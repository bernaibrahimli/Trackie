import SwiftUI
import Charts

struct NutritionSectionView: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeaderStrip(
                icon: "leaf",
                title: "Nutritition",
                subtitle: "Microbiome, prebiotics, and anti-inflammatory foods",
                gradientColors: [
                    Color.green.opacity(0.9),
                    Color.green.opacity(0.8),
                    Color.green.opacity(0.6),
                    Color.green.opacity(0.4),
                    Color.green.opacity(0.2),
                    Color.clear
                ]
            )
            
            // MARK: - Intro
            Text("Prebiyotikler, fermente gıdalar ve lif dengesi gibi unsurlar sağlıklı bir sindirim sistemi için kritik rol oynar. Küçük beslenme tercihleri, uzun vadede büyük farklar yaratır.")
                .font(.body)
                .padding(.horizontal)
            
            // MARK: - Gut-Brain Connection
            VStack(alignment: .leading, spacing: 15) {
                Text("Bağırsak-Beyin Bağlantısı: İkinci Beyin")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Bağırsaklarımızda 500 milyon nöron bulunur - spinal korddan daha fazla! Bu 'enterik sinir sistemi' ruh halimizi, enerjimizi ve karar verme yetimizi doğrudan etkiler.")
                    .font(.body)
                
                Text("Bağırsaktaki bakteriler serotonin (%90) ve dopamin (%50) üretimi etkiler")
                    .font(.subheadline)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            
            // MARK: - Microbiome Basics
            VStack(alignment: .leading, spacing: 15) {
                Text("Mikrobiyom: İçimizdeki Ekosistem")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("100 trilyon bakteri vücudumuzda yaşar - hücrelerimizden 10 kat fazla! Bu mikroorganizmalar bağışıklık sistemini, metabolizmayı ve hatta kişiliği etkileyebilir.")
                    .font(.body)
                
                Text("Çeşitlilik anahtardır: 1000+ farklı bakteri türü optimal sağlık için gerekli")
                    .font(.subheadline)
                    .foregroundColor(.blue)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            VStack(alignment: .leading, spacing: 20) {
                // MARK: - Fermented Foods
                FermentedFoodsView()
                
                // MARK: - Nutrition Research
                NutritionResearchView()
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
            
            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Image(systemName: "sparkles")
                        .font(.title2)
                        .foregroundColor(.green)
                        .frame(width: 32, height: 32)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Bu Bilgileri Hemen Uygula!")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Text("Bağırsak sağlığı için hazırlanmış program")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
                
                // Program Preview Card
                HStack(spacing: 12) {
                    // Program Icon
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.green.opacity(0.3),
                                        Color.green.opacity(0.1)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "leaf.circle")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundColor(.green)
                    }
                    
                    // Program Info
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Gut Health Revival")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text("22 günde bağırsak sağlığını optimize edin")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                        
                        HStack(spacing: 8) {
                            HStack(spacing: 3) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 10))
                                Text("22 gün")
                                    .font(.system(size: 10, weight: .medium))
                            }
                            .foregroundColor(.green)
                            
                            HStack(spacing: 3) {
                                Image(systemName: "list.bullet")
                                    .font(.system(size: 10))
                                Text("6 habit")
                                    .font(.system(size: 10, weight: .medium))
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                    
                    Spacer()
                    
                    // CTA Button
                    VStack {
                        Button(action: {
                            print("will be navigating to the quick program detail page")
                        }) {
                            HStack(spacing: 6) {
                                Text("Başla")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                
                                Image(systemName: "arrow.right.circle.fill")
                                    .font(.caption)
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.green)
                            .cornerRadius(8)
                        }
                        
                        Spacer()
                    }
                }
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.green.opacity(0.05))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.green.opacity(0.2), lineWidth: 1)
                        )
                )
            }
            .padding(.horizontal)
            .padding(.top, 16)
            
            // MARK: - TRACKIE APPLICATION GUIDE (NEW)
            TrackoApplicationGuideView(
                sectionType: .nutrition,
                tips: [
                    "Günlük sebze/meyve sayısını takip ederek çeşitliliği artırın",
                    "Su tüketim alışkanlığı oluşturun - günde 8 bardak hedefleyin",
                    "Fermente gıda alışkanlığı ekleyin (yoğurt, kefir, turşu)",
                    "Fotoğraf özelliğini kullanarak öğünlerinizi kaydedin"
                ],
                examples: [
                    "🥗 'Günde 5 porsiyon sebze'",
                    "💧 'Sabah 2 bardak su içerim'",
                    "🥛 '1 kase yoğurt tüketirim'",
                    "🍎 'Atıştırmalık meyve yerim'"
                ]
            )
            BreathingGlowFooterView()
        }
    }
}

// MARK: - Fermented Foods View
struct FermentedFoodsView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "drop.circle.fill")
                    .foregroundColor(.orange)
                    .font(.title2)
                Text("Fermente Gıdaların Gücü")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 12) {
                FermentedFoodCard(
                    food: "🥛 Kefir",
                    bacteria: "50+ probiyotik suş",
                    benefit: "Bağışıklık sistemi güçlendirme",
                    howTo: "Günde 1 bardak, sabah aç karnına"
                )
                
                FermentedFoodCard(
                    food: "🥒 Turşu (Sirke olmayan)",
                    bacteria: "Lactobacillus",
                    benefit: "Sindirim enzim artışı",
                    howTo: "Öğünlerle birlikte küçük porsiyon"
                )
                
                FermentedFoodCard(
                    food: "🍲 Miso",
                    bacteria: "Aspergillus oryzae",
                    benefit: "Protein emilimi artırma",
                    howTo: "Çorba olarak haftada 2-3 kez"
                )
                
                FermentedFoodCard(
                    food: "🥬 Sauerkraut",
                    bacteria: "Çok çeşitli laktobasil",
                    benefit: "Vitamin C ve K2 üretimi",
                    howTo: "Salata yanında 2 yemek kaşığı"
                )
            }
        }
    }
}

struct FermentedFoodCard: View {
    let food: String
    let bacteria: String
    let benefit: String
    let howTo: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(food)
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Text("PROBİYOTİK")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.green)
                    .cornerRadius(4)
            }
            
            Text("Aktif bakteri: \(bacteria)")
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

// MARK: - Nutrition Research View
struct NutritionResearchView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "doc.text.magnifyingglass")
                    .foregroundColor(.green)
                    .font(.title2)
                Text("Beslenme Araştırmaları")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            VStack(spacing: 12) {
                NutritionResearchCard(
                    study: "Harvard T.H. Chan - Gut Microbiome Study",
                    finding: "Çeşitli beslenme mikrobiyom zenginliğini %73 artırır",
                    category: "Mikrobiyom",
                    impact: "Bağışıklık"
                )
                
                NutritionResearchCard(
                    study: "Stanford Medicine - Fiber Study",
                    finding: "Günde 25g lif tüketimi kalp hastalığı riskini %30 azaltır",
                    category: "Kardiyovasküler",
                    impact: "Koruma"
                )
                
                NutritionResearchCard(
                    study: "UCLA - Fermented Foods Research",
                    finding: "12 haftalık fermente gıda tüketimi stres seviyesini %40 düşürür",
                    category: "Mental Sağlık",
                    impact: "Ruh Hali"
                )
                
                NutritionResearchCard(
                    study: "Journal of Nutrition - Omega-3 Study",
                    finding: "Haftada 2 porsiyon yağlı balık beyin fonksiyonlarını %25 iyileştirir",
                    category: "Nöroloji",
                    impact: "Kognitif"
                )
            }
        }
    }
}

struct NutritionResearchCard: View {
    let study: String
    let finding: String
    let category: String
    let impact: String
    
    private var categoryColor: Color {
        switch category {
        case "Mikrobiyom": return .purple
        case "Kardiyovasküler": return .red
        case "Mental Sağlık": return .blue
        case "Nöroloji": return .orange
        default: return .gray
        }
    }
    
    private var impactIcon: String {
        switch impact {
        case "Bağışıklık": return "shield.fill"
        case "Koruma": return "heart.circle.fill"
        case "Ruh Hali": return "brain.head.profile"
        case "Kognitif": return "lightbulb.fill"
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
            NutritionSectionView()
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
