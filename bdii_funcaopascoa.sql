CREATE OR REPLACE FUNCTION easter_day (
given_year NUMBER
) RETURN DATE AS
golden_metonic NUMBER;
century NUMBER;
leap_year_fix NUMBER;
lunar_sync NUMBER;
sunday_date NUMBER;
epact NUMBER;
day_of_month NUMBER;
easter_offset NUMBER;
BEGIN
golden_metonic := MOD(given_year,19) + 1;
century := ( given_year / 100 ) + 1;
leap_year_fix := ( 3 * century / 4 ) - 12;
lunar_sync := ( ( 8 * century + 5 ) / 25 ) - 5;
sunday_date := ( 5 * given_year / 4 ) - leap_year_fix - 3;
epact := MOD( (11 * golden_metonic + 20 + lunar_sync -
leap_year_fix),30);
IF
( ( epact = 25 AND golden_metonic < 11 ) OR ( epact = 24 )
)
THEN
epact := epact + 1;
END IF;
day_of_month := 44 - epact;
IF
( day_of_month < 21 )
THEN
day_of_month := day_of_month + 30;
END IF;
easter_offset := ( day_of_month + 7 - MOD( (sunday_date +
day_of_month),7) ) - 1;
RETURN TO_DATE('01-03-'
|| TO_CHAR(given_year),'DD-MM-YYYY') + easter_offset;
END;