----------------------------------------------------------
------------- PROCEDURE SP_PROCESSUPDATEDATA -------------
----------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_PROCESSUPDATEDATA()
LANGUAGE plpgsql
AS $$
DECLARE
    RETRY_COUNT INT := 0;
BEGIN
    -- Intentar ejecutar el proceso principal con retry en caso de deadlock
    -- Se puede intentar un máximo de 5 veces
    WHILE RETRY_COUNT < 5 LOOP
        -- Inicia un nuevo procesamiento de informacion
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

            -- Confirma la transaccion
            COMMIT;

            -- Si no hubo errores, salir del bucle de retry
            EXIT WHEN NOT FOUND;

            -- Incrementar el contador de retry
            RETRY_COUNT := RETRY_COUNT + 1;
            
            -- Calcular el tiempo de espera (reintento exponencial)
            PERFORM pg_sleep(2^RETRY_COUNT);
        END;
    END LOOP;
    
    -- Verificar el recuento de intentos despues del bucle
    IF RETRY_COUNT >= 5 THEN
        RAISE EXCEPTION 'Demasiados intentos de retry debido a deadlock. Revisar proceso.';
    END IF;
END;
$$;
