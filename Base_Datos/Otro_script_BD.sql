que el repositorio este versionado

CTE command table expression

    dbname="TIENDA_ONLINE",
    user="postgres",
    password="etl091079",
    host="localhost"

psql -U postgres -d postgres

CREATE DATABASE TIENDA_ONLINE;


--- Nueva etapa

CREATE OR REPLACE FUNCTION CHECK_QUANTITY()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.QUANTITY <= 0 THEN
        RAISE EXCEPTION 'El valor en la columna QUANTITY no puede ser negativa o cero';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER CHECK_QUANTITY_TRIGGER
	BEFORE INSERT ON ORDERDETAILS
	FOR EACH ROW
	EXECUTE FUNCTION CHECK_QUANTITY();


CREATE OR REPLACE FUNCTION FN_CALCULATEDISCOUNT(
    PRODUCTID INTEGER,
    QUANTITY INTEGER
)
RETURNS DECIMAL AS
$$
DECLARE
    DISCOUNT DECIMAL := 0.00;
BEGIN
    IF QUANTITY >= 50 THEN
        DISCOUNT := 0.25; -- 25% DE DESCUENTO
    ELSIF QUANTITY >= 20 THEN
        DISCOUNT := 0.20; -- 20% DE DESCUENTO
    ELSIF QUANTITY >= 10 THEN
        DISCOUNT := 0.10; -- 10% DE DESCUENTO
    END IF;

    RETURN DISCOUNT;
END;
$$
LANGUAGE plpgsql;


SELECT DET.ORDERDETAILID,
       DET.PRODUCTID, 
       DET.QUANTITY, 
       fn_CalculateDiscount(PRODUCTID, QUANTITY)
FROM (SELECT ORDERDETAILID,
	         PRODUCTID,
             QUANTITY
      FROM   ORDERDETAILS) AS DET
;

-----

CREATE OR REPLACE FUNCTION FN_ACTIVECUSTOMERS()
RETURNS TABLE (
    CUSTOMERID INTEGER,
    FIRSTNAME VARCHAR(250),
    LASTNAME VARCHAR(250),
    EMAIL VARCHAR(250),
    ORDERID INTEGER,
    ORDERDATE DATE,
    TOTALAMOUNT DECIMAL(20,2)
)
AS $$
BEGIN
    RETURN QUERY 
    SELECT CUST.CUSTOMERID,
           CUST.FIRSTNAME,
           CUST.LASTNAME,
           CUST.EMAIL,
           ORD.ORDERID,
           ORD.ORDERDATE,
           ORD.TOTALAMOUNT
    FROM CUSTOMERS AS CUST
    INNER JOIN ORDERS AS ORD
    ON    CUST.CUSTOMERID = ORD.CUSTOMERID
    WHERE ORD.ORDERDATE > CURRENT_DATE - INTERVAL '6 MONTHS';
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION FN_ACTIVECUSTOMERS()
RETURNS TABLE (
    CUSTOMERID INTEGER,
    FIRSTNAME VARCHAR(250),
    LASTNAME VARCHAR(250),
    EMAIL VARCHAR(250),
    ORDERID INTEGER,
    ORDERDATE DATE,
    TOTALAMOUNT DECIMAL(20,2),
    PRODUCTID INTEGER,
    PRODUCTNAME VARCHAR(500),
    QUANTITY INTEGER,
    CATEGORY VARCHAR(500),
    PRICE DECIMAL(20,2)
)
AS $$
BEGIN
    RETURN QUERY 
    SELECT CUST.CUSTOMERID,
           CUST.FIRSTNAME,
           CUST.LASTNAME,
           CUST.EMAIL,
           ORD.ORDERID,
           ORD.ORDERDATE,
           ORD.TOTALAMOUNT,
           DET.PRODUCTID,
           PRD.PRODUCTNAME,
           DET.QUANTITY,
           PRD.CATEGORY,
           PRD.PRICE
    FROM CUSTOMERS AS CUST
    INNER JOIN ORDERS AS ORD
    ON    CUST.CUSTOMERID = ORD.CUSTOMERID
	LEFT JOIN ORDERDETAILS AS DET
	ON    ORD.ORDERID = DET.ORDERID
	LEFT JOIN PRODUCTS AS PRD
	ON    DET.PRODUCTID = PRD.PRODUCTID
    WHERE ORD.ORDERDATE > CURRENT_DATE - INTERVAL '6 MONTHS';
END;
$$ LANGUAGE plpgsql;

-----
---- ESTA BIEN PORQUE UNA ORDEN PUEDE TENER VARIAS CATEGORIAS

WITH PRODUCT_CATEGORIES AS (
    SELECT PRD.CATEGORY,
           EXTRACT(YEAR FROM ORD.ORDERDATE) AS YEAR,
           SUM(DET.QUANTITY) AS TOTALQUANTITY,
           SUM(DET.QUANTITY * DET.UNITPRICE) AS TOTALAMOUNT
    FROM  PRODUCTS AS PRD
    INNER JOIN ORDERDETAILS AS DET 
	ON    PRD.PRODUCTID = DET.PRODUCTID
    INNER JOIN ORDERS AS ORD 
	ON    DET.ORDERID = ORD.ORDERID
    WHERE EXTRACT(YEAR FROM ORD.ORDERDATE) = 2023
    GROUP BY PRD.CATEGORY, 
	      YEAR
)
SELECT *
FROM PRODUCT_CATEGORIES
ORDER BY CATEGORY;


----

CREATE OR REPLACE PROCEDURE PROCESS_UPDATE_DATA()
LANGUAGE plpgsql
AS $$
DECLARE
    RETRY_COUNT INT := 0;
BEGIN
    -- Intentar ejecutar el proceso principal con retry en caso de deadlock
    -- Se puede intentar un máximo de 5 veces
    WHILE RETRY_COUNT < 5 LOOP
        -- Iniciar una nueva transacción
        BEGIN
            -- Procesamiento con grandes volúmenes de datos en lotes de 10000 registros
            UPDATE ORDERS AS ORD
            SET TOTALAMOUNT = (
                SELECT COALESCE(SUM(DET.QUANTITY * DET.UNITPRICE), 0)
                FROM ORDERDETAILS AS DET
                WHERE DET.ORDERID = ORD.ORDERID
            )
            WHERE EXISTS (
                SELECT 1
                FROM ORDERDETAILS AS DET
                WHERE DET.ORDERID = ORD.ORDERID
                LIMIT 10000
            );

            -- Confirmar la transacción
            COMMIT;

            -- Si no hubo errores, salir del bucle de retry
            EXIT WHEN NOT FOUND;

            -- Incrementar el contador de retry
            RETRY_COUNT := RETRY_COUNT + 1;
            
            -- Calcular el tiempo de espera (reintento exponencial)
            PERFORM pg_sleep(2^RETRY_COUNT);  -- Esperar 2^retry_count segundos
        END;
    END LOOP;
    
    -- Verificar el recuento de intentos después del bucle
    IF RETRY_COUNT >= 5 THEN
        RAISE EXCEPTION 'Demasiados intentos de retry debido a deadlock. Revisar proceso.';
    END IF;
END;
$$;


CALL PROCESS_UPDATE_DATA();


Explicación del código:
retry_count: Variable que cuenta los intentos de retry debido a deadlocks.
WHILE loop: El stored procedure intentará procesar los datos en lotes (LIMIT 1000 como ejemplo) y manejará cualquier deadlock detectado.
BEGIN; - COMMIT; Bloque de transacción que encapsula la lógica de procesamiento de datos. Si se detecta un deadlock (deadlock_detected), el código captura la excepción y ejecuta un retry con un retraso incremental utilizando pg_sleep. El tiempo de espera aumenta exponencialmente con cada intento (EXP(2, retry_count)).
IF retry_count >= 5 THEN: Si se supera el número máximo de intentos de retry, el stored procedure puede lanzar una excepción personalizada o manejar el caso según sea necesario.

Consideraciones adicionales:
Ajusta el número máximo de intentos (retry_count) y el tiempo de espera (retraso incremental) según las necesidades y las características de tu aplicación.
Monitorea y registra los errores de deadlock para entender mejor las causas subyacentes y ajustar tu estrategia de manejo de deadlocks en consecuencia.
Asegúrate de que el código del stored procedure maneje adecuadamente cualquier otro tipo de error que pueda ocurrir durante el procesamiento de los datos.


----

UPDATE ORDERS AS ORD
SET TOTAL_AMOUNT = (
    SELECT SUM(DET.QUANTITY * DET.UNIT_PRICE)
    FROM ORDER_DETAILS AS DET
    WHERE DET.ORDER_ID = ORD.ORDER_ID
)
WHERE EXISTS (
    SELECT 1
    FROM ORDER_DETAILS AS DET
    WHERE DET.ORDER_ID = ORD.ORDER_ID


----

UPDATE tabla1 AS t1
SET campo_actualizar = t2.campo_fuente
FROM tabla2 AS t2
WHERE t1.id = 1 AND t2.id = 1;


            UPDATE ORDERS AS ORD
            SET TOTALAMOUNT = (
                SELECT SUM(DET.QUANTITY * DET.UNITPRICE)
                FROM ORDERDETAILS AS DET
                WHERE DET.ORDERID = ORD.ORDERID
            )
            WHERE EXISTS (
                SELECT 1
                FROM ORDERDETAILS AS DET
                WHERE DET.ORDERID = ORD.ORDERID