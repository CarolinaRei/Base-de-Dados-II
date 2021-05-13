CREATE OR REPLACE FUNCTION define_class (
p_income IN dw_customers.cust_income_level%TYPE
) RETURN VARCHAR2 IS
cust_class VARCHAR2(10);
v_char VARCHAR2(1);
BEGIN
v_char := substr(p_income,1,1);
IF
( v_char = 'A' ) OR ( v_char = 'B' )
THEN
RETURN 'Poor';
ELSIF ( v_char > 'B' ) AND ( v_char <= 'G' ) THEN
RETURN 'Middle';
ELSE
RETURN 'Rich';
END IF;
END;