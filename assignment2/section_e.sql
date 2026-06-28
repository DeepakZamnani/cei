
SELECT product_name,
       unit_price,
       CASE
           WHEN unit_price < 1000              THEN 'Budget'
           WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
           ELSE                                     'Premium'
       END AS price_tier
FROM products
ORDER BY unit_price;



SELECT
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
    SUM(CASE WHEN status <> 'Delivered' THEN 1 ELSE 0 END) AS not_delivered_count
FROM orders;




BEGIN;

    INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
    VALUES (1011, 102, CURRENT_DATE, 'Pending', 1598.00);

   
    INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
    VALUES (5016, 1011, 206, 1, 1299.00, 0);   

    INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
    VALUES (5017, 1011, 208, 1, 599.00,  0);   

    UPDATE products
    SET stock_qty = stock_qty - 1
    WHERE product_id = 206;

    UPDATE products
    SET stock_qty = stock_qty - 1
    WHERE product_id = 208;

COMMIT;

