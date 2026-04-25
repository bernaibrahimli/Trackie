// HabitListView.swift
import SwiftUI

struct HabitListView: View {
    @EnvironmentObject var habitStore: HabitStore // Access to the habit store
    @State private var selectedHabit: Habit? // Currently selected habit for actions like camera verification
    @State private var showingCamera = false // Controls presentation of the CameraView sheet
    @State private var showingConfirmation = false // Controls presentation of the confirmation dialog

    var body: some View {
        NavigationView {
            if habitStore.habits.isEmpty {
                // Empty state view if no habits exist.
                VStack {
                    Spacer()
                    Image(systemName: "list.bullet.clipboard") // Relevant icon
                        .font(.system(size: 60))
                        .foregroundColor(AppStyles.Colors.secondaryText.opacity(0.5))
                    Text("No Habits Yet!")
                        .font(AppStyles.Typography.title)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                    Text("Tap the '+' button to add your first habit.")
                        .font(AppStyles.Typography.body)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Spacer()
                    Spacer() // Add more spacer to push content up a bit
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(AppStyles.Colors.secondaryBackground.edgesIgnoringSafeArea(.all))
                .navigationTitle("Today's Habits")
            } else {
                // List of habits.
                List {
                    // Section header (optional, could be dynamic based on date)
                    Section(header: Text("Your Habits").font(AppStyles.Typography.caption).padding(.leading, AppStyles.Dimensions.standardPadding)) {
                        ForEach(habitStore.habits) { habit in
                            Button(action: {
                                handleHabitTap(habit)
                            }) {
                                HabitRowView(habit: habit)
                                    // Apply a clear background to each row to let HabitRowView's CardView shine.
                                    .listRowBackground(Color.clear)
                            }
                            .buttonStyle(PlainButtonStyle()) // Use PlainButtonStyle to keep custom appearance
                        }
                        .onDelete(perform: habitStore.deleteHabit) // Enable swipe-to-delete for habits.
                    }
                }
                .listStyle(PlainListStyle()) // Use PlainListStyle for more control over appearance.
                .background(AppStyles.Colors.secondaryBackground.edgesIgnoringSafeArea(.all)) // Background for the list area
                .navigationTitle("Today's Habits") // Title for the navigation bar.
                .alert(isPresented: $showingConfirmation) {
                    Alert(
                        title: Text("Complete Habit"),
                        message: Text("Have you completed \"\(selectedHabit?.name ?? "")\" for today?"),
                        primaryButton: .default(Text("Yes"), action: {
                            // Complete the habit when confirmed
                            if let habit = selectedHabit {
                                // Complete the habit
                                habitStore.completeHabit(habitId: habit.id)
                            }
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
        .accentColor(AppStyles.Colors.primary)
    }
    
    private func handleHabitTap(_ habit: Habit) {
        selectedHabit = habit
    }
}


#Preview {
    let habitStore = HabitStore()
    return HabitListView()
        .environmentObject(habitStore)
}
