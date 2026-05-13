CREATE SCHEMA IF NOT EXISTS silver

CREATE TABLE silver.categories AS
SELECT
    categoryid          AS category_id,
    categoryname        AS category_name,
    description         AS description,
    NOW()               AS _ingested_at
FROM bronze.categories

CREATE TABLE silver.customers AS
SELECT
    customerid          AS customer_id,
    customername        AS customer_name,
    contactname         AS contact_name,
    address             AS address,
    INITCAP(city)       AS city,
    postalcode          AS postal_code,
    INITCAP(country)    AS country,
    NOW()               AS _ingested_at
FROM bronze.customers

CREATE TABLE silver.employees AS
SELECT
    employeeid              AS employee_id,
    lastname                AS last_name,
    firstname               AS first_name,
    firstname || ' ' || lastname AS full_name,
    birthdate::DATE         AS birth_date,
    photo                   AS photo,
    notes                   AS notes,
    NOW()                   AS _ingested_at
FROM bronze.employees

CREATE TABLE silver.shippers AS
SELECT
    shipperid           AS shipper_id,
    shippername         AS shipper_name,
    phone               AS phone,
    NOW()               AS _ingested_at
FROM bronze.shippers

CREATE TABLE silver.suppliers AS
SELECT
    supplierid          AS supplier_id,
    suppliername        AS supplier_name,
    contactname         AS contact_name,
    address             AS address,
    INITCAP(city)       AS city,
    postalcode          AS postal_code,
    INITCAP(country)    AS country,
    phone               AS phone,
    NOW()               AS _ingested_at
FROM bronze.suppliers

CREATE TABLE silver.products AS
SELECT
    productid           AS product_id,
    productname         AS product_name,
    supplierid          AS supplier_id,
    categoryid          AS category_id,
    unit                AS unit,
    ROUND(price::NUMERIC, 2) AS price,
    NOW()               AS _ingested_at
FROM bronze.products

CREATE TABLE silver.orders AS
SELECT
    orderid             AS order_id,
    customerid          AS customer_id,
    employeeid          AS employee_id,
    orderdate::DATE     AS order_date,
    shipperid           AS shipper_id,
    NOW()               AS _ingested_at
FROM bronze.orders

CREATE TABLE silver.order_details AS
SELECT
    od.orderdetailid        AS order_detail_id,
    od.orderid              AS order_id,
    od.productid            AS product_id,
    od.quantity             AS quantity,
    ROUND((od.quantity * p.price)::NUMERIC, 2) AS line_total,
    NOW()                   AS _ingested_at
FROM bronze.order_details od
JOIN bronze.products p ON od.productid = p.productid
