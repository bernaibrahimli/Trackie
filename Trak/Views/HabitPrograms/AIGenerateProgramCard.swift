// AIGenerateProgramCard.swift
import SwiftUI

struct AIGenerateProgramCard: View {
    @Binding var generatedProgram: HabitProgram?
    @Binding var showPreview: Bool

    @State private var goalText: String = ""
    @State private var isGenerating: Bool = false
    @State private var errorMessage: String? = nil

    var body: some View {
        CardView(backgroundColor: Color.clear) {
            VStack(alignment: .leading, spacing: 14) {
                // Header
                HStack(spacing: 6) {
                    Image(systemName: "sparkles")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, AppStyles.Colors.primary],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Text("Build with AI")
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.purple, AppStyles.Colors.primary],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                }

                Text("Describe your goal and we'll create a personalized habit program for you.")
                    .font(AppStyles.Typography.caption)
                    .foregroundColor(AppStyles.Colors.secondaryText)

                // Input row
                HStack(spacing: 10) {
                    TextField("e.g. I want to eat healthier", text: $goalText)
                        .font(.system(size: 15, design: .rounded))
                        .submitLabel(.go)
                        .disabled(isGenerating)
                        .onSubmit {
                            Task { await generate() }
                        }

                    if isGenerating {
                        ProgressView()
                            .frame(width: 88, height: 34)
                    } else {
                        Button {
                            Task { await generate() }
                        } label: {
                            Text("Generate")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 8)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            goalText.trimmingCharacters(in: .whitespaces).isEmpty
                                                ? LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.3)],
                                                                 startPoint: .leading, endPoint: .trailing)
                                                : LinearGradient(colors: [.purple, AppStyles.Colors.primary],
                                                                 startPoint: .leading, endPoint: .trailing)
                                        )
                                )
                        }
                        .disabled(goalText.trimmingCharacters(in: .whitespaces).isEmpty)
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                if let error = errorMessage {
                    Text(error)
                        .font(AppStyles.Typography.caption)
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
            }
            .padding(.vertical, 6)
            .animation(AppStyles.Animations.spring, value: isGenerating)
            .animation(AppStyles.Animations.spring, value: errorMessage)
        }
        .background(
            LinearGradient(
                colors: [
                    Color.purple.opacity(0.12),
                    AppStyles.Colors.primary.opacity(0.08),
                    Color.purple.opacity(0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(AppStyles.Dimensions.cornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: AppStyles.Dimensions.cornerRadius)
                .stroke(
                    LinearGradient(
                        colors: [.purple.opacity(0.4), AppStyles.Colors.primary.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: .purple.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    @MainActor
    private func generate() async {
        let input = goalText.trimmingCharacters(in: .whitespaces)
        guard !input.isEmpty else { return }

        withAnimation(AppStyles.Animations.spring) {
            isGenerating = true
            errorMessage = nil
        }

        if let program = await AIManager.generateProgram(goal: input) {
            withAnimation(AppStyles.Animations.spring) {
                generatedProgram = program
                isGenerating = false
                showPreview = true
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } else {
            withAnimation(AppStyles.Animations.spring) {
                isGenerating = false
                errorMessage = "Couldn't generate a program. Please try again."
            }
        }
    }
}
