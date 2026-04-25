//
//  ProgramDetailView.swift
//  Trak
//
//  Created by Ege Özçelik on 19.09.2025.
//

// ProgramDetailView.swift
import SwiftUI


struct ProgramDetailView: View {
    let program: HabitProgram
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitStore: HabitStore
    
    @State private var showApplySheet = false
    @State private var showHabitLimitAlert = false
    @State private var contentVisible = false
    
    private var currentHabitCount: Int {
        habitStore.habits.count
    }
    
    private var wouldExceedLimit: Bool {
        currentHabitCount + program.habits.count > 10
    }
    
    private var habitsToRemove: Int {
        max(0, (currentHabitCount + program.habits.count) - 10)
    }
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack(spacing: 10) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 20)
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
                                    .frame(width: 100, height: 100)
                                
                                Image(systemName: program.icon)
                                    .font(.system(size: 48, weight: .medium))
                                    .foregroundColor(program.color)
                            }
                            .scaleEffect(contentVisible ? 1.0 : 0.8)
                            .animation(AppStyles.Animations.spring, value: contentVisible)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(program.name)
                                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                                    .foregroundColor(AppStyles.Colors.text)
                                    .lineLimit(3)
                                    .multilineTextAlignment(.leading)
                                
                                // Program stats
                                HStack(spacing: 15) {
                                    Label("\(program.duration) days", systemImage: "calendar")
                                        .font(.caption)
                                        .foregroundColor(AppStyles.Colors.primary)
                                    
                                    Label("\(program.habits.count) habits", systemImage: "list.bullet")
                                        .font(.caption)
                                        .foregroundColor(AppStyles.Colors.primary)
                                }
                            }
                            
                            Spacer()
                           
                            VStack {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .font(.system(size: 26))
                                        .foregroundColor(AppStyles.Colors.secondaryText)
                                        .background(Circle().fill(AppStyles.Colors.background))
                                }
                            }
                        }
                        .opacity(contentVisible ? 1 : 0)
                        .offset(y: contentVisible ? 0 : -20)
                        .animation(AppStyles.Animations.spring.delay(0.1), value: contentVisible)
                        
                        // Detailed Description
                        Text(program.detailedDescription)
                            .font(AppStyles.Typography.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                            .lineLimit(nil)
                            .padding(.top, 8)
                            .opacity(contentVisible ? 1 : 0)
                            .offset(y: contentVisible ? 0 : -15)
                            .animation(AppStyles.Animations.spring.delay(0.2), value: contentVisible)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    
                    // Habits List
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Program Content (\(program.habits.count) Habits)")
                            .font(AppStyles.Typography.headline)
                            .foregroundColor(AppStyles.Colors.text)
                            .padding(.horizontal, 20)
                            .opacity(contentVisible ? 1 : 0)
                            .animation(AppStyles.Animations.spring.delay(0.3), value: contentVisible)
                        
                        LazyVStack(spacing: 12) {
                            ForEach(Array(program.habits.enumerated()), id: \.element.id) { index, habit in
                                ProgramHabitCard(habit: habit, program: program)
                                    .opacity(contentVisible ? 1 : 0)
                                    .offset(x: contentVisible ? 0 : 20)
                                    .animation(
                                        AppStyles.Animations.spring.delay(Double(index) * 0.05 + 0.4),
                                        value: contentVisible
                                    )
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    
                    // Bottom space for floating button
                    Spacer()
                        .frame(height: 120)
                }
            }
            .scrollIndicators(.hidden)
            .background(AppStyles.Colors.background.edgesIgnoringSafeArea(.all))
            
            // Floating Apply Button
            VStack {
                Spacer()
                
                Button(action: {
                    if wouldExceedLimit {
                        showHabitLimitAlert = true
                    } else {
                        showApplySheet = true
                    }
                }) {
                    HStack(spacing: 12) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 20, weight: .medium))
                        
                        Text("Start This Journey")
                            .font(AppStyles.Typography.button)
                    }
                    .foregroundColor(AppStyles.Colors.lightText)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                program.color,
                                program.color.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(25)
                    .shadow(color: program.color.opacity(0.4), radius: 8, x: 0, y: 4)
                }
                .scaleEffect(contentVisible ? 1.0 : 0.0)
                .animation(AppStyles.Animations.bounce.delay(0.8), value: contentVisible)
                .padding(.bottom, 40)
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("")
        .navigationBarHidden(true)
        .onAppear {
            withAnimation {
                contentVisible = true
            }
        }
        .sheet(isPresented: $showApplySheet) {
            ApplyProgramSheet(
                program: program,
                isPresented: $showApplySheet,
                onApply: applyProgram
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
        .alert("Habit Limit Exceeded", isPresented: $showHabitLimitAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You currently have \(currentHabitCount) habits. This program will add \(program.habits.count) habits.\n\nYou can have a maximum of 10 habits. Please delete \(habitsToRemove) habit(s) first.")
        }
    }
    
    private func applyProgram() {
        // Önce habit'leri ekle
        for programHabit in program.habits {
            let newHabit = programHabit.toHabit()
            habitStore.addHabit(newHabit)
        }
        
        // Haptic feedback
        let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
        impactFeedback.impactOccurred()
        
        // Kısa bir delay sonra ProgramDetailView'ı kapat
        // Sheet zaten butondan kapatılacak
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// MARK: - Apply Program Sheet
struct ApplyProgramSheet: View {
    let program: HabitProgram
    @Binding var isPresented: Bool
    let onApply: () -> Void
    
    @State private var animateContent = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Icon
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                program.color.opacity(0.2),
                                program.color.opacity(0.1)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 80, height: 80)
                
                Image(systemName: program.icon)
                    .font(.system(size: 40, weight: .medium))
                    .foregroundColor(program.color)
            }
            .scaleEffect(animateContent ? 1.0 : 0.5)
            .opacity(animateContent ? 1 : 0)
            .padding(.top, 32)
            .padding(.bottom, 20)
            
            // Title
            Text("Apply Program")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundColor(AppStyles.Colors.text)
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
                .padding(.bottom, 12)
            
            // Message
            VStack(spacing: 8) {
                Text("Do you want to add \(program.habits.count) habits from this program to your habit list?")
                    .font(AppStyles.Typography.body)
                    .foregroundColor(AppStyles.Colors.secondaryText)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                
                Text("Program: \(program.name)")
                    .font(AppStyles.Typography.headline)
                    .foregroundColor(program.color)
                    .padding(.top, 4)
            }
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 20)
            .padding(.horizontal, 32)
            .padding(.bottom, 28)
            
            // Buttons
            VStack(spacing: 12) {
                // Apply Button - ÇÖZ��M 2: Önce onApply, sonra sheet kapat
                Button(action: {
                    // 1. Önce habit ekleme işlemini yap
                    onApply()
                    
                    // 2. Kısa bir delay sonra sheet'i kapat
                    // Bu sayede kullanıcı feedback görebilir
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        isPresented = false
                    }
                }) {
                    HStack(spacing: 10) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 18, weight: .medium))
                        Text("Apply Program")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                program.color,
                                program.color.opacity(0.8)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(14)
                    .shadow(color: program.color.opacity(0.4), radius: 12, x: 0, y: 6)
                }
                
                // Cancel Button
                Button(action: {
                    isPresented = false
                }) {
                    Text("Cancel")
                        .font(.system(size: 17, weight: .medium))
                        .foregroundColor(AppStyles.Colors.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(AppStyles.Colors.secondaryBackground.opacity(0.5))
                        )
                }
            }
            .opacity(animateContent ? 1 : 0)
            .offset(y: animateContent ? 0 : 20)
            .padding(.horizontal, 20)
        }
        .padding(.bottom, 40)
        .onAppear {
            // Sheet animasyonu
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateContent = true
            }
        }
    }
}
struct ProgramHabitCard: View {
    let habit: ProgramHabit
    let program: HabitProgram
    
    var body: some View {
        CardView(backgroundColor: AppStyles.Colors.secondaryBackground.opacity(0.6)) {
            HStack(spacing: 16) {
                // Habit Icon
                ZStack {
                    Circle()
                        .fill(program.color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: getHabitIcon(for: habit.name))
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(program.color)
                }
                
                // Habit Info
                VStack(alignment: .leading, spacing: 6) {
                    Text(habit.name)
                        .font(AppStyles.Typography.headline)
                        .foregroundColor(AppStyles.Colors.text)
                        .lineLimit(2)
                    
                    Text(habit.description)
                        .font(AppStyles.Typography.body)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                        .lineLimit(2)
                    
                    // Habit details
                    HStack(spacing: 12) {
                        // Frequency
                        Label(habit.benefits, systemImage: "clock")
                            .font(.caption)
                            .foregroundColor(AppStyles.Colors.primary)
                        
                        // Goal if exists
                        if let goal = habit.dailyGoal, goal.type != .single {
                            Label("\(goal.target) \(goal.unit)", systemImage: "target")
                                .font(.caption)
                                .foregroundColor(AppStyles.Colors.primary)
                        }
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func getHabitIcon(for habitName: String) -> String {
        let habitLower = habitName.lowercased()
        
        if habitLower.contains("sebze") || habitLower.contains("vegetable") { return "leaf.fill" }
        if habitLower.contains("su") || habitLower.contains("water") || habitLower.contains("chia") { return "drop.fill" }
        if habitLower.contains("vitamin") { return "pills.fill" }
        if habitLower.contains("atıştırmalık") || habitLower.contains("snack") { return "takeoutbag.and.cup.and.straw.fill" }
        if habitLower.contains("akşam") || habitLower.contains("yemek") || habitLower.contains("meal") { return "fork.knife" }
        if habitLower.contains("yoga") { return "figure.mind.and.body" }
        if habitLower.contains("meditasyon") || habitLower.contains("meditation") { return "brain.head.profile" }
        if habitLower.contains("yürüyüş") || habitLower.contains("walk") { return "figure.walk" }
        if habitLower.contains("nefes") || habitLower.contains("breath") { return "wind" }
        if habitLower.contains("stretching") || habitLower.contains("germe") { return "figure.flexibility" }
        if habitLower.contains("refleksiyon") || habitLower.contains("reflection") || habitLower.contains("journal") { return "pencil.and.scribble" }
        if habitLower.contains("uyku") || habitLower.contains("sleep") { return "bed.double.fill" }
        
        return "star.fill"
    }
}

struct ProgramDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleProgram = ProgramDataStore.shared.programs.first!
        
        return ProgramDetailView(program: sampleProgram)
            .environmentObject(HabitStore())
    }
}
