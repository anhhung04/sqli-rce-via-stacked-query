import psycopg2
import string, random, sys


def connect():
    return psycopg2.connect(dsn="dbname=app user=app password=dummy host=db-postgres")


def exec(sql, args):
    try:
        conn = connect()
        cur = conn.cursor()
        cur.execute(sql, args)
        rows = cur.fetchall()
        cur.close()
        conn.close()
    except Exception as e:
        print(e, file=sys.stderr, flush=True)
        rows = []
    return rows


def init():
    conn = connect()
    cur = conn.cursor()
    cur.execute(
        "CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, name VARCHAR(255))"
    )
    conn.commit()
    for _ in range(10):
        cur.execute(
            "INSERT INTO users (name) VALUES ('{}')".format(
                "".join(random.choices(string.ascii_letters, k=10))
            )
        )
    conn.commit()
    cur.close()
    conn.close()
