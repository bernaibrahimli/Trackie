// TrackieWidgets.swift
import WidgetKit
import SwiftUI



// MARK: - Widget Entry (Veri Modeli)
struct HabitEntry: TimelineEntry {
    let date: Date
    let habits: [WidgetHabit]
    let completedCount: Int
    let totalCount: Int
}

// MARK: - Widget Habit Modeli
struct WidgetHabit: Identifiable {
    let id: UUID
    let name: String
    let isCompleted: Bool
    let iconName: String
    let color: WidgetColor
    let progressPercentage: Double
    let progressText: String
}

// MARK: - Widget Renk Enum'u
enum WidgetColor {
    case primary
    case success
    case warning
    case secondary
    
    var color: Color {
        switch self {
        case .primary:
            return Color(red: 0.41, green: 0.91, blue: 0.85)
            
        case .success:
            return Color(red: 0.13, green: 0.82, blue: 0.40)
        case .warning:
            return Color(red: 1.0, green: 0.78, blue: 0.0)
        case .secondary:
            return Color(red: 1.0, green: 0.37, blue: 0.47)
        }
    }
}

struct HabitProvider: TimelineProvider {
    func placeholder(in context: Context) -> HabitEntry {
        HabitEntry(
            date: Date(),
            habits: [],
            completedCount: 0,
            totalCount: 0
        )
    }
    
    // Widget Gallery'de gösterilecek örnek
    func getSnapshot(in context: Context, completion: @escaping (HabitEntry) -> ()) {
        if let sharedData = WidgetDataManager.shared.loadHabitsData() {
            let entry = createEntry(from: sharedData)
            completion(entry)
        } else {
            let entry = HabitEntry(
                date: Date(),
                habits: [],  // ← BOŞ liste
                completedCount: 0,
                totalCount: 0
            )
            completion(entry)
        }
    }
    // Ana timeline fonksiyonu
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [HabitEntry] = []
        let currentDate = Date()
        
        // Gerçek veriyi yükle
        if let sharedData = WidgetDataManager.shared.loadHabitsData() {
            // Veri varsa gerçek veriyi kullan
            let entry = createEntry(from: sharedData)
            entries.append(entry)
            
        } else {
            // Veri yoksa boş liste oluştur (placeholder değil)
            let entry = HabitEntry(
                date: currentDate,
                habits: [],
                completedCount: 0,
                totalCount: 0
            )
            entries.append(entry)
            
        }
        
        // Bir sonraki güncelleme zamanı
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate) ?? currentDate
        let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
        completion(timeline)
    }
    
    // Shared data'dan widget entry oluştur
    private func createEntry(from sharedData: SharedHabitData) -> HabitEntry {
        let widgetHabits = sharedData.habits.map { sharedHabit in
            WidgetHabit(
                id: sharedHabit.id,
                name: sharedHabit.name,
                isCompleted: sharedHabit.isCompleted,
                iconName: sharedHabit.iconName,
                color: sharedHabit.isCompleted ? .success : .primary,
                progressPercentage: sharedHabit.progressPercentage,
                progressText: sharedHabit.progressText
            )
        }
        
        return HabitEntry(
            date: sharedData.lastUpdated,
            habits: widgetHabits,
            completedCount: sharedData.completedCount,
            totalCount: sharedData.totalCount
        )
    }
    
    // Placeholder habitler (gerçek veri yoksa)
}

// MARK: - Widget Views
struct HabitWidgetEntryView: View {
    var entry: HabitProvider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                SmallWidgetView(entry: entry)
                    .cornerRadius(16)
            case .systemMedium:
                MediumWidgetView(entry: entry)
                    .cornerRadius(16)
            case .systemLarge:
                LargeWidgetView(entry: entry)
                    .cornerRadius(16)
            default:
                SmallWidgetView(entry: entry)
            }
        }
        .widgetURL(URL(string: "trackie://today"))
        .containerBackground(Color.black, for: .widget)
    }
}

// MARK: - Small Widget View
struct SmallWidgetView: View {
    let entry: HabitEntry
    
    var body: some View {
        ZStack {
            Color(.clear)
                .overlay(
                    Color(.clear)
                
                )
            
            if entry.totalCount == 0 {
                // Empty state
                VStack(spacing: 8) {
                    Image(systemName: "list.star")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(Color.white)
                    
                    Text("No Habits Yet")
                        .font(.system(size: 13, weight: .light, design: .rounded))
                        .foregroundColor(Color.white)
                        .multilineTextAlignment(.center)
                }
            } else {
                VStack(spacing: 8) {
                    // Başlık
                    Text("Today")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.mint,
                                    Color.white
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    
                    // Ana progress circle
                    ZStack {
                        // Background circle
                        Circle()
                            .stroke(Color(.systemGray4), lineWidth: 1)
                            .frame(width: 80, height: 80)
                        
                        // Progress circle
                        Circle()
                            .trim(from: 0, to: CGFloat(entry.completedCount) / CGFloat(max(entry.totalCount, 1)))
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        WidgetColor.primary.color,
                                        WidgetColor.success.color
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                style: StrokeStyle(lineWidth: 4, lineCap: .round)
                            )
                            .frame(width: 80, height: 80)
                            .rotationEffect(.degrees(-90))
                        
                        // İçerdeki metin
                        VStack(spacing: 2) {
                            Text("\(entry.completedCount)")
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundColor(Color.white)
                            
                            Text("/ \(entry.totalCount)")
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                    }
                    
                    // Alt metin
                    Text(entry.completedCount == entry.totalCount ? "All completed!" : "habits completed")
                        .font(.system(size: 10, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

// MARK: - Medium Widget View
struct MediumWidgetView: View {
    let entry: HabitEntry
    
    var body: some View {
        ZStack {
            // Background
            Color(.clear)
                .overlay(
                    Color(.clear)
                )
            
            if entry.totalCount == 0 {
                VStack(spacing: 12) {
                    Image(systemName: "list.star")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(Color.white)
                    
                    Text("No Habits Added Yet")
                        .font(.system(size: 12, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white)
                    Divider()
                        .colorInvert()
                    Text("Click here to add a new one!")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                VStack(spacing: 12) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Today's Habits")
                                .font(.title3)
                                .fontWeight(.medium)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.mint, Color.white],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                            Divider()
                                .colorInvert()
                            
                            Text("\(entry.completedCount)/\(entry.totalCount) completed")
                                .font(.system(size: 11, weight: .medium, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        // Overall progress circle (küçük)
                        ZStack {
                            Circle()
                                .stroke(Color(.systemGray4), lineWidth: 1)
                                .frame(width: 55, height: 55)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(entry.completedCount) / CGFloat(max(entry.totalCount, 1)))
                                .stroke(WidgetColor.success.color, style: StrokeStyle(lineWidth: 3, lineCap: .round))
                                .frame(width: 55, height: 55)
                                .rotationEffect(.degrees(-90))
                            
                            Text("\(Int((Double(entry.completedCount) / Double(max(entry.totalCount, 1))) * 100))%")
                                .font(.system(size: 16, weight: .bold, design: .rounded))
                                .foregroundColor(Color.white)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    
                    // Habit circles
                    HStack(spacing: 16) {
                        Spacer()
                        if entry.habits.count <= 4 {
                            
                            ForEach(displayedHabits.prefix(4), id: \.id) { habit in
                                MediumHabitCircle(habit: habit)
                            }
                            
                        } else if entry.habits.count > 4 {
                            ForEach(displayedHabits.prefix(3), id: \.id) { habit in
                                MediumHabitCircle(habit: habit)
                            }
                            VStack(spacing: 4) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Circle()
                                                .stroke(Color(.systemGray4), lineWidth: 1.5)
                                        )
                                    
                                    VStack(spacing: 1) {
                                        Text("+\(entry.habits.count - 3)")
                                            .font(.system(size: 12, weight: .bold, design: .rounded))
                                            .foregroundColor(Color.white)
                                        
                                        Text("more")
                                            .font(.system(size: 8, weight: .medium, design: .rounded))
                                            .foregroundColor(Color.white.opacity(0.7))
                                    }
                                }
                                
                                Text("Others")
                                    .font(.system(size: 8, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.white.opacity(0.7))
                                    .lineLimit(1)
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 12)
                }
            }
        }
    }
    
    // Önce tamamlanmayanlar, sonra tamamlananlar (sola doğru)
    var displayedHabits: [WidgetHabit] {
        let incomplete = entry.habits.filter { !$0.isCompleted }
        let complete = entry.habits.filter { $0.isCompleted }
        return incomplete + complete
    }
}

// MARK: - Medium Habit Circle Component
struct MediumHabitCircle: View {
    let habit: WidgetHabit
    
    var body: some View {
        VStack(spacing: 4) {
            ZStack {
                // Background circle
                Circle()
                    .fill(habit.isCompleted ? habit.color.color.opacity(0.2) : Color.white.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                // Border
                Circle()
                    .stroke(
                        habit.isCompleted ? habit.color.color : Color.white.opacity(0.5),
                        lineWidth: habit.isCompleted ? 2.5 : 1.5
                    )
                    .frame(width: 50, height: 50)
                
                if !habit.isCompleted && habit.progressPercentage > 0 {
                    Circle()
                        .fill(WidgetColor.primary.color.opacity(0.3))
                        .frame(width: 50, height: 50)
                        .mask(
                            Rectangle()
                                .frame(height: 50 * habit.progressPercentage)
                                .offset(y: 25 * (1 - habit.progressPercentage))
                        )
                }
                
                // Icon
                Image(systemName: habit.iconName)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(habit.isCompleted ? habit.color.color : Color.white)
                
                // Progress indicator (top right)
                if !habit.isCompleted && !habit.progressText.isEmpty {
                    Text(habit.progressText)
                        .font(.system(size: 6, weight: .bold, design: .rounded))
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 3)
                        .padding(.vertical, 1)
                        .background(
                            Capsule()
                                .fill(WidgetColor.primary.color)
                        )
                        .offset(x: 20, y: -20)
                } else if habit.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                        .foregroundColor(habit.color.color)
                        .background(Circle().fill(Color(.systemBackground)))
                        .offset(x: 20, y: -20)
                }
            }
            
            // Habit name
            Text(habit.name)
                .font(.system(size: 8, weight: .medium, design: .rounded))
                .foregroundColor(habit.isCompleted ? habit.color.color : Color.white)
                .lineLimit(1)
                .frame(width: 50)
        }
    }
}

// MARK: - Large Widget View
struct LargeWidgetView: View {
    let entry: HabitEntry
    
    var body: some View {
        ZStack {
            
            if entry.totalCount == 0 {
                // Empty state
                VStack(spacing: 12) {
                    Image(systemName: "list.star")
                        .font(.system(size: 50, weight: .light))
                        .foregroundColor(Color.white)
                    
                    Text("No Habits Added Yet")
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(Color.white)
                    Divider()
                        .colorInvert()
                        .padding(.vertical)
                    Text("Click here to add a new one!")
                        .font(.system(size: 10, weight: .regular, design: .rounded))
                        .foregroundColor(Color.white.opacity(0.7))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            } else {
                VStack(spacing: 16) {
                    // Header with overall progress
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today's Habits")
                                .font(.title2)
                                .fontWeight(.medium)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.mint, .white],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                           
                           Divider()
                                .colorInvert()
                            Text(getCurrentDateString())
                                .font(.system(size: 12, weight: .light, design: .rounded))
                                .foregroundColor(Color.white.opacity(0.7))
                        }
                        
                        Spacer()
                        
                        // Overall progress circle
                        ZStack {
                            Circle()
                                .stroke(Color(.systemGray4), lineWidth: 2)
                                .frame(width: 60, height: 60)
                            
                            Circle()
                                .trim(from: 0, to: CGFloat(entry.completedCount) / CGFloat(max(entry.totalCount, 1)))
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            WidgetColor.primary.color,
                                            WidgetColor.success.color
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    style: StrokeStyle(lineWidth: 6, lineCap: .round)
                                )
                                .frame(width: 60, height: 60)
                                .rotationEffect(.degrees(-90))
                            
                            VStack(spacing: 1) {
                                Text("\(entry.completedCount)")
                                    .font(.system(size: 16, weight: .bold, design: .rounded))
                                    .foregroundColor(Color.white)
                                
                                Text("/ \(entry.totalCount)")
                                    .font(.system(size: 10, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.white.opacity(0.7))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16),
                        GridItem(.flexible(), spacing: 16)
                    ], spacing: 16) {
                        ForEach(displayedHabits.prefix(7), id: \.id) { habit in
                            LargeHabitCircle(habit: habit)
                        }
                        
                        // "And more" if more than 8 habits
                        if entry.habits.count > 7 {
                            VStack(spacing: 6) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.1))
                                        .frame(width: 60, height: 60)
                                        .overlay(
                                            Circle()
                                                .stroke(Color.white.opacity(0.5), lineWidth: 2)
                                        )
                                    
                                    VStack(spacing: 2) {
                                        Text("+\(entry.habits.count - 7)")
                                            .font(.system(size: 14, weight: .bold, design: .rounded))
                                            .foregroundColor(Color.white)
                                        
                                        Text("more")
                                            .font(.system(size: 9, weight: .medium, design: .rounded))
                                            .foregroundColor(Color.white.opacity(0.7))
                                    }
                                }
                                
                                Text("Others")
                                    .font(.system(size: 9, weight: .medium, design: .rounded))
                                    .foregroundColor(Color.white.opacity(0.7))
                                    .lineLimit(1)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                }
            }
        }
    }
    
    // Önce tamamlanmayanlar, sonra tamamlananlar (sola doğru)
    var displayedHabits: [WidgetHabit] {
        let incomplete = entry.habits.filter { !$0.isCompleted }
        let complete = entry.habits.filter { $0.isCompleted }
        return incomplete + complete
    }
    
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d"
        formatter.locale = Locale(identifier: "en_US")
        return formatter.string(from: entry.date)
    }
}

// MARK: - Large Habit Circle Component
struct LargeHabitCircle: View {
    let habit: WidgetHabit
    
    var body: some View {
        VStack(spacing: 6) {
            ZStack {
                // Background circle
                Circle()
                    .fill(habit.isCompleted ? habit.color.color.opacity(0.2) : Color.white.opacity(0.1))
                    .frame(width: 60, height: 60)
                
                // Border
                Circle()
                    .stroke(
                        habit.isCompleted ? habit.color.color : Color.white.opacity(0.5),
                        lineWidth: habit.isCompleted ? 3 : 2
                    )
                    .frame(width: 60, height: 60)
                
                // Progress fill for non-completed habits with progress
                if !habit.isCompleted && habit.progressPercentage > 0 {
                    Circle()
                        .fill(WidgetColor.primary.color.opacity(0.3))
                        .frame(width: 60, height: 60)
                        .mask(
                            Rectangle()
                                .frame(height: 60 * habit.progressPercentage)
                                .offset(y: 30 * (1 - habit.progressPercentage))
                        )
                }
                
                // Icon
                Image(systemName: habit.iconName)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(habit.isCompleted ? habit.color.color : Color.white)
                
                // Progress indicator (top right)
                if !habit.isCompleted && !habit.progressText.isEmpty {
                    Text(habit.progressText)
                        .font(.system(size: 7, weight: .bold, design: .rounded))
                        .foregroundColor(Color.black)
                        .padding(.horizontal, 4)
                        .padding(.vertical, 2)
                        .background(
                            Capsule()
                                .fill(WidgetColor.primary.color)
                        )
                        .offset(x: 25, y: -25)
                } else if habit.isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundColor(habit.color.color)
                        .background(
                            Circle()
                                .fill(Color(.systemBackground))
                                .frame(width: 18, height: 18)
                        )
                        .offset(x: 25, y: -25)
                }
            }
            
            // Habit name
            Text(habit.name)
                .font(.system(size: 9, weight: .medium, design: .rounded))
                .foregroundColor(habit.isCompleted ? habit.color.color : Color.white)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(width: 60, height: 20)
        }
    }
}

// MARK: - Ana Widget Tanımı
struct HabitWidget: Widget {
    let kind: String = "HabitWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: HabitProvider()) { entry in
            HabitWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Habit Tracker")
        .description("Track your daily habits.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}


   

