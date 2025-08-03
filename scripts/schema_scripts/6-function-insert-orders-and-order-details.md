## Write database functions to insert data in order, order details tables around 2 , 5 million rows based on the inserted data in customers and products :

---
### Stored Procedure for ORDERS

```SQL
CREATE PROCEDURE sp_generate_orders @numOrders INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @startOrderId INT;
    SELECT @startOrderId = ISNULL(MAX(order_id), 0) FROM ORDERS;

    INSERT INTO ORDERS (order_id, customer_id, order_date, total_amount)
    SELECT TOP (@numOrders)
        @startOrderId + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS order_id,
        -- Random customer_id between 1 and 1,000,000
        FLOOR(RAND(CHECKSUM(NEWID())) * 1000000) + 1,
        -- Random date between 2019-01-01 and today
        DATEADD(DAY, -1 * FLOOR(RAND(CHECKSUM(NEWID())) * 1825), GETDATE()),
        0   -- placeholder, will update after we insert ORDER_DETAILS
    FROM master.dbo.spt_values v1
    CROSS JOIN master.dbo.spt_values v2
    CROSS JOIN master.dbo.spt_values v3
    WHERE v1.type = 'P' AND v2.type = 'P' AND v3.type = 'P';
END;
GO


EXEC sp_generate_orders 2000000;
```

---
### Stored Procedure for ORDER_DETAILS

```SQL
CREATE PROCEDURE sp_generate_order_details @numDetails INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @startDetailId INT;
    SELECT @startDetailId = ISNULL(MAX(order_detail_id), 0) FROM ORDER_DETAILS;

    INSERT INTO ORDER_DETAILS (order_detail_id, order_id, product_id, quantity, unit_price)
    SELECT TOP (@numDetails)
        @startDetailId + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS order_detail_id,
        -- Random order_id between 1 and 2,000,000
        FLOOR(RAND(CHECKSUM(NEWID())) * 2000000) + 1,
        -- Random product_id between 1 and 100,000
        FLOOR(RAND(CHECKSUM(NEWID())) * 100000) + 1,
        -- Random quantity (1-5)
        FLOOR(RAND(CHECKSUM(NEWID())) * 5) + 1,
        -- Random price (1 – 1000)
        ROUND(RAND(CHECKSUM(NEWID())) * 1000, 2)
    FROM master.dbo.spt_values v1
    CROSS JOIN master.dbo.spt_values v2
    CROSS JOIN master.dbo.spt_values v3
    WHERE v1.type = 'P' AND v2.type = 'P' AND v3.type = 'P';
END;
GO

EXEC sp_generate_order_details 5000000;
```

---
### After Insertion

We can update **`ORDERS.total_amount`** so it reflects the sum of its details:

```SQL
UPDATE O
SET O.total_amount = T.total
FROM ORDERS O
JOIN (
    SELECT order_id, SUM(quantity * unit_price) AS total
    FROM ORDER_DETAILS
    GROUP BY order_id
) T ON O.order_id = T.order_id;
```