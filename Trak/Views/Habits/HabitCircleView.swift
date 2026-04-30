// HabitCircleView.swift
import SwiftUI

struct HabitCircleView: View {
    let habit: Habit
    let iconName: String
    let onTap: () -> Void

    @State private var isPressed = false
    @State private var showCompletionEffect = false
    @State private var iconScale: CGFloat = 1.0
    @State private var completionAnimationPlayed = false

    init(habit: Habit, iconName: String, onTap: @escaping () -> Void = {}) {
        self.habit = habit
        self.iconName = iconName
        self.onTap = onTap
    }

    // MARK: - Derived State

    private var isDailyHabit: Bool {
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

    /// True only when the habit is a count-type goal that is not yet completed.
    /// Drives the segmented ring rendering path.
    private var isCountType: Bool {
        habit.dailyGoal?.type == .count && !habit.isCompletedToday
    }

    // MARK: - Body

    var body: some View {
        VStack {
            ZStack {
                circleBackground

                // Starburst on completion — only visible momentarily after the final tap
                if habit.isCompletedToday && showCompletionEffect {
                    starburstView
                }

                centerContent

                // Badges — hidden once the habit is done
                if !habit.isCompletedToday {
                    progressIndicator

                    if isDailyHabit {
                        HStack(spacing: 2) {
                            Image(systemName: "calendar")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(.white)
                            Text("Daily")
                                .font(.system(size: 9, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(AppStyles.Colors.primary))
                        .offset(x: -40, y: -25)
                        .transition(.opacity.combined(with: .scale))
                    }

                    if habit.streak >= 2 {
                        HStack(spacing: 4) {
                            Image(systemName: "flame.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(AppStyles.Colors.accentFun)
                            Text("\(habit.streak)")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(AppStyles.Colors.accentFun)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(AppStyles.Colors.background.opacity(0.9)))
                        .background(Capsule().fill(AppStyles.Colors.accentFun).scaleEffect(1.1))
                        .offset(x: -40, y: 35)
                        .transition(.opacity.combined(with: .scale))
                    }
                }
            }
            .frame(width: 110, height: 110)
            .if(habit.canBeTappedToday) { view in
                view.simultaneousGesture(
                    TapGesture().onEnded { _ in onTap() }
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isPressed {
                                withAnimation(AppStyles.Animations.quick) { isPressed = true }
                            }
                        }
                        .onEnded { _ in
                            withAnimation(AppStyles.Animations.spring) { isPressed = false }
                        }
                )
            }
            .if(!habit.canBeTappedToday) { view in
                view.onTapGesture {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
            }
            .onAppear {
                if habit.isCompletedToday && !completionAnimationPlayed {
                    withAnimation(AppStyles.Animations.bounce.delay(0.2)) {
                        iconScale = 1.15
                        showCompletionEffect = true
                    }
                    withAnimation(AppStyles.Animations.smooth.delay(1.0)) {
                        iconScale = 1.0
                        showCompletionEffect = false
                    }
                    completionAnimationPlayed = true
                }
            }
            .onChange(of: habit.isCompletedToday) { completed in
                if completed && !completionAnimationPlayed {
                    withAnimation(AppStyles.Animations.bounce) {
                        iconScale = 1.15
                        showCompletionEffect = true
                    }
                    withAnimation(AppStyles.Animations.smooth.delay(1.0)) {
                        iconScale = 1.0
                        showCompletionEffect = false
                    }
                    completionAnimationPlayed = true
                } else if !completed {
                    completionAnimationPlayed = false
                    showCompletionEffect = false
                    iconScale = 1.0
                }
            }

            // Name label
            VStack {
                if habit.hasActiveSession && habit.dailyGoal?.type == .duration {
                    HStack(spacing: 4) {
                        Text(habit.name)
                            .font(Font.system(.caption, design: .rounded).weight(.medium))
                            .foregroundColor(AppStyles.Colors.text)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 70)
                        Text("STARTED")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Capsule().fill(Color.orange))
                            .transition(.scale.combined(with: .opacity))
                    }
                } else {
                    Text(habit.name)
                        .font(Font.system(.caption, design: .rounded).weight(.medium))
                        .foregroundColor(habit.isCompletedToday ? AppStyles.Colors.success : AppStyles.Colors.text)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 100)
                }
            }
            .padding(.top, 4)
        }
        .padding(.bottom, 20)
        .opacity(habit.canBeTappedToday ? 1.0 : 0.8)
    }

    // MARK: - Circle Background

    @ViewBuilder
    private var circleBackground: some View {
        if habit.isCompletedToday {
            completedCircleView
        } else if isCountType {
            countSegmentedRingView
        } else {
            incompleteCircleView
        }
    }

    // MARK: - Center Content

    /// For count-type: shows the habit icon stacked above a "filled/total" label.
    /// For completed: white checkmark. For all others: habit icon alone.
    @ViewBuilder
    private var centerContent: some View {
        if habit.isCompletedToday {
            Image(systemName: "checkmark")
                .font(.system(size: 36, weight: .semibold))
                .foregroundColor(.white)
                .scaleEffect(iconScale)
                .animation(AppStyles.Animations.spring, value: iconScale)

        } else if isCountType {
            let goal = habit.dailyGoal!
            // Express progress as taps (filled/total) so "10/10" for water rather than "200/200".
            let totalSegments = max(1, goal.target / goal.increment)
            let filledSegments = min(habit.todayProgress.current / goal.increment, totalSegments)

            VStack(spacing: 2) {
                Image(systemName: iconName)
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(AppStyles.Colors.primary)
                Text("\(filledSegments)/\(totalSegments)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundColor(AppStyles.Colors.primary)
            }
            .scaleEffect(iconScale)
            .animation(AppStyles.Animations.spring, value: iconScale)

        } else {
            Image(systemName: iconName)
                .font(.system(size: 36, weight: .medium))
                .foregroundColor(habit.hasActiveSession ? .orange : AppStyles.Colors.primary)
                .scaleEffect(iconScale)
                .animation(AppStyles.Animations.spring, value: iconScale)
        }
    }

    // MARK: - Segmented Ring (count type only)

    /// Each segment is an independent trimmed arc so segment boundaries are
    /// defined by exact fractions (i/N … i/N + filledFraction/N) with no
    /// floating-point accumulation. The old single-trim + dash approach
    /// caused a visible bleed into the next segment because 2π×r / N is
    /// irrational, making the trim boundary miss the gap by a few pixels.
    private var countSegmentedRingView: some View {
        let goal           = habit.dailyGoal!
        let totalSegments  = max(1, goal.target / goal.increment)
        let filledSegments = min(habit.todayProgress.current / goal.increment, totalSegments)

        let lineWidth: CGFloat = 6
        let diameter: CGFloat  = 100
        // Each segment occupies 1/N of the circle; the painted arc is 82 % of
        // that slot and the remaining 18 % is the gap (left unpainted).
        let paintedFraction: CGFloat = 0.82 / CGFloat(totalSegments)

        return ZStack {
            Circle()
                .fill(AppStyles.Colors.secondaryBackground)
                .frame(width: diameter, height: diameter)

            ForEach(0..<totalSegments, id: \.self) { i in
                let slotStart = CGFloat(i) / CGFloat(totalSegments)
                Circle()
                    .trim(from: slotStart, to: slotStart + paintedFraction)
                    .stroke(
                        i < filledSegments
                            ? AppStyles.Colors.primary
                            : AppStyles.Colors.primary.opacity(0.15),
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .butt)
                    )
                    .frame(width: diameter, height: diameter)
                    .rotationEffect(.degrees(-90))
                    .animation(AppStyles.Animations.spring, value: filledSegments)
            }
        }
        .shadow(color: AppStyles.Colors.primary.opacity(0.2), radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .animation(AppStyles.Animations.spring, value: isPressed)
    }

    // MARK: - Standard Circle Variants

    private var completedCircleView: some View {
        Circle()
            .fill(AppStyles.Colors.success)
            .frame(width: 100, height: 100)
            .shadow(color: AppStyles.Colors.success.opacity(0.3), radius: 8, x: 0, y: 4)
    }

    private var incompleteCircleView: some View {
        Circle()
            .fill(AppStyles.Colors.secondaryBackground)
            .frame(width: 100, height: 100)
            .overlay(
                Circle()
                    .stroke(
                        habit.hasActiveSession ? Color.orange : AppStyles.Colors.primary,
                        lineWidth: isPressed ? 4 : 3
                    )
                    .opacity(0.7)
            )
            .shadow(
                color: habit.hasActiveSession ? Color.orange.opacity(0.2) : AppStyles.Colors.primary.opacity(0.2),
                radius: 8, x: 0, y: 4
            )
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .animation(AppStyles.Animations.spring, value: isPressed)
    }

    // MARK: - Progress Badge

    /// Count-type habits display their progress inside the ring center, so they
    /// are excluded here. Duration and volume types still get the capsule badge.
    @ViewBuilder
    private var progressIndicator: some View {
        if habit.hasProgressTracking && habit.dailyGoal?.type != .count {
            Text(habit.progressDisplayText)
                .font(.system(size: 12, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(Capsule().fill(AppStyles.Colors.primary))
                .offset(x: 40, y: -25)
                .transition(.scale.combined(with: .opacity))
        }
    }

    // MARK: - Starburst

    private var starburstView: some View {
        ZStack {
            ForEach(0..<8) { i in
                Rectangle()
                    .fill(AppStyles.Colors.success.opacity(0.4))
                    .frame(width: 2, height: 12)
                    .offset(y: -48)
                    .rotationEffect(.degrees(Double(i) * 45))
                    .scaleEffect(showCompletionEffect ? 1.2 : 0.0)
                    .opacity(showCompletionEffect ? 1.0 : 0.0)
            }
        }
        .animation(AppStyles.Animations.bounce, value: showCompletionEffect)
    }
}

extension View {
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
