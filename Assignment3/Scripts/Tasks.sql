create or replace function calculate_order_total (p_order_id int)
returns numeric(10, 2)
language sql

as $$

select coalesce(SUM(quantity * price), 0)
from order_items
where order_id = p_order_id;

$$;

create or replace procedure create_order(p_customer_id int)
language plpgsql 
as $$
begin
if not exists (select 1 from customers where customer_id = p_customer_id)
then return;
end if;
insert into orders (customer_id, order_date, total_amount) values(p_customer_id, now(), 0);
end;
$$;

create or replace procedure add_product_to_order(
    p_order_id int,
    p_product_id int,
    p_quantity int
)
language plpgsql 
as $$
begin
if (p_quantity <= 0) or not exists (select 1 from products where product_id = p_product_id and stock_quantity >= p_quantity)
then return;
end if;
insert into order_items (order_id, product_id, quantity, price) values(p_order_id, p_product_id, p_quantity, (select price from products where product_id = p_product_id));
update products set stock_quantity = stock_quantity - p_quantity where product_id = p_product_id;
end;
$$;

create or replace function upd_total_order()
returns trigger
language plpgsql
as $$
begin
update orders set total_amount = calculate_order_total(order_id) where order_id = order_id or order_id = old.order_id;
return new;
end;
$$;

create or replace trigger trg_u_total_order
after insert or delete or update on order_items
for each row
execute function upd_total_order();


create or replace function add_to_log()
returns trigger
language plpgsql
as $$
begin
insert into order_log (order_id, customer_id, action, log_date) values (new.order_id, new.customer_id, 'new order', now());
return new;
end;
$$;

create or replace trigger trg_logging
after insert on orders
for each row
execute function add_to_log();



-- TESTING AREA


-- Creating customer:

insert into customers (full_name, email, balance) values ('Andrew Jons', 'jons@example.com', 499.99);


-- Creating product:

insert into products (product_name, price, stock_quantity) values ('Speakers', 120, 200);


-- Creating order:

call create_order(5);


-- Add products to order:

call add_product_to_order(4, 6, 4);


-- Order totals are updated automatically
-- Product stock decreases correctly
-- Order creation is logged in order_log.