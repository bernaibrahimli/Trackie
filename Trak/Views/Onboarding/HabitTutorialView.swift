// HabitTutorialView.swift
import SwiftUI

struct HabitTutorialView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                   TutorialBanner()
                    TutorialSection(
                        title: "Daily Habits",
                        description: "Complete anytime during the day by tapping the circle and selecting 'Yes' in the confirmation dialog.",
                        habitExample: createDailyHabit()
                    )
                    
                    // Morning Habits Section
                    TutorialSection(
                        title: "Morning Habits",
                        description: "Best completed between 6:00 AM - 12:00 PM. If completed outside this time, the habit will show a warning indicator.",
                        habitExample: createMorningHabit()
                    )
                    
                    // Evening Habits Section
                    TutorialSection(
                        title: "Evening Habits",
                        description: "Best completed after 6:00 PM. Late completion will be marked with a different color indicator.",
                        habitExample: createEveningHabit()
                    )
                    
                    // Custom Frequency Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Custom Frequency")
                            .font(AppStyles.Typography.headline)
                            .foregroundColor(AppStyles.Colors.text)
                        
                        Text("Set specific targets like '5 out of 7 days'. Small circles around the habit show your progress in the current period.")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack(spacing: 20) {
                            // Habit circle example
                            VStack {
                                HabitCircleView(
                                    habit: createCustomHabit(),
                                    iconName: "figure.cooldown",
                                    onTap: {}
                                )
                                .allowsHitTesting(false)
                                .scaleEffect(0.8)
                            }
                            
                            // Custom form example
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Custom Form")
                                    .font(AppStyles.Typography.caption)
                                    .foregroundColor(AppStyles.Colors.secondaryText)
                                
                                VStack(alignment: .leading, spacing: 6) {
                                    HStack {
                                        Text("Goal Type:")
                                            .font(.system(size: 11))
                                            .foregroundColor(AppStyles.Colors.secondaryText)
                                        Text("one time")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(AppStyles.Colors.primary)
                                    }
                                    
                                    HStack {
                                        Text("Target:")
                                            .font(.system(size: 11))
                                            .foregroundColor(AppStyles.Colors.secondaryText)
                                        Text("5 out of 7 days")
                                            .font(.system(size: 11, weight: .medium))
                                            .foregroundColor(AppStyles.Colors.primary)
                                    }
                                }
                                .padding(8)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(AppStyles.Colors.secondaryBackground)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 8)
                                                .stroke(AppStyles.Colors.primary.opacity(0.3), lineWidth: 1)
                                        )
                                )
                            }
                        }
                        .padding(.vertical, 10)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                            .fill(AppStyles.Colors.background)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                    
                    // Progress Tracking Section
                    TutorialSection(
                        title: "Progress Tracking",
                        description: "Some habits track progress like counting or timing. The progress badge shows your current status.",
                        habitExample: createProgressHabit()
                    )
                    
                    // Add Template Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Creating Templates")
                            .font(AppStyles.Typography.headline)
                            .foregroundColor(AppStyles.Colors.text)
                        
                        Text("Save time by creating custom templates. Tap the '+' icon in the template section to create reusable habit configurations.")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack {
                            Spacer()
                            
                            // Template creation visual
                            VStack(spacing: 10) {
                                ZStack {
                                    Circle()
                                        .stroke(AppStyles.Colors.primary, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                                        .frame(width: 50, height: 50)
                                        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                                    
                                    Image(systemName: "plus")
                                        .font(.system(size: 22, weight: .medium))
                                        .foregroundColor(AppStyles.Colors.primary)
                                }
                                
                                Text("Create Template")
                                    .font(Font.system(.caption, design: .rounded).weight(.medium))
                                    .lineLimit(2)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(AppStyles.Colors.primary)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 10)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                            .fill(AppStyles.Colors.background)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Streak Analytics")
                            .font(AppStyles.Typography.headline)
                            .foregroundColor(AppStyles.Colors.text)
                        
                        Text("Track your habit progress over time with detailed analytics from your stats page. View completion patterns, streak counts, and daily progress in visual charts, all your progress is here.")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        ZStack {
                            VStack(alignment: .leading, spacing: 12) {
                                HStack {
                                    Text("Morning Exercise")
                                        .font(.system(.title3, design: .default, weight: .thin))
                                        .foregroundColor(AppStyles.Colors.text)
                                    
                                    Spacer()
                                    
                                    // Streak badge
                                    HStack(spacing: 4) {
                                        Image(systemName: "flame.fill")
                                            .foregroundColor(AppStyles.Colors.accentFun)
                                            .font(.caption)
                                        
                                        Text("6")
                                            .font(Font.system(.caption, design: .rounded).weight(.bold))
                                            .foregroundColor(AppStyles.Colors.accentFun)
                                    }
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(
                                        Capsule()
                                            .fill(AppStyles.Colors.accentFun.opacity(0.15))
                                    )
                                }
                                
                                // Goal information
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Daily Goal: 30 min")
                                        .font(.system(.body, design: .default, weight: .thin))
                                        .foregroundColor(AppStyles.Colors.text)
                                    
                                    Text("Frequency: Morning")
                                        .font(AppStyles.Typography.caption)
                                        .foregroundColor(AppStyles.Colors.secondaryText)
                                }
                                
                                // Demo bar chart
                                VStack(spacing: 8) {
                                    HStack(alignment: .bottom, spacing: 6) {
                                        Spacer()
                                        
                                        // Demo bars with mixed completion states
                                        ForEach(0..<10, id: \.self) { index in
                                            VStack(spacing: 4) {
                                                ZStack(alignment: .top) {
                                                    let barData = getDemoBarData(index: index)
                                                    
                                                    RoundedRectangle(cornerRadius: 3)
                                                        .fill(barData.isCompleted ? AppStyles.Colors.success : AppStyles.Colors.secondaryBackground)
                                                        .frame(width: 18, height: max(barData.height, 8))
                                                        .overlay(
                                                            // Progress indicator
                                                            barData.hasProgress ?
                                                            RoundedRectangle(cornerRadius: 3)
                                                                .fill(AppStyles.Colors.primary.opacity(0.7))
                                                                .frame(width: 18, height: barData.progressHeight)
                                                            : nil,
                                                            alignment: .bottom
                                                        )
                                                    
                                                    // Completion indicator
                                                    if barData.isCompleted && barData.height > 15 {
                                                        Image(systemName: "checkmark")
                                                            .font(.system(size: 8, weight: .bold))
                                                            .foregroundColor(.white)
                                                            .offset(y: 2)
                                                    } else if barData.hasProgress && barData.progressHeight > 15 && !barData.isCompleted {
                                                        Text("\(Int(barData.progressPercentage * 100))%")
                                                            .font(.system(size: 6, weight: .bold))
                                                            .foregroundColor(.white)
                                                            .offset(y: 2)
                                                    }
                                                }
                                                
                                                Text(getDemoDate(index: index))
                                                    .font(.system(size: 6, weight: .medium))
                                                    .foregroundColor(AppStyles.Colors.secondaryText)
                                                    .rotationEffect(.degrees(-90))
                                                    .padding(.top, 5)
                                            }
                                        }
                                        
                                        Spacer()
                                    }
                                    .frame(height: 80)
                                    .padding(.top, 10)
                                    
                                    // Legend
                                    HStack(spacing: 12) {
                                        HStack(spacing: 4) {
                                            Circle()
                                                .fill(AppStyles.Colors.success)
                                                .frame(width: 6, height: 6)
                                            Text("Completed")
                                                .font(.system(size: 8))
                                                .foregroundColor(AppStyles.Colors.secondaryText)
                                        }
                                        
                                        HStack(spacing: 4) {
                                            Circle()
                                                .fill(AppStyles.Colors.primary.opacity(0.7))
                                                .frame(width: 6, height: 6)
                                            Text("Progress")
                                                .font(.system(size: 8))
                                                .foregroundColor(AppStyles.Colors.secondaryText)
                                        }
                                    }
                                }
                            }
                            .padding(14)
                            .zIndex(1)
                            
                            // Background icon
                            VStack {
                                Spacer()
                                HStack {
                                    Spacer()
                                    ZStack {
                                        Circle()
                                            .stroke(Color.black, lineWidth: 1)
                                            .frame(width: 80, height: 80)
                                            .opacity(0.1)
                                        
                                        Image(systemName: "figure.cooldown")
                                            .font(.system(size: 35, weight: .thin))
                                            .foregroundColor(Color.black)
                                            .opacity(0.1)
                                    }
                                    .offset(x: 15, y: 15)
                                }
                            }
                            .zIndex(0)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                                .fill(AppStyles.Colors.background)
                                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius))
                        .scaleEffect(0.85) // Slightly smaller for tutorial
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                            .fill(AppStyles.Colors.background)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                    
                    
                    // Deletion Section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Deleting Habits")
                            .font(AppStyles.Typography.headline)
                            .foregroundColor(AppStyles.Colors.text)
                        
                        Text("Long press on any habit circle and select 'Delete Habit' from the context menu to remove it permanently.")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        HStack {
                            Spacer()
                            
                            // Demo habit for deletion
                            VStack {
                                ZStack {
                                    Circle()
                                        .fill(AppStyles.Colors.secondaryBackground)
                                        .frame(width: 80, height: 80)
                                        .overlay(
                                            Circle()
                                                .stroke(AppStyles.Colors.primary, lineWidth: 2)
                                        )
                                    
                                    Image(systemName: "trash")
                                        .font(.system(size: 24))
                                        .foregroundColor(AppStyles.Colors.error)
                                }
                                
                                Text("Long Press")
                                    .font(Font.system(.caption, design: .rounded).weight(.medium))
                                    .foregroundColor(AppStyles.Colors.secondaryText)
                                    .padding(.top, 4)
                            }
                            
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        
                        // Limits explanation
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Habit & Template Limits")
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(AppStyles.Colors.primary)
                                .fontWeight(.semibold)
                            
                            Text("For optimal performance and focus, you can maintain up to 10 active habits and 3 custom templates. Research shows that tracking fewer habits leads to better consistency and long-term success. This limit ensures smooth app performance while encouraging focused habit development.")
                                .font(.system(size: 12))
                                .foregroundColor(AppStyles.Colors.secondaryText)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .padding(.top, 15)
                        .padding(.horizontal, 5)
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                            .fill(AppStyles.Colors.background)
                            .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
                    )
                    
                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
            }
            .background(Color.black.edgesIgnoringSafeArea(.all))
            .navigationTitle("Tutorial")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppStyles.Colors.primary)
                }
            }
        }
    }
    
    private func getDemoBarData(index: Int) -> (height: CGFloat, isCompleted: Bool, hasProgress: Bool, progressHeight: CGFloat, progressPercentage: Double) {
        let patterns: [(CGFloat, Bool, Bool, CGFloat, Double)] = [
            (35, false, true, 35, 0.7),
            (42, false, true, 42, 0.85),
            (50, true, false, 0, 1.0),
            (20, false, true, 20, 0.4),
            (50, true, false, 0, 1.0),
            (50, true, false, 0, 1.0),
            (50, true, false, 0, 1.0),
            (50, true, false, 0, 1.0),
            (50, true, false, 0, 1.0),
            (50, true, false, 0, 1.0)
        ]
        
        return patterns[index]
    }

    private func getDemoDate(index: Int) -> String {
        let dates = ["28.05", "29.05", "30.05", "31.05", "01.06", "02.06", "03.06", "04.06", "05.06", "06.06"]
        return dates[index]
    }
    
    // Helper functions to create example habits
    private func createDailyHabit() -> Habit {
        return Habit(
            name: "Read a book",
            frequency: .daily,
            
        )
    }
    
    private func createMorningHabit() -> Habit {
        return Habit(
            name: "Morning run",
            frequency: .morning,
           
        )
    }
    
    private func createEveningHabit() -> Habit {
        return Habit(
            name: "Meditate",
            frequency: .evening,
          
        )
    }
    
    private func createCustomHabit() -> Habit {
        return Habit(
            name: "Gym workout",
            frequency: .custom,
            
            customFrequency: Habit.CustomFrequency(
                targetDays: 5,
                totalDays: 7,
                startDate: Date()
            )
        )
    }
    
    private func createProgressHabit() -> Habit {
        var habit = Habit(
            name: "Drink water",
            frequency: .daily,
            dailyGoal: Habit.DailyGoal(
                type: .count,
                target: 200,
                increment: 20,
                unit: "cl"
            )
        )
        
        // Add some sample completions to show progress
        habit.completions = [
            Habit.CompletionRecord(
                date: Date(),
                value: 60,
                isCorrectTime: true
            )
        ]
        
        return habit
    }
}

// Tutorial Section Component
struct TutorialSection: View {
    let title: String
    let description: String
    let habitExample: Habit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text(title)
                .font(AppStyles.Typography.headline)
                .foregroundColor(AppStyles.Colors.text)
            
            Text(description)
                .font(AppStyles.Typography.body)
                .foregroundColor(AppStyles.Colors.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Spacer()
                
                // Display the habit circle (non-interactive)
                HabitCircleView(
                    habit: habitExample,
                    iconName: getIconName(for: habitExample.name),
                    onTap: {} // Empty onTap since it's non-interactive
                )
                .allowsHitTesting(false) // Disable interaction
                
                Spacer()
            }
            .padding(.vertical, 10)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                .fill(AppStyles.Colors.background)
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
        )
    }
    
    // Helper function to get icon name
    private func getIconName(for habitName: String) -> String {
        let habitLower = habitName.lowercased()
        
        if habitLower.contains("read") || habitLower.contains("book") { return "book.fill" }
        if habitLower.contains("run") { return "figure.run" }
        if habitLower.contains("meditate") { return "figure.mind.and.body" }
        if habitLower.contains("gym") || habitLower.contains("workout") { return "figure.cooldown" }
        if habitLower.contains("water") { return "drop.fill" }
        
        return "list.star"
    }
}

struct HabitTutorialView_Previews: PreviewProvider {
    static var previews: some View {
        HabitTutorialView()
    }
}
