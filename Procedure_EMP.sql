

create sequence emp_seq;
create sequence mini_emp_seq;

drop sequence emp_seq;
drop sequence mini_emp_seq;

select * from dw_employees;

select * from dw_employees_mini;
select * from employees;


/*-----------------------------------------------------------------------------------------------------------------------------------
PROCEDURE MINI
---------------------------------------------------------------------------------------------------------------------------------------*/

exec procedure_employees_mini;

create or replace procedure procedure_employees_mini is
    sal_min_value NUMBER(4):= 1;
    sal_min NUMBER(6):= 1;
    sal_max NUMBER(6):= 2;
    
begin

    select min(salary)
    into  sal_min_value
    from employees;

    sal_min := sal_min_value-100;
    sal_max := sal_min +3000;
    
    for loop_p in 1..8 loop
        insert into dw_employees_mini(id, salary_min, salary_max, salary_level)
        values (mini_emp_seq.nextval, sal_min, sal_max, mini_emp_seq.currval);
        sal_min := sal_min + 3000;
        sal_max:= sal_min + 3000;
    end loop;
end;
/


create or replace procedure procedure_employees is
    sal_min_value NUMBER(4):= 1;
    sal_max_value NUMBER(6):= 2;
    sal_min NUMBER(6):= 1;
    sal_max NUMBER(6):= 2;
    
    sal NUMBER(4):= 1;
    
    sal_pct NUMBER(3,2):=1.00;
begin
    select min(salary), max(salary)
    into  sal_min_value, sal_max_value
    from employees;
    
    sal_min := sal_min_value-100;
    sal_max := sal_min +3000;
    
    
        if cenas = 1 
        insert into dw_employees_mini(id, salary_min, salary_max, salary_level)
        select mini_emp_seq.nextval, sal_min, sal_max, mini_emp_seq.currval
        from employees;
        
        sal_min := sal_min + 3000;
        sal_max:= sal_min + 3000;
        
    
    insert into dw_employees(id, employee_id, employees_mini_id, first_name, last_name, manager_id, hire_date, phone_number, email, salary)
    select emp_seq.nextval, employee_id, func_sal_lvl(employee_id), first_name, last_name, manager_id, hire_date, phone_number, email, salary
    from employees, dw_employees_mini
    where employee_id<100;
    
    
end;
/


CREATE OR replace FUNCTION func_sal_lvl(
    p_employee_id NUMBER
) RETURN NUMBER IS
    salary_               employees.salary%TYPE;
    salvl                 dw_employees_mini.salary_level%TYPE;
    id_                   NUMBER;
BEGIN  
    SELECT
        salary
    INTO salary_ 
    FROM
        employees
    WHERE
        employee_id = p_employee_id;

    
    IF salary_ >= 2000 AND salary_ <= 5000 THEN
        salvl := 1;
    ELSIF salary_ >= 5000 AND salary_ <= 9000 THEN
        salvl := 2;
    ELSIF salary_ >= 9000 AND salary_ <= 12000 THEN
        salvl := 3;
    ELSIF salary_ >= 12000 AND salary_ <= 15000 THEN
        salvl := 4;
    ELSIF salary_ >= 15000 AND salary_ <= 18000 THEN
        salvl := 5;
    ELSIF salary_ >= 18000 AND salary_ <= 21000 THEN
        salvl := 6;
    ELSIF salary_ >= 21000 AND salary_ <= 24000 THEN
        salvl := 7;
    END IF;

    SELECT
        id
    INTO id_
    FROM
        dw_employees_mini
    WHERE
        salary_level = salvl;

    
    RETURN id_;
END func_sal_lvl;
/
exec procedure_employees;
/

select * from dw_delivery_company;
/