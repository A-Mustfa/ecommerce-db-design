## Write database functions to insert data in the category table around 100 rows

```SQL
create or alter procedure sp_addCategory @nOfRows int
as
begin
set nocount on;

	DECLARE @i INT = 6;

	WHILE @i <= @nOfRows
	BEGIN
		 INSERT INTO CATEGORY (category_id, category_name)
		  VALUES (
		    @i,
		   CONCAT('Category ', @i)
		  );

		SET @i += 1;
	END;

end;
go

exec sp_addCategory 100
```
