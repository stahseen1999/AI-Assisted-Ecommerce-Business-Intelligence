-- Refrential Integrity Check
-- Counts order-item records that do not have a matching order in raw_orders.
SELECT COUNT(*) AS orphan_items
FROM raw_order_items i
LEFT JOIN raw_orders o
    ON i.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Counts orders that do not have a matching customer record.
SELECT COUNT(*) AS orphan_order_customers
FROM raw_orders o
LEFT JOIN raw_customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Counts order items that do not have a matching product record.
SELECT COUNT(*) AS orphan_item_products
FROM raw_order_items i
LEFT JOIN raw_products p
    ON i.product_id = p.product_id
WHERE p.product_id IS NULL;

-- Counts order items that do not have a matching seller record.
SELECT COUNT(*) AS orphan_item_sellers
FROM raw_order_items i
LEFT JOIN raw_sellers s
    ON i.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- Counts payment records that do not have a matching order.
SELECT COUNT(*) AS orphan_payments
FROM raw_payments p
LEFT JOIN raw_orders o
    ON p.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Counts review records that do not have a matching order.
SELECT COUNT(*) AS orphan_reviews
FROM raw_reviews r
LEFT JOIN raw_orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- Summarizes the number of orders for each order status.
SELECT
    order_status,
    COUNT(*) AS order_count
FROM raw_orders
GROUP BY order_status
ORDER BY order_count DESC;

-- Summarizes payment record counts and total payment value by payment type.
SELECT
    payment_type,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_value), 2) AS value_total
FROM raw_payments
GROUP BY payment_type
ORDER BY payment_count DESC;

-- Counts review records with scores outside the valid 1-to-5 range.
SELECT COUNT(*) AS invalid_review_scores
FROM raw_reviews
WHERE review_score NOT BETWEEN 1 AND 5;

-- Counts payment records with negative installment values.
SELECT COUNT(*) AS invalid_installments
FROM raw_payments
WHERE payment_installments < 0;

-- Counts payment records with negative payment values.
SELECT COUNT(*) AS invalid_payment_values
FROM raw_payments
WHERE payment_value < 0;

-- Counts products with negative physical dimension values.
SELECT COUNT(*) AS invalid_product_dimensions
FROM raw_products
WHERE product_weight_g < 0
   OR product_length_cm < 0
   OR product_height_cm < 0
   OR product_width_cm < 0;
   
-- Counts geolocation records with coordinates outside valid latitude and longitude ranges.
SELECT COUNT(*) AS invalid_lat_lng
FROM raw_geolocation
WHERE geolocation_lat NOT BETWEEN -90 AND 90
   OR geolocation_lng NOT BETWEEN -180 AND 180;
   
-- Summarizes customer counts by state to review geographic distribution.
SELECT
    customer_state,
    COUNT(*) AS customer_count
FROM raw_customers
GROUP BY customer_state
ORDER BY customer_count DESC;

-- Identifies payment type values that differ only by capitalization or surrounding spaces.
SELECT
    LOWER(TRIM(payment_type)) AS normalized_payment_type,
    COUNT(DISTINCT payment_type) AS raw_variants
FROM raw_payments
GROUP BY LOWER(TRIM(payment_type))
HAVING COUNT(DISTINCT payment_type) > 1;