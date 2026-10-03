-- TABLE LEVEL AUDIT
-- Inspected the structure of all nine raw tables
SELECT table_name, column_name, column_type, is_nullable, column_key
FROM information_schema.columns
WHERE table_schema=DATABASE() AND table_name LIKE 'raw_%'
ORDER BY table_name, ordinal_position;

-- Retrieves estimated row counts for all raw tables from MySQL metadata to provide a quick overview of table sizes.
SELECT table_name, table_rows AS estimated_rows
FROM information_schema.tables
WHERE table_schema=DATABASE() AND table_name LIKE 'raw_%'
ORDER BY table_name;

-- Counts the exact number of records in each raw table.
SELECT 'raw_category_translation' AS table_name, COUNT(*) AS total_rows FROM raw_category_translation
UNION ALL
SELECT 'raw_customers', COUNT(*) FROM raw_customers
UNION ALL
SELECT 'raw_geolocation', COUNT(*) FROM raw_geolocation
UNION ALL
SELECT 'raw_order_items', COUNT(*) FROM raw_order_items
UNION ALL
SELECT 'raw_orders', COUNT(*) FROM raw_orders
UNION ALL
SELECT 'raw_payments', COUNT(*) FROM raw_payments
UNION ALL
SELECT 'raw_products', COUNT(*) FROM raw_products
UNION ALL
SELECT 'raw_reviews', COUNT(*) FROM raw_reviews
UNION ALL
SELECT 'raw_sellers', COUNT(*) FROM raw_sellers;

-- COLUMN LEVEL AUDIT
-- Checks raw_orders for missing or blank order IDs, customer IDs, purchase dates, and customer delivery dates.
SELECT
 SUM(order_id IS NULL OR TRIM(order_id)='') AS blank_order_id,
 SUM(customer_id IS NULL OR TRIM(customer_id)='') AS blank_customer_id,
 SUM(order_purchase_timestamp IS NULL) AS missing_purchase_date,
 SUM(order_delivered_customer_date IS NULL) AS missing_delivery_date
FROM raw_orders;

-- Checks order items for missing product/seller IDs and invalid negative or missing price and freight values.
SELECT
 SUM(product_id IS NULL OR TRIM(product_id)='') AS blank_product_id,
 SUM(seller_id IS NULL OR TRIM(seller_id)='') AS blank_seller_id,
 SUM(price IS NULL) AS missing_price,
 SUM(price<0) AS negative_price,
 SUM(freight_value<0) AS negative_freight
FROM raw_order_items;

-- Duplicate candidate checks (natural keys)
SELECT order_id,COUNT(*) n FROM raw_orders GROUP BY order_id HAVING COUNT(*)>1;
SELECT order_id,order_item_id,COUNT(*) n FROM raw_order_items GROUP BY order_id,order_item_id HAVING COUNT(*)>1;
SELECT order_id,payment_sequential,COUNT(*) n FROM raw_payments GROUP BY order_id,payment_sequential HAVING COUNT(*)>1;
SELECT review_id,COUNT(*) n FROM raw_reviews GROUP BY review_id HAVING COUNT(*)>1;
SELECT customer_id,COUNT(*) n FROM raw_customers GROUP BY customer_id HAVING COUNT(*)>1;
SELECT seller_id,COUNT(*) n FROM raw_sellers GROUP BY seller_id HAVING COUNT(*)>1;
SELECT product_id,COUNT(*) n FROM raw_products GROUP BY product_id HAVING COUNT(*)>1;

-- Inspects records with repeated review IDs to determine whether they are exact duplicates or associated with different orders.
SELECT
    r.review_id,
    r.order_id,
    r.review_score,
    r.review_creation_date,
    r.review_answer_timestamp
FROM raw_reviews r
JOIN (
    SELECT review_id
    FROM raw_reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
) d
    ON r.review_id = d.review_id
ORDER BY r.review_id, r.order_id
LIMIT 30;

-- Date ordering anomalies
SELECT COUNT(*) AS approved_before_purchase
FROM raw_orders
WHERE order_approved_at < order_purchase_timestamp;
SELECT COUNT(*) AS delivered_before_purchase
FROM raw_orders
WHERE order_delivered_customer_date < order_purchase_timestamp;
SELECT COUNT(*) AS delivery_after_estimate
FROM raw_orders
WHERE order_delivered_customer_date > order_estimated_delivery_date;
