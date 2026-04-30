// ProgramsTabView.swift
import SwiftUI

struct ProgramsTabView: View {
    @EnvironmentObject var habitStore: HabitStore
    @StateObject private var programStore = ProgramDataStore.shared

    @State private var selectedProgram: HabitProgram?
    @State private var contentVisible = false
    @State private var showDisclaimer = false
    @State private var disclaimerAccepted = false

    @State private var generatedProgram: HabitProgram?

    var body: some View {
        NavigationView {
            ZStack {
                AppStyles.Colors.background.edgesIgnoringSafeArea(.all)

                ScrollView {
                    VStack(spacing: 20) {
                        // AI generate card
                        AIGenerateProgramCard(generatedProgram: $generatedProgram)
                        .padding(.horizontal, 16)
                        .opacity(contentVisible ? 1 : 0)
                        .offset(y: contentVisible ? 0 : 20)
                        .animation(AppStyles.Animations.spring.delay(0.1), value: contentVisible)

                        // Curated programs header
                        HStack {
                            Text("Curated Programs")
                                .font(AppStyles.Typography.headline)
                                .foregroundColor(AppStyles.Colors.text)
                            Spacer()
                        }
                        .padding(.horizontal, 16)
                        .opacity(contentVisible ? 1 : 0)
                        .animation(AppStyles.Animations.spring.delay(0.2), value: contentVisible)

                        LazyVStack(spacing: 16) {
                            ForEach(Array(programStore.programs.enumerated()), id: \.element.id) { index, program in
                                ProgramCard(program: program) {
                                    selectedProgram = program
                                }
                                .opacity(contentVisible ? 1 : 0)
                                .offset(y: contentVisible ? 0 : 30)
                                .scaleEffect(contentVisible ? 1.0 : 0.9)
                                .animation(
                                    AppStyles.Animations.spring.delay(Double(index) * 0.08 + 0.25),
                                    value: contentVisible
                                )
                            }
                        }
                        .padding(.horizontal, 16)

                        Spacer(minLength: 30)
                    }
                    .padding(.top, 8)
                }
                .scrollIndicators(.hidden)
            }
            .navigationTitle("Programs")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                let hasAccepted = UserDefaults.standard.bool(forKey: "quickProgramsDisclaimerAccepted")
                if !hasAccepted {
                    showDisclaimer = true
                } else {
                    withAnimation { contentVisible = true }
                }
            }
            .onChange(of: disclaimerAccepted) { accepted in
                if accepted {
                    withAnimation { contentVisible = true }
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
        .fullScreenCover(item: $generatedProgram) { program in
            AIProgramPreviewSheet(
                program: program,
                onRegenerate: { generatedProgram = nil }
            )
            .environmentObject(habitStore)
        }
    }
}
