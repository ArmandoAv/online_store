import psycopg2
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
        cursor.execute("CREATE SEQUENCE customer_id_seq START 1 INCREMENT 1")
        conn.commit()
        print("customer_id_seq sequence successfully created in PostgreSQL.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error creating sequence:", e)
        # Closed connection
        cursor.close()
        conn.close()

# Function to drop the sequence
def drop_sequence():
    try:
        cursor.execute("DROP SEQUENCE customer_id_seq")
        conn.commit()
        print("customer_id_seq sequence successfully droped in PostgreSQL.")
    
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

# Function to generate random order data
def generate_customers(num_customers):
    try:
        for _ in range(num_customers):
            firstname = fake.first_name()
            lastname = fake.last_name()
            email = fake.email()
            joindate = fake.date_time_between_dates(datetime(2023, 1, 1), datetime.now())
            
            cursor.execute("""
                INSERT INTO CUSTOMERS (CUSTOMERID, FIRSTNAME, LASTNAME, EMAIL, JOINDATE)
                VALUES (NEXTVAL('customer_id_seq'), %s, %s, %s, %s)
            """, (firstname, lastname, email, joindate))
            conn.commit()
        
        print("Data successfully inserted into the database.")
    
    except psycopg2.Error as e:
        conn.rollback()
        print("Error inserting data:", e)
        # Closed connection
        cursor.close()
        conn.close()

# Sequence creation
create_sequence()
    
# Generate customer data
generate_customers(5001)
    
# Sequence drop
drop_sequence()
