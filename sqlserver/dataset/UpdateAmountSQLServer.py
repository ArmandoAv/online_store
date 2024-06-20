import pyodbc
from UpdateScriptSQLServer import *
from decouple import config

# Connection to the SQL Server database
conn = pyodbc.connect('DRIVER={SQL Server};'
                      'SERVER=' + str(config('DB_HOST')) + ';'
                      'DATABASE=' + str(config('DB_NAME')) + ';'
                      'UID=' + str(config('DB_USR')) + ';'
                      'PWD=' + str(config('DB_PWD')) + ';')
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

    except pyodbc.Error as e:
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
