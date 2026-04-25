//
//  HabitProgram.swift
//  Trak
//
//  Created by Ege Özçelik on 19.09.2025.
//

// HabitProgram.swift
import SwiftUI


// Ana program modeli
struct HabitProgram: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let detailedDescription: String
    let icon: String
    let color: Color
    let duration: Int // gün sayısı
    let habits: [ProgramHabit]
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, detailedDescription, icon, imageName
        case duration, habits, category, difficulty, tags
        case colorRed, colorGreen, colorBlue, colorOpacity
    }
    
    init(name: String, description: String, detailedDescription: String, icon: String, color: Color, duration: Int, habits: [ProgramHabit]) {
        self.name = name
        self.description = description
        self.detailedDescription = detailedDescription
        self.icon = icon
        self.color = color
        self.duration = duration
        self.habits = habits
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        detailedDescription = try container.decode(String.self, forKey: .detailedDescription)
        icon = try container.decode(String.self, forKey: .icon)
       
        duration = try container.decode(Int.self, forKey: .duration)
        habits = try container.decode([ProgramHabit].self, forKey: .habits)
        
       
  
        // Color'ı decode etme
        let red = try container.decode(Double.self, forKey: .colorRed)
        let green = try container.decode(Double.self, forKey: .colorGreen)
        let blue = try container.decode(Double.self, forKey: .colorBlue)
        let opacity = try container.decode(Double.self, forKey: .colorOpacity)
        color = Color(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(detailedDescription, forKey: .detailedDescription)
        try container.encode(icon, forKey: .icon)
        
        try container.encode(duration, forKey: .duration)
        try container.encode(habits, forKey: .habits)
        
        // Color'ı encode etme
        let uiColor = UIColor(color)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        try container.encode(Double(red), forKey: .colorRed)
        try container.encode(Double(green), forKey: .colorGreen)
        try container.encode(Double(blue), forKey: .colorBlue)
        try container.encode(Double(alpha), forKey: .colorOpacity)
    }
}


// Program içindeki habit modeli
struct ProgramHabit: Identifiable, Codable {
    let id = UUID()
    let name: String
    let description: String
    let frequency: Habit.FrequencyType
    let dailyGoal: Habit.DailyGoal?
    let customFrequency: (targetDays: Int, totalDays: Int)?
    let tips: [String]
    let benefits: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, frequency, dailyGoal, tips, benefits
        case customTargetDays, customTotalDays
    }
    
    init(name: String, description: String, frequency: Habit.FrequencyType, dailyGoal: Habit.DailyGoal? = nil, customFrequency: (targetDays: Int, totalDays: Int)? = nil, tips: [String] = [], benefits: String) {
        self.name = name
        self.description = description
        self.frequency = frequency
        self.dailyGoal = dailyGoal
        self.customFrequency = customFrequency
        self.tips = tips
        self.benefits = benefits
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        frequency = try container.decode(Habit.FrequencyType.self, forKey: .frequency)
        dailyGoal = try? container.decode(Habit.DailyGoal.self, forKey: .dailyGoal)
        tips = try container.decode([String].self, forKey: .tips)
        benefits = try container.decode(String.self, forKey: .benefits)
        
        // Custom frequency decode
        if let targetDays = try? container.decode(Int.self, forKey: .customTargetDays),
           let totalDays = try? container.decode(Int.self, forKey: .customTotalDays) {
            customFrequency = (targetDays: targetDays, totalDays: totalDays)
        } else {
            customFrequency = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(frequency, forKey: .frequency)
        try container.encodeIfPresent(dailyGoal, forKey: .dailyGoal)
        try container.encode(tips, forKey: .tips)
        try container.encode(benefits, forKey: .benefits)
        
        // Custom frequency encode
        if let customFreq = customFrequency {
            try container.encode(customFreq.targetDays, forKey: .customTargetDays)
            try container.encode(customFreq.totalDays, forKey: .customTotalDays)
        }
    }
    
    // ProgramHabit'i normal Habit'e dönüştürme
    func toHabit() -> Habit {
        var customFrequencyStruct: Habit.CustomFrequency? = nil
        if let customFreq = customFrequency {
            customFrequencyStruct = Habit.CustomFrequency(
                targetDays: customFreq.targetDays,
                totalDays: customFreq.totalDays,
                startDate: Date()
            )
        }
        
        return Habit(
            name: name,
            frequency: frequency,
            customFrequency: customFrequencyStruct,
            dailyGoal: dailyGoal
        )
    }
}
