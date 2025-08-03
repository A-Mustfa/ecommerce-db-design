# 📊 Case 1 – Retrieve Total Number of Products in Each Category

## 📌 Problem Statement
We needed to retrieve the total number of products in each category efficiently.  
The original query was running **very slowly** as the `product` table grew larger, because SQL Server was doing a **Full Table Scan**.

```sql
SELECT c.category_name,
       COUNT(p.product_id) AS total_products
FROM products p
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;
````

---

## ⏱️ Before Optimization

**Query Stats:**

- **CATEGORY Table**
    
    - Logical Reads: 4
        
    - Physical Reads: 1
        
- **PRODUCT Table**
    
    - Logical Reads: 5,103
        
    - Physical Reads: 2
        
- **Execution Time**
    
    - **CPU time:** 16 ms
        
    - **Elapsed time:** **35,148 ms (~35 sec)**
        

SQL Server had to scan the entire `product` table, which became very costly as data volume increased.

---

## 📊 Execution Plan (Before)

![[case-1-before.png]]

---

## 🔧 Optimization Applied

- ✅ Added an index on `product(category_id)` including `product_id`
    
- ✅ Added an index on `category(category_id)` including `category_name`
    

```sql
CREATE INDEX IX_Product_CategoryID
ON product (category_id)
INCLUDE (product_id);

CREATE INDEX IX_Category_CategoryID
ON category (category_id)
INCLUDE (category_name);
```

---

## 🚀 After Optimization

**Query Stats:**

- **CATEGORY Table**
    
    - Logical Reads: 2
        
    - Physical Reads: 0
        
- **PRODUCT Table**
    
    - Logical Reads: **878** (↓ from 5,103)
        
    - Physical Reads: 0
        
- **Execution Time**
    
    - **CPU time:** 94 ms
        
    - **Elapsed time:** **150 ms (~0.15 sec)**
        

---

## 📊 Execution Plan (After)

![[case-1-after.png]]

---

## 📈 Comparison Table

|Metric|Before Index|After Index|Improvement|
|---|--:|--:|--:|
|Logical Reads|5,103|878|**-82%**|
|CPU Time (ms)|16|94|Slight ↑|
|Elapsed Time (ms)|35,148 (35 sec)|150 (0.15 sec)|**-99.5%**|

---

## 💡 What I Learned

- **Indexes dramatically reduced I/O:** Logical reads dropped by **82%**.
    
- **Performance skyrocketed:** Elapsed time went from **35 seconds → 0.15 seconds** (99.5% improvement).
    
- **Slight CPU increase is normal:** SQL Server used an **Index Seek + Hash Aggregate** instead of a Full Scan, but the trade-off is worth it.
    

---

✅ This case clearly demonstrates how **proper indexing** transforms query performance in SQL Server.

