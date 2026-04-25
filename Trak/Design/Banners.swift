//
//  Banners.swift
//  Trak
//
//  Created by Ege Özçelik on 29.09.2025.
//

import SwiftUI




struct StreaksBanner: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Trackie.")
                    .font(.system(size: 42, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                    .textCase(nil)
                
                Text("Streaks")
                    .font(.system(size: 32, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .textCase(nil)
                Text("All your progress is here")
                    .font(.system(size: 16, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .textCase(nil)
            }
            Spacer()
        }
        .frame(height: 200)
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .overlay(
            VStack {
                Rectangle()
                    .fill(Color.primary.opacity(0.01))
                    .frame(height: 0.5)
                Spacer()
                Rectangle()
                    .fill(Color.primary.opacity(0.01))
                    .frame(height: 0.5)
            }
        )
        .ignoresSafeArea(.container, edges: [.horizontal])
        .padding(.bottom, 10)
        
    }
    
   
}


struct StatsBanner: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Trackie.")
                    .font(.system(size: 42, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                    .textCase(nil)
                
                Text("Dashboard")
                    .font(.system(size: 32, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .textCase(nil)
                /*Text("Available programs for you to try out")
                    .font(.system(size: 16, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .textCase(nil)*/
            }
            Spacer()
        }
        .frame(height: 200)
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .overlay(
            VStack {
                Rectangle()
                    .fill(Color.primary.opacity(0.01))
                    .frame(height: 0.5)
                Spacer()
                Rectangle()
                    .fill(Color.primary.opacity(0.01))
                    .frame(height: 0.5)
            }
        )
        .ignoresSafeArea(.container, edges: [.horizontal])
        .padding(.bottom, 10)
        
    }
    
   
}


struct FreshStartBanner: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Trackie.")
                    .font(.system(size: 42, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                    .textCase(nil)
                
                Text("Fresh Start")
                    .font(.system(size: 32, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .textCase(nil)
                Text("Available programs for you to try out")
                    .font(.system(size: 16, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .textCase(nil)
            }
            Spacer()
        }
        .frame(height: 200)
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .overlay(
            VStack {
                Rectangle()
                    .fill(Color.primary.opacity(0.01))
                    .frame(height: 0.5)
                Spacer()
                Rectangle()
                    .fill(Color.primary.opacity(0.01))
                    .frame(height: 0.5)
            }
        )
        .ignoresSafeArea(.container, edges: [.horizontal])
        .padding(.bottom, 10)
        
    }
    
   
}

struct ExploreBanner: View {
    
    @State private var displayedSubtitle = ""
    @State private var currentSubtitleIndex = 0
    
    // Rastgele dönecek subtitle'lar
    private let subtitles = [
        "Science-backed habits, designed for your brain.",
        "Your brain builds habits in 66 days.\nWe decoded the science behind it.",
        "Micro habits. Massive change.\nAll backed by neuroscience.",
        "From circadian rhythms to dopamine loops—discover the hidden science shaping your daily routine.",
        "The wellness app that actually reads research papers.\nSo you don't have to.",
        "Stop guessing.\nStart building habits your brain actually wants to keep.",
        "Your brain is wired for habits.\nWe just cracked the code."
    ]
    
    init() {
        _currentSubtitleIndex = State(initialValue: Int.random(in: 0..<7))
    }
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Trackie.")
                    .font(.system(size: 42, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                    .textCase(nil)
                
                Text("Deep Dive")
                    .font(.system(size: 32, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .textCase(nil)
                
                Text(displayedSubtitle)
                    .font(.system(size: 16, weight: .light, design: .default))
                    .foregroundColor(.primary.opacity(0.8))
                    .multilineTextAlignment(.leading)
                    .textCase(nil)
                    .frame(minHeight: 44, alignment: .topLeading) // Sabit yükseklik için
            }
            Spacer()
        }
        .frame(height: 200)
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .overlay(
            VStack {
                Rectangle()
                    .fill(Color.primary.opacity(0.01))
                    .frame(height: 0.5)
                Spacer()
                Rectangle()
                    .fill(Color.primary.opacity(0.01))
                    .frame(height: 0.5)
            }
        )
        .ignoresSafeArea(.container, edges: [.horizontal])
        .padding(.bottom, 10)
        .onAppear {
            startTypewriterEffect()
        }
    }
    
    private func startTypewriterEffect() {
        // Seçili subtitle'ı al
        let selectedSubtitle = subtitles[currentSubtitleIndex]
        
        // Typewriter effect
        let titleDelay = 0.3
        for (index, character) in selectedSubtitle.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + titleDelay + (Double(index) * 0.04)) {
                displayedSubtitle.append(character)
            }
        }
    }
}

struct TutorialBanner: View {
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Trackie.")
                    .font(.system(size: 42, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                    .textCase(nil)
                
                Text("Guide")
                    .font(.system(size: 32, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .textCase(nil)
                Text("How can you add and track your daily habits to Trackie?")
                    .font(.system(size: 16, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.leading)
                    .textCase(nil)
            }
            Spacer()
        }
        .frame(height: 200)
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .overlay(
            VStack {
                Rectangle()
                    .fill(Color.primary.opacity(0.01))
                    .frame(height: 0.5)
                Spacer()
                Rectangle()
                    .fill(Color.primary.opacity(0.01))
                    .frame(height: 0.5)
            }
        )
        .ignoresSafeArea(.container, edges: [.horizontal])
        .padding(.bottom, 10)
        
    }
    
   
}

