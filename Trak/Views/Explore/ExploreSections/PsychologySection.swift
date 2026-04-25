import SwiftUI
import Charts

struct PsychologySectionView: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeaderStrip(
                icon: "lightbulb.min",
                title: "Psychology",
                subtitle: "The science behind building micro habits and behavior change",
                gradientColors: [
                    Color.brown.opacity(0.9),
                    Color.brown.opacity(0.8),
                    Color.brown.opacity(0.6),
                    Color.brown.opacity(0.4),
                    Color.brown.opacity(0.2),
                    Color.clear
                ]
            )
        
            // MARK: - Section Title
            Text("Alışkanlıkların Psikolojisi & Mikro Alışkanlıkların Gücü")
                .font(.title2)
                .bold()
                .padding(.horizontal)
            
            // MARK: - Intro
            Text("Beynimiz alışkanlıkları küçük ödüller ve tekrarlarla inşa eder. Mikro alışkanlıklarla başlamak, büyük hedeflere ulaşmanın en güvenilir yoludur.")
                .font(.body)
                .padding(.horizontal)
            
            // MARK: - Habit Loop Explanation
            VStack(alignment: .leading, spacing: 15) {
                Text("Alışkanlık Döngüsü: Tetik → Rutin → Ödül")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Her alışkanlık üç temel bileşenden oluşur: Tetikleyici (cue), yapılan davranış (routine) ve alınan ödül (reward). Bu döngüyü anlayarak yeni alışkanlıklar tasarlayabilir veya kötü alışkanlıkları değiştirebilirsin.")
                    .font(.body)
                
                Text("Örnek: Telefonunu görmen (tetik) → sosyal medya kontrolü (rutin) → dopamin salınımı (ödül)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .italic()
            }
            .padding(.horizontal)
            
            // MARK: - Micro Habits Power
            VStack(alignment: .leading, spacing: 15) {
                Text("2 Dakika Kuralı ve Mikro Alışkanlıklar")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Yeni bir alışkanlık 2 dakikadan az sürmeli. 'Her gün 50 sayfa kitap okuyacağım' yerine 'her gün 1 sayfa okuyacağım' daha etkili. Mikro başarılar büyük değişimlerin temelini oluşturur.")
                    .font(.body)
                
                Text("Stanford Üniversitesi araştırması: Mikro alışkanlıklar %90 başarı oranına sahip")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 20) {
               
                CommonMistakesView()
                
                
                PsychologyResearchView()
            }
            .padding(.horizontal)
            .transition(.opacity.combined(with: .move(edge: .top)))
            TrackoApplicationGuideView(
                sectionType: .psychology,
                tips: [
                    "2 dakika kuralı ile başlayın - sadece 2 dakikalık alışkanlıklar ekleyin",
                    "Tetik-rutin-ödül döngüsünü kurarken tetikleyicilerinizi belirleyin",
                    "İlk hafta sadece 1 alışkanlık ekleyin ve tutarlılığa odaklanın",
                    "Fotoğraf doğrulama özelliğini kullanarak ödül sistemini güçlendirin"
                ],
                examples: [
                    "🏃‍♂️ 'Spor kıyafetlerimi giyerim' (2 dk)",
                    "📚 '1 sayfa kitap okurum' (2 dk)",
                    "🧘‍♀️ '3 derin nefes alırım' (1 dk)"
                ]
            )
            BreathingGlowFooterView()
        }
        
    }
}

// MARK: - Trackie Application Guide Component
struct TrackoApplicationGuideView: View {
    enum SectionType {
        case psychology, nutrition, chronobiology
        
        var title: String {
            switch self {
            case .psychology:
                return "Trackie ile Mikro Alışkanlık Uygulaması"
            case .nutrition:
                return "Trackie ile Beslenme Takibi"
            case .chronobiology:
                return "Trackie ile Ritim Düzenleme"
            }
        }
        
        var icon: String {
            switch self {
            case .psychology:
                return "brain.head.profile"
            case .nutrition:
                return "leaf.circle"
            case .chronobiology:
                return "clock.circle"
            }
        }
        
        var color: Color {
            switch self {
            case .psychology:
                return .purple
            case .nutrition:
                return .green
            case .chronobiology:
                return .blue
            }
        }
    }
    
    let sectionType: SectionType
    let tips: [String]
    let examples: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header
            HStack(spacing: 12) {
                Image(systemName: sectionType.icon)
                    .font(.title2)
                    .foregroundColor(sectionType.color)
                    .frame(width: 32, height: 32)
                    .background(sectionType.color.opacity(0.1))
                    .cornerRadius(8)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(sectionType.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("Bu bilgileri pratikte nasıl uygulayacaksın?")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            // Tips Section
            VStack(alignment: .leading, spacing: 8) {
                Text("💡 Uygulama İpuçları:")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(sectionType.color)
                
                ForEach(Array(tips.enumerated()), id: \.offset) { index, tip in
                    HStack(alignment: .top, spacing: 8) {
                        Text("•")
                            .foregroundColor(sectionType.color)
                            .fontWeight(.bold)
                        
                        Text(tip)
                            .font(.caption)
                            .fixedSize(horizontal: false, vertical: true)
                        
                        Spacer()
                    }
                }
            }
            
            // Examples Section
            if !examples.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("🎯 Başlangıç Örnekleri:")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(sectionType.color)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 8) {
                        ForEach(examples, id: \.self) { example in
                            Text(example)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(sectionType.color.opacity(0.1))
                                .cornerRadius(6)
                        }
                    }
                }
            }
            
            // Call to Action
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hemen başlamaya hazır mısın?")
                        .font(.caption)
                        .fontWeight(.medium)
                    
                    Text("Dashboard'unda yeni alışkanlık oluştur")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.title3)
                    .foregroundColor(sectionType.color)
            }
            .padding(.top, 4)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(sectionType.color.opacity(0.3), lineWidth: 1)
                )
        )
        .padding(.horizontal)
        .padding(.top, 8)
    }
}

// MARK: - Common Mistakes View (existing)
struct CommonMistakesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("Yaygın Hatalar ve Çözümleri")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 10) {
                MistakeCard(
                    mistake: "Çok büyük başlamak",
                    solution: "Her gün 1 sayfa okumakla başla, 1 saat değil"
                )
                
                MistakeCard(
                    mistake: "Mükemmeliyetçilik",
                    solution: "%80 tutarlılık %100'den daha değerli"
                )
                
                MistakeCard(
                    mistake: "Çok fazla alışkanlık birden",
                    solution: "Aynı anda maksimum 2-3 alışkanlık"
                )
                
                MistakeCard(
                    mistake: "Tetikleyici belirlememe",
                    solution: "Her alışkanlık için net tetik noktası seç"
                )
            }
        }
    }
}

struct MistakeCard: View {
    let mistake: String
    let solution: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("❌ \(mistake)")
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text("✅ \(solution)")
                    .font(.caption)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Psychology Research View (existing)
struct PsychologyResearchView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "book.circle.fill")
                    .foregroundColor(.purple)
                    .font(.title2)
                Text("Psikoloji Araştırmaları")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 12) {
                PsychologyResearchCard(
                    study: "Dr. BJ Fogg - Stanford Üniversitesi",
                    finding: "Mikro alışkanlıklar büyük alışkanlıklardan 3 kat daha başarılı",
                    category: "Davranış Psikolojisi",
                    percentage: 90
                )
                
                PsychologyResearchCard(
                    study: "Dr. Phillippa Lally - King's College London",
                    finding: "Alışkanlık oluşumu ortalama 66 gün sürüyor (18-254 gün arasında)",
                    category: "Nöroplastisite",
                    percentage: 66
                )
                
                PsychologyResearchCard(
                    study: "Dr. Charles Duhigg - MIT Araştırması",
                    finding: "Alışkanlık döngüsü (tetik-rutin-ödül) beynin bazal ganglionlarında kodlanır",
                    category: "Nörobilim",
                    percentage: 45
                )
                
                PsychologyResearchCard(
                    study: "Dr. James Clear - Atomik Alışkanlıklar",
                    finding: "%1'lik günlük gelişim yılda %37 büyüme sağlar",
                    category: "Davranış Değişimi",
                    percentage: 37
                )
            }
        }
    }
}

struct PsychologyResearchCard: View {
    let study: String
    let finding: String
    let category: String
    let percentage: Int
    
    private var categoryColor: Color {
        switch category {
        case "Davranış Psikolojisi": return .purple
        case "Nöroplastisite": return .blue
        case "Nörobilim": return .orange
        case "Davranış Değişimi": return .green
        default: return .gray
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
                
                Text("%\(percentage)")
                    .font(.headline)
                    .fontWeight(.bold)
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
            PsychologySectionView()
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
