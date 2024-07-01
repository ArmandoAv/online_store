import pyodbc
from decouple import config

# Connection to the SQL Server database
try:
    conn = pyodbc.connect('DRIVER={SQL Server};'
                          'SERVER=' + str(config('DB_HOST')) + ';'
                          'DATABASE=' + str(config('DB_NAME')) + ';'
                          'UID=' + str(config('DB_USR')) + ';'
                          'PWD=' + str(config('DB_PWD')) + ';')

    if conn:
        print("Successful connection to SQL Server.")
    
    # Close connection
    conn.close()

except pyodbc.Error as e:
    print(f"Connection error: {e}")
