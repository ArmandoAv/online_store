import psycopg2
import random
from faker import Faker
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
        cursor.execute("CREATE SEQUENCE product_id_seq START 1 INCREMENT 1")
        conn.commit()
        print("Secuencia 'product_id_seq' creada correctamente en PostgreSQL.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error al crear la secuencia:", e)
        # Cerrar la conexion
        cursor.close()
        conn.close()

# Funcion para elminiar la secuencia
def drop_sequence():
    try:
        cursor.execute("DROP SEQUENCE product_id_seq")
        conn.commit()
        print("Secuencia 'product_id_seq' elminada correctamente en PostgreSQL.")
    
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

# Funcion para generar datos aleatorios de productos
def generate_products(num_products):
    try:
        categories = [
            'Computadoras', 'Tablets', 'Celulares', 'Relojes Inteligentes', 
            'Pantallas', 'Videojuegos', 'Lavadoras'
        ]
        for _ in range(num_products):
            productname = fake.text(max_nb_chars=50)
            category = random.choice(categories)
            price = round(random.uniform(10, 500), 2)
            
            cursor.execute("""
                INSERT INTO PRODUCTS (PRODUCTID, PRODUCTNAME, CATEGORY, PRICE)
                VALUES (NEXTVAL('product_id_seq'), %s, %s, %s)
            """, (productname, category, price))
        
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
generate_products(1000)
    
# Eliminacion de la secuencia
drop_sequence()
