CREATE SCHEMA IF NOT EXISTS gold

CREATE TABLE gold.dim_customers AS
SELECT
    customer_id,
    customer_name,
    contact_name,
    city,
    country,
    postal_code
FROM silver.customers

CREATE TABLE gold.dim_products AS
SELECT
    p.product_id,
    p.product_name,
    p.unit,
    p.price,
    c.category_id,
    c.category_name
FROM silver.products p
JOIN silver.categories c ON p.category_id = c.category_id

CREATE TABLE gold.dim_employees AS
SELECT
    employee_id,
    full_name,
    first_name,
    last_name,
    birth_date
FROM silver.employees

CREATE TABLE gold.dim_date AS
SELECT
    date::DATE                          AS date_id,
    date::DATE                          AS full_date,
    EXTRACT(YEAR FROM date)::INT        AS year,
    EXTRACT(QUARTER FROM date)::INT     AS quarter,
    EXTRACT(MONTH FROM date)::INT       AS month_number,
    TO_CHAR(date, 'Month')              AS month_name,
    EXTRACT(DAY FROM date)::INT         AS day,
    TO_CHAR(date, 'Day')                AS day_name,
    CASE 
        WHEN EXTRACT(ISODOW FROM date) IN (6,7) 
        THEN TRUE ELSE FALSE 
    END                                 AS is_weekend
FROM GENERATE_SERIES(
    (SELECT MIN(order_date) FROM silver.orders),
    (SELECT MAX(order_date) FROM silver.orders),
    '1 day'::INTERVAL
) AS date

CREATE TABLE gold.fact_sales AS
SELECT
    od.order_detail_id,
    o.order_id,
    o.order_date,
    o.customer_id,
    o.employee_id,
    o.shipper_id,
    od.product_id,
    p.category_id,
    od.quantity,
    p.price                                         AS unit_price,
    od.line_total                                   AS revenue,
    ROUND((od.line_total * 0.8)::NUMERIC, 2)       AS estimated_cost,
    ROUND((od.line_total * 0.2)::NUMERIC, 2)       AS estimated_profit
FROM silver.orders o
JOIN silver.order_details od ON o.order_id = od.order_id
JOIN silver.products p ON od.product_id = p.product_id
JOIN silver.categories cat ON p.category_id = cat.category_id
JOIN silver.customers c ON o.customer_id = c.customer_id
JOIN silver.employees e ON o.employee_id = e.employee_id
