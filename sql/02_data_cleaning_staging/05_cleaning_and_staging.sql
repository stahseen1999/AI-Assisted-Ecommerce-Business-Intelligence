-- Removes the existing staging table, if present, before recreating it.
DROP TABLE IF EXISTS stg_orders;

-- Creates a standardized orders staging table and retains one record per order ID.
CREATE TABLE stg_orders AS
SELECT
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
FROM (
    SELECT
        TRIM(order_id) AS order_id,
        TRIM(customer_id) AS customer_id,
        LOWER(TRIM(order_status)) AS order_status,
        order_purchase_timestamp,
        order_approved_at,
        order_delivered_carrier_date,
        order_delivered_customer_date,
        order_estimated_delivery_date,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(order_id)
            ORDER BY order_purchase_timestamp DESC
        ) AS rn
    FROM raw_orders
    WHERE order_id IS NOT NULL
      AND TRIM(order_id) <> ''
) x
WHERE rn = 1;

-- Validates the total records and unique order IDs in the orders staging table.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_order_ids
FROM stg_orders;

-- Removes the existing customers staging table, if present, before recreating it.
DROP TABLE IF EXISTS stg_customers;

-- Creates a standardized customers staging table with cleaned IDs, ZIP codes and location text.
CREATE TABLE stg_customers AS
SELECT
    customer_id,
    customer_unique_id,
    LPAD(TRIM(customer_zip_code_prefix), 5, '0') AS customer_zip_code_prefix,
    UPPER(TRIM(customer_city)) AS customer_city,
    UPPER(TRIM(customer_state)) AS customer_state
FROM (
    SELECT
        TRIM(customer_id) AS customer_id,
        TRIM(customer_unique_id) AS customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(customer_id)
            ORDER BY customer_id
        ) AS rn
    FROM raw_customers
    WHERE customer_id IS NOT NULL
      AND TRIM(customer_id) <> ''
) x
WHERE rn = 1;

-- Validates the total records and unique customer IDs in the customers staging table.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids
FROM stg_customers;

-- Removes the existing sellers staging table, if present, before recreating it.
DROP TABLE IF EXISTS stg_sellers;

-- Creates a standardized sellers staging table with cleaned IDs, ZIP codes and location text.
CREATE TABLE stg_sellers AS
SELECT
    seller_id,
    LPAD(TRIM(seller_zip_code_prefix), 5, '0') AS seller_zip_code_prefix,
    UPPER(TRIM(seller_city)) AS seller_city,
    UPPER(TRIM(seller_state)) AS seller_state
FROM (
    SELECT
        TRIM(seller_id) AS seller_id,
        seller_zip_code_prefix,
        seller_city,
        seller_state,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(seller_id)
            ORDER BY seller_id
        ) AS rn
    FROM raw_sellers
    WHERE seller_id IS NOT NULL
      AND TRIM(seller_id) <> ''
) x
WHERE rn = 1;

-- Validates total records and unique seller IDs in the sellers staging table.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_seller_ids
FROM stg_sellers;

-- Removes the existing products staging table, if present, before recreating it.
DROP TABLE IF EXISTS stg_products;

-- Creates a standardized products staging table and retains one record per product ID.
CREATE TABLE stg_products AS
SELECT
    product_id,
    NULLIF(TRIM(product_category_name), '') AS product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
FROM (
    SELECT
        TRIM(product_id) AS product_id,
        product_category_name,
        product_name_lenght,
        product_description_lenght,
        product_photos_qty,
        product_weight_g,
        product_length_cm,
        product_height_cm,
        product_width_cm,
        ROW_NUMBER() OVER (
            PARTITION BY TRIM(product_id)
            ORDER BY product_id
        ) AS rn
    FROM raw_products
    WHERE product_id IS NOT NULL
      AND TRIM(product_id) <> ''
) x
WHERE rn = 1;

-- Checks total records and unique product IDs in the products staging table.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids
FROM stg_products;

-- Removes the existing order items staging table, if present.
DROP TABLE IF EXISTS stg_order_items;

-- Creates a cleaned staging table for order items without modifying raw data.
CREATE TABLE stg_order_items AS
SELECT
    TRIM(order_id) AS order_id,
    order_item_id,
    TRIM(product_id) AS product_id,
    TRIM(seller_id) AS seller_id,
    shipping_limit_date,
    price,
    freight_value
FROM raw_order_items
WHERE order_id IS NOT NULL
  AND product_id IS NOT NULL
  AND seller_id IS NOT NULL
  AND order_item_id > 0
  AND price >= 0
  AND freight_value >= 0;
  
-- Checks total records and unique order-item combinations.
SELECT
    COUNT(*) AS total_rows,
    (
        SELECT COUNT(*)
        FROM (
            SELECT order_id, order_item_id
            FROM stg_order_items
            GROUP BY order_id, order_item_id
        ) AS unique_items
    ) AS unique_order_item_pairs
FROM stg_order_items;

-- Removes the existing payments staging table, if present.
DROP TABLE IF EXISTS stg_payments;

-- Creates a standardized staging table for payment records.
CREATE TABLE stg_payments AS
SELECT
    TRIM(order_id) AS order_id,
    payment_sequential,
    CASE
        WHEN LOWER(TRIM(payment_type)) IN (
            'credit_card',
            'debit_card',
            'boleto',
            'voucher',
            'not_defined'
        )
        THEN LOWER(TRIM(payment_type))
        ELSE 'other'
    END AS payment_type,
    payment_installments,
    payment_value
FROM raw_payments
WHERE order_id IS NOT NULL
  AND payment_sequential > 0
  AND payment_installments >= 0
  AND payment_value >= 0;
  
-- Checks total payment records and unique order-payment combinations.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT CONCAT(order_id, '-', payment_sequential)) AS unique_payment_pairs
FROM stg_payments;

-- Identifies review IDs associated with multiple records or orders.
SELECT
    review_id,
    COUNT(*) AS record_count,
    COUNT(DISTINCT order_id) AS distinct_orders
FROM raw_reviews
WHERE review_id IS NOT NULL
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

-- Finds repeated review IDs associated with the same order.
SELECT
    review_id,
    order_id,
    COUNT(*) AS record_count
FROM raw_reviews
WHERE review_id IS NOT NULL
  AND order_id IS NOT NULL
GROUP BY review_id, order_id
HAVING COUNT(*) > 1
ORDER BY record_count DESC;

-- Removes the existing reviews staging table, if present.
DROP TABLE IF EXISTS stg_reviews;

-- Creates a standardized reviews staging table while preserving valid records.
CREATE TABLE stg_reviews AS
SELECT
    TRIM(review_id) AS review_id,
    TRIM(order_id) AS order_id,
    review_score,
    NULLIF(TRIM(review_comment_title), '') AS review_comment_title,
    NULLIF(TRIM(review_comment_message), '') AS review_comment_message,
    review_creation_date,
    review_answer_timestamp
FROM raw_reviews
WHERE review_id IS NOT NULL
  AND TRIM(review_id) <> ''
  AND order_id IS NOT NULL
  AND TRIM(order_id) <> ''
  AND review_score BETWEEN 1 AND 5;
  
-- Checks total review records and unique review-order combinations.
SELECT
    COUNT(*) AS total_rows,
    (
        SELECT COUNT(*)
        FROM (
            SELECT review_id, order_id
            FROM stg_reviews
            GROUP BY review_id, order_id
        ) AS unique_reviews
    ) AS unique_review_order_pairs
FROM stg_reviews;

-- Removes the existing categories staging table, if present.
DROP TABLE IF EXISTS stg_categories;

-- Creates a standardized staging table for product categories.
CREATE TABLE stg_categories AS
SELECT
    NULLIF(TRIM(product_category_name), '') AS product_category_name,
    NULLIF(TRIM(product_category_name_english), '') AS product_category_name_english
FROM raw_category_translation;

-- Checks total category records and unique Portuguese category names.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_category_name) AS unique_categories
FROM stg_categories;

-- Removes the existing geolocation staging table, if present.
DROP TABLE IF EXISTS stg_geolocation;

-- Creates standardized geolocation data while preserving valid coordinates.
CREATE TABLE stg_geolocation AS
SELECT
    LPAD(TRIM(geolocation_zip_code_prefix), 5, '0') AS zip_code_prefix,
    geolocation_lat,
    geolocation_lng,
    UPPER(TRIM(geolocation_city)) AS city,
    UPPER(TRIM(geolocation_state)) AS state
FROM raw_geolocation
WHERE geolocation_lat BETWEEN -90 AND 90
  AND geolocation_lng BETWEEN -180 AND 180;
  
-- Checks total geolocation records and unique ZIP-code prefixes.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT zip_code_prefix) AS unique_zip_prefixes
FROM stg_geolocation;