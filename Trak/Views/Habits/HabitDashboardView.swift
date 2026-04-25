import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    let type: HabitDashboardView.AlertType
    let habit: Habit
}

struct HabitDashboardView: View {
    @EnvironmentObject var habitStore: HabitStore
    @State private var activeAlert: AlertItem?   
    @State private var showingStreakAnalytics = false
    @State private var contentVisible = false
    @State private var showCompletionEffect = false
    @State private var completedHabitId: UUID? = nil

    enum AlertType {
        case confirmation
        case timeWarning
        case timerStart
        case timerStop
        case deleteConfirmation
        
        var description: String {
            switch self {
            case .confirmation: return "confirmation"
            case .timeWarning: return "timeWarning"
            case .timerStart: return "timerStart"
            case .timerStop: return "timerStop"
            case .deleteConfirmation: return "deleteConfirmation"
            }
        }
    }
    
    private func handleHabitDeletion(_ habit: Habit) {
        if habit.streak > 3 {
            activeAlert = AlertItem(type: .deleteConfirmation, habit: habit)
        } else {
            if let habitIndex = habitStore.habits.firstIndex(where: { $0.id == habit.id }) {
                habitStore.deleteHabit(at: IndexSet(integer: habitIndex))
            }
        }
    }
    
    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 110, maximum: 130), spacing: 40),
    ]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d"
        return formatter
    }

    var body: some View {
        NavigationView {
            ZStack {
                DynamicLineParticleView()
                    .ignoresSafeArea()
               

                    
                    VStack(alignment: .leading, spacing: 5) {
                        headerView
                        ScrollView{
                            mainContentView
                        }
                        .scrollIndicators(.hidden)
                }
               
            }
            .navigationBarHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingStreakAnalytics = true
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.orange.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                )
                        )
                    }
                }
            }
            .sheet(isPresented: $showingStreakAnalytics) {
                StreakAnalyticsView()
                    .environmentObject(habitStore)
            }
            .alert(item: $activeAlert) { alertItem in
                switch alertItem.type {
                case .confirmation:
                    return Alert(
                        title: Text("Complete Habit"),
                        message: Text("Have you completed \"\(alertItem.habit.name)\" for today?"),
                        primaryButton: .default(Text("Yes")) {
                            completeHabitWithEffect(alertItem.habit)
                        },
                        secondaryButton: .cancel()
                    )
                case .timeWarning:
                    return Alert(
                        title: Text("Wrong Time"),
                        message: Text(getTimeWarningMessage(for: alertItem.habit)),
                        primaryButton: .default(Text("Complete Anyway")) {
                            completeHabitWithEffect(alertItem.habit, forceComplete: true)
                        },
                        secondaryButton: .cancel()
                    )
                case .timerStart:
                    return Alert(
                        title: Text("Start Timer"),
                        message: Text("Are you starting \(alertItem.habit.name) activity?\n\nDon't forget to tap this button again to save your time when you're done!"),
                        primaryButton: .default(Text("Start")) {
                            habitStore.startTimerSession(habitId: alertItem.habit.id)
                        },
                        secondaryButton: .cancel()
                    )
                
                case .timerStop:
                    let message: String
                    if let startTime = alertItem.habit.activeSessionStartTime {
                        let elapsed = Int(Date().timeIntervalSince(startTime) / 60)
                        message = "Are you finishing \(alertItem.habit.name) activity?\n\nElapsed time: \(elapsed) minutes"
                    } else {
                        message = "Are you finishing \(alertItem.habit.name) activity?"
                    }
                    return Alert(
                        title: Text("Stop Timer"),
                        message: Text(message),
                        primaryButton: .default(Text("Stop & Save")) {
                            habitStore.stopTimerSession(habitId: alertItem.habit.id)
                        },
                        secondaryButton: .cancel()
                    )
                case .deleteConfirmation:
                    return Alert(
                        title: Text("Delete Your \(alertItem.habit.streak)-Day Streak?"),
                        message: Text("You've built an amazing \(alertItem.habit.streak)-day streak with \(alertItem.habit.name)! 🔥\n\nThis represents your dedication and progress. Are you sure you want to delete this habit and lose your streak?"),
                        primaryButton: .destructive(Text("Delete")) {
                            if let habitIndex = habitStore.habits.firstIndex(where: { $0.id == alertItem.habit.id }) {
                                habitStore.deleteHabit(at: IndexSet(integer: habitIndex))
                            }
                        },
                        secondaryButton: .cancel(Text("Keep My Streak"))
                    )
                }
            }
            .onAppear {
                DispatchQueue.main.async {
                    if !contentVisible {
                        withAnimation(AppStyles.Animations.spring.delay(0.1)) {
                            contentVisible = true
                        }
                    }
                }
            }

            .onDisappear {
                contentVisible = false
            }
        }
        .accentColor(AppStyles.Colors.primary)
    }
    
    // MARK: - Header
    private var headerView: some View {

        HStack(spacing: 0){
    
            VStack(alignment:.leading, spacing: 0) {
                Text("Today's Program")
                    .font(.system(size: 28, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .textCase(nil)
         
                
                Text(dateFormatter.string(from: Date()).uppercased())
                    .font(Font.system(.callout, design: .rounded).weight(.medium))
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [.mint, .white]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            }
            Spacer()
            HStack(spacing: 5){
                completionCounter
                Button {
                    showingStreakAnalytics = true
                } label: {
                    HStack(spacing: 6) {
                        Image(systemName: "flame.fill")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.orange)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.orange.opacity(0.1))
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                            )
                    )
                }
            }
            
        }
        .padding()
        .opacity(contentVisible ? 1 : 0)
        .offset(y: contentVisible ? 0 : -20)
        .animation(AppStyles.Animations.spring, value: contentVisible)
    }
    
    private var completionCounter: some View {
        
        Group {
            if !habitStore.habits.isEmpty {
                let completedCount = habitStore.habits.filter { habit in
                    guard let lastCompleted = habit.lastCompleted else {
                        return false
                    }
                    let isToday = Calendar.current.isDateInToday(lastCompleted)
                    let isCompleted = habit.isCompletedToday
                    return isCompleted
                }.count
                
                HStack(spacing: 8) {
                    Text("\(completedCount)/\(habitStore.habits.count)")
                        //.font(Font.system(.callout, design: .rounded).weight(.semibold))
                        .font(.system(size: 18, weight: .light))
                        .foregroundColor(AppStyles.Colors.text)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(AppStyles.Colors.success)
                        .font(.callout)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(AppStyles.Colors.secondaryBackground)
                        .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                )
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : -15)
                .animation(AppStyles.Animations.spring.delay(0.1), value: contentVisible)
            }
        }
    }
    
    // MARK: - Main Content
    @ViewBuilder
    private var mainContentView: some View {
        if habitStore.habits.isEmpty {
            emptyStateView
        } else {
            habitsGridView
        }
    }
    
    private var dailyHabits: [Habit] {
        habitStore.habits.filter { habit in
            switch habit.frequency {
            case .daily, .morning, .evening:
                return true
            case .custom:
                if let customFreq = habit.customFrequency {
                    return customFreq.targetDays == customFreq.totalDays
                }
                return false
            }
        }
    }
    
    private var dailyHabitsSection: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Daily")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(AppStyles.Colors.secondaryText.opacity(0.7))
                
                Spacer()
                
                Text("\(dailyHabits.count)")
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundColor(AppStyles.Colors.secondaryText.opacity(0.5))
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 8)
            .background(
                Rectangle()
                    .fill(AppStyles.Colors.secondaryBackground.opacity(0.3))
            )
            
            Rectangle()
                .fill(AppStyles.Colors.secondaryBackground.opacity(0.5))
                .frame(height: 1)
                .padding(.horizontal, 20)
        }
        .padding(.bottom, 20)
    }
    
    private var emptyStateView: some View {
        VStack {
            Spacer(minLength: 50)
            
            Image(systemName: "figure.walk.motion")
                .font(.system(size: 75))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [AppStyles.Colors.primary, AppStyles.Colors.gradient2]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .opacity(0.7)
                .rotationEffect(.degrees(contentVisible ? 0 : -5))
                .scaleEffect(contentVisible ? 1.0 : 0.9)
                .padding(.bottom, 20)
            
            Text("Ready to Build Habits?")
                .font(AppStyles.Typography.title)
                .foregroundColor(AppStyles.Colors.text)
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 20)
                .animation(AppStyles.Animations.spring.delay(0.2), value: contentVisible)
            
            Text("Tap the '+' button below to add your first habit and start your journey!")
                .font(AppStyles.Typography.body)
                .foregroundColor(AppStyles.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .opacity(contentVisible ? 1 : 0)
                .offset(y: contentVisible ? 0 : 20)
                .animation(AppStyles.Animations.spring.delay(0.3), value: contentVisible)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, minHeight: 300)
}
    
    private var habitsGridView: some View {
        LazyVGrid(columns: columns, spacing: 40) {
            ForEach(Array(habitStore.habits.enumerated()), id: \.element.id) { index, habit in
                habitCircleView(habit: habit, index: index)
                    .contentShape(Circle())

            }
        }
        .padding()
    }
    
    private func habitCircleView(habit: Habit, index: Int) -> some View {
        HabitCircleView(
            habit: habit,
            iconName: habitStore.getIconName(for: habit.name),
            onTap: {
                handleHabitTap(habit)
            }
        )
        .opacity(contentVisible ? 1 : 0)
        .offset(y: contentVisible ? 0 : 30)
        .scaleEffect(contentVisible ? 1.0 : 0.9)
        .animation(
            AppStyles.Animations.spring.delay(min(Double(index) * 0.03, 0.3)),
            value: contentVisible
        )
        .overlay(completionEffectOverlay(for: habit))
        .contextMenu {
            Button(role: .destructive) {
                handleHabitDeletion(habit)
            } label: {
                Label("Delete Habit", systemImage: "trash")
            }
        }
    }
    
    private func completionEffectOverlay(for habit: Habit) -> some View {
        ZStack {
            if showCompletionEffect && completedHabitId == habit.id {
                Circle()
                    .fill(AppStyles.Colors.success.opacity(0.2))
                    .scaleEffect(showCompletionEffect ? 1.5 : 0)
                    .opacity(showCompletionEffect ? 0 : 1)
            }
        }
        .animation(.easeOut(duration: 0.8), value: showCompletionEffect)
    }
    
    
    private func getTimeWarningMessage(for habit: Habit) -> String {
        switch habit.frequency {
        case .morning:
            return "This is a morning habit (6:00 AM - 12:00 PM). Complete anyway?"
        case .evening:
            return "This is an evening habit (after 6:00 PM). Complete anyway?"
        default:
            return ""
        }
    }
    
    private func completeHabitWithEffect(_ habit: Habit, forceComplete: Bool = false) {
        withAnimation {
            completedHabitId = habit.id
            showCompletionEffect = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            showCompletionEffect = false
            completedHabitId = nil
        }
        
        habitStore.completeHabit(habitId: habit.id, forceComplete: forceComplete)
    }
    
    private func handleHabitTap(_ habit: Habit) {
        print("habit selected: \(habit.name)")
        
        if let dailyGoal = habit.dailyGoal, dailyGoal.type == .duration {
            activeAlert = AlertItem(type: habit.hasActiveSession ? .timerStop : .timerStart, habit: habit)
            return
        }
        
        if !habit.isCorrectTimeToComplete(),
           habit.frequency == .morning || habit.frequency == .evening {
            activeAlert = AlertItem(type: .timeWarning, habit: habit)
            return
        }
        
        activeAlert = AlertItem(type: .confirmation, habit: habit)
        
    }
}
