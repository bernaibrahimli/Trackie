// AppStyles.swift
import SwiftUI

struct AppStyles {
    struct Colors {
        
        static let primary = Color.mint // Indigo
        static let secondary = Color(red: 255/255, green: 94/255, blue: 120/255) // Vibrant coral
        
        static let accentFun = Color(red: 255/255, green: 198/255, blue: 0/255) // Bright yellow
        
        static let success = Color(red: 32/255, green: 209/255, blue: 103/255) // Vibrant green
        
        static let error = Color(red: 255/255, green: 59/255, blue: 59/255) // Bright red
        
        static let background = Color(.systemBackground)
 
        static let secondaryBackground = Color(.systemGray6)
        
        static let text = Color.primary
        static let secondaryText = Color.secondary
        static let lightText = Color.white
        
        static let gradient1 = Color.mint
        static let gradient2 = Color(red: 105/255, green: 70/255, blue: 245/255)
    }
    
    struct Typography {
        static let largeTitle = Font.largeTitle.weight(.bold)
        static let title = Font.title.weight(.heavy)
        static let headline = Font.headline.weight(.semibold)
        static let body = Font.body
        static let caption = Font.caption
        static let button = Font.system(.headline, design: .rounded).weight(.bold)
    }
    
    struct Dimensions {
        static let cornerRadius: CGFloat = 18
        static let buttonHeight: CGFloat = 56
        static let standardPadding: CGFloat = 16
        static let smallPadding: CGFloat = 8
        static let fabSize: CGFloat = 80
    }
    
    struct Animations {
        static let spring = Animation.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.3)
        
        static let bounce = Animation.spring(response: 0.4, dampingFraction: 0.5, blendDuration: 0)
        
        static let smooth = Animation.easeInOut(duration: 0.3)
        
        static let quick = Animation.easeOut(duration: 0.2)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    var disabled: Bool = false
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppStyles.Typography.button)
            .frame(maxWidth: .infinity)
            .frame(height: AppStyles.Dimensions.buttonHeight)
            .background(
                Group {
                    if disabled {
                        Color.gray.opacity(0.5)
                    } else if configuration.isPressed {
                        LinearGradient(
                            gradient: Gradient(colors: [AppStyles.Colors.gradient1.opacity(0.8), AppStyles.Colors.gradient2.opacity(0.8)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        LinearGradient(
                            gradient: Gradient(colors: [AppStyles.Colors.gradient1, AppStyles.Colors.gradient2]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    }
                }
            )
            .foregroundColor(AppStyles.Colors.lightText)
            .cornerRadius(AppStyles.Dimensions.cornerRadius)
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(AppStyles.Animations.spring, value: configuration.isPressed)
            .shadow(color: AppStyles.Colors.primary.opacity(disabled ? 0 : 0.3), radius: configuration.isPressed ? 2 : 8, x: 0, y: configuration.isPressed ? 1 : 4)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppStyles.Typography.button)
            .frame(maxWidth: .infinity)
            .frame(height: AppStyles.Dimensions.buttonHeight)
            .background(
                configuration.isPressed ?
                    AppStyles.Colors.secondaryBackground.opacity(0.7) :
                    AppStyles.Colors.secondaryBackground
            )
            .foregroundColor(AppStyles.Colors.primary) // Text color for secondary button
            .cornerRadius(AppStyles.Dimensions.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                    .stroke(AppStyles.Colors.primary.opacity(0.6), lineWidth: 2) // More visible border
            )
            .scaleEffect(configuration.isPressed ? 0.96 : 1)
            .animation(AppStyles.Animations.spring, value: configuration.isPressed)
            .shadow(color: AppStyles.Colors.primary.opacity(0.1), radius: 4, x: 0, y: 2)
    }
}

// Card view for habits and stats
struct CardView<Content: View>: View {
    let content: Content
    var backgroundColor: Color = AppStyles.Colors.secondaryBackground // Default background
    var addStroke: Bool = false // Optional stroke for emphasis
    var addShadow: Bool = true // Optional shadow

    init(backgroundColor: Color = AppStyles.Colors.secondaryBackground, addStroke: Bool = false, addShadow: Bool = true, @ViewBuilder content: () -> Content) {
        self.backgroundColor = backgroundColor
        self.addStroke = addStroke
        self.addShadow = addShadow
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(AppStyles.Dimensions.standardPadding)
            .background(backgroundColor)
            .cornerRadius(AppStyles.Dimensions.cornerRadius)
            .shadow(color: addShadow ? Color.black.opacity(0.08) : Color.clear, radius: 10, x: 0, y: 5) // Enhanced shadow
            .overlay(
                addStroke ?
                    RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                        .stroke(AppStyles.Colors.primary.opacity(0.3), lineWidth: 1.5)
                    : nil
            )
    }
}

// Badge for streak counts - Bolder and Fun
struct StreakBadge: View {
    let count: Int
    @State private var animationAmount = 1.0
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "flame.fill")
                .foregroundColor(AppStyles.Colors.accentFun) // Using fun accent color
                .font(.headline)
                .scaleEffect(animationAmount)
                .onAppear {
                    withAnimation(
                        AppStyles.Animations.bounce.repeatCount(3, autoreverses: true)
                    ) {
                        animationAmount = 1.2
                    }
                }
            
            Text("\(count)")
                .font(Font.system(.caption, design: .rounded).weight(.bold)) // Rounded font
                .foregroundColor(AppStyles.Colors.accentFun) // Using fun accent color
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            Capsule()
                .fill(AppStyles.Colors.accentFun.opacity(0.15)) // Lighter background of accent
        )
    }
}

// Status view for habit completion - More visual
struct StatusIndicator: View {
    let completed: Bool
    let dueToday: Bool
    @State private var animateCheckmark = false
    
    var body: some View {
        ZStack {
            Circle()
                .fill(completed ? AppStyles.Colors.success : (dueToday ? AppStyles.Colors.primary.opacity(0.15) : AppStyles.Colors.secondaryBackground))
                .frame(width: 34, height: 34) // Slightly larger
                .shadow(color: completed ? AppStyles.Colors.success.opacity(0.3) : Color.clear, radius: 5, x: 0, y: 2)
            
            if completed {
                Image(systemName: "checkmark")
                    .font(.body.weight(.bold))
                    .foregroundColor(AppStyles.Colors.lightText) // White checkmark on success
                    .scaleEffect(animateCheckmark ? 1.2 : 0.8)
                    .opacity(animateCheckmark ? 1 : 0)
                    .onAppear {
                        withAnimation(AppStyles.Animations.bounce.delay(0.1)) {
                            animateCheckmark = true
                        }
                    }
            } else if dueToday {
                Circle() // Inner circle for "due" state
                    .fill(AppStyles.Colors.primary)
                    .frame(width: 12, height: 12)
            } else {
                 // Optional: an icon for "not due" or "upcoming"
                 Image(systemName: "circle.dashed")
                    .font(.body.weight(.light))
                    .foregroundColor(Color.gray.opacity(0.7))
            }
        }
        .animation(AppStyles.Animations.spring, value: completed)
        .animation(AppStyles.Animations.spring, value: dueToday)
    }
}
