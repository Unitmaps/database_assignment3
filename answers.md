## Answers:

1. What is the difference between a function and a procedure in PostgreSQL?

Функція виконує дії над даними та повертає значення, її можна використовувати у SELECT. Приклад функції - calculate_hipotenuse, що вираховує гіпотенузу по двом катетам; Процедура виконує послідовність дій, зазвичай не повертає значень, викликається через CALL. Наприклад, процедура increase_counter, що збільшує лічильник.

2. Can a trigger be executed manually? Why or why not?

Тригер складається з двох частин: тригерної функції та тіла тригера. Сам тригер неможливо викликати вручну, однак можливо викликати тригерну функцію через SELECT. Деякий функціонал, як NEW і OLD, буде недоступний, але тригерна функція виконається.

3. What are the advantages and disadvantages of storing business logic inside the database?

До переваг зберігання бізнес-логіки в базах даних належать більша швидкість (оскільки бекенду не потрібно йти до бази даних, він вже там) та висока надійність даних (налаштування безпеки та цілісності данних вибудовуються одазу в базі даних для усіх програм). Однак, напротивагу, таку бізнес логіку важче вибудовувати, підтримувати та масштабувати


## Execution time:

Hash Join  (cost=1.14..28.19 rows=7 width=64) (actual time=0.332..0.339 rows=2.00 loops=1)  
    &ensp;&ensp;&ensp;&ensp;Hash Cond: (oi.product_id = p.product_id)  
    &ensp;&ensp;&ensp;&ensp;Buffers: shared hit=2  
    &ensp;&ensp;&ensp;&ensp;->  Seq Scan on order_items oi  (cost=0.00..27.00 rows=7 width=28) (actual time=0.122..0.125 rows=2.00 loops=1)  
        &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Filter: (order_id = 1)  
        &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Rows Removed by Filter: 4  
        &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Buffers: shared hit=1  
    &ensp;&ensp;&ensp;&ensp;->  Hash  (cost=1.06..1.06 rows=6 width=12) (actual time=0.068..0.069 rows=6.00 loops=1)  
        &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Buckets: 1024  Batches: 1  Memory Usage: 9kB  
        &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Buffers: shared hit=1  
        &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;->  Seq Scan on products p  (cost=0.00..1.06 rows=6 width=12) (actual time=0.039..0.043 rows=6.00 loops=1)  
              &ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;&ensp;Buffers: shared hit=1  
Planning:  
    &ensp;&ensp;&ensp;&ensp;Buffers: shared hit=29  
Planning Time: 3.956 ms  
Execution Time: 0.658 ms  


Спочатку відбулося з'єднання по хешу (join products), потім повний скан таблиці для фільтрації (where oi.order_id = 1). За ним відбувся пошук по хешу для виводу стовпців з двох таблиць. Об'єднання через хеш таблиці та повний скан для фільтрації можна було б оптимізувати через створення відповідних індексів