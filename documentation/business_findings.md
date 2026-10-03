# Business Findings & Insights

## Project: AI-Assisted E-Commerce Business Intelligence & Decision Support

### 1. Project Overview

**Project Objective**

The objective of this project is to analyze e-commerce data using SQL to identify business trends, evaluate operational performance, understand customer behavior and generate data-driven insights that can support business decision-making.

The project follows an end-to-end SQL analytics workflow, starting from raw data auditing and cleaning to analytical data modelling and business analysis.

**Dataset**

* **Dataset:** Olist Brazilian E-Commerce Public Dataset
* **Source:** Kaggle
* **Database:** MySQL 8.0
* **SQL Environment:** MySQL Workbench

The dataset contains information about e-commerce orders, customers, products, sellers, payments, reviews, delivery and geolocation.

**Project Scope**

The project covers the following stages:

1. **Data Auditing:** Examine the raw dataset for missing values, duplicate records, inconsistencies, anomalies and referential integrity issues.
2. **Data Cleaning & Staging:** Standardize data, handle identified quality issues and prepare structured staging tables for analysis.
3. **Analytical Data Modelling:** Design a relational analytical schema consisting of fact and dimension tables, using a star schema approach.
4. **Business Analysis:** Develop SQL queries to answer business questions related to sales, customers, products, sellers, payments, delivery performance and customer satisfaction.
5. **Business Insights & Recommendations:** Interpret analytical results to identify trends, highlight potential business challenges and propose data-driven recommendations.

**Tools & Technologies**

* MySQL 8.0
* MySQL Workbench
* SQL
* AI-assisted SQL development, debugging, query interpretation and documentation

**Role of AI**

AI was used as an assistant throughout the project to support SQL query development, troubleshoot errors, explain SQL concepts, interpret query results and prepare technical and business documentation.

The analysis, validation of query outputs and interpretation of findings were performed as part of the project workflow. AI assisted with the process but was not used to train a machine learning model.

**Expected Outcome**

The project aims to demonstrate practical SQL skills, data quality assessment, analytical data modelling, business problem-solving and the ability to translate raw e-commerce data into meaningful business insights.


## SQL Concepts & Techniques Used

This project applies SQL across the complete data analytics workflow, from raw data auditing and cleaning to analytical data modelling and business analysis.

### 1. Data Auditing & Data Quality Checks

**Objective:** Assess the quality, consistency, completeness and reliability of the raw dataset before using it for analysis.

**SQL concepts and techniques:**

* `COUNT()` and `COUNT(DISTINCT)` – Validate record counts and uniqueness of key columns.
* `GROUP BY` – Identify duplicate values and analyze data distributions.
* `HAVING` – Filter grouped results to identify duplicate records.
* `COUNT(CASE WHEN...)` – Identify missing, invalid or condition-based records.
* `MIN()`, `MAX()` and `AVG()` – Check value ranges and detect potential anomalies.
* `LEFT JOIN` – Identify orphan records and validate referential integrity.
* Date comparisons – Identify inconsistent or unexpected date sequences.
* Data profiling – Examine table structure, grain, data types, missing values and potential relationships.

### 2. Data Cleaning & Staging

**Objective:** Standardize raw data, address identified quality issues and prepare consistent staging tables for analytical modelling.

**SQL concepts and techniques:**

* `TRIM()` – Remove leading and trailing whitespace from text and identifiers.
* `UPPER()` / `LOWER()` – Standardize text casing where applicable.
* `NULLIF()` – Convert empty values into `NULL` where appropriate.
* `LPAD()` – Standardize ZIP code formatting.
* `CASE` – Apply conditional transformations and validation logic.
* `ROW_NUMBER()` – Assign sequence numbers to records for deduplication.
* `PARTITION BY` – Group records for row-level ranking and duplicate handling.
* `ORDER BY` within window functions – Define which record is prioritized during deduplication.
* Common Table Expressions (CTEs) – Organize multi-step data transformation logic.
* Data validation – Compare staging table record counts and verify key constraints against raw data.

### 3. Analytical Data Modelling

**Objective:** Organize cleaned data into a structured analytical schema that supports reliable business queries.

**Concepts and techniques:**

* Fact tables – Store measurable business events such as orders, order items, payments and reviews.
* Dimension tables – Store descriptive attributes such as customer, seller, product and date details.
* Grain – Define what one row represents in each fact and dimension table.
* Primary keys (PK) – Uniquely identify records within a table.
* Foreign keys (FK) – Establish relationships between fact and dimension tables.
* Surrogate keys – Use generated identifiers to link analytical records.
* Star schema – Structure fact and dimension tables for analytical querying.
* `JOIN` operations – Combine fact and dimension data for analysis.
* Referential integrity validation – Check that relationships between tables are consistent.

### 4. Business Analysis

**Objective:** Use SQL to answer business questions, measure performance and identify trends across orders, customers, products, sellers, payments, delivery and reviews.

**SQL concepts and techniques:**

* `SELECT` and `WHERE` – Retrieve and filter relevant records.
* `INNER JOIN` and `LEFT JOIN` – Combine related tables based on analytical requirements.
* `GROUP BY` – Aggregate data by business dimensions such as month, category and payment type.
* Aggregate functions – Use `COUNT()`, `SUM()`, `AVG()`, `MIN()` and `MAX()` to calculate business metrics.
* `COUNT(DISTINCT)` – Measure unique entities such as customers and orders.
* `CASE` – Create conditional classifications and categories.
* `HAVING` – Filter aggregated results based on business conditions.
* Date functions – Extract and group data by year, month and other date attributes.
* CTEs – Break complex analytical queries into manageable steps.
* `ROUND()` – Format calculated metrics to a suitable decimal precision.
* Percentage calculations – Measure proportions, rates and contribution to totals.
* Conditional aggregation – Calculate metrics for specific conditions within grouped results.
* `ORDER BY` – Rank and sort results to identify top or bottom performers.

These concepts were applied to investigate order fulfilment, sales trends, customer retention, average order value, seller performance, payment preferences, delivery performance, customer satisfaction and freight costs.

*Note: The specific techniques used vary by query. The individual business analysis sections identify the concepts relevant to each question.*

## Business Analysis & Findings

### Q1. What is the overall distribution of order statuses?

**Business Objective**

Analyze the distribution of order statuses to understand order fulfilment performance and identify orders that were not successfully delivered.

**SQL Concepts Used**

* `GROUP BY` – Group orders by their status.
* `COUNT()` – Calculate the number of orders in each status.
* `ORDER BY` – Sort the results by order count.
* Percentage calculation – Measure each status's contribution to total orders.
* Aggregate functions – Summarize order distribution.

**Key Findings**

| Order Status | Order Count | Percentage |
| ------------ | ----------: | ---------: |
| Delivered    |      96,478 |     97.02% |
| Shipped      |       1,107 |      1.11% |
| Canceled     |         625 |      0.63% |
| Unavailable  |         609 |      0.61% |
| Invoiced     |         314 |      0.32% |
| Processing   |         301 |      0.30% |
| Created      |           5 |      0.01% |
| Approved     |           2 |      0.00% |
| **Total**    |  **99,441** |   **100%** |

**Business Interpretation**

* Approximately 97.02% of all orders were delivered, indicating a high order fulfilment completion rate in the dataset.
* Canceled and unavailable orders together account for 1.24% of all orders.
* The remaining orders are distributed across different stages of the order lifecycle.

**Business Recommendations**

* Investigate canceled and unavailable orders to identify possible inventory, payment or fulfilment issues.
* Monitor order statuses regularly to identify potential bottlenecks in the order lifecycle.
* Further analyze unsuccessful orders by seller, product category and time period to identify recurring patterns.

**Business Takeaway**

The dataset shows a high proportion of delivered orders. However, investigating the reasons behind canceled and unavailable orders may help identify opportunities to improve order fulfilment.

### Q2. How does order volume change over time?

**Business Objective**

Analyze monthly order volume to identify ordering trends, seasonal patterns and periods of higher or lower customer activity.

**SQL Concepts Used**

* `COUNT()` – Calculate the number of orders.
* `GROUP BY` – Aggregate orders by year and month.
* Date functions – Extract year and month from order dates.
* `ORDER BY` – Arrange results chronologically.
* Aggregate analysis – Compare order volumes across different months.

**Key Findings**

| Month    | Order Count |
| -------- | ----------: |
| Jan 2017 |         800 |
| Feb 2017 |       1,780 |
| Mar 2017 |       2,682 |
| Apr 2017 |       2,404 |
| May 2017 |       3,700 |
| Jun 2017 |       3,245 |
| Jul 2017 |       4,026 |
| Aug 2017 |       4,331 |
| Sep 2017 |       4,285 |
| Oct 2017 |       4,631 |
| Nov 2017 |       7,544 |
| Dec 2017 |       5,673 |
| Jan 2018 |       6,729 |
| Feb 2018 |       6,728 |
| Mar 2018 |       7,211 |
| Apr 2018 |       6,939 |
| May 2018 |       6,873 |
| Jun 2018 |       6,177 |
| Jul 2018 |       6,292 |
| Aug 2018 |       6,512 |

**Business Interpretation**

* Monthly order volume generally increased through much of 2017, with a notable peak in November 2017 at 7,544 orders.
* Order volume remained relatively high during the first eight months of 2018, with March recording 7,211 orders.
* November 2017 had the highest monthly order volume among the listed full months.
* The dataset contains partial boundary months, including 2016 and September 2018, so these should not be directly compared with complete months.

**Business Recommendations**

* Investigate the reasons for the significant increase in order volume in November 2017, including possible seasonal or promotional effects.
* Use historical monthly order patterns to support inventory, staffing and fulfilment planning.
* Continue monitoring monthly order volume to identify changes in customer demand.

**Business Takeaway**

Order volume increased substantially during 2017 and remained relatively high in 2018. November 2017 was the busiest full month in the analyzed period, making it a useful period for further investigation of demand patterns.

### Q3. Which product categories generate the highest sales?

**Business Objective**

Identify the product categories generating the highest sales revenue to understand product demand and determine which categories contribute most to overall product sales.

**SQL Concepts Used**

* `JOIN` – Combine order item data with product and category information.
* `GROUP BY` – Aggregate sales by product category.
* `SUM()` – Calculate total product sales for each category.
* `ORDER BY` – Rank categories based on sales.
* `LIMIT` – Retrieve the highest-performing categories.

**Key Findings**

* **Health Beauty** recorded the highest product sales of **125,861.34**.
* **Watches Gifts** ranked second, with product sales of **120,505.68**.

**Business Interpretation**

Health Beauty and Watches Gifts were the two highest-selling categories by product sales value in the analysis. This indicates that these categories made substantial contributions to the product sales recorded in the dataset.

Product sales are calculated using item prices and exclude freight charges. These figures represent sales value, not profit.

**Business Recommendations**

* Monitor demand and sales trends in high-performing categories to support inventory planning.
* Investigate the factors contributing to the strong sales performance of Health Beauty and Watches Gifts.
* Evaluate category-level costs and margins separately before making profitability-related decisions.
* Review lower-performing categories to identify potential opportunities for improvement.

**Business Takeaway**

Health Beauty led product sales, followed by Watches Gifts. These categories may warrant closer attention in sales and inventory planning, while profitability should be assessed using additional cost and margin data.

### Q4. How do product sales change over time?

**Business Objective**

Analyze monthly product sales trends to identify periods of high and low sales activity, understand changes in sales performance and identify potential seasonal patterns.

**SQL Concepts Used**

* `JOIN` – Combine order item data with order dates.
* `SUM()` – Calculate total product sales for each month.
* `GROUP BY` – Aggregate product sales by year and month.
* Date functions – Extract year and month from order dates.
* `ORDER BY` – Arrange monthly sales results chronologically.
* `ROUND()` – Format sales values to two decimal places.

**Key Findings**

| Month         | Product Sales |
| ------------- | ------------: |
| November 2017 |    101,027.37 |
| April 2018    |     99,667.75 |
| May 2018      |     99,617.68 |
| March 2018    |     98,213.44 |
| January 2018  |     95,000.36 |

* November 2017 recorded the highest monthly product sales at **101,027.37**.
* April and May 2018 also recorded high product sales, each close to 100,000.
* Several months in early 2018 showed consistently strong sales performance.

**Business Interpretation**

Product sales were particularly high in November 2017 and remained strong during several months in 2018. This suggests periods of increased sales activity, although further analysis is needed to establish whether these patterns are seasonal or driven by specific promotions or other factors.

This analysis uses product sales from order items and is distinct from monthly order volume, which counts orders rather than measuring their sales value.

**Business Recommendations**

* Investigate the factors behind the high sales recorded in November 2017.
* Compare sales trends across product categories to identify which categories contribute most during high-sales periods.
* Use historical sales patterns to support inventory and operational planning.
* Analyze promotional and seasonal effects if additional campaign data becomes available.

**Business Takeaway**

November 2017 recorded the highest monthly product sales in the analysis, while several months in 2018 also performed strongly. Monitoring monthly sales trends can support demand planning and help identify periods that warrant further investigation.

### Q5. How many customers are repeat customers?

**Business Objective**

Analyze customer purchasing frequency to understand customer retention, identify repeat purchasing behavior and evaluate how many customers have placed more than one order.

**SQL Concepts Used**

* `COUNT()` – Count customer records and orders.
* `COUNT(DISTINCT)` – Identify unique customers using `customer_unique_id`.
* `GROUP BY` – Group customers based on their number of orders.
* CTEs – Organize the customer order-count calculation into logical steps.
* `CASE` – Classify customers into order-frequency groups.
* Percentage calculation – Calculate the proportion of customers in each group.
* `ORDER BY` – Arrange customer frequency groups for reporting.

**Key Findings**

| Customer Order Frequency | Number of Customers | Percentage |
| ------------------------ | ------------------: | ---------: |
| 1 order                  |              93,099 |     96.88% |
| 2 orders                 |               2,745 |      2.86% |
| 3 orders                 |                 203 |      0.21% |
| 4 or more orders         |                  49 |      0.05% |
| **Total**                |          **96,096** |   **100%** |

* Total unique customers: **96,096**
* Repeat customers (more than one order): **2,997**
* Repeat customer rate: **3.12%**
* One-time customers: **93,099**, accounting for **96.88%** of unique customers.

**Business Interpretation**

The analysis shows that most unique customers placed only one order during the observed dataset period. Approximately 3.12% of unique customers placed more than one order.

This indicates a relatively low observed repeat-purchase rate. However, the dataset covers a limited period, so customers who made only one purchase may have returned outside the available observation window.

**Business Recommendations**

* Investigate potential reasons for low repeat purchasing, such as customer experience, product availability and delivery performance.
* Explore customer retention initiatives, such as targeted offers or personalized recommendations, where appropriate.
* Analyze repeat purchasing by product category and customer location to identify segments with stronger retention.
* Track repeat purchasing over time to assess whether retention initiatives are associated with improvements.

**Business Takeaway**

Most customers in the dataset placed a single order, while 3.12% placed multiple orders. Customer retention is a potential area for further investigation, while recognizing that the observed rate is limited to the available dataset period.

### Q6. What is the Average Order Value (AOV)?

**Business Objective**

Calculate the average product sales value per order to understand customer spending patterns and establish a baseline for evaluating order value.

**SQL Concepts Used**

* `SUM()` – Calculate the total product sales value.
* `COUNT(DISTINCT)` – Count unique orders represented in the order items data.
* `JOIN` – Combine relevant order and order item information, where required.
* Aggregate functions – Summarize sales and order metrics.
* Division – Calculate average order value.
* `ROUND()` – Format the AOV to two decimal places.

**Key Findings**

| Metric                            |         Value |
| --------------------------------- | ------------: |
| Orders represented in order items |        98,666 |
| Total product sales               | 13,591,643.70 |
| Average Order Value (AOV)         |        137.75 |

**Business Interpretation**

The average product sales value per order was **137.75** across the 98,666 orders represented in the order items data.

This metric provides an indication of the average value of products purchased per order. It does not include freight charges or other potential charges, taxes or adjustments.

Orders without corresponding order item records are excluded from this calculation.

**Business Recommendations**

* Monitor AOV over time to identify changes in average customer spending.
* Analyze AOV by product category, customer segment and location to understand differences in purchasing behavior.
* Explore product bundling, cross-selling and upselling opportunities to potentially increase the average value of orders.
* Evaluate any initiatives using both AOV and profitability metrics, rather than AOV alone.

**Business Takeaway**

The observed AOV was **137.75** based on product sales. Tracking this metric across customer segments and periods can help identify opportunities to increase order value, while considering associated costs and margins.

### Q7. Who are the top-performing sellers by product sales?

**Business Objective**

Evaluate seller performance based on product sales, number of orders and items sold to identify high-performing sellers and understand their contribution to e-commerce sales.

**SQL Concepts Used**

* `JOIN` – Combine order item data with seller information.
* `GROUP BY` – Aggregate performance metrics for each seller.
* `SUM()` – Calculate total product sales for each seller.
* `COUNT()` – Calculate the number of items sold.
* `COUNT(DISTINCT)` – Calculate the number of unique orders per seller.
* `ORDER BY` – Sort sellers by product sales.
* `LIMIT` – Retrieve the top 10 sellers.

**Key Findings**

The following sellers appeared in the top 10 by product sales:

| Seller Location      | Items Sold | Orders | Product Sales |
| -------------------- | ---------: | -----: | ------------: |
| Guariba, SP          |      1,156 |  1,132 |     22,947.63 |
| Lauro de Freitas, BA |        410 |    358 |     22,276.05 |
| Ibitinga, SP         |      1,987 |  1,806 |     20,047.92 |
| Sumare, SP           |        586 |    585 |     19,402.03 |
| Itaququecetuba, SP   |      1,364 |    982 |     17,923.89 |
| Barueri, SP          |        340 |    336 |     17,643.87 |
| Piracicaba, SP       |      1,551 |  1,314 |     16,036.57 |
| São Paulo, SP        |      1,171 |  1,160 |     14,745.53 |
| São Paulo, SP        |      1,428 |    915 |     13,896.55 |
| São Paulo, SP        |      1,499 |  1,287 |     13,517.70 |

**Business Interpretation**

* The top-ranked seller recorded product sales of **22,947.63**, followed closely by the second-ranked seller at **22,276.05**.
* Sellers show differences in the number of items sold and the number of orders, indicating that order volume and item volume do not necessarily align.
* Several of the top 10 sellers are located in São Paulo state (SP), although seller location alone does not establish the reason for their sales performance.

**Business Recommendations**

* Analyze high-performing sellers to understand their product mix, order volumes and sales patterns.
* Investigate differences between items sold and orders received to better understand seller purchasing patterns.
* Evaluate seller performance alongside delivery reliability, customer reviews and product availability.
* Explore opportunities to support sellers with lower sales through further analysis of their product categories and order trends.

**Business Takeaway**

The top 10 sellers demonstrate varying levels of product sales, order volume and item volume. Combining these metrics with operational and customer experience indicators can provide a more complete view of seller performance.

**Note:** Product sales represent item prices and do not account for seller costs, commissions or other expenses. Therefore, sales value should not be interpreted as seller profit.

### Q8. Which payment methods are most commonly used by customers?

**Business Objective**

Analyze customer payment preferences to identify the most frequently used payment methods and understand their contribution to total payment value.

**SQL Concepts Used**

* `GROUP BY` – Group payment records by payment type.
* `COUNT()` – Calculate the number of payment records for each method.
* `SUM()` – Calculate the total payment value for each method.
* `ROUND()` – Format payment values and percentages.
* `CASE` – Apply conditional logic where required.
* Percentage calculation – Calculate each payment method's share of total payment records and payment value.
* `ORDER BY` – Sort payment methods based on usage or payment value.

**Key Findings**

| Payment Method | Payment Records |    Payment Value | Record Share | Value Share |
| -------------- | --------------: | ---------------: | -----------: | ----------: |
| Credit Card    |          76,795 |     1,254,208.19 |       73.92% |      78.34% |
| Boleto         |          19,784 |       289,631.27 |       19.04% |      17.92% |
| Voucher        |           5,775 |        37,943.67 |        5.56% |       2.37% |
| Debit Card     |           1,529 |        21,798.79 |        1.47% |       1.36% |
| Not Defined    |               3 |             0.00 |        0.00% |       0.00% |
| **Total**      |     **103,886** | **1,603,581.92** |     **100%** |    **100%** |

**Business Interpretation**

* Credit cards were the dominant payment method, accounting for 73.92% of payment records and 78.34% of total payment value.
* Boleto was the second most frequently recorded method, representing 19.04% of payment records and 17.92% of payment value.
* Vouchers accounted for 5.56% of payment records but contributed only 2.37% of the total payment value.
* Debit cards represented a relatively small share of both payment records and total payment value.

**Business Recommendations**

* Maintain reliable support for credit card payments, given their dominant share of payment activity.
* Monitor boleto usage to understand its role in customer payment preferences.
* Analyze voucher usage further to assess whether voucher-based purchases are associated with specific promotions or customer segments.
* Continue monitoring payment method distribution to identify changes in customer preferences.

**Business Takeaway**

Credit cards were the leading payment method by both record count and payment value, followed by boleto. Understanding payment preferences can help businesses prioritize payment support and evaluate opportunities to improve the customer checkout experience.

**Note:** The analysis is based on payment records, not distinct orders. An order can have multiple payment records. Payment value is not equivalent to net revenue or profit.

### Q9. How well is the business performing in terms of delivery time and delays?

**Business Objective**

Evaluate delivery performance by analyzing the average delivery time and the proportion of orders delivered later than the estimated delivery date.

**SQL Concepts Used**

* `JOIN` – Connect order facts with the date dimension to retrieve relevant dates.
* `INNER JOIN` – Include orders with matching purchase, delivered and estimated delivery dates.
* `WHERE` – Filter for delivered orders.
* `AVG()` – Calculate the average delivery duration.
* `DATEDIFF()` – Calculate the number of days taken to deliver an order.
* `CASE` – Classify deliveries as on time or late.
* Conditional aggregation – Count late deliveries based on a specified condition.
* Percentage calculation – Calculate the late delivery rate.
* `ROUND()` – Format calculated metrics.

**Key Findings**

| Metric                    |      Value |
| ------------------------- | ---------: |
| Delivered orders analyzed |     96,470 |
| Average delivery time     | 12.50 days |
| Late deliveries           |      6,534 |
| Late delivery rate        |      6.77% |

**Business Interpretation**

* The average delivery time for the analyzed delivered orders was **12.50 days**.
* A total of **6,534 orders**, representing **6.77%** of the analyzed deliveries, arrived later than their estimated delivery dates.
* Although most analyzed orders were not classified as late, delivery delays may affect customer satisfaction and the overall shopping experience.

**Business Recommendations**

* Investigate the causes of late deliveries, including seller dispatch delays, transportation issues and geographical challenges.
* Analyze delivery performance by seller, customer location and time period to identify recurring delay patterns.
* Monitor estimated versus actual delivery times to identify opportunities for improving delivery planning.
* Review delivery performance alongside customer review scores to explore potential relationships between delays and customer satisfaction.

**Business Takeaway**

The analyzed delivered orders had an average delivery time of 12.50 days, with 6.77% arriving later than estimated. Further investigation into delay patterns could help identify opportunities to improve fulfilment reliability and customer experience.

**Note:** This analysis includes 96,470 delivered orders for which the required purchase, actual delivery and estimated delivery dates were successfully matched in the date dimension. The results therefore reflect the analyzed subset, not necessarily every delivered order in the raw dataset.

### Q10. How satisfied are customers with their shopping experience?

**Business Objective**

Evaluate customer satisfaction using review scores to understand the overall customer experience and identify the proportion of positive and negative feedback.

**SQL Concepts Used**

* `AVG()` – Calculate the average customer review score.
* `COUNT()` – Count the number of reviews for each score.
* `GROUP BY` – Group reviews by their score.
* `ORDER BY` – Arrange review scores for analysis.
* Percentage calculation – Calculate the proportion of reviews for each score.
* `ROUND()` – Format average scores and percentages.

**Key Findings**

| Review Score | Percentage of Reviews |
| ------------ | --------------------: |
| 5 Stars      |                57.78% |
| 4 Stars      |                19.29% |
| 3 Stars      |                 8.24% |
| 2 Stars      |                 3.18% |
| 1 Star       |                11.51% |

| Metric                       |    Value |
| ---------------------------- | -------: |
| Average Review Score         | 4.09 / 5 |
| Positive Reviews (4–5 stars) |   77.07% |

**Business Interpretation**

* The average customer review score was **4.09 out of 5**, indicating generally positive feedback among customers who submitted reviews.
* Five-star reviews accounted for 57.78% of all reviews, making them the largest review category.
* Combined, four- and five-star reviews represented 77.07% of submitted feedback.
* One-star reviews accounted for 11.51%, highlighting an area for further investigation.

**Business Recommendations**

* Investigate the reasons behind low review scores to identify possible issues with products, delivery or customer service.
* Analyze review scores alongside delivery performance to explore whether delays are associated with lower customer satisfaction.
* Identify product categories and sellers with lower average review scores to determine where improvements may be needed.
* Monitor customer review trends over time to evaluate changes in customer experience.

**Business Takeaway**

Customer feedback was generally positive, with an average score of 4.09 out of 5 and 77.07% of reviews rated four or five stars. However, the share of one-star reviews indicates opportunities to investigate and improve the customer experience.

**Note:** Review scores represent customers who submitted feedback and should not be treated as the opinion of every customer or every order.

### Q11. Which product categories have the lowest average review scores?

**Business Objective**

Identify product categories with relatively low average customer review scores to highlight areas that may require further investigation into customer experience and satisfaction.

**SQL Concepts Used**

* `JOIN` – Combine review, order and product category information.
* `GROUP BY` – Aggregate review scores by product category.
* `AVG()` – Calculate the average review score for each category.
* `COUNT()` – Calculate the number of reviews associated with each category.
* `HAVING` – Include only categories meeting the minimum review count threshold.
* `ORDER BY` – Sort categories by average review score in ascending order.
* `DISTINCT` – Avoid duplicate review-order-category associations where applicable.
* `ROUND()` – Format average review scores.

**Key Findings**

<text color="secondary" size="sm">Lowest-rated categories, with a minimum threshold of 50 reviews:</text>

| Product Category          | Review Count | Average Review Score |
| ------------------------- | -----------: | -------------------: |
| Office Furniture          |          126 |                 3.62 |
| Fashion Male Clothing     |          111 |                 3.70 |
| Audio                     |          348 |                 3.83 |
| Construction Tools Safety |          166 |                 3.85 |
| Home Comfort              |          398 |                 3.86 |
| Fixed Telephony           |          215 |                 3.90 |
| Uncategorized             |          148 |                 3.91 |
| Fashion Underwear Beach   |          120 |                 3.93 |
| Bed Bath Table            |          932 |                 3.97 |
| Home Construction         |          488 |                 3.97 |

**Business Interpretation**

* Office Furniture recorded the lowest average review score at **3.62**, followed by Fashion Male Clothing at **3.70**.
* Audio and Construction Tools Safety also recorded relatively low average scores.
* Bed Bath Table and Home Construction had higher review counts among the listed categories, making them useful candidates for further investigation.
* These results highlight categories with lower average customer feedback, but do not establish the reasons behind the scores.

**Business Recommendations**

* Investigate low-rated categories to understand potential customer concerns relating to product descriptions, quality, delivery or service.
* Examine review comments, where available, to identify recurring themes behind lower scores.
* Prioritize further investigation of categories with both low average scores and substantial review counts.
* Compare category-level review scores with delivery performance and seller-level results to identify potential areas for improvement.

**Business Takeaway**

Office Furniture had the lowest average review score among the analyzed categories, followed by Fashion Male Clothing. These categories may warrant further investigation to identify potential opportunities to improve customer satisfaction.

**Note:** Reviews are associated with orders, not necessarily with individual products or categories. The analysis uses deduplicated review-order-category associations and includes categories with at least 50 associated reviews. Lower category-level scores should not be interpreted as proof of product quality issues.

### Q12. Which product categories have the highest freight-to-sales ratio?

**Business Objective**

Analyze freight costs relative to product sales across categories to identify categories where shipping costs represent a larger proportion of product sales value.

**SQL Concepts Used**

* `JOIN` – Combine order item data with product and category information.
* `GROUP BY` – Aggregate sales and freight values by product category.
* `SUM()` – Calculate total product sales and freight costs.
* `COUNT(DISTINCT)` – Count unique orders per category.
* `HAVING` – Filter categories based on a minimum order count.
* Percentage calculation – Calculate freight costs as a percentage of product sales.
* `ORDER BY` – Rank categories by freight-to-sales ratio.
* `ROUND()` – Format calculated ratios to two decimal places.

**Key Findings**

The following are the 10 categories with the highest freight-to-sales ratios among categories with at least 50 orders:

| Product Category                | Orders | Product Sales |   Freight | Freight-to-Sales Ratio |
| ------------------------------- | -----: | ------------: | --------: | ---------------------: |
| Christmas Supplies              |    128 |        880.82 |    329.30 |                 36.69% |
| Signaling and Security          |    140 |      2,159.23 |    650.82 |                 30.26% |
| Food Drink                      |    227 |      1,579.48 |    457.99 |                 29.70% |
| Electronics                     |    250 |     16,024.74 |  4,658.32 |                 29.07% |
| Furniture Living Room           |    422 |      6,916.56 |  1,796.17 |                 26.07% |
| Kitchen Dining Garden Furniture |    248 |      4,632.37 |  1,199.43 |                 25.90% |
| Drinks                          |    297 |      2,248.70 |    574.25 |                 25.60% |
| Office Furniture                |    127 |     27,960.60 |  6,857.95 |                 25.03% |
| Food                            |    450 |     29,393.41 |  7,271.03 |                 24.74% |
| Furniture Decor                 |    649 |     72,762.49 | 17,249.30 |                 23.67% |

**Business Interpretation**

* Christmas Supplies recorded the highest freight-to-sales ratio at **36.69%**, meaning freight costs were equivalent to over one-third of product sales value for this category.
* Signaling and Security and Food Drink also had relatively high freight-to-sales ratios, both close to 30%.
* Office Furniture and Furniture Decor had substantial freight costs in absolute terms, alongside comparatively lower ratios than the top-ranked categories.
* A high freight-to-sales ratio indicates that shipping costs account for a larger share of product sales value. It does not necessarily mean that a category is unprofitable.

**Business Recommendations**

* Investigate shipping costs for categories with high freight-to-sales ratios to identify potential opportunities for logistics optimization.
* Examine the effects of product size, weight, shipping distance and delivery method, where this information is available.
* Evaluate freight costs alongside product margins and other operating expenses before making pricing or profitability decisions.
* Consider reviewing shipping arrangements for categories with consistently high freight costs relative to sales.

**Business Takeaway**

Christmas Supplies had the highest freight-to-sales ratio among the analyzed categories, followed by Signaling and Security and Food Drink. These categories may warrant further logistics cost analysis to identify opportunities for improving cost efficiency.

**Note:** Freight-to-sales ratio is calculated as total freight divided by total product sales, multiplied by 100. The analysis includes categories with at least 50 orders. This metric is not a profit margin or a direct measure of profitability.

## Project Limitations

Although the project provides useful business insights, certain limitations should be considered when interpreting the results.

**1. Dataset Coverage**

The analysis is based on the available Olist Brazilian E-Commerce dataset and its observation period. The findings may not represent current business performance or customer behavior beyond the period covered.

**2. Data Quality**

Data auditing identified missing values, duplicate identifiers in certain contexts and other data quality issues. Cleaning and validation rules were applied during staging, while relevant anomalies were retained or handled according to their analytical impact.

**3. Customer Retention**

The repeat customer analysis is based on purchasing activity observed within the available dataset period. Customers classified as one-time buyers may have made additional purchases outside this observation window.

**4. Customer Reviews**

Review scores represent customers who submitted feedback and may not reflect the experience of every customer. In addition, reviews are associated with orders and cannot always be attributed directly to individual products or categories.

**5. Profitability Analysis**

The project analyzes product sales and freight costs but does not include all business expenses, such as operational costs, commissions and other cost components. Therefore, sales and freight metrics alone cannot establish actual profitability.

**6. Delivery Performance**

Delivery performance metrics are based on orders with the required date information available and successfully matched during analysis. The results may not represent every order in the dataset.

**7. Limited Business Context**

The dataset does not provide all possible contextual information, such as detailed marketing campaign data, customer acquisition costs or the reasons behind customer decisions. Some business patterns can be identified, but their causes require further investigation.

**8. AI-Assisted Analysis**

AI was used to assist with SQL development, debugging, interpretation and documentation. The project does not involve training or deploying a machine learning model, and the insights are based on descriptive SQL analysis rather than predictive modelling.

## Project Conclusion

This project demonstrates an end-to-end SQL analytics workflow using the Olist Brazilian E-Commerce Public Dataset and MySQL 8.0.

The project involved raw data auditing, data quality assessment, cleaning and staging, analytical data modelling, and business analysis using structured SQL queries.

The analysis addressed 12 business questions covering:

* Order status distribution and monthly order volume
* Product category sales and monthly sales trends
* Repeat customer behavior and Average Order Value
* Seller performance and payment preferences
* Delivery performance and customer satisfaction
* Lowest-rated product categories and freight-to-sales ratios

The findings highlighted several areas of business interest, including the high proportion of delivered orders, the leading product sales categories, low observed repeat purchasing, the dominance of credit card payments, and opportunities to investigate delivery delays, customer feedback and freight costs.

The project demonstrates practical application of SQL for data auditing, transformation, relational data modelling, aggregation, analytical querying and business interpretation.

AI-assisted development supported the workflow by helping with query construction, debugging, concept explanations and documentation, while the project remained focused on SQL-based business intelligence and decision support.

**Overall, this project demonstrates the ability to transform raw e-commerce data into structured analytical datasets and use SQL to derive meaningful business insights that can support data-driven decision-making.**
