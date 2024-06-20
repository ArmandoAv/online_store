----------------------------------------------------
------------- TR_CHECKQUANTITY_TRIGGER -------------
----------------------------------------------------

CREATE TRIGGER TR_VALIDATEQUANTITY
ON ORDERDETAILS
FOR INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM INSERTED WHERE QUANTITY <= 0)
    BEGIN
        RAISERROR('Quantity cannot be 0 or negative.', 16, 1);
        ROLLBACK TRANSACTION;
    END;
END;
