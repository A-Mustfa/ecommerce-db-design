# 📊 Case 4 – List Products That Have Low Stock Quantities

## 📌 Problem Statement
We needed to retrieve **products with low stock (less than 10 units)**.  
The table was large, and the query was **scanning the entire table** to filter rows.

```sql
SELECT product_id AS [product id], 
       product_name AS [product_name], 
       stock_quantity AS [stock quantity]
FROM product
WHERE stock_quantity < 10;
```

---

## ⏱️ Before Optimization

**Query Stats:**

* **PRODUCT Table**
  * Logical Reads: **4,860**
* **Execution Time**
  * CPU time: **31 ms**
  * Elapsed time: **147 ms**

---

## 📊 Execution Plan (Before)

![[case-4-before.png]]

---

## 🔧 Optimization Applied

✅ **Added a non-clustered index** on `stock_quantity`  
✅ **Included `product_name`** in the index so SQL Server can retrieve it **without key lookups**

```sql
CREATE INDEX IX_Product_StockQuantity
ON product (stock_quantity)
INCLUDE (product_name);
```

---

## 🚀 After Optimization

**Query Stats:**

* **PRODUCT Table**
  * Logical Reads: **38** (↓ from 4,860)
* **Execution Time**
  * CPU time: **47 ms**
  * Elapsed time: **295 ms**

---

## 📊 Execution Plan (after)

![[case-4-after.png]]

---

## 📈 Comparison Table

| Metric            | Before Index | After Index |                             Improvement |
| ----------------- | -----------: | ----------: | --------------------------------------: |
| Logical Reads     |        4,860 |          38 |                               **-99%**✅ |
| CPU Time (ms)     |           31 |          47 |                           Slight change |
| Elapsed Time (ms) |          147 |         295 | Slightly higher (first run after index) |

---

## 💡 What I Learned

* ✅ **Indexing on `stock_quantity`** turned a full table scan into a **targeted index seek**.
* ✅ **Including `product_name`** eliminated extra key lookups, so SQL Server didn’t need to go back to the table.
* 📉 Logical Reads dropped **from 4,860 → 38** (≈ 99% improvement).
* ℹ️ Elapsed time was slightly higher because this was the **first query run after index creation** — would typically stabilize and get faster with caching.

---

✅ This case shows how **a simple covering index** can dramatically reduce the work SQL Server needs to do for a basic filter query.
