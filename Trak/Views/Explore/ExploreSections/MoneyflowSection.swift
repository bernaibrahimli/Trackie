import SwiftUI
import Charts

struct MoneyflowSectionView: View {
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeaderStrip(
                icon: "chart.pie.fill",
                title: "Money Management",
                subtitle: "Financial psychology and mindful spending",
                gradientColors: [
                    Color.mint.opacity(0.9),
                    Color.mint.opacity(0.8),
                    Color.mint.opacity(0.6),
                    Color.mint.opacity(0.4),
                    Color.mint.opacity(0.2),
                    Color.clear
                ]
            )
            
            // MARK: - Intro
            Text("Para yönetimi yalnızca matematiksel hesaplamalardan ibaret değildir; psikolojik etkenler de önemli rol oynar. Harcama kararlarımız bazen bilinçdışı kalıplar ve duygusal durumlarımızdan etkilenebilir.")
                .font(.body)
                .padding(.horizontal)
            
            // MARK: - Mental Accounting
            VStack(alignment: .leading, spacing: 15) {
                Text("🧠 Paranın Psikolojisi")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Richard Thaler'in 'mental accounting' teorisi: İnsanlar parayı kaynağına göre farklı kategorilere böler. 'Hediye olarak aldığım para' ile 'çalışarak kazandığım para'yı farklı harcama eğiliminde kullanırız. Bu durum rasyonel görünmese de birçok kültürde gözlemlenmiştir.")
                    .font(.body)
                
                Text("Çalışma: İnsanlar maaştan $20'ı harcamakta tereddüt ederken, ikramiye $20'sını kolayca harcar")
                    .font(.subheadline)
                    .foregroundColor(.mint)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            
            // MARK: - Present Bias
            VStack(alignment: .leading, spacing: 15) {
                Text("⏰ Şimdi Önyargısı (Present Bias)")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text("Beyin, uzak gelecekteki büyük kazançtan çok, şimdiki küçük zevki tercih eder. Bu yüzden emeklilik için tasarruf zordur ama bugün kahve almak kolaydır. Bu eğilimin, kısa vadeli ödüllere öncelik veren evrimsel bir eğilimle ilişkili olabileceği düşünülüyor.")
                    .font(.body)
                
                Text("Davranışsal ekonomi: Gelecek için plan yapmak prefrontal korteks gerektirir - yorucu bir süreç")
                    .font(.subheadline)
                    .foregroundColor(.pink)
                    .fontWeight(.medium)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 20) {
                
                // MARK: - Spending Psychology Chart
                SpendingPsychologyChartView()
                    .padding(.horizontal)
                
                // MARK: - Cognitive Biases in Money
                CognitiveBiasesMoneyView()
                    .padding(.horizontal)
                
                // MARK: - Money Mindfulness
                MoneyMindfulnessView()
                    .padding()
                
                // MARK: - Budget System (Core Feature)
                MonthlyBudgetSystemView()
                    .padding(.horizontal)
                
                // MARK: - Income vs Expense Visualization
                IncomeExpenseVisualizationView()
                    .padding(.horizontal)
                
                // MARK: - MONEYFLOW APP PROMOTION (Special Section)
                MoneyflowAppPromotionView()
                    .padding(.horizontal)
                
                // MARK: - Behavioral Economics Research
               
            }
            
            // MARK: - TRACKIE APPLICATION GUIDE
            
            
            BreathingGlowFooterView()
        }
    }
}

// MARK: - Spending Psychology Chart
struct SpendingPsychologyChartView: View {
    let spendingTriggers = [
        SpendingTrigger(trigger: "Duygusal", percentage: 42),
        SpendingTrigger(trigger: "Sosyal", percentage: 28),
        SpendingTrigger(trigger: "İmpulsif", percentage: 18),
        SpendingTrigger(trigger: "Planlı", percentage: 12)
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Harcama Tetikleyicileri")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("İnsanların neden harcama yaptığına dair psikolojik faktörler:")
                .font(.body)
                .foregroundColor(.secondary)
            
            Chart(spendingTriggers) { item in
                BarMark(
                    x: .value("Yüzde", item.percentage),
                    y: .value("Tetikleyici", item.trigger)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [.mint, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(4)
            }
            .chartXAxisLabel("Harcama Oranı (%)")
            .frame(height: 180)
            
            Text("💡 Duygusal harcamalar genellikle kısa vadeli tatmin sağlar ama uzun vadede pişmanlık yaratabilir.")
                .font(.caption)
                .foregroundColor(.orange)
                .fontWeight(.medium)
        }
    }
}

struct SpendingTrigger: Identifiable {
    let id = UUID()
    let trigger: String
    let percentage: Int
}

// MARK: - Cognitive Biases in Money
struct CognitiveBiasesMoneyView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Para Yönetiminde Bilişsel Önyargılar")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Beynimizin bizi yönlendirdiği finansal kararlar:")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                CognitiveBiasCard(
                    icon: "arrow.down.circle.fill",
                    iconColor: .red,
                    bias: "Sunk Cost Fallacy (Batık Maliyet)",
                    description: "Zaten harcanan paradan vazgeçememe",
                    example: "Kullanmadığı spor salonu üyeliğini iptal etmemek",
                    solution: "Geçmiş harcamalar geri gelmez, gelecek odaklı düşünün"
                )
                
                CognitiveBiasCard(
                    icon: "cart.fill",
                    iconColor: .orange,
                    bias: "Anchoring (Çıpa Etkisi)",
                    description: "İlk gördüğünüz fiyat referans olur",
                    example: "₺1000'den ₺600'e düşen ürünü ucuz sanmak",
                    solution: "Gerçek değeri ve ihtiyacınızı sorgulayın"
                )
                
                CognitiveBiasCard(
                    icon: "clock.arrow.circlepath",
                    iconColor: .blue,
                    bias: "Hyperbolic Discounting",
                    description: "Yakın gelecek uzak gelecekten değerlidir",
                    example: "Emeklilik için biriktirmek yerine tatil yapmak",
                    solution: "Gelecekteki benliğinizi somutlaştırın"
                )
                
                CognitiveBiasCard(
                    icon: "person.2.fill",
                    iconColor: .pink,
                    bias: "Sosyal Karşılaştırma",
                    description: "Çevrenizin harcama seviyesine adapte olma",
                    example: "Arkadaşlar pahalı restorana gidince siz de gitmek",
                    solution: "Kendi değerlerinize göre harcayın"
                )
            }
        }
    }
}

struct CognitiveBiasCard: View {
    let icon: String
    let iconColor: Color
    let bias: String
    let description: String
    let example: String
    let solution: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(iconColor)
                .frame(width: 40, height: 40)
                .background(iconColor.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(bias)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Örnek: \(example)")
                    .font(.caption)
                    .foregroundColor(iconColor)
                    .italic()
                
                Text("✓ Çözüm: \(solution)")
                    .font(.caption)
                    .foregroundColor(.green)
                    .fontWeight(.medium)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Money Mindfulness
struct MoneyMindfulnessView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "heart.circle.fill")
                    .foregroundColor(.mint)
                    .font(.title2)
                Text("Bilinçli Para Yönetimi")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Text("Para ile sağlıklı ilişki kurmanın yolları:")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                MindfulnessStrategyCard(
                    strategy: "24 Saat Kuralı",
                    description: "Plansız alışverişlerde 24 saat bekleyin",
                    benefit: "İmpulsif harcamaları azaltmada yardımcı olabilir",
                    difficulty: "Kolay"
                )
                
                MindfulnessStrategyCard(
                    strategy: "Değer Bazlı Harcama",
                    description: "Harcama yapmadan önce 'Bu değerlerime uygun mu?' sorun",
                    benefit: "Gereksiz harcamayı minimuma indirir",
                    difficulty: "Orta"
                )
                
                MindfulnessStrategyCard(
                    strategy: "Zaman-Para Denkliği",
                    description: "Fiyatları 'kaç saat çalışma' olarak düşünün",
                    benefit: "Harcama perspektifini değişir",
                    difficulty: "Orta"
                )
                
                MindfulnessStrategyCard(
                    strategy: "Otomatik Tasarruf",
                    description: "Maaş gelir gelmez %10-20'sini otomatik ayırın",
                    benefit: "Biriktirme disiplinini otomatikleştirir",
                    difficulty: "Kolay"
                )
            }
        }
    }
}

struct MindfulnessStrategyCard: View {
    let strategy: String
    let description: String
    let benefit: String
    let difficulty: String
    
    private var difficultyColor: Color {
        switch difficulty {
        case "Kolay": return .green
        case "Orta": return .orange
        case "Zor": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(strategy)
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
            
            Text(description)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text("📈 \(benefit)")
                .font(.caption)
                .foregroundColor(.mint)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Monthly Budget System (Core Feature)
struct MonthlyBudgetSystemView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Image(systemName: "calendar.circle.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                Text("Aylık Bütçe Sistemi: Temelden Kurulum")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
            
            Text("Finansal kontrolü sağlamak için etkili bir yöntem: Ayın başında gelir-gider dengesini hesaplamak ve günlük limitler belirlemek.")
                .font(.body)
                .foregroundColor(.secondary)
            
            VStack(spacing: 16) {
                // Step 1
                BudgetStepCard(
                    stepNumber: "1",
                    title: "Ay Başında Toplam Geliri Belirle",
                    description: "Maaş, ek gelir, yan iş - tüm kaynakları toplayın",
                    example: """
                    Örnek: 
                    Maaş €5.000 + Freelance €2.000 
                    = € 7.000
                    """,
                    icon: "arrow.down.circle.fill",
                    color: .mint
                )
                
                // Step 2
                BudgetStepCard(
                    stepNumber: "2",
                    title: "Sabit Giderleri Çıkar",
                    description: "Kira, faturalar, abonelikler, krediler ve diğer giderler",
                    example: """
                    Örnek: 
                    €2.600 (kira) + €1.500 (diğer giderler) 
                    = € 4.100
                    """,
                    icon: "minus.circle.fill",
                    color: .pink
                )
                
                // Step 3
                BudgetStepCard(
                    stepNumber: "3",
                    title: "Kalan Parayı Hesapla",
                    description: "Gelir - Sabit Gider = Harcanabilir Bütçe",
                    example: """
                        7.000 - 4.100 = € 2.900  (aylık serbest bütçe)
                        """,
                    icon: "equal.circle.fill",
                    color: .blue
                )
                
                // Step 4
                BudgetStepCard(
                    stepNumber: "4",
                    title: "Günlük Limit Belirle",
                    description: "Aylık bütçeyi 30 güne böl",
                    example: "€2.900 ÷ 30 = ~ 100 €/gün",
                    icon: "calendar.badge.clock",
                    color: .orange
                )
            }
            
            // Important Note
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("Önemli Not")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Text("Günlük limiti aşarsanız, ertesi günkü limitten düşürün. Harcamazsanız biriktirin. Bu sistem esneklik ve kontrol dengesi sağlar.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color.orange.opacity(0.1))
            .cornerRadius(10)
        }
    }
}

struct BudgetStepCard: View {
    let stepNumber: String
    let title: String
    let description: String
    let example: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // Step Number Circle
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 36, height: 36)
                
                Text(stepNumber)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(color)
            }
            
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.subheadline)
                    
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(example)
                    .font(.caption)
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(color.opacity(0.1))
                    .cornerRadius(6)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }
}

// MARK: - Income vs Expense Visualization
struct IncomeExpenseVisualizationView: View {
    // Example data
    let totalIncome: Double = 18000
    let totalExpense: Double = 12500
    
    var remaining: Double {
        totalIncome - totalExpense
    }
    
    var incomePercentage: Double {
        (totalIncome / (totalIncome + totalExpense)) * 100
    }
    
    var expensePercentage: Double {
        (totalExpense / (totalIncome + totalExpense)) * 100
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Gelir vs Gider Görselleştirme")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Aylık finansal dengenizi bir bakışta görün:")
                .font(.body)
                .foregroundColor(.secondary)
            
            // Pie Chart
            Chart {
                SectorMark(
                    angle: .value("Miktar", totalIncome),
                    innerRadius: .ratio(0.8),
                    angularInset: 2
                )
                .foregroundStyle(.mint)
                .cornerRadius(4)
                
                SectorMark(
                    angle: .value("Miktar", totalExpense),
                    innerRadius: .ratio(0.8),
                    angularInset: 2
                )
                .foregroundStyle(.pink)
                .cornerRadius(4)
            }
            .frame(height: 220)
            .chartBackground { chartProxy in
                GeometryReader { geometry in
                    let frame = geometry[chartProxy.plotAreaFrame]
                    VStack(spacing: 4) {
                        Text("Kalan")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$\(Int(remaining))")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    .position(x: frame.midX, y: frame.midY)
                }
            }
            
            // Legend
            VStack(spacing: 12) {
                HStack {
                    Circle()
                        .fill(.mint)
                        .frame(width: 12, height: 12)
                    Text("Toplam Gelir")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("$\(Int(totalIncome))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.mint)
                }
                
                HStack {
                    Circle()
                        .fill(.pink)
                        .frame(width: 12, height: 12)
                    Text("Toplam Gider")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text("$\(Int(totalExpense))")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.pink)
                }
                
                Divider()
                
                HStack {
                    Text("Günlük Harcama Limiti")
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Spacer()
                    Text("$\(Int(remaining / 30))/gün")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(12)
        }
    }
}

// MARK: - MONEYFLOW APP PROMOTION (Special Premium Section)
struct MoneyflowAppPromotionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Para yönetimine özelleşmiş bir uygulamamız var!")
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
            HStack(spacing: 16) {
                
                Image("moneyflow")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(14)
                    .shadow(color: .mint.opacity(0.9), radius: 8, x: 0, y: 4)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Moneyflow+")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text("Know Your Budget.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                //Spacer()
            }
            .padding()
            
            
            .cornerRadius(16)
            
            // Features Grid
            VStack(spacing: 12) {
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    MoneyflowFeatureCard(
                        icon: "hand.tap.fill",
                        title: "Easy Usage",
                    )
                    MoneyflowFeatureCard(
                        icon: "chart.pie.fill",
                        title: "Detailed Analytics",
                    )
                    
                    MoneyflowFeatureCard(
                        icon: "doc.text.fill",
                        title: "Financial Report Exports",
                    )
                    
                    MoneyflowFeatureCard(
                        icon: "bell.badge.fill",
                        title: "Smart Payment Reminders",
                    )
                    
                    
                }
            }
            .padding(.vertical, 12)
            
            // CTA Button
            Button(action: {
                if let url = URL(string: "https://apps.apple.com/tr/app/moneyflow/id6753347918") {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack(spacing: 12) {
                    Image(systemName: "arrow.down.circle.fill")
                        .font(.title3)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Moneyflow+")
                            .font(.headline)
                            .fontWeight(.bold)
                        
                        Text("App Store'dan İndir")
                            .font(.caption)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "chevron.right")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .padding()
                .background(
                    LinearGradient(
                        colors: [.mint, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(14)
                .shadow(color: .mint.opacity(0.4), radius: 12, x: 0, y: 6)
            }
            
           
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                colors: [.mint.opacity(0.5), .pink.opacity(0.5)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        )
                )
        )
        .shadow(color: .mint.opacity(0.15), radius: 20, x: 0, y: 10)
    }
}

struct MoneyflowFeatureCard: View {
    let icon: String
    let title: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(
                    LinearGradient(
                        colors: [.mint, .pink],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 32)
            
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            
        }
        .padding()
        .frame(width: 130, height: 130)
        .background(Color(.secondarySystemGroupedBackground).opacity(0.5))
        .cornerRadius(12)
    }
}

// MARK: - Behavioral Economics Research


// MARK: - TrackoApplicationGuideView Extension for Money Management
extension TrackoApplicationGuideView {
    init(sectionType: MoneyManagementSectionType, tips: [String], examples: [String]) {
        self.init(
            sectionType: .psychology, // Default fallback
            tips: tips,
            examples: examples
        )
    }
}

enum MoneyManagementSectionType {
    case moneyManagement
    
    var title: String {
        "Trackie ile Para Yönetimi Alışkanlıkları"
    }
    
    var icon: String {
        "chart.pie.fill"
    }
    
    var color: Color {
        .mint
    }
}

// MARK: - Preview
#Preview {
    NavigationView {
        ScrollView {
            MoneyflowSectionView()
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
