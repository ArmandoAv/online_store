---------------------------------------------------
------------- CHECK_QUANTITY FUNCTION -------------
---------------------------------------------------

CREATE OR REPLACE FUNCTION FN_CHECKQUANTITY()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.QUANTITY <= 0 THEN
        RAISE EXCEPTION 'El valor en la columna QUANTITY no puede ser negativa o cero';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


----------------------------------------------------------
------------- TRIGGER CHECK_QUANTITY_TRIGGER -------------
----------------------------------------------------------

CREATE TRIGGER TR_CHECKQUANTITY
	BEFORE INSERT ON ORDERDETAILS
	FOR EACH ROW
	EXECUTE FUNCTION FN_CHECKQUANTITY();
