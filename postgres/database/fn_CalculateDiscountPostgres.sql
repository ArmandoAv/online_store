---------------------------------------------------------
------------- FN_CALCULATEDISCOUNT FUNCTION -------------
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
        DISCOUNT := 0.25;
    ELSIF QUANTITY >= 20 THEN
        DISCOUNT := 0.20;
    ELSIF QUANTITY >= 10 THEN
        DISCOUNT := 0.10;
    END IF;

    RETURN DISCOUNT;
END;
$$
LANGUAGE plpgsql;
