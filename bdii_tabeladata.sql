create or replace PROCEDURE insert_date IS
start_date DATE;
end_date DATE;
easter_date DATE;
v_weekend dw_date.weekend%TYPE;
v_quarter dw_date.quartername%TYPE;
v_fquarter dw_date.firstquarter%TYPE;
v_lquarter dw_date.lastquarter%TYPE;
v_holiday dw_date.holiday%TYPE;
V_ID dw_DATE.DATEID%TYPE;
BEGIN
--declaring the beginning date and end date of the table
start_date := TO_DATE('01-01-1997','DD-MM-YYYY');
end_date := TO_DATE('01-01-2030','DD-MM-YYYY');
--the following loops until it reaches the end date 
--specified previously
WHILE start_date < end_date LOOP
-- The following if is used to determine the quarter of a month
IF ( to_number(TO_CHAR(start_date,'Q') ) = 1) THEN
v_quarter := 'First';
v_fquarter := TO_DATE('01-01-' || to_char(start_date,
'YYYY'), 'DD-MM-YYYY');
v_lquarter := TO_DATE('31-03-' || to_char(start_date,
'YYYY'), 'DD-MM-YYYY');
ELSIF ( to_number(TO_CHAR(start_date,'Q') ) = 2) THEN
v_quarter := 'Second';
v_fquarter := TO_DATE('01-04-' || to_char(start_date,
'YYYY'), 'DD-MM-YYYY');
v_lquarter := TO_DATE('30-06-' || to_char(start_date,
'YYYY'), 'DD-MM-YYYY');
ELSIF ( to_number(TO_CHAR(start_date,'Q') ) = 3) THEN
v_quarter := 'Third';
v_fquarter := TO_DATE('01-07-' || to_char(start_date,
'YYYY'), 'DD-MM-YYYY');
v_lquarter := TO_DATE('30-09-' || to_char(start_date,
'YYYY'), 'DD-MM-YYYY');
ELSE
v_quarter := 'Fourth';
v_fquarter := TO_DATE('01-10-' || to_char(start_date,
'YYYY'), 'DD-MM-YYYY');
v_lquarter := TO_DATE('31-12-' || to_char(start_date,
'YYYY'), 'DD-MM-YYYY');
END IF;
--the fuction f_hollyday returns a string corresponding to 
--the hollyday, and if there isn’t any hollyday, returns null
v_holiday := f_holiday(start_date);
--f_weekend returns ‘Yes’ if its a weekend, else ‘No’
v_weekend := f_weekend(start_date);
dbms_output.put_line(TO_CHAR(start_date,'DD-MM-YYYY') );
INSERT INTO dw_date (
dateid,
dateformat,
daydw,
monthdw,
yeardw,
dayweek,
dayofweek,
dayofyear,
weekend,
weekofyear,
weekofthemonth,
monthname,
quarter,
quartername,
firstquarter,
lastquarter,
holiday
) VALUES (
to_number(TO_CHAR(start_date,'YYYY') ||
TO_CHAR(start_date,'MM') || TO_CHAR(start_date,'DD') ),
start_date,
to_number(TO_CHAR(start_date,'DD') ),
to_number(TO_CHAR(start_date,'MM') ),
to_number(TO_CHAR(start_date,'YYYY') ),
to_number(TO_CHAR(start_date,'D') ),
TO_CHAR(start_date,'DAY'),
to_number(TO_CHAR(start_date,'DDD') ),
v_weekend,
to_number(TO_CHAR(start_date,'WW') ),
to_number(TO_CHAR(start_date,'W') ),
TO_CHAR(start_date,'MONTH'),
to_number(TO_CHAR(start_date,'Q') ),
v_quarter,
v_fquarter,
v_lquarter,
v_holiday
);
start_date := start_date + 1;
END LOOP;
END;