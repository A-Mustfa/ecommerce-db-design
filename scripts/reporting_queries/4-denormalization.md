This script creates a **denormalized table** called `denormalized_order` to simplify reporting and analytics.
The table combines essential **customer information** with their corresponding **order data** in a single structure.

#### 🏗 **What it does:**

1. **Creates the table** `denormalized_order` with the following columns:

   * `order_id` → Primary key for each order.
   * `customer_id` → ID of the customer who made the order.
   * `first_name` & `last_name` → Customer’s name for reporting purposes.
   * `total_amount` → Total value of the order (with a CHECK constraint to ensure it’s not negative).

2. **Populates the table** using a `JOIN` between:

   * `customer` table (to fetch customer info).
   * `orders` table (to fetch order details).

#### 🎯 **Purpose:**

* Speeds up **reporting queries** by avoiding multiple JOINs every time.
* Useful for **dashboards** and **analytics** where order and customer details are frequently queried together.

```SQL
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
