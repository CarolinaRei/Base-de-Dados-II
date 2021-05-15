-- Dimensão com a respetiva minidimensão (Products)

-- Código desenvolvido por Afonso Antunes - Nº 1701570

create or replace procedure etl_import_products is 
begin 
-- Error: PL/SQL: ORA-00913: demasiados valores
insert into dw_products (id, prod_id, name, description, price_max, price_min)
select prod_name, prod_desc, 
       prod_id, prod_weight_class, prod_unit_of_measure, prod_pack_size, prod_status, prod_list_price, prod_min_price, prod_cost,
       prod_subcategory, prod_subcat_desc,
       prod_category, prod_cat_desc
from product_descriptions, 
     products,  
     sub_categories, 
     categories
where products.prod_id not in (
    select prod_id 
    from dw_products
    )
  and products.prod_descriptions_id = product_descriptions.prod_desc_id
  and products.sub_cat_id = sub_categories.sub_cat_id
  and sub_categories.cat_id = categories.cat_id;
end;
/

exec etl_import_products;
/

select * from dw_products;
select * from dw_products_mini;