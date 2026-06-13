#!/usr/bin/env python3
import sys
import os
import json
import sqlite3
import urllib.request

DB_PATH = os.path.expanduser("~/.cache/ollama_semantic_cache.db")
SIMILARITY_THRESHOLD = 0.85  # 85% match on core intent

def get_embedding(text):
    """Fetches text vector coordinates from local Ollama using all-minilm."""
    req = urllib.request.Request(
        "http://localhost:11434/api/embeddings",
        data=json.dumps({"model": "all-minilm", "prompt": text}).encode("utf-8"),
        headers={"Content-Type": "application/json"}
    )
    try:
        with urllib.request.urlopen(req) as res:
            return json.loads(res.read().decode("utf-8"))["embedding"]
    except Exception:
        return None

def cosine_similarity(v1, v2):
    """Calculates how closely two vector arrays align mathematically."""
    dot_product = sum(x * y for x, y in zip(v1, v2))
    norm_a = sum(x * x for x in v1) ** 0.5
    norm_b = sum(x * x for x in v2) ** 0.5
    return dot_product / (norm_a * norm_b) if (norm_a * norm_b) else 0.0

def main():
    if len(sys.argv) < 2:
        return

    action = sys.argv[1]
    user_prompt = sys.argv[2]

    os.makedirs(os.path.dirname(DB_PATH), exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()
    cursor.execute("CREATE TABLE IF NOT EXISTS semantic_cache (prompt TEXT, response TEXT, embedding TEXT);")

    # LOOKUP PHASE
    if action == "lookup":
        new_vector = get_embedding(user_prompt)
        if not new_vector:
            sys.exit(1)

        cursor.execute("SELECT prompt, response, embedding FROM semantic_cache")
        rows = cursor.fetchall()

        best_match = None
        highest_score = 0.0

        for prompt, response, embedding_str in rows:
            past_vector = json.loads(embedding_str)
            score = cosine_similarity(new_vector, past_vector)
            if score > highest_score:
                highest_score = score
                best_match = response

        if highest_score >= SIMILARITY_THRESHOLD:
            print(best_match)
            sys.exit(0) # Cache Hit!
        else:
            sys.exit(1) # Cache Miss

    # SAVE PHASE
    elif action == "save" and len(sys.argv) == 4:
        response_text = sys.argv[3]
        new_vector = get_embedding(user_prompt)
        if new_vector:
            cursor.execute(
                "INSERT INTO semantic_cache (prompt, response, embedding) VALUES (?, ?, ?)",
                (user_prompt, response_text, json.dumps(new_vector))
            )
            conn.commit()

    conn.close()

if __name__ == "__main__":
    main()
