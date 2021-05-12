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

create synonym sales for oltp_2021.sales@query_link;
/

-- Verificar
select * from oltp_2021.sales@query_link;
select * from sales;

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
	v_min_value NUMBER(9):= 1;
    v_max_value NUMBER(9):= 2;
    v_name_array namesarray;
    v_type_array typesarray;
    v_name VARCHAR2(20);
    v_type VARCHAR2(20);
    v_rand number(9);
    v_count number(9);
    v_delivery_company_fleet_fk number(9);
begin
    select min(sale_id), max (sale_id)
    into v_min_value, v_max_value
    from sales;
    
    v_name_array := namesarray('UPS', 'Amazon', 'Binni', 'Stack', 'Stark', 'CTT', 'DpD', 'HelloWorld');
    v_type_array := typesarray('Fisical', 'Mail', 'Data', 'Crypto', 'Stuff', 'All-Rounded');
    
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

-- Verificar/Testar

select * from delivery_company;
select * from sales;
select count(sale_id) from sales;
select count(id) from delivery_company;


-- Dar privilégio de select às tabelas extra ao utilizador BDII_1702033

grant select on delivery_company to BDII_1702033;
grant select on fleet to BDII_1702033;
/


-- Verificar que start_date não são mais recentes que end_date

select id, start_date, end_date
from fleet
where start_date > end_date;
/


-- Selecionar uma certa delivery_company ordenando os type por ordem alfabética

select name, type
from delivery_company
where name = 'CTT'
order by type asc;
/

