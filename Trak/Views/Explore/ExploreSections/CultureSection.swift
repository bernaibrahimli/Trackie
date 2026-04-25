import SwiftUI
import Charts

struct CultureSectionView: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            SectionHeaderStrip(
                icon: "globe",
                title: "Culture",
                subtitle: "Traditional habits from Blue Zones and ancient cultures",
                gradientColors: [
                    Color.blue.opacity(0.9),
                    Color.blue.opacity(0.8),
                    Color.blue.opacity(0.6),
                    Color.blue.opacity(0.4),
                    Color.blue.opacity(0.2),
                    Color.clear
                ]
            )
            
            // MARK: - Intro
            Text("Dünyanın farklı kültürleri sağlıklı yaşamı destekleyen küçük ritüeller geliştirmiştir. Japonların 'Hara Hachi Bu' geleneği ya da İskandinavların doğa ile bağ kurma alışkanlıkları bunlara örnektir.")
                .font(.body)
                .padding(.horizontal)
            
            // MARK: - Japanese Wisdom
            VStack(alignment: .leading, spacing: 15) {
                Text("🇯🇵 Japon Yaşam Felsefesi: Hara Hachi Bu")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("'%80 doyunca ye' prensibini benimseyen Okinawalılar dünyada en uzun yaşayan toplumdur. Bu basit kural aşırı yeme alışkanlığını önler ve metabolizmayı düzenler.")
                    .font(.body)
                
                Text("Okinawa'da 100 yaş üstü insan oranı dünya ortalamasının 5 katı")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            
            // MARK: - Scandinavian Concept
            VStack(alignment: .leading, spacing: 15) {
                Text("🇸🇪 İskandinav Konsepti: Friluftsliv")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("'Açık havada yaşam' anlamına gelen bu felsefe, hava koşulları ne olursa olsun doğada vakit geçirmeyi öğütler. İsveçliler haftada ortalama 5 saat doğada zaman geçirir.")
                    .font(.body)
                
                Text("Doğada vakit geçirmek stres hormonlarını %50 azaltır")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                
                // MARK: - Longevity Chart
                LongevityChartView()
                    .padding(.horizontal)
                
                // MARK: - Blue Zones
                BlueZonesView()
                    .padding(.horizontal)
                
                // MARK: - Cultural Habits Guide
                CulturalHabitsGuideView()
                    .padding()
                
                // MARK: - Traditional Practices
                TraditionalPracticesView()
                    .padding(.horizontal)
                
                // MARK: - Modern Applications
                ModernApplicationsView()
                    .padding()
                
                // MARK: - Cultural Research
                CulturalResearchView()
                    .padding(.horizontal)
                   
            }
            BreathingGlowFooterView()
            
        }
        
    }
}

// MARK: - Longevity Chart
struct LongevityChartView: View {
    let longevityData = [
        LongevityRegion(region: "Okinawa 🇯🇵", lifespan: 87, centenarians: 50, culture: "Hara Hachi Bu"),
        LongevityRegion(region: "Sardinia 🇮🇹", lifespan: 85, centenarians: 22, culture: "Aile Bağları"),
        LongevityRegion(region: "Nicoya 🇨🇷", lifespan: 83, centenarians: 15, culture: "Plan de Vida"),
        LongevityRegion(region: "Ikaria 🇬🇷", lifespan: 84, centenarians: 18, culture: "Siesta & Sosyalleşme"),
        LongevityRegion(region: "Loma Linda 🇺🇸", lifespan: 86, centenarians: 25, culture: "Bitki Bazlı Diyet"),
        LongevityRegion(region: "Dünya Ortalaması 🌍", lifespan: 73, centenarians: 2, culture: "Modern Yaşam")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Mavi Bölgeler: Uzun Yaşam Merkezleri")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Dünya üzerinde insanların en uzun ve sağlıklı yaşadığı bölgeler. Her birinin kendine özgü kültürel sırları var.")
                .font(.body)
                .foregroundColor(.secondary)
            
            Chart(longevityData) { region in
                BarMark(
                    x: .value("Yaşam Süresi", region.lifespan),
                    y: .value("Bölge", region.region)
                )
                .foregroundStyle(
                    region.region.contains("Dünya")
                    ? AnyGradient(Gradient(colors: [.gray.opacity(0.8), .gray]))
                    : AnyGradient(Gradient(colors: [.indigo.opacity(0.8), .indigo]))
                )
                .cornerRadius(4)
            }
            .chartXAxisLabel("Ortalama Yaşam Süresi")
            //.chartXScale(domain: 70...90)
            .frame(height: 250)
            .frame(maxWidth: .infinity) // <- Bu eklenmeli

      
            
            VStack(alignment: .leading, spacing: 8) {
                Text("100 Yaş Üstü İnsan Oranı (10.000 kişide):")
                    .font(.caption)
                    .fontWeight(.semibold)
                
                ForEach(longevityData.prefix(5), id: \.region) { region in
                    HStack {
                        Text(region.region)
                            .font(.caption)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("\(region.centenarians)")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.indigo)
                    }
                }
            }
            .padding(.top, 10)
        }
    }
}

struct LongevityRegion: Identifiable {
    let id = UUID()
    let region: String
    let lifespan: Int
    let centenarians: Int
    let culture: String
}

// MARK: - Blue Zones
struct BlueZonesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Mavi Bölgelerin Ortak Özellikleri")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Dan Buettner'in araştırmasına göre tüm mavi bölgelerde tekrarlanan 9 temel yaşam prensibi:")
                .font(.body)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                BlueZonePrincipleCard(
                    icon: "figure.walk",
                    principle: "Doğal Hareket",
                    description: "Günlük aktivite, spor değil"
                )
                
                BlueZonePrincipleCard(
                    icon: "target",
                    principle: "Yaşam Amacı",
                    description: "Güçlü 'ikigai' hissi"
                )
                
                BlueZonePrincipleCard(
                    icon: "leaf.fill",
                    principle: "Stres Azaltma",
                    description: "Günlük ritual/meditasyon"
                )
                
                BlueZonePrincipleCard(
                    icon: "chart.pie",
                    principle: "80% Kuralı",
                    description: "Hara hachi bu prensibi"
                )
                
                BlueZonePrincipleCard(
                    icon: "carrot.fill",
                    principle: "Bitki Odaklı",
                    description: "Et nadir, sebze bol"
                )
                
                BlueZonePrincipleCard(
                    icon: "wineglass",
                    principle: "Alkol Moderasyonu",
                    description: "Sosyal içim, az miktar"
                )
                
                BlueZonePrincipleCard(
                    icon: "person.3.fill",
                    principle: "Topluluk",
                    description: "Güçlü sosyal bağlar"
                )
                
                BlueZonePrincipleCard(
                    icon: "heart.fill",
                    principle: "Aile Öncelikli",
                    description: "Yaşlılara saygı"
                )
                
                BlueZonePrincipleCard(
                    icon: "hands.sparkles.fill",
                    principle: "Doğru Kabile",
                    description: "Sağlıklı sosyal çevre"
                )
            }
        }
    }
}

struct BlueZonePrincipleCard: View {
    let icon: String
    let principle: String
    let description: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.indigo)
                .frame(height: 30)
            
            Text(principle)
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Text(description)
                .font(.caption2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
        .padding()
        .frame(height: 100)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Cultural Habits Guide
struct CulturalHabitsGuideView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "globe.asia.australia.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("Kültürel Alışkanlıklar Rehberi")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Text("Dünyanın dört bir yanından sağlık destekleyici geleneksel alışkanlıklar:")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                CulturalHabitCard(
                    flag: "🇩🇰",
                    culture: "Danimarka - Hygge",
                    habit: "Sıcak, rahat anlarda vakit geçirme",
                    practice: "Mum ışığında kitap okuma, sıcak çay içme",
                    benefit: "Stres azaltır, mutluluk hormonu artırır",
                    howTo: "Günde 30 dk rahat aktivite"
                )
                
                CulturalHabitCard(
                    flag: "🇪🇸",
                    culture: "İspanya - Siesta",
                    habit: "Öğle sonrası kısa uyku",
                    practice: "13:00-15:00 arası 20-30 dk dinlenme",
                    benefit: "Kardiyovasküler sağlık, zihinsel performans",
                    howTo: "Power nap, sessiz ortam"
                )
                
                CulturalHabitCard(
                    flag: "🇮🇳",
                    culture: "Hindistan - Ayurveda",
                    habit: "Dinacharya (günlük rutin)",
                    practice: "Gün doğumunda uyanma, dosha'ya uygun beslenme",
                    benefit: "Enerji dengesi, sindirim düzenleme",
                    howTo: "Sabit uyku/yemek saatleri"
                )
                
                CulturalHabitCard(
                    flag: "🇰🇷",
                    culture: "Güney Kore - Nunchi",
                    habit: "Sosyal farkındalık ve empati",
                    practice: "Çevredeki insanların duygularını anlama",
                    benefit: "Sosyal bağ, stres azaltma",
                    howTo: "Aktif dinleme pratiği"
                )
                
                CulturalHabitCard(
                    flag: "🇧🇷",
                    culture: "Brezilya - Saudade",
                    habit: "Nostaljik minnettarlık",
                    practice: "Güzel anıları hatırlayarak şükretme",
                    benefit: "Pozitif ruh hali, yaşam memnuniyeti",
                    howTo: "Akşam anı paylaşımı"
                )
            }
        }
    }
}

struct CulturalHabitCard: View {
    let flag: String
    let culture: String
    let habit: String
    let practice: String
    let benefit: String
    let howTo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(flag)
                    .font(.title2)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(culture)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(habit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Text("Uygulama: \(practice)")
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(6)
            
            Text("Fayda: \(benefit)")
                .font(.caption)
                .foregroundColor(.green)
                .fontWeight(.medium)
            
            Text("Nasıl: \(howTo)")
                .font(.caption)
                .foregroundColor(.indigo)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Traditional Practices
struct TraditionalPracticesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Geleneksel Sağlık Uygulamaları")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Modern bilimin doğruladığı eski kültürel uygulamalar:")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 10) {
                TraditionalPracticeCard(
                    icon: "🧘‍♀️",
                    practice: "Çin - Tai Chi",
                    description: "Yavaş, akışkan hareketler",
                    modernEvidence: "Düşme riskini %45 azaltır, denge iyileştirir",
                    ageRange: "Tüm yaşlar"
                )
                
                TraditionalPracticeCard(
                    icon: "🌡️",
                    practice: "Finlandiya - Sauna",
                    description: "Yüksek sıcaklık terapisi",
                    modernEvidence: "Kalp hastalığı riskini %27 azaltır",
                    ageRange: "Yetişkinler"
                )
                
                TraditionalPracticeCard(
                    icon: "🍵",
                    practice: "İngiltere - Tea Time",
                    description: "Düzenli çay molası ritüeli",
                    modernEvidence: "L-theanine stresi azaltır, odaklanma artırır",
                    ageRange: "Tüm yaşlar"
                )
                
                TraditionalPracticeCard(
                    icon: "🚶‍♂️",
                    practice: "İtalya - Passeggiata",
                    description: "Akşam yavaş yürüyüşü",
                    modernEvidence: "Sindirim iyileştirir, sosyal bağ güçlendirir",
                    ageRange: "Tüm yaşlar"
                )
                
                TraditionalPracticeCard(
                    icon: "💤",
                    practice: "Türkiye - Kestirme",
                    description: "Öğle sonrası kısa uyku",
                    modernEvidence: "Hafıza konsolidasyonu, yaratıcılık artışı",
                    ageRange: "Yetişkinler"
                )
            }
        }
    }
}

struct TraditionalPracticeCard: View {
    let icon: String
    let practice: String
    let description: String
    let modernEvidence: String
    let ageRange: String
    
    var body: some View {
        HStack(spacing: 15) {
            Text(icon)
                .font(.title)
                .frame(width: 40, height: 40)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(practice)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Bilim: \(modernEvidence)")
                    .font(.caption)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
                
                Text("Uygun: \(ageRange)")
                    .font(.caption2)
                    .foregroundColor(.blue)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(10)
    }
}

// MARK: - Modern Applications
struct ModernApplicationsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "sparkles")
                    .foregroundColor(.purple)
                    .font(.title2)
                Text("Modern Hayata Uyarlama")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Text("Geleneksel alışkanlıkları modern yaşama entegre etmenin yolları:")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                ModernApplicationCard(
                    traditional: "Hara Hachi Bu (%80 doyma)",
                    modern: "Mindful Eating App",
                    application: "Yemek yerken telefonu kapatma, yavaş çiğneme",
                    timeNeeded: "Her öğün +5 dk"
                )
                
                ModernApplicationCard(
                    traditional: "Friluftsliv (doğa yaşamı)",
                    modern: "Urban Forest Bathing",
                    application: "Parkta telefonsuz 20 dk yürüyüş",
                    timeNeeded: "Günde 20 dk"
                )
                
                ModernApplicationCard(
                    traditional: "Hygge (rahat anlar)",
                    modern: "Digital Detox Evening",
                    application: "19:00 sonrası ekransız, kitap/müzik",
                    timeNeeded: "Akşam 2 saat"
                )
                
                ModernApplicationCard(
                    traditional: "Siesta (öğle uykusu)",
                    modern: "Power Nap Protocol",
                    application: "14:00-15:00 arası 20 dk uyku",
                    timeNeeded: "20 dakika"
                )
                
                ModernApplicationCard(
                    traditional: "Tea Time (çay molası)",
                    modern: "Mindfulness Break",
                    application: "İçecek içerken derin nefes, şükür pratiği",
                    timeNeeded: "Günde 3x5 dk"
                )
            }
        }
    }
}

struct ModernApplicationCard: View {
    let traditional: String
    let modern: String
    let application: String
    let timeNeeded: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Geleneksel:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(traditional)
                        .font(.caption)
                        .fontWeight(.medium)
                }
                
                Image(systemName: "arrow.right")
                    .foregroundColor(.gray)
                    .font(.caption)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Modern:")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Text(modern)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.purple)
                }
                
                Spacer()
            }
            
            Text(application)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.indigo.opacity(0.1))
                .cornerRadius(6)
            
            Text("⏱️ \(timeNeeded)")
                .font(.caption2)
                .foregroundColor(.orange)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Cultural Research
struct CulturalResearchView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "building.columns.circle.fill")
                    .foregroundColor(.indigo)
                    .font(.title2)
                Text("Kültürel Sağlık Araştırmaları")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 12) {
                CulturalResearchCard(
                    study: "Blue Zones Research - Dan Buettner & National Geographic",
                    finding: "Mavi bölgelerde yaşayanlar ortalama 10 yıl daha uzun, sağlıklı yaşıyor",
                    category: "Uzun Yaşam Antropolojisi",
                    impact: "Yaşam Tarzı Değişimi"
                )
                
                CulturalResearchCard(
                    study: "Harvard Study of Adult Development - 80 yıllık takip",
                    finding: "Güçlü sosyal ilişkiler mutluluğu paradan daha fazla etkiler",
                    category: "Sosyal Bağlar",
                    impact: "İlişki Kalitesi"
                )
                
                CulturalResearchCard(
                    study: "University of Copenhagen - Hygge ve Mutluluk İlişkisi",
                    finding: "Hygge pratikleri yaşam memnuniyetini %23 artırır",
                    category: "Kültürel Psikoloji",
                    impact: "Mental Refah"
                )
                
                CulturalResearchCard(
                    study: "Japanese Ikigai Research - Tohoku University",
                    finding: "Güçlü yaşam amacı (ikigai) ölüm riskini %30 azaltır",
                    category: "Varoluşsal Psikoloji",
                    impact: "Yaşam Amacı"
                )
                
                CulturalResearchCard(
                    study: "Mediterranean Diet Studies - Multiple Universities",
                    finding: "Geleneksel Akdeniz yaşam tarzı Alzheimer riskini %40 azaltır",
                    category: "Beslenme Antropolojisi",
                    impact: "Bilişsel Sağlık"
                )
            }
        }
    }
}

struct CulturalResearchCard: View {
    let study: String
    let finding: String
    let category: String
    let impact: String
    
    private var categoryColor: Color {
        switch category {
        case "Uzun Yaşam Antropolojisi": return .blue
        case "Sosyal Bağlar": return .pink
        case "Kültürel Psikoloji": return .purple
        case "Varoluşsal Psikoloji": return .orange
        case "Beslenme Antropolojisi": return .green
        default: return .gray
        }
    }
    
    private var impactIcon: String {
        switch impact {
        case "Yaşam Tarzı Değişimi": return "figure.walk.circle.fill"
        case "İlişki Kalitesi": return "heart.circle.fill"
        case "Mental Refah": return "brain.head.profile"
        case "Yaşam Amacı": return "target"
        case "Bilişsel Sağlık": return "brain.filled.head.profile"
        default: return "circle.fill"
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
                        .foregroundColor(categoryColor)
                        .font(.caption)
                    
                    Text(impact)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(categoryColor)
                }
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

// MARK: - Preview

#Preview{
    NavigationView {
        ScrollView {
            CultureSectionView()
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
