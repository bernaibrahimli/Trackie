// AIManager.swift
import Foundation
import SwiftUI

/// Handles all AI-powered parsing for the Magic Add feature.
/// Currently uses a mock implementation. Swap `parseHabitPrompt` body
/// with a real Gemini / OpenAI network call when ready.
final class AIManager {

    // MARK: - System Prompt

    /// Paste this verbatim as the `system` message when calling the LLM.
    static let systemPrompt = """
    You are a habit-building assistant embedded in a mobile app. \
    Your sole job is to parse a user's natural-language habit description \
    into a strict JSON object. Output ONLY valid JSON — no markdown, \
    no code blocks, no explanation, no trailing text.

    ── OUTPUT SCHEMA ────────────────────────────────────────────────────────
    {
      "name": string,                // Short habit name, max 25 characters
      "frequency": string,           // Exactly one of: "daily" | "morning" | "evening" | "custom"
      "customFrequency": {           // Present only when frequency == "custom", else null
        "targetDays": number,        // Days to complete within the period  (e.g. 3)
        "totalDays":  number,        // Length of the period in days        (e.g. 7)
        "isRecurring": boolean       // true  = repeat the cycle indefinitely
                                     // false = one fixed period, then done
      } | null,
      "dailyGoal": {                 // null when habit needs no measurement (e.g. "take vitamins")
        "type":      string,         // Exactly one of: "count" | "duration"
        "target":    number,         // e.g. 8 for 8 glasses, 30 for 30 minutes
        "increment": number,         // Always 1
        "unit":      string          // e.g. "glasses", "times", "pages", "min"
      } | null,
      "reminderEnabled": boolean,
      "reminderHour":   number | null,   // 24-hour clock (0–23), null if no reminder
      "reminderMinute": number | null    // 0–59, null if no reminder
    }

    ── RULES ────────────────────────────────────────────────────────────────
    Frequency:
    • Use "morning" only when the user says "morning", "wake up", or similar AM cues
      AND there is no count/duration goal.
    • Use "evening" only when the user says "evening", "night", "before bed", or
      similar PM cues AND there is no count/duration goal.
    • Use "daily"  for every-day habits that don't fit morning/evening.
    • Use "custom" for anything not every day (e.g. "3 times a week",
      "every other day", "5 out of 7 days").
    • When frequency is "custom", default isRecurring to true UNLESS the user
      explicitly says "for the next X days" or a clearly one-time timeframe.

    Reminders:
    • Set reminderEnabled: true whenever the user says "remind me", "notification",
      "alert", or specifies a time ("at 9 AM", "at 7:30").
    • If the user enables a reminder but gives no time, infer a sensible default
      (e.g. 8:00 for morning habits, 20:00 for evening habits, 9:00 otherwise).
    • Parse 12-hour times correctly: "9 AM" → hour 9, "9 PM" → hour 21.

    Goals:
    • Use "count" for discrete repetitions: glasses of water, push-ups, pages, pills.
    • Use "duration" for timed activities: run, meditate, read (when in minutes).
    • Set dailyGoal to null for simple once-per-day habits with no measurement.

    Naming:
    • Keep the name short, natural, and title-case (e.g. "Drink water", "Morning run").
    • Strip filler phrases like "I want to", "Help me", "Remind me to".

    ── EXAMPLES ─────────────────────────────────────────────────────────────
    Input:  "Drink 8 glasses of water every day and remind me at 9 AM"
    Output: {"name":"Drink water","frequency":"daily","customFrequency":null,"dailyGoal":{"type":"count","target":8,"increment":1,"unit":"glasses"},"reminderEnabled":true,"reminderHour":9,"reminderMinute":0}

    Input:  "Go for a 30 minute run 5 times a week"
    Output: {"name":"Go for a run","frequency":"custom","customFrequency":{"targetDays":5,"totalDays":7,"isRecurring":true},"dailyGoal":{"type":"duration","target":30,"increment":1,"unit":"min"},"reminderEnabled":false,"reminderHour":null,"reminderMinute":null}

    Input:  "Meditate every morning for 10 minutes"
    Output: {"name":"Meditate","frequency":"morning","customFrequency":null,"dailyGoal":{"type":"duration","target":10,"increment":1,"unit":"min"},"reminderEnabled":false,"reminderHour":null,"reminderMinute":null}

    Input:  "Read 20 pages before bed each night"
    Output: {"name":"Read","frequency":"evening","customFrequency":null,"dailyGoal":{"type":"count","target":20,"increment":1,"unit":"pages"},"reminderEnabled":false,"reminderHour":null,"reminderMinute":null}

    Input:  "Exercise 4 times a week for 45 minutes, remind me at 7 AM"
    Output: {"name":"Exercise","frequency":"custom","customFrequency":{"targetDays":4,"totalDays":7,"isRecurring":true},"dailyGoal":{"type":"duration","target":45,"increment":1,"unit":"min"},"reminderEnabled":true,"reminderHour":7,"reminderMinute":0}
    """

    // MARK: - JSON Response Model

    /// Mirrors the schema above — decode the LLM's raw JSON string into this.
    struct HabitResponse: Decodable {
        let name: String
        let frequency: String
        let customFrequency: CustomFrequencyResponse?
        let dailyGoal: DailyGoalResponse?
        let reminderEnabled: Bool
        let reminderHour: Int?
        let reminderMinute: Int?

        struct CustomFrequencyResponse: Decodable {
            let targetDays: Int
            let totalDays: Int
            let isRecurring: Bool
        }

        struct DailyGoalResponse: Decodable {
            let type: String
            let target: Int
            let increment: Int
            let unit: String
        }
    }

    // MARK: - HabitResponse → Habit

    /// Converts a decoded LLM response into a `Habit` ready to populate the form.
    static func habit(from response: HabitResponse) -> Habit? {
        guard !response.name.trimmingCharacters(in: .whitespaces).isEmpty else { return nil }

        let frequency: Habit.FrequencyType
        switch response.frequency {
        case "morning": frequency = .morning
        case "evening": frequency = .evening
        case "custom":  frequency = .custom
        default:        frequency = .daily
        }

        let customFrequency: Habit.CustomFrequency?
        if let cf = response.customFrequency, frequency == .custom {
            customFrequency = Habit.CustomFrequency(
                targetDays: max(1, cf.targetDays),
                totalDays:  max(cf.targetDays, cf.totalDays),
                startDate:  Date(),
                isRecurring: cf.isRecurring
            )
        } else {
            customFrequency = nil
        }

        let dailyGoal: Habit.DailyGoal?
        if let dg = response.dailyGoal {
            let goalType: Habit.DailyGoal.GoalType = dg.type == "duration" ? .duration : .count
            dailyGoal = Habit.DailyGoal(
                type: goalType,
                target: max(1, dg.target),
                increment: max(1, dg.increment),
                unit: dg.unit
            )
        } else {
            dailyGoal = nil
        }

        var reminderTime: Date? = nil
        if response.reminderEnabled,
           let hour = response.reminderHour,
           let minute = response.reminderMinute {
            reminderTime = Self.makeTime(hour: hour, minute: minute)
        }

        return Habit(
            name:            String(response.name.prefix(25)),
            frequency:       frequency,
            customFrequency: customFrequency,
            dailyGoal:       dailyGoal,
            reminderEnabled: response.reminderEnabled,
            reminderTime:    reminderTime
        )
    }

    // MARK: - API Implementation

    static func parseHabitPrompt(text: String) async -> Habit? {
        let url = URL(string: "https://trackie-9jt0.onrender.com/parse-habit")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["text": text])

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            // Check for backend error response before decoding
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errMsg = json["error"] as? String {
                print("AIManager: backend error – \(errMsg)")
                return nil
            }
            let response = try JSONDecoder().decode(HabitResponse.self, from: data)
            return habit(from: response)
        } catch {
            print("AIManager error: \(error)")
            return nil
        }
    }

    // MARK: - Program Generation

    struct ProgramResponse: Decodable {
        let name: String
        let description: String
        let detailedDescription: String
        let icon: String
        let colorHex: String
        let duration: Int
        let habits: [ProgramHabitResponse]

        struct ProgramHabitResponse: Decodable {
            let name: String
            let description: String
            let frequency: String
            let customTargetDays: Int?
            let customTotalDays: Int?
            let dailyGoalType: String?
            let dailyGoalTarget: Int?
            let dailyGoalUnit: String?
            let benefits: String
        }
    }

    static func generateProgram(goal: String) async -> HabitProgram? {
        let url = URL(string: "https://trackie-9jt0.onrender.com/generate-program")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["goal": goal])

        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let errMsg = json["error"] as? String {
                print("AIManager: backend error – \(errMsg)")
                return nil
            }
            let response = try JSONDecoder().decode(ProgramResponse.self, from: data)
            return habitProgram(from: response)
        } catch {
            print("AIManager generateProgram error: \(error)")
            return nil
        }
    }

    static func habitProgram(from response: ProgramResponse) -> HabitProgram {
        let habits = response.habits.map { programHabit(from: $0) }
        let color = Color(hex: response.colorHex) ?? AppStyles.Colors.primary
        return HabitProgram(
            name: String(response.name.prefix(30)),
            description: response.description,
            detailedDescription: response.detailedDescription,
            icon: response.icon,
            color: color,
            duration: response.duration,
            habits: habits
        )
    }

    private static func programHabit(from r: ProgramResponse.ProgramHabitResponse) -> ProgramHabit {
        let freq: Habit.FrequencyType
        switch r.frequency {
        case "morning": freq = .morning
        case "evening": freq = .evening
        case "custom":  freq = .custom
        default:        freq = .daily
        }

        let customFrequency: (targetDays: Int, totalDays: Int)?
        if freq == .custom, let t = r.customTargetDays, let total = r.customTotalDays {
            customFrequency = (targetDays: max(1, t), totalDays: max(t, total))
        } else {
            customFrequency = nil
        }

        let dailyGoal: Habit.DailyGoal?
        if let type = r.dailyGoalType, let target = r.dailyGoalTarget, let unit = r.dailyGoalUnit {
            let goalType: Habit.DailyGoal.GoalType = type == "duration" ? .duration : .count
            dailyGoal = Habit.DailyGoal(type: goalType, target: max(1, target), increment: 1, unit: unit)
        } else {
            dailyGoal = nil
        }

        return ProgramHabit(
            name: String(r.name.prefix(25)),
            description: r.description,
            frequency: freq,
            dailyGoal: dailyGoal,
            customFrequency: customFrequency,
            tips: [],
            benefits: r.benefits
        )
    }

    // MARK: - Private Helpers

    private static func makeTime(hour: Int, minute: Int) -> Date {
        var components        = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        components.hour       = hour
        components.minute     = minute
        components.second     = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    /// Scans for patterns like "9 AM", "9am", "9PM", "21:00", "7:30 AM".
    private static func extractHour(from text: String) -> Int? {
        let words = text.components(separatedBy: .whitespaces)
        for (i, raw) in words.enumerated() {
            let word = raw.trimmingCharacters(in: .punctuationCharacters).lowercased()

            // Combined tokens: "9am", "7pm", "9:30am"
            if word.hasSuffix("am") || word.hasSuffix("pm") {
                let isPM  = word.hasSuffix("pm")
                let body  = String(word.dropLast(2))
                let parts = body.components(separatedBy: ":")
                if let hour = Int(parts[0]) {
                    return isPM ? (hour < 12 ? hour + 12 : hour)
                                : (hour == 12 ? 0 : hour)
                }
            }

            // Separate tokens: "9 AM", "21 :00"
            if word == "am" || word == "pm" {
                if i > 0 {
                    let prev  = words[i - 1].trimmingCharacters(in: .punctuationCharacters)
                    let parts = prev.components(separatedBy: ":")
                    if let hour = Int(parts[0]) {
                        let isPM = word == "pm"
                        return isPM ? (hour < 12 ? hour + 12 : hour)
                                    : (hour == 12 ? 0 : hour)
                    }
                }
            }

            // 24-hour "HH:MM" token (no am/pm suffix)
            if word.contains(":") {
                let parts = word.components(separatedBy: ":")
                if parts.count == 2, let hour = Int(parts[0]), let _ = Int(parts[1]), hour < 24 {
                    return hour
                }
            }
        }
        return nil
    }

    /// Finds a number adjacent to any of the given keyword prefixes.
    private static func extractNumber(from text: String, near keywords: [String]) -> Int? {
        let words = text.components(separatedBy: .whitespaces)
        for keyword in keywords {
            for (i, word) in words.enumerated() {
                guard word.lowercased().hasPrefix(keyword) else { continue }
                if i > 0, let n = Int(words[i - 1]), n > 0 { return n }
                if i < words.count - 1, let n = Int(words[i + 1]), n > 0 { return n }
            }
        }
        // Fallback: first standalone number in the string
        for word in words {
            let clean = word.trimmingCharacters(in: .punctuationCharacters)
            if let n = Int(clean), n > 0, n < 1000 { return n }
        }
        return nil
    }

    /// Strips filler phrases and returns the first ~4 words as a habit name.
    private static func extractHabitName(from text: String) -> String {
        var result = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let prefixes = ["i want to ", "i'd like to ", "i would like to ",
                        "help me ", "remind me to ", "i should ", "let me "]
        for prefix in prefixes {
            if result.lowercased().hasPrefix(prefix) {
                result = String(result.dropFirst(prefix.count))
                break
            }
        }
        let name = result
            .components(separatedBy: .whitespaces)
            .prefix(4)
            .joined(separator: " ")
        let trimmed = String(name.prefix(25))
        return trimmed.prefix(1).uppercased() + trimmed.dropFirst()
    }
}
