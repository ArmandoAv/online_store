import psycopg2
import random
from faker import Faker
from datetime import datetime
from decouple import config

# Conexion a la base de datos PostgreSQL
conn = psycopg2.connect(
    dbname=str(config('DB_NAME')),
    user=str(config('DB_USR')),
    password=str(config('DB_PWD')),
    host=str(config('DB_HOST'))
)
cursor = conn.cursor()

# Funcion para crear las secuencias
def create_sequence():
    try:
        cursor.execute("CREATE SEQUENCE order_id_seq START 1 INCREMENT 1")
        conn.commit()
        print("Secuencia 'order_id_seq' creada correctamente en PostgreSQL.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error al crear la secuencia:", e)
        # Cerrar la conexion
        cursor.close()
        conn.close()

# Funcion para elminiar las secuencias
def drop_sequence():
    try:
        cursor.execute("DROP SEQUENCE order_id_seq")
        conn.commit()
        print("Secuencia 'order_id_seq' elminada correctamente en PostgreSQL.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error al eliminar la secuencia:", e)
        # Cerrar la conexion
        cursor.close()
        conn.close()
    
    finally:
        # Cerrar la conexion
        cursor.close()
        conn.close()

# Crear un generador de datos falsos
fake = Faker()

# Funcion para generar datos aleatorios de ordenes y detalles de ordenes
def generate_orders_and_details(num_orders):
    try:
        cursor.execute("SELECT MAX(CUSTOMERID) AS CUSTOMERID FROM CUSTOMERS")
        max_customer_ids = cursor.fetchone()[0]
        
        for _ in range(num_orders):
            customer_id = random.randint(1, max_customer_ids)
            order_date = fake.date_time_between(start_date=datetime(2023, 1, 1), end_date=datetime.now())
            total_amount = 0
            
            # Insertar orden
            cursor.execute("""
                INSERT INTO ORDERS (ORDERID, CUSTOMERID, ORDERDATE, TOTALAMOUNT)
                VALUES (NEXTVAL('order_id_seq'), %s, %s, %s)
                RETURNING ORDERID
            """, (customer_id, order_date, total_amount))
            
        print("Datos insertados correctamente en la base de datos.")

    except psycopg2.Error as e:
        conn.rollback()
        print("Error al insertar datos:", e)
        # Cerrar la conexion
        cursor.close()
        conn.close()

# Creacion de las secuencias
create_sequence()

# Generar datos de ordenes y detalle de ordenes
generate_orders_and_details(40000)

# Eliminacion de la secuencia
drop_sequence()
