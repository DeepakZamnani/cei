
SELECT * FROM customers;

SELECT first_name, last_name, city
FROM customers;



SELECT DISTINCT category
FROM products;



SELECT table_name, column_name, constraint_name
FROM information_schema.key_column_usage
WHERE constraint_name = 'PRIMARY'
  AND table_schema = DATABASE();  



INSERT INTO products VALUES (209, 'Defective Product', 'Electronics', 'TestBrand', -50.00, 100);
