
SELECT COUNT(*) AS total_orders
FROM orders;



SELECT SUM(total_amount) AS total_delivered_revenue
FROM orders
WHERE status = 'Delivered';



SELECT category,
       ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM products
GROUP BY category
ORDER BY avg_unit_price DESC;



SELECT status,
       COUNT(*)           AS order_count,
       SUM(total_amount)  AS total_revenue
FROM orders
GROUP BY status
ORDER BY total_revenue DESC;



SELECT category,
       MAX(unit_price) AS most_expensive,
       MIN(unit_price) AS cheapest
FROM products
GROUP BY category
ORDER BY category;


SELECT category,
       ROUND(AVG(unit_price), 2) AS avg_unit_price
FROM products
GROUP BY category
HAVING AVG(unit_price) > 2000
ORDER BY avg_unit_price DESC;
