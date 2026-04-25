//
//  effects.swift
//  Trak
//
//  Created by Ege Özçelik on 29.09.2025.
//

import SwiftUI

// MARK: - Version 1: Shimmer Effect (Öneririm ✨)
struct ShimmeringFooterView: View {
    @State private var shimmerOffset: CGFloat = -200
    
    var body: some View {
        VStack(spacing: 5) {
            Divider()
            
            HStack {
                Spacer()
                
                Text("Trackie | Explore")
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.white.opacity(0.2))
                    .overlay(
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .clear,
                                            .white.opacity(0.3),
                                            .clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 100)
                                .offset(x: shimmerOffset)
                                .onAppear {
                                    withAnimation(
                                        .linear(duration: 2.5)
                                        .repeatForever(autoreverses: false)
                                    ) {
                                        shimmerOffset = geometry.size.width + 100
                                    }
                                }
                        }
                    )
                    .mask(
                        Text("Trackie | Explore")
                            .font(.caption)
                            .fontWeight(.light)
                    )
                
                Spacer()
            }
        }
    }
}

// MARK: - Version 2: Breathing Glow
struct BreathingGlowFooterView: View {
    @State private var isGlowing = false
    
    var body: some View {
        VStack(spacing: 5) {
            Divider()
            
            HStack {
                Spacer()
                
                Text("Trackie | Explore")
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.white.opacity(isGlowing ? 0.4 : 0.2))
                    .shadow(
                        color: .white.opacity(isGlowing ? 0.2 : 0.0),
                        radius: isGlowing ? 8 : 0
                    )
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true),
                        value: isGlowing
                    )
                    .onAppear {
                        isGlowing = true
                    }
                
                Spacer()
            }
        }
    }
}

// MARK: - Version 3: Subtle Pulse
struct PulsingFooterView: View {
    @State private var isPulsing = false
    
    var body: some View {
        VStack(spacing: 5) {
            Divider()
            
            HStack {
                Spacer()
                
                Text("Trackie | Explore")
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundColor(.white.opacity(0.2))
                    .scaleEffect(isPulsing ? 1.02 : 1.0)
                    .opacity(isPulsing ? 0.4 : 0.2)
                    .animation(
                        .easeInOut(duration: 2.5)
                        .repeatForever(autoreverses: true),
                        value: isPulsing
                    )
                    .onAppear {
                        isPulsing = true
                    }
                
                Spacer()
            }
        }
    }
}

// MARK: - Version 4: Gradient Text with Animation
struct GradientAnimatedFooterView: View {
    @State private var gradientPhase: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 5) {
            Divider()
            
            HStack {
                Spacer()
                
                Text("Trackie | Explore")
                    .font(.caption)
                    .fontWeight(.light)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                
                                .white.opacity(0.2),
                                .white.opacity(0.5),
                                .white.opacity(0.7),
                               
                                .white.opacity(0.5),
                                .white.opacity(0.2)
                               
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        .opacity(0.5)
                    )
                    .hueRotation(.degrees(gradientPhase))
                    .onAppear {
                        withAnimation(
                            .linear(duration: 3.0)
                            .repeatForever(autoreverses: false)
                        ) {
                            gradientPhase = 360
                        }
                    }
                
                Spacer()
            }
        }
    }
}

// MARK: - Version 5: Star Twinkle Effect
struct TwinkleFooterView: View {
    @State private var showStars = false
    
    var body: some View {
        VStack(spacing: 5) {
            Divider()
            
            HStack {
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: "sparkle")
                        .font(.system(size: 6))
                        .foregroundColor(.white.opacity(0.3))
                        .opacity(showStars ? 1 : 0)
                        .scaleEffect(showStars ? 1 : 0.5)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(0.0),
                            value: showStars
                        )
                    
                    Text("Trackie | Explore")
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(.white.opacity(0.2))
                    
                    Image(systemName: "sparkle")
                        .font(.system(size: 6))
                        .foregroundColor(.white.opacity(0.3))
                        .opacity(showStars ? 1 : 0)
                        .scaleEffect(showStars ? 1 : 0.5)
                        .animation(
                            .easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true)
                            .delay(0.75),
                            value: showStars
                        )
                }
                .onAppear {
                    showStars = true
                }
                
                Spacer()
            }
        }
    }
}

// MARK: - Version 6: Typewriter + Shimmer (En Gösterişli)
struct TypewriterShimmerFooterView: View {
    @State private var showText = false
    @State private var shimmerOffset: CGFloat = -100
    
    let text = "Trackie | Explore"
    
    var body: some View {
        VStack(spacing: 5) {
            Divider()
            
            HStack {
                Spacer()
                
                if showText {
                    Text(text)
                        .font(.caption)
                        .fontWeight(.light)
                        .foregroundColor(.white.opacity(0.2))
                        .overlay(
                            GeometryReader { geometry in
                                Rectangle()
                                    .fill(
                                        LinearGradient(
                                            colors: [
                                                .clear,
                                                .white.opacity(0.4),
                                                .clear
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: 80)
                                    .offset(x: shimmerOffset)
                            }
                        )
                        .mask(
                            Text(text)
                                .font(.caption)
                                .fontWeight(.light)
                        )
                        .transition(.opacity.combined(with: .scale))
                }
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.easeIn(duration: 0.5).delay(0.3)) {
                showText = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(
                    .linear(duration: 2.0)
                    .repeatForever(autoreverses: false)
                ) {
                    shimmerOffset = 200
                }
            }
        }
    }
}

// MARK: - Preview
struct ShimmeringFooterView_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            VStack(spacing: 60) {
                // Sample Content
                VStack(alignment: .leading, spacing: 16) {
                    Text("Section Content")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit.")
                        .foregroundColor(.secondary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemGray6))
                .cornerRadius(12)
                
                VStack(spacing: 30) {
                    Text("Version 1: Shimmer ✨ (Öneririm)")
                        .font(.caption)
                        .foregroundColor(.blue)
                    ShimmeringFooterView()
                        .padding(.horizontal)
                }
                
                VStack(spacing: 30) {
                    Text("Version 2: Breathing Glow")
                        .font(.caption)
                        .foregroundColor(.blue)
                    BreathingGlowFooterView()
                        .padding(.horizontal)
                }
                
                VStack(spacing: 30) {
                    Text("Version 3: Subtle Pulse")
                        .font(.caption)
                        .foregroundColor(.blue)
                    PulsingFooterView()
                        .padding(.horizontal)
                }
                
                VStack(spacing: 30) {
                    Text("Version 4: Gradient Animation")
                        .font(.caption)
                        .foregroundColor(.blue)
                    GradientAnimatedFooterView()
                        .padding(.horizontal)
                }
                
                VStack(spacing: 30) {
                    Text("Version 5: Twinkle Stars")
                        .font(.caption)
                        .foregroundColor(.blue)
                    TwinkleFooterView()
                        .padding(.horizontal)
                }
                
                VStack(spacing: 30) {
                    Text("Version 6: Typewriter + Shimmer")
                        .font(.caption)
                        .foregroundColor(.blue)
                    TypewriterShimmerFooterView()
                        .padding(.horizontal)
                }
            }
            .padding(.vertical, 40)
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
    }
}
