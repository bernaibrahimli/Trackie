import SwiftUI
import Charts
import WebKit


struct ScienceSectionView: View {
    @State private var stressLevel: Double = 0.5
    @State private var isResearchExpanded: Bool = false
    
    var body: some View {
            VStack(alignment: .leading, spacing: 20) {
                
                // Başlık bölümü
                SectionHeaderStrip(
                    icon: "brain.head.profile",
                    title: "Stress",
                    subtitle: "How it influences body and mind",
                    gradientColors: [
                        Color.mint.opacity(0.9),
                        Color.mint.opacity(0.7),
                        Color.mint.opacity(0.5),
                        Color.mint.opacity(0.3),
                        Color.clear
                    ]
                )
                .padding(.horizontal)
                
                // Giriş
                Text("""
Stress triggers a cascade of physiological reactions — from hormone surges to immune shifts — and when sustained, it can contribute to chronic disease risk.  
Short-term stress can help us respond to danger, but when it persists, it becomes harmful.  
(anlam türetimi, Harvard)  
""")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.horizontal)
                
                // MARK: - Stress Response Chain
                VStack(alignment: .leading, spacing: 12) {
                    Text("The Stress Response: Fight-or-Flight and HPA Axis")
                        .font(.headline)
                    Text("""
When a threat is perceived, the amygdala signals the hypothalamus, triggering the sympathetic nervous system and adrenal release of epinephrine (adrenaline). Then the HPA axis (hypothalamus → pituitary → adrenals) releases cortisol to maintain the state of alert.  
(uyarlama, Harvard)  
""")
                    .font(.body)
                    
                    Text("If this system remains chronically active, it can contribute to hypertension, anxiety, metabolic changes, and vascular damage.  (Harvard)  ")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)
                
                // MARK: - Body Systems Affected
                VStack(alignment: .leading, spacing: 15) {
                    Text("Systemic Effects of Chronic Stress")
                        .font(.headline)
                    
                    Group {
                        HStack(alignment: .top) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.red)
                            Text("Cardiovascular: Long-term stress may raise blood pressure and promote formation of arterial plaques.  (Harvard) ")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "lungs.fill")
                                .foregroundColor(.blue)
                            Text("Respiratory: Stress can exacerbate breathing problems by tightening airways (e.g. in asthma).  (APA) ")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "flame.fill")
                                .foregroundColor(.orange)
                            Text("Immune & Inflammation: Chronic stress can lead to a low-grade inflammatory state and impair resistance to infection.  (Harvard & APA) ")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "brain.head.side.fill")
                                .foregroundColor(.purple)
                            Text("Brain & Cognition: Prolonged stress impairs hippocampal neurons (memory center) and shifts brain toward threat responses.  (Harvard) ")
                        }
                        HStack(alignment: .top) {
                            Image(systemName: "leaf.fill")
                                .foregroundColor(.green)
                            Text("Endocrine & Metabolic: Excess cortisol can increase appetite, promote fat storage, dysregulate glucose metabolism.  (Harvard) ")
                        }
                    }
                }
                .padding(.horizontal)
                
                // MARK: - Hormone Visualization
                VStack(alignment: .leading, spacing: 12) {
                    Text("Hormonal Balance vs Stress Level")
                        .font(.headline)
                    Text("Illustrative representation. Actual hormone levels vary individually")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Chart {
                        BarMark(
                            x: .value("Hormone", "Cortisol"),
                            y: .value("Level", stressLevel * 100)
                        )
                        .foregroundStyle(Color.red.gradient)
                        
                        BarMark(
                            x: .value("Hormone", "DHEA"),
                            y: .value("Level", (1 - stressLevel) * 80)
                        )
                        .foregroundStyle(Color.blue.gradient)
                        
                        BarMark(
                            x: .value("Hormone", "Serotonin"),
                            y: .value("Level", (1 - stressLevel) * 90)
                        )
                        .foregroundStyle(Color.green.gradient)
                    }
                    .chartYAxis(.hidden)
                    .chartYScale(domain: 0...100)
                    .frame(height: 240)
                    .padding(.horizontal)
                    
                    Slider(value: $stressLevel, in: 0.0...1.0)
                        .accentColor(.red)
                        .padding(.horizontal)
                    HStack {
                        Text("Low Stress")
                        Spacer()
                        Text("High Stress")
                    }
                    .font(.caption)
                    .padding(.horizontal)
                }
                .padding(.horizontal)
                // MARK: - Stress Relief Practices
                VStack(alignment: .leading, spacing: 15) {
                    Text("Stress Relief & Resilience Strategies")
                        .font(.headline)
                    
                    Text("""
• Deep breathing, meditation, and guided imagery help evoke a “relaxation response” that counters the stress cascade.  (Harvard)  
• Regular physical activity reduces stress hormone levels, increases mood-boosting endorphins, and supports metabolic health.  (Harvard)  
• Adequate sleep (≥ 7 hours), social connections, and a mostly plant-based diet improve resilience to stress.  (Harvard)  
• Progressive muscle relaxation, mindfulness breaks, structured goals, and cognitive reframing are effective tools in reducing stress burden.  (Harvard)  
""")
                    .font(.body)
                }
                .padding(.horizontal)
                
                // MARK: - Research & References
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: {
                        withAnimation { isResearchExpanded.toggle() }
                    }) {
                        HStack {
                            Image(systemName: "doc.text.magnifyingglass")
                            Text("Stress Research & Sources")
                                .font(.title3)
                                .fontWeight(.semibold)
                            Spacer()
                            Image(systemName: isResearchExpanded ? "chevron.up" : "chevron.down")
                        }
                    }
                    
                    if isResearchExpanded {
                        VStack(alignment: .leading, spacing: 10) {
                            ResearchCard(
                                title: "Harvard Health — Understanding Stress",
                                detail: "Chronic stress contributes to high blood pressure, brain changes, metabolic shifts. (Harvard)",
                                url: "https://www.health.harvard.edu/staying-healthy/understanding-the-stress-response"
                            )
                            ResearchCard(
                                title: "APA — Stress Effects on Body Systems",
                                detail: "Stress influences systems including cardiovascular, respiratory, endocrine and immune. (APA)",
                                url: "https://www.apa.org/topics/stress/body"
                            )
                            ResearchCard(
                                title: "Harvard — Ways to Reduce Daily Stress",
                                detail: "Sleep, diet, exercise, mindfulness all buffer against stress’s negative impact. (Harvard)",
                                url: "https://www.health.harvard.edu/staying-healthy/top-ways-to-reduce-daily-stress"
                            )
                        }
                    }
                }
                .padding(.horizontal)
                
                // Boşluk alt
                Spacer(minLength: 30)
            }
            .padding(.vertical)
        
    }
}

// MARK: — ResearchCard
struct ResearchCard: View {
    let title: String
    let detail: String
    let url: String
    @State private var showWeb = false
    
    var body: some View {
        Button(action: { showWeb.toggle() }) {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(detail)
                    .font(.body)
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color(.secondarySystemGroupedBackground))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showWeb) {
            NavigationView {
                WebView(url: URL(string: url)!)
                    .navigationTitle(title)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Close") {
                                showWeb = false
                            }
                        }
                    }
            }
        }
    }
}



#Preview{
    NavigationView {
        ScrollView {
            ScienceSectionView()
                .preferredColorScheme(.dark)
                .padding()
        }
    }
}
