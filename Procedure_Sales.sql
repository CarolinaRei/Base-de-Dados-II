select * from sales;

/ --procedure for inserting facts
create or replace procedure procedure_sales is
begin
    
    insert into dw_sales(product_quantity, total_sold_quantity, total_sold_amount, total_customers, total_employees, date, employees, employees_mini, products, products_mini, customers, social_class, age_gap, delivery_company)
    select count(prod_id), count(quantity_sold), sum(amount_sold), count(cust_id), count(employee_id), func_date_id(trunc(sale_date)), func_employees_id(employee_id),
    func_mini_emp_id(employee_id), func_products_id(prod_id), 
    func_mini_prod_id(prod_id), func_customers_id(cust_id), func_social_id(cust_id), func_age_id(cust_id),func_Delivery_id(delivery_id)
    from sales, sales_rows ; 
end;
/

 --Selects to test out functions
select func_date_id(sale_date), sale_date from sales  where employee_id = 203 ;
select func_employees_id(employee_id) from sales  where employee_id = 160;
select func_mini_emp_id(employee_id) from sales  where employee_id = 160;
select func_products_id(prod_id), dw_products_mini.id from dw_products, dw_products_mini  where prod_id = 9750;
select func_mini_prod_id(prod_id) from dw_products where prod_id = 9750;
select func_Delivery_id(delivery_id) from sales;
select func_customers_id(cust_id) from sales;
select func_social_id(cust_id) from sales where cust_id = 161270;
select func_age_id(cust_id) from sales where cust_id = 161270;


 --function for date (gets dw_ID using the date from sales)
create or replace function func_date_id (
    p_date date
)return number is
    date_id dw_date.dateid%TYPE;
begin

    select dateid
    into date_id
    from dw_date
    where dw_date.dateformat = p_date;

    return date_id;
end;
/

 --function for employees (gets dw_ID using the sales ID)

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
--function for employees mini dimension (gets dw_ID using the sales ID)
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
--function for products (gets all 6 correspondent product_IDs using the sales_row ID)

CREATE OR replace FUNCTION func_products_id(
    p_products_id NUMBER
) RETURN NUMBER IS
     products_dim_id                   NUMBER;
     length_saver number;
BEGIN 
    select count(products_mini_id)
    into length_saver
    from dw_products
    where dw_products.prod_id = p_products_id;
    
    for lvl in 1..length_saver loop
        select id
        into products_dim_id
        from dw_products
        where dw_products.prod_id = p_products_id
        and products_mini_id=lvl;
        return products_dim_id;
    end loop;
END func_products_id;
/
--function for products mini dimension (gets all 6 correspondent mini_product_IDs using the sales_row ID)

CREATE OR replace FUNCTION func_mini_prod_id(
    p_products_id NUMBER
) RETURN NUMBER IS
     products_dim_id                   NUMBER;
     length_saver number;
BEGIN 
    select count(products_mini_id)
    into length_saver
    from dw_products
    where dw_products.prod_id = p_products_id;
    
    for lvl in 1..length_saver loop
        select products_mini_id
        into products_dim_id
        from dw_products
        where dw_products.prod_id = p_products_id
        and products_mini_id=lvl;
        
        return products_dim_id;
    end loop;
END func_mini_prod_id;
/
--function for customer dimension (gets dw_ID using the sales ID)

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
--function for social id mini dimension (gets dw_ID using the sales ID)

CREATE OR replace FUNCTION func_social_id(
    p_customers_id NUMBER
) RETURN NUMBER IS
     social_dim_id                   NUMBER;
BEGIN 
    select cust_social_class
    into social_dim_id
    from dw_customers
    where dw_customers.cust_id = p_customers_id;
    
    return social_dim_id;
END func_social_id;
/
--function for age id mini dimension (gets ID using the sales ID)

CREATE OR replace FUNCTION func_age_id(
    p_customers_id NUMBER
) RETURN NUMBER IS
     age_dim_id                   NUMBER;
BEGIN 
    select cust_age_group
    into age_dim_id
    from dw_customers
    where dw_customers.cust_id = p_customers_id;
    
    return age_dim_id;
END func_age_id;
/
--function for delivery id mini dimension (gets ID using the sales ID)

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

