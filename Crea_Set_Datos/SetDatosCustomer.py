import psycopg2
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

# Funcion para crear la secuencia
def create_sequence():
    try:
        cursor.execute("CREATE SEQUENCE customer_id_seq START 1 INCREMENT 1")
        conn.commit()
        print("Secuencia 'customer_id_seq' creada correctamente en PostgreSQL.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error al crear la secuencia:", e)
        # Cerrar la conexion
        cursor.close()
        conn.close()

# Funcion para elminiar la secuencia
def drop_sequence():
    try:
        cursor.execute("DROP SEQUENCE customer_id_seq")
        conn.commit()
        print("Secuencia 'customer_id_seq' elminada correctamente en PostgreSQL.")
    
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

# Funcion para generar datos aleatorios de clientes
def generate_customers(num_customers):
    try:
        for _ in range(num_customers):
            firstname = fake.first_name()
            lastname = fake.last_name()
            email = fake.email()
            joindate = fake.date_time_between_dates(datetime(2023, 1, 1), datetime.now())
            
            # Insertar cliente utilizando la secuencia customer_id_seq
            cursor.execute("""
                INSERT INTO CUSTOMERS (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, JOINDATE)
                VALUES (NEXTVAL('customer_id_seq'), %s, %s, %s, %s)
            """, (firstname, lastname, email, joindate))
            conn.commit()
        
        print("Datos insertados correctamente en la base de datos.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error al insertar datos:", e)
        # Cerrar la conexion
        cursor.close()
        conn.close()

# Creacion de la secuencia
create_sequence()
    
# Generar datos de customers
generate_customers(5001)
    
# Eliminacion de la secuencia
drop_sequence()
