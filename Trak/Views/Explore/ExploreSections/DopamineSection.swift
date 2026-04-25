//
//  DopamineSection.swift
//  Trak
//
//  Created by Ege Özçelik on 20.09.2025.
//

import SwiftUI
import Charts

struct DopamineSectionView: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeaderStrip(
                icon: "bolt.circle",
                title: "Dopamine",
                subtitle: "Reward Systems",
                gradientColors: [
                    Color.yellow.opacity(0.9),
                    Color.yellow.opacity(0.8),
                    Color.yellow.opacity(0.6),
                    Color.yellow.opacity(0.4),
                    Color.yellow.opacity(0.2),
                    Color.clear
                    
                ]
            )
            
            // MARK: - Intro
            Text("Beynin ödül mekanizması küçük başarılarla aktive olur. Alışkanlıklarını sürdürmek için küçük ödüller kurgulamak, motivasyonunu uzun vadede korumana yardımcı olur.")
                .font(.body)
                .padding(.horizontal)
            
            // MARK: - Dopamine System Intro
            VStack(alignment: .leading, spacing: 15) {
                Text("🧠 Dopamin: Motivasyonun Kimyası")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Dopamin 'mutluluk hormonu' değil, 'isteme hormonu'dur. Ödülü almaktan çok, ödülü beklemek dopamin salgılar. Bu mekanizmayı anlamak alışkanlık tasarımının anahtarıdır.")
                    .font(.body)
                
                Text("Araştırma: Küçük ödüller büyük ödüllerden %40 daha etkili motivasyon yaratır")
                    .font(.subheadline)
                    .foregroundColor(.pink)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            
            // MARK: - Reward Prediction Error
            VStack(alignment: .leading, spacing: 15) {
                Text("🎯 Ödül Tahmin Hatası (Reward Prediction Error)")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Beyin beklediğinden fazla ödül aldığında dopamin zirve yapar. Sürpriz element ödülü güçlendirir. Öngörülebilir ödüller zamanla etkisini kaybeder.")
                    .font(.body)
                
                Text("Taktik: Değişken oranlı ödüllendirme en bağımlılık yapan sistemdir")
                    .font(.subheadline)
                    .foregroundColor(.purple)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Dopamine Release Chart
                DopamineReleaseChartView()
                    .padding(.horizontal)
                
                // MARK: - Reward Systems
                RewardSystemsView()
                    .padding(.horizontal)
                
                // MARK: - Dopamine Detox
                DopamineDetoxView()
                    .padding()
                
                // MARK: - Healthy Rewards
                HealthyRewardsView()
                    .padding(.horizontal)
                
                // MARK: - Habit Stacking with Rewards
                HabitStackingRewardsView()
                    .padding()
                
                // MARK: - Dopamine Research
                DopamineResearchView()
                    .padding()
                   
            }
            BreathingGlowFooterView()
            
        }
    }
}

// MARK: - Dopamine Release Chart
struct DopamineReleaseChartView: View {
    let dopamineData = [
        DopamineActivity(activity: "Yemek", baseline: 150, peak: 150, duration: 30, type: "Doğal"),
        DopamineActivity(activity: "Seks", baseline: 200, peak: 200, duration: 60, type: "Doğal"),
        DopamineActivity(activity: "Egzersiz", baseline: 130, peak: 130, duration: 120, type: "Sağlıklı"),
        DopamineActivity(activity: "Müzik", baseline: 110, peak: 110, duration: 45, type: "Sağlıklı"),
        DopamineActivity(activity: "Sosyal Medya", baseline: 75, peak: 75, duration: 15, type: "Dijital"),
        DopamineActivity(activity: "Oyun", baseline: 80, peak: 80, duration: 180, type: "Dijital"),
        DopamineActivity(activity: "Kokain", baseline: 350, peak: 350, duration: 45, type: "Zararlı"),
        DopamineActivity(activity: "Alkol", baseline: 120, peak: 120, duration: 90, type: "Zararlı")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Dopamin Salınım Seviyeleri")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Farklı aktivitelerin dopamin üzerindeki etkisi (baseline = %100):")
                .font(.body)
                .foregroundColor(.secondary)
            
            Chart(dopamineData.filter { $0.type != "Zararlı" }) { activity in
                BarMark(
                    x: .value("Aktivite", activity.activity),
                    y: .value("Dopamin %", activity.baseline)
                )
                .foregroundStyle(activity.type == "Doğal" ? .green : .orange)
                                
                .cornerRadius(4)
            }
            .chartYAxisLabel("Dopamin Artışı (%)")
            //.chartYScale(domain: 100...250)
            .frame(height: 200)
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Circle()
                        .fill(.green)
                        .frame(width: 8, height: 8)
                    Text("Doğal Ödüller")
                        .font(.caption)
                    
                    Circle()
                        .fill(.blue)
                        .frame(width: 8, height: 8)
                    Text("Sağlıklı Aktiviteler")
                        .font(.caption)
                    
                    Circle()
                        .fill(.red)
                        .frame(width: 8, height: 8)
                    Text("Dijital Uyarılar")
                        .font(.caption)
                }
                
                Text("⚠️ Dikkat: Yapay uyarılar (sosyal medya, oyun) doğal ödülleri köreltir")
                    .font(.caption)
                    .foregroundColor(.orange)
                    .fontWeight(.medium)
            }
        }
    }
}

struct DopamineActivity: Identifiable {
    let id = UUID()
    let activity: String
    let baseline: Int
    let peak: Int
    let duration: Int
    let type: String
}

// MARK: - Reward Systems
struct RewardSystemsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Etkili Ödül Sistemleri Tasarımı")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Alışkanlıklarını güçlendirecek ödül mekanizmalarını nasıl kuracaksın:")
                .font(.body)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                RewardSystemCard(
                    icon: "clock.fill",
                    system: "Anında Ödül",
                    description: "Alışkanlığı yaptıktan hemen sonra",
                    example: "Egzersizden sonra favori çayını iç",
                    effectiveness: "Yüksek",
                    color: .green
                )
                
                RewardSystemCard(
                    icon: "calendar.badge.plus",
                    system: "Haftalık Ödül",
                    description: "7 gün üst üste başarıda",
                    example: "Hafta sonu sinema/masaj",
                    effectiveness: "Orta",
                    color: .blue
                )
                
                RewardSystemCard(
                    icon: "gift.fill",
                    system: "Sürpriz Ödül",
                    description: "Rastgele zamanlarda ver",
                    example: "Zar at, 6 gelirse ödül",
                    effectiveness: "Çok Yüksek",
                    color: .purple
                )
                
                RewardSystemCard(
                    icon: "chart.line.uptrend.xyaxis",
                    system: "Gelişim Ödülü",
                    description: "Milestone'lara dayalı",
                    example: "30 gün sonra yeni kitap",
                    effectiveness: "Orta",
                    color: .orange
                )
                
                RewardSystemCard(
                    icon: "person.2.fill",
                    system: "Sosyal Ödül",
                    description: "Başarını paylaş, övgü al",
                    example: "Instagram story, arkadaş tebriği",
                    effectiveness: "Yüksek",
                    color: .pink
                )
                
                RewardSystemCard(
                    icon: "star.fill",
                    system: "İçsel Ödül",
                    description: "Kendi kendini övmek",
                    example: "'Bugün harika biriyim' de",
                    effectiveness: "Sürdürülebilir",
                    color: .yellow
                )
            }
        }
    }
}

struct RewardSystemCard: View {
    let icon: String
    let system: String
    let description: String
    let example: String
    let effectiveness: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
                
                Spacer()
                
                Text(effectiveness)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(color)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(color.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text(system)
                .font(.subheadline)
                .fontWeight(.semibold)
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            Text("Örnek: \(example)")
                .font(.caption2)
                .foregroundColor(color)
                .fontWeight(.medium)
                .lineLimit(2)
        }
        .padding()
        .frame(height: 130)
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Dopamine Detox
struct DopamineDetoxView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "brain.head.profile")
                    .foregroundColor(.red)
                    .font(.title2)
                Text("Dopamin Detoksu")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Text("Dopamin reseptörlerini sıfırlamak için yapay uyarılardan uzak durmak:")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                DetoxLevelCard(
                    level: "Level 1: Mikro Detoks",
                    duration: "1-2 saat",
                    restrictions: ["Telefon", "Sosyal medya", "Müzik"],
                    activities: ["Sessizce otur", "Nefes al", "Düşün"],
                    benefit: "Anında rahatlama",
                    difficulty: "Kolay"
                )
                
                DetoxLevelCard(
                    level: "Level 2: Günlük Detoks",
                    duration: "1 gün",
                    restrictions: ["Tüm ekranlar", "Müzik", "Şeker", "Kafeyn"],
                    activities: ["Doğa yürüyüşü", "Kitap", "Meditasyon"],
                    benefit: "Zihinsel berraklık",
                    difficulty: "Orta"
                )
                
                DetoxLevelCard(
                    level: "Level 3: Haftalık Detoks",
                    duration: "7 gün",
                    restrictions: ["Sosyal medya", "YouTube", "Netflix", "Oyunlar"],
                    activities: ["Hobiler", "Spor", "Sosyal aktivite"],
                    benefit: "Dopamin sıfırlama",
                    difficulty: "Zor"
                )
                
                DetoxLevelCard(
                    level: "Level 4: Tam Detoks",
                    duration: "30 gün",
                    restrictions: ["Tüm eğlence teknolojisi", "Hızlı yemek", "Alışveriş"],
                    activities: ["Yaratıcılık", "İnsan ilişkileri", "Kitap"],
                    benefit: "Hayat perspektifi",
                    difficulty: "Ekstrem"
                )
            }
        }
    }
}

struct DetoxLevelCard: View {
    let level: String
    let duration: String
    let restrictions: [String]
    let activities: [String]
    let benefit: String
    let difficulty: String
    
    private var difficultyColor: Color {
        switch difficulty {
        case "Kolay": return .green
        case "Orta": return .orange
        case "Zor": return .red
        case "Ekstrem": return .purple
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(level)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text(difficulty)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(difficultyColor)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(difficultyColor.opacity(0.1))
                    .cornerRadius(4)
            }
            
            Text("⏱️ Süre: \(duration)")
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("🚫 Yasak: \(restrictions.joined(separator: ", "))")
                .font(.caption)
                .foregroundColor(.red)
                .lineLimit(2)
            
            Text("✅ Yapılacak: \(activities.joined(separator: ", "))")
                .font(.caption)
                .foregroundColor(.green)
                .lineLimit(2)
            
            Text("🎯 Fayda: \(benefit)")
                .font(.caption)
                .foregroundColor(.blue)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Healthy Rewards
struct HealthyRewardsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Sağlıklı Ödül Alternatifleri")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Dopamin salgılayan ama uzun vadede zarar vermeyen ödüller:")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 10) {
                HealthyRewardCard(
                    category: "Duyusal Ödüller",
                    rewards: ["Güzel kokulu mum yak", "Rahat kıyafet giy", "Sıcak banyo yap", "Doğa seslerini dinle"],
                    icon: "hand.draw.fill",
                    color: .blue
                )
                
                HealthyRewardCard(
                    category: "Sosyal Ödüller",
                    rewards: ["Arkadaşını ara", "Aile ile vakit geçir", "Yeni insan tanı", "Sevdiklerine mesaj at"],
                    icon: "person.2.fill",
                    color: .pink
                )
                
                HealthyRewardCard(
                    category: "Yaratıcı Ödüller",
                    rewards: ["Resim çiz", "Müzik yap", "Yazı yaz", "El sanatları"],
                    icon: "paintbrush.fill",
                    color: .purple
                )
                
                HealthyRewardCard(
                    category: "Aktivite Ödülleri",
                    rewards: ["Yeni yer keşfet", "Farklı yemek dene", "Hobi edin", "Öğren"],
                    icon: "figure.walk",
                    color: .green
                )
                
                HealthyRewardCard(
                    category: "Dinlenme Ödülleri",
                    rewards: ["Kaliteli uyku", "Masaj", "Meditasyon", "Hiçbir şey yapmama"],
                    icon: "bed.double.fill",
                    color: .indigo
                )
            }
        }
    }
}

struct HealthyRewardCard: View {
    let category: String
    let rewards: [String]
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.title2)
                .frame(width: 40, height: 40)
                .background(color.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(category)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(rewards.joined(separator: " • "))
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.tertiarySystemGroupedBackground))
        .cornerRadius(10)
    }
}

// MARK: - Habit Stacking with Rewards
struct HabitStackingRewardsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "link.circle.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("Alışkanlık + Ödül Birleştirme")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Text("Alışkanlığın hemen ardından doğal ödül gelecek şekilde tasarımla:")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                HabitRewardStackCard(
                    habit: "Sabah egzersizi",
                    reward: "Favori kahve/çay",
                    explanation: "Endorfin + kafein kombinasyonu",
                    time: "Hemen sonra"
                )
                
                HabitRewardStackCard(
                    habit: "Günlük okuma",
                    reward: "Rahat koltuğa uzanma",
                    explanation: "Bilişsel çaba + fiziksel rahatlık",
                    time: "Okurken"
                )
                
                HabitRewardStackCard(
                    habit: "Meditasyon",
                    reward: "Güzel müzik dinleme",
                    explanation: "Zihinsel sessizlik + işitsel zevk",
                    time: "Hemen sonra"
                )
                
                HabitRewardStackCard(
                    habit: "Sağlıklı yemek",
                    reward: "Güzel sunum/tabak",
                    explanation: "Beslenme + görsel estetik",
                    time: "Yerken"
                )
                
                HabitRewardStackCard(
                    habit: "Çalışma/ödev",
                    reward: "15 dk doğa manzarası",
                    explanation: "Mental çaba + doğal rahatlama",
                    time: "25 dk sonra"
                )
            }
        }
    }
}

struct HabitRewardStackCard: View {
    let habit: String
    let reward: String
    let explanation: String
    let time: String
    
    var body: some View {
        HStack(spacing: 15) {
            VStack(spacing: 4) {
                Text(habit)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(6)
                
                Image(systemName: "plus")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(reward)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 8)
                    .background(Color.pink.opacity(0.1))
                    .cornerRadius(6)
            }
            .frame(width: 80)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(explanation)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("⏱️ \(time)")
                    .font(.caption2)
                    .foregroundColor(.orange)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Dopamine Research
struct DopamineResearchView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "brain.head.profile.fill")
                    .foregroundColor(.pink)
                    .font(.title2)
                Text("Dopamin Araştırmaları")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 12) {
                DopamineResearchCard(
                    study: "Stanford Neuroscience - Dr. Anna Lembke Research",
                    finding: "Dopamin detoksu 2 hafta sonra doğal ödül hassasiyetini %60 artırır",
                    category: "Nöroplastisite",
                    impact: "Tedavi Yaklaşımı"
                )
                
                DopamineResearchCard(
                    study: "MIT Reward Learning Lab - Variable Ratio Schedule",
                    finding: "Rastgele ödüller sabit ödüllerden 3 kat daha güçlü bağımlılık yaratır",
                    category: "Öğrenme Psikolojisi",
                    impact: "Alışkanlık Tasarımı"
                )
                
                DopamineResearchCard(
                    study: "UC Berkeley - Digital Addiction & Dopamine Study",
                    finding: "Sosyal medya kullanımı doğal dopamin üretimini %23 azaltır",
                    category: "Dijital Wellness",
                    impact: "Teknoloji Kullanımı"
                )
                
                DopamineResearchCard(
                    study: "Harvard Medical School - Exercise & Reward System",
                    finding: "Düzenli egzersiz dopamin D2 reseptörlerini %45 artırır",
                    category: "Egzersiz Nörobilimi",
                    impact: "Doğal Ödül Sistemi"
                )
                
                DopamineResearchCard(
                    study: "Journal of Neuroscience - Anticipation vs Consumption",
                    finding: "Dopamin ödülü almaktan çok beklemek sırasında %80 daha fazla salınır",
                    category: "Beklenti Psikolojisi",
                    impact: "Motivasyon Stratejisi"
                )
            }
        }
    }
}

struct DopamineResearchCard: View {
    let study: String
    let finding: String
    let category: String
    let impact: String
    
    private var categoryColor: Color {
        switch category {
        case "Nöroplastisite": return .purple
        case "Öğrenme Psikolojisi": return .blue
        case "Dijital Wellness": return .red
        case "Egzersiz Nörobilimi": return .green
        case "Beklenti Psikolojisi": return .orange
        default: return .gray
        }
    }
    
    private var impactIcon: String {
        switch impact {
        case "Tedavi Yaklaşımı": return "cross.circle.fill"
        case "Alışkanlık Tasarımı": return "gearshape.circle.fill"
        case "Teknoloji Kullanımı": return "iphone.circle.fill"
        case "Doğal Ödül Sistemi": return "heart.circle.fill"
        case "Motivasyon Stratejisi": return "target"
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


#Preview{
    NavigationView {
        ScrollView {
            DopamineSectionView()
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
