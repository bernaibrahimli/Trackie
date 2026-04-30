from fastapi import FastAPI
from pydantic import BaseModel
from google import genai
from google.genai import types
import json
import os
from dotenv import load_dotenv

# 1. Load environment variables
load_dotenv()

# 2. Configure Gemini
api_key = os.getenv("GEMINI_API_KEY")
if not api_key:
    raise ValueError("No GEMINI_API_KEY found in .env file")

client = genai.Client(api_key=api_key)

app = FastAPI()


@app.get("/")
async def health():
    return {"status": "ok"}


# --- Parse Habit ---

class ParseHabitRequest(BaseModel):
    text: str


SYSTEM_PROMPT = """
You are a habit-building assistant. Parse the user's natural-language habit description into a JSON object.

OUTPUT SCHEMA:
{
  "name": string,                // Short habit name, max 25 chars, title-case
  "frequency": string,           // One of: "daily" | "morning" | "evening" | "custom"
  "customFrequency": {           // Only when frequency == "custom", else null
    "targetDays": number,        // Days to complete within the period (e.g. 3)
    "totalDays": number,         // Length of the period in days (e.g. 7)
    "isRecurring": boolean       // true = repeat cycle indefinitely
  } | null,
  "dailyGoal": {                 // null for simple once-per-day habits with no measurement
    "type": string,              // "count" or "duration"
    "target": number,
    "increment": number,         // Always 1
    "unit": string               // e.g. "glasses", "min", "pages", "reps"
  } | null,
  "reminderEnabled": boolean,
  "reminderHour": number | null,   // 24-hour (0-23), null if no reminder
  "reminderMinute": number | null  // 0-59, null if no reminder
}

RULES:
- frequency "morning": user says morning/wake up AND no count/duration goal
- frequency "evening": user says evening/night/before bed AND no count/duration goal
- frequency "daily": every day, doesn't fit morning/evening
- frequency "custom": not every day (e.g. "3x a week", "every other day")
- custom isRecurring defaults to true unless user says "for the next X days"
- reminderEnabled true when user says "remind me", "at 9 AM", etc.
- No reminder time given → infer: 8:00 morning, 20:00 evening, 9:00 otherwise
- "count" for discrete reps (glasses, push-ups, pages); "duration" for timed activities
- dailyGoal null for simple habits with no measurement (e.g. "take vitamins")
- Strip filler: "I want to", "Help me", "Remind me to"

EXAMPLES:
Input:  "Drink 8 glasses of water every day, remind me at 9 AM"
Output: {"name":"Drink water","frequency":"daily","customFrequency":null,"dailyGoal":{"type":"count","target":8,"increment":1,"unit":"glasses"},"reminderEnabled":true,"reminderHour":9,"reminderMinute":0}

Input:  "Run 5 times a week for 30 minutes"
Output: {"name":"Go for a run","frequency":"custom","customFrequency":{"targetDays":5,"totalDays":7,"isRecurring":true},"dailyGoal":{"type":"duration","target":30,"increment":1,"unit":"min"},"reminderEnabled":false,"reminderHour":null,"reminderMinute":null}
"""


# --- Generate Program ---

class GenerateProgramRequest(BaseModel):
    goal: str


GENERATE_PROGRAM_PROMPT = """
You are a habit-building assistant. Generate a multi-habit program based on the user's goal.

OUTPUT SCHEMA:
{
  "name": string,                // Program name, max 30 chars, title-case
  "description": string,         // One-sentence description, max 80 chars
  "detailedDescription": string, // 2-3 sentence paragraph explaining the program
  "icon": string,                // MUST be exactly one of: "leaf.circle.fill", "figure.run", "brain.head.profile", "moon.stars.fill", "drop.fill", "book.fill", "heart.fill", "globe", "fork.knife", "bed.double.fill", "figure.mind.and.body", "dumbbell.fill", "music.note", "paintbrush.fill", "laptopcomputer"
  "colorHex": string,            // MUST be exactly one of: "#34C759", "#007AFF", "#FF9500", "#AF52DE", "#FF3B30", "#5AC8FA", "#5856D6"
  "duration": number,            // Days, between 7 and 30
  "habits": [                    // Array of exactly 4 to 6 habits
    {
      "name": string,            // Max 25 chars, title-case
      "description": string,     // One sentence describing the habit
      "frequency": string,       // One of: "daily" | "morning" | "evening" | "custom"
      "customTargetDays": number | null,  // e.g. 3 — only when frequency == "custom", else null
      "customTotalDays": number | null,   // e.g. 7 — only when frequency == "custom", else null
      "dailyGoalType": string | null,     // "count" | "duration" | null
      "dailyGoalTarget": number | null,   // null when dailyGoalType is null
      "dailyGoalUnit": string | null,     // e.g. "glasses", "min", "times" — null when dailyGoalType is null
      "benefits": string                  // Short benefit phrase, max 40 chars
    }
  ]
}

RULES:
- Return exactly 4 to 6 habits — no more, no less
- Choose the icon and colorHex that best matches the program theme
- Use "custom" frequency only when a habit should NOT happen every day (e.g. "3x a week")
- Use "morning" or "evening" only for habits tied to those time windows with no count/duration
- dailyGoalType null for simple once-per-day habits (e.g. "Take vitamins", "Meditate")
- Make habits specific, actionable, and varied — don't repeat the same type
- Program name and habit names must be concise and motivating
- Strip filler from goal: "I want to", "Help me", "I'd like to"
"""


@app.post("/generate-program")
async def generate_program(req: GenerateProgramRequest):
    user_prompt = f'Generate a habit program for this goal: "{req.goal.strip()}"'

    try:
        full_prompt = GENERATE_PROGRAM_PROMPT + "\n\n" + user_prompt
        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=[types.Content(parts=[types.Part(text=full_prompt)])],
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
            ),
        )

        print(f"\n--- GENERATE PROGRAM INPUT ---\n{req.goal}")
        print(f"--- OUTPUT ---\n{response.text}\n")

        data = json.loads(response.text)
        return data

    except Exception as e:
        import traceback
        print(f"Error: {e}")
        traceback.print_exc()
        return {"error": str(e)}


@app.post("/parse-habit")
async def parse_habit(req: ParseHabitRequest):
    user_prompt = f'Parse this habit: "{req.text.strip()}"'

    try:
        full_prompt = SYSTEM_PROMPT + "\n\n" + user_prompt
        response = client.models.generate_content(
            model="gemini-2.5-flash",
            contents=[types.Content(parts=[types.Part(text=full_prompt)])],
            config=types.GenerateContentConfig(
                response_mime_type="application/json",
            ),
        )

        print(f"\n--- INPUT ---\n{req.text}")
        print(f"--- OUTPUT ---\n{response.text}\n")

        data = json.loads(response.text)
        return data

    except Exception as e:
        import traceback
        print(f"Error: {e}")
        traceback.print_exc()
        return {"error": str(e)}
