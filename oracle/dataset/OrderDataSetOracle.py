import cx_Oracle
import random
from faker import Faker
from datetime import datetime
from decouple import config

# Connection to the Oracle database
dsn = cx_Oracle.makedsn(str(config('DB_HOST')), str(config('DB_PORT')), service_name = str(config('DB_SERVICENAME')))
conn = cx_Oracle.connect(user = str(config('DB_USR')), password = str(config('DB_PWD')), dsn = dsn)
cursor = conn.cursor()

# Function to create the sequence
def create_sequence():
    try:
        cursor.execute("CREATE SEQUENCE order_id_seq START WITH 1 INCREMENT BY 1")
        conn.commit()
        print("order_id_seq sequence successfully created in Oracle.")
    
    except cx_Oracle.DatabaseError as e:
        conn.rollback()
        print("Error creating sequence:", e)
        # Closed connection
        cursor.close()
        conn.close()

# Function to drop the sequence
def drop_sequence():
    try:
        cursor.execute("DROP SEQUENCE order_id_seq")
        conn.commit()
        print("order_id_seq sequence successfully droped in Oracle.")
    
    except cx_Oracle.DatabaseError as e:
        conn.rollback()
        print("Error creating sequence:", e)
    
    finally:
        # Closed connection
        cursor.close()
        conn.close()

# Crear un generador de datos falsos
fake = Faker()

# Function to generate random order data
def generate_orders(num_orders):
    try:
        cursor.execute("SELECT MAX(CUSTOMERID) AS CUSTOMERID FROM CUSTOMERS")
        max_customer_ids = cursor.fetchone()[0]
        
        for _ in range(num_orders):
            customer_id = random.randint(1, max_customer_ids)
            order_date = fake.date_time_between(start_date=datetime(2023, 1, 1), end_date=datetime.now())
            total_amount = 0
            
            cursor.execute("""
                INSERT INTO ORDERS (ORDERID, CUSTOMERID, ORDERDATE, TOTALAMOUNT)
                VALUES (order_id_seq.NEXTVAL, :1, :2, :3)
            """, (customer_id, order_date, total_amount))
            conn.commit()
            
        print("Data successfully inserted into the database.")

    except cx_Oracle.DatabaseError as e:
        conn.rollback()
        print("Error inserting data:", e)
        # Closed connection
        cursor.close()
        conn.close()

# Sequence creation
create_sequence()

# Generate order data
generate_orders(40000)

# Sequence drop
drop_sequence()