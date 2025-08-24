import random

# Funny & Tricky Riddles
riddles = [
    {"question": "I speak without a mouth and hear without ears. I have no body, but I come alive with sound.", "answer": "echo"},
    {"question": "The more you take, the more you leave behind.", "answer": "footsteps"},
    {"question": "I have keys but no locks, space but no rooms, and you can enter but not go outside.", "answer": "keyboard"},
    {"question": "I’m tall when I’m young and short when I’m old. A breath can end me.", "answer": "candle"},
    {"question": "I can fill a room but take up no space.", "answer": "light"},
    {"question": "I have cities, but no houses; mountains, but no trees; and roads, but no cars.", "answer": "map"},
    {"question": "I follow you by day, leave you at night, and vanish in darkness.", "answer": "shadow"},
    {"question": "I run but never walk, have a bed but never sleep, and have a mouth but never eat.", "answer": "river"},
    {"question": "You can break me without touching me or saying a word.", "answer": "promise"},
    {"question": "The more I dry, the wetter I get.", "answer": "towel"},
    {"question": "I have many branches but no fruit, trunk, or leaves.", "answer": "bank"},
    {"question": "Feed me and I live; give me a drink and I die.", "answer": "fire"},
    {"question": "I have a neck and two arms, yet no head or hands.", "answer": "shirt"},
    {"question": "The maker sells it, the buyer never uses it, and the user never knows they’re using it.", "answer": "coffin"},
    {"question": "I’m five letters long; remove my last four and I still sound the same.", "answer": "queue"},
]

# Maths Questions
maths = [
    {"question": "What is 15 * 6?", "answer": "90"},
    {"question": "What is (25 / 5) + 7?", "answer": "12"},
    {"question": "What is 11 * 11?", "answer": "121"},
    {"question": "What is (100 - 45)?", "answer": "55"},
    {"question": "What is 50 / 2?", "answer": "25"},
    {"question": "What is 9 * 8?", "answer": "72"},
    {"question": "What is 144 / 12?", "answer": "12"},
    {"question": "What is (200 - 175)?", "answer": "25"},
    {"question": "What is (15 + 9) * 2?", "answer": "48"},
    {"question": "What is 81 / 9?", "answer": "9"},
    {"question": "What is (30 * 3) - 45?", "answer": "45"},
    {"question": "What is (5 ** 2)?", "answer": "25"},
    {"question": "What is (7 * 7) + 14?", "answer": "63"},
    {"question": "What is 1000 / 100?", "answer": "10"},
    {"question": "What is (8 + 12) * 5?", "answer": "100"},
]

# Word Scrambles
scrambles = [
    {"question": "Unscramble: 'nohtyp'", "answer": "python"},
    {"question": "Unscramble: 'rpteucom'", "answer": "computer"},
    {"question": "Unscramble: 'atad'", "answer": "data"},
    {"question": "Unscramble: 'gnidoc'", "answer": "coding"},
    {"question": "Unscramble: 'avaj'", "answer": "java"},
    {"question": "Unscramble: 'gnimmargorp'", "answer": "programming"},
    {"question": "Unscramble: 'ahcs'", "answer": "cash"},
    {"question": "Unscramble: 'tpircsjava'", "answer": "javascript"},
    {"question": "Unscramble: 'mhtl'", "answer": "html"},
    {"question": "Unscramble: 'tpyos'", "answer": "typos"},
    {"question": "Unscramble: 'yarra'", "answer": "array"},
    {"question": "Unscramble: 'atabdaes'", "answer": "database"},
    {"question": "Unscramble: 'liunx'", "answer": "linux"},
    {"question": "Unscramble: 'krowemarf'", "answer": "framework"},
    {"question": "Unscramble: 'tenretni'", "answer": "internet"},
]

# Pools for tracking used questions
used_riddles, used_maths, used_scrambles = set(), set(), set()

def pick_unique(question_list, used_set):
    """Pick a unique question that hasn't been asked in this run."""
    available = [q for i, q in enumerate(question_list) if i not in used_set]
    if not available:  # reset if all used
        used_set.clear()
        available = question_list
    choice = random.choice(available)
    used_set.add(question_list.index(choice))
    return choice

def get_random_challenge():
    """Return one random question from each category in fixed order (Scramble, Math, Riddle)."""
    return [
        pick_unique(scrambles, used_scrambles),
        pick_unique(maths, used_maths),
        pick_unique(riddles, used_riddles),
    ]

def verify_answer(user_answer, correct_answer):
    return user_answer.strip().lower() == correct_answer.strip().lower()
