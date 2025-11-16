/* 
--------------------------------------------------------------------
Data Quality Check
--------------------------------------------------------------------
Purpose: 
        Below is a compilation of the queries used to examine and 
        inspect unclean data. 
--------------------------------------------------------------------
*/

-- Checking for Nulls or Duplicates in Primary Key

SELECT 
	cst_id, 
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Checking for Nulls or Duplicates in Primary Key

SELECT 
	cst_id, 
	COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Checking for unwanting spaces 
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname LIKE '% %'

-- Better method 
SELECT cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Consistency 
SELECT DISTINCT cst_gndr
FROM bronze.crm_cust_info;

SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info

-- Checking for NULLS or Duplicates in Primary Key 

SELECT prd_id, COUNT(*) FROM silver.crm_prd_info 
GROUP BY prd_id 
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Checkking for trailing spaces
SELECT prd_nm FROM silver.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Checking for NULLS or Negative Numbers
SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Data Standardization & Consistency 
SELECT DISTINCT prd_line 
FROM silver.crm_prd_info

-- Checking for invalid Date Orders 
SELECT * 
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt

-- Check for Invalid Dates 

SELECT 
NULLIF(sls_order_dt, 0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt <= 0
OR LEN(sls_order_dt) != 8 
OR sls_order_dt > 20500101
OR sls_order_dt < 19000101

-- Check for Invalid Date Orders 
SELECT * FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_ship_dt

-- Checking Data Consistency: Between Sales, Quantity, and Price 
-- Sales = Quantity * Price 
-- Values must not be NULL or negative

SELECT DISTINCT
	sls_sales AS old_sls_sales,
	sls_quantity,
	sls_price AS old_sls_price,
CASE WHEN sls_sales IS NULL OR sls_sales <= 0 or sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <=0 
		THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price
END AS sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- Identify Out-of-range Dates

SELECT DISTINCT 
bdate 
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()

-- Data Standardization & Consistency 
SELECT DISTINCT gen 
FROM silver.erp_cust_az12
