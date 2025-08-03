### 1. create 'CATEGORY: table :

```SQL
CREATE TABLE CATEGORY(
category_id int primary key,
category_name varchar(20) not null
);
```

---
### 2. create 'PRODUCT' table :

```SQL
CREATE TABLE PRODUCT(
product_id int primary key,
category_id int,
product_name varchar(50) not null,
description varchar(100),
price DECIMAL(10,2) not null default 0 check(price >= 0),
stock_quantity int not null default 0 check(stock_quantity >= 0) ,

constraint P_FK FOREIGN KEY (category_id) REFERENCES CATEGORY(category_id)

);
```

---
### 3. create 'CUSTOMER' table :

```SQL
CREATE TABLE CUSTOMER(
customer_id int primary key,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(100) unique not null,
password varchar(100) not null
);
```

---
### 4. create 'ORDERS' table :

```SQL
CREATE TABLE ORDERS(
order_id int primary key,
customer_id int,
order_date date default(getdate()),
total_amount int default 0 check(total_amount >= 0),
constraint O_FK FOREIGN KEY (customer_id) REFERENCES CUSTOMER(customer_id)
);
```

---
### 5. create 'ORDER_DETAILS' table :

```SQL
 CREATE TABLE ORDER_DETAILS(
order_detail_id int primary key,
order_id int not null,
product_id int not null,
quantity int,
unit_price DECIMAL(10,2) not null,

constraint ODO_FK FOREIGN KEY (order_id) REFERENCES ORDERS(order_id),
constraint ODP_FK FOREIGN KEY (product_id) REFERENCES PRODUCT(product_id)
);

