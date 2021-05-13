
CREATE OR REPLACE FUNCTION define_age_gap (
p_yearofbirth IN dw_customers.cust_year_of_birth%TYPE,
p_date IN dw_customers.cust_year_of_birth%TYPE
) RETURN VARCHAR2 IS
v_age_gap VARCHAR2(10);
v_age NUMBER(3);
BEGIN
v_age := p_date - p_yearofbirth;
IF
( v_age < 10 )
THEN
RETURN 'Kid';
ELSIF ( v_age < 18 ) THEN
RETURN 'Teen';
ELSIF ( v_age < 30 ) THEN
RETURN 'Young Adult';
ELSIF ( v_age < 50 ) THEN
RETURN 'Adult';
ELSIF ( v_age < 65 ) THEN
RETURN 'Middle Age';
ELSE
RETURN 'Senior';
END IF;
END;