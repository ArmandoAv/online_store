----------------------------------------------------------
------------- PROCEDURE SP_PROCESSUPDATEDATA -------------
----------------------------------------------------------

CREATE PROCEDURE SP_PROCESSUPDATEDATA
AS
BEGIN
    -- Start a transaction with SERIALIZABLE isolation level
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

    -- Running UPDATE under SERIALIZABLE isolation
    UPDATE ORDERS
    SET TOTALAMOUNT = (
        SELECT COALESCE(SUM(DET.QUANTITY * DET.UNITPRICE), 0)
        FROM ORDERDETAILS AS DET
        WHERE DET.ORDERID = ORDERS.ORDERID
    )
    WHERE EXISTS (
        SELECT 1
        FROM ORDERDETAILS AS DET
        WHERE DET.ORDERID = ORDERS.ORDERID
    )
END;
