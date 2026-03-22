"""
Online Voting System - Flask + MySQL Backend
Run: python app.py
"""

from flask import Flask, request, jsonify, render_template, session
from flask_cors import CORS
import mysql.connector
import hashlib
import os
from datetime import timedelta

app = Flask(__name__)
app.secret_key = os.urandom(24)           # change to a fixed string in production
app.permanent_session_lifetime = timedelta(minutes=30)
CORS(app, supports_credentials=True)

# ── MySQL Config ────────────────────────────────────────────────────────────
DB_CONFIG = {
    "host":     "localhost",
    "user":     "root",          # ← change to your MySQL username
    "password": "root",              # ← change to your MySQL password
    "database": "voting_system"
}

def get_db():
    return mysql.connector.connect(**DB_CONFIG)

def hash_pw(password: str) -> str:
    return hashlib.sha256(password.encode()).hexdigest()


# ── Hash all plain-text passwords on startup ───────────────────────────────
def migrate_passwords():
    """One-time migration: hash any plain-text passwords in DB."""
    con = get_db()
    cur = con.cursor(dictionary=True)

    # Voters
    cur.execute("SELECT id, password FROM voters")
    for row in cur.fetchall():
        pw = row["password"]
        if len(pw) != 64:
            hashed = hash_pw(pw)
            cur.execute("UPDATE voters SET password=%s WHERE id=%s", (hashed, row["id"]))

    # Admins
    cur.execute("SELECT username, password FROM admins")
    for row in cur.fetchall():
        pw = row["password"]
        if len(pw) != 64:
            hashed = hash_pw(pw)
            cur.execute("UPDATE admins SET password=%s WHERE username=%s",
                        (hashed, row["username"]))

    con.commit()
    cur.close()
    con.close()
    print("✅ Password migration done.")


# ── Serve HTML ───────────────────────────────────────────────────────────────
@app.route("/")
def index():
    return render_template("index.html")


# ── VOTER LOGIN ──────────────────────────────────────────────────────────────
@app.route("/api/voter/login", methods=["POST"])
def voter_login():
    data     = request.json
    voter_id = data.get("voter_id", "").strip()
    password = data.get("password", "").strip()

    if not voter_id or not password:
        return jsonify({"success": False, "message": "Voter ID and Password required"}), 400

    con = get_db()
    cur = con.cursor(dictionary=True)
    cur.execute("SELECT * FROM voters WHERE id = %s", (voter_id,))
    voter = cur.fetchone()
    cur.close()
    con.close()

    if not voter:
        return jsonify({"success": False, "message": "Invalid Voter ID or Password!"}), 401

    if voter["password"] != hash_pw(password):
        return jsonify({"success": False, "message": "Invalid Voter ID or Password!"}), 401

    if voter["has_voted"]:
        return jsonify({"success": False, "message": "You have already voted!"}), 403

    session.permanent = True
    session["voter_id"] = voter_id
    session["role"]     = "voter"

    return jsonify({"success": True, "message": "Login successful"})


# ── SUBMIT VOTE ──────────────────────────────────────────────────────────────
@app.route("/api/vote", methods=["POST"])
def submit_vote():
    if session.get("role") != "voter":
        return jsonify({"success": False, "message": "Unauthorized"}), 401

    data      = request.json
    candidate = data.get("candidate", "").strip().upper()
    voter_id  = session["voter_id"]

    if candidate not in ("A", "B", "C", "D"):
        return jsonify({"success": False, "message": "Invalid candidate"}), 400

    con = get_db()
    cur = con.cursor(dictionary=True)

    cur.execute("SELECT has_voted FROM voters WHERE id = %s", (voter_id,))
    voter = cur.fetchone()

    if not voter or voter["has_voted"]:
        cur.close(); con.close()
        return jsonify({"success": False, "message": "Already voted or invalid voter"}), 403

    cur.execute(
        "INSERT INTO votes (voter_id, candidate) VALUES (%s, %s)",
        (voter_id, candidate)
    )
    cur.execute(
        "UPDATE candidates SET vote_count = vote_count + 1 WHERE letter = %s",
        (candidate,)
    )
    cur.execute(
        "UPDATE voters SET has_voted = TRUE, voted_at = NOW() WHERE id = %s",
        (voter_id,)
    )
    con.commit()
    cur.close()
    con.close()

    session.clear()
    return jsonify({"success": True, "message": "Vote submitted successfully!"})


# ── ADMIN LOGIN ───────────────────────────────────────────────────────────────
@app.route("/api/admin/login", methods=["POST"])
def admin_login():
    data     = request.json
    username = data.get("username", "").strip()
    password = data.get("password", "").strip()

    con = get_db()
    cur = con.cursor(dictionary=True)
    cur.execute("SELECT * FROM admins WHERE username = %s", (username,))
    admin = cur.fetchone()
    cur.close()
    con.close()

    if not admin or admin["password"] != hash_pw(password):
        return jsonify({"success": False, "message": "Invalid Admin credentials!"}), 401

    session.permanent = True
    session["role"]   = "admin"

    return jsonify({"success": True, "message": "Admin login successful"})


# ── GET RESULTS (admin only) ──────────────────────────────────────────────────
@app.route("/api/results", methods=["GET"])
def get_results():
    if session.get("role") != "admin":
        return jsonify({"success": False, "message": "Unauthorized"}), 401

    con = get_db()
    cur = con.cursor(dictionary=True)

    # ✅ FIX: Get vote_count directly from votes table (always accurate)
    cur.execute("""
        SELECT c.letter, c.name, c.color,
               COUNT(v.id) AS vote_count
        FROM candidates c
        LEFT JOIN votes v ON v.candidate = c.letter
        GROUP BY c.letter, c.name, c.color
        ORDER BY c.letter
    """)
    candidates = cur.fetchall()

    # Total registered voters
    cur.execute("SELECT COUNT(*) AS total FROM voters")
    total_voters = cur.fetchone()["total"]

    # ✅ FIX: Total votes = actual rows in votes table
    cur.execute("SELECT COUNT(*) AS total FROM votes")
    total_votes = cur.fetchone()["total"]

    cur.close()
    con.close()

    # Determine winner(s)
    max_votes = max(c["vote_count"] for c in candidates)
    winners   = [c["name"] for c in candidates if c["vote_count"] == max_votes]

    # ✅ FIX: If no votes cast, no winner yet
    if total_votes == 0:
        winners = ["No votes cast yet"]

    return jsonify({
        "success":      True,
        "candidates":   candidates,
        "total_voters": total_voters,
        "total_votes":  total_votes,
        "winners":      winners
    })


# ── RESET ELECTION (admin only) ───────────────────────────────────────────────
@app.route("/api/reset", methods=["POST"])
def reset_election():
    """
    ✅ NEW: Properly resets all vote data so everything stays in sync.
    Call this from MySQL or add a Reset button in admin panel.
    """
    if session.get("role") != "admin":
        return jsonify({"success": False, "message": "Unauthorized"}), 401

    con = get_db()
    cur = con.cursor()

    cur.execute("DELETE FROM votes")                              # clear all votes
    cur.execute("UPDATE candidates SET vote_count = 0")          # reset candidate counts
    cur.execute("UPDATE voters SET has_voted = FALSE, voted_at = NULL")  # reset voter flags

    con.commit()
    cur.close()
    con.close()

    return jsonify({"success": True, "message": "Election reset successfully!"})


# ── LOGOUT ─────────────────────────────────────────────────────────────────────
@app.route("/api/logout", methods=["POST"])
def logout():
    session.clear()
    return jsonify({"success": True})


# ── MAIN ───────────────────────────────────────────────────────────────────────
if __name__ == "__main__":
    migrate_passwords()
    app.run(debug=True)