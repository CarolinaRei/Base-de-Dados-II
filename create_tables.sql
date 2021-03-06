-- Products

drop table dw_products;
/

CREATE TABLE dw_products (
    id                 NUMBER(6) NOT NULL,
    prod_id            NUMBER(6) NOT NULL,
    products_mini_id   NUMBER(9) NOT NULL,
    name               VARCHAR2(50 BYTE) NOT NULL,
    description        VARCHAR2(4000 BYTE) NOT NULL,
    price              NUMBER(8, 2) NOT NULL,
    sub_category       VARCHAR2(50 BYTE) NOT NULL,
    category           VARCHAR2(50 BYTE) NOT NULL
);

ALTER TABLE dw_products ADD CONSTRAINT products_pk PRIMARY KEY ( id );

ALTER TABLE dw_products
    ADD CONSTRAINT products_products_mini_fk FOREIGN KEY ( products_mini_id )
        REFERENCES dw_products_mini ( id );
     
        
-- Products mini

drop table dw_products_mini;
/

CREATE TABLE dw_products_mini (
    id               NUMBER(9) NOT NULL,
    pack_size_step   VARCHAR2(5 BYTE) NOT NULL,
    pack_size_min    NUMBER(2),
    pack_size_max    NUMBER(2)
);

ALTER TABLE dw_products_mini ADD CONSTRAINT products_mini_pk PRIMARY KEY ( id );


-- Employees

drop table dw_employees;
drop table dw_employees_mini;
/
CREATE TABLE dw_employees (
    id                 NUMBER(9) NOT NULL,
    employee_id        NUMBER(9) NOT NULL,
    employees_mini_id  NUMBER(9) NOT NULL,
    first_name         VARCHAR2(20 BYTE) NOT NULL,
    last_name          VARCHAR2(20 BYTE) NOT NULL,
    manager_id         NUMBER(9) ,
    hire_date          DATE NOT NULL,
    phone_number       VARCHAR2(30 BYTE) NOT NULL,
    email              VARCHAR2(30 BYTE) NOT NULL,
    salary             NUMBER(6) NOT NULL
);

ALTER TABLE dw_employees ADD CONSTRAINT employees_pk PRIMARY KEY ( id );

ALTER TABLE dw_employees
    ADD CONSTRAINT employees_employees_mini_fk FOREIGN KEY ( employees_mini_id )
        REFERENCES dw_employees_mini ( id );
        
        
-- Employees mini

CREATE TABLE dw_employees_mini (
    id            NUMBER(3) NOT NULL,
    salary_min    NUMBER(7) NOT NULL,
    salary_max    NUMBER(7) NOT NULL,
    salary_level  NUMBER(5) NOT NULL
);

ALTER TABLE dw_employees_mini ADD CONSTRAINT employees_mini_pk PRIMARY KEY ( id );


-- Customers


CREATE TABLE DW_Customers
(
cust_id NUMBER(6) NOT NULL,
cust_first_name VARCHAR2(20 BYTE) NOT NULL,
cust_last_name VARCHAR2(20 BYTE) NOT NULL,
cust_gender CHAR(1 BYTE) NOT NULL,
cust_year_of_birth NUMBER(4) NOT NULL,
cust_marital_status VARCHAR2(20 BYTE),
cust_street_adress VARCHAR2(40 BYTE) NOT NULL,
cust_postal_code VARCHAR2(10 BYTE) NOT NULL,
cust_main_phone_number VARCHAR2(25 BYTE) NOT NULL,
cust_income_level VARCHAR2(30 BYTE) NOT NULL,
cust_credit_limit NUMBER NOT NULL,
cust_email VARCHAR2(30 BYTE) NOT NULL,
cust_total VARCHAR2(14 BYTE),
cust_month_of_birth NUMBER(2) NOT NULL,
cust_city_name VARCHAR2(30 BYTE) NOT NULL,
cust_province_name VARCHAR2(40 BYTE) NOT NULL,
cust_country_name VARCHAR2(40 BYTE) NOT NULL,
cust_subregion_name VARCHAR2(30 BYTE) NOT NULL,
cust_region_name VARCHAR2(20 BYTE) NOT NULL,
cust_age_group NUMBER,
cust_social_class NUMBER,
PRIMARY KEY ( cust_id ),
FOREIGN KEY ( cust_age_group ) REFERENCES DW_age_gap (
age_group_id ),
FOREIGN KEY ( cust_social_class ) REFERENCES DW_social_class(
social_class_id )
);

/*CREATE TABLE dw_customers (
    id                  NUMBER(9) NOT NULL,
    cust_id             NUMBER(6) NOT NULL,
    customers_mini_id   NUMBER(9) NOT NULL,
    first_name          VARCHAR2(20 BYTE) NOT NULL,
    last_name           VARCHAR2(40 BYTE) NOT NULL,
    gender              CHAR(1 BYTE) NOT NULL,
    year_of_birth       NUMBER(4) NOT NULL,
    month_of_birth      NUMBER(2) NOT NULL,
    day_of_birth        NUMBER(2) NOT NULL,
    birth_day           DATE NOT NULL,
    email               VARCHAR2(30 BYTE) NOT NULL,
    phone_number        NUMBER(9),
    marital_status      VARCHAR2(20 BYTE),
    street_address      VARCHAR2(20 BYTE) NOT NULL,
    credit_limit        NUMBER(6) NOT NULL
);

ALTER TABLE dw_customers ADD CONSTRAINT customers_pk PRIMARY KEY ( id );

ALTER TABLE dw_customers
    ADD CONSTRAINT customers_customers_mini_fk FOREIGN KEY ( customers_mini_id )
        REFERENCES dw_customers_mini ( id );       */ 
  
        
-- Customers mini

CREATE TABLE dw_customers_mini (
    id               NUMBER(9) NOT NULL,
    income_level     VARCHAR2(30 BYTE) NOT NULL,
    credit_limit     NUMBER(6) NOT NULL,
    city             VARCHAR2(12 BYTE) NOT NULL,
    street_address   VARCHAR2(30 BYTE) NOT NULL,
    postal_code      VARCHAR2(20 BYTE) NOT NULL
);

ALTER TABLE dw_customers_mini ADD CONSTRAINT customers_mini_pk PRIMARY KEY ( id );


-- Delivery Company

drop table dw_delivery_company;
/


CREATE TABLE dw_delivery_company (
    delivery_company_id   NUMBER(9) NOT NULL,
    id                    NUMBER(9) NOT NULL,
    name                  VARCHAR2(20 BYTE) NOT NULL,
    type                  VARCHAR2(20 BYTE) NOT NULL,
    start_date            DATE,
    end_date              DATE
);

ALTER TABLE dw_delivery_company ADD CONSTRAINT delivery_company_pk PRIMARY KEY ( delivery_company_id );
/

-- Date

CREATE TABLE dw_date (
    id              NUMBER(9) NOT NULL,
    "DATE"          DATE NOT NULL,
    day             NUMBER(2) NOT NULL,
    month           NUMBER(2) NOT NULL,
    year            NUMBER(4) NOT NULL,
    month_name      VARCHAR2(10 BYTE) NOT NULL,
    day_week        NUMBER(1) NOT NULL,
    day_week_name   VARCHAR2(10 BYTE) NOT NULL
);

ALTER TABLE dw_date ADD CONSTRAINT date_pk PRIMARY KEY ( id );


-- Sales

drop table dw_sales;
/

CREATE TABLE dw_sales (
    product_quantity      NUMBER(6, 2),
    total_sold_quantity   NUMBER(3, 2),
    sold_amount           NUMBER(3, 2),
    total_customers       NUMBER(6, 2),
    total_employees       NUMBER(4, 2),
    "DATE"                NUMBER(9) NOT NULL,
    employees             NUMBER(6) NOT NULL,
    employees_mini        NUMBER(9) NOT NULL,
    products              NUMBER(6) NOT NULL,
    products_mini         NUMBER(9) NOT NULL,
    customers             NUMBER(9) NOT NULL,
    social_class          NUMBER(4) NOT NULL,
    age_gap               NUMBER(3) NOT NULL,
    delivery_company      NUMBER(6) NOT NULL
);

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_pk PRIMARY KEY ( "DATE",
                                          employees,
                                          products,
                                          customers,
                                          delivery_company );

ALTER TABLE dw_sales
    ADD CONSTRAINT dw_sales_dw_age_gap_fk FOREIGN KEY ( age_gap )
        REFERENCES dw_age_gap ( age_group_id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_customers_fk FOREIGN KEY ( customers )
        REFERENCES dw_customers ( cust_id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_customers_mini_fk FOREIGN KEY ( social_class )
        REFERENCES dw_social_class ( social_class_id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_date_fk FOREIGN KEY ( "DATE" )
        REFERENCES dw_date ( dateid );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_delivery_company_fk FOREIGN KEY ( delivery_company )
        REFERENCES dw_delivery_company ( delivery_company_id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_employees_fk FOREIGN KEY ( employees )
        REFERENCES dw_employees ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_employees_mini_fk FOREIGN KEY ( employees_mini )
        REFERENCES dw_employees_mini ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_products_fk FOREIGN KEY ( products )
        REFERENCES dw_products ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_products_mini_fk FOREIGN KEY ( products_mini )
        REFERENCES dw_products_mini ( id );