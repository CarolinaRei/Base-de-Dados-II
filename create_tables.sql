select * from delivery_company;
select * from fleet;
/


-- Products

CREATE TABLE dw_products (
    id                 NUMBER(6) NOT NULL,
    products_mini_id   NUMBER(9) NOT NULL,
    name               VARCHAR2(50 BYTE) NOT NULL,
    "DESC"             VARCHAR2(4000 BYTE) NOT NULL,
    price_max          NUMBER(4, 2) NOT NULL,
    price_min          NUMBER(4, 2) NOT NULL
);e

ALTER TABLE dw_products ADD CONSTRAINT products_pk PRIMARY KEY ( id );

ALTER TABLE dw_products
    ADD CONSTRAINT products_products_mini_fk FOREIGN KEY ( products_mini_id )
        REFERENCES dw_products_mini ( id );
     
        
-- Products mini

CREATE TABLE dw_products_mini (
    id                   NUMBER(9) NOT NULL,
    price_percentage     NUMBER(3) NOT NULL,
    promotion_end_date   DATE NOT NULL,
    sold_products        NUMBER(8) NOT NULL
);

ALTER TABLE dw_products_mini ADD CONSTRAINT products_mini_pk PRIMARY KEY ( id );


-- Employees

drop table dw_employees;
/

CREATE TABLE dw_employees (
    id                  NUMBER(6) NOT NULL,
    employee_id         NUMBER(6) NOT NULL,
    employees_mini_id   NUMBER(9) NOT NULL,
    first_name          VARCHAR2(20 BYTE) NOT NULL,
    last_name           VARCHAR2(20 BYTE) NOT NULL,
    manager             CHAR(1) NOT NULL,
    hire_date           DATE NOT NULL,
    phone_number        NUMBER(9) NOT NULL,
    email               VARCHAR2(30 BYTE) NOT NULL,
    commission_pct      NUMBER(5, 3) NOT NULL,
    salary_max          NUMBER(5, 2) NOT NULL,
    salary_min          NUMBER(3, 2) NOT NULL
);

ALTER TABLE dw_employees ADD CONSTRAINT employees_pk PRIMARY KEY ( id );

ALTER TABLE dw_employees
    ADD CONSTRAINT employees_employees_mini_fk FOREIGN KEY ( employees_mini_id )
        REFERENCES dw_employees_mini ( id );        
    
    
-- Employees mini

CREATE TABLE dw_employees_mini (
    id               NUMBER(9) NOT NULL,
    salary_percent   NUMBER(3) NOT NULL,
    commission_pct   NUMBER(5, 3) NOT NULL
);

ALTER TABLE dw_employees_mini ADD CONSTRAINT employees_mini_pk PRIMARY KEY ( id );


-- Customers

drop table dw_customers;
/

CREATE TABLE dw_customers (
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
        REFERENCES dw_customers_mini ( id );        
  
        
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

CREATE TABLE dw_delivery_company (
    id           NUMBER(6) NOT NULL,
    name         VARCHAR2(20 BYTE) NOT NULL,
    type         VARCHAR2(20 BYTE) NOT NULL,
    fleet_id     NUMBER(9),
    start_date   DATE,
    end_date     DATE
);

ALTER TABLE dw_delivery_company ADD CONSTRAINT delivery_company_pk PRIMARY KEY ( id );


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


-- Manh�/Tarde

CREATE TABLE dw_manha_tarde (
    id            NUMBER(9) NOT NULL,
    manha_tarde   CHAR(1) NOT NULL
);

ALTER TABLE dw_manha_tarde ADD CONSTRAINT manha_tarde_pk PRIMARY KEY ( id );


-- Sales

CREATE TABLE dw_sales (
    product_quantity   NUMBER(3, 2),
    total_price        NUMBER(5, 2),
    total_customers    NUMBER(6, 2),
    total_employees    NUMBER(4, 2),
    "DATE"             NUMBER(9) NOT NULL,
    employees          NUMBER(6) NOT NULL,
    products           NUMBER(6) NOT NULL,
    customers          NUMBER(9) NOT NULL,
    delivery_company   NUMBER(6) NOT NULL,
    employees_mini     NUMBER(9) NOT NULL,
    customers_mini     NUMBER(9) NOT NULL,
    products_mini      NUMBER(9) NOT NULL,
    manha_tarde_id     NUMBER(9) NOT NULL
);

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_pk PRIMARY KEY ( "DATE",
                                          employees,
                                          products,
                                          customers,
                                          delivery_company,
                                          manha_tarde_id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_customers_fk FOREIGN KEY ( customers )
        REFERENCES dw_customers ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_customers_mini_fk FOREIGN KEY ( customers_mini )
        REFERENCES dw_customers_mini ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_date_fk FOREIGN KEY ( "DATE" )
        REFERENCES dw_date ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_delivery_company_fk FOREIGN KEY ( delivery_company )
        REFERENCES dw_delivery_company ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_employees_fk FOREIGN KEY ( employees )
        REFERENCES dw_employees ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_employees_mini_fk FOREIGN KEY ( employees_mini )
        REFERENCES dw_employees_mini ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_manha_tarde_fk FOREIGN KEY ( manha_tarde_id )
        REFERENCES dw_manha_tarde ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_products_fk FOREIGN KEY ( products )
        REFERENCES dw_products ( id );

ALTER TABLE dw_sales
    ADD CONSTRAINT sales_products_mini_fk FOREIGN KEY ( products_mini )
        REFERENCES dw_products_mini ( id );