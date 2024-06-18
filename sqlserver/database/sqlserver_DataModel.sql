------------------------------------------
-------------- TABLES MODEL --------------
------------------------------------------

CREATE TABLE CUSTOMERS (
	CUSTOMERID INT PRIMARY KEY,
	FIRSTNAME VARCHAR(200),
	LASTNAME VARCHAR(200),
	EMAIL VARCHAR(250),
	JOINDATE DATE
);
GO

CREATE INDEX IDX_CUSTOMERS_NAME ON CUSTOMERS(FIRSTNAME, LASTNAME);
GO

CREATE TABLE ORDERS (
    ORDERID INT PRIMARY KEY,
    CUSTOMERID INT,
    ORDERDATE DATE,
    TOTALAMOUNT DECIMAL(20, 2),
    FOREIGN KEY (CUSTOMERID) REFERENCES CUSTOMERS(CUSTOMERID)
);
GO

CREATE INDEX IDX_ORDERS_ORDERDATE ON ORDERS(ORDERDATE);
GO

CREATE TABLE PRODUCTS(
	PRODUCTID INT PRIMARY KEY,
	PRODUCTNAME VARCHAR(500),
	CATEGORY VARCHAR(250),
	PRICE DECIMAL(20,2)
);
GO


CREATE TABLE ORDERDETAILS (
	ORDERDETAIL INT PRIMARY KEY,
	ORDERID INT,
	PRODUCTID INT,
	QUNATITY INT,
	UNITPRICE DECIMAL(20,2),
	FOREIGN KEY (ORDERID) REFERENCES ORDERS(ORDERID),
	FOREIGN KEY (PRODUCTID) REFERENCES PRODUCTS(PRODUCTID)
);
GO

CREATE INDEX IDX_ORDERDETAILS_ORDERID ON ORDERDETAILS(ORDERID);
GO


--------------------------------------------------
------------- VW_CUSTOMERORDERS VIEW -------------
--------------------------------------------------

CREATE VIEW VW_CUSTOMERORDERS AS
SELECT CUST.CUSTOMERID,
	   CUST.FIRSTNAME,
	   CUST.LASTNAME,
	   CUST.EMAIL,
	   COUNT(ORD.ORDERID) AS TOTALORDERS,
	   SUM(ORD.TOTALAMOUNT) AS TOTALAMOUNT,
	   YEAR(JOINDATE) AS YEAR
FROM   CUSTOMERS AS CUST
LEFT JOIN ORDERS AS ORD
ON CUST.CUSTOMERID = ORD.CUSTOMERID
WHERE  YEAR(JOINDATE) = 2023
GROUP BY CUST.CUSTOMERID,
	   CUST.FIRSTNAME,
	   CUST.LASTNAME,
	   CUST.EMAIL,
	   YEAR(JOINDATE)
;
