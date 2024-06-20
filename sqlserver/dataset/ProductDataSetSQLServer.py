import pyodbc
import random
from faker import Faker
from decouple import config

# Connection to the SQL Server database
conn = pyodbc.connect('DRIVER={SQL Server};'
                      'SERVER=' + str(config('DB_HOST')) + ';'
                      'DATABASE=' + str(config('DB_NAME')) + ';'
                      'UID=' + str(config('DB_USR')) + ';'
                      'PWD=' + str(config('DB_PWD')) + ';')
cursor = conn.cursor()

# Function to create the sequence
def create_sequence():
    try:
        cursor.execute("CREATE SEQUENCE product_id_seq START WITH 1 INCREMENT BY 1")
        conn.commit()
        print("product_id_seq sequence successfully created in SQL Server.")
    
    except pyodbc.Error as e:
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
        print("product_id_seq sequence successfully droped in SQL Server.")
    
    except pyodbc.Error as e:
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
                VALUES (NEXT VALUE FOR product_id_seq, ?, ?, ?)
            """, (productname, category, price))
        
        print("Data successfully inserted into the database.")

    except pyodbc.Error as e:
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
