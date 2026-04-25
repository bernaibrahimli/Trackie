// Habit.swift
import Foundation

// Model for a habit
struct Habit: Identifiable, Codable {
    var id = UUID()
    var name: String
    var frequency: FrequencyType
    var lastCompleted: Date?
    var streak: Int = 0
    var createdAt = Date()
    
    
    var customFrequency: CustomFrequency?
    var dailyGoal: DailyGoal?
    var completions: [CompletionRecord] = []
    
    var reminderEnabled: Bool = false
    var reminderTime: Date?
    var notificationIdentifiers: [String] = [] 
    
    enum FrequencyType: String, Codable, CaseIterable {
        case morning = "Morning"
        case evening = "Evening"
        case daily = "Daily"
        case custom = "Custom"
    }
    
    struct CustomFrequency: Codable {
        var targetDays: Int
        var totalDays: Int
        var startDate: Date
        var isRecurring: Bool = false

        /// For recurring habits, returns the start of whichever cycle we're currently in.
        /// For one-time habits, always returns the original startDate.
        var currentPeriodStart: Date {
            guard isRecurring else { return startDate }
            let cal = Calendar.current
            let origin = cal.startOfDay(for: startDate)
            let today  = cal.startOfDay(for: Date())
            let elapsed = cal.dateComponents([.day], from: origin, to: today).day ?? 0
            guard elapsed >= 0 else { return startDate }
            let cycleIndex = elapsed / totalDays
            return cal.date(byAdding: .day, value: cycleIndex * totalDays, to: origin) ?? startDate
        }

        var endDate: Date {
            Calendar.current.date(byAdding: .day, value: totalDays - 1, to: currentPeriodStart) ?? currentPeriodStart
        }

        var isActive: Bool {
            if isRecurring { return true }
            let now = Date()
            return now >= startDate && now <= endDate
        }

        var remainingDays: Int {
            let now = Date()
            let remaining = Calendar.current.dateComponents([.day], from: now, to: endDate).day ?? 0
            return max(0, remaining)
        }
    }
    
    struct DailyGoal: Codable {
        var type: GoalType
        var target: Int
        var increment: Int
        var unit: String
        
        enum GoalType: String, Codable, CaseIterable {
            case single = "single"
            case count = "count"
            case duration = "duration"
            case volume = "volume"
        }
    }
    
    struct CompletionRecord: Codable, Identifiable {
        var id = UUID()
        var date: Date
        var value: Int
        var isCorrectTime: Bool
        var notes: String?
        
        // Timer sessions için
        var startTime: Date?
        var endTime: Date?
        
        var dayKey: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            return formatter.string(from: date)
        }
    }
    
    enum CompletionStatus {
        case notCompleted
        case completedOnTime
        case completedLate
    }
    
    var todayCompletionStatus: CompletionStatus {
        let today = Calendar.current.startOfDay(for: Date())
        let todayCompletions = completions.filter { completion in
            let completionDay = Calendar.current.startOfDay(for: completion.date)
            return completionDay == today
        }
        
        if todayCompletions.isEmpty {
            return .notCompleted
        }
        
        // Daily goal varsa ve henüz tamamlanmamışsa
        if let dailyGoal = dailyGoal, dailyGoal.type != .single {
            let progress = todayProgress
            if progress.current < progress.target {
                return .notCompleted // Henüz hedefine ulaşmadı
            }
        }
        
        // Hedefine ulaştı, zaman kontrolü yap
        let allCorrectTime = todayCompletions.allSatisfy { $0.isCorrectTime }
        return allCorrectTime ? .completedOnTime : .completedLate
    }
    
    var shouldCompleteToday: Bool {
        if todayCompletionStatus != .notCompleted {
            return false
        }
        
        switch frequency {
        case .morning:
            return shouldCompleteInMorning
        case .evening:
            return shouldCompleteInEvening
        case .daily:
            return !isCompletedToday
        case .custom:
            return shouldCompleteInCustomFrequency
        }
    }
    
    private var shouldCompleteInMorning: Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let isMorningTime = hour >= 6 && hour < 12
        return isMorningTime && !isCompletedToday
    }
    
    private var shouldCompleteInEvening: Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        let isEveningTime = hour >= 18
        return isEveningTime && !isCompletedToday
    }
    
    private var shouldCompleteInCustomFrequency: Bool {
        guard let customFreq = customFrequency else { return false }
        guard customFreq.isActive else { return false }
        let completedDaysInPeriod = getCompletedDaysInCurrentPeriod()
        return completedDaysInPeriod < customFreq.targetDays
    }
    
    var isCompletedToday: Bool {
        let status = todayCompletionStatus
        let result = status != .notCompleted
        return result
    }
    
    var canBeTappedToday: Bool {
        return todayCompletionStatus == .notCompleted
    }
    
    var todayProgress: (current: Int, target: Int) {
        guard let dailyGoal = dailyGoal else { return (1, 1) }
        
        let today = Calendar.current.startOfDay(for: Date())
        let todayCompletions = completions.filter { completion in
            let completionDay = Calendar.current.startOfDay(for: completion.date)
            return completionDay == today
        }
        
        let totalValue = todayCompletions.reduce(0) { $0 + $1.value }
        return (totalValue, dailyGoal.target)
    }
    
    // Progress yüzdesi hesaplama (0.0 - 1.0 arası)
    var todayProgressPercentage: Double {
        guard let dailyGoal = dailyGoal, dailyGoal.type != .single else {
            return isCompletedToday ? 1.0 : 0.0
        }
        
        let progress = todayProgress
        guard progress.target > 0 else { return 0.0 }
        
        let percentage = Double(progress.current) / Double(progress.target)
        return min(percentage, 1.0)
    }
    
   
    var progressDisplayText: String {
        guard let dailyGoal = dailyGoal else { return "" }
        
        switch dailyGoal.type {
        case .single:
            return ""
        case .count:
            let progress = todayProgress
            return "\(progress.current)/\(progress.target)"
        case .volume:
            if dailyGoal.unit == "%" {
                let progress = todayProgress
                let percentage = Int(todayProgressPercentage * 100)
                return "\(percentage)%"
            } else {
                let percentage = Int(todayProgressPercentage * 100)
                return "\(percentage)%"
            }
        case .duration:
            let progress = todayProgress
            return "\(progress.current)/\(progress.target) min"
        }
    }
    
    // Progress tracking için increment value
    var incrementValue: Int {
        return dailyGoal?.increment ?? 1
    }
    
    // Daily goal'a sahip mi kontrolü (timer dahil)
    var hasProgressTracking: Bool {
        guard let dailyGoal = dailyGoal else { return false }
        return dailyGoal.type == .count || dailyGoal.type == .volume || dailyGoal.type == .duration
    }
    
    // Active timer session kontrolü
    var hasActiveSession: Bool {
        guard let dailyGoal = dailyGoal, dailyGoal.type == .duration else { return false }
        
        let today = Calendar.current.startOfDay(for: Date())
        return completions.contains { completion in
            let completionDay = Calendar.current.startOfDay(for: completion.date)
            return completionDay == today &&
                   completion.startTime != nil &&
                   completion.endTime == nil
        }
    }
    
    // Active session'ın başlama zamanı
    var activeSessionStartTime: Date? {
        guard hasActiveSession else { return nil }
        
        let today = Calendar.current.startOfDay(for: Date())
        let activeSession = completions.first { completion in
            let completionDay = Calendar.current.startOfDay(for: completion.date)
            return completionDay == today &&
                   completion.startTime != nil &&
                   completion.endTime == nil
        }
        
        return activeSession?.startTime
    }
    
    func getCompletedDaysInCurrentPeriod() -> Int {
        guard let customFreq = customFrequency else { return 0 }

        let startDate = Calendar.current.startOfDay(for: customFreq.currentPeriodStart)
        let endDate = Calendar.current.startOfDay(for: customFreq.endDate)
        
        let periodicCompletions = completions.filter { completion in
            let completionDay = Calendar.current.startOfDay(for: completion.date)
            return completionDay >= startDate && completionDay <= endDate
        }
        
        // Günleri grupla ve her gün için hedefine ulaşıp ulaşmadığını kontrol et
        let groupedByDay = Dictionary(grouping: periodicCompletions) { completion in
            completion.dayKey
        }
        
        var completedDaysCount = 0
        
        for (_, dayCompletions) in groupedByDay {
            // Bu gün için toplam değer hesapla
            let totalValue = dayCompletions.reduce(0) { $0 + $1.value }
            
            // Daily goal varsa hedefine ulaştı mı kontrol et
            if let dailyGoal = dailyGoal, dailyGoal.type != .single {
                if totalValue >= dailyGoal.target {
                    completedDaysCount += 1
                }
            } else {
                // Daily goal yoksa, herhangi bir completion varsa tamamlanmış say
                completedDaysCount += 1
            }
        }
        
        return completedDaysCount
    }
    
    func isCorrectTimeToComplete() -> Bool {
        let now = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: now)
        
        switch frequency {
        case .morning:
            return hour >= 6 && hour < 12
        case .evening:
            return hour >= 18
        case .daily, .custom:
            return true
        }
    }
}

extension Habit {
    
    var shouldReset: Bool {
        guard let lastCompleted = lastCompleted else { return false }
        
        let calendar = Calendar.current
        let now = Date()
        
        switch frequency {
        case .daily, .morning, .evening:
            // Günlük habitler: farklı günde ise resetle
            return !calendar.isDate(lastCompleted, inSameDayAs: now)
            
        case .custom:
            guard let customFreq = customFrequency else { return false }
            
            // Custom habit: toplam gün kadar süre geçtiyse resetle
            let daysPassed = calendar.dateComponents([.day], from: lastCompleted, to: now).day ?? 0
            return daysPassed >= customFreq.totalDays
        }
    }
    
    // Reset işlemi - sadece lastCompleted'ı sıfırla
    mutating func resetIfNeeded() {
        if shouldReset {
            print("🔄 Resetting habit: \(name)")
            lastCompleted = nil
        }
    }
}

