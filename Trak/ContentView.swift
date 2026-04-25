// ContentView.swift - FAB Animation Optimization
import SwiftUI

struct ContentView: View {
    
    
    @EnvironmentObject var habitStore: HabitStore
    @State private var showingAddHabit = false
    @State private var selectedTab = 0
    
    @State private var fabRotation = 0.0
    @State private var fabScale = 1.0
    @State private var fabPressed = false
    @State private var showPulseHint = true

    @State private var showMaxHabitsAlert = false
    
    @State private var showWidgetPromotion = false
    @AppStorage("hasShownWidgetPromotion") private var hasShownWidgetPromotion = false
        

    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(AppStyles.Colors.secondaryBackground)

        let itemAppearance = UITabBarItemAppearance()
        
        itemAppearance.selected.iconColor = UIColor(AppStyles.Colors.primary)
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(AppStyles.Colors.primary)]
        
        itemAppearance.normal.iconColor = UIColor.gray
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]

        tabBarAppearance.stackedLayoutAppearance = itemAppearance
        tabBarAppearance.inlineLayoutAppearance = itemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = itemAppearance
        

        UITabBar.appearance().standardAppearance = tabBarAppearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HabitDashboardView()
                    .tabItem {
                        Label("Today", systemImage: selectedTab == 0 ? "house.fill" : "house")
                    }
                    .tag(0)
                
                // YENİ: Takvim sekmesi
                CalendarView()
                    .tabItem {
                        Label("Calendar", systemImage: selectedTab == 1 ? "calendar" : "calendar")
                            
                    }
                    .tag(1)
                    .environmentObject(habitStore)
                
                StatsView()
                    .tabItem {
                        Label("Dashboard", systemImage: selectedTab == 2 ? "chart.bar.fill" : "chart.bar")
                    }
                    .tag(2)
            }
            
           
            HStack {
                Spacer()
                Button {
                    if habitStore.habits.count >= 10 {
                        showMaxHabitsAlert = true
                    } else {
                        showPulseHint = false
                        
                        withAnimation(AppStyles.Animations.spring) {
                            fabRotation += 180
                            fabScale = 1.2
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            fabScale = 1.0
                            showingAddHabit = true
                        }
                    }
                } label: {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            AppStyles.Colors.gradient1,
                                            AppStyles.Colors.gradient2
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: AppStyles.Dimensions.fabSize, height: AppStyles.Dimensions.fabSize)
                                .shadow(
                                    color: AppStyles.Colors.primary.opacity(0.4),
                                    radius: fabPressed ? 4 : 10,
                                    x: 0,
                                    y: fabPressed ? 2 : 5
                                )
                                .scaleEffect(fabPressed ? 0.95 : fabScale)
                            
                                Image(systemName: "plus")
                                    .font(.system(size: 30, weight: .semibold))
                                    .foregroundColor(AppStyles.Colors.lightText)
                                    .rotationEffect(.degrees(fabRotation))
                            }
                        }
                .padding(.bottom, AppStyles.Dimensions.standardPadding * 3.5 )
                    .padding(.trailing, 15)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                // ✅ Stop pulse hint on interaction
                                showPulseHint = false
                                
                                withAnimation(AppStyles.Animations.quick) {
                                    fabPressed = true
                                }
                            }
                            .onEnded { _ in
                                withAnimation(AppStyles.Animations.spring) {
                                    fabPressed = false
                                }
                            }
                    )
                    .onAppear {
                        DispatchQueue.main.async {
                            if showPulseHint {
                                withAnimation(
                                    Animation.easeInOut(duration: 1.5)
                                        .repeatCount(3, autoreverses: true)
                                ) {
                                    fabScale = 1.05
                                }

                                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                    showPulseHint = false
                                    withAnimation(.easeOut(duration: 0.3)) {
                                        fabScale = 1.0
                                    }
                                }
                            }
                        }
                    }
                    .onChange(of: selectedTab) { _ in
                        showPulseHint = false
                        withAnimation(.easeOut(duration: 0.3)) {
                            fabScale = 1.0
                        }
                    }
                    
                    //Spacer()
                }
            
           
        }
        .sheet(isPresented: $showingAddHabit) {
            AddHabitView()
                .environmentObject(habitStore)
        }
        .alert("Habit Limit Reached", isPresented: $showMaxHabitsAlert) {
            Button("OK") { }
        } message: {
            Text("You can delete and add new ones by tapping and holding on the habit.")
        }
        .fullScreenCover(isPresented: $showWidgetPromotion) {
            WidgetPromotionView(isPresented: $showWidgetPromotion)
                .onDisappear {
                    hasShownWidgetPromotion = true
                }
        }
        .onAppear {
            showWidgetPromotionAfterDelay()
        }
  
    }
    
    private func showWidgetPromotionAfterDelay() {
        // Daha önce gösterilmişse hiçbir şey yapma
        guard !hasShownWidgetPromotion else { return }
        
        // 120 saniye sonra göster
        DispatchQueue.main.asyncAfter(deadline: .now() + 120) {
            showWidgetPromotion = true
        }
    }
        
}

