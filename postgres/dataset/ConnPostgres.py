import psycopg2
from decouple import config

# Connection to the Postgres database
try:
    conn = psycopg2.connect(dbname=str(config('DB_NAME')),
                            user=str(config('DB_USR')),
                            password=str(config('DB_PWD')),
                            host=str(config('DB_HOST')))

    if conn:
        print("Successful connection to Postgres.")
    
    # Close connection
    conn.close()

except psycopg2.Error as e:
    print(f"Connection error: {e}")
