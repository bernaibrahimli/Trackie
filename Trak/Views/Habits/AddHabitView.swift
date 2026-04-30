// AddHabitView.swift
import SwiftUI

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitStore: HabitStore

    // MARK: - General State

    @State private var habitName = ""
    @State private var selectedTemplateIndex: Int? = nil
    @State private var selectedCustomTemplateIndex: Int? = nil
    @State private var animateTemplates = false
    @State private var isSubmitting = false
    @State private var showingAddTemplate = false

    // MARK: - Magic Add State

    @State private var magicInput: String = ""
    @State private var isGenerating: Bool = false
    @State private var magicDidPopulate: Bool = false

    // MARK: - How Often?

    @State private var frequencySelection: FrequencyChip = .everyDay
    /// 0 = Mon, 1 = Tue … 6 = Sun
    @State private var selectedWeekdays: Set<Int> = []
    @State private var intervalTarget: Int = 3
    @State private var intervalTotal: Int  = 7
    @State private var isRecurring: Bool   = false

    // MARK: - Daily Goal?

    @State private var goalSelection: GoalChip = .justOnce
    @State private var countTarget: Int = 3
    @State private var timerTarget: Int = 20

    // MARK: - Reminder

    @State private var reminderEnabled = false
    @State private var reminderTime = Date()

    // MARK: - Custom Templates

    @AppStorage("customTemplates") private var customTemplatesData: Data = Data()
    @State private var customTemplates: [CustomTemplate] = []
    private let maxCustomTemplates = 3

    // MARK: - Chip Enums

    private enum FrequencyChip { case everyDay, specificWeekdays, specificInterval }
    private enum GoalChip      { case justOnce, multipleTimes, timer }

    // MARK: - Internal Template Model

    private struct Template {
        let name: String
        let iconName: String
        let frequency: FrequencyChip
        let intervalTarget: Int
        let intervalTotal: Int
        let goal: GoalChip
        let goalTarget: Int
    }

    private let templates: [Template] = [
        Template(name: "Brush teeth",   iconName: "mouth",                       frequency: .everyDay,         intervalTarget: 1,  intervalTotal: 1,  goal: .multipleTimes, goalTarget: 2),
        Template(name: "Go for a run",  iconName: "figure.run",                  frequency: .specificInterval, intervalTarget: 5,  intervalTotal: 7,  goal: .timer,         goalTarget: 30),
        Template(name: "Drink water",   iconName: "drop.fill",                   frequency: .everyDay,         intervalTarget: 1,  intervalTotal: 1,  goal: .multipleTimes, goalTarget: 10),
        Template(name: "Read a book",   iconName: "book.fill",                   frequency: .specificInterval, intervalTarget: 5,  intervalTotal: 7,  goal: .timer,         goalTarget: 30),
        Template(name: "Meditate",      iconName: "figure.mind.and.body",        frequency: .everyDay,         intervalTarget: 1,  intervalTotal: 1,  goal: .timer,         goalTarget: 15),
        Template(name: "Exercise",      iconName: "figure.cooldown",             frequency: .specificInterval, intervalTarget: 4,  intervalTotal: 7,  goal: .timer,         goalTarget: 45),
        Template(name: "Eat healthy",   iconName: "leaf.fill",                   frequency: .specificInterval, intervalTarget: 25, intervalTotal: 30, goal: .multipleTimes, goalTarget: 3),
        Template(name: "Water plants",  iconName: "sprinkler.and.droplets.fill", frequency: .specificInterval, intervalTarget: 2,  intervalTotal: 7,  goal: .justOnce,      goalTarget: 1),
    ]

    // MARK: - Body

    var body: some View {
        NavigationView {
            Form {
                magicAddSection
                quickStartSection
                nameSection
                frequencySection
                goalSection
                reminderSection

                Section { createButton }.listRowBackground(Color.clear)
            }
            .navigationTitle("New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { presentationMode.wrappedValue.dismiss() }
                        .foregroundColor(AppStyles.Colors.primary)
                }
            }
        }
        .fullScreenCover(isPresented: $showingAddTemplate) {
            AddTemplateView(customTemplates: $customTemplates)
        }
        .accentColor(AppStyles.Colors.primary)
        .onAppear { loadCustomTemplates() }
        .onChange(of: customTemplates) { _ in saveCustomTemplates() }
    }

    // MARK: - Sections

    private var quickStartSection: some View {
        Section(header: Text("Quick Start").font(AppStyles.Typography.caption)) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(0..<templates.count, id: \.self) { templateButton(index: $0) }
                    ForEach(0..<customTemplates.count, id: \.self) { customTemplateButton(index: $0) }
                    addNewTemplateButton
                }
                .padding(.horizontal, AppStyles.Dimensions.standardPadding)
                .padding(.vertical, AppStyles.Dimensions.smallPadding)
            }
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: AppStyles.Dimensions.smallPadding, trailing: 0))
            .onAppear { withAnimation { animateTemplates = true } }
        }
    }

    private var nameSection: some View {
        Section {
            TextField("Habit name", text: $habitName)
                .font(AppStyles.Typography.body)
                .onChange(of: habitName) { newValue in
                    if newValue.count > 25 { habitName = String(newValue.prefix(25)) }
                }
        }
    }

    private var frequencySection: some View {
        Section(header: Text("How often?").font(AppStyles.Typography.caption)) {
            VStack(alignment: .leading, spacing: 14) {
                // Chip row
                HStack(spacing: 10) {
                    chipButton(icon: "arrow.clockwise",     label: "Every Day", isSelected: frequencySelection == .everyDay) {
                        frequencySelection = .everyDay
                    }
                    chipButton(icon: "calendar",            label: "Weekdays",  isSelected: frequencySelection == .specificWeekdays) {
                        frequencySelection = .specificWeekdays
                        if selectedWeekdays.isEmpty { selectedWeekdays = [0, 1, 2, 3, 4] }
                    }
                    chipButton(icon: "slider.horizontal.3", label: "Custom",    isSelected: frequencySelection == .specificInterval) {
                        frequencySelection = .specificInterval
                    }
                }

                // Conditional secondary UI
                if frequencySelection == .specificWeekdays {
                    weekdayRow
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                if frequencySelection == .specificInterval {
                    intervalStepperView
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(AppStyles.Animations.spring, value: frequencySelection)
            .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        }
    }

    private var goalSection: some View {
        Section(header: Text("Daily goal?").font(AppStyles.Typography.caption)) {
            VStack(alignment: .leading, spacing: 14) {
                // Chip row
                HStack(spacing: 10) {
                    chipButton(icon: "checkmark.circle", label: "Just Once", isSelected: goalSelection == .justOnce) {
                        goalSelection = .justOnce
                    }
                    chipButton(icon: "repeat",           label: "Multiple",  isSelected: goalSelection == .multipleTimes) {
                        goalSelection = .multipleTimes
                    }
                    chipButton(icon: "timer",            label: "Timer",     isSelected: goalSelection == .timer) {
                        goalSelection = .timer
                    }
                }

                if goalSelection == .multipleTimes {
                    stepperRow(label: "Times per day", value: $countTarget, range: 2...50, unit: "times")
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }

                if goalSelection == .timer {
                    stepperRow(label: "Duration", value: $timerTarget, range: 1...360, unit: "min")
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .animation(AppStyles.Animations.spring, value: goalSelection)
            .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        }
    }

    private var reminderSection: some View {
        Section(header: Text("Reminder").font(AppStyles.Typography.caption)) {
            Toggle("Remind Me", isOn: $reminderEnabled).tint(AppStyles.Colors.primary)
            if reminderEnabled {
                DatePicker("Time", selection: $reminderTime, displayedComponents: .hourAndMinute)
                    .datePickerStyle(.compact)
            }
        }
    }

    // MARK: - Magic Add Section

    private var magicAddSection: some View {
        Section {
            VStack(alignment: .leading, spacing: 14) {
                // Description
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
                    Text("Describe your habit — AI will fill in the details")
                        .font(.system(size: 12, design: .rounded))
                        .foregroundColor(AppStyles.Colors.secondaryText)
                }

                // Input row
                HStack(spacing: 10) {
                    TextField("What do you want to build?", text: $magicInput)
                        .font(.system(size: 15, design: .rounded))
                        .submitLabel(.go)
                        .disabled(isGenerating)
                        .onSubmit {
                            Task { await generateHabit() }
                        }

                    if isGenerating {
                        ProgressView()
                            .frame(width: 78, height: 34)
                    } else {
                        Button {
                            Task { await generateHabit() }
                        } label: {
                            Text("Generate")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                                .frame(width: 78, height: 34)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(
                                            magicInput.trimmingCharacters(in: .whitespaces).isEmpty
                                                ? LinearGradient(colors: [.gray.opacity(0.3), .gray.opacity(0.3)],
                                                                 startPoint: .leading, endPoint: .trailing)
                                                : LinearGradient(colors: [.purple, AppStyles.Colors.primary],
                                                                 startPoint: .leading, endPoint: .trailing)
                                        )
                                )
                        }
                        .disabled(magicInput.trimmingCharacters(in: .whitespaces).isEmpty)
                        .buttonStyle(PlainButtonStyle())
                    }
                }

                // Success confirmation
                if magicDidPopulate {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 13))
                            .foregroundColor(AppStyles.Colors.success)
                        Text("Habit filled in — review and tap Create")
                            .font(.system(size: 12, design: .rounded))
                            .foregroundColor(AppStyles.Colors.success)
                    }
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .padding(.vertical, 6)
            .animation(AppStyles.Animations.spring, value: magicDidPopulate)
            .animation(AppStyles.Animations.spring, value: isGenerating)
        } header: {
            HStack(spacing: 5) {
                Image(systemName: "sparkles")
                Text("Magic Add")
            }
            .font(.system(size: 13, weight: .semibold, design: .rounded))
            .textCase(nil)
            .foregroundStyle(
                LinearGradient(
                    colors: [.purple, AppStyles.Colors.primary],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
        }
    }

    // MARK: - Frequency Secondary UI

    private var weekdayRow: some View {
        let labels = ["M", "T", "W", "T", "F", "S", "S"]
        return VStack(alignment: .leading, spacing: 8) {
            Text("Select days")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(AppStyles.Colors.secondaryText)

            HStack(spacing: 8) {
                ForEach(0..<7) { i in
                    let isOn = selectedWeekdays.contains(i)
                    Button {
                        withAnimation(AppStyles.Animations.spring) {
                            if isOn { selectedWeekdays.remove(i) }
                            else    { selectedWeekdays.insert(i) }
                        }
                    } label: {
                        Text(labels[i])
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .frame(width: 36, height: 36)
                            .background(Circle().fill(isOn ? AppStyles.Colors.primary : AppStyles.Colors.secondaryBackground))
                            .foregroundColor(isOn ? .white : AppStyles.Colors.secondaryText)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }

            if !selectedWeekdays.isEmpty {
                Text("\(selectedWeekdays.count) day\(selectedWeekdays.count == 1 ? "" : "s") per week")
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(AppStyles.Colors.primary)
            }
        }
    }

    private var intervalStepperView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Set your schedule")
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(AppStyles.Colors.secondaryText)

            // Enforce intervalTarget ≤ intervalTotal
            stepperRow(label: "Target days", value: $intervalTarget, range: 1...intervalTotal, unit: "days")
                .onChange(of: intervalTarget) { newVal in
                    if intervalTotal < newVal { intervalTotal = newVal }
                }

            stepperRow(label: "In a period of", value: $intervalTotal, range: intervalTarget...31, unit: "days")

            let summary = intervalSummary
            if !summary.isEmpty {
                Text(summary)
                    .font(.system(size: 12, design: .rounded))
                    .foregroundColor(AppStyles.Colors.primary)
            }

            Divider()

            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Repeat this cycle")
                        .font(.system(size: 14, design: .rounded))
                        .foregroundColor(AppStyles.Colors.text)
                    Text(isRecurring
                         ? "Restarts every \(intervalTotal) days automatically"
                         : "Ends after \(intervalTotal) days")
                        .font(.system(size: 11, design: .rounded))
                        .foregroundColor(AppStyles.Colors.secondaryText)
                }
                Spacer()
                Toggle("", isOn: $isRecurring)
                    .tint(AppStyles.Colors.primary)
                    .labelsHidden()
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var intervalSummary: String {
        if intervalTarget == intervalTotal         { return "Every day" }
        if intervalTarget == 1, intervalTotal == 7 { return "Once a week" }
        if intervalTarget == 5, intervalTotal == 7 { return "Weekdays" }
        if intervalTarget == 1, intervalTotal == 30 { return "Once a month" }
        return "\(intervalTarget) out of every \(intervalTotal) days"
    }

    // MARK: - Reusable: Chip Button

    private func chipButton(icon: String, label: String, isSelected: Bool, action: @escaping () -> Void) -> some View {
        Button {
            withAnimation(AppStyles.Animations.spring) { action() }
        } label: {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: .medium))
                Text(label)
                    .font(.system(size: 11, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? AppStyles.Colors.primary.opacity(0.12) : AppStyles.Colors.secondaryBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? AppStyles.Colors.primary : Color.clear, lineWidth: 1.5)
            )
            .foregroundColor(isSelected ? AppStyles.Colors.primary : AppStyles.Colors.secondaryText)
        }
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Reusable: Stepper Row

    private func stepperRow(label: String, value: Binding<Int>, range: ClosedRange<Int>, unit: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(AppStyles.Colors.secondaryText)

            Spacer()

            HStack(spacing: 14) {
                Button {
                    if value.wrappedValue > range.lowerBound {
                        withAnimation(AppStyles.Animations.quick) { value.wrappedValue -= 1 }
                    }
                } label: {
                    Image(systemName: "minus.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(value.wrappedValue > range.lowerBound
                                         ? AppStyles.Colors.primary
                                         : AppStyles.Colors.secondaryText.opacity(0.3))
                }
                .disabled(value.wrappedValue <= range.lowerBound)
                .buttonStyle(PlainButtonStyle())

                Text("\(value.wrappedValue) \(unit)")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .frame(minWidth: 80)
                    .multilineTextAlignment(.center)

                Button {
                    if value.wrappedValue < range.upperBound {
                        withAnimation(AppStyles.Animations.quick) { value.wrappedValue += 1 }
                    }
                } label: {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 26))
                        .foregroundColor(value.wrappedValue < range.upperBound
                                         ? AppStyles.Colors.primary
                                         : AppStyles.Colors.secondaryText.opacity(0.3))
                }
                .disabled(value.wrappedValue >= range.upperBound)
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.vertical, 2)
    }

    // MARK: - Template Buttons

    private func templateButton(index: Int) -> some View {
        let template = templates[index]
        let isSelected = selectedTemplateIndex == index

        return Button {
            if selectedTemplateIndex == index { resetForm() }
            else { applyTemplate(template, at: index) }
        } label: {
            templateChipLabel(name: template.name, icon: template.iconName, isSelected: isSelected)
                .opacity(animateTemplates ? 1 : 0)
                .offset(y: animateTemplates ? 0 : 20)
                .animation(AppStyles.Animations.spring.delay(Double(index) * 0.05), value: animateTemplates)
        }
    }

    private func customTemplateButton(index: Int) -> some View {
        let template = customTemplates[index]
        let isSelected = selectedCustomTemplateIndex == index

        return Button {
            if selectedCustomTemplateIndex == index { resetForm() }
            else { applyCustomTemplate(template, at: index) }
        } label: {
            templateChipLabel(name: template.name, icon: template.iconName, isSelected: isSelected)
                .opacity(animateTemplates ? 1 : 0)
                .offset(y: animateTemplates ? 0 : 20)
                .animation(AppStyles.Animations.spring.delay(Double(templates.count + index) * 0.05), value: animateTemplates)
        }
        .contextMenu {
            Button(role: .destructive) { deleteCustomTemplate(at: index) } label: {
                Label("Delete Template", systemImage: "trash")
            }
        }
    }

    private var addNewTemplateButton: some View {
        Group {
            if customTemplates.count < maxCustomTemplates {
                Button { showingAddTemplate = true } label: {
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(AppStyles.Colors.primary, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                                .frame(width: 50, height: 50)
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .medium))
                                .foregroundColor(AppStyles.Colors.primary)
                        }
                        Text("Create Template")
                            .font(Font.system(.caption, design: .rounded).weight(.medium))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .foregroundColor(AppStyles.Colors.primary)
                    }
                    .padding(.vertical, AppStyles.Dimensions.smallPadding + 2)
                    .padding(.horizontal, AppStyles.Dimensions.smallPadding)
                    .frame(width: 95, height: 100)
                    .opacity(animateTemplates ? 1 : 0)
                    .offset(y: animateTemplates ? 0 : 20)
                    .animation(
                        AppStyles.Animations.spring.delay(Double(templates.count + customTemplates.count) * 0.05),
                        value: animateTemplates
                    )
                }
            }
        }
    }

    /// Shared visual for both built-in and custom template chips.
    private func templateChipLabel(name: String, icon: String, isSelected: Bool) -> some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .fill(isSelected
                          ? LinearGradient(gradient: Gradient(colors: [AppStyles.Colors.gradient1, AppStyles.Colors.gradient2]),
                                           startPoint: .topLeading, endPoint: .bottomTrailing)
                          : LinearGradient(gradient: Gradient(colors: [AppStyles.Colors.secondaryBackground, AppStyles.Colors.secondaryBackground]),
                                           startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 50, height: 50)
                    .shadow(color: isSelected ? AppStyles.Colors.primary.opacity(0.3) : Color.black.opacity(0.05),
                            radius: 6, x: 0, y: 3)
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(isSelected ? AppStyles.Colors.lightText : AppStyles.Colors.primary)
            }
            Text(name)
                .font(Font.system(.caption, design: .rounded).weight(.medium))
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(isSelected ? AppStyles.Colors.primary : AppStyles.Colors.text)
        }
        .padding(.vertical, AppStyles.Dimensions.smallPadding + 2)
        .padding(.horizontal, AppStyles.Dimensions.smallPadding)
        .frame(width: 95, height: 100)
    }

    // MARK: - Magic Add Logic

    @MainActor
    private func generateHabit() async {
        let input = magicInput.trimmingCharacters(in: .whitespaces)
        guard !input.isEmpty else { return }

        withAnimation(AppStyles.Animations.spring) {
            isGenerating = true
            magicDidPopulate = false
        }

        if let habit = await AIManager.parseHabitPrompt(text: input) {
            withAnimation(AppStyles.Animations.spring) {
                populateFromHabit(habit)
                isGenerating = false
                magicDidPopulate = true
            }
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        } else {
            withAnimation(AppStyles.Animations.spring) { isGenerating = false }
        }
    }

    /// Maps a `Habit` returned by the AI back onto the form's state variables.
    private func populateFromHabit(_ habit: Habit) {
        habitName = habit.name
        selectedTemplateIndex       = nil
        selectedCustomTemplateIndex = nil

        // Frequency
        switch habit.frequency {
        case .daily, .morning, .evening:
            frequencySelection = .everyDay

        case .custom:
            if let freq = habit.customFrequency {
                if freq.targetDays == freq.totalDays {
                    frequencySelection = .everyDay
                } else {
                    frequencySelection = .specificInterval
                    intervalTarget     = freq.targetDays
                    intervalTotal      = freq.totalDays
                    isRecurring        = freq.isRecurring
                }
            } else {
                frequencySelection = .everyDay
            }
        }

        // Daily goal
        if let goal = habit.dailyGoal {
            switch goal.type {
            case .count:
                goalSelection = .multipleTimes
                countTarget   = goal.target
            case .duration:
                goalSelection = .timer
                timerTarget   = goal.target
            default:
                goalSelection = .justOnce
            }
        } else {
            goalSelection = .justOnce
        }

        // Reminder
        reminderEnabled = habit.reminderEnabled
        if let time = habit.reminderTime {
            reminderTime = time
        }
    }

    // MARK: - Create Button

    private var createButton: some View {
        Button {
            if !habitName.isEmpty { createHabit() }
        } label: {
            HStack {
                Spacer()
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppStyles.Colors.lightText))
                        .scaleEffect(1.2)
                        .padding(.trailing, 8)
                }
                Text(isSubmitting ? "Creating..." : "Create Habit")
                    .font(AppStyles.Typography.button)
                    .foregroundColor(AppStyles.Colors.lightText)
                Spacer()
            }
            .frame(height: AppStyles.Dimensions.buttonHeight)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [AppStyles.Colors.gradient1, AppStyles.Colors.gradient2]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .opacity(habitName.isEmpty ? 0.5 : 1.0)
            )
            .cornerRadius(AppStyles.Dimensions.cornerRadius)
            .shadow(color: AppStyles.Colors.primary.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .disabled(habitName.isEmpty || isSubmitting)
    }

    // MARK: - Apply Template / Reset

    private func applyTemplate(_ template: Template, at index: Int) {
        selectedTemplateIndex       = index
        selectedCustomTemplateIndex = nil
        habitName          = template.name
        frequencySelection = template.frequency
        intervalTarget     = template.intervalTarget
        intervalTotal      = template.intervalTotal
        goalSelection      = template.goal
        countTarget        = template.goalTarget
        timerTarget        = template.goalTarget
    }

    private func applyCustomTemplate(_ template: CustomTemplate, at index: Int) {
        selectedCustomTemplateIndex = index
        selectedTemplateIndex       = nil
        habitName = template.name

        // Frequency
        switch template.frequency {
        case .daily, .morning, .evening:
            frequencySelection = .everyDay
        case .custom:
            if let freq = template.customFrequency {
                if freq.targetDays == freq.totalDays {
                    frequencySelection = .everyDay
                } else {
                    frequencySelection = .specificInterval
                    intervalTarget     = freq.targetDays
                    intervalTotal      = freq.totalDays
                }
            } else {
                frequencySelection = .everyDay
            }
        }

        // Goal — AddTemplateView.DailyRepeatType → GoalChip
        switch template.dailyGoalType {
        case .oneTime, .asPercent:
            goalSelection = .justOnce
        case .asCount:
            goalSelection = .multipleTimes
            countTarget   = template.dailyGoalTarget
        case .asTime:
            goalSelection = .timer
            timerTarget   = template.dailyGoalTarget
        }
    }

    private func resetForm() {
        selectedTemplateIndex       = nil
        selectedCustomTemplateIndex = nil
        habitName          = ""
        frequencySelection = .everyDay
        selectedWeekdays   = []
        intervalTarget     = 3
        intervalTotal      = 7
        isRecurring        = false
        goalSelection      = .justOnce
        countTarget        = 3
        timerTarget        = 20
        magicDidPopulate   = false
    }

    // MARK: - Create Habit

    private func createHabit() {
        withAnimation(AppStyles.Animations.spring) { isSubmitting = true }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            createNewHabit()
            presentationMode.wrappedValue.dismiss()
        }
    }

    private func createNewHabit() {
        // Resolve frequency
        let finalFrequency: Habit.FrequencyType
        var customFrequency: Habit.CustomFrequency? = nil

        switch frequencySelection {
        case .everyDay:
            finalFrequency = .daily

        case .specificWeekdays:
            finalFrequency  = .custom
            let count       = max(1, selectedWeekdays.count)
            customFrequency = Habit.CustomFrequency(targetDays: count, totalDays: 7, startDate: Date(), isRecurring: true)

        case .specificInterval:
            finalFrequency  = .custom
            customFrequency = Habit.CustomFrequency(
                targetDays: intervalTarget,
                totalDays:  intervalTotal,
                startDate:  Date(),
                isRecurring: isRecurring
            )
        }

        // Resolve daily goal
        let dailyGoal: Habit.DailyGoal?

        switch goalSelection {
        case .justOnce:
            dailyGoal = nil

        case .multipleTimes:
            dailyGoal = Habit.DailyGoal(type: .count, target: countTarget, increment: 1, unit: "times")

        case .timer:
            dailyGoal = Habit.DailyGoal(type: .duration, target: timerTarget, increment: 1, unit: "min")
        }

        let newHabit = Habit(
            name:             habitName.trimmingCharacters(in: .whitespacesAndNewlines),
            frequency:        finalFrequency,
            customFrequency:  customFrequency,
            dailyGoal:        dailyGoal,
            reminderEnabled:  reminderEnabled,
            reminderTime:     reminderEnabled ? reminderTime : nil
        )

        habitStore.addHabit(newHabit)
    }

    // MARK: - Custom Template Persistence

    private func loadCustomTemplates() {
        if let decoded = try? JSONDecoder().decode([CustomTemplate].self, from: customTemplatesData) {
            customTemplates = decoded
        }
    }

    private func saveCustomTemplates() {
        if let encoded = try? JSONEncoder().encode(customTemplates) {
            customTemplatesData = encoded
        }
    }

    private func deleteCustomTemplate(at index: Int) {
        withAnimation {
            customTemplates.remove(at: index)
            if selectedCustomTemplateIndex == index {
                resetForm()
            } else if let sel = selectedCustomTemplateIndex, sel > index {
                selectedCustomTemplateIndex = sel - 1
            }
        }
    }
}
