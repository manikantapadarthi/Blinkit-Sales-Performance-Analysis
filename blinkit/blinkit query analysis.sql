CREATE TABLE blinkit (
    Item_Fat_Content TEXT,
    Item_Type TEXT,
    Item_MRP NUMERIC(10,2),
    Outlet_Size TEXT,
    Outlet_Location_Type TEXT,
    Outlet_Type TEXT,
    Item_Visibility NUMERIC(10,4),
    Outlet_Establishment_Year INTEGER,
    Sales NUMERIC(12,2)
);


-- Check the table structure
SELECT *
FROM blinkit
LIMIT 10;

-- Check number of records
SELECT COUNT(*) AS total_records
FROM blinkit;

-- Check distinct fat content labels
SELECT DISTINCT Item_Fat_Content
FROM blinkit
ORDER BY Item_Fat_Content;

-- Standardize fat content labels
UPDATE blinkit
SET Item_Fat_Content = 'Low Fat'
WHERE LOWER(TRIM(Item_Fat_Content)) IN ('lf', 'low fat');

UPDATE blinkit
SET Item_Fat_Content = 'Regular'
WHERE LOWER(TRIM(Item_Fat_Content)) = 'reg';

-- Standardize outlet size labels
UPDATE blinkit
SET Outlet_Size = INITCAP(TRIM(Outlet_Size))
WHERE Outlet_Size IS NOT NULL;

-- Check missing values
SELECT
    COUNT(*) FILTER (WHERE Item_Type IS NULL) AS missing_item_type,
    COUNT(*) FILTER (WHERE Sales IS NULL) AS missing_sales,
    COUNT(*) FILTER (WHERE Item_MRP IS NULL) AS missing_mrp,
    COUNT(*) FILTER (WHERE Outlet_Size IS NULL) AS missing_outlet_size,
    COUNT(*) FILTER (WHERE Outlet_Type IS NULL) AS missing_outlet_type,
    COUNT(*) FILTER (
        WHERE Outlet_Establishment_Year IS NULL
    ) AS missing_establishment_year
FROM blinkit;

-- Check for invalid numeric values
SELECT *
FROM blinkit
WHERE Sales < 0
   OR Item_MRP < 0
   OR Item_Visibility < 0
   OR Outlet_Establishment_Year < 1900;


-- KPI 1: Total Sales Revenue
SELECT
    ROUND(SUM(Sales), 2) AS total_sales
FROM blinkit;

-- KPI 2: Average Sales per Record
SELECT
    ROUND(AVG(Sales), 2) AS average_sales
FROM blinkit;

-- KPI 3: Total Number of Records
SELECT
    COUNT(*) AS total_records
FROM blinkit;

-- KPI 4: Total Product Categories
SELECT
    COUNT(DISTINCT Item_Type) AS total_item_categories
FROM blinkit;

-- KPI 5: Average Item Visibility
SELECT
    ROUND(AVG(Item_Visibility), 4) AS average_item_visibility
FROM blinkit;

-- KPI 6: Total Sales per Item Category
SELECT
    ROUND(
        SUM(Sales) / NULLIF(COUNT(DISTINCT Item_Type), 0),
        2
    ) AS sales_per_category
FROM blinkit;

-- KPI 7: Sales Contribution from Low Fat Products
SELECT
    ROUND(
        100.0 * SUM(Sales) FILTER (
            WHERE Item_Fat_Content = 'Low Fat'
        ) / NULLIF(SUM(Sales), 0),
        2
    ) AS low_fat_sales_percentage
FROM blinkit;

-- KPI 8: Sales Contribution from Regular Products
SELECT
    ROUND(
        100.0 * SUM(Sales) FILTER (
            WHERE Item_Fat_Content = 'Regular'
        ) / NULLIF(SUM(Sales), 0),
        2
    ) AS regular_sales_percentage
FROM blinkit;


--Identify the strongest product categories by revenue and record count
SELECT
    Item_Type,
    ROUND(SUM(Sales), 2) AS total_sales,
    COUNT(*) AS item_count,
    ROUND(AVG(Sales), 2) AS average_sales,
    ROUND(AVG(I
FROM blinkit
GROUP BY Item_Type
ORDER BY total_sales DESC;

-- Compare sales across Small, Medium, and High outlet sizes

SELECT
    COALESCE(Outlet_Size, 'Unknown') AS outlet_size,
    ROUND(SUM(Sales), 2) AS total_sales,
    COUNT(*) AS record_count,
    ROUND(AVG(Sales), 2) AS average_sales,
    ROUND(100.0 * SUM(Sales) /
        NULLIF(SUM(SUM(Sales)) OVER (), 0), 2
    ) AS sales_percentage
FROM blinkit
GROUP BY COALESCE(Outlet_Size, 'Unknown')
ORDER BY total_sales DESC;

-- Compare Tier 1, Tier 2, and Tier 3 locations, depending on the labels in your dataset

SELECT
    Outlet_Location_Type,
    ROUND(SUM(Sales), 2) AS total_sales,
    COUNT(*) AS record_count,
    ROUND(AVG(Sales), 2) AS average_sales,
    RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS sales_rank,
    ROUND(
        100.0 * SUM(Sales) /
        NULLIF(SUM(SUM(Sales)) OVER (), 0),
        2
    ) AS sales_contribution_pct
FROM blinkit
GROUP BY Outlet_Location_Type
ORDER BY total_sales DESC;

-- Evaluate different outlet business formats.

SELECT
    Outlet_Type,
    ROUND(SUM(Sales), 2) AS total_sales,
    COUNT(*) AS record_count,
    ROUND(AVG(Sales), 2) AS average_sales,
    ROUND(AVG(Item_MRP), 2) AS average_mrp,
    DENSE_RANK() OVER (
        ORDER BY SUM(Sales) DESC
    ) AS outlet_rank
FROM blinkit
GROUP BY Outlet_Type
ORDER BY total_sales DESC;
