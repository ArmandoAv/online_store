import psycopg2
import random
from faker import Faker
from datetime import datetime
from decouple import config

# Connection to the PostgreSQL database
conn = psycopg2.connect(
    dbname=str(config('DB_NAME')),
    user=str(config('DB_USR')),
    password=str(config('DB_PWD')),
    host=str(config('DB_HOST'))
)
cursor = conn.cursor()

# Function to create the sequence
def create_sequence():
    try:
        cursor.execute("CREATE SEQUENCE orderdet_id_seq START 1 INCREMENT 1")
        conn.commit()
        print("orderdet_id_seq successfully created in PostgreSQL.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error creating sequence:", e)
        # Closed connection
        cursor.close()
        conn.close()

# Function to drop the sequence
def drop_sequence():
    try:
        cursor.execute("DROP SEQUENCE orderdet_id_seq")
        conn.commit()
        print("orderdet_id_seq sequence successfully droped in PostgreSQL.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error creating sequence:", e)
        # Cerrar la conexion
        cursor.close()
        conn.close()
    
    finally:
        # Closed connection
        cursor.close()
        conn.close()

# Crear un generador de datos falsos
fake = Faker()

# Function to generate random order detail data
def generate_order_details(max_order_details):
    try:
        cursor.execute("SELECT MAX(PRODUCTID) AS PRODUCTID FROM PRODUCTS")
        max_product_ids = cursor.fetchone()[0]
        cursor.execute("SELECT MAX(ORDERID) AS ORDERID FROM ORDERS")
        max_order_ids = cursor.fetchone()[0]
        
        for ord in range(max_order_ids):
            order_id = random.randint(1, max_order_ids)
            unit_price = 0

            # Generar detalles de orden aleatorios
            num_details = random.randint(1, max_order_details)
            for det in range(num_details):
                product_id = random.randint(1, max_product_ids)
                quantity = random.randint(1, 80)
                
                cursor.execute("""
                    INSERT INTO ORDERDETAILS (ORDERDETAILID, ORDERID, PRODUCTID, QUANTITY, UNITPRICE)
                    VALUES (NEXTVAL('orderdet_id_seq'), %s, %s, %s, %s)
                """, (order_id, product_id, quantity, unit_price))
            
        print("Data successfully inserted into the database.")

    except psycopg2.Error as e:
        conn.rollback()
        print("Error inserting data:", e)
        # Closed connection
        cursor.close()
        conn.close()

# Sequence creation
create_sequence()

# Generate order detail data
generate_order_details(10)

# Sequence drop
drop_sequence()
