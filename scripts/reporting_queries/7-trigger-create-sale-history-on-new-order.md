## trigger to Create a sale history [Above customer, product], when a new order is made in the "Orders" table :

### first: we create sales_history table :

```sql
create table Sale_History(
orderId int not null,
CustId int not null,
CustName varchar(22) not null,
ProductName varchar(20) not null,
total_amount decimal(10,2),
quantity int,
order_date date,
Foreign key (CustId) references customer(customer_id),
Foreign key (orderId) references orders(order_id) )
```
### second: trigger code

```SQL
create trigger saleHistoryTrigger
on orders
after insert
as
	insert into Sale_History(orderId, CustId, CustName, ProductName, total_amount, quantity, order_date)
	select 
		i.order_id,
		c.customer_id,
		c.first_name ,
		p.product_name,
		od.quantity * od.unit_price as total_amount
		, od.quantity, i.order_date
	from inserted i
	join Customer c on i.customer_id = c.customer_id
	join ORDER_DETAILS od on od.order_id = i.order_id
	join PRODUCT p on p.product_id = od.product_id
```