# 📌Project Overview
This project is an end-to-end data analysis solution aimed at uncovering key business insights from Walmart sales data. It involves structured SQL querying for business problem-solving and interactive Power BI dashboards for impactful data storytelling. By transforming raw data into actionable visuals, this project is ideal for aspiring data analysts looking to enhance their skills in data cleaning, SQL querying, feature engineering, and dashboard development with Power BI.
## 🚀 Project Steps
### 1. Environment Setup
- **Tools Used:** Power BI, SQL (MySQL), Excel.
- **Goal:** Set up a structured workspace for seamless SQL querying, data modeling, and dashboard visualization in Power BI.

### 2. Dataset Access and Preparation
- **Source:** [Walmart Sales Dataset](https://www.kaggle.com/datasets/najir0123/walmart-10k-sales-datasets) on Kaggle
- **Structure:** The original dataset contained 10,051 records in a single table.
- **Manual Split:** Separated into two logical tables — transactions and product — for clearer analysis.

### 3. Data Cleaning
- Removed special characters (e.g., $ sign from unit price).
- Checked for null values and duplicates — none found.
- Ensured proper data types (e.g., date formatted as DATE, prices as FLOAT).
- Renamed and formatted columns for clarity.

### 4. Feature Engineering
- Created a new column total_spendings = unit_price × quantity.
- Extracted new time-based features: year, day_name, and shift to enable advanced temporal analysis.

### 5. SQL-Based Data Exploration & Analysis
- Wrote modular SQL queries using CTEs and aggregations.
- Answered 9 business questions including:
  - Payment method trends
  - Peak sales by city and time
  - Top categories by rating and revenue
  - Branch-wise performance comparison (year-wise)
  - Used intermediate views or nested queries where needed.

### 6. Power BI Dashboard Creation
- Imported SQL queries directly into Power BI via MySQL connector.
- Addressed syntax issues by breaking queries into modular form and ensuring no ORDER BY in views.
- Built visually rich dashboards

### 7. Presentation & Publishing
- Created a PowerPoint presentation highlighting:
- Data Cleaning
- Data Exploration
- SQL logic
- Dashboard visuals
- Business insights
- Uploaded the entire project on GitHub including:
- SQL Scripts
- Dashboard Screenshot(s)
- PPT file
- Project Documentation

### 8. Acknowledgements
- Inspiration and Reference: [Najirh’s Walmart SQL Python Project](https://github.com/najirh/Walmart_SQL_Python)

## Results and Insights
- This section outlines the key findings derived from SQL analysis and Power BI visualizations:
  - Sales Insights: Identified the branch-wise and category-wise sales distribution. Credit Card emerged as the most used payment method with the highest number of transactions and quantities sold.
  - Revenue Trends: Analyzed revenue comparisons between 2022 and 2023, highlighting branches with significant decreases and overall trends.
  - Product Performance: Found the top-rated product categories per branch based on customer ratings and the highest average spending.
  - Customer Behavior: Uncovered purchasing trends by analyzing peak hours, payment preferences, and customer satisfaction ratings.
  - Branch Analysis: Determined the branch with the highest average product rating and transaction performance using custom SQL queries.
