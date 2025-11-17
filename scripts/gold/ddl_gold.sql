/* 
----------------------------------------------------------------
Creating Dimension Tables for Gold Layer
----------------------------------------------------------------
Purpose:  
      The scripts below create views for the dimension tables 
      in the Gold layer. It is a culmination of cleaned data 
      from the Bronze layer and sorted in a orderly fashion 
      from the Silver layer for a more analytical ready dataset.
----------------------------------------------------------------
*/

----------------------------------------------------------------
----------------------------------------------------------------
Creating Dimension Table: gold.dim_customers 
----------------------------------------------------------------
----------------------------------------------------------------

CREATE OR ALTER VIEW gold.dim_customers AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key,
	ci.cst_id AS customer_id, 
	ci.cst_key AS customer_number, 
	ci.cst_firstname AS first_name,
	ci.cst_lastname AS last_name,
	la.cntry AS country,
	ci.cst_marital_status AS marital_status,
	CASE WHEN ci.cst_gndr != 'N/a' THEN ci.cst_gndr 
	ELSE COALESCE(ca.gen, 'N/a')
	END AS gender, 
	ci.cst_create_date AS create_date,
	ca.bdate AS birthdate	
FROM silver.crm_cust_info ci
LEFT JOIN silver.erp_cust_az12 ca
ON ci.cst_key = ca.cid 
LEFT JOIN silver.erp_loc_a101 la
ON ci.cst_key = la.cid

----------------------------------------------------------------
----------------------------------------------------------------
Creating Dimension Table: gold.dim_products 
----------------------------------------------------------------
----------------------------------------------------------------

CREATE VIEW gold.dim_products AS
SELECT 
	ROW_NUMBER() OVER (ORDER BY pri.prd_start_dt, pri.prd_key) AS product_key,
	pri.prd_id AS product_id,
	pri.prd_key AS product_number,
	pri.prd_nm AS product_name,
	pri.cat_id AS category_id,
	pc.cat AS category,
	pc.subcat AS subcategory,
	pc.maintenance,
	pri.prd_cost AS cost,
	pri.prd_line AS product_line,
	pri.prd_start_dt AS start_date
FROM silver.crm_prd_info pri
LEFT JOIN silver.erp_px_cat_g1v2 pc
ON pri.cat_id = pc.id 
WHERE prd_end_dt IS NULL

----------------------------------------------------------------
----------------------------------------------------------------
Creating Dimension Table: gold.fact_sales
----------------------------------------------------------------
----------------------------------------------------------------

CREATE VIEW gold.fact_sales AS t
SELECT 
sd.sls_ord_num AS order_number,
pr.product_key,
cu.customer_key,
sd.sls_order_dt AS order_date, 
sd.sls_ship_dt AS shipping_date,
sd.sls_due_dt AS due_date,
sd.sls_sales AS sales,
sd.sls_quantity AS quantity,
sd.sls_price AS price
FROM silver.crm_sales_details sd
LEFT JOIN gold.dim_products pr
ON sd.sls_prd_key = pr.product_number
LEFT JOIN gold.dim_customers cu
ON sd.sls_cust_id = cu.customer_id
