## orders totalling more than $500 in the past month:

- Write a SQL query to retrieve a list of customers who have placed orders totalling more than $500 in the past month. Include customer names and their total order amounts. [Complex query].

```sql
select c.first_name + ' ' + c.last_name as customer_name , sum(odetails.quantity * odetails.unit_price) as [total_order_amount]
FROM customer c join orders o on c.customer_id = o.customer_id
	join order_details odetails on o.order_id = odetails.order_id
WHERE 
    o.order_date >= DATEADD(MONTH, -1, DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1))
    AND o.order_date < DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
GROUP BY c.customer_id, c.first_name, c.last_name
having sum(odetails.quantity * odetails.unit_price) > 500
```