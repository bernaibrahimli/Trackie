//
//  WidgetDataModels.swift
//  Trak
//
//  Created by Ege Özçelik on 29.09.2025.
//



import Foundation
import WidgetKit

// MARK: - Widget için Shared Habit Modeli
struct SharedHabit: Codable {
    let id: UUID
    let name: String
    let iconName: String
    let isCompleted: Bool
    let progressPercentage: Double
    let progressText: String
    let frequency: String
    let lastCompleted: Date?
    let streak: Int
}

// MARK: - Widget için Shared Data
struct SharedHabitData: Codable {
    let habits: [SharedHabit]
    let completedCount: Int
    let totalCount: Int
    let lastUpdated: Date
}

// MARK: - Widget Data Manager (Ana app'ten yazma için)
class WidgetDataManager {
    static let shared = WidgetDataManager()
    
    private let appGroupID = "group.com.IndigoCats.Trackie.habitdata"
    private let habitsDataKey = "SharedHabitsData"
    
    private init() {}
    
    // Widget'a veri yazma (ana app'ten)
    func saveHabitsForWidget(_ habits: [Habit]) {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            print("❌ App: App Group container bulunamadı")
            return
        }
        
        let fileURL = containerURL.appendingPathComponent("\(habitsDataKey).json")
        
        // Habit'leri SharedHabit'e çevir
        let sharedHabits = habits.map { habit -> SharedHabit in
            let isCompleted = isHabitCompletedToday(habit)
            let (progressPercentage, progressText) = getHabitProgress(habit)
            
            return SharedHabit(
                id: habit.id,
                name: habit.name,
                iconName: getIconName(for: habit),
                isCompleted: isCompleted,
                progressPercentage: progressPercentage,
                progressText: progressText,
                frequency: habit.frequency.rawValue,
                lastCompleted: habit.lastCompleted,
                streak: habit.streak
            )
        }
        
        let completedCount = sharedHabits.filter { $0.isCompleted }.count
        let totalCount = sharedHabits.count
        
        let sharedData = SharedHabitData(
            habits: sharedHabits,
            completedCount: completedCount,
            totalCount: totalCount,
            lastUpdated: Date()
        )
        
        do {
            let data = try JSONEncoder().encode(sharedData)
            try data.write(to: fileURL)
            
            // Widget'ı güncelle
            WidgetCenter.shared.reloadAllTimelines()
            
            
        } catch {
            print("❌ App: Widget verisi yazılamadı - \(error.localizedDescription)")
        }
    }
    
    // MARK: - Helper Functions
    
    private func isHabitCompletedToday(_ habit: Habit) -> Bool {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        // Bugünün completions'larını bul
        let todayCompletions = habit.completions.filter { completion in
            calendar.isDate(completion.date, inSameDayAs: today)
        }
        
        if todayCompletions.isEmpty {
            return false
        }
        
        // Daily goal varsa kontrol et
        if let dailyGoal = habit.dailyGoal, dailyGoal.type != .single {
            let totalValue = todayCompletions.reduce(0) { $0 + $1.value }
            return totalValue >= dailyGoal.target
        }
        
        // Daily goal yoksa, completion varsa tamamlanmış say
        return true
    }
    
    private func getHabitProgress(_ habit: Habit) -> (percentage: Double, text: String) {
        guard let dailyGoal = habit.dailyGoal else {
            return (0.0, "")
        }
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let todayCompletions = habit.completions.filter { completion in
            calendar.isDate(completion.date, inSameDayAs: today)
        }
        
        let totalValue = todayCompletions.reduce(0) { $0 + $1.value }
        
        // Tamamlanmış mı?
        if totalValue >= dailyGoal.target {
            return (1.0, "✓")
        }
        
        let percentage = min(Double(totalValue) / Double(dailyGoal.target), 1.0)
        
        // Progress text
        let progressText: String
        switch dailyGoal.type {
        case .single:
            progressText = ""
        case .count:
            progressText = "\(totalValue)/\(dailyGoal.target)"
        case .duration:
            progressText = "\(totalValue)/\(dailyGoal.target)"
        case .volume:
            progressText = "\(Int(percentage * 100))%"
        }
        
        return (percentage, progressText)
    }
    
    private func getIconName(for habit: Habit) -> String {
        // Habit ismine göre icon belirle
        let name = habit.name.lowercased()
        
        if name.contains("water") || name.contains("su") {
            return "drop.fill"
        } else if name.contains("read") || name.contains("book") || name.contains("oku") || name.contains("kitap") {
            return "book.fill"
        } else if name.contains("exercise") || name.contains("workout") || name.contains("spor") || name.contains("egzersiz") {
            return "figure.cooldown"
        } else if name.contains("meditate") || name.contains("meditasyon") || name.contains("yoga") {
            return "figure.mind.and.body"
        } else if name.contains("run") || name.contains("koş") {
            return "figure.run"
        } else if name.contains("walk") || name.contains("yürü") {
            return "figure.walk"
        } else if name.contains("sleep") || name.contains("uyku") {
            return "bed.double.fill"
        } else if name.contains("eat") || name.contains("meal") || name.contains("yemek") {
            return "fork.knife"
        } else if name.contains("vitamin") || name.contains("pill") || name.contains("ilaç") {
            return "pills.fill"
        } else if name.contains("teeth") || name.contains("brush") || name.contains("diş") {
            return "mouth"
        } else if name.contains("journal") || name.contains("write") || name.contains("günlük") {
            return "book.closed.fill"
        } else if name.contains("music") || name.contains("müzik") {
            return "music.note"
        } else if name.contains("study") || name.contains("learn") || name.contains("ders") || name.contains("çalış") {
            return "book.pages.fill"
        } else if name.contains("clean") || name.contains("temiz") {
            return "sparkles"
        } else if name.contains("prayer") || name.contains("namaz") {
            return "moon.stars.fill"
        } else {
            return "star.fill"
        }
    }
}
