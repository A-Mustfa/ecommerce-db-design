SELECT P.product_id as [product id], p.product_name as [product name], p.category_id as [category id], p.product_author as [product author]
from product p join (select p.product_id as 'p_id' , p.category_id as 'c_id' , p.product_author 'p_author' from product p join order_details od
on p.product_id = od.product_id join orders o on o.order_id = od.order_id
where o.customer_id = 5) as joinTable on p.product_author = joinTable.p_author
and p.category_id = joinTable.c_id 
where p.product_id != joinTable.p_id ;