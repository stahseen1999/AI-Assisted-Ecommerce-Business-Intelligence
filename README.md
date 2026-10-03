# AI-Assisted E-Commerce Business Intelligence & Decision Support

## Project Overview

This project uses **MySQL 8.0** to analyze the Olist Brazilian E-Commerce Public Dataset and derive business insights related to sales performance, customer behavior, seller performance, payment preferences, delivery operations and customer satisfaction.

The project follows an end-to-end SQL analytics workflow, from raw data auditing and cleaning to analytical data modelling and business analysis.

AI tools were used to assist with SQL development, debugging, query interpretation and documentation. The project focuses on SQL-based analytics and does not involve training or deploying a machine learning model.

## Business Objectives

The project aims to answer 12 business questions:

1. What is the overall distribution of order statuses?
2. How does order volume change month over month?
3. Which product categories generate the highest sales?
4. How do product sales trend over time?
5. What proportion of customers make repeat purchases?
6. What is the Average Order Value (AOV)?
7. Which sellers have the highest sales performance?
8. Which payment methods are most commonly used?
9. How well does the business perform in terms of delivery time?
10. What is the overall customer review score distribution?
11. Which product categories have the lowest average review scores?
12. Which categories have the highest freight-to-sales ratios?

## Dataset

* **Dataset:** Olist Brazilian E-Commerce Public Dataset
* **Source:** Kaggle
* **Database:** MySQL 8.0
* **Environment:** MySQL Workbench

The dataset contains information about customers, orders, order items, payments, products, sellers, reviews, geolocation and product category translations.

The raw data was imported into separate tables and processed through a structured SQL workflow.

## Tools & Technologies

* **MySQL 8.0** — Data cleaning, transformation, modelling and analysis
* **MySQL Workbench** — SQL development and query execution
* **SQL** — Data auditing, staging, relational modelling and business analysis
* **AI-assisted development** — Query assistance, debugging, interpretation and documentation

## Project Workflow

1. **Database Setup & Data Import**
   Created the database and imported the source CSV files into raw tables.

2. **Data Auditing**
   Assessed row counts, missing values, duplicates, data types, key uniqueness, date consistency and referential integrity.

3. **Data Cleaning & Staging**
   Standardized fields, handled blanks and invalid values, applied validation rules and created staging tables while preserving appropriate data grain.

4. **Analytical Data Modelling**
   Created dimension and fact tables to support structured analysis using relational keys and defined table grains.

5. **Business Analysis**
   Developed SQL queries to answer 12 business questions using joins, aggregations, CTEs, window functions, conditional logic and date functions.

6. **Documentation**
   Recorded the business objectives, SQL concepts, findings, interpretations, recommendations and limitations.

## Analytical Data Model

The analytical schema includes the following fact tables:

* `fact_orders` — One row per order
* `fact_order_items` — One row per order item
* `fact_payments` — One row per order/payment sequence
* `fact_reviews` — One row per review/order pair

The schema also includes customer, seller, product and date dimensions to support analysis across different business areas.

## Key Findings

* **Order fulfillment:** 96,478 orders were marked as delivered, representing approximately 97.02% of all orders.
* **Sales performance:** Health & Beauty was the highest-selling product category by product sales, at 125,861.34.
* **Customer behavior:** 2,997 of 96,096 unique customers made repeat purchases within the observed dataset period, approximately 3.12%.
* **Average Order Value:** The calculated AOV was 137.75, based on product item prices and the orders represented in the item table.
* **Payment preferences:** Credit cards accounted for approximately 78.34% of total payment value.
* **Delivery performance:** The analyzed delivered-order subset had an average delivery time of 12.50 days, with 6.77% delivered after the estimated date.
* **Customer satisfaction:** The average review score was 4.09 out of 5.
* **Freight analysis:** Christmas Supplies had the highest freight-to-sales ratio among the categories included in the analysis, at 36.69%.

These findings are descriptive and identify areas for further business investigation. Sales and freight metrics should not be interpreted as actual profit or margin.

## SQL Concepts Applied

* Data profiling and data quality checks
* `COUNT()`, `COUNT(DISTINCT)`, `SUM()`, `AVG()` and `ROUND()`
* `GROUP BY`, `HAVING` and `ORDER BY`
* `INNER JOIN` and `LEFT JOIN`
* Common Table Expressions (CTEs)
* Window functions, including `ROW_NUMBER()`
* `CASE` expressions and conditional aggregation
* Date functions and date-based analysis
* Data cleaning and standardization
* Fact and dimension tables
* Table grain, primary keys and foreign keys
* Referential integrity validation

## Repository Structure

```text
AI-Assisted-Ecommerce-Business-Intelligence/
│
├── dataset/
│
├── documentation/
│   └── business_findings.md
│
├── sql/
│   ├── 00_database_setup_and_import/
│   ├── 01_data_audit/
│   ├── 02_data_cleaning_staging/
│   ├── 03_data_modeling/
│   └── 04_business_analysis/
│
└── README.md
```

## How to Use

1. Download the Olist Brazilian E-Commerce Public Dataset from Kaggle.
2. Create the database in MySQL 8.0 using the database setup script.
3. Import the required CSV files into the raw tables, following the import instructions in the SQL scripts.
4. Run the SQL scripts in sequence, from database setup and auditing through staging and analytical modelling.
5. Execute the business analysis queries to review the results.

Review the comments in each SQL file for the purpose of the queries and the relevant business context.

## Project Limitations

* The dataset covers a finite observation period, and some boundary months are partial.
* Repeat purchase behavior reflects only the available observation period.
* Customer reviews represent submitted feedback and cannot always be attributed directly to individual products or categories.
* Sales metrics are based on product item prices and exclude freight unless explicitly stated.
* Freight-to-sales ratios are not equivalent to profit margins.
* The analysis is descriptive and does not establish causal relationships.

Further details are available in `documentation/business_findings.md`.

## Role of AI

AI assistance was used throughout the project to support SQL query development, debugging, concept explanations, result interpretation and documentation.

The dataset analysis, query execution and validation were performed as part of the SQL project workflow. This is an AI-assisted analytics project, not a trained predictive AI or machine learning model.

## Conclusion

This project demonstrates an end-to-end SQL analytics workflow, transforming raw e-commerce data into structured analytical tables and using SQL to investigate business performance and customer behavior.

It showcases practical skills in data quality assessment, data transformation, relational modelling, analytical querying and translating SQL results into business-oriented insights and recommendations.
