------------------------------------------
-------------- TABLES MODEL --------------
------------------------------------------

CREATE TABLE CUSTOMERS (
	CUSTOMERID NUMBER PRIMARY KEY,
	FIRSTNAME VARCHAR2(200),
	LASTNAME VARCHAR2(200),
	EMAIL VARCHAR2(250),
	JOINDATE DATE
)
TABLESPACE USERS_DATA;

CREATE INDEX IDX_CUSTOMERS_NAME ON CUSTOMERS (FIRSTNAME, LASTNAME)
TABLESPACE USERS_DATA_IDX;


CREATE TABLE ORDERS (
    ORDERID NUMBER PRIMARY KEY,
    CUSTOMERID NUMBER,
    ORDERDATE DATE,
    TOTALAMOUNT NUMBER(20, 2),
	CONSTRAINT FK_CUSTOMERID FOREIGN KEY (CUSTOMERID) REFERENCES CUSTOMERS(CUSTOMERID) ON DELETE CASCADE
)
TABLESPACE USERS_DATA;

CREATE INDEX IDX_ORDERS_ORDERDATE ON ORDERS (ORDERDATE)
TABLESPACE USERS_DATA_IDX;


CREATE TABLE ORDERDETAILS (
	ORDERDETAILID NUMBER PRIMARY KEY,
	ORDERID NUMBER,
	PRODUCTID NUMBER,
	QUANTITY NUMBER,
	UNITPRICE NUMBER(20,2),
	CONSTRAINT FK_ORDERID FOREIGN KEY (ORDERID) REFERENCES ORDERS(ORDERID) ON DELETE CASCADE
)
TABLESPACE USERS_DATA;

CREATE INDEX IDX_ORDERDETAILS_ORDERID ON ORDERDETAILS (ORDERID)
TABLESPACE USERS_DATA_IDX;


CREATE TABLE PRODUCTS(
	PRODUCTID NUMBER PRIMARY KEY,
	PRODUCTNAME VARCHAR2(500),
	CATEGORY VARCHAR2(250),
	PRICE NUMBER(20,2)
);
TABLESPACE USERS_DATA;