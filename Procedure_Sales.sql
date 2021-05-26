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
    select all_products, , customers_all, employees_all, dw_date.id, dw_employees.id
    from 
end;
/