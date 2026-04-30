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


@app.post("/parse-habit")
async def parse_habit(req: ParseHabitRequest):
    user_prompt = f'Parse this habit: "{req.text.strip()}"'

    try:
        full_prompt = SYSTEM_PROMPT + "\n\n" + user_prompt
        response = client.models.generate_content(
            model="gemini-1.5-flash",
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
