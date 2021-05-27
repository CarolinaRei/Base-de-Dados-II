select * from dw_sales;

/
create or replace procedure procedure_sales is
    all_products NUMBER :=0;
    total_price NUMBER :=0;
    employees_all NUMBER :=0;
    customers_all NUMBER :=0;
begin
    select count(*)
    into all_products
    from dw_products;
    
    select count(*)
    into customers_all
    from dw_customers;
    
    select count(*)
    into employees_all
    from dw_employees;
    
    insert into dw_sales(product_quantity, total_price, total_customers, total_employees, date, employees, employees_mini, products, products_mini, customers, social_class, age_gap, delivery_company)
    select count(prod_id), sum(prod_cost), count(cust_id), count(employee_id), func_date_id(trunc(sale_date)), func_employees_id(employee_id),
    func_mini_emp_id(employee_id), func_products_id(prod_id), 
    func_mini_prod_id(prod_id), func_customers_id(cust_id), func_social_id(cust_id)/*SDADASDASASFASFlater*/, func_age_id(cust_id)/*ASDASDSADASDADASDlater*/,func_Delivery_id(id)
    from sales, sales_rows;
end;
/
select * from dw_date;
create or replace function func_date_id (
    p_date date
)return number is
    date_id dw_date.id%TYPE;
begin

    select id
    into date_id
    from dw_date
    where dw_date.data = p_date;

    return date_id;
end;
/

select * from sales;

CREATE OR replace FUNCTION func_employees_id(
    p_employee_id NUMBER
) RETURN NUMBER IS
     employee_dim_id                   NUMBER;
BEGIN 
    select id
    into employee_dim_id
    from dw_employees
    where dw_employees.employee_id = p_employee_id;
    
    return employee_dim_id;
END func_employees_id;
/
CREATE OR replace FUNCTION func_mini_emp_id(
    p_employee_id NUMBER
) RETURN NUMBER IS
     employee_dim_id                   NUMBER;
BEGIN 
    select employees_mini_id
    into employee_dim_id
    from dw_employees
    where dw_employees.employee_id = p_employee_id;
    
    return employee_dim_id;
END func_mini_emp_id;
/
select * from products;

CREATE OR replace FUNCTION func_products_id(
    p_products_id NUMBER
) RETURN NUMBER IS
     products_dim_id                   NUMBER;
BEGIN 
    select id
    into products_dim_id
    from dw_products
    where dw_products.prod_id = p_products_id;
    
    return products_dim_id;
END func_products_id;
/
select * from products;

CREATE OR replace FUNCTION func_mini_prod_id(
    p_products_id NUMBER
) RETURN NUMBER IS
     products_dim_id                   NUMBER;
BEGIN 
    select product_mini_id
    into products_dim_id
    from dw_products
    where dw_products.prod_id = p_products_id;
    
    return products_dim_id;
END func_mini_prod_id;
/
select * from customers;

CREATE OR replace FUNCTION func_customers_id(
    p_customers_id NUMBER
) RETURN NUMBER IS
     customers_dim_id                   NUMBER;
BEGIN 
    select id
    into customers_dim_id
    from dw_customers
    where dw_customers.cust_id = p_customers_id;
    
    return customers_dim_id;
END func_customers_id;
/
select * from Delivery_company;

CREATE OR replace FUNCTION func_Delivery_id(
    p_Delivery_id NUMBER
) RETURN NUMBER IS
     Delivery_dim_id                   NUMBER;
BEGIN 
    select delivery_company_id
    into Delivery_dim_id
    from dw_Delivery_company
    where dw_Delivery_company.id = p_Delivery_id;
    
    return Delivery_dim_id;
END func_Delivery_id;

