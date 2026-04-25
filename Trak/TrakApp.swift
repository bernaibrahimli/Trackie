import SwiftUI
import GoogleMobileAds

@main
struct HabitTrackApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    @StateObject private var habitStore = HabitStore()
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showOnboarding = true
    @State private var isSplashActive = false

    init() {
        NotificationManager.shared.requestAuthorization { granted in
            print("Notification permission: \(granted)")
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {
                if !isSplashActive {
                    // Splash gösterilsin
                    SplashScreen(isActive: $isSplashActive)
                        .zIndex(999)
                } else {
                    // Splash bitti -> onboarding veya ana içerik
                    if !hasCompletedOnboarding && showOnboarding {
                        OnboardingView(showOnboarding: $showOnboarding)
                            .transition(.opacity)
                            .zIndex(100)
                    } else {
                        ContentView()
                            .environmentObject(habitStore)
                            .onAppear {
                                habitStore.checkAndResetExpiredHabits()
                            }
                    }
                }
            }
            .preferredColorScheme(.dark)
            .onAppear {
                // showOnboarding kontrolünü başlat
                DispatchQueue.main.async {
                    showOnboarding = !hasCompletedOnboarding
                }
            }
            // Splash tamamlandığında reklam göster
            .onChange(of: isSplashActive) { newValue in
                if newValue == true {
                    print("🔔 Splash kapandı — şimdi reklam gösterme denenecek")
                    // AppOpenAdManager.showAdIfAvailable() reklam hazır ise gösterecek
                    AppOpenAdManager.shared.showAdIfAvailable()
                }
            }
        }
    }
}
