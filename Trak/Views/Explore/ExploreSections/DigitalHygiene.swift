//
//  DigitalHygenie.swift
//  Trak
//
//  Created by Ege Özçelik on 20.09.2025.
//



import SwiftUI
import Charts

struct DigitalHygieneSectionView: View {
    @State private var isExpanded = false
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 10) {
            SectionHeaderStrip(
                icon: "iphone",
                title: "Digital Hygiene",
                subtitle: "Managing screen time and digital wellness",
                gradientColors: [
                    Color.pink.opacity(0.9),
                    Color.purple.opacity(0.8),
                    Color.purple.opacity(0.6),
                    Color.purple.opacity(0.4),
                    Color.purple.opacity(0.2),
                    Color.clear
                ]
            )
            

            Text("Dijital cihazlarla geçirilen yoğun zaman, dikkat, uyku kalitesi ve sosyal ilişkiler üzerinde etkili olabileceği düşünülen bir faktördür.")
                .font(.body)
                .padding(.horizontal)
                .padding(.bottom, 15)
            
            VStack(alignment: .leading, spacing: 15) {
                Text("Zihnin Pazaryeri")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("""
                    Pink!!
                    
                    * Telefonunu kontrol eder *
                    """)
                    .font(.headline)
                
                Text("""
                    Sosyal medya platformları, kullanıcı etkileşimini artırmak amacıyla dikkat çekici içerik akışları ve bildirim sistemleri gibi psikolojik prensiplerden yararlanır. Sonsuz kaydırma, anlık bildirimler ve değişken ödül sistemleri beynimizi sürekli uyarılmış halde tutmak içindir. 
                    
                    Amerika’da yapılan bir araştırmaya göre, ortalama bir Amerikalı uyanık olduğu süre boyunca günde **205 kez**, yani yaklaşık her beş dakikada bir kez telefonunu kontrol ediyor. 
                    
                    Bir önceki yıl bu sayı 144’tü. Bu da yalnızca bir yılda **%43,2**’lik bir artış anlamına geliyor.
                    """)
                    .font(.body)
                
                Text("Araştırmadan Öne Çıkan Bulgular:")
                    .font(.headline)
                    .foregroundColor(.pink)
                    .fontWeight(.medium)
                
                Text("""
                    - İnsanlar günde ortalama 205 kez telefonlarını kontrol ediyor.
                    - Katılımcıların %80,6’sı, uyandıktan sonraki ilk 10 dakika içinde telefonuna bakıyor.
                    - %76’sı, bildirim geldikten sonraki beş dakika içinde telefonu kontrol ediyor.
                    - %65,7’si, tuvaletteyken telefonunu kullanıyor.
                    - %43,2’si kendisini “bağımlı” olarak tanımlıyor.
                    """)
                    .font(.body)
                    
            }
            .padding(.horizontal)

            
            // MARK: - Blue Light Impact
            
            
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Screen Time Impact Chart
                ScreenTimeImpactChartView()
                    .padding(.horizontal)
                VStack(alignment: .leading, spacing: 15) {
                    Text("Ekranlardan yayılan mavi ışığın, bazı araştırmalara göre beynin ‘gündüz’ modunda kalmasına neden olabileceği düşünülmektedir. Bu durum, melatonin üretimini etkileyerek sirkadiyen ritmi değiştirebilir. Akşam ekran kullanımı uyku kalitesini doğrudan etkiler.")
                        .font(.body)
                    
                    Text("Bazı araştırmalara göre yatmadan 2 saat önce ekran kullanımı, melatonin üretimini önemli ölçüde azaltabilir — bazı çalışmalarda bu etki %50’ye kadar ölçülmüştür.")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                
                // MARK: - Digital Habits Spectrum
                DigitalHabitsSpectrumView()
                    .padding(.horizontal)
                
                // MARK: - Attention Restoration
                AttentionRestorationView()
                    .padding()
                
                // MARK: - Healthy Digital Boundaries
                HealthyDigitalBoundariesView()
                    .padding(.horizontal)
                
                // MARK: - Notification Management
                NotificationManagementView()
                    .padding(.horizontal)
                DigitalHygieneSourcesView()
                    .padding()
             
             
            }
           
            BreathingGlowFooterView()
        }
    }
}

// MARK: - Screen Time Impact Chart
struct ScreenTimeImpactChartView: View {
    let screenTimeData = [
        ScreenTimeImpact(category: "Uyku Kalitesi", score: -35),
        ScreenTimeImpact(category: "Odaklanma", score: -42),
        ScreenTimeImpact(category: "Sosyal İlişki", score: -28),
        ScreenTimeImpact(category: "Üretkenlik", score: -38),
        ScreenTimeImpact(category: "Ruh Hali", score: -31)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Aşırı Ekran Kullanımının Etkileri")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Günde 6+ saat ekran kullanımının yaşam kalitesi üzerindeki tahmini negatif etkileri (%):")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Chart(screenTimeData) { item in
                BarMark(
                    x: .value("Etki", item.score),
                    y: .value("Kategori", item.category)
                )
                .foregroundStyle(.red.gradient)
                .cornerRadius(4)
            }
            .chartXAxisLabel("Etki Yüzdesi")
            .chartXScale(domain: -50...0)
            .frame(height: 220)
            
            Text("⚠️ Not: Bu veriler ekran süresine değil, kullanım şekline de bağlıdır")
                .font(.caption)
                .foregroundColor(.orange)
                .fontWeight(.medium)
        }
    }
}

struct ScreenTimeImpact: Identifiable {
    let id = UUID()
    let category: String
    let score: Int
}

// MARK: - Digital Habits Spectrum
struct DigitalHabitsSpectrumView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Dijital Kullanım Spektrumu")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Ekran kullanımının farklı kategorileri ve etkileri:")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                DigitalHabitCard(
                    icon: "checkmark.circle.fill",
                    iconColor: .green,
                    type: "Yapıcı Kullanım",
                    description: "Öğrenme, yaratıcı çalışma, anlamlı iletişim",
                    examples: ["Online kurs", "Podcast dinleme", "Uzun mesajlaşma"],
                    impact: "Pozitif"
                )
                
                DigitalHabitCard(
                    icon: "minus.circle.fill",
                    iconColor: .orange,
                    type: "Nötr Kullanım",
                    description: "Planlama, organize etme, bilgi erişimi",
                    examples: ["E-posta", "Takvim", "Harita kullanımı"],
                    impact: "Nötr"
                )
                
                DigitalHabitCard(
                    icon: "exclamationmark.circle.fill",
                    iconColor: .red,
                    type: "Tüketici Kullanım",
                    description: "Pasif kaydırma, otomatik izleme, tepkisel kontrol",
                    examples: ["Sonsuz scroll", "Otomatik video", "Bildirim kontrolü"],
                    impact: "Negatif"
                )
            }
        }
    }
}

struct DigitalHabitCard: View {
    let icon: String
    let iconColor: Color
    let type: String
    let description: String
    let examples: [String]
    let impact: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(iconColor)
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(type)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Text(impact)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(iconColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(iconColor.opacity(0.1))
                    .cornerRadius(6)
            }
            
            HStack {
                Text(examples.joined(separator: " • "))
                    .font(.caption2)
                    .foregroundColor(iconColor)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Attention Restoration
struct AttentionRestorationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.purple)
                    .font(.title2)
                Text("Dikkat Restorasyonu Teorisi")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Text("Dijital cihazlar **yönlendirilmiş dikkat** gerektirir ve bu yorucudur. Doğa ve çevrimdışı aktiviteler genellikle daha az zihinsel efor gerektirir ve bazı çalışmalarda bilişsel dinlenme sağladığı gözlemlenmiştir. İşte size iyi gelebilecek bazı alışkanlıklar ve etkileri.")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                AttentionRestoreCard(
                    activity: "🌳 Doğa Yürüyüşü",
                    duration: "20 dakika",
                    restoration: "Maksimum",
                    benefit: "Prefrontal korteksi dinlendirir"
                    
                )
                
                AttentionRestoreCard(
                    activity: "📖 Fiziksel Kitap",
                    duration: "15 dakika",
                    restoration: "Yüksek",
                    benefit: "Derin odaklanma pratiği",
                    
                )
                
                AttentionRestoreCard(
                    activity: "🧘‍♀️ Meditasyon",
                    duration: "10 dakika",
                    restoration: "Yüksek",
                    benefit: "Zihinsel dinlenme",
                    
                )
                
                AttentionRestoreCard(
                    activity: "🎨 El Sanatları",
                    duration: "30 dakika",
                    restoration: "Orta-Yüksek",
                    benefit: "Yaratıcı akış",
                   
                )
            }
        }
    }
}

struct AttentionRestoreCard: View {
    let activity: String
    let duration: String
    let restoration: String
    let benefit: String
    
    private var restorationColor: Color {
        switch restoration {
        case "Maksimum": return .green
        case "Yüksek": return .blue
        case "Orta-Yüksek": return .orange
        default: return .gray
        }
    }
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(activity)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Text(duration)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Text(benefit)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                HStack {
                    Text("Restorasyon:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    
                    Text(restoration)
                        .font(.caption2)
                        .fontWeight(.medium)
                        .foregroundColor(restorationColor)
                    
                    Spacer()
                  
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Healthy Digital Boundaries
struct HealthyDigitalBoundariesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Sağlıklı Dijital Sınırlar Oluşturma")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Teknoloji kullanımınız üzerinde bilinçli kontrol kurmanın yolları:")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 10) {
                BoundaryCard(
                    icon: "bed.double.fill",
                    title: "Yatak Odası = Telefonsuz Bölge",
                    description: "Telefonu yatak odası dışında bırakmak, bazı kişilerde daha iyi uyku kalitesiyle ilişkilendirilmiştir.",
                    reason: "Uyku kalitenizi arttırır",
                )
                
                BoundaryCard(
                    icon: "fork.knife",
                    title: "Yemek Zamanı Offline",
                    description: "Yemeklerde telefondan uzak kalmak, sosyal bağ ve farkındalığı artırabilir.",
                    reason: "Sindirimi iyileştirir, sosyal bağı güçlendirir",
                )
                
                BoundaryCard(
                    icon: "figure.walk",
                    title: "Kulaklıksız Yürüyüş",
                    description: "Belirli zamanlarda sessiz yürüyüş yapın",
                    reason: "Zihinsel netlik ve yaratıcılık artar",
                )
                
                BoundaryCard(
                    icon: "moon.stars.fill",
                    title: "Akşam Dijital Kapanış",
                    description: "Uyumadan önce belirli saatten sonra tüm ekranlardan uzaklaşın",
                    reason: "Melatonin dengesi desteklenir",
                )
            }
        }
    }
}

struct BoundaryCard: View {
    let icon: String
    let title: String
    let description: String
    let reason: String
    
   
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.purple)
                .frame(width: 40, height: 40)
                .background(Color.purple.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.semibold)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("💡 \(reason)")
                    .font(.caption)
                    .foregroundColor(.purple)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(10)
    }
}

// MARK: - Notification Management
struct NotificationManagementView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "bell.slash.circle.fill")
                    .foregroundColor(.red)
                    .font(.title2)
                Text("Bildirim Minimalizmi")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Text("Her gelen bildirim, dikkatinizi anlık olarak böler ve zihninizi yeniden toplamak dakikalar sürebilir. Bildirimleri bir anda değil, aşama aşama azaltmak; odağınızı korumanın en sürdürülebilir yoludur.")
                .font(.body)
                .foregroundColor(.secondary)
            Text("🎯 Örnek bir yol haritası")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.blue)
                .padding(.top, 8)
            VStack(spacing: 12) {
                NotificationTierCard(
                    tier: "Aşama 1",
                    description: "Gereksiz bildirimleri kapatın",
                    apps: ["Sosyal medya", "Oyunlar", "Haber uygulamaları"],
                    notifCount: "30+ → 15 / gün",
                    color: .red
                )
                
                NotificationTierCard(
                    tier: "Aşama 2",
                    description: "Önemli olmayan uygulamaları sessize alın",
                    apps: ["E-posta", "Takvim", "Hatırlatıcılar"],
                    notifCount: "15 → 8 / gün",
                    color: .orange
                )
                
                NotificationTierCard(
                    tier: "Aşama 3",
                    description: "Yalnızca acil durum bildirimlerini açık bırakın",
                    apps: ["Telefon", "Mesajlar (önemli kişiler)", "Alarm"],
                    notifCount: "8 → 3 / gün",
                    color: .green
                )
            }

            

        }
    }
}

struct NotificationTierCard: View {
    let tier: String
    let description: String
    let apps: [String]
    let notifCount: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(tier)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(notifCount)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(color.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(apps.joined(separator: ", "))
                .font(.caption)
                .foregroundColor(color)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(color.opacity(0.05))
                .cornerRadius(6)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}


struct DigitalHygieneSourcesView: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.title3)
                        .foregroundColor(.white)
                    
                    Text("Kaynaklar")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up.circle.fill" : "chevron.down.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Güncelliğini kontrol edin.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        SourceCard(
                            section: "Cell Phone Usage",
                            source: "Cell Phone Usage Stats 2025 by Trevor Wheelwright",
                            year: "2025",
                            url: "https://www.reviews.org/mobile/cell-phone-addiction/"
                        )
                        
                        SourceCard(
                            section: "Mavi Işık ve Melatonin Etkisi",
                            source: "Harvard Health - Blue Light and Sleep",
                            year: "2020",
                            url: "https://www.health.harvard.edu/staying-healthy/blue-light-has-a-dark-side"
                        )
                        
                        SourceCard(
                            section: "Telefon Ayrılık Anksiyetesi",
                            source: "Harvard Business School - iPhone Separation Study",
                            year: "2018",
                            url: "https://www.hbs.edu/faculty/Pages/item.aspx?num=54883"
                        )
                        
                        SourceCard(
                            section: "Sosyal Medya ve Mental Sağlık",
                            source: "Journal of Social and Clinical Psychology",
                            year: "2019",
                            url: "https://guilfordjournals.com/doi/10.1521/jscp.2018.37.10.751"
                        )
                        
                        
                        
                        SourceCard(
                            section: "Ekran Süresi ve Uyku Kalitesi",
                            source: "National Sleep Foundation - Screen Time Guidelines",
                            year: "2020",
                            url: "https://www.sleepfoundation.org/bedroom-environment/blue-light"
                        )
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}


// MARK: - Preview
#Preview {
    NavigationView {
        ScrollView {
            DigitalHygieneSectionView()
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}

