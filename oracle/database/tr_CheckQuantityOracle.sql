----------------------------------------------------
------------- TR_CHECKQUANTITY_TRIGGER -------------
----------------------------------------------------

CREATE TRIGGER TR_VALIDATEQUANTITY
BEFORE INSERT OR UPDATE ON ORDERDETAILS
FOR EACH ROW
DECLARE
BEGIN
    IF :NEW.QUANTITY <= 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Quantity cannot be 0 or negative.');
    END IF;
END;
