-- Dimensão com a respetiva minidimensão (Products)

-- Código desenvolvido por Afonso Antunes - Nº 1701570

create sequence products_mini_seq;
/

create sequence products_seq;
/


-- Carregamento da minidimensão (dw_products_mini)
-- TODO: insert values on steps

create or replace procedure etl_import_products_mini is 
begin 
    for etl_products_mini in (
        select distinct promo_id,
                        discount_pct,
                        promo_begin_date,
                        promo_end_date,
                        prod_status
        from promotions,
             sales_rows,
             products
        where sales_rows.promotion_id = promotions.promo_id 
          and sales_rows.prod_id = products.prod_id
    )
    loop
        insert into dw_products_mini (id, 
                                      promo_id, 
                                      price_percentage, 
                                      promotion_start_date, 
                                      promotion_end_date, 
                                      status_products)
        values (
            products_mini_seq.nextval, 
            etl_products_mini.promo_id,
            etl_products_mini.discount_pct,
            etl_products_mini.promo_begin_date,
            etl_products_mini.promo_end_date,
            etl_products_mini.prod_status
        );
    end loop;
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