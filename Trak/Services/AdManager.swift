//
//  AppOpenAdManager.swift
//  Moneyflow
//
//  Created by Ege on [Date]
//

import UIKit
import GoogleMobileAds

class AppOpenAdManager: NSObject, FullScreenContentDelegate {
    
    static let shared = AppOpenAdManager()
    
    //private let adUnitID = "ca-app-pub-8966491851338157/9523706227"
    private let adUnitID = "ca-app-pub-3940256099942544/5575463023" // test ID

    
    private var appOpenAd: AppOpenAd?
    private var isLoadingAd = false
    private var isShowingAd = false
    
    // İlk açılışta gösterim kontrolü
    private var hasShownFirstAd = false
    
    private let cooldownDuration: TimeInterval = 300
    private let lastAdShownTimeKey = "lastAppOpenAdShownTime"
    
    private override init() {
        super.init()
    }
    
    // MARK: - Reklam Yükleme
    
    func loadAd() {
        guard !isLoadingAd, appOpenAd == nil else {
            print("⚠️ [AdMob] Reklam zaten yükleniyor veya mevcut")
            return
        }
        
        isLoadingAd = true
        print("📱 [AdMob] Reklam yükleniyor...")
        
        AppOpenAd.load(with: adUnitID, request: Request()) { [weak self] ad, error in
            guard let self = self else { return }
            self.isLoadingAd = false
            
            if let error = error {
                print("❌ [AdMob] Reklam yüklenemedi: \(error.localizedDescription)")
                return
            }
            
            print("✅ [AdMob] Reklam başarıyla yüklendi")
            self.appOpenAd = ad
            self.appOpenAd?.fullScreenContentDelegate = self
        }
    }
    
    
    private func isCooldownActive() -> Bool {
        let lastShownTime = UserDefaults.standard.double(forKey: lastAdShownTimeKey)
        guard lastShownTime > 0 else {
            print("✅ [AdMob] İlk reklam, cooldown yok")
            return false
        }
        
        let currentTime = Date().timeIntervalSince1970
        let timeSinceLastAd = currentTime - lastShownTime
        
        if timeSinceLastAd < cooldownDuration {
            let remaining = Int(cooldownDuration - timeSinceLastAd)
            print("⏱️ [AdMob] Cooldown aktif – \(remaining) saniye kaldı")
            return true
        }
        
        print("✅ [AdMob] Cooldown süresi doldu, reklam gösterilebilir")
        return false
    }
    
    private func saveAdShownTime() {
        let currentTime = Date().timeIntervalSince1970
        UserDefaults.standard.set(currentTime, forKey: lastAdShownTimeKey)
        print("💾 [AdMob] Reklam gösterim zamanı kaydedildi: \(Date())")
    }
    
    
    func showAdIfAvailable() {
        guard !isShowingAd else {
            print("⚠️ [AdMob] Zaten bir reklam gösteriliyor")
            return
        }
        
        if isCooldownActive() {
            print("🚫 [AdMob] Cooldown aktif, reklam gösterilmeyecek")
            return
        }
        
        guard let ad = appOpenAd else {
            print("⚠️ [AdMob] Henüz yüklenmiş bir reklam yok, yükleniyor...")
            loadAd()
            return
        }
        
        guard let rootVC = UIApplication.shared.connectedScenes
            .compactMap({ ($0 as? UIWindowScene)?.windows.first(where: { $0.isKeyWindow })?.rootViewController })
            .first else {
            print("❌ [AdMob] RootViewController bulunamadı")
            return
        }
        
        print("🚀 [AdMob] Reklam gösteriliyor...")
        ad.present(from: rootVC)
    }
    
    // MARK: - GADFullScreenContentDelegate
    
    func adWillPresentFullScreenContent(_ ad: FullScreenPresentingAd) {
        isShowingAd = true
        print("📺 [AdMob] Reklam tam ekran gösterilecek")
    }
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        print("✅ [AdMob] Reklam kapatıldı")
        isShowingAd = false
        appOpenAd = nil
        hasShownFirstAd = true
        
        saveAdShownTime()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            print("🔄 [AdMob] Yeni reklam yükleniyor (cooldown sonrası)...")
            self.loadAd()
        }
    }
    
    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("❌ [AdMob] Reklam gösterilemedi: \(error.localizedDescription)")
        isShowingAd = false
        appOpenAd = nil
        loadAd()
    }
    
    
    func getRemainingCooldownTime() -> String {
        let lastShownTime = UserDefaults.standard.double(forKey: lastAdShownTimeKey)
        guard lastShownTime > 0 else { return "Henüz reklam gösterilmedi" }
        
        let currentTime = Date().timeIntervalSince1970
        let remaining = cooldownDuration - (currentTime - lastShownTime)
        
        if remaining > 0 {
            let minutes = Int(remaining) / 60
            let seconds = Int(remaining) % 60
            return "\(minutes)dk \(seconds)sn"
        }
        return "Hazır"
    }
}
