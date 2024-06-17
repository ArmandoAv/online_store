import psycopg2
from UpdateSQL import *
from decouple import config

# Conexion a la base de datos PostgreSQL
conn = psycopg2.connect(
    dbname=str(config('DB_NAME')),
    user=str(config('DB_USR')),
    password=str(config('DB_PWD')),
    host=str(config('DB_HOST'))
)
cursor = conn.cursor()

# Funcion para actualizar los montos
def update_amount():
    try:
        cursor.execute(update_details)
        conn.commit()
        print("Se actualiza el precio unitario correctamente")

        cursor.execute(update_orders)
        conn.commit()
        print("Se actualiza el monto total correctamente")

    except psycopg2.Error as e:
        conn.rollback()
        print("Error al crear la secuencia:", e)
        # Cerrar la conexion
        cursor.close()
        conn.close()
    
    finally:
        # Cerrar la conexion
        cursor.close()
        conn.close()

# Creacion de las secuencias
update_amount()
