-------------------------------------------------------
------------- FUNCTION FN_ACTIVECUSTOMERS -------------
-------------------------------------------------------
---------------------------------------------------
------------- COMMON TABLE EXPRESSION -------------
---------------------------------------------------

WITH PRODUCT_CATEGORIES AS (
    SELECT PRD.CATEGORY,
           EXTRACT(YEAR FROM ORD.ORDERDATE) AS YEAR,
           DET.QUANTITY,
           DET.QUANTITY * DET.UNITPRICE AS TOTALAMOUNT
    FROM  PRODUCTS AS PRD
    INNER JOIN ORDERDETAILS AS DET 
	ON    PRD.PRODUCTID = DET.PRODUCTID
    INNER JOIN ORDERS AS ORD 
	ON    DET.ORDERID = ORD.ORDERID
    WHERE EXTRACT(YEAR FROM ORD.ORDERDATE) = 2023
    GROUP BY PRD.CATEGORY, 
	      YEAR
)
SELECT CATEGORY,
       YEAR,
	   SUM(QUANTITY) AS TOTALQUANTITY,
       SUM(TOTALAMOUNT) AS TOTALAMOUNT
FROM PRODUCT_CATEGORIES
ORDER BY CATEGORY;
