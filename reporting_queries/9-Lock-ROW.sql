-- transaction query to lock row with id=211 from being updated
begin transaction
	select *
	from PRODUCT with(UPDLOCK, ROWLOCK)
	where product_id = 211

