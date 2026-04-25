//
//  ExploreHelpers.swift
//  Trak
//
//  Created by Ege Özçelik on 6.10.2025.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(URLRequest(url: url))
    }
}


struct SectionHeaderStrip: View {
    let icon: String
    let title: String
    let subtitle: String
    let gradientColors: [Color]
    
    @State private var shimmerOffset: CGFloat = -200
    
    init(icon: String, title: String, subtitle: String, gradientColors: [Color] = [Color.blue.opacity(0.1), Color.purple.opacity(0.05)]) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.gradientColors = gradientColors
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Sol taraf - Icon (statik)
            Image(systemName: icon)
                .font(.system(size: 34, weight: .light))
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [.primary, .primary, .mint]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 32, height: 32)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                // Title with shimmer
                Text(title)
                    .font(.system(size: 22, weight: .medium, design: .default))
                    .foregroundColor(.primary)
                    .textCase(nil)
                    .overlay(
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .clear,
                                            .black.opacity(0.6),
                                            .clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 100)
                                .offset(x: shimmerOffset)
                        }
                    )
                    .mask(
                        Text(title)
                            .font(.system(size: 22, weight: .medium, design: .default))
                            .textCase(nil)
                    )
                
                // Subtitle with shimmer
                Text(subtitle)
                    .font(.system(size: 16, weight: .light, design: .default))
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.trailing)
                    .textCase(nil)
                    .overlay(
                        GeometryReader { geometry in
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [
                                            .clear,
                                            .black.opacity(0.5),
                                            .clear
                                        ],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 220)
                                .offset(x: shimmerOffset)
                        }
                    )
                    .mask(
                        Text(subtitle)
                            .font(.system(size: 16, weight: .light, design: .default))
                            .multilineTextAlignment(.trailing)
                            .textCase(nil)
                    )
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 30)
        .background(
            LinearGradient(
                gradient: Gradient(colors: gradientColors),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .overlay(
            VStack {
                Rectangle()
                    .fill(Color.primary.opacity(0.08))
                    .frame(height: 0.5)
                Spacer()
                Rectangle()
                    .fill(Color.primary.opacity(0.08))
                    .frame(height: 0.5)
            }
        )
        .ignoresSafeArea(.container, edges: [.horizontal])
        .padding(.bottom, 10)
        .onAppear {
            withAnimation(
                .linear(duration: 3.0)
                .repeatForever(autoreverses: false)
            ) {
                shimmerOffset = 300
            }
        }
    }
}

struct SourceCard: View {
    let section: String
    let source: String
    let year: String
    let url: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "link.circle.fill")
                    .font(.title3)
                    .foregroundColor(Color.mint)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(section)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                    
                    Text(source)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(Color.black)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(year)")
                        .font(.caption2)
                        .foregroundColor(Color.black.opacity(0.7))
                }
                
                Spacer()
                
                Image(systemName: "arrow.up.right.circle")
                    .font(.subheadline)
                    .foregroundColor(Color.black)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}






struct InlineDisclaimerStrings {
    let language: DisclaimerLanguage
    
    var title: String {
        switch language {
        case .turkish: return "Bilgilendirme ve Sorumluluk Reddi"
        case .english: return "Information & Disclaimer"
        }
    }
    
    var shortDescription: String {
        switch language {
        case .turkish: return "Trackie olarak amacımız, sizi alışkanlık oluşturma konusunda bilimsel araştırmalar ışığında bilinçlendirmek ve bu yolculukta size destek olmaktır."
        case .english: return "As Trackie, our mission is to educate you about habit formation through scientific research and support you on this journey."
        }
    }
    
    var detailedInfo: String {
        switch language {
        case .turkish: return "Detaylı Bilgi"
        case .english: return "Detailed Info"
        }
    }
    
    var collapse: String {
        switch language {
        case .turkish: return "Gizle"
        case .english: return "Collapse"
        }
    }
    
    var point1: String {
        switch language {
        case .turkish: return "Bu uygulama, kişisel gelişim ve bilinçlendirme amacıyla tasarlanmıştır. Tıbbi bir teşhis, tedavi veya danışmanlık aracı değildir."
        case .english: return "This app is designed for personal development and awareness purposes. It is not a medical diagnosis, treatment, or consultation tool."
        }
    }
    
    var point2: String {
        switch language {
        case .turkish: return "İçeriklerimiz akademik kaynaklardan derlenmiştir. Ancak güncelliği ve mutlak doğruluğu garanti verilemez. Bilimsel bilgi sürekli gelişir ve sonuçlar kişiden kişiye değişebilir."
        case .english: return "Our content is compiled from academic sources. However, currency and absolute accuracy cannot be guaranteed. Scientific knowledge constantly evolves and results may vary from person to person."
        }
    }
    
    var point3: String {
        switch language {
        case .turkish: return "Sağlık, beslenme veya psikolojik konularda profesyonel desteğe ihtiyaç duyuyorsanız, lütfen alanında uzman kişilerle görüşün."
        case .english: return "If you need professional support in health, nutrition, or psychological matters, please consult with qualified experts in those fields."
        }
    }
    
    var point4: String {
        switch language {
        case .turkish: return "Uygulama 'olduğu gibi' sunulmaktadır. Bu uygulamayı kullanarak, verilen bilgileri kendi sağlık durumunuz ve kişisel koşullarınız bağlamında değerlendirme sorumluluğunu kabul etmiş olursunuz. Uygulama geliştiricisi ve Trackie, içeriklerin kullanımından doğrudan veya dolaylı olarak kaynaklanan herhangi bir sonuç, zarar veya kayıptan sorumlu tutulamaz."
        case .english: return "The app is provided 'as is'. By using this app, you accept responsibility for evaluating the provided information in the context of your own health condition and personal circumstances. The app developer and Trackie cannot be held responsible for any result, damage, or loss arising directly or indirectly from the use of the content."
        }
    }
    
    var emergencyTitle: String {
        switch language {
        case .turkish: return "🚨 Acil Durumlarda"
        case .english: return "🚨 In Emergencies"
        }
    }
    
    var emergencyHealth: String {
        switch language {
        case .turkish: return "Sağlık"
        case .english: return "Health"
        }
    }
    
    var emergencySupport: String {
        switch language {
        case .turkish: return "Destek"
        case .english: return "Support"
        }
    }
}

struct InlineDisclaimerView: View {
    @State private var isExpanded = false
    @State private var selectedLanguage: DisclaimerLanguage = .turkish
    
    private var strings: InlineDisclaimerStrings {
        InlineDisclaimerStrings(language: selectedLanguage)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Header with Language Switch
            HStack(spacing: 12) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.blue)
                
                Text(strings.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                
                Spacer()
                
                // Language Switch (compact)
                HStack(spacing: 0) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedLanguage = .turkish
                        }
                    }) {
                        Text("TR")
                            .font(.system(size: 14))
                            .frame(width: 32, height: 26)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(selectedLanguage == .turkish ? Color.blue : Color.clear)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedLanguage = .english
                        }
                    }) {
                        Text("EN")
                            .font(.system(size: 14))
                            .frame(width: 32, height: 26)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(selectedLanguage == .english ? Color.blue : Color.clear)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(Color(.systemGray6))
                )
            }
            
            // Collapsed Content
            if !isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Text(strings.shortDescription)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.primary)
                        .lineSpacing(3)
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isExpanded.toggle()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Text(strings.detailedInfo)
                                .font(.system(size: 14, weight: .medium))
                            
                            Image(systemName: "chevron.down")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(.blue)
                    }
                }
            }
            
            // Expanded Content
            if isExpanded {
                VStack(alignment: .leading, spacing: 16) {
                    Text(strings.shortDescription)
                        .font(.system(size: 14, weight: .regular))
                        .foregroundColor(.primary)
                        .lineSpacing(3)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 14) {
                        CompactInfoRow(
                            icon: "circle",
                            iconColor: .blue,
                            text: strings.point1
                        )
                        
                        CompactInfoRow(
                            icon: "circle",
                            iconColor: .blue,
                            text: strings.point2
                        )
                        
                        CompactInfoRow(
                            icon: "circle",
                            iconColor: .blue,
                            text: strings.point3
                        )
                        
                        CompactInfoRow(
                            icon: "shield",
                            iconColor: .red,
                            text: strings.point4
                        )
                    }
                    
                    Divider()
                    
                   
                    
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            isExpanded.toggle()
                        }
                    }) {
                        HStack(spacing: 6) {
                            Text(strings.collapse)
                                .font(.system(size: 14, weight: .medium))
                            
                            Image(systemName: "chevron.up")
                                .font(.system(size: 11, weight: .semibold))
                        }
                        .foregroundColor(.blue)
                    }
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                )
        )
        .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 2)
    }
}
struct CompactInfoRow: View {
    let icon: String
    let iconColor: Color
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(iconColor)
                .frame(width: 20, height: 20)
            
            Text(text)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(.secondary)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
