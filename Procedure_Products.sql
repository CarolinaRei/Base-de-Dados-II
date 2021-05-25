-- Dimensão com a respetiva minidimensão (Products)

-- Código desenvolvido por Afonso Antunes - Nº 1701570

create sequence products_mini_seq;
/

create sequence products_seq;
/



-- Carregamento da minidimensão (dw_products_mini)

create or replace procedure etl_import_products_mini is 
begin 

    insert into dw_products_mini (id, pack_size_step, pack_size_min, pack_size_max)
    values (products_mini_seq.nextval, 'XS', 0.01, 0.10);
    
    insert into dw_products_mini (id, pack_size_step, pack_size_min, pack_size_max)
    values (products_mini_seq.nextval, 'S', 0.11, 0.15);
    
    insert into dw_products_mini (id, pack_size_step, pack_size_min, pack_size_max)
    values (products_mini_seq.nextval, 'M', 0.16, 0.20);
    
    insert into dw_products_mini (id, pack_size_step, pack_size_min, pack_size_max)
    values (products_mini_seq.nextval, 'L', 0.21, 0.25);
    
    insert into dw_products_mini (id, pack_size_step, pack_size_min, pack_size_max)
    values (products_mini_seq.nextval, 'XL', 0.26, 0.30);
    
    insert into dw_products_mini (id, pack_size_step, pack_size_min, pack_size_max)
    values (products_mini_seq.nextval, 'XXL', 0.31, 0.36);
    
    insert into dw_products_mini (id, pack_size_step, pack_size_min, pack_size_max)
    values (products_mini_seq.nextval, 'XXXL', 0.36, 0.40);
    
    commit;
end;
/

exec etl_import_products_mini;
/

select * from dw_products_mini;
/



-- Carregamento da dimensão (dw_products)

create or replace procedure etl_import_products is 
begin 
    insert into dw_products (id, 
                             prod_id,
                             products_mini_id,
                             name, 
                             description,
                             price_max,
                             price_min,
                             sub_category,
                             category)
    select
        products_seq.nextval, 
        prod_id,
        dw_products_mini.id,
        prod_name,
        prod_desc, 
        prod_list_price, 
        prod_min_price,
        prod_subcategory,
        prod_category
    from
        products,
        dw_products_mini,
        product_descriptions,
        sub_categories,
        categories
    where sub_categories.cat_id = categories.cat_id
    and products.sub_cat_id = sub_categories.sub_cat_id
    and products.prod_descriptions_id = product_descriptions.prod_desc_id;
end;
/

exec etl_import_products;
/

select * from dw_products;
/