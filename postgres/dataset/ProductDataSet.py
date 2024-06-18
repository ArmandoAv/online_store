import psycopg2
import random
from faker import Faker
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
        cursor.execute("CREATE SEQUENCE product_id_seq START 1 INCREMENT 1")
        conn.commit()
        print("product_id_seq sequence successfully created in PostgreSQL.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error creating sequence:", e)
        # Closed connection
        cursor.close()
        conn.close()

# Function to drop the sequence
def drop_sequence():
    try:
        cursor.execute("DROP SEQUENCE product_id_seq")
        conn.commit()
        print("product_id_seq sequence successfully droped in PostgreSQL.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error creating sequence:", e)
        # Closed connection
        cursor.close()
        conn.close()
    
    finally:
        # Closed connection
        cursor.close()
        conn.close()

# Create a fake data generator
fake = Faker()

# Function to generate random product data
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
        
        print("Data successfully inserted into the database.")

    except psycopg2.Error as e:
        conn.rollback()
        print("Error inserting data:", e)
        # Closed connection
        cursor.close()
        conn.close()

# Sequence creation
create_sequence()
    
# Generate product data
generate_products(1000)
    
# Sequence drop
drop_sequence()
