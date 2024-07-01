import cx_Oracle
from UpdateScriptOracle import *
from decouple import config

# Connection to the Oracle database
dsn = cx_Oracle.makedsn(str(config('DB_HOST')), str(config('DB_PORT')), service_name = str(config('DB_SERVICENAME')))
conn = cx_Oracle.connect(user = str(config('DB_USR')), password = str(config('DB_PWD')), dsn = dsn)
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

    except cx_Oracle.DatabaseError as e:
        conn.rollback()
        print("Error updating amounts:", e)
    
    finally:
        # Closed connection
        cursor.close()
        conn.close()

# Sequence update
update_amount()
