-- Dimens�o simples (delivery company)

create sequence delivery_company_seq;

/

create or replace procedure etl_simple_dimension is
begin
  insert into dw_delivery_company (delivery_company_id, id, name, type, start_date, end_date)
  select delivery_company_seq.nextval, delivery_company.id, delivery_company.name, delivery_company.type, start_date, end_date
  from delivery_company, fleet
  where delivery_company.fleet_id = fleet.id;
end;
/

exec etl_simple_dimension;
/

select * from dw_delivery_company where delivery_company_id = 1000500;
/

select * from delivery_company;
select * from fleet;
/