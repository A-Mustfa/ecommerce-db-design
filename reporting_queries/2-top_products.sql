 --Write an SQL query to generate a monthly report of the top-selling products in a given month.

declare @x int = 5

select top(3) p.product_name, sum(odetails.quantity) as  [total_quantity]
from product as p join order_details as odetails
on p.product_id = odetails.product_id join orders as o on o.order_id = odetails.order_id 
where MONTH(o.order_date) = @x
group by p.product_name
order by  [total_quantity] desc

---



