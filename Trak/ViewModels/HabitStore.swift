// HabitStore.swift
import SwiftUI
import Combine
import AVFoundation
import WidgetKit

@MainActor
class HabitStore: ObservableObject {
    @Published var habits: [Habit] = [] {
        didSet {
            save()
            updateWidgets()
        }
    }

    private var activeAutoTimers: [UUID: DispatchWorkItem] = [:]

    init() {
        load()

    }
    
    // MARK: - Widget Güncelleme Fonksiyonu
    private func updateWidgets() {
        // Widget verilerini kaydet
        WidgetDataManager.shared.saveHabitsForWidget(habits)
        
        // Tüm widget'ları yenile
        WidgetCenter.shared.reloadAllTimelines()
        
        
    }
    
    private func save() {
        if let encoded = try? JSONEncoder().encode(habits) {
            UserDefaults.standard.set(encoded, forKey: "SavedHabits")
        }
    }
    private func playSound(_ soundID: SystemSoundID) {
        AudioServicesPlaySystemSound(soundID)
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: "SavedHabits") {
            if let decoded = try? JSONDecoder().decode([Habit].self, from: data) {
                habits = decoded
                
                checkAndResetHabits()
                updateWidgets()
                return
            }
        }
    }
    func checkAndResetExpiredHabits() {
        checkAndResetHabits()
    }

    /// Call this when the app returns to the foreground so sessions that elapsed
    /// while backgrounded are automatically completed.
    func checkAndAutoCompleteActiveTimers() {
        let now = Date()
        for habit in habits {
            guard let dailyGoal = habit.dailyGoal, dailyGoal.type == .duration else { continue }
            guard habit.hasActiveSession, let startTime = habit.activeSessionStartTime else { continue }
            let elapsed = now.timeIntervalSince(startTime)
            if elapsed >= Double(dailyGoal.target * 60) {
                stopTimerSession(habitId: habit.id)
            }
        }
    }

    
    private func checkAndResetHabits() {
        
        for index in habits.indices {
            habits[index].resetIfNeeded()
            updateStreak(for: habits[index].id)
        }
    }
   
    // MARK: - Habit Management
    func addHabit(_ habit: Habit) {
        habits.append(habit)
        if habit.reminderEnabled {
                NotificationManager.shared.scheduleNotifications(for: habit)
            }
        playSound(1026)
        
    }

    func deleteHabit(at offsets: IndexSet) {
        for index in offsets {
            let habit = habits[index]
            // Cancel notifications
            NotificationManager.shared.cancelNotifications(for: habit.id)
        }
        habits.remove(atOffsets: offsets)
    }
    func updateNotificationIdentifiers(habitId: UUID, identifiers: [String]) {
        guard let index = habits.firstIndex(where: { $0.id == habitId }) else { return }
        habits[index].notificationIdentifiers = identifiers
    }
    // ✅ GÜNCELLENMIŞ: Habit completion - timer sessions dahil
    func completeHabit(habitId: UUID, value: Int = 0, notes: String? = nil, forceComplete: Bool = false) {
        if let index = habits.firstIndex(where: { $0.id == habitId }) {
            let habit = habits[index]
            let now = Date()
            
            // Progress tracking için value hesaplama
            let completionValue: Int
            if value > 0 {
                completionValue = value
            } else {
                completionValue = habit.incrementValue
            }
            
            let isCorrectTime: Bool
            if forceComplete {
                isCorrectTime = false
            } else {
                isCorrectTime = habit.isCorrectTimeToComplete()
            }
            
          
            let completion = Habit.CompletionRecord(
                date: now,
                value: completionValue,
                isCorrectTime: isCorrectTime,
                notes: notes
            )
            
            habits[index].completions.append(completion)
            
            habits[index].lastCompleted = now
            
            updateStreak(for: habitId)
            
            if habits[index].isCompletedToday {
                playSound(1034)
            }
            
        }
    }

    func startTimerSession(habitId: UUID) {
        if let index = habits.firstIndex(where: { $0.id == habitId }) {
            let habit = habits[index]
            let now = Date()

            let sessionRecord = Habit.CompletionRecord(
                date: now,
                value: 0,
                isCorrectTime: habit.isCorrectTimeToComplete(),
                startTime: now,
                endTime: nil
            )

            habits[index].completions.append(sessionRecord)
            playSound(1054)

            // Schedule auto-completion when the target duration elapses
            if let target = habit.dailyGoal?.target, target > 0 {
                let workItem = DispatchWorkItem { [weak self] in
                    self?.stopTimerSession(habitId: habitId)
                }
                activeAutoTimers[habitId] = workItem
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(target * 60), execute: workItem)

                NotificationManager.shared.scheduleTimerCompletionNotification(for: habit, duration: target)
            }
        }
    }

    func stopTimerSession(habitId: UUID) {
        // Cancel the scheduled auto-completion if the user stopped manually
        if let workItem = activeAutoTimers[habitId] {
            workItem.cancel()
            activeAutoTimers.removeValue(forKey: habitId)
        }
        NotificationManager.shared.cancelTimerCompletionNotification(for: habitId)

        if let index = habits.firstIndex(where: { $0.id == habitId }) {
            let habit = habits[index]
            let now = Date()
            
            
            if let activeSessionIndex = habits[index].completions.lastIndex(where: { completion in
                completion.startTime != nil && completion.endTime == nil
            }) {
                let startTime = habits[index].completions[activeSessionIndex].startTime!
                let elapsed = Int(now.timeIntervalSince(startTime) / 60)
                let duration = min(elapsed, habit.dailyGoal?.target ?? elapsed)
                
                habits[index].completions[activeSessionIndex].endTime = now
                habits[index].completions[activeSessionIndex].value = duration
                habits[index].lastCompleted = now
               
                
                let progress = habits[index].todayProgress
                print("   Total progress: \(progress.current)/\(progress.target) min")
                
                updateStreak(for: habitId)
                playSound(1025)
               
            }
        }
    }
    
   
    private func updateStreak(for habitId: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == habitId }) else { return }
        
        let habit = habits[index]
        let calendar = Calendar.current
        
        var streak = 0
        var currentDate = calendar.startOfDay(for: Date())
        
        // Bugünden geriye doğru, arka arkaya kaç gün complete edilmiş sayalım
        while streak < 365 { // Maksimum 1 yıl
            let dayKey = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.string(from: currentDate)
            }()
            
            // Bu günde habit complete edilmiş mi?
            let isDayCompleted = isHabitCompletedOnDay(habit: habit, dayKey: dayKey)
            
            if isDayCompleted {
                streak += 1
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate) ?? currentDate
            } else {
                break // İlk complete olmayan günde dur
            }
        }
        
        habits[index].streak = streak
    }

    // Yardımcı fonksiyon - bir günde habit complete edilmiş mi?
    private func isHabitCompletedOnDay(habit: Habit, dayKey: String) -> Bool {
        let dayCompletions = habit.completions.filter { completion in
            completion.dayKey == dayKey
        }
        
        if dayCompletions.isEmpty {
            return false
        }
        
        // Daily goal varsa hedefine ulaştı mı kontrol et
        if let dailyGoal = habit.dailyGoal, dailyGoal.type != .single {
            let totalValue = dayCompletions.reduce(0) { $0 + $1.value }
            return totalValue >= dailyGoal.target
        } else {
            // Daily goal yoksa, herhangi bir completion varsa tamam
            return true
        }
    }
    
    func startTimer(for habitId: UUID) {
        // Timer logic buraya gelecek
        // Şimdilik placeholder
        print("Timer started for habit: \(habitId)")
    }
    
    func stopTimer(for habitId: UUID, duration: Int) {
        completeHabit(habitId: habitId, value: duration, notes: "Timer completed")
    }
    
    // MARK: - Template Helpers (Existing functions updated)
    
    
    // Map habit name to an SF Symbol icon name
    func getIconName(for habitName: String) -> String {
        let habitLower = habitName.lowercased()
        
        if habitLower.contains("brush") && habitLower.contains("teeth") { return "mouth" }
        if habitLower.contains("run") || habitLower.contains("jog") { return "figure.run" }
        if habitLower.contains("drink") && habitLower.contains("water") { return "drop.fill" }
        if habitLower.contains("read") || habitLower.contains("book") { return "book.fill" }
        if habitLower.contains("meditate") { return "figure.mind.and.body" }
        if habitLower.contains("exercise") || habitLower.contains("workout") { return "figure.cooldown" }
        if habitLower.contains("eat") && habitLower.contains("healthy") { return "leaf.fill" }
        if habitLower.contains("water") && habitLower.contains("plant") { return "sprinkler.and.droplets.fill" }
        if habitLower.contains("journal") { return "pencil.and.scribble"}
        if habitLower.contains("novel") { return "book.closed.fill"}
        if habitLower.contains("vitamin") { return "pills.fill"}
        if habitLower.contains("mobilise") || habitLower.contains("stretch") { return "figure.flexibility" }

        return "list.star"
    }
    
   
}
