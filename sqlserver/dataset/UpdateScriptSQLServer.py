# Scripts with amount updates

update_details = """UPDATE T1
SET  T1.UNITPRICE = T2.PRICE
FROM ORDERDETAILS AS T1
INNER JOIN PRODUCTS AS T2 
ON   T1.PRODUCTID = T2.PRODUCTID"""

update_orders = """UPDATE ORDERS
SET TOTALAMOUNT = (
    SELECT SUM(DET.QUANTITY * DET.UNITPRICE)
    FROM ORDERDETAILS AS DET
    WHERE DET.ORDERID = ORDERS.ORDERID
)
WHERE EXISTS (
    SELECT 1
    FROM ORDERDETAILS AS DET
    WHERE DET.ORDERID = ORDERS.ORDERID
)"""
