// SplashScreen.swift
/*import SwiftUI

struct SplashScreen: View {
    @Binding var isActive: Bool
    @State private var logoScale = 0.0
    @State private var logoRotation = -30.0
    @State private var textOpacity = 0.0
    @State private var backgroundCircleScale = 0.0
    @State private var iconOffset = [CGSize](repeating: CGSize(width: 0, height: 0), count: 3)
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    AppStyles.Colors.gradient1,
                    AppStyles.Colors.gradient2
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
            
            // Background circle
            Circle()
                .fill(Color.white.opacity(0.1))
                .frame(width: 300, height: 300)
                .scaleEffect(backgroundCircleScale)
                .animation(Animation.easeOut(duration: 0.7), value: backgroundCircleScale)
            
            VStack(spacing: 20) {
                // App logo
                ZStack {
                    // Logo circle
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.white.opacity(0.95),
                                    Color.white.opacity(0.8)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 130, height: 130)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    // Logo icons that animate in
                    Group {
                        // First icon - flame (streaks)
                        Image(systemName: "flame.fill")
                            .font(.system(size: 30, weight: .bold))
                            .foregroundColor(AppStyles.Colors.accentFun)
                            .offset(x: -25 + iconOffset[0].width, y: -25 + iconOffset[0].height)
                            .opacity(logoScale > 0.5 ? 1 : 0)
                        
                        // Second icon - checkmark (habits)
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 35, weight: .bold))
                            .foregroundColor(AppStyles.Colors.primary)
                            .offset(x: 25 + iconOffset[1].width, y: -15 + iconOffset[1].height)
                            .opacity(logoScale > 0.6 ? 1 : 0)
                        
                        // Third icon - camera (verification)
                        Image(systemName: "camera.fill")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(AppStyles.Colors.secondary)
                            .offset(x: 0 + iconOffset[2].width, y: 30 + iconOffset[2].height)
                            .opacity(logoScale > 0.7 ? 1 : 0)
                    }
                    
                    // App letter in center
                    Text("T")
                        .font(.system(size: 70, weight: .black, design: .rounded))
                        .foregroundColor(AppStyles.Colors.gradient1)
                }
                .scaleEffect(logoScale)
                .rotationEffect(.degrees(logoRotation))
                
                // App name
                VStack(spacing: 5) {
                    Text("Trackie")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text("DAILY HABIT TRACKER")
                        .font(.system(size: 14, weight: .bold, design: .rounded))
                        .kerning(3)
                        .foregroundColor(.white.opacity(0.8))
                }
                .opacity(textOpacity)
            }
        }
        .onAppear {
            // Animate elements in sequence
            withAnimation(Animation.spring(response: 0.7, dampingFraction: 0.6).delay(0.1)) {
                backgroundCircleScale = 1.1
            }
            withAnimation(Animation.spring(response: 0.7, dampingFraction: 0.6).delay(0.3)) {
                logoScale = 1.0
                logoRotation = 0
            }
            withAnimation(Animation.easeIn.delay(0.7)) {
                textOpacity = 1.0
            }
            
            // Subtle icon floating animation
            withAnimation(
                Animation.easeInOut(duration: 2)
                    .repeatForever(autoreverses: true)
                    .delay(1.0)
            ) {
                iconOffset[0] = CGSize(width: 3, height: -2)
                iconOffset[1] = CGSize(width: -3, height: 2)
                iconOffset[2] = CGSize(width: 2, height: 3)
            }
            
            // Move to onboarding after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

struct SplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreen(isActive: .constant(false))
    }
}
*/
// SplashScreen.swift - Yeni Minimal Tasarım
import SwiftUI

struct SplashScreen: View {
    @Binding var isActive: Bool
    
    // Animation states
    @State private var logoOpacity = 0.0
    @State private var logoScale = 0.8
    @State private var showSubtitle = false
    @State private var shimmerOffset: CGFloat = -200
    @State private var subtitleProgress: CGFloat = 0
    
    private let subtitle = "Habits shape time, time shapes you."
    
    var body: some View {
        ZStack {
          
            Color.black
                .ignoresSafeArea()
            
            // Subtle background glow
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color(red: 0.41, green: 0.91, blue: 0.85).opacity(0.03),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 300
                    )
                )
                .frame(width: 600, height: 600)
                .blur(radius: 80)
            
            VStack(spacing: 0) {
                Spacer()
                
                VStack(spacing: 0) {
                    
                    Image("SplashImage")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                        .frame(maxWidth: .infinity)
                        
                    
                    if showSubtitle {
                        TypewriterShimmerText(
                            text: subtitle,
                            progress: subtitleProgress
                        )
                        .frame(maxWidth: .infinity)
                        .offset(y: -60)
                    } else {
                        TypewriterShimmerText(
                            text: "",
                            progress: subtitleProgress
                        )
                        .frame(maxWidth: 280)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        withAnimation(.easeOut(duration: 0.8)) {
            logoOpacity = 1.0
            logoScale = 1.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            showSubtitle = true
            
            // 3. Typewriter effect (0.8s - 2.3s)
            withAnimation(.linear(duration: 1.5)) {
                subtitleProgress = 1.0
            }
            
            // 4. Shimmer effect after typewriter (2.3s)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.linear(duration: 0.8)) {
                    shimmerOffset = 400
                }
                
                // 5. Navigate to app (3.1s total)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    isActive = true
                }
            }
        }
    }
}

// MARK: - Typewriter Shimmer Text Component
struct TypewriterShimmerText: View {
    let text: String
    let progress: CGFloat
    
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        let displayedText = String(text.prefix(Int(CGFloat(text.count) * progress)))
        
        Text(displayedText)
            .font(.system(size: 15, weight: .light, design: .rounded))
            .foregroundColor(.white.opacity(0.4))
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .overlay(
                // Shimmer overlay
                GeometryReader { geometry in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .clear,
                                    .white.opacity(0.6),
                                    .white.opacity(0.8),
                                    .white.opacity(0.6),
                                    .clear
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: 120)
                        .offset(x: shimmerOffset)
                }
            )
            .mask(
                Text(displayedText)
                    .font(.system(size: 15, weight: .light, design: .rounded))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            )
            .onAppear {
                // Shimmer animation starts after typewriter is complete
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.linear(duration: 0.8)) {
                        shimmerOffset = 400
                    }
                }
            }
    }
}

