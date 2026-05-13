--Create Bronze Schema
CREATE SCHEMA IF NOT EXISTS bronze;

--Create Customer Table in Bronze Layer 
CREATE TABLE bronze.customers AS
SELECT 
    *,
    NOW() AS _ingested_at
FROM public.customers

-- Create Categories Table in Bronze Layer
CREATE TABLE bronze.categories AS
SELECT 
    *,
    NOW() AS _ingested_at
FROM public.categories;

-- Create Employees Table in Bronze Layer
CREATE TABLE bronze.employees AS
SELECT 
    *,
    NOW() AS _ingested_at
FROM public.employees;

-- Create Shippers Table in Bronze Layer
CREATE TABLE bronze.shippers AS
SELECT 
    *,
    NOW() AS _ingested_at
FROM public.shippers;

-- Create Suppliers Table in Bronze Layer
CREATE TABLE bronze.suppliers AS
SELECT 
    *,
    NOW() AS _ingested_at
FROM public.suppliers;

-- Create Products Table in Bronze Layer
CREATE TABLE bronze.products AS
SELECT 
    *,
    NOW() AS _ingested_at
FROM public.products;

-- Create Orders Table in Bronze Layer
CREATE TABLE bronze.orders AS
SELECT 
    *,
    NOW() AS _ingested_at
FROM public.orders;

-- Create Order Details Table in Bronze Layer
CREATE TABLE bronze.order_details AS
SELECT 
    *,
    NOW() AS _ingested_at
FROM public.orderdetails;