## Write database functions to insert data in the product table around 100k rows :

```SQL
create or alter procedure sp_addProducts
as
begin
	set nocount on;

	DECLARE @startId INT;

--  نجيب آخر ID موجود في PRODUCT علشان نكمّل بعده
SELECT @startId = ISNULL(MAX(product_id), 0) FROM PRODUCT;

--  نضيف 100,000 Product
INSERT INTO PRODUCT (product_id, category_id, product_name, description, price, stock_quantity)
SELECT TOP 100000
    @startId + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS product_id,
    FLOOR(RAND(CHECKSUM(NEWID())) * 100) + 1,                        -- category_id عشوائي بين 1 و 100
    CONCAT('Product ', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    CONCAT('Description for product ', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
    ROUND(RAND(CHECKSUM(NEWID())) * 1000, 2),
    FLOOR(RAND(CHECKSUM(NEWID())) * 500) + 1
FROM master.dbo.spt_values v1
CROSS JOIN master.dbo.spt_values v2
WHERE v1.type = 'P' AND v2.type = 'P';

end;
go

exec sp_addProducts
```