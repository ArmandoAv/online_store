import cx_Oracle
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
        cursor.execute("CREATE SEQUENCE customer_id_seq START WITH 1 INCREMENT BY 1")
        conn.commit()
        print("customer_id_seq sequence successfully created in Oracle.")
    
    except cx_Oracle.DatabaseError as e:
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
        print("customer_id_seq sequence successfully droped in Oracle.")
    
    except cx_Oracle.DatabaseError as e:
        conn.rollback()
        print("Error creating sequence:", e)
    
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
                VALUES (customer_id_seq.NEXTVAL, :1, :2, :3, :4)
            """, (firstname, lastname, email, joindate))
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

# Generate customer data
generate_customers(5000)

# Sequence drop
drop_sequence()
