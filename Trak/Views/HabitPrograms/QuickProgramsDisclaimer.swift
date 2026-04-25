//
//  QuickProgramsDisclaimer.swift
//  Trak
//
//  Created by Ege Özçelik on 25.10.2025.
//

import SwiftUI

struct QuickProgramsDisclaimerView: View {
    @Binding var isPresented: Bool
    @Binding var disclaimerAccepted: Bool
    @State private var animateContent = false
    @State private var hasScrolledToBottom = false
    @State private var confirmationChecked = false
    @State private var selectedLanguage: DisclaimerLanguage = .english
    
    private var strings: QuickProgramsDisclaimerStrings {
        QuickProgramsDisclaimerStrings(language: selectedLanguage)
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                
                GeometryReader { geometry in
                    ScrollView {
                        VStack(spacing: 32) {
                            // Language Selector Switch
                            HStack {
                                Spacer()
                                
                                HStack(spacing: 0) {
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedLanguage = .english
                                        }
                                    }) {
                                        HStack(spacing: 6) {
                                            Text("EN")
                                                .font(.system(size: 14, weight: selectedLanguage == .english ? .semibold : .light))
                                        }
                                        .foregroundColor(selectedLanguage == .english ? .white : .secondary)
                                        .frame(width: 70, height: 36)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(selectedLanguage == .english ? Color.blue : Color.clear)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedLanguage = .turkish
                                        }
                                    }) {
                                        HStack(spacing: 6) {
                                            Text("TR")
                                                .font(.system(size: 14, weight: selectedLanguage == .turkish ? .semibold : .light))
                                        }
                                        .foregroundColor(selectedLanguage == .turkish ? .white : .secondary)
                                        .frame(width: 70, height: 36)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(selectedLanguage == .turkish ? Color.blue : Color.clear)
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(.systemGray6))
                                )
                                .padding(.trailing, 4)
                            }
                            .id(selectedLanguage)
                            
                            // Header
                            VStack(spacing: 24) {
                                VStack(spacing: 12) {
                                    Text(strings.welcome)
                                        .font(.system(size: 20, weight: .medium))
                                        .foregroundColor(.primary)
                                    
                                    Text(strings.subtitle)
                                        .font(.system(size: 16, weight: .light))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .id(selectedLanguage)
                            }
                            
                            // What Are Quick Programs
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 12) {
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.orange)
                                        .font(.title2)
                                    
                                    Text(strings.whatArePrograms)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                Text(strings.programsDescription)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.primary)
                                    .lineSpacing(4)
                                
                                Text(strings.programsDetail)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.secondary)
                                    .lineSpacing(4)
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.blue.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .id(selectedLanguage)
                            
                            // Important Notice
                            VStack(alignment: .leading, spacing: 20) {
                                HStack(spacing: 12) {
                                    Image(systemName: "info.circle.fill")
                                        .foregroundColor(.orange)
                                        .font(.title2)
                                    
                                    Text(strings.importantInfo)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                VStack(alignment: .leading, spacing: 16) {
                                    InfoPoint(
                                        number: "1",
                                        title: strings.point1Title,
                                        description: strings.point1Description
                                    )
                                    
                                    InfoPoint(
                                        number: "2",
                                        title: strings.point2Title,
                                        description: strings.point2Description
                                    )
                                    
                                    InfoPoint(
                                        number: "3",
                                        title: strings.point3Title,
                                        description: strings.point3Description
                                    )
                                    
                                    InfoPoint(
                                        number: "4",
                                        title: strings.point4Title,
                                        description: strings.point4Description
                                    )
                                    
                                    InfoPoint(
                                        number: "5",
                                        title: strings.point5Title,
                                        description: strings.point5Description
                                    )
                                }
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.orange.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .id(selectedLanguage)
                            
                            // Emergency Warning
                            HStack(spacing: 12) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.red)
                                    .font(.title2)
                                
                                Text(strings.emergencyWarning)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.red.opacity(0.1))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.red.opacity(0.5), lineWidth: 2)
                                    )
                            )
                            .id(selectedLanguage)
                            
                            // Age Restriction
                            HStack(spacing: 12) {
                                Image(systemName: "18.circle")
                                    .font(.title2)
                                    .foregroundColor(.secondary)
                                
                                Text(strings.ageRestriction)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.secondary)
                            }
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(.systemGray6))
                            )
                            .id(selectedLanguage)
                            
                            // Confirmation Box
                            VStack(alignment: .leading, spacing: 16) {
                                Text(strings.confirmationText)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.primary)
                                    .lineSpacing(4)
                               
                                Toggle(isOn: $confirmationChecked) {
                                    Text(strings.readAndUnderstood)
                                        .font(.system(size: 15, weight: .regular))
                                        .foregroundColor(.primary)
                                        .lineSpacing(4)
                                }
                                .toggleStyle(SwitchToggleStyle(tint: .blue))
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(.systemBackground))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(confirmationChecked ? Color.blue : Color(.systemGray4), lineWidth: confirmationChecked ? 2 : 1)
                                    )
                            )
                            .id(selectedLanguage)
                            
                            // Bottom marker
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 1)
                                .background(
                                    GeometryReader { innerGeometry in
                                        Color.clear
                                            .preference(
                                                key: ScrollOffsetPreferenceKey.self,
                                                value: innerGeometry.frame(in: .named("scroll")).maxY
                                            )
                                    }
                                )
                            
                            Spacer().frame(height: 140)
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        let threshold = geometry.size.height + 50
                        if value <= threshold && !hasScrolledToBottom {
                            withAnimation(.easeOut(duration: 0.5)) {
                                hasScrolledToBottom = true
                            }
                        }
                    }
                }
                
                // Floating Action Button
                VStack {
                    Spacer()
                    
                    VStack(spacing: 12) {
                        // Progress indicator
                        if !hasScrolledToBottom {
                            HStack(spacing: 8) {
                                Image(systemName: "arrow.down.circle")
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.blue)
                                Text(strings.scrollPrompt)
                                    .font(.system(size: 13, weight: .medium))
                                    .foregroundColor(.blue)
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule()
                                    .fill(Color.blue.opacity(0.1))
                                    .overlay(
                                        Capsule()
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .transition(.opacity)
                        }
                        
                        // Accept Button
                        Button(action: {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                                disclaimerAccepted = true
                                isPresented = false
                                UserDefaults.standard.set(true, forKey: "quickProgramsDisclaimerAccepted")
                            }
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18, weight: .medium))
                                Text(strings.continueButton)
                                    .font(.system(size: 17, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(canProceed ? Color.blue : Color.gray.opacity(0.3))
                            )
                            .shadow(color: canProceed ? Color.blue.opacity(0.4) : .clear, radius: 12, x: 0, y: 6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(canProceed ? Color.blue.opacity(0.5) : .clear, lineWidth: 1)
                            )
                        }
                        .disabled(!canProceed)
                        .scaleEffect(canProceed ? 1.0 : 0.98)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: canProceed)
                    }
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
        }
        .interactiveDismissDisabled()
        .onAppear {
            withAnimation {
                animateContent = true
            }
        }
    }
    
    private var canProceed: Bool {
        hasScrolledToBottom && confirmationChecked
    }
}

// MARK: - Quick Programs Disclaimer Strings
struct QuickProgramsDisclaimerStrings {
    let language: DisclaimerLanguage
    
    var welcome: String {
        switch language {
        case .turkish: return "Hazır Programlara Hoş Geldin"
        case .english: return "Welcome to Fresh Start"
        }
    }
    
    var subtitle: String {
        switch language {
        case .turkish: return "Trackie Fresh Start ile Alışkanlık Yolculuğuna Başla"
        case .english: return "Start Your Habit Journey with Pre-Defined Programs"
        }
    }
    
    var whatArePrograms: String {
        switch language {
        case .turkish: return "Hazır Programlar Nedir?"
        case .english: return "What Are Quick Programs?"
        }
    }
    
    var programsDescription: String {
        switch language {
        case .turkish: return "Fresh Start bölümündeki hazır programlar, alışkanlık oluşturma sürecinizde size ilham vermek ve rehberlik etmek için tasarlanmış şablonlardır."
        case .english: return "The Quick Programs in Fresh Start are templates designed to inspire and guide you in your habit-building journey."
        }
    }
    
    var programsDetail: String {
        switch language {
        case .turkish: return "Bu programlar, bilimsel araştırmalar ve uzman önerileri temelinde hazırlanmış genel çerçevelerdir. Her bireyin ihtiyaçları farklı olduğundan, bu şablonları kendi hedeflerinize göre özelleştirmeniz önerilir."
        case .english: return "These programs are general frameworks based on scientific research and expert recommendations. Since everyone's needs are different, we recommend customizing these templates according to your own goals."
        }
    }
    
    var importantInfo: String {
        switch language {
        case .turkish: return "Önemli Bilgilendirme"
        case .english: return "Important Information"
        }
    }
    
    var point1Title: String {
        switch language {
        case .turkish: return "Şablon Niteliğinde İçerik"
        case .english: return "Template Content"
        }
    }
    
    var point1Description: String {
        switch language {
        case .turkish: return "Hazır programlar, yönlendirici şablonlardır ve kişisel sağlık durumunuz, fiziksel kapasiteniz veya özel ihtiyaçlarınız göz önünde bulundurmadan hazırlanmıştır. Bu programları kullanmadan önce kendi durumunuza uygunluğunu değerlendirmeniz sizin sorumluluğunuzdadır."
        case .english: return "Quick programs are guideline templates and do not take into account your personal health status, physical capacity, or special needs. It's your responsibility to evaluate their suitability for your situation before using these programs."
        }
    }
    
    var point2Title: String {
        switch language {
        case .turkish: return "Kişiselleştirme Gereklidir"
        case .english: return "Customization Required"
        }
    }
    
    var point2Description: String {
        switch language {
        case .turkish: return "Bu programlar genel öneriler içermektedir. Kendinize uygun olmayan alışkanlıkları çıkarabilir, hedefleri değiştirebilir veya yeni alışkanlıklar ekleyebilirsiniz. Programları olduğu gibi takip etmek yerine, kendi yaşam tarzınıza adapte edin."
        case .english: return "These programs contain general recommendations. You can remove habits that don't suit you, change goals, or add new habits. Instead of following programs as-is, adapt them to your own lifestyle."
        }
    }
    
    var point3Title: String {
        switch language {
        case .turkish: return "Tıbbi Tavsiye Değildir"
        case .english: return "Not Medical Advice"
        }
    }
    
    var point3Description: String {
        switch language {
        case .turkish: return "Hazır programlardaki içerikler eğitim ve bilinçlendirme amaçlıdır. Tıbbi teşhis, tedavi veya profesyonel danışmanlık yerine geçmez. Sağlık, beslenme veya egzersiz konularında profesyonel destek gerekiyorsa, lütfen alanında uzman kişilerle görüşün."
        case .english: return "The content in quick programs is for educational and awareness purposes. It does not replace medical diagnosis, treatment, or professional consultation. If you need professional support in health, nutrition, or exercise matters, please consult with qualified experts."
        }
    }
    
    var point4Title: String {
        switch language {
        case .turkish: return "Sorumluluk Reddi"
        case .english: return "Disclaimer"
        }
    }
    
    var point4Description: String {
        switch language {
        case .turkish: return "Hazır programları kullanarak oluşabilecek herhangi bir sakatlık, sağlık sorunu veya olumsuz sonuçtan uygulama geliştiricisi ve Trackie sorumlu tutulamaz. Bu programları kullanmayı seçerken, kendi riskinizle hareket ettiğinizi kabul etmiş olursunuz."
        case .english: return "The app developer and Trackie cannot be held responsible for any injury, health problem, or negative consequences that may arise from using quick programs. By choosing to use these programs, you acknowledge that you are acting at your own risk."
        }
    }
    
    var point5Title: String {
        switch language {
        case .turkish: return "İçeriklerin Güncellenmesi"
        case .english: return "Content Updates"
        }
    }
    
    var point5Description: String {
        switch language {
        case .turkish: return "Trackie, önceden haber vermeksizin program içeriklerini güncelleme, değiştirme veya kaldırma hakkını saklı tutar. Bilimsel bilgi dinamiktir ve sürekli gelişir."
        case .english: return "Trackie reserves the right to update, modify, or remove program content without prior notice. Scientific knowledge is dynamic and constantly evolving."
        }
    }
    
    var emergencyWarning: String {
        switch language {
        case .turkish: return "Kendinize veya başkalarına zarar verme düşünceleriniz varsa, derhal 112'yi arayın veya en yakın acil servise başvurun."
        case .english: return "If you have thoughts of harming yourself or others, immediately call emergency services or go to the nearest emergency room."
        }
    }
    
    var ageRestriction: String {
        switch language {
        case .turkish: return "18 yaşından küçükseniz, ebeveyn veya vasi gözetiminde kullanın."
        case .english: return "If you are under 18, use under parental or guardian supervision."
        }
    }
    
    var confirmationText: String {
        switch language {
        case .turkish: return "Hazır programların şablon niteliğinde olduğunu, kişiselleştirme gerektirdiğini ve tıbbi tavsiye içermediğini anladım. Bu programları kullanarak oluşabilecek sonuçlardan kendimin sorumlu olduğumu kabul ediyorum."
        case .english: return "I understand that quick programs are templates, require customization, and do not contain medical advice. I accept that I am responsible for any consequences that may arise from using these programs."
        }
    }
    
    var readAndUnderstood: String {
        switch language {
        case .turkish: return "Okudum ve anladım."
        case .english: return "I have read and understood."
        }
    }
    
    var scrollPrompt: String {
        switch language {
        case .turkish: return "Devam etmek için aşağı kaydırın"
        case .english: return "Scroll down to continue"
        }
    }
    
    var continueButton: String {
        switch language {
        case .turkish: return "Anladım, Devam Et"
        case .english: return "I Understand, Continue"
        }
    }
}
