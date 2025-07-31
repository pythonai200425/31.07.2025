import psycopg2
import psycopg2.extras

try:
    conn = psycopg2.connect(
        dbname='postgres',
        user='postgres',
        password='admin',
        host='localhost',
        port='5432',
        cursor_factory=psycopg2.extras.RealDictCursor
    )
    print("Connected successfully.")
except psycopg2.Error as e:
    print("Connection error:", e)

try:
    cur = conn.cursor()
    cur.execute("""
        CREATE TABLE IF NOT EXISTS users (
            id SERIAL PRIMARY KEY,
            name TEXT NOT NULL,
            email TEXT UNIQUE NOT NULL
        );
    """)
    conn.commit()
    print("Table created (or already exist).")
except psycopg2.Error as e:
    print("Error creating table:", e)
finally:
    cur.close()

# try:
#     cur = conn.cursor()
#     cur.execute(
#         "INSERT INTO users (name, email) VALUES (%s, %s)",
#         ("Alice", "alice@example.com")
#     )
#     conn.commit()
#     print("Data inserted.")
# except psycopg2.Error as e:
#     print("Insert error:", e)
# finally:
#     cur.close()

try:
    cur = conn.cursor()
    cur.execute("SELECT * FROM users")
    rows = cur.fetchall()
    for row in rows:
        print(dict(row))
except psycopg2.Error as e:
    print("Select error:", e)
finally:
    cur.close()

################ stored procedure
print("\nMovies:")
try:
    cur = conn.cursor()
    cur.execute("SELECT * FROM sp_get_all_movies()")
    rows = cur.fetchall()
    for row in rows:
        print(dict(row))
except psycopg2.Error as e:
    print("Select error:", e)
finally:
    cur.close()

# conn.close()
print("Connection closed.")