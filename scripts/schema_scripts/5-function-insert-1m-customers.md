## Write database functions to insert data in customer tables around 1million rows

```SQL
CREATE PROCEDURE sp_generate_customers @numRows INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @startId INT;

    -- ✅ If customer_id is NOT Identity, find the max existing ID
    SELECT @startId = ISNULL(MAX(customer_id), 0) FROM CUSTOMER;

    -- ✅ Insert @numRows rows
    INSERT INTO CUSTOMER (customer_id, first_name, last_name, email, password)
    SELECT TOP (@numRows)
        @startId + ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS customer_id,
        CONCAT('FirstName', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
        CONCAT('LastName', ROW_NUMBER() OVER (ORDER BY (SELECT NULL))),
        CONCAT('user', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), '@mail.com'),
        CONCAT('Pass', ROW_NUMBER() OVER (ORDER BY (SELECT NULL)), '!23')
    FROM master.dbo.spt_values v1
    CROSS JOIN master.dbo.spt_values v2
    CROSS JOIN master.dbo.spt_values v3
    WHERE v1.type = 'P' AND v2.type = 'P' AND v3.type = 'P';
END;
GO

exec sp_generate_customers 1000000
```