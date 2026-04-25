//
//  WidgetSharedModels.swift
//  Trak
//
//  Created by Ege Özçelik on 29.09.2025.
//

// WidgetSharedModels.swift
// Bu dosyayı SADECE Widget Extension target'ına ekleyin (TrackieWidgets)
// Ana uygulama target'ına EKLEMEYIN

import Foundation

// MARK: - Shared Habit Model (Widget için basitleştirilmiş)
struct SharedHabit: Codable, Identifiable {
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

// MARK: - Shared Data Model
struct SharedHabitData: Codable {
    let habits: [SharedHabit]
    let completedCount: Int
    let totalCount: Int
    let lastUpdated: Date
}

// MARK: - Widget Data Manager (sadece okuma için)
class WidgetDataManager {
    static let shared = WidgetDataManager()
    
    private let appGroupID = "group.com.IndigoCats.Trackie.habitdata"
    private let habitsDataKey = "SharedHabitsData"
    
    private init() {}
    
    // Widget'tan veri okuma
    func loadHabitsData() -> SharedHabitData? {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            print("❌ Widget: App Group container bulunamadı")
            return nil
        }
        
        let fileURL = containerURL.appendingPathComponent("\(habitsDataKey).json")
        
        // Dosya yoksa sessizce nil dön (ilk açılış normal)
        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("ℹ️ Widget: İlk açılış - veri dosyası henüz oluşturulmamış")
            return nil
        }
        
        do {
            let data = try Data(contentsOf: fileURL)
            let sharedData = try JSONDecoder().decode(SharedHabitData.self, from: data)
            return sharedData
        } catch {
            print("❌ Widget: Veri decode hatası - \(error.localizedDescription)")
            return nil
        }
    }
    
    // Widget verisi var mı kontrol et
    func hasData() -> Bool {
        guard let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroupID) else {
            return false
        }
        
        let fileURL = containerURL.appendingPathComponent("\(habitsDataKey).json")
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
}
