import psycopg2
from UpdateScriptPostgres import *
from decouple import config

# Connection to the PostgreSQL database
conn = psycopg2.connect(
    dbname=str(config('DB_NAME')),
    user=str(config('DB_USR')),
    password=str(config('DB_PWD')),
    host=str(config('DB_HOST'))
)
cursor = conn.cursor()

# Function to update the amounts
def update_amount():
    try:
        cursor.execute(update_details)
        conn.commit()
        print("The unit price is updated correctly.")

        cursor.execute(update_orders)
        conn.commit()
        print("The total amount is updated correctly.")

    except psycopg2.Error as e:
        conn.rollback()
        print("Error updating amounts:", e)
        # Closed connection
        cursor.close()
        conn.close()
    
    finally:
        # Closed connection
        cursor.close()
        conn.close()

# Sequence update
update_amount()
