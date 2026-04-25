// StreakAnalyticsView.swift
import SwiftUI

struct StreakAnalyticsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitStore: HabitStore
    
    var body: some View {
        NavigationView {
            if habitStore.habits.isEmpty {
                emptyState
            } else {
                ScrollView {
                    
                    VStack(spacing: 20) {
                        StreaksBanner()
                        
                        // Habits list with analytics cards
                        LazyVStack(spacing: 12) {
                            ForEach(habitStore.habits) { habit in
                                HabitAnalyticsCard(habit: habit)
                            }
                        }
                        .padding(.horizontal, 8)
                        
                        Spacer(minLength: 30)
                    }
                }
                .background(Color.black.edgesIgnoringSafeArea(.all))
                .navigationTitle("")
                .navigationBarHidden(true)
            }
            
        }
    }
}


// Individual habit analytics card
struct HabitAnalyticsCard: View {
    let habit: Habit
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text(habit.name)
                        .font(.system(.title, design: .default, weight: .thin))
                        .foregroundColor(AppStyles.Colors.text)
                    
                    Spacer()
                    
                  
                }
                
                // Streak badge - eski kod aynen kalacak
                HStack {
                    if habit.streak > 2 {
                        Label("\(habit.streak) day streak", systemImage: "flame.fill")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Capsule().fill(AppStyles.Colors.accentFun))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Last 10 days")
                        .font(.caption)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                }
                
                // Bar chart for last 10 days - eski kod aynen kalacak
                HabitBarChart(habit: habit)
            }
            .padding(16)
            .zIndex(1)
            
            // Background icon - eski kod aynen kalacak
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .stroke(Color.white, lineWidth: 2)
                            .frame(width: 180, height: 180)
                            .opacity(0.1)
                        
                        Image(systemName: getHabitIcon(for: habit.name))
                            .font(.system(size: 80, weight: .thin))
                            .foregroundColor(Color.white)
                            .opacity(0.1)
                    }
                    .offset(x: 30, y: 30)
                }
            }
            .zIndex(0)
        }
        .background(
            RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                .fill(Color.white.opacity(0.1))
                .shadow(color: Color.white.opacity(0.01), radius: 8, x: 0, y: 4)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius))
        
    }
    // Optimized icon mapping with dictionary
    private func getHabitIcon(for habitName: String) -> String {
        let habitLower = habitName.lowercased()
        
        let iconMap: [String: String] = [
            "teeth": "mouth",
            "brush": "mouth",
            "run": "figure.run",
            "jog": "figure.run",
            "water": "drop.fill",
            "drink": "drop.fill",
            "read": "book.fill",
            "book": "book.fill",
            "meditate": "figure.mind.and.body",
            "exercise": "figure.cooldown",
            "workout": "figure.cooldown",
            "gym": "figure.cooldown",
            "eat": "leaf.fill",
            "healthy": "leaf.fill",
            "plant": "sprinkler.and.droplets.fill",
            "journal": "pencil.and.scribble",
            "novel": "book.closed.fill",
            "vitamin": "pills.fill",
            "stretch": "figure.flexibility",
            "mobilise": "figure.flexibility"
        ]
        
        // Find first matching keyword
        for (keyword, icon) in iconMap {
            if habitLower.contains(keyword) {
                return icon
            }
        }
        
        return "list.star" // Default icon
    }

}

// Bar chart component
struct HabitBarChart: View {
    let habit: Habit
    private let dayCount = 10
    
    var body: some View {
        VStack(spacing: 8) {
            // Chart area
            HStack(alignment: .bottom, spacing: 6) {
                Spacer()
                ForEach(getChartData(), id: \.dayKey) { dayData in
                    VStack(spacing: 4) {
                        // Bar with tick mark
                        ZStack(alignment: .top) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(dayData.isCompleted ? AppStyles.Colors.success : AppStyles.Colors.secondaryBackground)
                                .frame(width: 22, height: max(dayData.barHeight, 8))
                                .overlay(
                                    // Progress indicator for progress tracking habits
                                    dayData.hasProgress ?
                                    RoundedRectangle(cornerRadius: 3)
                                        .fill(AppStyles.Colors.primary.opacity(0.7))
                                        .frame(width: 22, height: dayData.progressHeight)
                                    : nil,
                                    alignment: .bottom
                                )
                            
                            // Tick mark for completed bars or progress text
                            if dayData.isCompleted && dayData.barHeight > 15 {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.white)
                                    .offset(y: 3)
                            } else if dayData.hasProgress && dayData.progressHeight > 15 && !dayData.isCompleted {
                                Text("\(Int(dayData.progressPercentage * 100))%")
                                    .font(.system(size: 8, weight: .bold))
                                    .foregroundColor(.white)
                                    .offset(y: 3)
                            }
                        }
                        
                        // Day label
                        Text(dayData.dayLabel)
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(AppStyles.Colors.secondaryText)
                            .rotationEffect(.degrees(-90))
                            .padding(.top, 10)
                    }
                }
                Spacer()
            }
            .frame(height: 100)
        
        }
    }
    
    private func getChartData() -> [ChartDayData] {
        let calendar = Calendar.current
        let now = Date()
        var chartData: [ChartDayData] = []
        
        for i in (0..<dayCount).reversed() {
            let date = calendar.date(byAdding: .day, value: -i, to: now) ?? now
            let dayKey = {
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                return formatter.string(from: date)
            }()
            
            let dayLabel = {
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.MM"
                return formatter.string(from: date)
            }()
            
            // Get day's completions
            let dayCompletions = habit.completions.filter { completion in
                completion.dayKey == dayKey
            }
            
            let totalValue = dayCompletions.reduce(0) { $0 + $1.value }
            let isCompleted = isHabitCompletedOnDay(dayCompletions: dayCompletions)
            
            // Calculate bar heights
            let maxBarHeight: CGFloat = 60
            var barHeight: CGFloat = 8 // Minimum height
            var progressHeight: CGFloat = 8
            var hasProgress = false
            
            if let dailyGoal = habit.dailyGoal, dailyGoal.type != .single {
                hasProgress = true
                let progressPercentage = min(Double(totalValue) / Double(dailyGoal.target), 1.0)
                progressHeight = CGFloat(progressPercentage) * maxBarHeight
                barHeight = isCompleted ? maxBarHeight : max(progressHeight, 8)
            } else if !dayCompletions.isEmpty {
                barHeight = maxBarHeight
            }
            
            chartData.append(ChartDayData(
                dayKey: dayKey,
                dayLabel: dayLabel,
                isCompleted: isCompleted,
                barHeight: barHeight,
                progressHeight: progressHeight,
                hasProgress: hasProgress,
                progressPercentage: hasProgress ? min(Double(totalValue) / Double(habit.dailyGoal?.target ?? 1), 1.0) : 0.0
            ))
        }
        
        return chartData
    }
    
    private func isHabitCompletedOnDay(dayCompletions: [Habit.CompletionRecord]) -> Bool {
        if dayCompletions.isEmpty {
            return false
        }
        
        if let dailyGoal = habit.dailyGoal, dailyGoal.type != .single {
            let totalValue = dayCompletions.reduce(0) { $0 + $1.value }
            return totalValue >= dailyGoal.target
        } else {
            return true
        }
    }
}

// Chart data model
struct ChartDayData {
    let dayKey: String
    let dayLabel: String
    let isCompleted: Bool
    let barHeight: CGFloat
    let progressHeight: CGFloat
    let hasProgress: Bool
    let progressPercentage: Double
}

private var emptyState: some View {
    VStack(spacing: 20) {
        // Ikon
        Image(systemName: "figure.jump")
            .font(.system(size: 60))
            .foregroundColor(.gray.opacity(0.6))
            .padding(.bottom, 10)
        
        // Başlık
        Text("No Habits Yet")
            .font(.title2)
            .fontWeight(.semibold)
            .foregroundColor(.white)
        
        // Açıklama
        Text("You haven’t added any habits yet.\nStart by creating your first habit and track your streaks!")
            .font(.body)
            .multilineTextAlignment(.center)
            .foregroundColor(.gray.opacity(0.8))
            .padding(.horizontal, 40)
        
       
        
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.black.edgesIgnoringSafeArea(.all))
}



struct StreakAnalyticsView_Previews: PreviewProvider {
    static var previews: some View {
        StreakAnalyticsView()
            .environmentObject(HabitStore())
    }
}

