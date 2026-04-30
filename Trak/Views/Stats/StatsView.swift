// StatsView.swift
import SwiftUI



struct StatsView: View {
    @EnvironmentObject var habitStore: HabitStore
    @State private var showingTutorial = false
    @State private var showingQuickPrograms = false
    @State private var showingExplore = false
    @State private var showingDeveloperNote = false

    var body: some View {
        NavigationView {
            ZStack {
                // Background Animation
                DynamicLineParticleView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: AppStyles.Dimensions.standardPadding) {
                        StatsBanner()
                      
                        StatCard(
                            title: "Today's Stats",
                            value: "\(Int(completionRateToday * 100))% ",
                            subtitle: "completed on \(habitStore.habits.count) habit",
                            icon: "checkmark.circle.fill",
                            color: AppStyles.Colors.success,
                            iconBackgroundColor: AppStyles.Colors.success
                        )
                        StatCard(
                            title: "Current Longest Streak",
                            value: "\(longestCurrentStreak)",
                            subtitle: "days",
                            icon: "flame.fill",
                            color: AppStyles.Colors.accentFun,
                            iconBackgroundColor: AppStyles.Colors.accentFun
                        )
                        
                        QuickProgramsCard(isPresented: $showingQuickPrograms)
                            .onTapGesture {
                                showingQuickPrograms = true
                            }
                            .fullScreenCover(isPresented: $showingQuickPrograms) {
                                QuickProgramsView()
                                    .environmentObject(habitStore)
                            }
                            
                        /*ExploreCard()
                            .onTapGesture {
                                showingExplore = true
                            }
                            .fullScreenCover(isPresented: $showingExplore) {
                                ExploreView()
                            }*/
                        
                        HStack(alignment: .top, spacing: AppStyles.Dimensions.standardPadding) {
                            StatCard(
                                title: "Guide",
                                value: "",
                                subtitle: "Learn How to Add Habits.",
                                icon: "info.circle.fill",
                                color: Color.yellow,
                                iconBackgroundColor: Color.yellow
                            )
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                showingTutorial = true
                            }
                            .sheet(isPresented: $showingTutorial) {
                                HabitTutorialView()
                            }

                            StatCard(
                                title: "About",
                                value: "",
                                subtitle: "Developer Note",
                                icon: "hammer.fill",
                                color: Color.blue,
                                iconBackgroundColor: Color.blue.opacity(0.8)
                            )
                            .frame(maxWidth: .infinity)
                            .onTapGesture {
                                showingDeveloperNote = true
                            }
                            .sheet(isPresented: $showingDeveloperNote) {
                                DeveloperNoteView()
                            }

                        }
                        
                        Spacer()
                        
                    }
                    .padding(AppStyles.Dimensions.standardPadding)
                }
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .accentColor(AppStyles.Colors.primary)
    }
    var longestCurrentStreak: Int {
        habitStore.habits.map { $0.streak }.max() ?? 0
    }
    
    var completionRateToday: Double {
        let totalHabits = habitStore.habits.count
        if totalHabits == 0 { return 0 }
        
        // DÜZELTME: isCompletedToday kullan
        let completedTodayCount = habitStore.habits.filter { habit in
            habit.isCompletedToday
        }.count
        
        return Double(completedTodayCount) / Double(totalHabits)
    }
}



struct ExploreCard: View {
    @State private var imageOpacity: Double = 0.8
    @State private var textOffset: CGFloat = 10
    
    var body: some View {
        ZStack {
            // Background Image
            Image("image")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 250)
                .clipped()
                .opacity(imageOpacity)
                .overlay(
                    // Gradient overlay for better text readability
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.6),
                            Color.black.opacity(0.3),
                            Color.clear
                        ]),
                        startPoint: .bottomLeading,
                        endPoint: .topTrailing
                    )
                )
            
            // Text Content - positioned at bottom left
            VStack {
                Spacer()
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Deep Dive")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                        
                        Text("Habits, Humans, Science and more")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.9))
                            .shadow(color: .black.opacity(0.5), radius: 1, x: 0.5, y: 0.5)
                    }
                    .offset(y: textOffset)
                    
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.bottom, 16)
            }
        }
        .frame(height: 250)
        .cornerRadius(AppStyles.Dimensions.cornerRadius)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .onAppear {
            DispatchQueue.main.async {
                withAnimation(.easeOut(duration: 0.8)) {
                    imageOpacity = 1.0
                    textOffset = 0
                }
            }
        }
        .scaleEffect(imageOpacity) 
    }
}


