# E-Commerce Database Design

This project contains a relational database schema for a simple e-commerce web store, including:

- Product and Category management
- Customer and Orders structure
- Sample data for testing
- Useful reporting queries

## 📂 Structure

- [Tables Structure](schema/tables_structure.sql) : SQL script to create all tables with constraints and relationships
- [Sample Data](schema/sample_data.sql) : Sample data (100+ rows) to populate the tables
- [Queries](queries/) : Useful analytics and business queries

## 📊 ER Diagram

![Conceptual Data Model](diagrams/ERD.png)

![Conceptual Data Model](diagrams/schema.png)

## 💡 Example Query

```sql
-- Top 3 selling products in May
select top(3) p.product_name, sum(odetails.quantity) as  [total_quantity]
from product as p join order_details as odetails
on p.product_id = odetails.product_id join orders as o on o.order_id = odetails.order_id 
where MONTH(o.order_date) = 5
group by p.product_name
order by  [total_quantity] desc;
```

## 👨‍💻 Technologies
- SQL Server 
- SQL
