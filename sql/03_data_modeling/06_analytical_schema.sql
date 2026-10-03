-- DIMENSION TABLES 
-- Compares customer records with distinct customer IDs and unique customers.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM stg_customers;

-- Identifies customers associated with multiple location combinations.
SELECT
    customer_unique_id,
    COUNT(*) AS customer_records,
    COUNT(DISTINCT CONCAT_WS(
        '|',
        customer_zip_code_prefix,
        customer_city,
        customer_state
    )) AS distinct_locations
FROM stg_customers
GROUP BY customer_unique_id
HAVING COUNT(DISTINCT CONCAT_WS(
    '|',
    customer_zip_code_prefix,
    customer_city,
    customer_state
)) > 1
ORDER BY distinct_locations DESC, customer_records DESC;

-- Creates the customer dimension with one row per source customer ID.
CREATE TABLE IF NOT EXISTS dim_customer (
    customer_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    customer_id CHAR(32) NOT NULL UNIQUE,
    customer_unique_id CHAR(32),
    zip_code_prefix CHAR(5),
    city VARCHAR(120),
    state CHAR(2)
);

-- Inserts cleaned customer records into the customer dimension.
INSERT INTO dim_customer (
    customer_id,
    customer_unique_id,
    zip_code_prefix,
    city,
    state
)
SELECT
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM stg_customers;

-- Validates customer dimension row count and source customer ID uniqueness.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS unique_customer_ids,
    COUNT(DISTINCT customer_unique_id) AS unique_customers
FROM dim_customer;

-- Creates the seller dimension with a surrogate primary key.
CREATE TABLE IF NOT EXISTS dim_seller (
    seller_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    seller_id CHAR(32) NOT NULL UNIQUE,
    zip_code_prefix CHAR(5),
    city VARCHAR(120),
    state CHAR(2)
);

-- Inserts cleaned seller records into the seller dimension.
INSERT INTO dim_seller (
    seller_id,
    zip_code_prefix,
    city,
    state
)
SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM stg_sellers;

-- Validates seller dimension row count and seller ID uniqueness.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT seller_id) AS unique_seller_ids
FROM dim_seller;

-- Creates the product dimension with a surrogate primary key.
CREATE TABLE IF NOT EXISTS dim_product (
    product_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    product_id CHAR(32) NOT NULL UNIQUE,
    product_category_name VARCHAR(120),
    product_category_english VARCHAR(120),
    product_name_length INT,
    product_description_length INT,
    product_photos_qty INT,
    product_weight_g INT,
    product_length_cm INT,
    product_height_cm INT,
    product_width_cm INT
);

-- Inserts cleaned product records and their English category translations.
INSERT INTO dim_product (
    product_id,
    product_category_name,
    product_category_english,
    product_name_length,
    product_description_length,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm
)
SELECT
    p.product_id,
    p.product_category_name,
    c.product_category_name_english,
    p.product_name_lenght,
    p.product_description_lenght,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm
FROM stg_products AS p
LEFT JOIN stg_categories AS c
    ON p.product_category_name = c.product_category_name;
    
-- Validates product dimension row count and product ID uniqueness.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT product_id) AS unique_product_ids,
    COUNT(product_category_english) AS translated_categories
FROM dim_product;

-- Checks whether missing English translations are due to missing source categories or unmatched translations.
SELECT
    CASE
        WHEN product_category_name IS NULL THEN 'Missing source category'
        WHEN product_category_english IS NULL THEN 'Translation unavailable'
    END AS category_status,
    COUNT(*) AS product_count
FROM dim_product
WHERE product_category_english IS NULL
GROUP BY category_status;

-- Creates a date dimension for calendar-based business analysis.
CREATE TABLE IF NOT EXISTS dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    year INT,
    quarter INT,
    month INT,
    month_name VARCHAR(15),
    day INT,
    day_name VARCHAR(15),
    week_of_year INT,
    day_of_week INT,
    is_weekend BOOLEAN
);

-- Populates a continuous calendar using the order purchase date range.
INSERT INTO dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_name,
    week_of_year,
    day_of_week,
    is_weekend
)
WITH RECURSIVE date_series AS (
    SELECT DATE(MIN(order_purchase_timestamp)) AS calendar_date
    FROM stg_orders

    UNION ALL

    SELECT calendar_date + INTERVAL 1 DAY
    FROM date_series
    WHERE calendar_date < (
        SELECT DATE(MAX(order_purchase_timestamp))
        FROM stg_orders
    )
)
SELECT
    DATE_FORMAT(calendar_date, '%Y%m%d') + 0,
    calendar_date,
    YEAR(calendar_date),
    QUARTER(calendar_date),
    MONTH(calendar_date),
    MONTHNAME(calendar_date),
    DAY(calendar_date),
    DAYNAME(calendar_date),
    WEEK(calendar_date, 3),
    WEEKDAY(calendar_date) + 1,
    CASE
        WHEN WEEKDAY(calendar_date) IN (5, 6) THEN TRUE
        ELSE FALSE
    END
FROM date_series;

-- Validates date dimension row count, uniqueness, date range, and calendar continuity.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT full_date) AS unique_dates,
    MIN(full_date) AS first_date,
    MAX(full_date) AS last_date,
    DATEDIFF(MAX(full_date), MIN(full_date)) + 1 AS expected_days
FROM dim_date;

-- FACT TABLES
-- Creates the order fact table with one row per order.
CREATE TABLE IF NOT EXISTS fact_orders (
    order_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id CHAR(32) NOT NULL UNIQUE,
    customer_key BIGINT NOT NULL,
    purchase_date_key INT NOT NULL,
    approved_date_key INT,
    carrier_date_key INT,
    delivered_date_key INT,
    estimated_delivery_date_key INT,
    order_status VARCHAR(30),
    order_purchase_timestamp DATETIME,
    order_approved_at DATETIME,
    order_delivered_carrier_date DATETIME,
    order_delivered_customer_date DATETIME,
    order_estimated_delivery_date DATETIME,
    CONSTRAINT fk_fact_orders_customer
        FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    CONSTRAINT fk_fact_orders_purchase_date
        FOREIGN KEY (purchase_date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_fact_orders_approved_date
        FOREIGN KEY (approved_date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_fact_orders_carrier_date
        FOREIGN KEY (carrier_date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_fact_orders_delivered_date
        FOREIGN KEY (delivered_date_key) REFERENCES dim_date(date_key),
    CONSTRAINT fk_fact_orders_estimated_date
        FOREIGN KEY (estimated_delivery_date_key) REFERENCES dim_date(date_key)
);

-- Checks whether all order-related dates have matching records in dim_date.
SELECT
    'Purchase Date' AS date_type,
    COUNT(*) AS total_records,
    SUM(d.date_key IS NULL) AS unmatched_dates
FROM stg_orders AS o
LEFT JOIN dim_date AS d
    ON d.full_date = DATE(o.order_purchase_timestamp)

UNION ALL

SELECT
    'Approval Date',
    COUNT(o.order_approved_at),
    SUM(o.order_approved_at IS NOT NULL AND d.date_key IS NULL)
FROM stg_orders AS o
LEFT JOIN dim_date AS d
    ON d.full_date = DATE(o.order_approved_at)

UNION ALL

SELECT
    'Carrier Date',
    COUNT(o.order_delivered_carrier_date),
    SUM(o.order_delivered_carrier_date IS NOT NULL AND d.date_key IS NULL)
FROM stg_orders AS o
LEFT JOIN dim_date AS d
    ON d.full_date = DATE(o.order_delivered_carrier_date)

UNION ALL

SELECT
    'Customer Delivery Date',
    COUNT(o.order_delivered_customer_date),
    SUM(o.order_delivered_customer_date IS NOT NULL AND d.date_key IS NULL)
FROM stg_orders AS o
LEFT JOIN dim_date AS d
    ON d.full_date = DATE(o.order_delivered_customer_date)

UNION ALL

SELECT
    'Estimated Delivery Date',
    COUNT(o.order_estimated_delivery_date),
    SUM(o.order_estimated_delivery_date IS NOT NULL AND d.date_key IS NULL)
FROM stg_orders AS o
LEFT JOIN dim_date AS d
    ON d.full_date = DATE(o.order_estimated_delivery_date);
    
-- Extends the date dimension to cover all order-related dates.
INSERT INTO dim_date (
    date_key,
    full_date,
    year,
    quarter,
    month,
    month_name,
    day,
    day_name,
    week_of_year,
    day_of_week,
    is_weekend
)
WITH RECURSIVE all_order_dates AS (
    SELECT DATE(order_purchase_timestamp) AS event_date
    FROM stg_orders
    WHERE order_purchase_timestamp IS NOT NULL

    UNION ALL
    SELECT DATE(order_approved_at)
    FROM stg_orders
    WHERE order_approved_at IS NOT NULL

    UNION ALL
    SELECT DATE(order_delivered_carrier_date)
    FROM stg_orders
    WHERE order_delivered_carrier_date IS NOT NULL

    UNION ALL
    SELECT DATE(order_delivered_customer_date)
    FROM stg_orders
    WHERE order_delivered_customer_date IS NOT NULL

    UNION ALL
    SELECT DATE(order_estimated_delivery_date)
    FROM stg_orders
    WHERE order_estimated_delivery_date IS NOT NULL
),
date_bounds AS (
    SELECT
        MIN(event_date) AS min_date,
        MAX(event_date) AS max_date
    FROM all_order_dates
),
date_series AS (
    SELECT min_date AS calendar_date
    FROM date_bounds

    UNION ALL

    SELECT calendar_date + INTERVAL 1 DAY
    FROM date_series
    CROSS JOIN date_bounds
    WHERE calendar_date < max_date
)
SELECT
    DATE_FORMAT(s.calendar_date, '%Y%m%d') + 0,
    s.calendar_date,
    YEAR(s.calendar_date),
    QUARTER(s.calendar_date),
    MONTH(s.calendar_date),
    MONTHNAME(s.calendar_date),
    DAY(s.calendar_date),
    DAYNAME(s.calendar_date),
    WEEK(s.calendar_date, 3),
    WEEKDAY(s.calendar_date) + 1,
    CASE WHEN WEEKDAY(s.calendar_date) IN (5, 6)
         THEN TRUE ELSE FALSE END
FROM date_series AS s
WHERE NOT EXISTS (
    SELECT 1
    FROM dim_date AS d
    WHERE d.full_date = s.calendar_date
);

-- Inserts one record per order with customer and date dimension keys.
INSERT INTO fact_orders (
    order_id,
    customer_key,
    purchase_date_key,
    approved_date_key,
    carrier_date_key,
    delivered_date_key,
    estimated_delivery_date_key,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date,
    order_delivered_customer_date,
    order_estimated_delivery_date
)
SELECT
    o.order_id,
    c.customer_key,
    dp.date_key,
    da.date_key,
    dc.date_key,
    dd.date_key,
    de.date_key,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date
FROM stg_orders AS o
JOIN dim_customer AS c
    ON o.customer_id = c.customer_id
JOIN dim_date AS dp
    ON DATE(o.order_purchase_timestamp) = dp.full_date
LEFT JOIN dim_date AS da
    ON DATE(o.order_approved_at) = da.full_date
LEFT JOIN dim_date AS dc
    ON DATE(o.order_delivered_carrier_date) = dc.full_date
LEFT JOIN dim_date AS dd
    ON DATE(o.order_delivered_customer_date) = dd.full_date
LEFT JOIN dim_date AS de
    ON DATE(o.order_estimated_delivery_date) = de.full_date;
    
-- Validates fact order count, order uniqueness, and required dimension keys.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id) AS unique_orders,
    SUM(customer_key IS NULL) AS missing_customer_keys,
    SUM(purchase_date_key IS NULL) AS missing_purchase_date_keys
FROM fact_orders;

-- Creates the order-item fact table at one row per order item.
CREATE TABLE IF NOT EXISTS fact_order_items (
    order_item_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_key BIGINT NOT NULL,
    order_id CHAR(32) NOT NULL,
    order_item_id INT NOT NULL,
    product_key BIGINT NOT NULL,
    seller_key BIGINT NOT NULL,
    shipping_limit_date DATETIME,
    price DECIMAL(10,2) NOT NULL,
    freight_value DECIMAL(10,2) NOT NULL,

    CONSTRAINT uq_fact_order_item
        UNIQUE (order_id, order_item_id),

    CONSTRAINT fk_order_items_order
        FOREIGN KEY (order_key) REFERENCES fact_orders(order_key),

    CONSTRAINT fk_order_items_product
        FOREIGN KEY (product_key) REFERENCES dim_product(product_key),

    CONSTRAINT fk_order_items_seller
        FOREIGN KEY (seller_key) REFERENCES dim_seller(seller_key)
);

-- Inserts order items with their corresponding order, product, and seller keys.
INSERT INTO fact_order_items (
    order_key,
    order_id,
    order_item_id,
    product_key,
    seller_key,
    shipping_limit_date,
    price,
    freight_value
)
SELECT
    fo.order_key,
    oi.order_id,
    oi.order_item_id,
    p.product_key,
    s.seller_key,
    oi.shipping_limit_date,
    oi.price,
    oi.freight_value
FROM stg_order_items AS oi
JOIN fact_orders AS fo
    ON oi.order_id = fo.order_id
JOIN dim_product AS p
    ON oi.product_id = p.product_id
JOIN dim_seller AS s
    ON oi.seller_id = s.seller_id;
    
-- Validates order-item row count, composite key uniqueness, and dimension keys.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id, order_item_id) AS unique_order_items,
    SUM(order_key IS NULL) AS missing_order_keys,
    SUM(product_key IS NULL) AS missing_product_keys,
    SUM(seller_key IS NULL) AS missing_seller_keys
FROM fact_order_items;

-- Creates the payment fact table at one row per order payment.
CREATE TABLE IF NOT EXISTS fact_payments (
    payment_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_key BIGINT NOT NULL,
    order_id CHAR(32) NOT NULL,
    payment_sequential INT NOT NULL,
    payment_type VARCHAR(30),
    payment_installments INT,
    payment_value DECIMAL(10,2) NOT NULL,

    CONSTRAINT uq_fact_payment
        UNIQUE (order_id, payment_sequential),

    CONSTRAINT fk_fact_payments_order
        FOREIGN KEY (order_key) REFERENCES fact_orders(order_key)
);

-- Inserts payment records with their corresponding order keys.
INSERT INTO fact_payments (
    order_key,
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value
)
SELECT
    fo.order_key,
    p.order_id,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value
FROM stg_payments AS p
JOIN fact_orders AS fo
    ON p.order_id = fo.order_id;
    
-- Validates payment row count, uniqueness, and order key mapping.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT order_id, payment_sequential) AS unique_payments,
    SUM(order_key IS NULL) AS missing_order_keys
FROM fact_payments;

-- Creates the review fact table with one row per review and order combination.
CREATE TABLE IF NOT EXISTS fact_reviews (
    review_key BIGINT AUTO_INCREMENT PRIMARY KEY,
    review_id CHAR(32) NOT NULL,
    order_id CHAR(32) NOT NULL,
    order_key BIGINT NOT NULL,
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date DATETIME,
    review_answer_timestamp DATETIME,

    CONSTRAINT uq_fact_review
        UNIQUE (review_id, order_id),

    CONSTRAINT fk_fact_reviews_order
        FOREIGN KEY (order_key) REFERENCES fact_orders(order_key)
);

-- Inserts customer reviews with their corresponding order keys.
INSERT INTO fact_reviews (
    review_id,
    order_id,
    order_key,
    review_score,
    review_comment_title,
    review_comment_message,
    review_creation_date,
    review_answer_timestamp
)
SELECT
    r.review_id,
    r.order_id,
    fo.order_key,
    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date,
    r.review_answer_timestamp
FROM stg_reviews AS r
JOIN fact_orders AS fo
    ON r.order_id = fo.order_id;
    
-- Validates review row count, composite key uniqueness, and order key mapping.
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT review_id, order_id) AS unique_reviews,
    SUM(order_key IS NULL) AS missing_order_keys,
    SUM(review_score IS NULL) AS missing_review_scores
FROM fact_reviews;

-- Compares staging and fact table row counts after analytical modelling.
SELECT 'Orders' AS table_name,
       (SELECT COUNT(*) FROM stg_orders) AS staging_rows,
       (SELECT COUNT(*) FROM fact_orders) AS fact_rows
UNION ALL
SELECT 'Order Items',
       (SELECT COUNT(*) FROM stg_order_items),
       (SELECT COUNT(*) FROM fact_order_items)
UNION ALL
SELECT 'Payments',
       (SELECT COUNT(*) FROM stg_payments),
       (SELECT COUNT(*) FROM fact_payments)
UNION ALL
SELECT 'Reviews',
       (SELECT COUNT(*) FROM stg_reviews),
       (SELECT COUNT(*) FROM fact_reviews);