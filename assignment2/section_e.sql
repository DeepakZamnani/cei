-- ============================================================
-- SECTION E: Advanced Concepts (CASE, ACID, Transactions)
-- ============================================================

-- ------------------------------------------------------------
-- Q24. Classify products into price tiers using CASE.
-- ------------------------------------------------------------
SELECT product_name,
       unit_price,
       CASE
           WHEN unit_price < 1000              THEN 'Budget'
           WHEN unit_price BETWEEN 1000 AND 3000 THEN 'Mid-Range'
           ELSE                                     'Premium'
       END AS price_tier
FROM products
ORDER BY unit_price;


-- ------------------------------------------------------------
-- Q25. Count Delivered vs Not Delivered orders in a single row using CASE.
-- ------------------------------------------------------------
SELECT
    SUM(CASE WHEN status = 'Delivered' THEN 1 ELSE 0 END) AS delivered_count,
    SUM(CASE WHEN status <> 'Delivered' THEN 1 ELSE 0 END) AS not_delivered_count
FROM orders;

/*
  How it works:
    For each row, the CASE expression returns 1 (match) or 0 (no match).
    SUM() then totals those 1s, giving the count per category —
    all in one pass over the table without a GROUP BY or subquery.
*/


-- ------------------------------------------------------------
-- Q26. ACID Properties — explained with a real-world bank transfer example.
-- ------------------------------------------------------------
/*
  ACID guarantees that database transactions are processed reliably.

  ─────────────────────────────────────────────────────────────────
  A — ATOMICITY
  ─────────────────────────────────────────────────────────────────
  Definition:
    A transaction is treated as a single indivisible unit. Either ALL
    operations within it succeed, or NONE of them are applied.

  Bank transfer example:
    Step 1: Deduct ₹5000 from Account A.
    Step 2: Add    ₹5000 to   Account B.

    If the system crashes after Step 1 but before Step 2, without
    atomicity ₹5000 vanishes from the database entirely.
    With atomicity, the incomplete transaction is rolled back and
    Account A is restored — money is never lost.

  ─────────────────────────────────────────────────────────────────
  C — CONSISTENCY
  ─────────────────────────────────────────────────────────────────
  Definition:
    A transaction brings the database from one VALID state to another,
    never violating defined rules (constraints, foreign keys, triggers).

  Bank transfer example:
    A business rule states: "no account balance can go below ₹0."
    If Account A has ₹3000 and someone attempts to transfer ₹5000,
    consistency prevents the transaction from completing — the rule
    would be broken. The database stays in a valid state.

  ─────────────────────────────────────────────────────────────────
  I — ISOLATION
  ─────────────────────────────────────────────────────────────────
  Definition:
    Concurrent transactions execute as if they were running serially.
    Intermediate states of a transaction are invisible to other
    transactions until it commits.

  Bank transfer example:
    While the ₹5000 transfer is in progress (A debited, B not yet
    credited), another transaction checks both balances. Without
    isolation it would see an inconsistent snapshot — money missing
    from both accounts. With isolation, the second transaction either
    sees the state before the transfer or after, never the in-between.

  ─────────────────────────────────────────────────────────────────
  D — DURABILITY
  ─────────────────────────────────────────────────────────────────
  Definition:
    Once a transaction is committed, its changes are permanently
    recorded — even if the server crashes or loses power immediately
    afterward. This is typically achieved through write-ahead logging
    (WAL) or redo logs.

  Bank transfer example:
    After the transfer commits and the customer receives a confirmation,
    the server crashes. When it restarts, the ₹5000 transfer is still
    reflected correctly because the committed changes were written to
    durable storage before the crash.
*/


-- ------------------------------------------------------------
-- Q27. Complete transaction: insert order 1011, two items, update stock.
-- ------------------------------------------------------------

-- PostgreSQL / standard SQL syntax:
BEGIN;

    -- Step 1: Insert the new order
    INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
    VALUES (1011, 102, CURRENT_DATE, 'Pending', 1598.00);

    -- Step 2: Insert two order items for order 1011
    INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
    VALUES (5016, 1011, 206, 1, 1299.00, 0);   -- Bedsheet Set

    INSERT INTO order_items (item_id, order_id, product_id, quantity, unit_price, discount_pct)
    VALUES (5017, 1011, 208, 1, 599.00,  0);   -- Cushion Covers (Set)

    -- Step 3: Reduce stock for the purchased products
    UPDATE products
    SET stock_qty = stock_qty - 1
    WHERE product_id = 206;

    UPDATE products
    SET stock_qty = stock_qty - 1
    WHERE product_id = 208;

COMMIT;

/*
  If ANY of the above steps fails (constraint violation, server error, etc.),
  issue ROLLBACK instead of COMMIT to undo all changes atomically:

      ROLLBACK;

  ── MySQL equivalent (using stored procedure for error handling) ──────────

  DELIMITER $$
  CREATE PROCEDURE place_order_1011()
  BEGIN
      DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
          ROLLBACK;
          RESIGNAL;
      END;

      START TRANSACTION;

          INSERT INTO orders VALUES (1011, 102, CURDATE(), 'Pending', 1598.00);

          INSERT INTO order_items VALUES (5016, 1011, 206, 1, 1299.00, 0);
          INSERT INTO order_items VALUES (5017, 1011, 208, 1,  599.00, 0);

          UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 206;
          UPDATE products SET stock_qty = stock_qty - 1 WHERE product_id = 208;

      COMMIT;
  END$$
  DELIMITER ;

  CALL place_order_1011();

  ─────────────────────────────────────────────────────────────────
  Why wrap this in a transaction?
    Without a transaction, a crash between the INSERT and the UPDATE
    would leave an order recorded but stock never decremented —
    an inconsistent state. The transaction (ACID — Atomicity) ensures
    either all five statements succeed together or none take effect.
*/
