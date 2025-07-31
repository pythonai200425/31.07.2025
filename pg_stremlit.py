import streamlit as st
import psycopg2
import psycopg2.extras


st.title("Hello PostgreSQL")


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
    cur.execute("SELECT * FROM users")
    rows = cur.fetchall()
    for row in rows:
        st.write(f"{row['id']}  {row['name']}  {row['email']}")


    ############## nice print:
    # output = ""
    # for row in rows:
    #     output += f"{row['id']:5}  {row['name']:10}  {row['email']:20}\n"
    # st.markdown(f"```text\n{output}\n```")


except psycopg2.Error as e:
    print("Select error:", e)
finally:
    cur.close()

# conn.close()
print("Connection closed.")

