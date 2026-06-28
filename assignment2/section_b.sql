
SELECT *
FROM orders
WHERE status = 'Delivered';



SELECT *
FROM products
WHERE category = 'Electronics'
  AND unit_price > 2000;


SELECT *
FROM customers
WHERE join_date BETWEEN '2024-01-01' AND '2024-12-31'
  AND state = 'Maharashtra';



SELECT *
FROM orders
WHERE order_date BETWEEN '2024-08-10' AND '2024-08-25'
  AND status <> 'Cancelled';



SELECT order_id, customer_id, order_date, status, total_amount
FROM orders
WHERE order_date BETWEEN '2024-08-01' AND '2024-08-31'
ORDER BY order_date;



SELECT *
FROM customers
WHERE join_date >= '2024-01-01'
AND join_date <  '2025-01-01';
