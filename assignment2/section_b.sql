-- ============================================================
-- SECTION B: Filtering & Optimization (WHERE, Indexes)
-- ============================================================

-- ------------------------------------------------------------
-- Q7. Retrieve all orders with status = 'Delivered'.
-- ------------------------------------------------------------
SELECT *
FROM orders
WHERE status = 'Delivered';


-- ------------------------------------------------------------
-- Q8. Find all products in 'Electronics' with unit_price > 2000.
-- ------------------------------------------------------------
SELECT *
FROM products
WHERE category = 'Electronics'
  AND unit_price > 2000;


-- ------------------------------------------------------------
-- Q9. List customers who joined in 2024 and belong to 'Maharashtra'.
-- ------------------------------------------------------------
SELECT *
FROM customers
WHERE join_date BETWEEN '2024-01-01' AND '2024-12-31'
  AND state = 'Maharashtra';


-- ------------------------------------------------------------
-- Q10. Orders placed between 2024-08-10 and 2024-08-25 that are NOT Cancelled.
-- ------------------------------------------------------------
SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
  AND status <> 'Cancelled';


-- ------------------------------------------------------------
-- Q11. What does idx_orders_date do and how does it help?
-- ------------------------------------------------------------
/*
  idx_orders_date is a B-tree index on orders(order_date).

  Without the index:
    The database performs a full table scan — it reads every row in orders
    to check whether order_date matches the filter. Cost = O(n).

  With the index:
    The database uses the B-tree to jump directly to the matching date range.
    Cost = O(log n) for the seek + a small sequential read for the range.
    This is especially valuable when the orders table grows to millions of rows.

  Queries that benefit from idx_orders_date:
    - Equality filter:  WHERE order_date = '2024-08-15'
    - Range filter:     WHERE order_date BETWEEN '2024-08-01' AND '2024-08-31'
    - ORDER BY:         ORDER BY order_date (avoids a sort step)
    - MIN/MAX:          SELECT MIN(order_date) / MAX(order_date)

  The index does NOT help when a function is applied to the column
  (e.g. YEAR(order_date)), because the index stores raw date values.
*/

-- Sample query that directly benefits from idx_orders_date:
SELECT order_id, customer_id, order_date, status, total_amount
FROM orders
WHERE order_date BETWEEN '2024-08-01' AND '2024-08-31'
ORDER BY order_date;


-- ------------------------------------------------------------
-- Q12. YEAR(join_date) = 2024 — is the index used? Rewrite to be SARGable.
-- ------------------------------------------------------------
/*
  Original query (NOT index-friendly):
      SELECT * FROM customers WHERE YEAR(join_date) = 2024;

  WHY THE INDEX IS NOT USED:
    YEAR() is a scalar function applied to the indexed column join_date.
    The database cannot use the index because the index stores raw DATE
    values, not pre-computed YEAR() results. To evaluate the condition,
    the engine must call YEAR() on every row — effectively a full table
    scan even if an index exists on join_date.
    This is called a non-SARGable predicate (Search ARGument Not-able).

  SARGable rewrite — compare the column directly against a range:
*/

-- Non-SARGable (avoids index):
-- SELECT * FROM customers WHERE YEAR(join_date) = 2024;

-- SARGable (uses idx_customers_state / any index on join_date):
SELECT *
FROM customers
WHERE join_date >= '2024-01-01'
  AND join_date <  '2025-01-01';
/*
  Now the predicate compares the raw column value against literal dates.
  The query optimizer can seek directly into the B-tree index and read
  only the rows whose join_date falls within 2024 — no function call,
  no full scan.
*/
