// CalendarView.swift
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var habitStore: HabitStore
    @State private var selectedDate = Date()
    @State private var currentMonth = Date()
    @State private var selectedHabit: Habit?
    
    private let calendar = Calendar.current

    private func canGoPreviousMonth() -> Bool {
        guard let previousMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) else {
            return false
        }
        let oneMonthBeforeToday = calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date()
        return calendar.compare(previousMonth, to: oneMonthBeforeToday, toGranularity: .month) != .orderedAscending
    }

    private func canGoNextMonth() -> Bool {
        guard let nextMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) else {
            return false
        }
        let oneMonthAfterToday = calendar.date(byAdding: .month, value: 1, to: Date()) ?? Date()
        return calendar.compare(nextMonth, to: oneMonthAfterToday, toGranularity: .month) != .orderedDescending
    }
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                monthNavigationBar
                
                calendarGrid
                
                Divider()
                
                // Habits for selected date
                selectedDateHabits
            }
            .background(AppStyles.Colors.background.edgesIgnoringSafeArea(.all))
            .navigationTitle("Calendar")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Today") {
                        withAnimation {
                            selectedDate = Date()
                            currentMonth = Date()
                        }
                    }
                    .font(.headline)
                    .foregroundColor(AppStyles.Colors.primary)
                }
            }
        }
    }
    
    // MARK: - Month Navigation Bar
    private var monthNavigationBar: some View {
        HStack {
            Button {
                withAnimation {
                    if let newMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth),
                       calendar.compare(newMonth, to: calendar.date(byAdding: .month, value: -1, to: Date()) ?? Date(), toGranularity: .month) != .orderedAscending {
                        currentMonth = newMonth
                    }
                }
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3)
                    .foregroundColor(canGoPreviousMonth() ? AppStyles.Colors.primary : AppStyles.Colors.secondaryText)
            }
            .disabled(!canGoPreviousMonth())
            
            Spacer()
            
            Text(currentMonth, format: .dateTime.month(.wide).year())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(AppStyles.Colors.text)
            
            Spacer()
            
            Button {
                withAnimation {
                    if let newMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth),
                       calendar.compare(newMonth, to: calendar.date(byAdding: .month, value: 1, to: Date()) ?? Date(), toGranularity: .month) != .orderedDescending {
                        currentMonth = newMonth
                    }
                }
            } label: {
                Image(systemName: "chevron.right")
                    .font(.title3)
                    .foregroundColor(canGoNextMonth() ? AppStyles.Colors.primary : AppStyles.Colors.secondaryText)
            }
            .disabled(!canGoNextMonth())
        }
        .padding()
        .background(AppStyles.Colors.secondaryBackground)
    }
    
    // MARK: - Calendar Grid
    private var calendarGrid: some View {
        VStack(spacing: 0) {
            // Weekday headers
            HStack(spacing: 0) {
                ForEach(calendar.shortWeekdaySymbols, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 8)
            
            // Calendar days
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 0) {
                ForEach(getDaysInMonth(), id: \.self) { date in
                    CalendarDayCell(
                        date: date,
                        isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                        isToday: calendar.isDateInToday(date),
                        isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month),
                        habitCount: getHabitCount(for: date),
                        completedCount: getCompletedCount(for: date),
                        hasIncompleteHabits: hasIncompleteHabits(for: date)
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            selectedDate = date
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Selected Date Habits
    private var selectedDateHabits: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                let habitsForDate = getHabitsForDay(selectedDate)
                if habitsForDate.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle")
                            .font(.system(size: 40))
                            .foregroundColor(AppStyles.Colors.secondaryText)
                        
                        Text("No habits scheduled")
                            .font(.headline)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                        
                        Text("Enjoy your free time!")
                            .font(.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 40)
                } else {
                    ForEach(habitsForDate) { habit in
                        CalendarHabitRow(
                            habit: habit,
                            date: selectedDate,
                            isCompleted: isHabitCompleted(habit: habit, on: selectedDate)
                        ) {
                            selectedHabit = habit
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Helper Functions
    
    private func getDaysInMonth() -> [Date] {
        guard let interval = calendar.dateInterval(of: .month, for: currentMonth) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        let firstDayOfWeek = calendar.firstWeekday
        
        var days: [Date] = []
        
        // Add days from previous month to fill the first week
        let daysFromPreviousMonth = (firstWeekday - firstDayOfWeek + 7) % 7
        if daysFromPreviousMonth > 0,
           let startOfPreviousMonth = calendar.date(byAdding: .month, value: -1, to: interval.start),
           let previousMonthRange = calendar.range(of: .day, in: .month, for: startOfPreviousMonth) {
            let previousMonthDays = previousMonthRange.count
            let startDay = previousMonthDays - daysFromPreviousMonth + 1
            if startDay <= previousMonthDays {
                for day in startDay...previousMonthDays {
                    if let date = calendar.date(bySetting: .day, value: day, of: startOfPreviousMonth) {
                        days.append(date)
                    }
                }
            }
        }
        
        // Add days from current month
        if let daysInMonthRange = calendar.range(of: .day, in: .month, for: currentMonth) {
            for day in daysInMonthRange {
                if let date = calendar.date(bySetting: .day, value: day, of: interval.start) {
                    days.append(date)
                }
            }
        }
        
        // Add days from next month to complete the grid
        let remainingDays = 42 - days.count // 6 rows * 7 days
        if remainingDays > 0,
           let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: interval.start) {
            for day in 1...remainingDays {
                if let date = calendar.date(bySetting: .day, value: day, of: startOfNextMonth) {
                    days.append(date)
                }
            }
        }
        
        return days
    }
    
    private func getHabitsForDay(_ date: Date) -> [Habit] {
        let dayStart = calendar.startOfDay(for: date)
        
        return habitStore.habits.filter { habit in
            switch habit.frequency {
            case .daily, .morning, .evening:
                return dayStart >= calendar.startOfDay(for: habit.createdAt)
                
            case .custom:
                guard let customFreq = habit.customFrequency else { return false }
                let startDate = calendar.startOfDay(for: customFreq.startDate)
                let endDate = calendar.startOfDay(for: customFreq.endDate)
                return dayStart >= startDate && dayStart <= endDate
            }
        }
    }
    
    private func getHabitCount(for date: Date) -> Int {
        return getHabitsForDay(date).count
    }
    
    private func getCompletedCount(for date: Date) -> Int {
        return getHabitsForDay(date).filter { isHabitCompleted(habit: $0, on: date) }.count
    }
    
    private func hasIncompleteHabits(for date: Date) -> Bool {
        let habits = getHabitsForDay(date)
        let now = Date()
        let isPastDate = date < calendar.startOfDay(for: now)
        
        return habits.contains { habit in
            !isHabitCompleted(habit: habit, on: date) && isPastDate
        }
    }
    
    private func isHabitCompleted(habit: Habit, on date: Date) -> Bool {
        let dayStart = calendar.startOfDay(for: date)
        
        let dayCompletions = habit.completions.filter { completion in
            let completionDay = calendar.startOfDay(for: completion.date)
            return completionDay == dayStart
        }
        
        if dayCompletions.isEmpty {
            return false
        }
        
        if let dailyGoal = habit.dailyGoal, dailyGoal.type != .single {
            let totalValue = dayCompletions.reduce(0) { $0 + $1.value }
            return totalValue >= dailyGoal.target
        }
        
        return true
    }
}

// MARK: - Calendar Day Cell
struct CalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let isCurrentMonth: Bool
    let habitCount: Int
    let completedCount: Int
    let hasIncompleteHabits: Bool
    let action: () -> Void
    private var isPastDate: Bool {
        date < Calendar.current.startOfDay(for: Date())
    }
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Text("\(Calendar.current.component(.day, from: date))")
                    .font(.system(size: 16, weight: isToday ? .bold : .regular))
                    .foregroundColor(
                        isSelected ? .white :
                        isToday ? AppStyles.Colors.primary :
                        isCurrentMonth ? AppStyles.Colors.text : AppStyles.Colors.secondaryText
                    )
                
                if !isPastDate && habitCount > 0 {
                    HStack(spacing: 2) {
                        ForEach(0..<min(habitCount, 3), id: \.self) { index in
                            Circle()
                                .fill(
                                    isSelected ? Color.white :
                                    (index < completedCount) ? AppStyles.Colors.success :
                                    hasIncompleteHabits ? Color.red : AppStyles.Colors.secondaryText
                                )
                                .frame(width: 4, height: 4)
                        }
                        
                        if habitCount > 3 {
                            Text("+\(habitCount - 3)")
                                .font(.system(size: 8, weight: .semibold))
                                .foregroundColor(isSelected ? .white : AppStyles.Colors.secondaryText)
                        }
                    }
                } else {
                    Spacer()
                        .frame(height: 4)
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        isSelected ?
                            LinearGradient(
                                gradient: Gradient(colors: [AppStyles.Colors.gradient1, AppStyles.Colors.gradient2]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [.clear]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isToday && !isSelected ? AppStyles.Colors.primary : Color.clear, lineWidth: 2)
            )
        }
        .disabled(isPastDate) // ✏️ Yeni: Geçmiş günler tıklanamaz
        .opacity((isCurrentMonth && !isPastDate) ? 1.0 : 0.4)
        .buttonStyle(PlainButtonStyle())
        .opacity(isCurrentMonth ? 1.0 : 0.4)
    }
}

// MARK: - Calendar Habit Row
// MARK: - Calendar Habit Row
struct CalendarHabitRow: View {
    let habit: Habit
    let date: Date
    let isCompleted: Bool
    let action: () -> Void
    
    private func getHabitIcon() -> String {
        let lowerName = habit.name.lowercased()
        
        if lowerName.contains("water") || lowerName.contains("drink") || lowerName.contains("hydrate") {
            return "drop.fill"
        } else if lowerName.contains("run") || lowerName.contains("jog") || lowerName.contains("cardio") {
            return "figure.run"
        } else if lowerName.contains("read") || lowerName.contains("book") {
            return "book.fill"
        } else if lowerName.contains("meditate") || lowerName.contains("yoga") || lowerName.contains("mindful") {
            return "leaf.fill"
        } else if lowerName.contains("sleep") || lowerName.contains("rest") {
            return "bed.double.fill"
        } else if lowerName.contains("eat") || lowerName.contains("meal") || lowerName.contains("food") {
            return "fork.knife"
        } else if lowerName.contains("exercise") || lowerName.contains("workout") || lowerName.contains("gym") {
            return "figure.strengthtraining.traditional"
        } else if lowerName.contains("walk") {
            return "figure.walk"
        } else if lowerName.contains("stretch") {
            return "figure.flexibility"
        }
        
        return "star.fill"
    }
    
    private var frequencyLabel: String {
        switch habit.frequency {
        case .morning:
            return "Morning"
        case .evening:
            return "Evening"
        case .daily:
            return "Daily"
        case .custom:
            if let customFreq = habit.customFrequency {
                return "\(customFreq.targetDays) out of \(customFreq.totalDays) days"
            }
            return "Custom"
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                // Habit icon
                ZStack {
                    Circle()
                        .fill(
                            isCompleted ?
                            AppStyles.Colors.success.opacity(0.2) :
                            AppStyles.Colors.primary.opacity(0.2)
                        )
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: getHabitIcon())
                        .font(.system(size: 18))
                        .foregroundColor(
                            isCompleted ?
                            AppStyles.Colors.success :
                            AppStyles.Colors.primary
                        )
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(habit.name)
                            .font(.headline)
                            .foregroundColor(AppStyles.Colors.text)
                        
                        Spacer()
                        
                       
                    }
                    
                    HStack(spacing: 8) {
                        Text(frequencyLabel)
                            .font(.caption)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                        
                        if habit.streak > 2 {
                            Text("|")
                                .font(.caption)
                                .foregroundColor(AppStyles.Colors.secondaryText)
                            
                            Text("\(habit.streak) day streak")
                                .font(.caption)
                                .foregroundColor(AppStyles.Colors.secondaryText)
                        }
                    }
                }
                
               
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(
                                isCompleted ?
                                AppStyles.Colors.success :
                                AppStyles.Colors.primary.opacity(0.3),
                                lineWidth: isCompleted ? 2 : 1
                            )
                    )
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
// MARK: - Preview
struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        let habitStore = HabitStore()
        
        var dailyHabit = Habit(
            name: "Drink Water",
            frequency: .daily,
            lastCompleted: Date(),
            streak: 5,
            
        )
        dailyHabit.completions = [
            Habit.CompletionRecord(date: Date(), value: 1, isCorrectTime: true)
        ]
        
        var customHabit = Habit(
            name: "Workout",
            frequency: .custom,
            streak: 3,
            customFrequency: Habit.CustomFrequency(
                targetDays: 3,
                totalDays: 7,
                startDate: Calendar.current.date(byAdding: .day, value: -3, to: Date()) ?? Date()
            )
        )
        customHabit.completions = [
            Habit.CompletionRecord(date: Date(), value: 1, isCorrectTime: true)
        ]
        
        habitStore.habits = [dailyHabit, customHabit]
        
        return CalendarView()
            .environmentObject(habitStore)
            .preferredColorScheme(.dark)
    }
}
