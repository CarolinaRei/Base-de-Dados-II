CREATE OR REPLACE PROCEDURE import_customers IS
BEGIN
INSERT INTO customers_dw (
cust_id,
cust_first_name,
cust_last_name,
cust_gender,
cust_year_of_birth,
cust_marital_status,
cust_street_adress,
cust_postal_code,
cust_main_phone_number,
cust_income_level,
cust_credit_limit,
cust_email,
cust_total,
cust_month_of_birth,
cust_city_name,
cust_province_name,
cust_country_name,
cust_subregion_name,
cust_region_name
)
SELECT
cust_id,
10cust_first_name,
cust_last_name,
cust_gender,
cust_year_of_birth,
cust_marital_status,
cust_street_address,
cust_postal_code,
cust_main_phone_number,
cust_income_level,
cust_credit_limit,
cust_email,
cust_total,
cust_month_of_birth,
city,
state_provinces.state_province,
country_name,
country_subregions.country_subregion,
country_regions.country_region
FROM
customers,
cities,
state_provinces,
countries,
country_subregions,
country_regions
WHERE
customers.cust_id NOT IN (
SELECT
cust_id
11FROM
customers_dw
)
AND cust_city = city_id
AND cities.state_province = state_province_id
AND country_id = state_provinces.country
AND country_subregion_id =
countries.country_subregion
AND country_region_id =
country_subregions.country_region;
END;