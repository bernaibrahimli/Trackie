// ExploreView.swift - Updated with Card View Toggle
import SwiftUI

struct ExploreView: View {
    @State private var showDisclaimer = false
    @State private var disclaimerAccepted = false
    @State private var showCardView = true
    @State private var selectedSection: SectionType? = nil
    @State private var hasCheckedDisclaimer = false   // ✅ eklendi

    @Environment(\.presentationMode) var presentationMode
    private let disclaimerKey = "exploreDisclaimerAccepted"

    

    
    var body: some View {
        NavigationView {
            Group {
                if showCardView {
                    
                    ScrollView {
                        ExploreBanner()
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: 16),
                            GridItem(.flexible(), spacing: 16)
                        ], spacing: 20) {
                            SectionCard(
                                sectionType: .stress,
                                title: "Stress & Science",
                                subtitle: "Cellular Impact",
                                icon: "brain.head.profile",
                                description: "How stress affects your DNA, mitochondria, and cellular health"
                            ){
                                selectedSection = .stress
                                
                            }
                            
                            SectionCard(
                                sectionType: .psychology,
                                title: "Psychology",
                                subtitle: "Habit Formation",
                                icon: "lightbulb.min",
                                description: "The science behind building micro-habits and behavior change"
                            ){  
                                selectedSection = .psychology
                            }
                            
                            SectionCard(
                                sectionType: .chronobiology,
                                title: "Chronobiology",
                                subtitle: "Body Rhythms",
                                icon: "clock",
                                description: "Optimize your daily routine with circadian rhythm science"
                            ){  // ← YENİ EKLEME - closure
                                selectedSection = .chronobiology
                            }
                            
                            SectionCard(
                                sectionType: .nutrition,
                                title: "Nutrition",
                                subtitle: "Gut-Brain Connection",
                                icon: "leaf",
                                description: "Microbiome, prebiotics, and anti-inflammatory foods"
                            ){  // ← YENİ EKLEME - closure
                                selectedSection = .nutrition
                            }
                            
                            SectionCard(
                                sectionType: .culture,
                                title: "Culture",
                                subtitle: "Global Wisdom",
                                icon: "globe",
                                description: "Traditional habits from Blue Zones and ancient cultures"
                            ){  // ← YENİ EKLEME - closure
                                selectedSection = .culture
                            }
                            
                            SectionCard(
                                sectionType: .dataDriven,
                                title: "Data-Driven",
                                subtitle: "Self Tracking",
                                icon: "chart.bar",
                                description: "Quantified self methods and personal analytics"
                            ){
                                selectedSection = .dataDriven
                            }
                            
                            SectionCard(
                                sectionType: .moneyflow,
                                title: "Moneyflow",
                                subtitle: "Incomes & Expenses",
                                icon: "chart.pie.fill",
                                description: "Understanding your spending psychology"
                            ){
                                selectedSection = .moneyflow
                            }
                            
                            SectionCard(
                                sectionType: .dopamine,
                                title: "Dopamine",
                                subtitle: "Reward Systems",
                                icon: "bolt.circle",
                                description: "Understanding motivation and healthy reward mechanisms"
                            ){
                                selectedSection = .dopamine
                            }
                            
                            SectionCard(
                                sectionType: .digitalHygiene,
                                title: "Digital Hygiene",
                                subtitle: "Tech Balance",
                                icon: "iphone",
                                description: "Managing screen time and digital wellness"
                            ){
                                selectedSection = .digitalHygiene
                            }
                        }
                        .padding()
                        /*InlineDisclaimerView()
                            .padding(.horizontal)
                            .padding(.top, 32)
                            .padding(.bottom, 16)*/
                    }
                } else {
                  

                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            ExploreBanner()
                            ScienceSectionView()
                                .padding(.vertical, 50)
                           
                            PsychologySectionView()
                                .padding(.vertical, 50)
                            ChronobiologySectionView()
                                .padding(.vertical, 50)
                            NutritionSectionView()
                                .padding(.vertical, 50)
                            CultureSectionView()
                                .padding(.vertical, 50)
                            DataDrivenSectionView()
                                .padding(.vertical, 50)
                            MoneyflowSectionView()
                                .padding(.vertical, 50)
                            DopamineSectionView()
                                .padding(.vertical, 50)
                            DigitalHygieneSectionView()
                                
                            /*InlineDisclaimerView()
                                .padding(.horizontal)
                                .padding(.vertical, 50)*/
                        }
                    }
                        //.padding()
                    
                }
            }
            .blur(radius: showDisclaimer ? 3 : 0)
            .animation(.easeInOut(duration: 0.3), value: showDisclaimer)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.4)) {
                            showCardView.toggle()
                        }
                    }) {
                        Image(systemName: showCardView ? "eyeglasses" : "square.grid.2x2")
                            .font(.system(size: 16, weight: .light))
                            .foregroundColor(.primary)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                        //selectedSection = nil
                    }
                    .font(.system(size: 16, weight: .light))
                    .foregroundColor(.primary)
                }
            }
        }
        .onAppear {
            if !hasCheckedDisclaimer {
                checkDisclaimerStatus()
                hasCheckedDisclaimer = true
               
            }
        }
        .sheet(item: $selectedSection) { sectionType in
            NavigationView {
                ScrollView {
                    Group {
                        switch sectionType {
                        case .stress:
                            ScienceSectionView()
                        case .psychology:
                            PsychologySectionView()
                        case .chronobiology:
                            ChronobiologySectionView()
                        case .nutrition:
                            NutritionSectionView()
                        case .culture:
                            CultureSectionView()
                        case .moneyflow:
                            MoneyflowSectionView()
                        case .dataDriven:
                            DataDrivenSectionView()
                        case .dopamine:
                            DopamineSectionView()
                        case .digitalHygiene:
                            DigitalHygieneSectionView()
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle(sectionType.title)
                .navigationBarTitleDisplayMode(.large)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Kapat") {
                            selectedSection = nil
                        }
                    }
                }
                
            }
        }
        .fullScreenCover(isPresented: $showDisclaimer) {
            ExploreDisclaimerView(
                isPresented: $showDisclaimer,
                disclaimerAccepted: $disclaimerAccepted
            )
        }
        
    }
    private func checkDisclaimerStatus() {
            let hasAcceptedBefore = UserDefaults.standard.bool(forKey: disclaimerKey)
            if !hasAcceptedBefore {
                showDisclaimer = true
                disclaimerAccepted = false
            } else {
                showDisclaimer = false
                disclaimerAccepted = true
            }
        }
}


enum SectionType: String, CaseIterable, Identifiable {
    case stress = "stress"
    case psychology = "psychology"
    case chronobiology = "chronobiology"
    case nutrition = "nutrition"
    case culture = "culture"
    case dataDriven = "dataDriven"
    case dopamine = "dopamine"
    case digitalHygiene = "digitalHygiene"
    case moneyflow = "moneyflow"
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .stress: return "Stress & Science"
        case .psychology: return "Psychology"
        case .chronobiology: return "Chronobiology"
        case .nutrition: return "Nutrition"
        case .culture: return "Culture"
        case .dataDriven: return "Data-Driven"
        case .dopamine: return "Dopamine"
        case .digitalHygiene: return "Digital Hygiene"
        case .moneyflow: return "Moneyflow"
        }
    }
}




// MARK: - Supporting Components



struct SectionCard: View {
    let sectionType: SectionType
    let title: String
    let subtitle: String
    let icon: String
    let description: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 12) {
                Spacer()
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .ultraLight))
                        .foregroundColor(.primary)
                        .frame(width: 32, height: 32)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 2) {
                        Text(title)
                            .font(.system(size: 15, weight: .light))
                            .foregroundColor(.primary)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.trailing)
                        
                        Text(subtitle)
                            .font(.system(size: 12, weight: .ultraLight))
                            .foregroundColor(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                            .multilineTextAlignment(.trailing)
                    }
                }
                Spacer()
                
                // Description
                Text(description)
                    .font(.system(size: 13, weight: .light))
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
                
                Spacer()
            }
            .padding(10)
            .frame(height: 150)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.systemBackground))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color(.systemGray5), lineWidth: 0.5)
                    )
            )
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}











struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        ExploreView()
            .preferredColorScheme(.dark)
    }
}
