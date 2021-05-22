

create sequence emp_seq;
create sequence mini_emp_seq;

select * from dw_employees;

select * from employees;

create or replace procedure procedure_employees is
    com_min_value NUMBER(5,3):= 1.00;
    com_max_value NUMBER(5,3):= 2.00;
    
    sal_min_value NUMBER(4):= 1;
    sal_max_value NUMBER(6):= 2;
    
    sal NUMBER(4):= 1;
    commissiom NUMBER(5,3):= 2;
    
    sal_pct NUMBER(3,2):=1.00;
    com_pct NUMBER(3,2):=1.00;
begin
    select min(commission_pct), max(commission_pct), min(salary), max(salary), avg(salary)
    into com_min_value, com_max_value, sal_min_value, sal_max_value, avg_salary
    from employees;
    
    insert into mini_dw_employees(id, salary_min, salary_max, salary_level)
    select mini_emp_seq.nextval, sal_pt, com_pct;
    
    insert into dw_employees(id, employee_idk employees_mini_id, first_name, last_name, manager_id, hire_date, phone_number, email, salary)
    select emp_seq.nextval, employee_id, id, first_name, last_name, manager_id, hire_date, phone_number, email, salary
    from employees, mini_dw_employees;
end;
/

exec EMPLO;
/

select * from dw_delivery_company;
/