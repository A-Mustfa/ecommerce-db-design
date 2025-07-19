-- using 'like' :
select * from PRODUCT where product_name like '%camera%' or description like '%camera%';

-- the previous query won't use indexes cause of leading wild card problem (using '%' at the begging of the word)
-- so the solution will be
-- first: create indexes on columns we want to search in

create index nameindex on product(product_name)
create index descindex on product(description)

-- second: the query limiting leading wildcard

select *
from product
where product_name like 'camera%' or description like 'camera%'

----
-- using FULL-TEXT-SEARCH :
-- creating full text catalog

CREATE FULLTEXT CATALOG catalog1

-- creating full text index on columns we will search on
CREATE FULLTEXT INDEX ON product(
    product_name LANGUAGE 1033,
    description LANGUAGE 1033
)
KEY INDEX UX_Product_Id
ON catalog1;

-- search using contains
select *
from PRODUCT
where contains(product_name,'camera')
or contains(description, 'camera')