## total revenue for a specific date :

- Write an SQL query to generate a daily report of the total revenue for a specific date.

```sql
declare @x date = '2025-02-21'

select sum(odetails.quantity * odetails.unit_price) as  [total revenue]
from orders as o join order_details as odetails
on o.order_id = odetails.order_id
and o.order_date = @x
```
### alternate query 

```SQL
declare @x date = '2025-02-21'

select sum(o.total_amount) as  [total revenue]
from orders as o 
where o.order_date = @x
```
