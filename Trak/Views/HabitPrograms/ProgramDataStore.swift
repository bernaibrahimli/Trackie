//
//  ProgramDataStore.swift
//  Trak
//
//  Created by Ege Özçelik on 19.09.2025.
//

// ProgramDataStore.swift
import SwiftUI

class ProgramDataStore: ObservableObject {
    static let shared = ProgramDataStore()
    
    @Published var programs: [HabitProgram] = []
    
    private init() {
        loadPrograms()
    }
    
    private func loadPrograms() {
        programs = createDefaultPrograms()
    }
    
    private func createDefaultPrograms() -> [HabitProgram] {
        return [
            createHealthyLivingProgram(),
            
            createMindBodyHarmonyProgram(),
            
            createLanguageLearningProgram(),
            
            createCalisthenicsProgram(),
            
            createMemoryMindGymProgram(),
           
            createRunnerChallengeProgram(),
            
            createEveningWindDownProgram(),
            
            createDigitalDetoxProgram()
           
        ]
    }
    private func createHealthyLivingProgram() -> HabitProgram {
        let habits = [
            ProgramHabit(
                name: "Daily Vegetable Intake",
                description: "Consume vegetables throughout the day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "day"),
                customFrequency: (targetDays: 21, totalDays: 21),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Morning Chia Water",
                description: "Drink chia seed water in mornings",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "glass"),
                customFrequency: (targetDays: 10, totalDays: 21),
                tips: [],
                benefits: "Mornings"
            ),
            
            ProgramHabit(
                name: "Water Intake",
                description: "Drink at least 2 liters of water daily",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .count, target: 200, increment: 20, unit: "cl"),
                customFrequency: (targetDays: 21, totalDays: 21),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Early Evening Meal",
                description: "Finish your last meal before 8:00 PM",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "day"),
                customFrequency: (targetDays: 6, totalDays: 7),
                tips: [],
                benefits: "Evenings"
            ),
            
            ProgramHabit(
                name: "Stretching or Walking",
                description: "Do 20 minutes of stretching exercises or walking daily",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 20, increment: 5, unit: "min"),
                customFrequency: (targetDays: 21, totalDays: 21),
                tips: [],
                benefits: "Daily"
            )
        ]
        
        return HabitProgram(
            name: "Healthy Living Challenge",
            description: "Transform your lifestyle with nutrition and exercise habits",
            detailedDescription: """
            This 21-day program template is designed for anyone looking to establish a sustainable foundation of healthy living habits. Whether you're starting your wellness journey or seeking to refine your daily routine, this program provides a structured approach to building better eating patterns, proper hydration, and consistent movement into your lifestyle. 
            
            The program focuses on five core areas: increasing your daily vegetable intake for optimal nutrition, starting each morning with chia seed water to support digestion and energy, maintaining proper hydration throughout the day, practicing time-restricted eating by finishing meals early in the evening, and incorporating daily movement through gentle stretching or walking. These habits work together to create a balanced routine that supports your overall health, improves energy levels, enhances sleep quality, and helps you feel your best each day.
            """,
            icon: "leaf.circle.fill",
            color: AppStyles.Colors.success,
            duration: 21,
            habits: habits
        )
    }
   
    private func createMindBodyHarmonyProgram() -> HabitProgram {
        let habits = [
            ProgramHabit(
                name: "Morning Yoga Session",
                description: "Practice yoga for 15 minutes every morning",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 15, increment: 5, unit: "min"),
                customFrequency: (targetDays: 28, totalDays: 28),
                tips: [
                   
                ],
                benefits: "Mornings"
            ),
            
            ProgramHabit(
                name: "Evening Meditation",
                description: "Meditate for 10 minutes at the end of your day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 10, increment: 2, unit: "min"),
                customFrequency: (targetDays: 28, totalDays: 28),
                tips: [
                   
                ],
                benefits: "Evenings"
            ),
            
            ProgramHabit(
                name: "Daily Walk",
                description: "Walk for at least 30 minutes every day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 30, increment: 5, unit: "min"),
                customFrequency: (targetDays: 28, totalDays: 28),
                tips: [
                    
                ],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Breathing Exercises",
                description: "Practice deep breathing exercises for 5 minutes daily",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 5, increment: 1, unit: "min"),
                customFrequency: (targetDays: 28, totalDays: 28),
                tips: [
                   
                ],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Daily Stretching",
                description: "Do 10 minutes of stretching exercises every day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 10, increment: 2, unit: "min"),
                customFrequency: (targetDays: 28, totalDays: 28),
                tips: [
                    
                ],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Sleep Routine",
                description: "Go to bed at your designated bedtime consistently",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "day"),
                customFrequency: (targetDays: 24, totalDays: 28),
                tips: [
                    
                ],
                benefits: "Evenings"
            ),
            
            ProgramHabit(
                name: "Weekly Rest Day",
                description: "Take one full rest day per week for recovery",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "day"),
                customFrequency: (targetDays: 4, totalDays: 28),
                tips: [
                ],
                benefits: "Weekly"
            )
        ]
        
        return HabitProgram(
            name: "Mind & Body Harmony",
            description: "Find balance between mental and physical well-being",
            detailedDescription: """
            This 28-day program template is designed for individuals seeking to create harmony between their mind and body through integrated wellness practices. Whether you're dealing with stress, looking to improve flexibility, or wanting to establish a more balanced daily routine, this program combines movement, mindfulness, and rest to support your holistic health. 
            
            The program centers on seven complementary practices: starting each day with energizing yoga to awaken your body, ending each evening with calming meditation to quiet your mind, incorporating daily walks for cardiovascular health, practicing breathing exercises to manage stress, maintaining flexibility through daily stretching, establishing a consistent sleep routine for optimal recovery, and honoring your body's need for rest with a weekly recovery day. Together, these habits create a sustainable rhythm that reduces tension, enhances physical fitness, improves sleep quality, and cultivates inner peace throughout your month-long journey.
            """,
            icon: "figure.mind.and.body",
            color: .indigo,
            duration: 28,
            habits: habits
        )
    }
    
    private func createLanguageLearningProgram() -> HabitProgram {
        let habits = [
            ProgramHabit(
                name: "Daily Vocabulary Learning",
                description: "Learn 10 new words in your target language every day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .count, target: 10, increment: 1, unit: "words"),
                customFrequency: (targetDays: 24, totalDays: 24),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Podcast/Audio Content",
                description: "Listen to podcasts or audio content for 15 minutes daily",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 15, increment: 5, unit: "min"),
                customFrequency: (targetDays: 24, totalDays: 24),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Reading Aloud Practice",
                description: "Practice reading aloud for 10 minutes every day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 10, increment: 2, unit: "min"),
                customFrequency: (targetDays: 24, totalDays: 24),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Daily Writing Exercise",
                description: "Write in your target language for 15 minutes daily",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 15, increment: 5, unit: "min"),
                customFrequency: (targetDays: 24, totalDays: 24),
                tips: [],
                benefits:  "Daily"
            ),
            
            ProgramHabit(
                name: "Shadowing Technique",
                description: "Practice shadowing for 5 minutes every day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 5, increment: 1, unit: "min"),
                customFrequency: (targetDays: 24, totalDays: 24),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Cultural Content Exploration",
                description: "Explore cultural content for 10 minutes daily",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 10, increment: 2, unit: "min"),
                customFrequency: (targetDays: 24, totalDays: 24),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Weekly Review Session",
                description: "Complete a 30-minute comprehensive review session",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 30, increment: 10, unit: "min"),
                customFrequency: (targetDays: 4, totalDays: 24),
                tips: [],
                benefits: "Weekly"
            )
        ]
        
        return HabitProgram(
            name: "Language Learning",
            description: "Build fluency through consistent daily practice",
            detailedDescription: """
            This 24-day program template is designed for language learners who want to develop comprehensive skills through structured daily practice. Whether you're a beginner starting your language journey or an intermediate learner looking to achieve fluency, this program integrates all essential language acquisition methods into one cohesive routine.
            
            The program focuses on seven key learning practices: expanding your vocabulary with 10 new words daily, training your ear through podcast and audio content listening, improving pronunciation with reading aloud practice, developing writing skills through daily journaling or composition exercises, mastering the shadowing technique where you listen to native speakers and repeat simultaneously to improve rhythm and intonation, exploring cultural content such as films, music, news, or social media in your target language to understand context and cultural nuances, and conducting weekly review sessions to consolidate your learning and identify areas for improvement. These habits work together to create immersive language exposure, build confidence in all four skills (reading, writing, listening, speaking), and help you progress steadily toward fluency over the course of 24 days.
            """,
            icon: "globe",
            color: .blue,
            duration: 24,
            habits: habits
        )
    }
    
    private func createCalisthenicsProgram() -> HabitProgram {
        let habits = [
            ProgramHabit(
                name: "Pull-up Progression",
                description: "Perform maximum reps of pull-ups with proper form",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "session"),
                customFrequency: (targetDays: 12, totalDays: 28),
                tips: [],
                benefits: "3 Days a Week"
            ),
            
            ProgramHabit(
                name: "Dip Progression",
                description: "Perform maximum reps of dips with controlled movement",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "session"),
                customFrequency: (targetDays: 12, totalDays: 28),
                tips: [],
                benefits: "3 Days a Week"
            ),
            
            ProgramHabit(
                name: "Pistol Squat Training",
                description: "Practice 10 controlled pistol squats on each leg",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "session"),
                customFrequency: (targetDays: 8, totalDays: 28),
                tips: [],
                benefits: "2 Days a Week"
            ),
            
            ProgramHabit(
                name: "Handstand Practice",
                description: "Practice handstand holds and progressions for 5 minutes",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 5, increment: 1, unit: "min"),
                customFrequency: (targetDays: 28, totalDays: 28),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Core Workout",
                description: "Complete a 10-minute core strengthening routine",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 10, increment: 2, unit: "min"),
                customFrequency: (targetDays: 28, totalDays: 28),
                tips: [],
                benefits: "Daily"
            )
        ]
        
        return HabitProgram(
            name: "Calisthenics Strength Program",
            description: "Build functional strength using only your bodyweight",
            detailedDescription: """
            This 28-day program template is designed for fitness enthusiasts who want to develop impressive bodyweight strength and master fundamental calisthenics skills. Whether you're new to calisthenics or looking to advance your existing skills, this program provides a structured progression system that challenges your strength, balance, and body control. 
            
            The program focuses on five essential calisthenics movements: pull-up progressions three times per week to build upper body pulling strength and back development, dip progressions three times per week to develop pushing power in your chest, shoulders, and triceps, pistol squat training twice per week to build unilateral leg strength and balance, daily handstand practice to improve shoulder stability and body awareness through inversions, and daily core workouts to develop the foundational strength needed for all advanced calisthenics movements. These exercises work together to create a balanced, functional physique while teaching you complete control over your own bodyweight throughout the 28-day training cycle.
            """,
            icon: "figure.strengthtraining.traditional",
            color: .red,
            duration: 28,
            habits: habits
        )
    }
    
    private func createMemoryMindGymProgram() -> HabitProgram {
        let habits = [
            ProgramHabit(
                name: "Memory Games",
                description: "Play memory and brain training games for 15 minutes",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 15, increment: 5, unit: "min"),
                customFrequency: (targetDays: 21, totalDays: 21),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Foreign Language Practice",
                description: "Practice a foreign language for 20 minutes daily",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 20, increment: 5, unit: "min"),
                customFrequency: (targetDays: 21, totalDays: 21),

                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Math Problems",
                description: "Solve 10 math problems every day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "session"),
                customFrequency: (targetDays: 21, totalDays: 21),

                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Learn New Knowledge",
                description: "Study and learn one new topic each day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "topic"),
                customFrequency: (targetDays: 21, totalDays: 21),
                tips: [],
                benefits: "Daily"
            )
        ]
        
        return HabitProgram(
            name: "Memory & Mind Gym",
            description: "Strengthen cognitive abilities through daily mental exercises",
            detailedDescription: """
            This 21-day program template is designed for individuals who want to enhance their cognitive performance and keep their mind sharp through consistent mental training. Whether you're a student looking to improve academic performance, a professional seeking better focus and problem-solving skills, or simply someone interested in maintaining long-term brain health, this program provides a comprehensive approach to cognitive fitness. 
            
            The program focuses on four core mental training areas: engaging in memory games and brain training exercises to strengthen working memory and cognitive flexibility, practicing a foreign language to enhance neuroplasticity and executive function, solving mathematical problems to develop logical reasoning and analytical thinking skills, and learning new topics daily to promote continuous intellectual growth and knowledge expansion. These habits work synergistically to challenge different areas of your brain, improve information retention, boost mental agility, and create lasting cognitive improvements throughout your 21-day journey.
            """,
            icon: "brain.head.profile",
            color: .purple,
            duration: 21,
            habits: habits
        )
    }
   
    private func createRunnerChallengeProgram() -> HabitProgram {
        let habits = [
            ProgramHabit(
                name: "Light Jog",
                description: "Go for a 30-minute light jog to build endurance",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 30, increment: 5, unit: "min"),
                customFrequency: (targetDays: 6, totalDays: 14),
                tips: [],
                benefits: "2 Days of Week"
            ),
            
            ProgramHabit(
                name: "Core Strength Workout",
                description: "Complete a 15-minute core strengthening session",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 15, increment: 5, unit: "min"),
                customFrequency: (targetDays: 4, totalDays: 14),
                tips: [],
                benefits: "2 Days of Week"
            ),
            
            ProgramHabit(
                name: "Stretching",
                description: "Perform 10 minutes of stretching exercises daily",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 10, increment: 2, unit: "min"),
                customFrequency: (targetDays: 14, totalDays: 14),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Mobility & Recovery Session",
                description: "Complete a 20-minute mobility and recovery routine",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 20, increment: 5, unit: "min"),
                customFrequency: (targetDays: 4, totalDays: 14),
                tips: [],
                benefits: "2 Days of Week"
            ),
            
            ProgramHabit(
                name: "Hydration Tracking",
                description: "Drink 8 glasses of water throughout the day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .count, target: 8, increment: 1, unit: "glasses"),
                customFrequency: (targetDays: 14, totalDays: 14),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Progress Run",
                description: "Complete a tracked run to measure distance or pace improvement",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "run"),
                customFrequency: (targetDays: 2, totalDays: 14),
                tips: [],
                benefits: "2 Days of Week"
            )
        ]
        
        return HabitProgram(
            name: "Runner Challenge",
            description: "Build running endurance and injury prevention habits",
            detailedDescription: """
            This 14-day program template is designed for aspiring runners who want to build a sustainable running practice while preventing injuries and improving overall fitness. Whether you're starting your running journey or returning after a break, this program balances cardiovascular training with essential strength and recovery work that runners often neglect. 
            
            The program focuses on six key components of running success: light jogging sessions three times per week to gradually build aerobic capacity and running endurance, core strength workouts twice weekly to develop the stability needed for efficient running form, daily stretching to maintain flexibility and prevent muscle tightness, mobility and recovery sessions twice per week to address movement restrictions and promote faster recovery, daily hydration tracking to ensure optimal performance and recovery, and weekly progress runs to track your improvements in distance or pace. These habits work together to create a well-rounded running practice that prioritizes both performance and injury prevention throughout your 14-day challenge.
            """,
            icon: "figure.run",
            color: .orange,
            duration: 14,
            habits: habits
        )
    }
    
    private func createEveningWindDownProgram() -> HabitProgram {
        let habits = [
            ProgramHabit(
                name: "Light Reading",
                description: "Read for 15 minutes before bed to calm your mind",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 15, increment: 5, unit: "min"),
                customFrequency: (targetDays: 30, totalDays: 30),

                tips: [],
                benefits: "Evenings"
            ),
            
            ProgramHabit(
                name: "Digital-Free Time",
                description: "Avoid all screens for 30 minutes before bedtime",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 30, increment: 5, unit: "min"),
                customFrequency: (targetDays: 30, totalDays: 30),

                tips: [],
                benefits: "Evenings"
            ),
            
            ProgramHabit(
                name: "Gratitude Journal",
                description: "Write down 3 things you're grateful for each evening",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .count, target: 3, increment: 1, unit: "items"),
                customFrequency: (targetDays: 30, totalDays: 30),
                tips: [],
                benefits: "Evenings"
            ),
            
            ProgramHabit(
                name: "Gentle Stretching",
                description: "Do 10 minutes of gentle stretches to release tension",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 10, increment: 2, unit: "min"),
                customFrequency: (targetDays: 30, totalDays: 30),
                tips: [],
                benefits: "Evenings"
            ),
            
            ProgramHabit(
                name: "Evening Meditation",
                description: "Meditate for 10 minutes to quiet your mind",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 10, increment: 2, unit: "min"),
                customFrequency: (targetDays: 30, totalDays: 30),
                tips: [],
                benefits: "Evenings"
            ),
            
            ProgramHabit(
                name: "Prepare for Tomorrow",
                description: "Spend 10 minutes organizing for the next day",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 10, increment: 2, unit: "min"),
                customFrequency: (targetDays: 30, totalDays: 30),
                tips: [],
                benefits: "Evenings"
            ),
            
            ProgramHabit(
                name: "Relaxation",
                description: "Enjoy one cup of calming herbal tea or relaxation drink before sleep.",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "cup"),
                customFrequency: (targetDays: 30, totalDays: 30),
                tips: [],
                benefits: "Evenings"
            )
        ]
        
        return HabitProgram(
            name: "Evening Wind-Down Rituals",
            description: "Create a peaceful evening routine for better sleep for a month",
            detailedDescription: """
            This 30-day program is designed for individuals struggling with sleep quality or evening stress who want to establish a calming bedtime routine. Whether you have difficulty falling asleep, find yourself scrolling through devices late at night, or simply want to end your days with more peace and intention, this program creates a structured wind-down sequence that signals to your body and mind that it's time to rest. 
            
            The program focuses on seven evening rituals: light reading to transition your mind away from daily stressors, digital-free time for 30 minutes before bed to reduce blue light exposure and mental stimulation, gratitude journaling to shift your focus toward positive reflections, gentle stretching to release physical tension accumulated throughout the day, evening meditation to quiet racing thoughts and promote inner calm, preparing for tomorrow to reduce morning anxiety and create a sense of control, and enjoying herbal tea or a relaxation drink as a soothing sensory ritual. These practices work together to lower cortisol levels, activate your parasympathetic nervous system, and create consistent sleep cues that improve both the quality and duration of your rest throughout the 30-day period.
            """,
            icon: "moon.stars.fill",
            color: .indigo,
            duration: 30,
            habits: habits
        )
    }
    
    private func createDigitalDetoxProgram() -> HabitProgram {
        let habits = [
            ProgramHabit(
                name: "Morning Screen-Free Routine",
                description: "Wait 1 hour after waking before checking any devices",
                frequency: .daily,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 60, increment: 10, unit: "min"),
                customFrequency: (targetDays: 10, totalDays: 10),

                tips: [],
                benefits: "Mornings"
            ),
            
            ProgramHabit(
                name: "Mindful Meals",
                description: "Eat meals without any digital devices present",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "day"),
                customFrequency: (targetDays: 10, totalDays: 10),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Evening Device Curfew",
                description: "Put away all devices 1 hour before bedtime",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 60, increment: 10, unit: "min"),
                customFrequency: (targetDays: 10, totalDays: 10),
                tips: [],
                benefits: "Evenings"
            ),
            
            ProgramHabit(
                name: "Short Walks Without Phone",
                description: "Take a 20-minute walk without bringing your phone",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 20, increment: 5, unit: "min"),
                customFrequency: (targetDays: 10, totalDays: 10),

                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Journaling / Reflection",
                description: "Write or reflect without screens for 20 minutes",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 20, increment: 2, unit: "min"),
                customFrequency: (targetDays: 10, totalDays: 10),

                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Social Check-Ins Only",
                description: "Limit notifications to essential contacts and job only",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .single, target: 1, increment: 1, unit: "day"),
                customFrequency: (targetDays: 10, totalDays: 10),
                tips: [],
                benefits: "Daily"
            ),
            
            ProgramHabit(
                name: "Tech-Free Hobby Time",
                description: "Engage in an offline hobby for 30 minutes",
                frequency: .custom,
                dailyGoal: Habit.DailyGoal(type: .duration, target: 30, increment: 5, unit: "min"),
                customFrequency: (targetDays: 10, totalDays: 10),
                tips: [],
                benefits: "Daily"
            )
        ]
        
        return HabitProgram(
            name: "Digital Detox & Presence Boost",
            description: "Reclaim your attention and reconnect with the present moment",
            detailedDescription: """
            This 10-day program template is designed for anyone feeling overwhelmed by constant digital connectivity and seeking to restore their relationship with technology. Whether you find yourself mindlessly scrolling, feeling anxious without your phone, or struggling to be fully present in daily life, this program helps you establish healthy boundaries with devices while rediscovering the richness of offline experiences. 
            
            The program focuses on seven intentional practices: maintaining a morning screen-free routine for one hour to start your day with clarity rather than reactivity, practicing mindful meals by eating without devices to enhance digestion and food enjoyment, implementing an evening device curfew one hour before bed to improve sleep quality, taking short walks without your phone to practice presence and notice your surroundings, engaging in journaling or reflection time to process thoughts without digital distractions, limiting notifications to social check-ins only to reduce constant interruptions, and dedicating time to tech-free hobbies to remember the satisfaction of analog activities. These habits work together to reduce dopamine dependency on digital stimulation, improve focus and attention span, decrease anxiety and stress levels, and help you cultivate genuine presence in your daily life throughout the 10-day reset period.
            """,
            icon: "iphone.slash",
            color: .green,
            duration: 10,
            habits: habits
        )
    }

     }
