from flask import Flask, request, jsonify
import sqlite3

app = Flask(__name__)

DATABASE = "database.db"

def init_db():
    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT UNIQUE NOT NULL,
            password TEXT NOT NULL
        )
    """)

    cursor.execute("SELECT * FROM users WHERE username=?", ("test",))
    if not cursor.fetchone():
        cursor.execute("INSERT INTO users (username, password) VALUES (?, ?)", ("test", "test@123"))
        print("Inserted default user: test / test@123")
        
    conn.commit()
    conn.close()

@app.route("/", methods=["GET"])
def home():
    return "Flask backend is running!", 200

@app.route("/login", methods=["POST"])
def login():
    data = request.get_json()
    username = data.get("username")
    password = data.get("password")

    conn = sqlite3.connect(DATABASE)
    cursor = conn.cursor()
    cursor.execute("SELECT * FROM users WHERE username=? AND password=?", (username, password))
    user = cursor.fetchone()
    conn.close()

    if user:
        return f"Welcome {username}!", 200
    return "Invalid credentials", 401

@app.route("/api/healthcheck", methods=["GET"])
def healthcheck():
    return jsonify({"status": "OK"}), 200    

if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=80, debug=True)
