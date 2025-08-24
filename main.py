from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from .agent import get_random_challenge, verify_answer

app = FastAPI(title="Intelligent Query System")

# ✅ Enable CORS so Flutter Web can access the backend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # for testing, allow everything
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# In-memory sessions
sessions = {}

class AnswerRequest(BaseModel):
    session_id: str
    stage: int
    user_answer: str


@app.get("/")
def root():
    return {"message": "IQS Backend running!"}


@app.get("/start_quiz")
def start_quiz(session_id: str):
    """Start new quiz with Scramble → Math → Riddle"""
    sessions[session_id] = {
        "stage": 0,
        "challenges": get_random_challenge(),  # returns [scramble, math, riddle]
        "secret": "ACCESS-GRANTED-KEY-1234"
    }
    return {
        "message": "Scramble initialized. Solve to continue.",
        "challenge": sessions[session_id]["challenges"][0]["question"]
    }


@app.post("/verify_answer")
def verify_answer_api(req: AnswerRequest):
    if req.session_id not in sessions:
        return {"message": "Session expired. Restart required.", "correct": False}

    session = sessions[req.session_id]
    stage = session["stage"]
    challenges = session["challenges"]

    # Current challenge
    challenge = challenges[stage]
    correct = verify_answer(req.user_answer, challenge["answer"])

    if correct:
        session["stage"] += 1
        if session["stage"] >= len(challenges):
            return {"message": "✅ All stages cleared. Retrieving secret...", "correct": True}
        else:
            next_challenge = challenges[session["stage"]]
            return {
                "message": f"✅ Stage {stage+1} cleared. Proceed.",
                "correct": True,
                "challenge": next_challenge["question"]
            }

    else:
        # If user fails on RIDDLE
        if challenge["question"] in [c["question"] for c in session["challenges"]] and stage == 2:
            # Allow retry once
            if "retried" not in challenge:
                challenge["retried"] = True
                return {
                    "message": "❌ Wrong answer. You have ONE more chance for this riddle.",
                    "correct": False,
                    "challenge": challenge["question"]
                }
            else:
                # Restart quiz with new set
                sessions[req.session_id] = {
                    "stage": 0,
                    "challenges": get_random_challenge(),
                    "secret": "ACCESS-GRANTED-KEY-1234"
                }
                return {
                    "message": "❌ Riddle failed twice. Restarting quiz...",
                    "correct": False,
                    "challenge": sessions[req.session_id]["challenges"][0]["question"]
                }

        # If user fails on SCRAMBLE or MATH → immediate restart
        else:
            sessions[req.session_id] = {
                "stage": 0,
                "challenges": get_random_challenge(),
                "secret": "ACCESS-GRANTED-KEY-1234"
            }
            return {
                "message": "❌ Wrong answer. Restarting quiz with new set...",
                "correct": False,
                "challenge": sessions[req.session_id]["challenges"][0]["question"]
            }


@app.get("/get_secret")
def get_secret(session_id: str):
    if session_id in sessions and sessions[session_id]["stage"] >= 3:
        return {"secret": sessions[session_id]["secret"]}
    return {"message": "Quiz not completed yet."}
