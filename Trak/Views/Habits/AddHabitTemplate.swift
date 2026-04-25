// AddTemplateView.swift - Custom Template Creation
import SwiftUI

struct AddTemplateView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var customTemplates: [CustomTemplate]
    
    @State private var templateName = ""
    @State private var frequency: Habit.FrequencyType = .daily
    @State private var selectedIconIndex = 0
    
    @State private var showCustomForm = false
    @State private var customTargetDays = 30
    @State private var customTotalDays = 30
    @State private var dailyGoalType: DailyRepeatType = .oneTime
    @State private var dailyGoalTarget = 1
    @State private var dailyGoalIncrement = 1
    
    @State private var animateIcons = false
    @State private var animateForm = false
    @State private var isSubmitting = false
    
    @State private var isCustomInterval = false 

    
    enum DailyRepeatType: String, CaseIterable, Codable {
        case oneTime = "one time"
        case asCount = "as a count"
        case asTime = "as a time"
        case asPercent = "as a percent"
    }
    
    private let availableIcons = [
        "list.star",
        "gamecontroller.fill",
        "brain.head.profile",
        "music.note",
        "paintbrush.fill",
        "leaf.fill",
        "sun.max.fill",
        "heart.fill"
    ]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Choose Icon").font(AppStyles.Typography.caption)) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(0..<availableIcons.count, id: \.self) { index in
                                iconButton(index: index)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                    .frame(height: 90)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: AppStyles.Dimensions.smallPadding, trailing: 0))
                    .onAppear {
                        withAnimation {
                            animateIcons = true
                        }
                    }
                }
                
                Section(header: Text("Template Details").font(AppStyles.Typography.caption)) {
                    TextField("Template name", text: $templateName)
                        .font(AppStyles.Typography.body)
                        .onChange(of: templateName) { newValue in
                            if newValue.count > 25 {
                                templateName = String(newValue.prefix(25))
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
                
                Section(header: Text("Summary").font(AppStyles.Typography.caption)) {
                    Text(summaryText)
                        .font(AppStyles.Typography.body)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                        .opacity(animateForm ? 1 : 0)
                        .offset(y: animateForm ? 0 : 20)
                        .animation(AppStyles.Animations.spring.delay(0.4), value: animateForm)
                }
                
                Section {
                    createButtonView
                        .opacity(animateForm ? 1 : 0)
                        .animation(AppStyles.Animations.spring.delay(0.5), value: animateForm)
                }
                .listRowBackground(Color.clear)
            }
            .navigationTitle("Create Template")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                    .foregroundColor(AppStyles.Colors.primary)
                }
            }
            
        }
        .accentColor(AppStyles.Colors.primary)
    }
    
    private var headerView: some View {
        VStack(spacing: 8) {
            Text("Create Your Custom Template")
                .font(AppStyles.Typography.title)
                .foregroundColor(AppStyles.Colors.text)
                .multilineTextAlignment(.center)
            
            Text("Design a personalized habit template that you can reuse anytime")
                .font(AppStyles.Typography.body)
                .foregroundColor(AppStyles.Colors.secondaryText)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
        .opacity(animateForm ? 1 : 0)
        .offset(y: animateForm ? 0 : -20)
        .animation(AppStyles.Animations.spring, value: animateForm)
    }
    
    private var iconSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Choose Icon")
                .font(AppStyles.Typography.headline)
                .foregroundColor(AppStyles.Colors.text)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<availableIcons.count, id: \.self) { index in
                        iconButton(index: index)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8) // Extra padding to prevent clipping
            }
            .frame(height: 90) // Fixed height to prevent clipping of scaled icons
        }
        .opacity(animateIcons ? 1 : 0)
        .offset(y: animateIcons ? 0 : 20)
        .animation(AppStyles.Animations.spring.delay(0.2), value: animateIcons)
    }
    
    private func iconButton(index: Int) -> some View {
        let isSelected = selectedIconIndex == index
        
        return Button(action: {
            withAnimation(AppStyles.Animations.spring) {
                selectedIconIndex = index
            }
        }) {
            ZStack {
                Circle()
                    .fill(isSelected ?
                          LinearGradient(
                            gradient: Gradient(colors: [AppStyles.Colors.gradient1, AppStyles.Colors.gradient2]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                          ) :
                          LinearGradient(
                            gradient: Gradient(colors: [AppStyles.Colors.secondaryBackground, AppStyles.Colors.secondaryBackground]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                          )
                    )
                    .frame(width: 60, height: 60)
                    .shadow(color: isSelected ? AppStyles.Colors.primary.opacity(0.3) : Color.black.opacity(0.05),
                           radius: isSelected ? 8 : 4, x: 0, y: isSelected ? 4 : 2)
                
                Image(systemName: availableIcons[index])
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(isSelected ? AppStyles.Colors.lightText : AppStyles.Colors.primary)
            }
            .scaleEffect(isSelected ? 1.1 : 1.0)
            .opacity(animateIcons ? 1 : 0)
            .offset(y: animateIcons ? 0 : 15)
            .animation(AppStyles.Animations.spring.delay(Double(index) * 0.05), value: animateIcons)
        }
    }
    
    private var templateFormView: some View {
        VStack(spacing: 20) {
            // Template Name
            VStack(alignment: .leading, spacing: 8) {
                Text("Template Name")
                    .font(AppStyles.Typography.headline)
                    .foregroundColor(AppStyles.Colors.text)
                
                TextField("Enter template name", text: $templateName)
                    .font(AppStyles.Typography.body)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppStyles.Colors.secondaryBackground)
                    )
            }
            
            // Frequency Selection
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
            
            if showCustomForm {
                customFormView
            }
        }
        .opacity(animateForm ? 1 : 0)
        .offset(y: animateForm ? 0 : 20)
        .animation(AppStyles.Animations.spring.delay(0.3), value: animateForm)
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
                    Text("times")
                        .font(AppStyles.Typography.body)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                    
                    Text("each tick =")
                        .font(AppStyles.Typography.caption)
                        .foregroundColor(AppStyles.Colors.secondaryText)
                    
                    VStack(alignment: .center, spacing: 0) {
                        Picker("Increment", selection: $dailyGoalIncrement) {
                            ForEach(1...min(dailyGoalTarget, 250), id: \.self) { value in
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
                        .frame(width: 80, height: 80) 
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
    
    private var summaryView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Summary")
                .font(AppStyles.Typography.headline)
                .foregroundColor(AppStyles.Colors.text)
            
            Text(summaryText)
                .font(AppStyles.Typography.body)
                .foregroundColor(AppStyles.Colors.secondaryText)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 0)
                        .fill(AppStyles.Colors.primary.opacity(0.1))
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(AppStyles.Colors.primary.opacity(0.3), lineWidth: 1)
                        )
                )
        }
        .opacity(animateForm ? 1 : 0)
        .offset(y: animateForm ? 0 : 20)
        .animation(AppStyles.Animations.spring.delay(0.4), value: animateForm)
    }
    
    private var summaryText: String {
        guard !templateName.isEmpty else {
            return "Enter a template name to see the summary"
        }
        
        let frequencyText: String
        switch frequency {
        case .morning:
            frequencyText = "every morning"
        case .evening:
            frequencyText = "every evening"
        case .daily:
            frequencyText = "daily"
        case .custom:
            if customTargetDays == customTotalDays {
                frequencyText = "daily"
            } else if customTargetDays == 1 && customTotalDays == 7 {
                frequencyText = "weekly"
            } else if customTargetDays == 1 && (customTotalDays == 30 || customTotalDays == 31) {
                frequencyText = "monthly"
            } else {
                frequencyText = "\(customTargetDays) out of \(customTotalDays) days"
            }
        }
        
        let goalText: String
        switch dailyGoalType {
        case .oneTime:
            goalText = "once"
        case .asCount:
            goalText = "\(dailyGoalTarget) times"
        case .asTime:
            goalText = "for \(dailyGoalTarget) minutes"
        case .asPercent:
            goalText = "\(dailyGoalTarget) units"
        }
        
        if dailyGoalType == .oneTime {
            return "Save \"\(templateName)\" template to be completed \(frequencyText)?"
        } else {
            return "Save \"\(templateName)\" template to be completed \(goalText) \(frequencyText)?"
        }
    }
    
    private var createButtonView: some View {
        Button(action: {
            createTemplate()
        }) {
            HStack {
                Spacer()
                
                if isSubmitting {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: AppStyles.Colors.lightText))
                        .scaleEffect(1.2)
                        .padding(.trailing, 8)
                }
                
                Text(isSubmitting ? "Creating..." : "Create Template")
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
                .opacity(templateName.isEmpty ? 0.5 : 1.0)
            )
            .cornerRadius(AppStyles.Dimensions.cornerRadius)
            .shadow(color: AppStyles.Colors.primary.opacity(0.3), radius: 8, x: 0, y: 4)
        }
        .disabled(templateName.isEmpty || isSubmitting)
        .opacity(animateForm ? 1 : 0)
        .offset(y: animateForm ? 0 : 20)
        .animation(AppStyles.Animations.spring.delay(0.5), value: animateForm)
    }
    
    private var frequencyDescription: String {
        switch frequency {
        case .morning:
            return "Complete between 6:00 AM - 12:00 PM"
        case .evening:
            return "Complete between 6:00 PM - 12:00 AM"
        case .daily:
            return "Complete at any time during the day"
        default:
            return ""
        }
    }
    
    private func createTemplate() {
        withAnimation(AppStyles.Animations.spring) {
            isSubmitting = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let finalFrequency: Habit.FrequencyType
            let finalCustomFrequency: (targetDays: Int, totalDays: Int)?
            
            if frequency == .custom {
                if isCustomInterval {
                    finalFrequency = .custom
                    finalCustomFrequency = (targetDays: customTargetDays, totalDays: customTotalDays)
                } else {
                    finalFrequency = .daily
                    finalCustomFrequency = nil
                }
            } else {
                finalFrequency = frequency
                finalCustomFrequency = frequency == .custom ? (targetDays: customTargetDays, totalDays: customTotalDays) : nil
            }
            
            let newTemplate = CustomTemplate(
                name: templateName,
                iconName: availableIcons[selectedIconIndex],
                frequency: finalFrequency,
                customFrequency: finalCustomFrequency,
                dailyGoalType: dailyGoalType,
                dailyGoalTarget: dailyGoalTarget,
                dailyGoalIncrement: dailyGoalIncrement
            )
            
            customTemplates.append(newTemplate)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

    // Custom Template Model
struct CustomTemplate: Identifiable, Codable, Equatable {
    let id = UUID()
    let name: String
    let iconName: String
    let frequency: Habit.FrequencyType
    let customFrequency: (targetDays: Int, totalDays: Int)?
    let dailyGoalType: AddTemplateView.DailyRepeatType
    let dailyGoalTarget: Int
    let dailyGoalIncrement: Int
    
    // Equatable conformance
    static func == (lhs: CustomTemplate, rhs: CustomTemplate) -> Bool {
        return lhs.id == rhs.id &&
               lhs.name == rhs.name &&
               lhs.iconName == rhs.iconName &&
               lhs.frequency == rhs.frequency &&
               lhs.customFrequency?.targetDays == rhs.customFrequency?.targetDays &&
               lhs.customFrequency?.totalDays == rhs.customFrequency?.totalDays &&
               lhs.dailyGoalType == rhs.dailyGoalType &&
               lhs.dailyGoalTarget == rhs.dailyGoalTarget &&
               lhs.dailyGoalIncrement == rhs.dailyGoalIncrement
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, iconName, frequency, dailyGoalType, dailyGoalTarget, dailyGoalIncrement
        case customTargetDays, customTotalDays
    }
    
    init(name: String, iconName: String, frequency: Habit.FrequencyType, customFrequency: (targetDays: Int, totalDays: Int)?, dailyGoalType: AddTemplateView.DailyRepeatType, dailyGoalTarget: Int, dailyGoalIncrement: Int) {
        self.name = name
        self.iconName = iconName
        self.frequency = frequency
        self.customFrequency = customFrequency
        self.dailyGoalType = dailyGoalType
        self.dailyGoalTarget = dailyGoalTarget
        self.dailyGoalIncrement = dailyGoalIncrement
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        iconName = try container.decode(String.self, forKey: .iconName)
        frequency = try container.decode(Habit.FrequencyType.self, forKey: .frequency)
        dailyGoalType = try container.decode(AddTemplateView.DailyRepeatType.self, forKey: .dailyGoalType)
        dailyGoalTarget = try container.decode(Int.self, forKey: .dailyGoalTarget)
        dailyGoalIncrement = try container.decode(Int.self, forKey: .dailyGoalIncrement)
        
        if let targetDays = try? container.decode(Int.self, forKey: .customTargetDays),
           let totalDays = try? container.decode(Int.self, forKey: .customTotalDays) {
            customFrequency = (targetDays: targetDays, totalDays: totalDays)
        } else {
            customFrequency = nil
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(iconName, forKey: .iconName)
        try container.encode(frequency, forKey: .frequency)
        try container.encode(dailyGoalType, forKey: .dailyGoalType)
        try container.encode(dailyGoalTarget, forKey: .dailyGoalTarget)
        try container.encode(dailyGoalIncrement, forKey: .dailyGoalIncrement)
        
        if let customFreq = customFrequency {
            try container.encode(customFreq.targetDays, forKey: .customTargetDays)
            try container.encode(customFreq.totalDays, forKey: .customTotalDays)
        }
    }
}

struct AddTemplateView_Previews: PreviewProvider {
    static var previews: some View {
        AddTemplateView(customTemplates: .constant([]))
    }
}
