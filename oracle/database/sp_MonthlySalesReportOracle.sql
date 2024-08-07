-----------------------------------------------------------
------------- SP_MONTHLYSALESREPORT PROCEDURE -------------
-----------------------------------------------------------

CREATE OR REPLACE PROCEDURE SP_MONTHLYSALESREPORT (
    p_STARTDATE IN DATE,
    p_ENDDATE IN DATE
)
IS
BEGIN
	DELETE 
	FROM   MONTHLYSALESREPORT
	WHERE  ORDERDATE >= p_STARTDATE
	AND    ORDERDATE <= p_ENDDATE;
	
	INSERT INTO MONTHLYSALESREPORT (YEAR, MONTH, ORDERDATE, QUANTITY, TOTALAMOUNT)
	SELECT EXTRACT(YEAR FROM ORD.ORDERDATE) AS YEAR,
	       EXTRACT(MONTH FROM ORD.ORDERDATE) AS MONTH,
	       TRUNC(ORD.ORDERDATE) AS ORDERDATE,
	       SUM(DET.QUANTITY) AS QUANTITY,
	       SUM(DET.QUANTITY * DET.UNITPRICE) AS TOTALAMOUNT
	FROM   ORDERS ORD
	INNER JOIN ORDERDETAILS DET
	ON     ORD.ORDERID = DET.ORDERID
	WHERE  TRUNC(ORD.ORDERDATE) >= p_STARTDATE
	AND    TRUNC(ORD.ORDERDATE) <= p_ENDDATE
	GROUP BY EXTRACT(YEAR FROM ORD.ORDERDATE),
	       EXTRACT(MONTH FROM ORD.ORDERDATE),
	       TRUNC(ORD.ORDERDATE);
END SP_MONTHLYSALESREPORT;

----------------------------------------------------
------------- MONTHLYSALESREPORT TABLE -------------
----------------------------------------------------

CREATE TABLE MONTHLYSALESREPORT
(
    YEAR NUMERIC,
	MONTH NUMERIC,
	ORDERDATE DATE,
    QUANTITY NUMERIC,
    TOTALAMOUNT NUMERIC(20,2)
)
TABLESPACE USERS_DATA
;
