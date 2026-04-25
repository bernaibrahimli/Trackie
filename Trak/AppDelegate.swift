//
//  AppDelegate.swift
//  Trak
//
//  Created by Ege Özçelik on 2.11.2025.
//


import UIKit
import UserNotifications
import GoogleMobileAds

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().setBadgeCount(0)
        
        MobileAds.shared.start { status in
            print("✅ [AdMob] SDK başlatıldı")
            
            AppOpenAdManager.shared.loadAd()
        }
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil
        )
        
        return true
    }
    
    @objc private func appWillEnterForeground() {
        print("🔄 [AdMob] Uygulama ön plana geldi")
        //AppOpenAdManager.shared.showAdIfAvailable()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound, .badge])
        } else {
            completionHandler([.alert, .sound, .badge])
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        
        UNUserNotificationCenter.current().setBadgeCount(0)
        completionHandler()
    }
}
