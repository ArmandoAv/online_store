---------------------------------------------------------
------------- FUNCTION FN_CALCULATEDISCOUNT -------------
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_CALCULATEDISCOUNT(
    PRODUCTID INTEGER,
    QUANTITY INTEGER
)
RETURNS DECIMAL AS
$$
DECLARE
    DISCOUNT DECIMAL := 0.00;
BEGIN
    IF QUANTITY >= 50 THEN
        DISCOUNT := 0.25; -- 25% DE DESCUENTO
    ELSIF QUANTITY >= 20 THEN
        DISCOUNT := 0.20; -- 20% DE DESCUENTO
    ELSIF QUANTITY >= 10 THEN
        DISCOUNT := 0.10; -- 10% DE DESCUENTO
    END IF;

    RETURN DISCOUNT;
END;
$$
LANGUAGE plpgsql;
