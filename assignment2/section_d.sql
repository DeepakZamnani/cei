
SELECT o.order_id,
       o.order_date,
       c.first_name,
       c.last_name,
       o.total_amount
FROM orders o
INNER JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;



SELECT c.customer_id,
       c.first_name,
       c.last_name,
       o.order_id,
       o.order_date,
       o.status,
       o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id;



SELECT o.order_id,
       p.product_name,
       oi.quantity,
       oi.unit_price,
       oi.discount_pct
FROM orders o
INNER JOIN order_items oi ON o.order_id   = oi.order_id
INNER JOIN products    p  ON oi.product_id = p.product_id
ORDER BY o.order_id, p.product_name;


SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;


SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;


SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id

UNION

SELECT c.customer_id, c.first_name, o.order_id
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;


INSERT INTO orders VALUES (1099, 999, '2024-09-01', 'Pending', 500.00);
