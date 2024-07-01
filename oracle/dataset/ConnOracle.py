import cx_Oracle
from decouple import config

# Connection parameters
dsn = cx_Oracle.makedsn(str(config('DB_HOST')), str(config('DB_PORT')), service_name = str(config('DB_SERVICENAME')))

# Connection to the Oracle database
try:
    conn = cx_Oracle.connect(user = str(config('DB_USR')), password = str(config('DB_PWD')), dsn = dsn)
    
    if conn:
        print("Successful connection to Oracle.")
    
    # Close connection
    conn.close()

except cx_Oracle.Error as e:
    print(f"Connection error: {e}")
