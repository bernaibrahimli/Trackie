//
//  CustomUICircles.swift
//  Trak
//
//  Created by Ege on 25.05.2025.
//

// CustomFrequencyCircles.swift
import SwiftUI

struct CustomFrequencyCircles: View {
    let habit: Habit
    
    @State private var animateCircles = false
    
    var body: some View {
        ZStack {
            if let customFreq = habit.customFrequency {
                let totalDays = customFreq.totalDays
                let targetDays = customFreq.targetDays
                let completedDays = habit.getCompletedDaysInCurrentPeriod()
                
                ForEach(0..<totalDays, id: \.self) { index in
                    let angle = Double(index) * 360.0 / Double(totalDays)
                    let isTarget = index < targetDays
                    let isCompleted = index < completedDays
                    
                    Circle()
                        .fill(isCompleted ? AppStyles.Colors.success : Color.clear)
                        .stroke(
                            isTarget ? AppStyles.Colors.success : AppStyles.Colors.secondaryText,
                            lineWidth: isTarget ? 2 : 1.5
                        )
                        .frame(width: 8, height: 8)
                        .offset(y: -60) // Ana circle'dan 60pt uzakta
                        .rotationEffect(.degrees(angle))
                        .scaleEffect(animateCircles ? 1.0 : 0.1)
                        .opacity(animateCircles ? 1.0 : 0.0)
                        .animation(
                            AppStyles.Animations.spring.delay(Double(index) * 0.03),
                            value: animateCircles
                        )
                }
            }
        }
        .onAppear {
            withAnimation {
                animateCircles = true
            }
        }
    }
}

