-------------------------------------------------------------
------------- FN_ACTIVECUSTOMERS TABLE FUNCTION -------------
-------------------------------------------------------------

-- Defines the type of object that will contain the attributes
CREATE OR REPLACE TYPE CUSTOMER_ORDER_TYPE AS OBJECT (
    CUSTOMERID    NUMBER,
    FIRSTNAME     VARCHAR2(200),
    LASTNAME      VARCHAR2(200),
    EMAIL         VARCHAR2(300),
    ORDERID       NUMBER,
    ORDERDATE     DATE,
    TOTALAMOUNT   NUMBER
);

-- Defines a type of table that is composed of elements of the type defined above
CREATE OR REPLACE TYPE CUSTOMER_ORDER_TABLE AS TABLE OF CUSTOMER_ORDER_TYPE;

-- This function returns a result set from the table defined above in a pipelined manner
CREATE OR REPLACE FUNCTION FN_ACTIVECUSTOMERS
RETURN CUSTOMER_ORDER_TABLE PIPELINED
IS
BEGIN
    FOR rec IN (
        SELECT CUS.CUSTOMERID,
               CUS.FIRSTNAME,
               CUS.LASTNAME,
               CUS.EMAIL,
               ORD.ORDERID,
               ORD.ORDERDATE,
               ORD.TOTALAMOUNT
        FROM   CUSTOMERS CUS
        INNER JOIN ORDERS ORD
        ON     CUS.CUSTOMERID = ORD.CUSTOMERID
        WHERE  ORD.ORDERDATE > ADD_MONTHS(TRUNC(SYSDATE), -6)
    )
    LOOP
        PIPE ROW (CUSTOMER_ORDER_TYPE(rec.CUSTOMERID, rec.FIRSTNAME, rec.LASTNAME, rec.EMAIL, rec.ORDERID, rec.ORDERDATE, rec.TOTALAMOUNT));
    END LOOP;

    RETURN;
END FN_ACTIVECUSTOMERS;
