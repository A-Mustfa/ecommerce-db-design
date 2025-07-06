--  Write a SQL query to search for all products with the word "camera" in either the product name or description.
select * from PRODUCT where product_name like '%camera%' or description like '%camera%';
