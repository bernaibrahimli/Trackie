//
//  NotificationManager.swift
//  Trak
//
//  Created by Ege Özçelik on 18.10.2025.
//

import Foundation
import UserNotifications

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func scheduleNotifications(for habit: Habit) {
        guard habit.reminderEnabled,
              let reminderTime = habit.reminderTime else { return }
        
        // Cancel existing notifications
        cancelNotifications(for: habit.id)
        
        var identifiers: [String] = []
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: reminderTime)
        
        switch habit.frequency {
        case .daily:
            identifiers.append(scheduleDailyNotification(habit: habit, components: components))
            
        case .morning, .evening:
            identifiers.append(scheduleDailyNotification(habit: habit, components: components))
            
        case .custom:
            if let customFreq = habit.customFrequency {
                if customFreq.totalDays == 1 {
                    // One-time notification
                    identifiers.append(scheduleOneTimeNotification(habit: habit, date: customFreq.startDate, components: components))
                } else {
                    // Schedule for target days within total days
                    identifiers = scheduleCustomIntervalNotifications(habit: habit, customFreq: customFreq, components: components)
                }
            }
        }
        
        // Update habit with notification identifiers
        HabitStore().updateNotificationIdentifiers(habitId: habit.id, identifiers: identifiers)
    }
    
    private func scheduleDailyNotification(habit: Habit, components: DateComponents) -> String {
        let content = UNMutableNotificationContent()
        content.title = "Time for \(habit.name)!"
        content.body = "Don't forget to complete your habit today."
        content.sound = .default
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        return identifier
    }
    
    private func scheduleOneTimeNotification(habit: Habit, date: Date, components: DateComponents) -> String {
        let content = UNMutableNotificationContent()
        content.title = "Time for \(habit.name)!"
        content.body = "Complete your habit!"
        content.sound = .default
        
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        dateComponents.hour = components.hour
        dateComponents.minute = components.minute
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let identifier = UUID().uuidString
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        return identifier
    }
    
    private func scheduleCustomIntervalNotifications(habit: Habit, customFreq: Habit.CustomFrequency, components: DateComponents) -> [String] {
        var identifiers: [String] = []
        let calendar = Calendar.current
        let interval = customFreq.totalDays / customFreq.targetDays
        
        for day in stride(from: 0, to: customFreq.totalDays, by: max(1, interval)) {
            guard let notificationDate = calendar.date(byAdding: .day, value: day, to: customFreq.startDate),
                  notificationDate <= customFreq.endDate else { continue }
            
            var dateComponents = calendar.dateComponents([.year, .month, .day], from: notificationDate)
            dateComponents.hour = components.hour
            dateComponents.minute = components.minute
            
            let content = UNMutableNotificationContent()
            content.title = "Time for \(habit.name)!"
            content.body = "Complete your habit!"
            content.sound = .default
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let identifier = UUID().uuidString
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
            identifiers.append(identifier)
        }
        
        return identifiers
    }
    
    func cancelNotifications(for habitId: UUID) {
        if let habit = HabitStore().habits.first(where: { $0.id == habitId }) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: habit.notificationIdentifiers)
        }
    }
}
