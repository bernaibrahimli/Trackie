// HabitRowView.swift
import SwiftUI

// Row view for a single habit - V3 (Enhanced with animations)
struct HabitRowView: View {
    // The habit to display
    let habit: Habit
    
    // Animation states
    @State private var isPressed = false
    @State private var showBounceAnimation = false
    
    var body: some View {
        // Enhanced CardView with shadow and animations
        CardView(backgroundColor: AppStyles.Colors.background, addStroke: true, addShadow: true) {
            HStack(spacing: AppStyles.Dimensions.standardPadding) {
                // Left side: Habit icon, name, frequency, and streak badge
                HStack(spacing: AppStyles.Dimensions.standardPadding) {
                    // Icon Circle
                    ZStack {
                        Circle()
                            .fill(isCompleted
                                  ? AppStyles.Colors.success.opacity(0.15)
                                  : AppStyles.Colors.primary.opacity(0.1))
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: getIconName(for: habit.name))
                            .font(.system(size: 20))
                            .foregroundColor(isCompleted
                                            ? AppStyles.Colors.success
                                            : AppStyles.Colors.primary)
                            .scaleEffect(showBounceAnimation ? 1.2 : 1.0)
                            .animation(
                                showBounceAnimation
                                ? AppStyles.Animations.bounce
                                : .default,
                                value: showBounceAnimation
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: AppStyles.Dimensions.smallPadding / 2) {
                        Text(habit.name)
                            .font(AppStyles.Typography.headline)
                            .foregroundColor(AppStyles.Colors.text)
                        
                        Text(habit.frequency.rawValue.capitalized) // e.g., "Daily", "Morning"
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                        
                        if habit.streak > 0 {
                            StreakBadge(count: habit.streak)
                                .padding(.top, AppStyles.Dimensions.smallPadding / 2)
                        }
                    }
                }
                
                Spacer() // Pushes status indicator to the right
                
                // Right side: Status indicator for completion
                StatusIndicator(
                    completed: isCompleted,
                    dueToday: habit.shouldCompleteToday
                )
            }
            .padding(.vertical, AppStyles.Dimensions.smallPadding)
            .contentShape(Rectangle()) // Make entire row tappable
        }
        // Card press effect
        .scaleEffect(isPressed ? 0.97 : 1.0)
        .animation(AppStyles.Animations.spring, value: isPressed)
        // These modifiers are important when HabitRowView is used within a List
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .padding(.horizontal, AppStyles.Dimensions.standardPadding)
        .padding(.vertical, AppStyles.Dimensions.smallPadding / 2)
        .onAppear {
            // Delayed animation to get attention if completed
            if isCompleted {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    showBounceAnimation = true
                }
            }
        }
        // Add gesture handling for press effect
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    withAnimation(AppStyles.Animations.quick) {
                        isPressed = true
                    }
                }
                .onEnded { _ in
                    withAnimation(AppStyles.Animations.spring) {
                        isPressed = false
                    }
                }
        )
    }
    
    // Helper to check if the habit is completed today
    private var isCompleted: Bool {
        guard let lastCompleted = habit.lastCompleted else { return false }
        return Calendar.current.isDateInToday(lastCompleted)
    }
    
    // Helper to get icon name (borrowed from HabitStore)
    private func getIconName(for habitName: String) -> String {
        let habitLower = habitName.lowercased()
        
        if habitLower.contains("brush") && habitLower.contains("teeth") { return "mouth" }
        if habitLower.contains("run") || habitLower.contains("jog") { return "figure.run" }
        if habitLower.contains("drink") && habitLower.contains("water") { return "drop.fill" }
        if habitLower.contains("read") || habitLower.contains("book") { return "book.fill" }
        if habitLower.contains("meditate") { return "figure.mind.and.body" }
        if habitLower.contains("exercise") || habitLower.contains("workout") { return "figure.cooldown" }
        if habitLower.contains("eat") && habitLower.contains("healthy") { return "leaf.fill" }
        if habitLower.contains("water") && habitLower.contains("plant") { return "sprinkler.and.droplets.fill" }
        if habitLower.contains("journal") { return "pencil.and.scribble"}
        if habitLower.contains("novel") { return "book.closed.fill"}
        if habitLower.contains("vitamin") { return "pills.fill"}
        if habitLower.contains("mobilise") || habitLower.contains("stretch") { return "figure.flexibility" }

        // Fallback to a generic icon
        return "list.star"
    }
}

