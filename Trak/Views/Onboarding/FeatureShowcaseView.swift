// FeatureShowcaseView.swift - Timer Performance Optimization
import SwiftUI

struct FeatureShowcaseView: View {
    let feature: OnboardingFeature
    @State private var animationPhase = 0
    @State private var isAnimating = false
    
    // ✅ OPTIMIZED: Controllable timer with cleanup
    @State private var timer: Timer?
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.white.opacity(0.15))
                .frame(width: 280, height: 280)
            
            Group {
                switch feature {
                case .habitTracking:
                    habitTrackingAnimation
                case .knowledgeGuide:
                    knowledgeAnimation
                case .readyPrograms:
                    readyProgramsAnimation
                case .streaks:
                    streaksAnimation
                case .stats:
                    statsAnimation
                }
            }
        }
        .onAppear {
            startAnimation()
        }
        .onDisappear {
            stopAnimation()
        }
    }
    
    // ✅ OPTIMIZED: Controlled animation lifecycle
    private func startAnimation() {
        isAnimating = true
        
        // Start timer only when view is visible
        timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: true) { _ in
            if isAnimating {
                withAnimation(AppStyles.Animations.spring) {
                    animationPhase = (animationPhase + 1) % 3
                }
            }
        }
    }
    
    private func stopAnimation() {
        isAnimating = false
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: - Feature-specific animations (unchanged)
    
    private var habitTrackingAnimation: some View {
        ZStack {
            ForEach(0..<3) { index in
                Circle()
                    .stroke(Color.white.opacity(animationPhase == index ? 1 : 0.3), lineWidth: 3)
                    .frame(width: 70, height: 70)
                    .scaleEffect(animationPhase == index ? 1.1 : 1.0)
                    .offset(x: CGFloat(index - 1) * 90)
                    .overlay(
                        Image(systemName: index == 0 ? "moon.fill" : (index == 1 ? "drop.fill" : "book.fill"))
                            .font(.system(size: 30))
                            .foregroundColor(Color.white.opacity(animationPhase == index ? 1 : 0.3))
                            .offset(x: CGFloat(index - 1) * 90)
                    )
            }
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 24))
                .foregroundColor(AppStyles.Colors.success)
                .offset(x: CGFloat(animationPhase - 1) * 90, y: -40)
                .opacity(isAnimating ? 1 : 0)
                .scaleEffect(isAnimating ? 1.2 : 0)
                .animation(AppStyles.Animations.bounce, value: animationPhase)
        }
    }
    
    private var knowledgeAnimation: some View {
        ZStack {
            // Akan bilgi kartları
            VStack(spacing: 15) {
                ForEach(0..<3) { index in
                    HStack(spacing: 12) {
                        Image(systemName: ["heart.fill", "brain.head.profile", "figure.walk"][index])
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .frame(width: 40, height: 40)
                            .background(Color.white.opacity(animationPhase == index ? 0.4 : 0.2))
                            .cornerRadius(8)
                            .scaleEffect(animationPhase == index ? 1.15 : 1.0)
                            .animation(AppStyles.Animations.spring, value: animationPhase)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(animationPhase == index ? 1.0 : 0.6))
                                .frame(width: animationPhase == index ? 110 : 100, height: 8)
                                .animation(AppStyles.Animations.spring, value: animationPhase)
                            
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(animationPhase == index ? 0.9 : 0.5))
                                .frame(width: animationPhase == index ? 80 : 70, height: 6)
                                .animation(AppStyles.Animations.spring, value: animationPhase)
                        }
                        
                        Spacer()
                    }
                    .padding(12)
                    .background(Color.white.opacity(animationPhase == index ? 0.25 : 0.15))
                    .cornerRadius(12)
                    .frame(width: 200)
                    .scaleEffect(animationPhase == index ? 1.05 : 1.0)
                    .shadow(
                        color: Color.white.opacity(animationPhase == index ? 0.3 : 0),
                        radius: animationPhase == index ? 10 : 0,
                        x: 0,
                        y: 4
                    )
                    .animation(AppStyles.Animations.spring, value: animationPhase)
                }
            }
            
            // Okuma göstergesi - checkmark animasyonu
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 28))
                .foregroundColor(AppStyles.Colors.success)
                .offset(x: 110, y: CGFloat(animationPhase - 1) * 60 - 30)
                .opacity(isAnimating ? 1 : 0)
                .scaleEffect(isAnimating ? 1.0 : 0.5)
                .animation(AppStyles.Animations.bounce, value: animationPhase)
            
            // Işık partikülleri - bilgi akışını gösterir
            ForEach(0..<5) { i in
                Image(systemName: "sparkle")
                    .font(.system(size: CGFloat.random(in: 12...20)))
                    .foregroundColor(.white.opacity(0.8))
                    .offset(
                        x: CGFloat.random(in: -40...40),
                        y: animationPhase == (i % 3) ? -120 : 120
                    )
                    .opacity(animationPhase == (i % 3) ? 0 : 0.8)
                    .rotationEffect(.degrees(animationPhase == (i % 3) ? 180 : 0))
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .delay(Double(i) * 0.2),
                        value: animationPhase
                    )
            }
            
            
        }
    }
    
    private var readyProgramsAnimation: some View {
        ZStack {
            // Arka plandaki program kartları
            VStack(spacing: 12) {
                ForEach(0..<3) { index in
                    HStack(spacing: 10) {
                        // Program ikonu
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.3),
                                            Color.white.opacity(0.15)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: ["paintbrush.pointed", "sun.max.circle", "fork.knife"][index])
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        
                        // Program bilgileri
                        VStack(alignment: .leading, spacing: 4) {
                            RoundedRectangle(cornerRadius: 3)
                                .fill(Color.white.opacity(0.9))
                                .frame(width: 90, height: 10)
                            
                            HStack(spacing: 4) {
                                ForEach(0..<3) { habitIndex in
                                    Circle()
                                        .fill(Color.white.opacity(0.6))
                                        .frame(width: 6, height: 6)
                                }
                            }
                        }
                        
                        Spacer()
                        
                        // Seçim göstergesi
                        Image(systemName: animationPhase == index ? "checkmark.circle.fill" : "circle")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .scaleEffect(animationPhase == index ? 1.2 : 1.0)
                            .animation(AppStyles.Animations.bounce, value: animationPhase)
                    }
                    .padding(.horizontal, 15)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white.opacity(animationPhase == index ? 0.25 : 0.15))
                    )
                    .frame(width: 220)
                    .scaleEffect(animationPhase == index ? 1.05 : 1.0)
                    .shadow(
                        color: Color.white.opacity(animationPhase == index ? 0.4 : 0),
                        radius: animationPhase == index ? 12 : 0,
                        x: 0,
                        y: 4
                    )
                    .animation(AppStyles.Animations.spring, value: animationPhase)
                }
            }
            
           
            // Sparkle efektleri
            ForEach(0..<4) { i in
                Image(systemName: "sparkle")
                    .font(.system(size: CGFloat.random(in: 10...16)))
                    .foregroundColor(.yellow.opacity(0.8))
                    .offset(
                        x: CGFloat.random(in: -60...60),
                        y: CGFloat.random(in: -60...60)
                    )
                    .opacity(animationPhase == (i % 3) ? 1 : 0)
                    .scaleEffect(animationPhase == (i % 3) ? 1.2 : 0.5)
                    .animation(
                        Animation.easeInOut(duration: 1.0)
                            .delay(Double(i) * 0.15),
                        value: animationPhase
                    )
            }
        }
    }
    
    
    private var streaksAnimation: some View {
        VStack {
            Text("\(animationPhase * 3 + 1)")
                .font(.system(size: 70, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .frame(width: 100, height: 100)
                .animation(.none, value: animationPhase)
            
            ZStack {
                ForEach(0..<3) { i in
                    Image(systemName: "flame.fill")
                        .font(.system(size: 50 - CGFloat(i * 15)))
                        .foregroundColor(AppStyles.Colors.accentFun)
                        .offset(y: isAnimating ? CGFloat(i * -6) : 0)
                        .opacity(isAnimating ? [1.0, 0.7, 0.5][i] : 0.5)
                        // ✅ OPTIMIZED: Animation only when isAnimating is true
                        .animation(
                            isAnimating ?
                            Animation.easeInOut(duration: 0.6)
                                .repeatCount(3, autoreverses: true) // Limited repeat instead of forever
                                .delay(Double(i) * 0.2) :
                            .default,
                            value: isAnimating
                        )
                }
            }
            .scaleEffect(1.0 + CGFloat(animationPhase) * 0.2)
        }
    }
    
    private var statsAnimation: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: CGFloat(animationPhase + 1) / 3.0)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [AppStyles.Colors.success, AppStyles.Colors.primary]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                    style: StrokeStyle(lineWidth: 15, lineCap: .round)
                )
                .frame(width: 150, height: 150)
                .rotationEffect(.degrees(-90))
                .animation(AppStyles.Animations.spring, value: animationPhase)
            
            Text("\(Int((CGFloat(animationPhase + 1) / 3.0) * 100))%")
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .animation(.none, value: animationPhase)
            
            HStack(spacing: 15) {
                ForEach(0..<3) { i in
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.white.opacity(0.3))
                        .frame(width: 15, height: 60)
                        .overlay(
                            Rectangle()
                                .fill(Color.white)
                                .frame(
                                    width: 15,
                                    height: animationPhase >= i ? 60 : 10
                                )
                                .animation(AppStyles.Animations.spring.delay(Double(i) * 0.1), value: animationPhase),
                            alignment: .bottom
                        )
                }
            }
            .offset(y: 80)
        }
    }
}

enum OnboardingFeature {
    case habitTracking
    case knowledgeGuide
    case readyPrograms
    case streaks
    case stats
}
