create or replace function calculate_order_total (p_order_id int)
returns integer
language sql

as $$

select coalesce(SUM(quantity * price), 0)
from order_items
where order_id = p_order_id

$$;