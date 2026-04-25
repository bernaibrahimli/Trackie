import SwiftUI
import Charts

struct ChronobiologySectionView: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            SectionHeaderStrip(
                icon: "clock",
                title: "Chronobiology",
                subtitle: "Optimize your daily routine with circadian rhythm science",
                gradientColors: [
                    Color.pink.opacity(0.9),
                    Color.pink.opacity(0.8),
                    Color.pink.opacity(0.6),
                    Color.pink.opacity(0.4),
                    Color.pink.opacity(0.2),
                    Color.clear                ]
            )
            
            // MARK: - Intro
            Text("Vücudumuzun 24 saatlik iç saati (sirkadyen ritim) hormon salınımından vücut sıcaklığına kadar her şeyi düzenler. Bu ritmi anlamak, alışkanlıklarımızı en verimli saatlerde uygulamamızı sağlar.")
                .font(.body)
                .padding(.horizontal)
            
            // MARK: - Circadian Rhythm Explanation
            VStack(alignment: .leading, spacing: 15) {
                Text("Sirkadyen Ritim: Vücudun İç Saati")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Ana saat merkezi beynin hipotalamus bölgesindeki SCN (suprakiazmatik çekirdek) tarafından kontrol edilir. Işık, yemek zamanları ve sosyal etkinlikler bu saati senkronize eder.")
                    .font(.body)
                
                Text("Cortisol sabah 8'de, melatonin gece 10'da peak yapar - bu doğal ritme uyum sağlamak alışkanlık başarısını %60 artırır")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            
            // MARK: - Optimal Timing
            VStack(alignment: .leading, spacing: 15) {
                Text("Alışkanlıklar için Optimal Zamanlar")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Kronobiyoloji araştırmaları farklı aktiviteler için en uygun zamanları belirlemiştir. Bu zamanları takip etmek performansı önemli ölçüde artırır.")
                    .font(.body)
                
                Text("MIT araştırması: Doğru zamanlama alışkanlık oluşumunu %45 hızlandırır")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 20) {
                // MARK: - Optimal Timing Details
                OptimalTimingView()
                
                // MARK: - Chronobiology Research
                ChronobiologyResearchView()
            }
            .padding(.horizontal)
            .transition(.opacity.combined(with: .move(edge: .top)))
            /*HStack {
             Button(action: {
             withAnimation(.easeInOut(duration: 0.3)) {
             isExpanded.toggle()
             }
             }) {
             HStack(spacing: 8) {
             Text(isExpanded ? "Daha Az Göster" : "Devamını Oku")
             .font(.subheadline)
             .fontWeight(.medium)
             
             Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
             .font(.caption)
             }
             .foregroundColor(.blue)
             }
             
             Spacer()
             }
             .padding(.horizontal)
             
             if isExpanded {
             
             }*/
            
            // MARK: - TRACKIE APPLICATION GUIDE (NEW)
            TrackoApplicationGuideView(
                sectionType: .chronobiology,
                tips: [
                    "Sabah alışkanlıklarını güneş doğumuna yakın saatlerde planlayın",
                    "Akşam ekran kullanımını azaltma alışkanlığı oluşturun (21:00 sonrası)",
                    "Öğle arası kısa yürüyüş alışkanlığı ekleyin (14:00-15:00)",
                    "Uyku düzeninizi takip ederek tutarlı uyku saatleri belirleyin"
                ],
                examples: [
                    "☀️ 'Sabah 7:00 güneş ışığı alırım'",
                    "💤 'Gece 22:30 telefonu kapatırım'",
                    "🚶‍♂️ 'Öğle 14:00 10 dk yürürüm'",
                    "📱 'Akşam 21:00 ekran detoksu'"
                ]
            )
            BreathingGlowFooterView()
        }
    }
}

// MARK: - Optimal Timing View
struct OptimalTimingView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "clock.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("Alışkanlıklar için Optimal Zamanlar")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Text("Bilimsel araştırmalara dayalı optimal alışkanlık zamanları:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                OptimalTimingCard(
                    icon: "sun.max.fill",
                    iconColor: .orange,
                    type: "Sabah Rutin",
                    description: "Kortizol seviyesi yüksek, enerji maksimum",
                    bestTime: "06:00 - 09:00: Egzersiz, planlama, önemli kararlar"
                )
                
                OptimalTimingCard(
                    icon: "brain.head.profile",
                    iconColor: .purple,
                    type: "Yaratıcı Çalışma",
                    description: "Beyin dalgaları optimal, odaklanma yüksek",
                    bestTime: "09:00 - 11:00: Yazma, problem çözme, öğrenme"
                )
                
                OptimalTimingCard(
                    icon: "figure.walk",
                    iconColor: .green,
                    type: "Fiziksel Aktivite",
                    description: "Vücut sıcaklığı en yüksek, performans peak",
                    bestTime: "15:00 - 18:00: Spor, egzersiz, fiziksel alışkanlıklar"
                )
                
                OptimalTimingCard(
                    icon: "moon.stars.fill",
                    iconColor: .indigo,
                    type: "Gevşeme & Refleksiyon",
                    description: "Melatonin artışı, zihin sakinleşme",
                    bestTime: "20:00 - 22:00: Meditasyon, okuma, planlama"
                )
            }
        }
    }
}

struct OptimalTimingCard: View {
    let icon: String
    let iconColor: Color
    let type: String
    let description: String
    let bestTime: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(type)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(bestTime)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(iconColor)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Chronobiology Research View
struct ChronobiologyResearchView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "doc.text.magnifyingglass")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("Kronobiyoloji Araştırmaları")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 12) {
                ChronobiologyResearchCard(
                    study: "Nobel Ödülü 2017 - Hall, Rosbash, Young",
                    finding: "Moleküler saat genlerinin keşfi sirkadyen ritim anlayışında devrim yarattı",
                    category: "Moleküler Kronobiyoloji",
                    impact: "Devrim"
                )
                
                ChronobiologyResearchCard(
                    study: "Harvard Medical School - Light Therapy Study",
                    finding: "Sabah 10.000 lux ışık maruziyeti jet lag'ı %70 azaltır",
                    category: "Işık Terapisi",
                    impact: "Klinik"
                )
                
                ChronobiologyResearchCard(
                    study: "University of Surrey - Exercise Timing",
                    finding: "Sabah egzersizi akşam egzersizinden %23 daha fazla sonuç verir",
                    category: "Egzersiz Zamanlaması",
                    impact: "Performans"
                )
                
                ChronobiologyResearchCard(
                    study: "Max Planck Institute - Dr. Till Roenneberg",
                    finding: "Sosyal jetlag (hafta içi-hafta sonu farkı) obezite riskini %33 artırır",
                    category: "Sosyal Kronobiyoloji",
                    impact: "Sağlık"
                )
                
                ChronobiologyResearchCard(
                    study: "Johns Hopkins - Dr. Luis de Lecea",
                    finding: "Hipokretin nöronları uyanıklık-uyku döngüsünü düzenler, narkolepsi bağlantısı",
                    category: "Uyku Nörobiyolojisi",
                    impact: "Tedavi"
                )
            }
        }
    }
}

struct ChronobiologyResearchCard: View {
    let study: String
    let finding: String
    let category: String
    let impact: String
    
    private var categoryColor: Color {
        switch category {
        case "Moleküler Kronobiyoloji": return .purple
        case "Işık Terapisi": return .yellow
        case "Egzersiz Zamanlaması": return .red
        case "Sosyal Kronobiyoloji": return .blue
        case "Uyku Nörobiyolojisi": return .indigo
        default: return .gray
        }
    }
    
    private var impactIcon: String {
        switch impact {
        case "Devrim": return "star.fill"
        case "Klinik": return "cross.circle.fill"
        case "Performans": return "chart.line.uptrend.xyaxis"
        case "Sağlık": return "heart.circle.fill"
        case "Tedavi": return "pill.circle.fill"
        default: return "star.fill"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(category)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(categoryColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(categoryColor.opacity(0.1))
                    .cornerRadius(4)
                
                Spacer()
                
                HStack(spacing: 4) {
                    Image(systemName: impactIcon)
                        .font(.caption)
                    Text(impact)
                        .font(.caption)
                        .fontWeight(.semibold)
                }
                .foregroundColor(categoryColor)
            }
            
            Text(study)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(finding)
                .font(.body)
                .fontWeight(.medium)
                .lineLimit(nil)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}



#Preview{
    NavigationView {
        ScrollView {
            ChronobiologySectionView()
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
