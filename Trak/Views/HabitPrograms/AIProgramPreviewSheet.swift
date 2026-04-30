// AIProgramPreviewSheet.swift
import SwiftUI

struct AIProgramPreviewSheet: View {
    let program: HabitProgram
    let onRegenerate: () -> Void
    @Binding var isPresented: Bool

    @EnvironmentObject var habitStore: HabitStore
    @State private var contentVisible = false
    @State private var showHabitLimitAlert = false
    @State private var showApplyConfirmation = false

    private var currentHabitCount: Int { habitStore.habits.count }
    private var wouldExceedLimit: Bool { currentHabitCount + program.habits.count > 10 }
    private var habitsToRemove: Int { max(0, (currentHabitCount + program.habits.count) - 10) }

    var body: some View {
        ZStack {
            AppStyles.Colors.background.edgesIgnoringSafeArea(.all)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
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
                                // AI-generated badge
                                HStack(spacing: 4) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 10, weight: .semibold))
                                    Text("AI Generated")
                                        .font(.system(size: 11, weight: .semibold, design: .rounded))
                                }
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.purple, AppStyles.Colors.primary],
                                        startPoint: .leading, endPoint: .trailing
                                    )
                                )
                                .padding(.horizontal, 8)
                                .padding(.vertical, 3)
                                .background(
                                    Capsule()
                                        .fill(Color.purple.opacity(0.12))
                                )

                                Text(program.name)
                                    .font(Font.system(.title2, design: .rounded).weight(.bold))
                                    .foregroundColor(AppStyles.Colors.text)
                                    .lineLimit(3)
                                    .multilineTextAlignment(.leading)

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
                                Button {
                                    isPresented = false
                                } label: {
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

                    // Habits list
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

                    Spacer().frame(height: 140)
                }
            }
            .scrollIndicators(.hidden)

            // Floating buttons
            VStack {
                Spacer()

                VStack(spacing: 10) {
                    // Regenerate button
                    Button {
                        isPresented = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            onRegenerate()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: "arrow.clockwise")
                                .font(.system(size: 15, weight: .medium))
                            Text("Regenerate")
                                .font(.system(size: 15, weight: .semibold, design: .rounded))
                        }
                        .foregroundColor(AppStyles.Colors.secondaryText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(AppStyles.Colors.secondaryBackground.opacity(0.8))
                        )
                    }

                    // Start This Journey button
                    Button {
                        if wouldExceedLimit {
                            showHabitLimitAlert = true
                        } else {
                            showApplyConfirmation = true
                        }
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20, weight: .medium))
                            Text("Start This Journey")
                                .font(AppStyles.Typography.button)
                        }
                        .foregroundColor(AppStyles.Colors.lightText)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [program.color, program.color.opacity(0.8)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(25)
                        .shadow(color: program.color.opacity(0.4), radius: 8, x: 0, y: 4)
                    }
                }
                .scaleEffect(contentVisible ? 1.0 : 0.0)
                .animation(AppStyles.Animations.bounce.delay(0.8), value: contentVisible)
                .padding(.bottom, 40)
                .padding(.horizontal, 20)
            }
        }
        .onAppear {
            withAnimation { contentVisible = true }
        }
        .alert("Habit Limit Exceeded", isPresented: $showHabitLimitAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("You currently have \(currentHabitCount) habits. This program will add \(program.habits.count) habits.\n\nYou can have a maximum of 10 habits. Please delete \(habitsToRemove) habit(s) first.")
        }
        .sheet(isPresented: $showApplyConfirmation) {
            ApplyProgramSheet(
                program: program,
                isPresented: $showApplyConfirmation,
                onApply: applyProgram
            )
            .presentationDetents([.medium])
            .presentationDragIndicator(.visible)
        }
    }

    private func applyProgram() {
        for programHabit in program.habits {
            habitStore.addHabit(programHabit.toHabit())
        }
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}
