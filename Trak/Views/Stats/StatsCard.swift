// StatCard.swift
import SwiftUI

// Stats card view - V3 (Enhanced with animations and visuals)

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color // This will be the primary color for the icon/text
    let iconBackgroundColor: Color // Background for the icon shape
    
    // Animation states
    @State private var showValue = false
    @State private var iconRotation = 0.0
    @State private var iconScale = 0.8
    
    var body: some View {
        CardView(backgroundColor: AppStyles.Colors.secondaryBackground.opacity(0.7)) {
            VStack(alignment: .leading, spacing: AppStyles.Dimensions.smallPadding) {
                HStack {
                    Text(title.uppercased()) // Uppercased for a bolder look
                        .font(Font.system(.caption, design: .rounded).weight(.medium))
                        .foregroundColor(AppStyles.Colors.secondaryText)
                    
                    Spacer()
                    
                    // Icon with a shaped background and animation
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        iconBackgroundColor.opacity(0.15),
                                        iconBackgroundColor.opacity(0.25)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 42, height: 42)
                            .shadow(color: iconBackgroundColor.opacity(0.3), radius: 4, x: 0, y: 2)
                        
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(color) // Use the main color for the icon
                            .rotationEffect(.degrees(iconRotation))
                            .scaleEffect(iconScale)
                    }
                    .onAppear {
                        // Icon appearance animation
                        withAnimation(AppStyles.Animations.spring.delay(0.1)) {
                            iconScale = 1.0
                            iconRotation = 360
                        }
                    }
                }
                
                Spacer().frame(height: AppStyles.Dimensions.smallPadding) // Add some space
                
                HStack(alignment: .lastTextBaseline, spacing: AppStyles.Dimensions.smallPadding / 2) {
                    // Value with counting animation effect
                    Text(showValue ? value : "0")
                        .font(Font.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(color) // Value takes the main color
                        .onAppear {
                            withAnimation(Animation.easeOut(duration: 1.2).delay(0.2)) {
                                showValue = true
                            }
                        }
                    
                    Text(subtitle)
                        .font(Font.system(.footnote, design: .rounded).weight(.medium))
                        .foregroundColor(AppStyles.Colors.secondaryText)
                    
                    Spacer()
                }
            }
            .frame(height: 120)
        }
        .clipShape(Rectangle())
        .shadow(color: color.opacity(0.15), radius: 8, x: 0, y: 10)
        .scaleEffect(showValue ? 1.0 : 0.95)
        .animation(AppStyles.Animations.spring.delay(0.1), value: showValue)
    }
}

/*
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color // This will be the primary color for the icon/text
    let iconBackgroundColor: Color // Background for the icon shape
    
    // Animation states
    @State private var showValue = false
    @State private var iconRotation = 0.0
    @State private var iconScale = 0.8
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                .fill(.ultraThinMaterial)
                .shadow(color: Color.black.opacity(0.1), radius: 20, x: 0, y: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.3),
                                    Color.clear,
                                    Color.white.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
            
            VStack(alignment: .leading, spacing: AppStyles.Dimensions.smallPadding) {
                HStack {
                    Text(title.uppercased())
                        .font(Font.system(.caption, design: .rounded).weight(.medium))
                        .foregroundColor(.white.opacity(0.7)) // Glass effect için beyaz metin
                    
                    Spacer()
                    
                    // Icon with glass effect background
                    ZStack {
                        Circle()
                            .fill(.thickMaterial)
                            .frame(width: 42, height: 42)
                            .overlay(
                                Circle()
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.white.opacity(0.4),
                                                Color.clear
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            )
                        
                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .medium))
                            .foregroundColor(color)
                            .rotationEffect(.degrees(iconRotation))
                            .scaleEffect(iconScale)
                    }
                    .onAppear {
                        withAnimation(AppStyles.Animations.spring.delay(0.1)) {
                            iconScale = 1.0
                            iconRotation = 360
                        }
                    }
                }
                
                Spacer().frame(height: AppStyles.Dimensions.smallPadding)
                
                HStack(alignment: .lastTextBaseline, spacing: AppStyles.Dimensions.smallPadding / 2) {
                    // Value with counting animation effect
                    Text(showValue ? value : "0")
                        .font(Font.system(size: 36, weight: .bold, design: .rounded))
                        .foregroundColor(.white) // Glass effect için beyaz değer
                        .onAppear {
                            withAnimation(Animation.easeOut(duration: 1.2).delay(0.2)) {
                                showValue = true
                            }
                        }
                    
                    Text(subtitle)
                        .font(Font.system(.footnote, design: .rounded).weight(.medium))
                        .foregroundColor(.white.opacity(0.6)) // Glass effect için beyaz alt başlık
                    
                    Spacer()
                }
            }
            .padding(AppStyles.Dimensions.standardPadding)
        }
        // Add glow effect
        .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
        // Add hover effect
        .scaleEffect(showValue ? 1.0 : 0.95)
        .animation(AppStyles.Animations.spring.delay(0.1), value: showValue)
    }
}
*/
struct StatCard_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StatCard(
                title: "Current Streak",
                value: "7",
                subtitle: "days",
                icon: "flame.fill",
                color: AppStyles.Colors.accentFun, // Gold for streak
                iconBackgroundColor: AppStyles.Colors.accentFun
            )
            .frame(width: 180, height: 120)
            .padding()
            .previewLayout(.sizeThatFits)

            StatCard(
                title: "Completion Rate",
                value: "85%",
                subtitle: "today",
                icon: "checkmark.circle.fill", // More direct success icon
                color: AppStyles.Colors.success, // Green for completion
                iconBackgroundColor: AppStyles.Colors.success
            )
            .frame(width: 180, height: 120)
            .padding()
            .previewLayout(.sizeThatFits)
            
            StatCard(
                title: "Total Habits",
                value: "12",
                subtitle: "active",
                icon: "list.star", // A more engaging list icon
                color: AppStyles.Colors.primary, // Primary color for general info
                iconBackgroundColor: AppStyles.Colors.primary
            )
            .frame(width: 180, height: 120)
            .padding()
            .previewLayout(.sizeThatFits)
        }
        .background(AppStyles.Colors.secondaryBackground)
    }
}
