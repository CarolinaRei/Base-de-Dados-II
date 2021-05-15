-- Dimens�o simples (delivery company)

create sequence delivery_company_seq;

/

create or replace procedure etl_simple_dimension is
begin
  insert into dw_delivery_company (delivery_company_id, id, name, type, start_date, end_date)
  select delivery_company_seq.nextval, delivery_company.id, name, type, start_date, end_date
  from delivery_company, fleet
  where delivery_company.fleet_id = fleet.id;
end;
/

exec etl_simple_dimension;
/

select * from dw_delivery_company;
/