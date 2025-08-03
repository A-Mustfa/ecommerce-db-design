## transaction query to lock field 'quantity' from being updated :

```sql
BEGIN TRANSACTION
    SELECT stock_quantity
    FROM product WITH (UPDLOCK)
    WHERE product_id = 211
```

 - also we can create trigger to prevent this field from being updated cause in previous query the lock is on the entire row not the field only

```SQL
create trigger quantityTrigger
on product 
instead of update
as
begin
	if update(stock_quantity)
	Begin
		if exists (select 1 from inserted i where product_id = 211)
		begin
			raiserror('this field is locked',16,1);
			return;
		end

		update p
		set p.stock_quantity = i.stock_quantity
		from inserted i join product p
		on p.product_id = i.product_id
	End
end
```