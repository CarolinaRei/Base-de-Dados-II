create or replace synonym oltp_channels for oltp_2021.channels@query_link;
create or replace  synonym oltp_custom for oltp_2021.customers@query_link;
create or replace  synonym x_dev_company for oltp_2021.delivery_company@query_link;
create or replace  synonym oltp_employ for oltp_2021.employees@query_link;
create or replace  synonym x_fleet for oltp_2021.fleet@query_link;
create or replace  synonym oltp_product_desc for oltp_2021.product_descriptions@query_link;
create or replace  synonym oltp_sales for oltp_2021.sales@query_link;
-- Sales Table

CREATE TABLE sales (
    cust_id               NUMBER NOT NULL,
    channel_id            CHAR(1 BYTE) NOT NULL,
    sale_date             DATE,
    employee_id           NUMBER(6),
    sale_id               NUMBER NOT NULL,
    store_id              NUMBER(6),
    donation_id           NUMBER(6),
    order_id              NUMBER(9),
    delivery_id           NUMBER(6),
    store_promotion_id    NUMBER(6),
    status_id             NUMBER(6),
    currency_id           NUMBER(9),
    currency_rate         NUMBER(9, 4),
    credit_company_id     NUMBER(9),
    payment_method_id     NUMBER(6),
    credit_limit_id       NUMBER(6),
    weather_id            NUMBER(6),
    marketing_id          NUMBER(6),
    delivery_company_id   NUMBER(6),
    salesman_fleet_id     NUMBER(6),
    contribution_id       NUMBER(6)
);

COMMENT ON TABLE sales IS
    'facts table, without a primary key; all rows are uniquely identified by the combination of all foreign keys';

COMMENT ON COLUMN sales.sale_id IS
    'primary key';

CREATE INDEX sales_channel_id ON
    sales (
        channel_id
    ASC );

CREATE INDEX sales_customer_fk_fk ON
    sales (
        cust_id
    ASC );

CREATE INDEX sales_employee_id ON
    sales (
        employee_id
    ASC );

CREATE UNIQUE INDEX sales_pk ON
    sales (
        sale_id
    ASC );

ALTER TABLE sales ADD CONSTRAINT pk_sales PRIMARY KEY ( sale_id );

ALTER TABLE sales
    ADD CONSTRAINT fk_sales_channel FOREIGN KEY ( channel_id )
        REFERENCES channels ( channel_id );

ALTER TABLE sales
    ADD CONSTRAINT fk_sales_customer FOREIGN KEY ( cust_id )
        REFERENCES customers ( cust_id );

ALTER TABLE sales
    ADD CONSTRAINT fk_sales_employee FOREIGN KEY ( employee_id )
        REFERENCES employees ( employee_id );

ALTER TABLE sales
    ADD CONSTRAINT sales_delivery_company_fk FOREIGN KEY ( delivery_company_id )
        REFERENCES delivery_company ( id );
/

    
-- Descriptions

CREATE TABLE product_descriptions (
    prod_desc_id   NUMBER(6) NOT NULL,
    prod_name      VARCHAR2(50 BYTE)
        CONSTRAINT ckc_prod_name_prod_desc NOT NULL,
    prod_desc      VARCHAR2(4000 BYTE)
        CONSTRAINT ckc_prod_desc_prod_desc NOT NULL
);

COMMENT ON TABLE product_descriptions IS
    'dimension table';

COMMENT ON COLUMN product_descriptions.prod_desc_id IS
    'primary key';

COMMENT ON COLUMN product_descriptions.prod_name IS
    'product name';

COMMENT ON COLUMN product_descriptions.prod_desc IS
    'product description';

CREATE UNIQUE INDEX pk_product_descriptions ON
    product_descriptions (
        prod_desc_id
    ASC );

ALTER TABLE product_descriptions ADD CONSTRAINT pk_product_descriptions PRIMARY KEY ( prod_desc_id );
/



-- Channels

CREATE TABLE channels (
    channel_id      CHAR(1 BYTE) NOT NULL,
    channel_desc    VARCHAR2(20 BYTE),
    channel_class   VARCHAR2(20 BYTE),
    cost_sale_pct   NUMBER(5, 3)
);

CREATE UNIQUE INDEX pk_channels ON
    channels (
        channel_id
    ASC );

ALTER TABLE channels ADD CONSTRAINT pk_channels PRIMARY KEY ( channel_id );
/





-- Employees

CREATE TABLE employees (
    employee_id      NUMBER(6) NOT NULL,
    first_name       VARCHAR2(15 BYTE),
    last_name        VARCHAR2(12 BYTE),
    email            VARCHAR2(30 BYTE),
    phone_number     VARCHAR2(20 BYTE),
    hire_date        DATE,
    job_id           VARCHAR2(10 BYTE),
    salary           NUMBER(12),
    commission_pct   NUMBER(5, 3),
    manager_id       NUMBER(10),
    column1          NUMBER(6)
);

CREATE UNIQUE INDEX employees_pk ON
    employees (
        employee_id
    ASC );

ALTER TABLE employees ADD CONSTRAINT pk_employees PRIMARY KEY ( employee_id );

ALTER TABLE employees
    ADD CONSTRAINT fk_employees_manager_employee FOREIGN KEY ( manager_id )
        REFERENCES oltp_2021.employees ( employee_id );
/



-- Customers

CREATE TABLE customers (
    cust_id                  NUMBER NOT NULL,
    cust_first_name          VARCHAR2(20 BYTE)
        CONSTRAINT ckc_cust_first_name_customer NOT NULL,
    cust_last_name           VARCHAR2(40 BYTE)
        CONSTRAINT ckc_cust_last_name_customer NOT NULL,
    cust_gender              CHAR(1 BYTE),
    cust_year_of_birth       NUMBER(4) NOT NULL,
    cust_marital_status      VARCHAR2(20 BYTE),
    cust_street_address      VARCHAR2(40 BYTE)
        CONSTRAINT ckc_cust_street_addre_customer NOT NULL,
    cust_postal_code         VARCHAR2(10 BYTE)
        CONSTRAINT ckc_cust_postal_code_customer NOT NULL,
    cust_main_phone_number   VARCHAR2(25 BYTE),
    cust_income_level        VARCHAR2(30 BYTE),
    cust_credit_limit        NUMBER,
    cust_email               VARCHAR2(30 BYTE),
    cust_total               VARCHAR2(14 BYTE),
    cust_city                VARCHAR2(12 BYTE) NOT NULL,
    cust_month_of_birth      NUMBER(2) NOT NULL,
    cust_birth_date          DATE NOT NULL,
    cust_day_of_birth        NUMBER(2) NOT NULL
);

COMMENT ON TABLE customers IS
    'dimension table';

COMMENT ON COLUMN customers.cust_id IS
    'primary key';

COMMENT ON COLUMN customers.cust_first_name IS
    'first name of the customer';

COMMENT ON COLUMN customers.cust_last_name IS
    'last name of the customer';

COMMENT ON COLUMN customers.cust_gender IS
    'gender; low cardinality attribute';

COMMENT ON COLUMN customers.cust_year_of_birth IS
    'customer year of birth';

COMMENT ON COLUMN customers.cust_marital_status IS
    'customer marital status; low cardinality attribute';

COMMENT ON COLUMN customers.cust_street_address IS
    'customer street address';

COMMENT ON COLUMN customers.cust_postal_code IS
    'postal code of the customer';

COMMENT ON COLUMN customers.cust_main_phone_number IS
    'customer main phone number';

COMMENT ON COLUMN customers.cust_income_level IS
    'customer income level';

COMMENT ON COLUMN customers.cust_credit_limit IS
    'customer credit limit';

COMMENT ON COLUMN customers.cust_email IS
    'customer email id';

COMMENT ON COLUMN customers.cust_total IS
    'customer total amount spend';

COMMENT ON COLUMN customers.cust_city IS
    'customer city';

COMMENT ON COLUMN customers.cust_month_of_birth IS
    'customer month of birth';

COMMENT ON COLUMN customers.cust_birth_date IS
    'customer date of birth';

COMMENT ON COLUMN customers.cust_day_of_birth IS
    'customer day of birth';

CREATE UNIQUE INDEX pk_customers ON
    customers (
        cust_id
    ASC );

ALTER TABLE customers ADD CONSTRAINT pk_customers PRIMARY KEY ( cust_id );

ALTER TABLE customers
    ADD CONSTRAINT fk_customers_city FOREIGN KEY ( cust_city )
        REFERENCES cities ( city_id );
/



-- Delivery Company

CREATE TABLE delivery_company (
    id         NUMBER(6) NOT NULL,
    name       VARCHAR2(20),
    type       VARCHAR2(20),
    fleet_id   NUMBER(9) NOT NULL
);

ALTER TABLE delivery_company ADD CONSTRAINT delivery_company_pk PRIMARY KEY ( id );

ALTER TABLE delivery_company
    ADD CONSTRAINT delivery_company_fleet_fk FOREIGN KEY ( fleet_id )
        REFERENCES fleet ( id );
/



-- Fleets

CREATE TABLE fleet (
    id           NUMBER(9) NOT NULL,
    start_date   DATE,
    end_date     DATE
);

ALTER TABLE fleet ADD CONSTRAINT fleet_pk PRIMARY KEY ( id );