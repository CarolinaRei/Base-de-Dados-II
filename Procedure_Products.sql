-- Dimensão com a respetiva minidimensão (Products)

-- Código desenvolvido por Afonso Antunes - Nº 1701570

create sequence products_mini_seq;
/
drop sequence products_mini_seq;
/
create sequence products_seq;
/


-- Carregamento da minidimensão (dw_products_mini)

create or replace procedure etl_import_products_mini is 
begin 
    insert into dw_products_mini (id, pack_size_step, pack_size_min, pack_size_max)
    values (products_mini_seq.nextval, 'XXS', 0.01, 0.05);
    
    insert into dw_products_mini (id, pack_size_step, pack_size_min, pack_size_max)
    values (products_mini_seq.nextval, 'XS', 0.06, 0.10);
    
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
    for etl_products in (
        select distinct prod_id,
                        prod_name, 
                        prod_desc, 
                        prod_list_price, 
                        prod_min_price
        from product_descriptions, 
             products
        where products.prod_descriptions_id = product_descriptions.prod_desc_id
    )
    loop
        insert into dw_products (id, 
                                 prod_id,
                                 -- products_mini_id,
                                 name, 
                                 description, 
                                 price_max, 
                                 price_min)
        values (
            products_seq.nextval, 
            etl_products.prod_id,
            -- dw_products_mini.id,
            etl_products.prod_name,
            etl_products.prod_desc, 
            etl_products.prod_list_price, 
            etl_products.prod_min_price
            )
            -- TODO: Incluir a chave estrangeira que liga a dimensão à minidimensão
            where dw_products.products_mini_id = dw_products_mini.id;
    end loop;
end;
/


exec etl_import_products;
/

select * from dw_products;
/

select * from products;