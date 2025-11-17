-- Checking for potential duplicates of Customer key in gold.dim_customers table

SELECT 
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers 
GROUP BY customer_key 
HAVING COUNT(*) > 1 ;

-- Checking for potential duplicates of Product key in gold.dim_products table

SELECT 
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY customer_key 
HAVING COUNT(*) > 1 ;


SELECT * 
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL
