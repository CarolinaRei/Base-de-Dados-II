create or replace synonym channels for oltp_2021.channels@query_link;
create or replace  synonym customers for oltp_2021.customers@query_link;
create or replace  synonym delivery_company for bdii_1701570.delivery_company;
create or replace  synonym employees for oltp_2021.employees@query_link;
create or replace  synonym fleet for bdii_1701570.fleet;
create or replace  synonym product_descriptions for oltp_2021.product_descriptions@query_link;
create or replace  synonym sales for oltp_2021.sales@query_link;


select * from fleet;

select * from sales;
