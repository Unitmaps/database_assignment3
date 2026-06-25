create or replace function calculate_order_total (p_order_id int)
returns integer
language sql

as $$

select coalesce(SUM(quantity * price), 0)
from order_items
where order_id = p_order_id

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