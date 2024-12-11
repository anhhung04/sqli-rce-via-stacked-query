import mysql.connector as connector
import string, random, sys


def connect():
    return connector.connect(
        host="db-mysql", user="app", password="dummy", database="app"
    )


def exec(sql, args):
    try:
        conn = connect()
        cursor = conn.cursor()
        cursor.execute(sql, args)
        conn.commit()
        return cursor.fetchall()
    except Exception as e:
        print(e, file=sys.stderr, flush=True)
        return []


def init():
    is_connect = False
    while not is_connect:
        try:
            _ = connect()
            is_connect = True
        except:
            pass
    exec(
        "CREATE TABLE IF NOT EXISTS users (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, name VARCHAR(255))",
        [],
    )
    exec(
        "INSERT INTO users (name) VALUES {}".format(
            ", ".join(["(%s)" for _ in range(10)])
        ),
        ["".join(random.choices(string.ascii_letters, k=10)) for _ in range(10)],
    )
