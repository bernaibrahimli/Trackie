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

    // Weekly scrubber selection
    @State private var selectedDate = Date()

    enum AlertType {
        case confirmation
        case timeWarning
        case timerStart
        case timerStop
        case deleteConfirmation

        var description: String {
            switch self {
            case .confirmation:      return "confirmation"
            case .timeWarning:       return "timeWarning"
            case .timerStart:        return "timerStart"
            case .timerStop:         return "timerStop"
            case .deleteConfirmation: return "deleteConfirmation"
            }
        }
    }

    // MARK: - Date Helpers

    private var isSelectedDateToday: Bool {
        Calendar.current.isDateInToday(selectedDate)
    }

    private var isSelectedDateFuture: Bool {
        Calendar.current.startOfDay(for: selectedDate) > Calendar.current.startOfDay(for: Date())
    }

    private var headerTitle: String {
        let cal = Calendar.current
        if cal.isDateInToday(selectedDate)     { return "Today's Program" }
        if cal.isDateInYesterday(selectedDate) { return "Yesterday" }
        if cal.isDateInTomorrow(selectedDate)  { return "Tomorrow" }
        let f = DateFormatter()
        f.dateFormat = "EEEE"
        return f.string(from: selectedDate)
    }

    /// Returns true if `habit` should appear on a future `date`.
    /// Daily/morning/evening habits always appear.
    /// Recurring custom habits disappear from future days in the current cycle once the target is met.
    private func habitAppliesToFutureDate(_ habit: Habit, date: Date) -> Bool {
        switch habit.frequency {
        case .daily, .morning, .evening:
            return true
        case .custom:
            guard let cf = habit.customFrequency else { return false }
            let cal = Calendar.current
            let origin = cal.startOfDay(for: cf.startDate)
            let target = cal.startOfDay(for: date)
            guard target >= origin else { return false }
            if !cf.isRecurring {
                let endDay = cal.startOfDay(for: cf.endDate)
                return target <= endDay
            }
            // Recurring: dates beyond the current cycle always appear (new cycle resets progress).
            let currentEnd = cal.date(byAdding: .day, value: cf.totalDays - 1, to: cf.currentPeriodStart) ?? cf.currentPeriodStart
            if target > cal.startOfDay(for: currentEnd) {
                return true
            }
            // Same cycle as today — hide if the target is already met.
            return habit.getCompletedDaysInCurrentPeriod() < cf.targetDays
        }
    }

    /// Returns true if `habit` has a completion record on `date` that satisfies its goal.
    private func habitCompletedOn(_ habit: Habit, date: Date) -> Bool {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        let dayKey = f.string(from: date)
        let dayCompletions = habit.completions.filter { $0.dayKey == dayKey }
        if dayCompletions.isEmpty { return false }
        if let goal = habit.dailyGoal, goal.type != .single {
            return dayCompletions.reduce(0) { $0 + $1.value } >= goal.target
        }
        return true
    }

    // MARK: - Other Helpers

    private func handleHabitDeletion(_ habit: Habit) {
        if habit.streak > 3 {
            activeAlert = AlertItem(type: .deleteConfirmation, habit: habit)
        } else {
            if let idx = habitStore.habits.firstIndex(where: { $0.id == habit.id }) {
                habitStore.deleteHabit(at: IndexSet(integer: idx))
            }
        }
    }

    private let columns: [GridItem] = [
        GridItem(.adaptive(minimum: 110, maximum: 130), spacing: 40),
    ]

    private var dateFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = "EEEE, MMM d"
        return f
    }

    // MARK: - Body

    var body: some View {
        NavigationView {
            ZStack {
                DynamicLineParticleView().ignoresSafeArea()

                VStack(alignment: .leading, spacing: 5) {
                    headerView
                    WeeklyScrubberView(selectedDate: $selectedDate)
                    ScrollView {
                        mainContentView
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingStreakAnalytics) {
                StreakAnalyticsView().environmentObject(habitStore)
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
                            if let idx = habitStore.habits.firstIndex(where: { $0.id == alertItem.habit.id }) {
                                habitStore.deleteHabit(at: IndexSet(integer: idx))
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
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text(headerTitle)
                    .font(.system(size: 28, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .textCase(nil)
                    .animation(.none, value: headerTitle)

                Text(dateFormatter.string(from: selectedDate).uppercased())
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
            HStack(spacing: 5) {
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
                    isSelectedDateToday
                        ? habit.isCompletedToday
                        : habitCompletedOn(habit, date: selectedDate)
                }.count

                HStack(spacing: 8) {
                    Text("\(completedCount)/\(habitStore.habits.count)")
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
        let habits = isSelectedDateFuture
            ? habitStore.habits.filter { habitAppliesToFutureDate($0, date: selectedDate) }
            : habitStore.habits
        return LazyVGrid(columns: columns, spacing: 40) {
            ForEach(Array(habits.enumerated()), id: \.element.id) { index, habit in
                habitCircleView(habit: habit, index: index)
                    .contentShape(Circle())
            }
        }
        .padding()
    }

    // MARK: - Habit Circle (3 states: today / past / future)

    @ViewBuilder
    private func habitCircleView(habit: Habit, index: Int) -> some View {
        let icon = habitStore.getIconName(for: habit.name)

        Group {
            if isSelectedDateToday {
                // Interactive — existing behavior
                HabitCircleView(
                    habit: habit,
                    iconName: icon,
                    onTap: { handleHabitTap(habit) }
                )
                .overlay(completionEffectOverlay(for: habit))
                .contextMenu {
                    Button(role: .destructive) {
                        handleHabitDeletion(habit)
                    } label: {
                        Label("Delete Habit", systemImage: "trash")
                    }
                }

            } else if isSelectedDateFuture {
                // Future date — show as not yet done, not interactive
                PastHabitCircleView(
                    habit: habit,
                    iconName: icon,
                    wasCompleted: false
                )
                .allowsHitTesting(false)

            } else {
                // Past date — read-only historical view
                PastHabitCircleView(
                    habit: habit,
                    iconName: icon,
                    wasCompleted: habitCompletedOn(habit, date: selectedDate)
                )
            }
        }
        .opacity(contentVisible ? 1 : 0)
        .offset(y: contentVisible ? 0 : 30)
        .scaleEffect(contentVisible ? 1.0 : 0.9)
        .animation(
            AppStyles.Animations.spring.delay(min(Double(index) * 0.03, 0.3)),
            value: contentVisible
        )
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

    // MARK: - Tap Handling (today only)

    private func getTimeWarningMessage(for habit: Habit) -> String {
        switch habit.frequency {
        case .morning: return "This is a morning habit (6:00 AM - 12:00 PM). Complete anyway?"
        case .evening: return "This is an evening habit (after 6:00 PM). Complete anyway?"
        default:       return ""
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

// MARK: - Past Date Read-Only Circle

private struct PastHabitCircleView: View {
    let habit: Habit
    let iconName: String
    let wasCompleted: Bool

    var body: some View {
        VStack {
            ZStack {
                if wasCompleted {
                    Circle()
                        .fill(AppStyles.Colors.success)
                        .frame(width: 100, height: 100)
                        .shadow(color: AppStyles.Colors.success.opacity(0.3), radius: 8, x: 0, y: 4)
                    Image(systemName: "checkmark")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundColor(.white)
                } else {
                    Circle()
                        .fill(AppStyles.Colors.secondaryBackground)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Circle()
                                .stroke(AppStyles.Colors.primary, lineWidth: 3)
                                .opacity(0.3)
                        )
                    Image(systemName: iconName)
                        .font(.system(size: 36, weight: .medium))
                        .foregroundColor(AppStyles.Colors.primary.opacity(0.4))
                }
            }
            .frame(width: 110, height: 110)

            Text(habit.name)
                .font(Font.system(.caption, design: .rounded).weight(.medium))
                .foregroundColor(wasCompleted ? AppStyles.Colors.success : AppStyles.Colors.secondaryText)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 100)
                .padding(.top, 4)
        }
        .padding(.bottom, 20)
    }
}
