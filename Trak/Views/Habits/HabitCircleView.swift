// HabitCircleView.swift - Badge Konumları Düzenlenmiş
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
    
    private var completionColor: Color {
        if habit.hasActiveSession && habit.dailyGoal?.type == .duration {
            return Color.orange
        }
        
        switch habit.todayCompletionStatus {
        case .notCompleted:
            return AppStyles.Colors.primary
        case .completedOnTime:
            return AppStyles.Colors.success
        case .completedLate:
            return Color.yellow
        }
    }
    
    private var backgroundGradient: Gradient {
        switch habit.todayCompletionStatus {
        case .notCompleted:
            return Gradient(colors: [
                AppStyles.Colors.secondaryBackground,
                AppStyles.Colors.secondaryBackground.opacity(0.7)
            ])
        case .completedOnTime:
            return Gradient(colors: [
                AppStyles.Colors.success.opacity(0.2),
                AppStyles.Colors.success.opacity(0.3)
            ])
        case .completedLate:
            return Gradient(colors: [
                Color.yellow.opacity(0.2),
                Color.yellow.opacity(0.3)
            ])
        }
    }
    
    private var shadowColor: Color {
        switch habit.todayCompletionStatus {
        case .notCompleted:
            return AppStyles.Colors.primary.opacity(0.2)
        case .completedOnTime:
            return AppStyles.Colors.success.opacity(0.3)
        case .completedLate:
            return Color.yellow.opacity(0.3)
        }
    }

    var body: some View {
        VStack {
            ZStack {
                // Progress tracking için özel view
                if habit.hasProgressTracking {
                    progressCircleView
                } else {
                    regularCircleView
                }
                
                // Custom frequency circles - ana circle'ın etrafında
                if habit.frequency == .custom {
                    CustomFrequencyCircles(habit: habit)
                }
                
                // Starburst effect - only show on completion
                if habit.isCompletedToday && showCompletionEffect {
                    ZStack {
                        ForEach(0..<8) { i in
                            Rectangle()
                                .fill(completionColor.opacity(0.4))
                                .frame(width: 2, height: 12)
                                .offset(y: -48)
                                .rotationEffect(.degrees(Double(i) * 45))
                                .scaleEffect(showCompletionEffect ? 1.2 : 0.0)
                                .opacity(showCompletionEffect ? 1.0 : 0.0)
                        }
                    }
                    .animation(AppStyles.Animations.bounce, value: showCompletionEffect)
                }

                // Ana icon
                Image(systemName: iconName)
                    .font(.system(size: 36, weight: .medium))
                    .foregroundColor(completionColor)
                    .scaleEffect(iconScale)
                    .animation(AppStyles.Animations.spring, value: iconScale)
                
                // Progress indicator (saat 2 - mevcut konum)
                progressIndicator
                
                // Late completion badge (saat 4 - completion badge'in altında)
                if habit.isCompletedToday && habit.todayCompletionStatus == .completedLate {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .padding(5)
                        .background(Circle().fill(Color.orange))
                        .offset(x: 45, y: 25) // Saat 4 konumu
                        .transition(.scale.combined(with: .opacity))
                }
                
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
                    .background(
                        Capsule()
                            .fill(AppStyles.Colors.primary)
                    )
                    .offset(x: -40, y: -25) // Saat 10 konumu
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
                    .background(
                        Capsule()
                            .fill(AppStyles.Colors.background.opacity(0.9))
                    )
                    .background(
                        Capsule()
                            .fill(AppStyles.Colors.accentFun)
                            .scaleEffect(1.1)
                    )
                    .offset(x: -40, y: 35) // Daha yakın
                    .transition(.opacity.combined(with: .scale))
                }
            }
            .frame(width: 110, height: 110)
            
            .if(habit.canBeTappedToday) { view in
                view.simultaneousGesture(
                    TapGesture()
                        .onEnded { _ in
                            onTap()
                        }
                )
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in
                            if !isPressed {
                                withAnimation(AppStyles.Animations.quick) {
                                    isPressed = true
                                }
                            }
                        }
                        .onEnded { _ in
                            withAnimation(AppStyles.Animations.spring) {
                                isPressed = false
                            }
                        }
                )
            }
            .if(!habit.canBeTappedToday) { view in
                view.onTapGesture {
                    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
                    impactFeedback.impactOccurred()
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
            
            
            
            // Habit name ve started badge'i (boşluk azaltıldı)
            VStack {
                if habit.hasActiveSession && habit.dailyGoal?.type == .duration {
                    HStack(spacing: 4) {
                        Text(habit.name)
                            .font(Font.system(.caption, design: .rounded).weight(.medium))
                            .foregroundColor(habit.isCompletedToday ? completionColor : AppStyles.Colors.text)
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 70)
                        
                        Text("STARTED")
                            .font(.system(size: 9, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule()
                                    .fill(Color.orange)
                            )
                            .transition(.scale.combined(with: .opacity))
                    }
                } else {
                    Text(habit.name)
                        .font(Font.system(.caption, design: .rounded).weight(.medium))
                        .foregroundColor(habit.isCompletedToday ? completionColor : AppStyles.Colors.text)
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
    
    private var progressCircleView: some View {
        ZStack {
            Circle()
                .fill(AppStyles.Colors.secondaryBackground)
                .frame(width: 100, height: 100)
            
            Circle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            AppStyles.Colors.success.opacity(0.2),
                            AppStyles.Colors.success.opacity(0.3)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
                .frame(width: 100, height: 100)
                .mask(
                    Rectangle()
                        .frame(height: 100 * habit.todayProgressPercentage)
                        .offset(y: 50 * (1 - habit.todayProgressPercentage))
                )
                .animation(AppStyles.Animations.spring, value: habit.todayProgressPercentage)
            
            Circle()
                .stroke(
                    habit.isCompletedToday ? completionColor : AppStyles.Colors.primary,
                    lineWidth: isPressed ? 4 : 3
                )
                .frame(width: 100, height: 100)
                .opacity(habit.isCompletedToday ? 1 : 0.7)
        }
        .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
        .scaleEffect(isPressed ? 0.92 : 1.0)
        .animation(AppStyles.Animations.spring, value: isPressed)
    }
    
    // Normal circle view
    private var regularCircleView: some View {
        Circle()
            .fill(LinearGradient(
                gradient: backgroundGradient,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            ))
            .frame(width: 100, height: 100)
            .overlay(
                Circle()
                    .stroke(
                        completionColor,
                        lineWidth: isPressed ? 4 : 3
                    )
                    .opacity(habit.isCompletedToday ? 1 : 0.7)
            )
            .shadow(color: shadowColor, radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.92 : 1.0)
            .animation(AppStyles.Animations.spring, value: isPressed)
    }
    
    // Progress indicator (saat 2 konumu)
    @ViewBuilder
    private var progressIndicator: some View {
        if habit.hasProgressTracking {
            Text(habit.isCompletedToday ? "✓" : habit.progressDisplayText)
                .font(.system(size: habit.isCompletedToday ? 16 : 12, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(
                    Capsule()
                        .fill(habit.isCompletedToday ? AppStyles.Colors.success : AppStyles.Colors.primary)
                )
                .offset(x: 40, y: -25) // Saat 2 konumu
                .transition(.scale.combined(with: .opacity))
        } else if habit.isCompletedToday {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(completionColor)
                .padding(4)
                .background(Circle().fill(AppStyles.Colors.background.opacity(0.85)))
                .offset(x: 40, y: -25) // Saat 2 konumu
                .transition(.scale.combined(with: .opacity))
        }
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
