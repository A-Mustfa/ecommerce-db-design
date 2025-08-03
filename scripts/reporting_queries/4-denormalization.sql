create table denormalized_order(
order_id int primary key,
customer_id int,
first_name varchar(50),
last_name varchar(50),
total_amount int check (total_amount >=0)
)


insert into denormalized_order(order_id, customer_id, first_name, last_name, total_amount)
select o.order_id, c.customer_id, c.first_name, c.last_name, o.total_amount
from customer c join orders o on c.customer_id = o.customer_id
