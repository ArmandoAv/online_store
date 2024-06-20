-----------------------------------------------------
------------- FN_CHECKQUANTITY FUNCTION -------------
-----------------------------------------------------

CREATE OR REPLACE FUNCTION FN_CHECKQUANTITY()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.QUANTITY <= 0 THEN
        RAISE EXCEPTION 'Quantity cannot be 0 or negative.';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


----------------------------------------------------
------------- TR_CHECKQUANTITY_TRIGGER -------------
----------------------------------------------------

CREATE TRIGGER TR_CHECKQUANTITY
	BEFORE INSERT ON ORDERDETAILS
	FOR EACH ROW
	EXECUTE FUNCTION FN_CHECKQUANTITY();
