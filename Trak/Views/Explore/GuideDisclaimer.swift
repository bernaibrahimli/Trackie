import SwiftUI

// MARK: - Language Support
enum DisclaimerLanguage: String, CaseIterable {
    case turkish = "TR"
    case english = "EN"
    
    var flag: String {
        switch self {
        case .turkish: return "🇹🇷"
        case .english: return "🇬🇧"
        }
    }
}

// MARK: - Localized Strings
struct DisclaimerStrings {
    let language: DisclaimerLanguage
    
    var welcome: String {
        switch language {
        case .turkish: return "Trackie Deep Dive'a Hoş Geldin"
        case .english: return "Welcome to Trackie Deep Dive"
        }
    }
    
    var subtitle: String {
        switch language {
        case .turkish: return "Alışkanlıkların Bilimsel Arka Planını Keşfet"
        case .english: return "Discover the Science Behind Your Habits"
        }
    }
    
    var ourMission: String {
        switch language {
        case .turkish: return "Amacımız"
        case .english: return "Our Mission"
        }
    }
    
    var missionText: String {
        switch language {
        case .turkish: return "Trackie olarak amacımız, sizi alışkanlık oluşturma konusunda bilimsel araştırmalar ışığında bilinçlendirmek ve bu yolculukta size destek olmaktır."
        case .english: return "As Trackie, our mission is to educate you about habit formation through scientific research and support you on this journey."
        }
    }
    
    var missionDetail: String {
        switch language {
        case .turkish: return "Paylaştığımız içerikler, psikoloji, nörobilim, beslenme ve kronobiyoloji gibi alanlardaki güncel araştırmalar ve uzman ekibimiz ile derlenmiştir."
        case .english: return "Our content is compiled from current research in fields such as psychology, neuroscience, nutrition, and chronobiology, along with our expert team."
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
        case .turkish: return "Eğitim Amaçlı İçerik"
        case .english: return "Educational Content"
        }
    }
    
    var point1Description: String {
        switch language {
        case .turkish: return "Bu uygulama, kişisel gelişim ve bilinçlendirme amacıyla tasarlanmıştır. Tıbbi bir teşhis, tedavi veya danışmanlık aracı değildir."
        case .english: return "This app is designed for personal development and awareness purposes. It is not a medical diagnosis, treatment, or consultation tool."
        }
    }
    
    var point2Title: String {
        switch language {
        case .turkish: return "Bilimsel Araştırmalar"
        case .english: return "Scientific Research"
        }
    }
    
    var point2Description: String {
        switch language {
        case .turkish: return "İçeriklerimiz akademik kaynaklardan derlenmiştir. Ancak bilimsel bilgi sürekli gelişir ve sonuçlar kişiden kişiye değişebilir. Güncelliği ve mutlak doğruluğu garanti verilemez."
        case .english: return "Our content is compiled from academic sources. However, scientific knowledge constantly evolves and results may vary from person to person. Currency and absolute accuracy cannot be guaranteed."
        }
    }
    
    var point3Title: String {
        switch language {
        case .turkish: return "Profesyonel Destek"
        case .english: return "Professional Support"
        }
    }
    
    var point3Description: String {
        switch language {
        case .turkish: return "Sağlık, beslenme veya psikolojik konularda profesyonel desteğe ihtiyaç duyuyorsanız, lütfen alanında uzman kişilerle görüşün."
        case .english: return "If you need professional support in health, nutrition, or psychological matters, please consult with qualified experts in those fields."
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
        case .turkish: return "Bu uygulamayı kullanarak, verilen bilgileri kendi sağlık durumunuz ve kişisel koşullarınız bağlamında değerlendirme sorumluluğunu kabul etmiş olursunuz. Uygulama geliştiricisi ve Trackie, içeriklerin kullanımından doğrudan veya dolaylı olarak kaynaklanan herhangi bir sonuç, zarar veya kayıptan sorumlu tutulamaz."
        case .english: return "By using this app, you accept responsibility for evaluating the provided information in the context of your own health condition and personal circumstances. The app developer and Trackie cannot be held responsible for any result, damage, or loss arising directly or indirectly from the use of the content."
        }
    }
    var changeRightsTitle: String {
        switch language {
        case .turkish:
            return "İçeriklerin Güncellemesi"
        case .english:
            return "Contents Modify"
        }
    }
    var changeRights: String {
        switch language {
        case .turkish:
            return "Trackie, önceden haber vermeksizin içerikleri güncelleme, değiştirme veya kaldırma hakkını saklı tutar."
        case .english:
            return "Trackie reserves the right to update, modify, or remove content without prior notice."
        }
    }
    var emergencyWarning: String {
        switch language {
        case .turkish:
            return "Kendinize veya başkalarına zarar verme düşünceleriniz varsa, derhal 112'yi arayın veya en yakın acil servise başvurun."
        case .english:
            return "If you have thoughts of harming yourself or others, immediately call emergency services or go to the nearest emergency room."
        }
    }
    
    var sourceQuality: String {
        switch language {
        case .turkish: return "Kaynak Kalitemiz"
        case .english: return "Our Source Quality"
        }
    }
    
    var expertTeam: String {
        switch language {
        case .turkish: return "Alanında Uzman Ekibimiz"
        case .english: return "Our Expert Team"
        }
    }
    
    var academicPublications: String {
        switch language {
        case .turkish: return "Akademik Yayınlar"
        case .english: return "Academic Publications"
        }
    }
    
    var universityResearch: String {
        switch language {
        case .turkish: return "Üniversite Araştırmaları"
        case .english: return "University Research"
        }
    }
    
    var sourceNote: String {
        switch language {
        case .turkish: return "Not: Bilimsel bilgi dinamiktir ve sürekli güncellenir. Bu nedenle içeriklerimizin güncelliği ve tam doğruluğu garanti edilemez."
        case .english: return "Note: Scientific knowledge is dynamic and constantly updated. Therefore, the currency and complete accuracy of our content cannot be guaranteed."
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
        case .turkish: return "Bu uygulama 'olduğu gibi' sunulmaktadır ve herhangi bir garanti verilmemektedir. Uygulamanın yalnızca eğitim ve bilinçlendirme amaçlı olduğunu, herhangi bir tıbbi teşhis, tedavi veya profesyonel danışmanlık içermediğini kabul ediyorum. Uygulamadan kaynaklanan doğrudan veya dolaylı herhangi bir sonuç, zarar veya kayıptan kendim sorumlu olduğumu onaylıyorum."
        case .english: return "This app is provided 'as is' without any warranties of any kind. I acknowledge that the app is solely for educational and awareness purposes, does not include any medical diagnosis, treatment, or professional consultation. I confirm that I am personally responsible for any result, damage, or loss arising directly or indirectly from the app."
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

// MARK: - Scroll Position Preference Key
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ExploreDisclaimerView: View {
    @Binding var isPresented: Bool
    @Binding var disclaimerAccepted: Bool
    @State private var animateContent = false
    @State private var hasScrolledToBottom = false
    @State private var confirmationChecked = false
    @State private var selectedLanguage: DisclaimerLanguage = .english
    
    private var strings: DisclaimerStrings {
        DisclaimerStrings(language: selectedLanguage)
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
                            
                            
                            // Mission Statement
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 12) {
                                    Image(systemName: "lightbulb.circle.fill")
                                        .foregroundColor(.orange)
                                        .font(.title2)
                                    
                                    Text(strings.ourMission)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                Text(strings.missionText)
                                    .font(.system(size: 15, weight: .regular))
                                    .foregroundColor(.primary)
                                    .lineSpacing(4)
                                
                                Text(strings.missionDetail)
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
                                        title: strings.changeRightsTitle,
                                        description: strings.changeRights
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
                            
                            // Sources Quality
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(spacing: 12) {
                                    Image(systemName: "checkmark.seal.fill")
                                        .foregroundColor(.green)
                                        .font(.title2)
                                    
                                    Text(strings.sourceQuality)
                                        .font(.system(size: 18, weight: .semibold))
                                        .foregroundColor(.primary)
                                }
                                
                                VStack(alignment: .leading, spacing: 12) {
                                    SourceBadge(
                                        icon: "person.fill",
                                        text: strings.expertTeam,
                                        color: .orange
                                    )
                                    SourceBadge(
                                        icon: "building.columns",
                                        text: strings.academicPublications,
                                        color: .orange
                                    )
                                    SourceBadge(
                                        icon: "graduationcap",
                                        text: strings.universityResearch,
                                        color: .orange
                                    )
                                }
                                
                                Text(strings.sourceNote)
                                    .font(.system(size: 13, weight: .regular))
                                    .foregroundColor(.secondary)
                                    .lineSpacing(3)
                                    .padding(.top, 8)
                            }
                            .padding(20)
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.green.opacity(0.05))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.green.opacity(0.2), lineWidth: 1)
                                    )
                            )
                            .id(selectedLanguage)
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
                                UserDefaults.standard.set(true, forKey: "exploreDisclaimerAccepted") // buraya eklenecek

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

// MARK: - Supporting Components

struct InfoPoint: View {
    let number: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text(number)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.blue)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(Color.blue.opacity(0.15))
                )
            
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.secondary)
                    .lineSpacing(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct SourceBadge: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(color)
                .frame(width: 24, height: 24)
                .background(color.opacity(0.15))
                .cornerRadius(6)
            
            Text(text)
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.primary)
            
            Spacer()
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(color.opacity(0.05))
        )
    }
}

// MARK: - Preview
struct ExploreDisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ExploreDisclaimerView(
                isPresented: .constant(true),
                disclaimerAccepted: .constant(false)
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("Turkish")
            
            ExploreDisclaimerView(
                isPresented: .constant(true),
                disclaimerAccepted: .constant(false)
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("English")
        }
    }
}
