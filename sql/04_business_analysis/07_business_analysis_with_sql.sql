-- ==================================================
-- BUSINESS ANALYSIS
-- Project: AI-Assisted E-Commerce Business Intelligence
-- Database: Olist
-- ==================================================

-- Business Question: What is the overall order status distribution?
-- Purpose: Understand order fulfillment and identify orders not marked as delivered.
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_orders
FROM fact_orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- Business Question: How does order volume change month over month?
-- Purpose: Identify monthly order trends and periods of higher or lower activity.
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(*) AS total_orders
FROM fact_orders AS fo
JOIN dim_date AS d
    ON fo.purchase_date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;
    
-- Business Question: Which product categories generate the highest sales value?
-- Purpose: Identify the categories contributing the most to product sales.
SELECT
    COALESCE(
        p.product_category_english,
        p.product_category_name,
        'Uncategorized'
    ) AS product_category,
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT foi.order_id) AS total_orders,
    ROUND(SUM(foi.price), 2) AS product_sales_value
FROM fact_order_items AS foi
JOIN dim_product AS p
    ON foi.product_key = p.product_key
GROUP BY
    COALESCE(
        p.product_category_english,
        p.product_category_name,
        'Uncategorized'
    )
ORDER BY product_sales_value DESC
LIMIT 10;

-- Business Question: How does sales value change over time?
-- Purpose: Identify monthly sales trends and periods of higher or lower sales.
SELECT
    d.year,
    d.month,
    d.month_name,
    COUNT(DISTINCT foi.order_id) AS total_orders,
    ROUND(SUM(foi.price), 2) AS product_sales_value
FROM fact_order_items AS foi
JOIN fact_orders AS fo
    ON foi.order_key = fo.order_key
JOIN dim_date AS d
    ON fo.purchase_date_key = d.date_key
GROUP BY
    d.year,
    d.month,
    d.month_name
ORDER BY
    d.year,
    d.month;
    
-- Business Question: How many customers are repeat customers, and how frequently do they order?
-- Purpose: Understand one-time versus repeat purchasing behavior.
WITH customer_order_frequency AS (
    SELECT
        dc.customer_unique_id,
        COUNT(fo.order_id) AS total_orders
    FROM fact_orders AS fo
    JOIN dim_customer AS dc
        ON fo.customer_key = dc.customer_key
    GROUP BY dc.customer_unique_id
)
SELECT
    CASE
        WHEN total_orders = 1 THEN 'One-time customer'
        WHEN total_orders = 2 THEN '2 orders'
        WHEN total_orders = 3 THEN '3 orders'
        ELSE '4+ orders'
    END AS customer_type,
    COUNT(*) AS total_customers,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage
FROM customer_order_frequency
GROUP BY customer_type
ORDER BY
    CASE customer_type
        WHEN 'One-time customer' THEN 1
        WHEN '2 orders' THEN 2
        WHEN '3 orders' THEN 3
        ELSE 4
    END;
    
-- Business Question: What is the average order value?
-- Purpose: Calculate the average product sales value per order.
SELECT
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(price), 2) AS total_product_sales,
    ROUND(
        SUM(price) / COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM fact_order_items;

-- Business Question: Which sellers contribute the most to product sales?
-- Purpose: Identify sellers with the highest product sales value and order volume.
SELECT
    s.seller_id,
    s.city,
    s.state,
    COUNT(*) AS total_order_items,
    COUNT(DISTINCT foi.order_id) AS total_orders,
    ROUND(SUM(foi.price), 2) AS product_sales_value
FROM fact_order_items AS foi
JOIN dim_seller AS s
    ON foi.seller_key = s.seller_key
GROUP BY
    s.seller_id,
    s.city,
    s.state
ORDER BY product_sales_value DESC
LIMIT 10;

-- Business Question: Which payment methods are most commonly used?
-- Purpose: Understand payment method usage and their contribution to total payment value.
SELECT
    payment_type,
    COUNT(*) AS total_payments,
    ROUND(SUM(payment_value), 2) AS total_payment_value,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS payment_count_percentage,
    ROUND(
        SUM(payment_value) * 100.0 / SUM(SUM(payment_value)) OVER (),
        2
    ) AS payment_value_percentage
FROM fact_payments
GROUP BY payment_type
ORDER BY total_payments DESC;

-- Business Question: How long does delivery take, and how often are orders late?
-- Purpose: Measure delivery duration and evaluate performance against estimated dates.
SELECT 
    COUNT(*) AS delivered_orders,
    ROUND(AVG(DATEDIFF(dd.full_date, pd.full_date)),
            2) AS avg_delivery_days,
    SUM(CASE
        WHEN dd.full_date > ed.full_date THEN 1
        ELSE 0
    END) AS late_deliveries,
    ROUND(SUM(CASE
                WHEN dd.full_date > ed.full_date THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
            2) AS late_delivery_percentage
FROM
    fact_orders AS fo
        JOIN
    dim_date AS pd ON fo.purchase_date_key = pd.date_key
        JOIN
    dim_date AS dd ON fo.delivered_date_key = dd.date_key
        JOIN
    dim_date AS ed ON fo.estimated_delivery_date_key = ed.date_key
WHERE
    fo.order_status = 'delivered';
    
-- Business Question: How satisfied are customers with their purchases?
-- Purpose: Analyze review score distribution and overall average customer rating.
SELECT
    review_score,
    COUNT(*) AS total_reviews,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS review_percentage,
    (
        SELECT ROUND(AVG(review_score), 2)
        FROM fact_reviews
    ) AS average_review_score
FROM fact_reviews
GROUP BY review_score
ORDER BY review_score DESC;

-- Business Question: Which product categories receive the lowest customer ratings?
-- Purpose: Identify categories associated with lower average review scores.
-- Only categories with at least 50 distinct reviews are included.
WITH review_category AS (
    SELECT DISTINCT
        fr.review_id,
        fr.order_id,
        COALESCE(
            p.product_category_english,
            p.product_category_name,
            'Uncategorized'
        ) AS product_category,
        fr.review_score
    FROM fact_reviews AS fr
    JOIN fact_order_items AS foi
        ON fr.order_id = foi.order_id
    JOIN dim_product AS p
        ON foi.product_key = p.product_key
)
SELECT
    product_category,
    COUNT(*) AS total_reviews,
    ROUND(AVG(review_score), 2) AS average_review_score
FROM review_category
GROUP BY product_category
HAVING COUNT(*) >= 50
ORDER BY average_review_score ASC, total_reviews DESC
LIMIT 10;

-- Business Question: How do freight charges affect order costs?
-- Purpose: Compare freight charges with product sales value across categories.
SELECT
    COALESCE(
        p.product_category_english,
        p.product_category_name,
        'Uncategorized'
    ) AS product_category,
    COUNT(DISTINCT foi.order_id) AS total_orders,
    ROUND(SUM(foi.price), 2) AS product_sales_value,
    ROUND(SUM(foi.freight_value), 2) AS total_freight,
    ROUND(
        SUM(foi.freight_value) * 100.0
        / NULLIF(SUM(foi.price), 0),
        2
    ) AS freight_percentage
FROM fact_order_items AS foi
JOIN dim_product AS p
    ON foi.product_key = p.product_key
GROUP BY
    COALESCE(
        p.product_category_english,
        p.product_category_name,
        'Uncategorized'
    )
HAVING COUNT(DISTINCT foi.order_id) >= 50
ORDER BY freight_percentage DESC
LIMIT 10;

