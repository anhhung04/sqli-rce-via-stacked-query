import pymssql, sys, string, random


def connect():
    return pymssql.connect(
        server="host.docker.internal",
        user="sa",
        password="Test@123",
        database="product-db",
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
        "INSERT INTO users (name) VALUES {}".format(
            ", ".join(["(%s)" for _ in range(10)])
        ),
        ["".join(random.choices(string.ascii_letters, k=10)) for _ in range(10)],
    )
