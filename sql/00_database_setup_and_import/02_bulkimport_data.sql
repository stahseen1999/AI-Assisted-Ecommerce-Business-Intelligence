-- Bulk import orders dataset
LOAD DATA LOCAL INFILE
'C:/Users/Safiya/Downloads/Olist Dataset/olist_orders_dataset.csv'
INTO TABLE raw_orders
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @order_id,
    @customer_id,
    @order_status,
    @purchase_timestamp,
    @approved_at,
    @delivered_carrier_date,
    @delivered_customer_date,
    @estimated_delivery_date
)
SET
    order_id = NULLIF(TRIM(@order_id), ''),
    customer_id = NULLIF(TRIM(@customer_id), ''),
    order_status = NULLIF(TRIM(@order_status), ''),
    order_purchase_timestamp = STR_TO_DATE(NULLIF(TRIM(@purchase_timestamp), ''), '%Y-%m-%d %H:%i:%s'),
    order_approved_at = STR_TO_DATE(NULLIF(TRIM(@approved_at), ''), '%Y-%m-%d %H:%i:%s'),
    order_delivered_carrier_date = STR_TO_DATE(NULLIF(TRIM(@delivered_carrier_date), ''), '%Y-%m-%d %H:%i:%s'),
    order_delivered_customer_date = STR_TO_DATE(NULLIF(TRIM(@delivered_customer_date), ''), '%Y-%m-%d %H:%i:%s'),
    order_estimated_delivery_date = STR_TO_DATE(NULLIF(TRIM(@estimated_delivery_date), ''), '%Y-%m-%d %H:%i:%s');

-- Bulk import customers dataset
LOAD DATA LOCAL INFILE
'C:/Users/Safiya/Downloads/Olist Dataset/olist_customers_dataset.csv'
INTO TABLE raw_customers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @customer_id,
    @customer_unique_id,
    @zip_code,
    @city,
    @state
)
SET
    customer_id = NULLIF(TRIM(@customer_id), ''),
    customer_unique_id = NULLIF(TRIM(@customer_unique_id), ''),
    customer_zip_code_prefix = NULLIF(TRIM(@zip_code), ''),
    customer_city = NULLIF(TRIM(@city), ''),
    customer_state = NULLIF(TRIM(@state), '');
    
-- Bulk import order items dataset
LOAD DATA LOCAL INFILE
'C:/Users/Safiya/Downloads/Olist Dataset/olist_order_items_dataset.csv'
INTO TABLE raw_order_items
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @order_id,
    @order_item_id,
    @product_id,
    @seller_id,
    @shipping_limit_date,
    @price,
    @freight_value
)
SET
    order_id = NULLIF(TRIM(@order_id), ''),
    order_item_id = NULLIF(TRIM(@order_item_id), ''),
    product_id = NULLIF(TRIM(@product_id), ''),
    seller_id = NULLIF(TRIM(@seller_id), ''),
    shipping_limit_date = STR_TO_DATE(NULLIF(TRIM(@shipping_limit_date), ''), '%Y-%m-%d %H:%i:%s'),
    price = NULLIF(TRIM(@price), ''),
    freight_value = NULLIF(TRIM(@freight_value), '');
    
-- Bulk import payments dataset
LOAD DATA LOCAL INFILE
'C:/Users/Safiya/Downloads/Olist Dataset/olist_order_payments_dataset.csv'
INTO TABLE raw_payments
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @order_id,
    @payment_sequential,
    @payment_type,
    @payment_installments,
    @payment_value
)
SET
    order_id = NULLIF(TRIM(@order_id), ''),
    payment_sequential = NULLIF(TRIM(@payment_sequential), ''),
    payment_type = NULLIF(TRIM(@payment_type), ''),
    payment_installments = NULLIF(TRIM(@payment_installments), ''),
    payment_value = NULLIF(TRIM(@payment_value), '');

-- Bulk import reviews dataset
LOAD DATA LOCAL INFILE
'C:/Users/Safiya/Downloads/Olist Dataset/olist_order_reviews_dataset.csv'
INTO TABLE raw_reviews
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @review_id,
    @order_id,
    @review_score,
    @review_comment_title,
    @review_comment_message,
    @review_creation_date,
    @review_answer_timestamp
)
SET
    review_id = NULLIF(TRIM(@review_id), ''),
    order_id = NULLIF(TRIM(@order_id), ''),
    review_score = NULLIF(TRIM(@review_score), ''),
    review_comment_title = NULLIF(TRIM(@review_comment_title), ''),
    review_comment_message = NULLIF(TRIM(@review_comment_message), ''),
    review_creation_date = STR_TO_DATE(NULLIF(TRIM(@review_creation_date), ''), '%Y-%m-%d %H:%i:%s'),
    review_answer_timestamp = STR_TO_DATE(NULLIF(TRIM(@review_answer_timestamp), ''), '%Y-%m-%d %H:%i:%s');
    
-- Bulk import products dataset
LOAD DATA LOCAL INFILE
'C:/Users/Safiya/Downloads/Olist Dataset/olist_products_dataset.csv'
INTO TABLE raw_products
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @product_id,
    @category,
    @name_length,
    @description_length,
    @photos_qty,
    @weight,
    @length,
    @height,
    @width
)
SET
    product_id = NULLIF(TRIM(@product_id), ''),
    product_category_name = NULLIF(TRIM(@category), ''),
    product_name_lenght = NULLIF(TRIM(@name_length), ''),
    product_description_lenght = NULLIF(TRIM(@description_length), ''),
    product_photos_qty = NULLIF(TRIM(@photos_qty), ''),
    product_weight_g = NULLIF(TRIM(@weight), ''),
    product_length_cm = NULLIF(TRIM(@length), ''),
    product_height_cm = NULLIF(TRIM(@height), ''),
    product_width_cm = NULLIF(TRIM(@width), '');
    
-- Bulk import sellers dataset
LOAD DATA LOCAL INFILE
'C:/Users/Safiya/Downloads/Olist Dataset/olist_sellers_dataset.csv'
INTO TABLE raw_sellers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @seller_id,
    @zip_code,
    @city,
    @state
)
SET
    seller_id = NULLIF(TRIM(@seller_id), ''),
    seller_zip_code_prefix = NULLIF(TRIM(@zip_code), ''),
    seller_city = NULLIF(TRIM(@city), ''),
    seller_state = NULLIF(TRIM(@state), '');
    
-- Bulk import geolocation dataset
LOAD DATA LOCAL INFILE
'C:/Users/Safiya/Downloads/Olist Dataset/olist_geolocation_dataset.csv'
INTO TABLE raw_geolocation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @zip_code,
    @latitude,
    @longitude,
    @city,
    @state
)
SET
    geolocation_zip_code_prefix = NULLIF(TRIM(@zip_code), ''),
    geolocation_lat = NULLIF(TRIM(@latitude), ''),
    geolocation_lng = NULLIF(TRIM(@longitude), ''),
    geolocation_city = NULLIF(TRIM(@city), ''),
    geolocation_state = NULLIF(TRIM(@state), '');
    
-- category translation
LOAD DATA LOCAL INFILE
'C:/Users/Safiya/Downloads/Olist Dataset/product_category_name_translation.csv'
INTO TABLE raw_category_translation
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(
    @category,
    @english_category
)
SET
    product_category_name = NULLIF(TRIM(@category), ''),
    product_category_name_english = NULLIF(TRIM(@english_category), '');