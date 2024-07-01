---------------------------------------------------
------------- COMMON TABLE EXPRESSION -------------
---------------------------------------------------

WITH CTE_PRODUCTCATEGORY AS (
	SELECT PRO.CATEGORY,
	       EXTRACT(YEAR FROM ORDERDATE) AS YEAR,
	       DET.QUANTITY,
		   DET.QUANTITY * DET.UNITPRICE AS TOTALAMOUNT
	FROM   PRODUCTS PRO
	INNER JOIN ORDERDETAILS DET
	ON     PRO.PRODUCTID = DET.PRODUCTID
	INNER JOIN ORDERS ORD
	ON     DET.ORDERID = ORD.ORDERID
	WHERE  EXTRACT(YEAR FROM ORDERDATE) = 2023 
)
SELECT CATEGORY,
       YEAR,
	   SUM(QUANTITY) AS QUANTITY,
	   SUM(TOTALAMOUNT) AS TOTALAMOUNT
FROM   CTE_PRODUCTCATEGORY
GROUP BY CATEGORY,
       YEAR;
