// OnboardingView.swift
import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPageIndex = 0
    
    // Animation states
    @State private var pageTransition = false
    @State private var buttonScale = 1.0
    @State private var imageScale = 0.8
    @State private var textOpacity = 0.0
    @State private var showConfetti = false
    
    // Define onboarding pages
    private let pages = [
        OnboardingPage(
            title: "Track Daily Habits",
            description: "Build positive routines by tracking your daily habits in a fun and visual way.",
            backgroundColor: AppStyles.Colors.gradient1
        ),
        /*OnboardingPage(
            title: "Your Scientific Library",
            description: "Browse 10+ expert topics on nutrition, habit cultures, exercise, and building lasting habits.",
            backgroundColor: AppStyles.Colors.gradient2
        ),*/
        OnboardingPage(
            title: "Pre-Defined Programs",
            description: "Get started instantly with carefully curated habit programs – just tap and streamline your life!",
            backgroundColor: AppStyles.Colors.primary
        ),
        OnboardingPage(
            title: "Build Streaks",
            description: "Watch your streaks grow as you consistently complete your habits day after day.",
            backgroundColor: AppStyles.Colors.accentFun
        ),
        OnboardingPage(
            title: "Track Progress",
            description: "Visualize your progress with beautiful stats and celebrate your achievements.",
            backgroundColor: AppStyles.Colors.success
        )
    ]
    
    var body: some View {
        ZStack {
            currentPage.backgroundColor
                .opacity(0.9)
                .edgesIgnoringSafeArea(.all)
            
            if showConfetti {
                ConfettiView()
                    .allowsHitTesting(false)
                    .edgesIgnoringSafeArea(.all)
            }
            
            VStack(spacing: 10) {
                Spacer()
                
                // Page dots indicator
                HStack(spacing: 12) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Circle()
                            .fill(Color.white)
                            .opacity(currentPageIndex == index ? 1 : 0.4)
                            .frame(width: 10, height: 10)
                            .scaleEffect(currentPageIndex == index ? 1.4 : 1)
                            .animation(AppStyles.Animations.spring, value: currentPageIndex)
                    }
                }
                .padding(.top, 10)
                
                Spacer()
                
                // Feature showcase animations
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 280, height: 280)
                    
                    Group {
                        if currentPageIndex == 0 {
                            FeatureShowcaseView(feature: .habitTracking)
                        } else if currentPageIndex == 1 {
                            FeatureShowcaseView(feature: .readyPrograms)
                        } else if currentPageIndex == 2 {
                            FeatureShowcaseView(feature: .streaks)
                        }else {
                            FeatureShowcaseView(feature: .stats)
                        }
                    }
                    .scaleEffect(imageScale)
                    .animation(AppStyles.Animations.bounce, value: imageScale)
                    .onAppear {
                        withAnimation(AppStyles.Animations.bounce.delay(0.2)) {
                            imageScale = 1.0
                        }
                    }
                    .onChange(of: currentPageIndex) { _ in
                        // Reset and animate when page changes
                        imageScale = 0.8
                        withAnimation(AppStyles.Animations.bounce.delay(0.2)) {
                            imageScale = 1.0
                        }
                    }
                }
                .padding(.bottom, 30)
                
                VStack(spacing: 20) {
                                    Text(currentPage.title)
                                        .font(Font.system(.title, design: .rounded).weight(.bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                    
                                    Text(currentPage.description)
                                        .font(Font.system(.body, design: .rounded))
                                        .foregroundColor(.white.opacity(0.9))
                                        .multilineTextAlignment(.center)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .padding(.horizontal, 30)
                                }
                .onChange(of: currentPageIndex) { _ in
                    // Reset and animate when page changes
                    textOpacity = 0.0
                    withAnimation(AppStyles.Animations.spring.delay(0.3)) {
                        textOpacity = 1.0
                    }
                }
                
                Spacer()
                
                // Navigation buttons
                VStack(spacing: 20) {
                    HStack(spacing: 20) {
                        // Skip button (first pages only)
                        if currentPageIndex < pages.count - 1 {
                            Button {
                                // Skip to the last page
                                withAnimation {
                                    currentPageIndex = pages.count - 1
                                    showConfetti = true
                                }
                            } label: {
                                Text("Skip")
                                    .font(AppStyles.Typography.button)
                                    .foregroundColor(.white)
                                    .padding(.vertical, 15)
                                    .padding(.horizontal, 25)
                                    .background(Color.white.opacity(0.2))
                                    .cornerRadius(AppStyles.Dimensions.cornerRadius)
                            }
                        }
                        
                        // Next/Get Started button
                        Button {
                            if currentPageIndex < pages.count - 1 {
                                // Go to next page with animation
                                withAnimation {
                                    currentPageIndex += 1
                                    
                                    // Show confetti on last page
                                    if currentPageIndex == pages.count - 1 {
                                        showConfetti = true
                                    }
                                }
                            } else {
                                // Complete onboarding
                                withAnimation {
                                    buttonScale = 1.3
                                }
                                
                                // Wait for animation
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    // Set the onboarding flag to false
                                    withAnimation {
                                        showOnboarding = false
                                    }
                                    
                                    // Save the completion state
                                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                                }
                            }
                        } label: {
                            Text(currentPageIndex < pages.count - 1 ? "Next" : "Get Started")
                                .font(AppStyles.Typography.button)
                                .foregroundColor(currentPage.backgroundColor)
                                .padding(.vertical, 15)
                                .padding(.horizontal, 25)
                                .background(Color.white)
                                .cornerRadius(AppStyles.Dimensions.cornerRadius)
                                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                                .scaleEffect(buttonScale)
                                .animation(AppStyles.Animations.spring, value: buttonScale)
                                .onAppear {
                                    // Subtle pulse animation for the button
                                    withAnimation(Animation.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                                        buttonScale = 1.05
                                    }
                                }
                        }
                    }
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
        .transition(.opacity)
    }
    
    // Helper to get current page
    private var currentPage: OnboardingPage {
        pages[currentPageIndex]
    }
}

// Onboarding page data structure
struct OnboardingPage {
    let title: String
    let description: String
    let backgroundColor: Color
}

// Confetti animation view
struct ConfettiView: View {
    @State private var confetti = [Confetti]()
    
    var body: some View {
        ZStack {
            ForEach(confetti) { item in
                ConfettiPiece(confetti: item)
            }
        }
        .onAppear {
            // Create confetti pieces
            for _ in 0..<60 {
                confetti.append(Confetti())
            }
        }
    }
}

struct Confetti: Identifiable {
    let id = UUID()
    let color = [AppStyles.Colors.primary, AppStyles.Colors.secondary, AppStyles.Colors.accentFun, AppStyles.Colors.success].randomElement()!
    let position = CGPoint(x: CGFloat.random(in: 0...UIScreen.main.bounds.width), y: -50)
    let size = CGFloat.random(in: 5...12)
    let rotation = Double.random(in: 0...360)
    let rotationSpeed = Double.random(in: 50...360)
    let fallSpeed = Double.random(in: 2...6)
    
    // Random confetti shape
    let shape = ["circle", "triangle", "square"].randomElement()!
}

struct ConfettiPiece: View {
    let confetti: Confetti
    @State private var yPosition: CGFloat
    @State private var rotation: Double
    
    init(confetti: Confetti) {
        self.confetti = confetti
        _yPosition = State(initialValue: confetti.position.y)
        _rotation = State(initialValue: confetti.rotation)
    }
    
    var body: some View {
        Group {
            if confetti.shape == "circle" {
                Circle().fill(confetti.color)
            } else if confetti.shape == "triangle" {
                Triangle().fill(confetti.color)
            } else {
                Rectangle().fill(confetti.color)
            }
        }
        .frame(width: confetti.size, height: confetti.size)
        .position(x: confetti.position.x, y: yPosition)
        .rotationEffect(.degrees(rotation))
        .onAppear {
            // Animate the confetti falling
            withAnimation(Animation.linear(duration: Double(UIScreen.main.bounds.height) / confetti.fallSpeed).delay(Double.random(in: 0...2))) {
                yPosition = UIScreen.main.bounds.height + 50
            }
            
            // Animate rotation
            withAnimation(Animation.linear(duration: Double(UIScreen.main.bounds.height) / confetti.fallSpeed).delay(Double.random(in: 0...2))) {
                rotation += confetti.rotationSpeed
            }
        }
    }
}

// Triangle shape for confetti
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        return path
    }
}

// Preview
struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(showOnboarding: .constant(true))
    }
}
