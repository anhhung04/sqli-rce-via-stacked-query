from flask import Flask, request, jsonify
import postgres

app = Flask(__name__)


@app.before_request
def before_request():
    db = request.args.get("db")
    app.db = postgres


@app.route("/users", methods=["GET"])
def get_users():
    rows = app.db.exec("SELECT * FROM users", [])
    return jsonify(rows)


@app.route("/users", methods=["POST"])
def add_user():
    name = request.json["name"]
    app.db.exec("INSERT INTO users (name) VALUES (%s)", [name])
    return jsonify({"status": "ok"})


@app.route("/user", methods=["GET"])
def get_user():
    id = request.args.get("id")
    rows = app.db.exec("SELECT * FROM users WHERE id = {}".format(id), [])
    return jsonify(rows)


if __name__ == "__main__":
    postgres.init()
    app.run(host="0")
