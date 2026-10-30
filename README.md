# Blinkit Sales Analysis Using PostgreSQL

## 📌 Project Overview

This project focuses on analyzing Blinkit sales data using **PostgreSQL** to understand product category performance, outlet characteristics, sales distribution, and key business metrics.

The project uses SQL queries for data cleaning, exploratory data analysis (EDA), KPI calculation, sales aggregation, revenue contribution analysis, and outlet performance ranking.

The main goal is to extract meaningful insights from sales data that can support business decisions related to product categories, outlet sizes, location tiers, and outlet types.

## 🎯 Project Objectives

- Analyze overall sales performance using key performance indicators (KPIs).
- Identify product categories that generate the highest sales.
- Compare sales performance across different outlet sizes.
- Evaluate sales across outlet location tiers.
- Identify the best-performing outlet types.
- Analyze sales contributions from Low Fat and Regular products.
- Standardize inconsistent categorical values.
- Check missing values and identify potentially invalid numeric records.
- Rank outlet types and location tiers using PostgreSQL window functions.

## 🛠️ Tools and Technologies

- **Database:** PostgreSQL
- **SQL Environment:** pgAdmin 4
- **Language:** SQL
- **Techniques:** Data Cleaning, Aggregation, Exploratory Data Analysis, KPI Analysis, Window Functions, Conditional Aggregation

## 📂 Dataset Description

The dataset contains product, pricing, visibility, outlet, and sales information.

| Column Name | Description |
|---|---|
| `Item_Fat_Content` | Fat content classification of the product |
| `Item_Type` | Product category |
| `Item_MRP` | Maximum Retail Price of the product |
| `Outlet_Size` | Size classification of the outlet |
| `Outlet_Location_Type` | Location tier of the outlet |
| `Outlet_Type` | Outlet business format |
| `Item_Visibility` | Visibility measure associated with the product |
| `Outlet_Establishment_Year` | Year in which the outlet was established |
| `Sales` | Sales value associated with the record |

## 🧹 Data Cleaning and Preparation

The project includes the following data preparation steps:

### 1. Data Inspection
- Display sample records from the dataset.
- Count the total number of records.
- Identify distinct product fat-content categories.

### 2. Standardization of Fat Content
Inconsistent labels are standardized as follows:

- `LF` → `Low Fat`
- `low fat` → `Low Fat`
- `reg` → `Regular`

### 3. Outlet Size Standardization
- Remove leading and trailing spaces using `TRIM()`.
- Standardize capitalization using `INITCAP()`.

### 4. Missing Value Analysis
Check missing values in the following columns:

- Item Type
- Sales
- Item MRP
- Outlet Size
- Outlet Type
- Outlet Establishment Year

### 5. Invalid Numeric Value Checks
Identify records containing potentially invalid values, such as:

- Negative sales
- Negative item MRP
- Negative item visibility
- Establishment years earlier than 1900

These checks identify suspicious records for investigation; they do not automatically remove them.

## 📊 Key Performance Indicators (KPIs)

The project calculates the following KPIs:

| KPI | Description | SQL Function |
|---|---|---|
| Total Sales Revenue | Total sales value across all records | `SUM()` |
| Average Sales per Record | Average sales value per record | `AVG()` |
| Total Records | Total number of records | `COUNT(*)` |
| Total Product Categories | Number of unique item categories | `COUNT(DISTINCT ...)` |
| Average Item Visibility | Average visibility measure | `AVG()` |
| Sales per Item Category | Total sales divided by the number of distinct item categories | `SUM()` and `COUNT()` |
| Low Fat Sales Contribution | Percentage of total sales from Low Fat products | `SUM() FILTER` |
| Regular Sales Contribution | Percentage of total sales from Regular products | `SUM() FILTER` |

## 🔍 Business Questions and Analysis

### 1. Product Category Analysis

**Objective:** Identify the strongest product categories based on sales.

The analysis calculates:
- Total sales by item type.
- Number of records in each category.
- Average sales per record.

**Business value:** Helps identify categories that contribute more to overall sales and deserve further investigation.

### 2. Outlet Size Analysis

**Objective:** Compare sales performance across outlet sizes.

The analysis calculates:
- Total sales by outlet size.
- Number of records by outlet size.
- Average sales per record.
- Percentage contribution to total sales.

NULL outlet sizes are grouped under `Unknown` using `COALESCE()`.

**Business value:** Helps compare sales distribution across outlet size classifications.

### 3. Outlet Location Tier Analysis

**Objective:** Identify which location tier generates the highest sales.

The analysis calculates:
- Total sales by location tier.
- Number of records per tier.
- Average sales per record.
- Sales ranking using `RANK()`.
- Revenue contribution percentage.

**Business value:** Helps compare sales performance across different location tiers.

### 4. Outlet Type Analysis

**Objective:** Evaluate the performance of different outlet business formats.

The analysis calculates:
- Total sales by outlet type.
- Number of records per outlet type.
- Average sales per record.
- Average item MRP.
- Outlet ranking using `DENSE_RANK()`.

**Business value:** Helps identify outlet types associated with higher sales and compare their average sales and pricing characteristics.

### 5. Product Fat Content Analysis

**Objective:** Compare sales contributions from Low Fat and Regular products.

The analysis calculates the percentage of total sales associated with each fat-content category.

**Business value:** Helps understand the distribution of sales across product fat-content classifications.

## 🧠 PostgreSQL Concepts Used

### Aggregate Functions
- `SUM()` — Calculates total sales.
- `AVG()` — Calculates average sales and item visibility.
- `COUNT()` — Counts records.
- `COUNT(DISTINCT ...)` — Counts unique categories.

### Data Cleaning Functions
- `TRIM()` — Removes leading and trailing spaces.
- `LOWER()` — Converts text to lowercase for consistent matching.
- `INITCAP()` — Standardizes capitalization.
- `COALESCE()` — Replaces NULL values with a fallback value.

### Conditional Aggregation
- `FILTER (WHERE ...)` — Calculates sales for specific product categories.
- `NULLIF()` — Prevents division-by-zero errors in percentage calculations.
- `ROUND()` — Rounds numeric results to a specified number of decimal places.

### Window Functions
- `RANK()` — Ranks location tiers according to total sales.
- `DENSE_RANK()` — Ranks outlet types according to total sales without gaps after ties.
- `SUM() OVER()` — Calculates grand totals across grouped results for revenue contribution analysis.

### Grouping and Sorting
- `GROUP BY` — Aggregates records by categories.
- `ORDER BY` — Sorts results based on sales performance.

## 📈 Business Value

This project provides a foundation for understanding sales performance and exploring business questions such as:

- Which product categories generate the most sales?
- How is revenue distributed across outlet sizes?
- Which location tiers perform best?
- Which outlet types have the highest total sales?
- How much do Low Fat and Regular products contribute to sales?
- Which outlet categories should be investigated further for potential improvement?

The results can support further analysis and dashboard development using tools such as Power BI or Tableau.

## ⚙️ How to Run the Project

1. Install PostgreSQL.
2. Open pgAdmin 4 and connect to your PostgreSQL server.
3. Create a database for the project.
4. Create the `blinkit` table using the SQL schema.
5. Import the dataset into the table, ensuring the column names and data types match the schema.
6. Open the SQL script in the pgAdmin Query Tool.
7. Execute the queries section by section.
8. Review the output for data quality, KPIs, product category performance, outlet size analysis, location tier analysis, and outlet type ranking.

**Note:** Run the table creation statement only when creating a new table. The `UPDATE` statements modify existing records, so execute them after importing the dataset.

## 🚀 Future Enhancements

- Develop an interactive sales dashboard using Power BI or Tableau.
- Add time-based analysis if transaction dates become available.
- Incorporate profit, cost, and margin data.
- Include a unique outlet identifier for outlet-level analysis.
- Expand the analysis with additional product and location comparisons.

