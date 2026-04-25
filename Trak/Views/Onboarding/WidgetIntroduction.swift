//
//  WidgetIntroduction.swift
//  Trak
//
//  Created by Ege Özçelik on 29.09.2025.
//

// WidgetPromotionView.swift
import SwiftUI

struct WidgetPromotionView: View {
    @Binding var isPresented: Bool
    @State private var animateWidgets = false
    @State private var showContent = false
    @State private var pulseAnimation = false
    
    var body: some View {
        ZStack {
            // Background with gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.05, green: 0.05, blue: 0.1),
                    Color(red: 0.1, green: 0.1, blue: 0.15)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Decorative background circles
            Circle()
                .fill(Color(red: 0.41, green: 0.91, blue: 0.85).opacity(0.05))
                .frame(width: 300, height: 300)
                .offset(x: -100, y: -200)
                .blur(radius: 60)
            
            Circle()
                .fill(Color(red: 0.13, green: 0.82, blue: 0.40).opacity(0.05))
                .frame(width: 250, height: 250)
                .offset(x: 120, y: 250)
                .blur(radius: 50)
            
            
                VStack(spacing: 10) {
                    Spacer(minLength: 20)
                    
                    // Header
                    VStack(spacing: 12) {
                        Image(systemName: "widget.small.fill")
                            .font(.system(size: 50, weight: .light))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.41, green: 0.91, blue: 0.85),
                                        Color(red: 0.13, green: 0.82, blue: 0.40)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .opacity(showContent ? 1 : 0)
                            .scaleEffect(showContent ? 1 : 0.5)
                            .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: showContent)
                        
                        Text("Try Our Widgets!")
                            .font(.system(size: 34, weight: .medium, design: .default))
                            .foregroundColor(.white)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.2), value: showContent)
                        
                        Text("Track your habits right from your home screen")
                            .font(.system(size: 16, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.7))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                            .opacity(showContent ? 1 : 0)
                            .offset(y: showContent ? 0 : 20)
                            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.3), value: showContent)
                    }
                    .padding(.bottom, 0)
                    
                    // Widget Previews with scattered layout
                    ZStack {
                        // Small Widget - Top Left
                        
                        
                        // Medium Widget - Center Right
                        MediumWidgetPreview()
                            .frame(width: 280, height: 120)
                            .offset(x: 30, y: 25)
                            .rotationEffect(.degrees(5))
                            .opacity(animateWidgets ? 1 : 0)
                            .offset(y: animateWidgets ? 0 : 50)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.6), value: animateWidgets)
                        
                        // Large Widget - Bottom Left
                        LargeWidgetPreview()
                            .frame(width: 280, height: 280)
                            .offset(x: -30, y: 230)
                            .rotationEffect(.degrees(-3))
                            .opacity(animateWidgets ? 1 : 0)
                            .offset(y: animateWidgets ? 0 : 50)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.8), value: animateWidgets)
                        
                        SmallWidgetPreview()
                            .frame(width: 140, height: 120)
                            .offset(x: -80, y: -100)
                            .rotationEffect(.degrees(-8))
                            .opacity(animateWidgets ? 1 : 0)
                            .offset(y: animateWidgets ? 0 : 50)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4), value: animateWidgets)
                    }
                    .frame(height: 500)
                    
                    Spacer(minLength: 40)
                    
                    
                   
                }
            
            
            // Close button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                            .frame(width: 36, height: 36)
                            .background(Color.white.opacity(0.1))
                            .clipShape(Circle())
                    }
                    .padding(.top, 50)
                    .padding(.trailing, 24)
                }
                Spacer()
            }
            .opacity(showContent ? 1 : 0)
            .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.5), value: showContent)
        }
        .onAppear {
            withAnimation {
                showContent = true
                animateWidgets = true
                pulseAnimation = true
            }
        }
    }
    
    private func dismiss() {
        withAnimation {
            isPresented = false
        }
    }
}

// MARK: - Small Widget Preview
struct SmallWidgetPreview: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
            
            VStack(spacing: 8) {
                Text("Today")
                    .font(.system(size: 10, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.8))
                
                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 6)
                        .frame(width: 60, height: 60)
                    
                    Circle()
                        .trim(from: 0, to: 0.6)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.41, green: 0.91, blue: 0.85),
                                    Color(red: 0.13, green: 0.82, blue: 0.40)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            style: StrokeStyle(lineWidth: 6, lineCap: .round)
                        )
                        .frame(width: 60, height: 60)
                        .rotationEffect(.degrees(-90))
                    
                    VStack(spacing: 1) {
                        Text("3")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                        
                        Text("/ 5")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                }
                
                Text("completed")
                    .font(.system(size: 8, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.6))
            }
        }
    }
}

// MARK: - Medium Widget Preview
struct MediumWidgetPreview: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
            
            VStack(spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Today's Habits")
                            .font(.system(size: 12, weight: .semibold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.mint, .white],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        Divider()
                        
                        Text("3/4 completed")
                            .font(.system(size: 9, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    Text("75%")
                        .font(.system(size: 8, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .frame(width: 28, height: 28)
                        .background(
                            Circle()
                                .stroke(Color(red: 0.13, green: 0.82, blue: 0.40), lineWidth: 2)
                        )
                }
                .padding(.horizontal, 14)
                .padding(.top, 10)
                
                HStack(spacing: 12) {
                    HabitCirclePreview(icon: "book.fill", isCompleted: true)
                    HabitCirclePreview(icon: "drop.fill", isCompleted: false)
                    HabitCirclePreview(icon: "figure.run", isCompleted: true)
                    HabitCirclePreview(icon: "figure.mind.and.body", isCompleted: true)
                }
                .padding(.horizontal, 14)
                .padding(.bottom, 10)
            }
        }
    }
}

// MARK: - Large Widget Preview
struct LargeWidgetPreview: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.black)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.white.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 8)
            
            VStack(spacing: 12) {
                HStack {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Today's Habits")
                            .font(.system(size: 14, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.mint, .white],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                        Divider()
                        Text("Monday, September 30")
                            .font(.system(size: 10, weight: .medium, design: .rounded))
                            .foregroundColor(.white.opacity(0.6))
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(Color.white.opacity(0.2), lineWidth: 4)
                            .frame(width: 45, height: 45)
                        
                        Circle()
                            .trim(from: 0, to: 0.6)
                            .stroke(
                                LinearGradient(
                                    colors: [
                                        Color(red: 0.41, green: 0.91, blue: 0.85),
                                        Color(red: 0.13, green: 0.82, blue: 0.40)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .frame(width: 45, height: 45)
                            .rotationEffect(.degrees(-90))
                        
                        VStack(spacing: 0) {
                            Text("3")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(.white)
                            
                            Text("/ 6")
                                .font(.system(size: 8, weight: .medium, design: .rounded))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 14)
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12),
                    GridItem(.flexible(), spacing: 12)
                ], spacing: 12) {
                    HabitCirclePreview(icon: "book.fill", isCompleted: true)
                    HabitCirclePreview(icon: "drop.fill", isCompleted: false)
                    HabitCirclePreview(icon: "figure.run", isCompleted: true)
                    HabitCirclePreview(icon: "figure.mind.and.body", isCompleted: true)
                    HabitCirclePreview(icon: "figure.cooldown", isCompleted: false)
                    HabitCirclePreview(icon: "bed.double.fill", isCompleted: false)
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
        }
    }
}

// MARK: - Habit Circle Preview Component
struct HabitCirclePreview: View {
    let icon: String
    let isCompleted: Bool
    
    var body: some View {
        VStack(spacing: 3) {
            ZStack {
                Circle()
                    .fill(isCompleted ? Color(red: 0.13, green: 0.82, blue: 0.40).opacity(0.2) : Color.white.opacity(0.05))
                    .frame(width: 40, height: 40)
                
                Circle()
                    .stroke(
                        isCompleted ? Color(red: 0.13, green: 0.82, blue: 0.40) : Color.white.opacity(0.2),
                        lineWidth: isCompleted ? 2 : 1.5
                    )
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isCompleted ? Color(red: 0.13, green: 0.82, blue: 0.40) : .white.opacity(0.8))
                
                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color(red: 0.13, green: 0.82, blue: 0.40))
                        .background(Circle().fill(Color(red: 0.15, green: 0.15, blue: 0.2)).frame(width: 12, height: 12))
                        .offset(x: 16, y: -16)
                }
            }
            
            Text(isCompleted ? "Done" : "Todo")
                .font(.system(size: 7, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.6))
        }
    }
}

// MARK: - Instruction Row Component
struct InstructionRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(Color(red: 0.41, green: 0.91, blue: 0.85))
                .frame(width: 44, height: 44)
                .background(Color(red: 0.41, green: 0.91, blue: 0.85).opacity(0.1))
                .clipShape(Circle())
            
            Text(text)
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .background(Color.white.opacity(0.05))
        .cornerRadius(16)
    }
}

// MARK: - Preview
struct WidgetPromotionView_Previews: PreviewProvider {
    static var previews: some View {
        WidgetPromotionView(isPresented: .constant(true))
    }
}
