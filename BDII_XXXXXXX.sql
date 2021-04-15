-- Tabela extra principal (delivery_company)

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
		

-- Tabela extra de lookup (fleet)

CREATE TABLE fleet (
    id           NUMBER(9) NOT NULL,
    start_date   DATE,
    end_date     DATE
);

ALTER TABLE fleet ADD CONSTRAINT fleet_pk PRIMARY KEY ( id );
/


-- Database link para a BD operacional

create DATABASE LINK "QUERY_LINK"
   connect to "OLTP_QUERY" identified by values ':1'
   using '
  (DESCRIPTION =
    (ADDRESS = (PROTOCOL = TCP)(HOST = bd.ipg.pt)(PORT = 1521))
    (CONNECT_DATA =
      (SERVER = DEDICATED)
      (SERVICE_NAME = oltp)
    )
  )';
/


-- Synonym da tabela Sales da BD Operacional

create synonym sales_delivery_company for oltp_link.sales@query_link;
/

  
-- Procedures para fazer os inserts nas tabelas extra

create or replace procedure insert_extra_tables
is
begin
    delete delivery_company;
    delete fleet;
    
    fleet_extra_table;
    delivery_company_extra_table;
    
    commit;
end;
/


-- Procedures para fazer os inserts nas tabelas extra

create or replace procedure insert_extra_tables
is
begin
    delete delivery_company;
    delete fleet;
    
    fleet_extra_table;
    delivery_company_extra_table;
    
    commit;
end;
/

exec insert_extra_tables;
exec fleet_extra_table;
exec delivery_company_extra_table;


-- Lookup

create or replace procedure fleet_extra_table
is
    v_min NUMBER(30):= 1;
    v_max NUMBER(30):= 600;
    v_date NUMBER(30);
begin    
    for i in v_min..v_max loop 
        v_date := dbms_random.value(2458484, 2459944);
        insert into fleet (id, start_date, end_date)
        values(i, to_date(trunc(v_date),'j'), to_date(trunc(v_date + dbms_random.value(0, 60)),'j'));
    end loop;
end;
/


-- Principal

create or replace procedure delivery_company_extra_table
is
    type namesarray IS VARRAY(8) OF VARCHAR2(20);
    type typesarray IS VARRAY(6) OF VARCHAR2(20);
	v_min_value NUMBER(5):=1;
    v_max_value NUMBER(5):=600;
    v_name_array namesarray;
    v_type_array typesarray;
    v_name VARCHAR2(20);
    v_type VARCHAR2(20);
    v_rand number(9);
    v_count number(9);
    v_delivery_company_fleet_fk number(9);
begin
    v_name_array := namesarray('UPS', 'Amazon', 'Binni', 'Stack', 'Stark', 'CTT', 'DpD', 'HelloWorld');
    v_type_array := typesarray('Fisical', 'Mail', 'Data', 'Crypto', 'Stuff', 'All-Rounded');
    
	/*select min(delivery_company_id), max(delivery_company_id)
	into v_min_value, v_max_value
	from sales;*/
	
	for j in v_min_value..v_max_value loop
		v_name := v_name_array(trunc(dbms_random.value(1, v_name_array.count())));
        v_type := v_type_array(trunc(dbms_random.value(1, v_type_array.count())));
        
		select count(*)
		into v_count
		from fleet;
		
		v_rand := trunc(dbms_random.value(0, v_count));
		
		select id
		into v_delivery_company_fleet_fk
		from fleet
		offset v_rand rows
		fetch first 1 row only;
		
		insert into delivery_company(id, name, type, fleet_id)
		values(j, v_name, v_type, v_delivery_company_fleet_fk); 
	end loop; 
end;
/


-- Dar privilégio de select às tabelas extra ao utilizador BDII_1702033 

grant select on delivery_company to BDII_1702033;
grant select on fleet to BDII_1702033;


-- Tabela sales

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
    oltp_2021.sales (
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

