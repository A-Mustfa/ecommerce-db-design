# E-Commerce Database Design

This project contains a relational database schema for a simple e-commerce web store, including:

- Product and <u>Category</u> management
- Customer and Orders structure
- Sample data for testing
- Useful reporting queries
---
## 📂 Structure

- [Tables Structure](schema/tables_structure.sql) : SQL script to create all tables with constraints and relationships
- [Sample Data](schema/sample_data.sql) : Sample data (100+ rows) to populate the tables
- [Queries](reporting_queries/) : Useful analytics and business queries
---
## 📊 ER Diagram

![Conceptual Data Model](diagrams/ERD.png)

![Conceptual Data Model](diagrams/schema.png)

---
## 💡 Reporting Queries

### 1. total revenue for a specific date :
```sql
declare @x date = '2025-02-21'

select sum(odetails.quantity * odetails.unit_price) as  [total revenue]
from orders as o join order_details as odetails
on o.order_id = odetails.order_id
and o.order_date = @x


---
-- alternate query 

declare @x date = '2025-02-21'

select sum(o.total_amount) as  [total revenue]
from orders as o 
where o.order_date = @x
```

### 2.  top-selling products in a given month:
```sql
declare @x int = 5

select top(3) p.product_name, sum(odetails.quantity) as  [total_quantity]
from product as p join order_details as odetails
on p.product_id = odetails.product_id join orders as o on o.order_id = odetails.order_id 
where MONTH(o.order_date) = @x
group by p.product_name
order by  [total_quantity] desc
```

### 3. orders totaling more than $500 in the past month:
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

### 4. denormalization table .
```sql
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
```

### 5. all products with the word "camera" in either the product name or description:
```sql
select * from PRODUCT where product_name like '%camera%' or description like '%camera%';
```

### 6. query to suggest popular products in the same category for the same author:
```sql
SELECT P.product_id as [product id],
        p.product_name as [product name],
        p.category_id as [category id],
        p.product_author as [product author]
from product p join (select p.product_id as 'p_id' , p.category_id as 'c_id' , p.product_author 'p_author'
                      from product p join order_details od
                      on p.product_id = od.product_id join orders o on o.order_id = od.order_id
                      where o.customer_id = 5) as joinTable
on p.product_author = joinTable.p_author
    and p.category_id = joinTable.c_id 
where p.product_id != joinTable.p_id ;
```
---
## 👨‍💻 Technologies
- SQL Server 
- SQL
