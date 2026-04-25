//
//  QuickProgramsView.swift
//  Trak
//
//  Created by Ege Özçelik on 19.09.2025.
//

// QuickProgramsView.swift
import SwiftUI

struct QuickProgramsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitStore: HabitStore
    @StateObject private var programStore = ProgramDataStore.shared
    
    @State private var selectedProgram: HabitProgram?
    @State private var contentVisible = false
    @State private var showDisclaimer = false
    @State private var disclaimerAccepted = false
    
    var body: some View {
        NavigationView {
            ZStack {
                AppStyles.Colors.background.edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack(spacing: 20) {
                        FreshStartBanner()
                        
                        LazyVStack(spacing: 16) {
                            ForEach(Array(programStore.programs.enumerated()), id: \.element.id) { index, program in
                                ProgramCard(program: program) {
                                    selectedProgram = program
                                }
                                .opacity(contentVisible ? 1 : 0)
                                .offset(y: contentVisible ? 0 : 30)
                                .scaleEffect(contentVisible ? 1.0 : 0.9)
                                .animation(
                                    AppStyles.Animations.spring.delay(Double(index) * 0.1 + 0.2),
                                    value: contentVisible
                                )
                            }
                        }
                        .padding(.horizontal, 16)
                        
                        // Coming Soon Placeholder
                        VStack(spacing: 12) {
                            Image(systemName: "sparkles")
                                .font(.system(size: 40))
                                .foregroundColor(AppStyles.Colors.secondaryText.opacity(0.5))
                            
                            Text("Don't Miss Out on New Programs!")
                                .font(AppStyles.Typography.headline)
                                .foregroundColor(AppStyles.Colors.secondaryText.opacity(0.7))
                            
                            Text("We'll be adding new programs for different goals. Make sure to keep the app up to date!")
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(AppStyles.Colors.secondaryText.opacity(0.5))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        .padding(.vertical, 30)
                        .opacity(contentVisible ? 1 : 0)
                        .animation(AppStyles.Animations.spring.delay(0.6), value: contentVisible)
                        
                        Spacer(minLength: 30)
                    }
                }
                .scrollIndicators(.hidden)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppStyles.Colors.primary)
                }
            }
            .onAppear {
                // Check if disclaimer has been accepted
                let hasAccepted = UserDefaults.standard.bool(forKey: "quickProgramsDisclaimerAccepted")
                if !hasAccepted {
                    showDisclaimer = true
                } else {
                    withAnimation {
                        contentVisible = true
                    }
                }
            }
            .onChange(of: disclaimerAccepted) { accepted in
                if accepted {
                    withAnimation {
                        contentVisible = true
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $showDisclaimer) {
            QuickProgramsDisclaimerView(isPresented: $showDisclaimer, disclaimerAccepted: $disclaimerAccepted)
        }
        .fullScreenCover(item: $selectedProgram) { program in
            ProgramDetailView(program: program)
                .environmentObject(habitStore)
        }
    }
}

struct ProgramCard: View {
    let program: HabitProgram
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            CardView(backgroundColor: Color.clear) {
                HStack(spacing: 16) {
                    // Program Image/Icon Section
                    VStack {
                        ZStack {
                            // Background with program color
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            program.color.opacity(0.3),
                                            program.color.opacity(0.1)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 80, height: 80)
                            
                            // Program Icon
                            Image(systemName: program.icon)
                                .font(.system(size: 36, weight: .medium))
                                .foregroundColor(program.color)
                        }
                    }
                    
                    // Program Info Section
                    VStack(alignment: .leading, spacing: 8) {
                        // Program Name
                        Text(program.name)
                            .font(AppStyles.Typography.headline)
                            .foregroundColor(AppStyles.Colors.text)
                            .lineLimit(2)
                        
                        // Program Description
                        Text(program.description)
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        
                        // Duration Badge
                        HStack(spacing: 8) {
                            HStack(spacing: 4) {
                                Image(systemName: "calendar")
                                    .font(.system(size: 10))
                                Text("\(program.duration) Days")
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                            }
                            .foregroundColor(program.color)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(program.color.opacity(0.15))
                            )
                            
                            HStack(spacing: 4) {
                                Image(systemName: "list.bullet")
                                    .font(.system(size: 10))
                                Text("\(program.habits.count) Habits")
                                    .font(.system(size: 11, weight: .medium, design: .rounded))
                            }
                            .foregroundColor(AppStyles.Colors.secondaryText)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(
                                Capsule()
                                    .fill(AppStyles.Colors.secondaryText.opacity(0.1))
                            )
                            
                            Spacer()
                        }
                    }
                    
                    // Arrow Icon
                    VStack {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(AppStyles.Colors.secondaryText.opacity(0.6))
                        
                        Spacer()
                    }
                    
                    Spacer(minLength: 0)
                }
                .padding(4)
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [
                        program.color.opacity(0.15),
                        program.color.opacity(0.08),
                        program.color.opacity(0.05)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(AppStyles.Dimensions.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                    .stroke(program.color.opacity(0.3), lineWidth: 1)
            )
            .shadow(color: program.color.opacity(0.2), radius: 8, x: 0, y: 4)
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(AppStyles.Animations.spring, value: isPressed)
        // FIXED: onTapGesture yerine simultaneousGesture kullanmıyoruz
        .onLongPressGesture(minimumDuration: 0, maximumDistance: 50) { pressing in
            withAnimation(AppStyles.Animations.quick) {
                isPressed = pressing
            }
        } perform: {
            // onTap zaten Button action'da çağrılıyor
        }
    }
}
struct QuickProgramsView_Previews: PreviewProvider {
    static var previews: some View {
        QuickProgramsView()
            .environmentObject(HabitStore())
    }
}
