// WeeklyScrubberView.swift
import SwiftUI

struct WeeklyScrubberView: View {
    @Binding var selectedDate: Date

    private let days: [Date]

    init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        let today = Calendar.current.startOfDay(for: Date())
        self.days = (-3...3).compactMap {
            Calendar.current.date(byAdding: .day, value: $0, to: today)
        }
    }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(days, id: \.self) { day in
                    DayCell(day: day, selectedDate: $selectedDate)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
        }
    }
}

private struct DayCell: View {
    let day: Date
    @Binding var selectedDate: Date

    private let calendar = Calendar.current

    private var isSelected: Bool { calendar.isDate(day, inSameDayAs: selectedDate) }
    private var isToday: Bool { calendar.isDateInToday(day) }
    private var isFuture: Bool { day > calendar.startOfDay(for: Date()) }

    var body: some View {
        Button {
            withAnimation(AppStyles.Animations.spring) {
                selectedDate = day
            }
        } label: {
            VStack(spacing: 6) {
                Text(weekdayLabel)
                    .font(.system(size: 11, weight: .medium, design: .rounded))
                    .foregroundColor(isSelected ? .white : AppStyles.Colors.secondaryText)

                Text(dayNumberLabel)
                    .font(.system(size: 17, weight: isSelected ? .bold : .regular, design: .rounded))
                    .foregroundColor(
                        isSelected ? .white :
                        isToday   ? AppStyles.Colors.primary :
                                    AppStyles.Colors.text
                    )

                // Dot under today's number when not selected
                Circle()
                    .fill(isToday && !isSelected ? AppStyles.Colors.primary : Color.clear)
                    .frame(width: 4, height: 4)
            }
            .frame(width: 44, height: 70)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isSelected ? AppStyles.Colors.primary : Color.clear)
            )
            .opacity(isFuture && !isSelected ? 0.55 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var weekdayLabel: String {
        let f = DateFormatter()
        f.dateFormat = "EEE"
        return f.string(from: day).uppercased()
    }

    private var dayNumberLabel: String {
        let f = DateFormatter()
        f.dateFormat = "d"
        return f.string(from: day)
    }
}
