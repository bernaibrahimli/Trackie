//
//  DeveloperNote.swift
//  Trak
//
//  Created by Ege Özçelik on 5.10.2025.
//

import SwiftUI

struct DeveloperNoteView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingPrivacyPolicy = false
    @State private var showingTermsOfUse = false
    @State private var language: String = "EN" 
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.black
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(language == "EN" ? "Developer Note" : "Geliştirici Notu")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                
                                Text(language == "EN" ? "From Indigo Cats🐈‍⬛ Team to You" : "Indigo Cats🐈‍⬛ Ekibinden Size")
                                    .font(.headline)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                            Spacer()
                            
                            // Dil Seçim Butonu
                            Button(action: {
                                withAnimation(.easeInOut) {
                                    language = (language == "EN") ? "TR" : "EN"
                                }
                            }) {
                                Text(language)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.white.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            .buttonStyle(.plain)
                        }
                        .padding(.bottom, 10)
                        
                        // İçerik
                        if language == "EN" {
                            englishContent
                        } else {
                            turkishContent
                        }
                        
                        Spacer(minLength: 50)
                    }
                    .padding()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(language == "EN" ? "Close" : "Kapat") {
                        dismiss()
                    }
                    .foregroundColor(.white)
                }
            }
            .sheet(isPresented: $showingPrivacyPolicy) {
                NavigationView {
                    WebView(url: URL(string: "https://egeozcelik.github.io/apps/trackie-privacy.html")!)
                        .navigationTitle("Privacy Policy")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    showingPrivacyPolicy = false
                                }
                            }
                        }
                }
            }
            .sheet(isPresented: $showingTermsOfUse) {
                NavigationView {
                    WebView(url: URL(string: "https://egeozcelik.github.io/apps/trackie-terms.html")!)
                        .navigationTitle("Terms of Use")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Close") {
                                    showingTermsOfUse = false
                                }
                            }
                        }
                }
            }
        }
    }
    
    // MARK: - English Content
    private var englishContent: some View {
        Group {
            Text("""
            🌿 Science shows that change doesn’t happen overnight — it happens with patience and repetition. Every new day is a chance to reshape yourself. Small steps are the foundation of great transformations, and by starting this journey, you’ve already made a big one.

            Remember: you’re building your habits, and each day you do, you move closer to a stronger version of yourself. We’re proud to be part of this process — because we believe in science, but most of all, we believe in the human ability to grow. You are living proof of that. 

            Change is possible — and you’ve already begun. 🌱
            """)
            .font(.body)
            .foregroundColor(.white.opacity(0.9))
            .multilineTextAlignment(.leading)
            
            Divider().background(Color.white.opacity(0.3))
            
            Text("""
            🫰🏻 Thank you for supporting us by purchasing our app. Our mission at Trackie is to help you build habits through awareness based on scientific research — to be a reliable guide on your journey.

            While you grow, we’ll continue improving the app with you. Ready-made programs and Deep Dive sections will be regularly updated — enriched with new studies, habit tips, and scientific findings. 

            Your feedback is invaluable to us. Please share your thoughts — we review your suggestions carefully for future updates. 

            Please keep the app updated — because every new version means a stronger Trackie.
            """)
            .font(.body)
            .foregroundColor(.white.opacity(0.9))
            .multilineTextAlignment(.leading)
            
            Button(action: {
                if let url = URL(string: "mailto:trackiedeveloper@gmail.com?subject=Trackie%20Feedback") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Share Your Thoughts")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .underline()
            }
            .buttonStyle(.plain)
            
            Divider().background(Color.white.opacity(0.3))
            
            Text("""
            🛡️ Your data is safe. At Trackie, we care about your privacy as much as you do. The app is built with a "privacy by design" approach.

            Your habit data stays only on your device; no information is sent to external servers, shared, or tracked online. Simply put, everything inside Trackie stays with you.

            Deleting the app permanently removes all your data and progress. We keep no backups or copies.
            """)
            .font(.body)
            .foregroundColor(.white.opacity(0.9))
            .multilineTextAlignment(.leading)
            
            Divider().background(Color.white.opacity(0.3))
            
            Text("Small but important reminders")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("""
            - This app is designed for personal growth and awareness. The information provided in the Quick Programs (Fresh Start) does **not** constitute medical diagnosis, treatment, or counseling.

            - If you need professional support on health, nutrition, or psychology, please consult qualified experts.

            - By using this app, you acknowledge that you are responsible for evaluating the information provided according to your own health and personal circumstances.

            - Trackie and the developer cannot be held liable for any outcomes, damages, or losses resulting directly or indirectly from the use of the content.

            - Our content is compiled from reliable academic sources. However, scientific knowledge is dynamic. We strive to keep it up to date, but absolute accuracy or completeness cannot be guaranteed.
            """)
            .font(.callout)
            .foregroundColor(.white.opacity(0.8))
            .multilineTextAlignment(.leading)
            
            Divider().background(Color.white.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 20) {
                Button(action: { showingPrivacyPolicy = true }) {
                    Text("Privacy Policy")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .underline()
                }
                Button(action: { showingTermsOfUse = true }) {
                    Text("Terms of Use")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .underline()
                }
            }
        }
    }
    
    // MARK: - Turkish Content
    private var turkishContent: some View {
        Group {
            Text("""
            🌿 Bilim bize gösteriyor ki, değişim bir anda değil, sabırla ve tekrarlarla gerçekleşir. Her yeni gün, kendinizi yeniden şekillendirme fırsatıdır. Küçük adımlar, büyük dönüşümlerin temelidir ve siz bu yolculuğa çıktığınız için zaten büyük bir adım attınız. 

            Unutmayın: alışkanlıklarınızı siz inşa ediyorsunuz, ve her gün bunu yaparken kendinizin daha güçlü bir versiyonuna yaklaşıyorsunuz. Biz, bu sürecin bir parçası olmaktan gurur duyuyoruz. Çünkü biz bilime inanıyoruz, ama en çok insanın kendini dönüştürme gücüne inanıyoruz. Siz bu gücün canlı kanıtısınız. 
            
            Değişim mümkün ve siz bunu zaten başlattınız. 🌱
            """)
            .font(.body)
            .foregroundColor(.white.opacity(0.9))
            .multilineTextAlignment(.leading)
            
            Divider().background(Color.white.opacity(0.3))
            
            Text("""
            🫰🏻 Uygulamamızı satın alarak bize de destek olduğunuz için içtenlikle teşekkür ederiz. Trackie olarak amacımız, alışkanlık oluşturma sürecinde sizi bilimsel araştırmaların ışığında bilinçlendirmek ve bu yolculukta güvenilir bir rehber olmaktır.
            
            Sizin gelişiminiz sürerken, biz de uygulamayı sizinle birlikte geliştirmeye devam edeceğiz.
            Hazır programlar ve Deep Dive bölümlerinin içeriği düzenli olarak güncellenecek; yeni araştırmalar, alışkanlık önerileri ve bilimsel bulgularla zenginleşecek.
            Ayrıca kullanıcı deneyimini sürekli iyileştirerek, Trackie’nin en iyi versiyonunu sunmak için çalışıyor olacağız. 
            
            Geri bildirimleriniz bizim için çok değerli. Lütfen düşüncelerinizi paylaşın; önerilerinizi dikkatle inceleyip gelecek sürümlerde değerlendiriyoruz. 
            
            Sizden ricamız uygulamayı güncel tutmanız — çünkü her yeni sürüm, daha güçlü bir Trackie demek.
            """)
            .font(.body)
            .foregroundColor(.white.opacity(0.9))
            .multilineTextAlignment(.leading)
            
            Button(action: {
                if let url = URL(string: "mailto:trackiedeveloper@gmail.com?subject=Trackie%20Feedback") {
                    UIApplication.shared.open(url)
                }
            }) {
                Text("Düşüncelerini Paylaş")
                    .font(.headline)
                    .foregroundColor(.blue)
                    .underline()
            }
            .buttonStyle(.plain)
            
            Divider().background(Color.white.opacity(0.3))
            
            Text("""
            🛡️ Verileriniz güvende. Trackie olarak gizliliğinize en az sizin kadar önem veriyoruz. Uygulamamız “gizlilik tasarımın bir parçasıdır” anlayışıyla geliştirildi.
            Alışkanlık verileriniz yalnızca sizin cihazınızda saklanır; hiçbir bilgi dış sunuculara gönderilmez, paylaşılmaz ve çevrimiçi olarak takip edilmez. Yani kısaca, Trackie’nin içinde tuttuğunuz her şeyi sadece siz görebilirsiniz.
            
            Uygulamayı kaldırmanız, tüm verilerinizin ve ilerlemenizin kalıcı olarak silinmesi ile sonuçlanacaktır. Bizde hiçbir yedeği veya kaydı tutulmaz.
            """)
            .font(.body)
            .foregroundColor(.white.opacity(0.9))
            .multilineTextAlignment(.leading)
            
            Divider().background(Color.white.opacity(0.3))
            
            Text("Küçük ama önemli hatırlatmalar")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("""
            Bunların farkında olduğunuzu biliyoruz ama yine de belirtmek isteriz:

            - Bu uygulama, kişisel gelişim ve bilinçlendirme amacıyla tasarlanmıştır. Hazır programlar (Fresh Start) bölümünde sunduğumuz bilgiler dahil olmak üzere bu uygulama, **tıbbi teşhis, tedavi veya danışmanlık** niteliği taşımaz.

            - Sağlık, beslenme veya psikolojik konularda profesyonel desteğe ihtiyaç duyuyorsanız, lütfen alanında uzman kişilerele görüşün.

            - Bu uygulamayı kullanarak, verilen bilgileri kendi sağlık durumunuz ve kişisel koşullarınız bağlamında değerlendirme sorumluluğunu kabul etmiş olursunuz.

            - Trackie ve geliştirici, içeriklerin kullanımından doğrudan veya dolaylı olarak kaynaklanabilecek herhangi bir sonuç, zarar veya kayıptan sorumlu tutulamaz.

            - İçeriklerimiz güvenilir akademik kaynaklardan derlenmiştir. Ancak bilimsel bilgi dinamiktir. Biz içeriği güncel tutmak için çabalıyoruz, ancak mutlak doğruluk veya bütünlük garanti edilemez.
            """)
            .font(.callout)
            .foregroundColor(.white.opacity(0.8))
            .multilineTextAlignment(.leading)
            
            Divider().background(Color.white.opacity(0.3))
            
            VStack(alignment: .leading, spacing: 20) {
                Button(action: { showingPrivacyPolicy = true }) {
                    Text("Privacy Policy")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .underline()
                }
                Button(action: { showingTermsOfUse = true }) {
                    Text("Terms of Use")
                        .font(.headline)
                        .foregroundColor(.blue)
                        .underline()
                }
            }
        }
    }
}

#Preview {
    DeveloperNoteView()
}
