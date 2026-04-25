//
//  QuickProgramsCard.swift
//  Trak
//
//  Created by Ege Özçelik on 19.09.2025.
//

// QuickProgramsCard.swift
import SwiftUI

struct QuickProgramsCard: View {
    @Binding var isPresented: Bool   // dışarıdan sheet kontrolü
    @State private var animateIcons = false
    @State private var cardPressed = false
    @StateObject private var programStore = ProgramDataStore.shared
    
    var body: some View {
        CardView(backgroundColor: AppStyles.Colors.secondaryBackground.opacity(0.7)) {
            VStack(alignment: .leading, spacing: AppStyles.Dimensions.standardPadding) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Quick Programs")
                            .font(Font.system(.caption, design: .rounded).weight(.medium))
                            .foregroundColor(AppStyles.Colors.secondaryText)
                        
                        Text("Fresh Start")
                            .font(Font.system(size: 24, weight: .bold))
                            .foregroundColor(AppStyles.Colors.text)
                        
                        Text("\(programStore.programs.count) pre-defined program for you")
                            .font(Font.system(.footnote, design: .rounded).weight(.medium))
                            .foregroundColor(AppStyles.Colors.secondaryText)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        AppStyles.Colors.gradient1.opacity(0.15),
                                        AppStyles.Colors.gradient2.opacity(0.25)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                            .shadow(color: AppStyles.Colors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
                        
                        Group {
                           
                            Image(systemName: "sparkles")
                                .font(.system(size: 24, weight: .medium))
                                .foregroundColor(AppStyles.Colors.primary)
                                .offset(y: animateIcons ? -1 : 1)
                                
                        }
                        .animation(
                            Animation.easeInOut(duration: 1.0)
                                .repeatForever(autoreverses: true),
                            value: animateIcons
                        )
                    }
                    .onAppear {
                        animateIcons = true
                    }
                }
                
                // Mini program previews
                HStack(spacing: 12) {
                    ForEach(Array(programStore.programs.prefix(2).enumerated()), id: \.element.id) { index, program in
                        VStack(spacing: 4) {
                            ZStack {
                                Circle()
                                    .fill(program.color.opacity(0.15))
                                    .frame(width: 32, height: 32)
                                
                                Image(systemName: program.icon)
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(program.color)
                            }
                            .scaleEffect(animateIcons ? 1.0 : 0.9)
                            .animation(
                                AppStyles.Animations.spring.delay(Double(index) * 0.2),
                                value: animateIcons
                            )
                            
                            Text(program.name.split(separator: " ").first?.description ?? "")
                                .font(.system(size: 9, weight: .medium, design: .rounded))
                                .foregroundColor(AppStyles.Colors.secondaryText)
                                .lineLimit(1)
                        }
                    }
                    
                    VStack(spacing: 4) {
                        ZStack {
                            Circle()
                                .fill(AppStyles.Colors.primary.opacity(0.1))
                                .frame(width: 32, height: 32)
                            
                            Text("\(programStore.programs.count-2)+")
                                .font(.system(size: 12, weight: .bold, design: .rounded))
                                .foregroundColor(AppStyles.Colors.primary)
                        }
                        
                        Text("more")
                            .font(.system(size: 9, weight: .medium, design: .rounded))
                            .foregroundColor(AppStyles.Colors.secondaryText)
                    }
                    .opacity(animateIcons ? 1.0 : 0.0)
                    .animation(
                        AppStyles.Animations.spring.delay(0.6),
                        value: animateIcons
                    )
                    
                    Spacer()
                    
                  
                }
                .padding(.top, 4)
            }
            
        }
        .clipShape(Rectangle())
        .scaleEffect(cardPressed ? 0.98 : 1.0)
        .animation(AppStyles.Animations.spring, value: cardPressed)
        .shadow(color: AppStyles.Colors.primary.opacity(0.15), radius: 8, x: 0, y: 4)
        
    }
}
