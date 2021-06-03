select * from sales_rows sr;/
select * from sales;/
select * from dw_customers;/
    select employees_mini_id
    from dw_employees
    where dw_employees.employee_id = 160;
/
SELECT * FROM DW_EMPLOYEES_MINI
/
SELECT * FROM DW_EMPLOYEES WHERE EMPLOYEES_MINI_ID > 8;
/
select count(*) from sales s, sales_rows sr;
select count(*) from sales s join sales_rows sr on(s.SALE_ID = sr.SALE_ID) join dw_customers cst on (cst.cust_id = s.cust_id);

select 1, 2, 3, 4, 5, func_date_id(trunc(sale_date),0), func_employees_id(s.employee_id),
    func_mini_emp_id(s.employee_id), func_products_id(sr.prod_id), 
    func_mini_prod_id(sr.prod_id), s.cust_id,define_class(cst.cust_income_level), define_age_gap(cst.cust_year_of_birth, extract(YEAR from sysdate)),func_delivery_id(s.delivery_id) from sales s join sales_rows sr on(s.SALE_ID = sr.SALE_ID) join dw_customers cst on (cst.cust_id = s.cust_id) join dw_employees emp on (emp.employee_id = s.employee_id) join dw_employees_mini emp_mini on (emp.employees_mini_id = emp_mini.id) where emp_mini.id < 1000;