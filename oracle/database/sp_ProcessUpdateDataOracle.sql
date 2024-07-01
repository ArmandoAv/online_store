----------------------------------------------------------
------------- PROCEDURE SP_PROCESSUPDATEDATA -------------
----------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_PROCESSUPDATEDATA
IS
BEGIN
    -- Start a transaction with SERIALIZABLE isolation level
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    -- Running UPDATE under SERIALIZABLE isolation
    UPDATE ORDERS ORD
    SET TOTALAMOUNT = (
        SELECT COALESCE(SUM(DET.QUANTITY * DET.UNITPRICE), 0)
        FROM ORDERDETAILS DET
        WHERE DET.ORDERID = ORD.ORDERID
    )
    WHERE EXISTS (
        SELECT 1
        FROM ORDERDETAILS DET
        WHERE DET.ORDERID = ORD.ORDERID
    );

    -- Commit the transaction
    COMMIT;
END;
