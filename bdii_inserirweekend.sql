CREATE OR REPLACE FUNCTION f_weekend(
given_date DATE )
RETURN dw_date.weekend%TYPE
IS
v_weekend dw_date.weekend%TYPE;
BEGIN
IF ( to_number(TO_CHAR(given_date,'D') ) = 1 ) OR (
to_number(TO_CHAR(given_date,'D') ) = 7 ) THEN
v_weekend := 'Yes';
ELSE
v_weekend := 'No';
END IF;
RETURN v_weekend;
END;
