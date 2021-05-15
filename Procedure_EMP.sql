
create sequence emp_seq;
select * from dw_employees;

select * from employees;

create or replace procedure EMPLO is
    com_min_value NUMBER(5,3):= 1;
    com_max_value NUMBER(5,3):= 2;
    
    sal_min_value NUMBER(4,3):= 1;
    sal_max_value NUMBER(6,3):= 2;
begin
    select min(commission_pct), max(commission_pct), min(salary), max(salary)
    into com_min_value, com_max_value, sal_min_value, sal_max_value
    from employees;
    
    insert into dw_employees(id, employee_id, first_name, last_name, manager_id, hire_date, phone_number, email, commission_min, comission_max, salary_max, salary_min)
    select emp_seq.nextval, employee_id, first_name, last_name, manager_id, hire_date, phone_number, email, com_min_value, com_max_value, sal_max_value, sal_min_value
    from employees;
end;
/

exec ;
/

select * from dw_delivery_company;
/