create or replace PROCEDURE mini_dimensoes_dimensoes IS
-- Inserting into a cursor values thats is going to be used in the customers table and social class table
CURSOR c_cust IS
--The customer table is denormalized and the values city name, province name, subregion
--and region are fetched from the respective tables
SELECT 
CUST_ID,
CUST_FIRST_NAME,
CUST_LAST_NAME,
CUST_GENDER,
CUST_YEAR_OF_BIRTH,
CUST_MARITAL_STATUS,
CUST_STREET_ADDRESS,
CUST_POSTAL_CODE,
CUST_MAIN_PHONE_NUMBER,
CUST_INCOME_LEVEL,
CUST_CREDIT_LIMIT,
CUST_EMAIL,
CUST_TOTAL,
CUST_MONTH_OF_BIRTH,
CITY,
(STATE_PROVINCES.STATE_PROVINCE) cust_province,
COUNTRY_NAME,
(COUNTRY_SUBREGIONS.COUNTRY_SUBREGION) cust_subregion,
(COUNTRY_REGIONS.COUNTRY_REGION) cust_region
FROM 
CUSTOMERS,
CITIES,
STATE_PROVINCES,
COUNTRIES,
COUNTRY_SUBREGIONS,
COUNTRY_REGIONS
WHERE
-- This ensures that there are no duplicated values in the customers table of the datawarehouse
CUSTOMERS.CUST_ID NOT IN
(SELECT CUST_ID FROM DW_CUSTOMERS
)
AND CUST_CITY = CITY_ID
AND CITIES.STATE_PROVINCE = STATE_PROVINCE_ID
AND COUNTRY_ID = STATE_PROVINCES.COUNTRY
AND COUNTRY_SUBREGION_ID = COUNTRIES.COUNTRY_SUBREGION
AND COUNTRY_REGION_ID = COUNTRY_SUBREGIONS.COUNTRY_REGION;
v_sc_id dw_social_class.social_class_id%type;
v_ag_id dw_age_gap.age_group_id%type;
v_ag_count NUMBER(5);
v_sc_count NUMBER(5);
BEGIN
-- because there is such a little number of values in age gap table, it was inserted all posibilities
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'M', 'Kid');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'F', 'Kid');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'M', 'Teen');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'F', 'Teen');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'M', 'Young Adult');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'F', 'Young Adult');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'M', 'Adult');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'F', 'Adult');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'M', 'Middle Age');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'F', 'Middle Age');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'M', 'Senior');
insert into dw_age_gap values (seq_dw_age_gap.nextval, 'F', 'Senior');
-- The loop goes through the rows of the entire cursor
FOR v_cust IN c_cust
LOOP
--The following query counts every row that has already the same city name, postal code, and social class
-- and inserts it into a counter
SELECT COUNT(*)
INTO v_sc_count
FROM dw_social_class
WHERE v_cust.cust_postal_code = cust_postal_code
AND v_cust.city = city
AND define_class(v_cust.cust_income_level) = social_class;
-- if the counter equals 0 it means that the values that are going to be inserted into social class are not duplicated
IF v_sc_count = 0 THEN
INSERT
INTO dw_social_class VALUES
(
seq_dw_social_class.nextval,
define_class(v_cust.cust_income_level),
v_cust.cust_postal_code,
v_cust.city
);
END IF;
-- inserts into customers_dw the values of the current row of the cursor and the variables
INSERT
INTO dw_customers VALUES
(
v_cust.CUST_ID,
v_cust.CUST_FIRST_NAME,
v_cust.CUST_LAST_NAME,
v_cust.CUST_GENDER,
v_cust.CUST_YEAR_OF_BIRTH,
v_cust.CUST_MARITAL_STATUS,
v_cust.CUST_STREET_ADDRESS,
v_cust.CUST_POSTAL_CODE,
v_cust.CUST_MAIN_PHONE_NUMBER,
v_cust.CUST_INCOME_LEVEL,
v_cust.CUST_CREDIT_LIMIT,
v_cust.CUST_EMAIL,
v_cust.CUST_TOTAL,
v_cust.CUST_MONTH_OF_BIRTH,
v_cust.CITY,
v_cust.cust_province,
v_cust.COUNTRY_NAME,
v_cust.cust_subregion,
v_cust.cust_region,
-- it selects the corresponding id for the foreign key that has the same gender and age group
(SELECT age_group_id
FROM dw_age_gap
WHERE v_cust.cust_gender = gender
AND age_group =
define_age_gap(v_cust.cust_year_of_birth,
to_number(TO_CHAR(sysdate, 'yyyy')))
),
(SELECT social_class_id
FROM dw_social_class
WHERE v_cust.cust_postal_code =
cust_postal_code
AND v_cust.city = city
AND define_class(v_cust.cust_income_level) = social_class
)
);
END LOOP;
END;