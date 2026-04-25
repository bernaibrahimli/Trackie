// AddHabitView.swift - Updated with Custom Template Support
import SwiftUI

struct AddHabitView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var habitStore: HabitStore
    
    @State private var habitName = ""
    @State private var frequency: Habit.FrequencyType = .daily
    @State private var selectedTemplateIndex: Int? = nil
    @State private var selectedCustomTemplateIndex: Int? = nil
    
    @State private var showCustomForm = false
    @State private var customTargetDays = 30
    @State private var customTotalDays = 30
    @State private var dailyGoalType: DailyRepeatType = .oneTime
    @State private var dailyGoalTarget = 1
    @State private var dailyGoalIncrement = 1
    
    @State private var animateTemplates = false
    @State private var animateForm = false
    @State private var buttonScale = 1.0
    @State private var isSubmitting = false
    @State private var showingAddTemplate = false
    
    @State private var isCustomInterval = false
    
    @State private var reminderEnabled = false
    @State private var reminderTime = Date()
    
    
    // Custom Templates Storage
    @AppStorage("customTemplates") private var customTemplatesData: Data = Data()
    @State private var customTemplates: [CustomTemplate] = []
    
    
    private let maxCustomTemplates = 3
    private let maxHabits = 10

    // Enhanced Template Structure
    struct Template {
        let name: String
        let iconName: String
        let frequency: Habit.FrequencyType
        let customFrequency: (targetDays: Int, totalDays: Int)?
        let dailyGoalType: DailyRepeatType
        let dailyGoalTarget: Int
        let dailyGoalIncrement: Int
      
    }
    
    enum DailyRepeatType: String, CaseIterable {
        case oneTime = "one time"
        case asCount = "as a count"
        case asTime = "as a time"
        case asPercent = "as a percent"
    }
    
    private let templates = [
        Template(
            name: "Brush teeth",
            iconName: "mouth",
            frequency: .custom,
            customFrequency: (targetDays: 30, totalDays: 30),
            dailyGoalType: .asCount,
            dailyGoalTarget: 2,
            dailyGoalIncrement: 1,
            
        ),
        Template(
            name: "Go for a run",
            iconName: "figure.run",
            frequency: .custom,
            customFrequency: (targetDays: 5, totalDays: 7),
            dailyGoalType: .asTime,
            dailyGoalTarget: 30,
            dailyGoalIncrement: 1,
            
        ),
        Template(
            name: "Drink water",
            iconName: "drop.fill",
            frequency: .custom,
            customFrequency: (targetDays: 30, totalDays: 30),
            dailyGoalType: .asCount,
            dailyGoalTarget: 200,
            dailyGoalIncrement: 20,
           
        ),
        Template(
            name: "Read a book",
            iconName: "book.fill",
            frequency: .custom,
            customFrequency: (targetDays: 5, totalDays: 7),
            dailyGoalType: .asTime,
            dailyGoalTarget: 30,
            dailyGoalIncrement: 1,
          
        ),
        Template(
            name: "Meditate",
            iconName: "figure.mind.and.body",
            frequency: .morning,
            customFrequency: nil,
            dailyGoalType: .asTime,
            dailyGoalTarget: 15,
            dailyGoalIncrement: 1,
        
        ),
        Template(
            name: "Exercise",
            iconName: "figure.cooldown",
            frequency: .custom,
            customFrequency: (targetDays: 4, totalDays: 7),
            dailyGoalType: .asTime,
            dailyGoalTarget: 45,
            dailyGoalIncrement: 1,
          
        ),
        Template(
            name: "Eat healthy",
            iconName: "leaf.fill",
            frequency: .custom,
            customFrequency: (targetDays: 25, totalDays: 30),
            dailyGoalType: .asCount,
            dailyGoalTarget: 3,
            dailyGoalIncrement: 1,
            
        ),
        Template(
            name: "Water plants",
            iconName: "sprinkler.and.droplets.fill",
            frequency: .custom,
            customFrequency: (targetDays: 2, totalDays: 7),
            dailyGoalType: .oneTime,
            dailyGoalTarget: 1,
            dailyGoalIncrement: 1,
       
        )
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Quick Start").font(AppStyles.Typography.caption)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(0..<templates.count, id: \.self) { index in
                                templateButton(index: index)
                            }
                            
                            ForEach(0..<customTemplates.count, id: \.self) { index in
                                customTemplateButton(index: index)
                            }
                            
                            addNewTemplateButton
                        }
                        .padding(.horizontal, AppStyles.Dimensions.standardPadding)
                        .padding(.vertical, AppStyles.Dimensions.smallPadding)
                    }
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: AppStyles.Dimensions.smallPadding, trailing: 0))
                    .onAppear {
                        withAnimation {
                            animateTemplates = true
                        }
                    }
                }
                
                Section(header: Text("Your Custom Habit").font(AppStyles.Typography.caption)) {
                    TextField("Habit name", text: $habitName)
                        .font(AppStyles.Typography.body)
                        .onChange(of: habitName) { newValue in
                            if newValue.count > 25 {
                                habitName = String(newValue.prefix(25))
                            }
                        }
                        .opacity(animateForm ? 1 : 0)
                        .offset(y: animateForm ? 0 : 10)
                        .animation(AppStyles.Animations.spring.delay(0.1), value: animateForm)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Frequency")
                            .font(AppStyles.Typography.caption)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                        
                        Picker("Frequency", selection: $frequency) {
                            Text("Mornings").tag(Habit.FrequencyType.morning)
                            Text("Evenings").tag(Habit.FrequencyType.evening)
                            Text("Daily").tag(Habit.FrequencyType.daily)
                            Text("Custom").tag(Habit.FrequencyType.custom)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .onChange(of: frequency) { newValue in
                            withAnimation {
                                showCustomForm = (newValue == .custom)
                            }
                        }
                        
                        if frequency != .custom {
                            Text(frequencyDescription)
                                .font(AppStyles.Typography.caption)
                                .foregroundColor(AppStyles.Colors.secondaryText)
                                .padding(.top, 4)
                        }
                    }
                    .opacity(animateForm ? 1 : 0)
                    .offset(y: animateForm ? 0 : 10)
                    .animation(AppStyles.Animations.spring.delay(0.2), value: animateForm)
                    
                    if showCustomForm {
                        customFormView
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        withAnimation {
                            animateForm = true
                        }
                    }
                }
                
                // Reminder Section
                Section(header:Text("Reminder").font(AppStyles.Typography.caption)) {
                    Toggle("Remind Me", isOn: $reminderEnabled)
                        .tint(AppStyles.Colors.primary)
                    
                    if reminderEnabled {
                        DatePicker(
                            "Reminder Time",
                            selection: $reminderTime,
                            displayedComponents: .hourAndMinute
                        )
                        .datePickerStyle(.compact)
                    }
                }
                
                Section {
                    createButton
                        .opacity(animateForm ? 1 : 0)
                        .animation(AppStyles.Animations.spring.delay(0.5), value: animateForm)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Add New Habit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    cancelButton
                }
            }
            
        }
        .fullScreenCover(isPresented: $showingAddTemplate) {
            AddTemplateView(customTemplates: $customTemplates)
        }
        .accentColor(AppStyles.Colors.primary)
        .onAppear {
            loadCustomTemplates()
        }
        .onChange(of: customTemplates) { _ in
            saveCustomTemplates()
        }
    }
    
    
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
    
    private var addNewTemplateButton: some View {
        Group {
            if customTemplates.count < maxCustomTemplates {
                Button(action: {
                    showingAddTemplate = true
                }) {
                    VStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .stroke(AppStyles.Colors.primary, style: StrokeStyle(lineWidth: 2, dash: [8, 4]))
                                .frame(width: 50, height: 50)
                                .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                            
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
                    .animation(AppStyles.Animations.spring.delay(Double(templates.count + customTemplates.count) * 0.05), value: animateTemplates)
                }
            }
        }
        
    }
    
    private func customTemplateButton(index: Int) -> some View {
        let template = customTemplates[index]
        let isSelected = selectedCustomTemplateIndex == index
        
        return Button(action: {
            if selectedCustomTemplateIndex == index {
                // Reset UI when tapping selected template
                resetForm()
            } else {
                // Apply custom template
                applyCustomTemplate(template, at: index)
            }
            
            withAnimation(AppStyles.Animations.spring) {
                buttonScale = 1.1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                buttonScale = 1.0
            }
        }) {
            VStack(spacing: 10) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    AppStyles.Colors.gradient1,
                                    AppStyles.Colors.gradient2
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 50, height: 50)
                            .shadow(color: AppStyles.Colors.primary.opacity(0.3), radius: 6, x: 0, y: 3)
                    } else {
                        Circle()
                            .fill(AppStyles.Colors.secondaryBackground)
                            .frame(width: 50, height: 50)
                            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                    }
                    
                    Image(systemName: template.iconName)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(isSelected ? AppStyles.Colors.lightText : AppStyles.Colors.primary)
                }
                
                Text(template.name)
                    .font(Font.system(.caption, design: .rounded).weight(.medium))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(isSelected ? AppStyles.Colors.primary : AppStyles.Colors.text)
            }
            .padding(.vertical, AppStyles.Dimensions.smallPadding + 2)
            .padding(.horizontal, AppStyles.Dimensions.smallPadding)
            .frame(width: 95, height: 100)
            .scaleEffect(isSelected ? buttonScale : 1.0)
            .opacity(animateTemplates ? 1 : 0)
            .offset(y: animateTemplates ? 0 : 20)
            .animation(AppStyles.Animations.spring.delay(Double(templates.count + index) * 0.05), value: animateTemplates)
        }
        .contextMenu {
            Button(role: .destructive) {
                deleteCustomTemplate(at: index)
            } label: {
                Label("Delete Template", systemImage: "trash")
            }
        }
    }
    
    private func applyCustomTemplate(_ template: CustomTemplate, at index: Int) {
        selectedCustomTemplateIndex = index
        selectedTemplateIndex = nil
        
        habitName = template.name
        frequency = template.frequency
        
        // Set custom frequency if needed
        if let customFreq = template.customFrequency {
            customTargetDays = customFreq.targetDays
            customTotalDays = customFreq.totalDays
            showCustomForm = true
        } else {
            showCustomForm = false
        }
        
        // Convert custom template goal type to our goal type
        switch template.dailyGoalType {
        case .oneTime:
            dailyGoalType = .oneTime
        case .asCount:
            dailyGoalType = .asCount
        case .asTime:
            dailyGoalType = .asTime
        case .asPercent:
            dailyGoalType = .asPercent
        }
        
        dailyGoalTarget = template.dailyGoalTarget
        dailyGoalIncrement = template.dailyGoalIncrement
        
       
    }
    
    private func deleteCustomTemplate(at index: Int) {
        withAnimation {
            customTemplates.remove(at: index)
            
            // Reset selection if deleted template was selected
            if selectedCustomTemplateIndex == index {
                resetForm()
            } else if let selectedIndex = selectedCustomTemplateIndex, selectedIndex > index {
                selectedCustomTemplateIndex = selectedIndex - 1
            }
        }
    }
    
    private var frequencyDescription: String {
        switch frequency {
        case .morning:
            return "Complete between 6:00 AM - 12:00 PM"
        case .evening:
            return "Complete between 6:00 PM - 12:00 AM"
        case .daily:
            return "During the day, complete at any time you want"
        default:
            return ""
        }
    }
    
    private var customFormView: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Goal Type")
                    .font(AppStyles.Typography.caption)
                    .foregroundColor(AppStyles.Colors.secondaryText)
                
                Picker("Daily Repeat", selection: $dailyGoalType) {
                    Text("one time").tag(DailyRepeatType.oneTime)
                    Text("as a count").tag(DailyRepeatType.asCount)
                    Text("as a time").tag(DailyRepeatType.asTime)
                    Text("as a percent").tag(DailyRepeatType.asPercent)
                }
                .pickerStyle(MenuPickerStyle())
                
                if dailyGoalType != .oneTime {
                    goalTypeInputView
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("Target Frequency")
                    .font(AppStyles.Typography.caption)
                    .foregroundColor(AppStyles.Colors.secondaryText)
                
                Picker("Target Day by Range", selection: $isCustomInterval) {
                    Text("for one day").tag(false)
                    Text("special interval").tag(true)
                }
                .pickerStyle(MenuPickerStyle())
                
                // Custom interval seçilirse mevcut picker'ları göster
                if isCustomInterval {
                    HStack {
                        Picker("Target Days", selection: $customTargetDays) {
                            ForEach(1...31, id: \.self) { day in
                                Text("\(day)").tag(day)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 80)
                        .clipped()
                        .onChange(of: customTargetDays) { newValue in
                            if customTotalDays < newValue {
                                customTotalDays = newValue
                            }
                        }
                        
                        Text("out of")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                        
                        Picker("Total Days", selection: $customTotalDays) {
                            ForEach(customTargetDays...31, id: \.self) { day in
                                Text("\(day)").tag(day)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 80)
                        .clipped()
                        
                        Text("days")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                    }
                    
                    // Açıklama metinleri
                    if customTotalDays == customTargetDays {
                        Text("Daily Habit")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                    } else if customTargetDays == 1 && customTotalDays == 7{
                        Text("Weekly Habit")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                    } else if customTargetDays == 1 && (customTotalDays == 30 || customTotalDays == 31){
                        Text("Monthly Habit")
                            .font(AppStyles.Typography.body)
                            .foregroundColor(AppStyles.Colors.secondaryText)
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .opacity(showCustomForm ? 1 : 0)
        .scaleEffect(showCustomForm ? 1 : 0.95)
        .animation(AppStyles.Animations.spring, value: showCustomForm)
    }
    
    @ViewBuilder
    private var goalTypeInputView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Goal Details")
                .font(AppStyles.Typography.caption)
                .foregroundColor(AppStyles.Colors.secondaryText)
            
            HStack(spacing: 8) {
                switch dailyGoalType {
                case .asCount:
                    VStack(alignment: .center, spacing: 0) {
                        Picker("Target", selection: $dailyGoalTarget) {
                            ForEach(1...250, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 60, height: 80)
                        .clipped()
                        .onChange(of: dailyGoalTarget) { newValue in
                            if dailyGoalIncrement > dailyGoalTarget {
                                dailyGoalIncrement = min(dailyGoalTarget, dailyGoalIncrement)
                            }
                        }
                        .onAppear {
                            if dailyGoalTarget == 1 && dailyGoalIncrement == 1 {
                                dailyGoalTarget = 10
                                dailyGoalIncrement = 1
                            }
                        }
                    }
                    
                    Text(selectedTemplateIndex == 2 ? "cl" : "times")
                        .font(AppStyles.Typography.body)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                    
                    Text("each tick =")
                        .font(AppStyles.Typography.caption)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                    
                    VStack(alignment: .center, spacing: 0) {
                        Picker("Increment", selection: $dailyGoalIncrement) {
                            ForEach(1...min(dailyGoalTarget, 360), id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 60, height: 80)
                        .clipped()
                    }
                    
                case .asTime:
                    VStack(alignment: .center, spacing: 0) {
                        Picker("Target", selection: $dailyGoalTarget) {
                            ForEach(1...360, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 80, height: 80) // Daha küçük boyut
                        .clipped()
                        .onAppear {
                            if dailyGoalTarget == 1 {
                                dailyGoalTarget = 30
                            }
                        }
                    }
                    
                    Text("minutes")
                        .font(AppStyles.Typography.body)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                    
                case .asPercent:
                    Text("100%")
                        .font(AppStyles.Typography.body)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                    
                    Text("each tick =")
                        .font(AppStyles.Typography.caption)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                    
                    VStack(alignment: .center, spacing: 0) {
                        Picker("Increment", selection: $dailyGoalIncrement) {
                            ForEach(1...99, id: \.self) { value in
                                Text("\(value)").tag(value)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 60, height: 80)
                        .clipped()
                    }
                    
                case .oneTime:
                    EmptyView()
                }
            }
        }
        .padding(.vertical)
    }
    
    private func templateButton(index: Int) -> some View {
        let template = templates[index]
        let isSelected = selectedTemplateIndex == index
        
        return Button(action: {
            if selectedTemplateIndex == index {
                resetForm()
            } else {

                applyTemplate(template, at: index)
            }
            
            withAnimation(AppStyles.Animations.spring) {
                buttonScale = 1.1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                buttonScale = 1.0
            }
        }) {
            VStack(spacing: 10) {
                ZStack {
                    if isSelected {
                        Circle()
                            .fill(LinearGradient(
                                gradient: Gradient(colors: [
                                    AppStyles.Colors.gradient1,
                                    AppStyles.Colors.gradient2
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(width: 50, height: 50)
                            .shadow(color: AppStyles.Colors.primary.opacity(0.3), radius: 6, x: 0, y: 3)
                    } else {
                        Circle()
                            .fill(AppStyles.Colors.secondaryBackground)
                            .frame(width: 50, height: 50)
                            .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
                    }
                    
                    Image(systemName: template.iconName)
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(isSelected ? AppStyles.Colors.lightText : AppStyles.Colors.primary)
                }
                
                Text(template.name)
                    .font(Font.system(.caption, design: .rounded).weight(.medium))
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(isSelected ? AppStyles.Colors.primary : AppStyles.Colors.text)
            }
            .padding(.vertical, AppStyles.Dimensions.smallPadding + 2)
            .padding(.horizontal, AppStyles.Dimensions.smallPadding)
            .frame(width: 95, height: 100)
            .scaleEffect(isSelected ? buttonScale : 1.0)
            .opacity(animateTemplates ? 1 : 0)
            .offset(y: animateTemplates ? 0 : 20)
            .animation(AppStyles.Animations.spring.delay(Double(index) * 0.05), value: animateTemplates)
        }
    }
    
    private func applyTemplate(_ template: Template, at index: Int) {
        selectedTemplateIndex = index
        selectedCustomTemplateIndex = nil // Clear custom template selection
        
        habitName = template.name
        frequency = template.frequency
      
        // Set custom frequency if needed
        if let customFreq = template.customFrequency {
            customTargetDays = customFreq.targetDays
            customTotalDays = customFreq.totalDays
            showCustomForm = true
        } else {
            showCustomForm = false
        }
        
        // Set daily goal
        dailyGoalType = template.dailyGoalType
        dailyGoalTarget = template.dailyGoalTarget
        dailyGoalIncrement = template.dailyGoalIncrement
        
       
    }
    
    private func resetForm() {
        selectedTemplateIndex = nil
        selectedCustomTemplateIndex = nil
        habitName = ""
        frequency = .daily
        
        customTargetDays = 30
        customTotalDays = 30
        dailyGoalType = .oneTime
        dailyGoalTarget = 1
        dailyGoalIncrement = 1
        isCustomInterval = false
        
        withAnimation {
            showCustomForm = false
        }
    }
    
    private var createButton: some View {
        Button(action: {
            if !habitName.isEmpty {
                createHabit()
            }
        }) {
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
            .background(createButtonBackground)
            .cornerRadius(AppStyles.Dimensions.cornerRadius)
            .shadow(color: AppStyles.Colors.primary.opacity(0.3), radius: 5, x: 0, y: 3)
        }
        .disabled(habitName.isEmpty || isSubmitting)
    }
    
    private var createButtonBackground: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                AppStyles.Colors.gradient1,
                AppStyles.Colors.gradient2
            ]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .opacity(habitName.isEmpty ? 0.5 : 1.0)
    }
    
    private var cancelButton: some View {
        Button("Cancel") {
            withAnimation {
                animateTemplates = false
                animateForm = false
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .foregroundColor(AppStyles.Colors.primary)
    }
    
    private func createHabit() {
        withAnimation(AppStyles.Animations.spring) {
            isSubmitting = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            createNewHabit()
            presentationMode.wrappedValue.dismiss()
        }
    }
    
    private func createNewHabit() {
        var customFrequency: Habit.CustomFrequency? = nil
        let finalFrequency: Habit.FrequencyType

        
        if frequency == .custom {
            if isCustomInterval {
                finalFrequency = .custom
                customFrequency = Habit.CustomFrequency(
                    targetDays: customTargetDays,
                    totalDays: customTotalDays,
                    startDate: Date()
                )
            } else {
                finalFrequency = .custom
                customFrequency = Habit.CustomFrequency(
                    targetDays: 1,
                    totalDays: 1,
                    startDate: Date()
                )
            }
        } else {
            finalFrequency = frequency
        }
        
        var dailyGoal: Habit.DailyGoal? = nil
        if dailyGoalType != .oneTime {
            let goalType: Habit.DailyGoal.GoalType
            let unit: String
            let target: Int
         
            switch dailyGoalType {
                case .asCount:
                    goalType = .count
                    if selectedTemplateIndex == 2 || habitName.lowercased().contains("water") || habitName.lowercased().contains("su") {
                        unit = "cl"
                    } else {
                        unit = "times"
                    }
                    target = dailyGoalTarget
                    
                case .asTime:
                    goalType = .duration
                    unit = "min"
                    target = dailyGoalTarget
                case .asPercent:
                    goalType = .volume
                    unit = "%"
                    target = 100
                case .oneTime:
                    goalType = .single
                    unit = ""
                    target = 1
            }
            
            dailyGoal = Habit.DailyGoal(
                type: goalType,
                target: target,
                increment: dailyGoalType == .asTime ? 1 : dailyGoalIncrement,
                unit: unit
            )
        }
        
        let newHabit = Habit(
            name: habitName.trimmingCharacters(in: .whitespacesAndNewlines),
            frequency: finalFrequency,
            customFrequency: customFrequency,
            dailyGoal: dailyGoal,
            reminderEnabled: reminderEnabled,  // ADD
            reminderTime: reminderEnabled ? reminderTime : nil  // ADD
        )
        
        habitStore.addHabit(newHabit)
    }
}

struct AddHabitView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitView()
            .environmentObject(HabitStore())
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
    }
}
