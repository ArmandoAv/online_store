---------------------------------------------------------
------------- FN_CALCULATEDISCOUNT FUNCTION -------------
---------------------------------------------------------

CREATE OR REPLACE FUNCTION FN_CALCULATEDISCOUNT (
    p_ProductID IN NUMBER,
    p_Quantity IN NUMBER
)
RETURN NUMBER
IS
    v_Discount NUMBER := 0;
BEGIN
    IF p_Quantity >= 50 THEN
        v_Discount := 0.25;
    ELSIF p_Quantity >= 20 THEN
        v_Discount := 0.20;
    ELSIF p_Quantity >= 10 THEN
        v_Discount := 0.10;
    END IF;

    RETURN v_Discount;
END FN_CALCULATEDISCOUNT;
