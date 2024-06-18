----------------------------------------------------------
------------- PROCEDURE SP_PROCESSUPDATEDATA -------------
----------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_PROCESSUPDATEDATA()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Start a transaction with SERIALIZABLE isolation level
    SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

    -- Running UPDATE under SERIALIZABLE isolation
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
	);

	COMMIT;

END;
$$;
