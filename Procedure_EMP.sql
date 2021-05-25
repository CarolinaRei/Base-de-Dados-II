

create sequence emp_seq;
create sequence mini_emp_seq;

select * from dw_employees;

select * from employees;

create or replace procedure procedure_employees is
    com_min_value NUMBER(5,3):= 1.00;
    com_max_value NUMBER(5,3):= 2.00;
    
    sal_min_value NUMBER(4):= 1;
    sal_max_value NUMBER(6):= 2;
    sal_min NUMBER(4):= 1;
    sal_max NUMBER(6):= 2;
    
    sal NUMBER(4):= 1;
    commissiom NUMBER(5,3):= 2;
    
    sal_pct NUMBER(3,2):=1.00;
    com_pct NUMBER(3,2):=1.00;
begin
    select min(salary), max(salary)
    into  sal_min_value, sal_max_value
    from employees;
    
    sal_min := sal_min_value-100;
    
    for lvl in 1..7 loop
        sal_max:= sal_min + 3000
        
        insert into mini_dw_employees(id, salary_min, salary_max, salary_level)
        select mini_emp_seq.nextval, sal_min, sal_max, lvl
        from employees;
        sal_min := sal_min + 3000
    end loop;
    
    
    insert into dw_employees(id, employee_id, employees_mini_id, first_name, last_name, manager_id, hire_date, phone_number, email, salary)
    select emp_seq.nextval, employee_id, func_sal_lvl(employee_id), first_name, last_name, manager_id, hire_date, phone_number, email, salary
    from employees, mini_dw_employees
    where salary > sal_min AND salary < sal_max;
end;
/


CREATE OR replace FUNCTION func_sal_lvl(
    employee_id NUMBER
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
        employees.employee_id = employee_id;

    
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

exec EMPLO;
/

select * from dw_delivery_company;
/