# Layoffs-Analysis-SQL-Data-Cleaning-and-Exploratory-Analysis-2020-2023-
An end-to-end SQL project in MySQL. I cleaned a messy real-world layoffs dataset, then explored it to find where and when layoffs happened and which companies and funding stages were hit hardest.

Tool: MySQL 

Repository structure
1. 01_data_cleaning/	SQL script that turns the raw table into a clean, analysis-ready table (layoffs_staging2)
2. 02_exploratory_analysis/	SQL script (Exploratory Data Analysis.sql) with all analysis queries.
   
Objectives
1.Clean and standardize the raw data without changing the source table
2. Fix duplicates, inconsistent text, wrong date types and missing values
3. Find yearly and monthly layoff trends
4. Identify the most affected companies, countries and funding stages

Part 1: Data cleaning
The raw data had duplicates, inconsistent entries, null values and dates stored as text. Rows went from [X] to [Y] after cleaning.

1. Created staging tables. Copied the raw table to layoffs_staging so the source data stays untouched.
2. Removed duplicates without a unique ID. Used ROW_NUMBER() OVER (PARTITION BY ...) across all columns, saved the result in layoffs_staging2, and deleted rows where row_num > 1. [N] duplicates were removed.
3. Standardized values.
   . Trimmed extra spaces in company and industry names with TRIM().
   . Merged crypto, cryptocurrency and crypto currency into Crypto.
   . Fixed United States. to United States by removing the trailing period.
4. Fixed date formats. Converted the text date column with STR_TO_DATE(date, '%m/%d/%Y') and changed the column type to DATE with ALTER TABLE.
5. Handled nulls and blanks. Filled missing values where another row for the same company had them (for example Airbnb's industry). Deleted [N] rows where both total_laid_off and percentage_laid_off were null and could not be recovered, since they cannot support the analysis.
6. Final cleanup. Dropped the helper row_num column and checked the final table.
   
Part 2: Exploratory data analysis
Using the cleaned table, I answered these questions with SQL only:

. How did layoffs change by year and by month?
. Which companies, countries and funding stages had the most layoffs?
. Which companies laid off 100% of their staff?
. Who were the top companies by layoffs in each year?

Key findings
1. Layoffs peaked in early 2023. A rolling monthly total built up from March 2020, slowed in 2021, rose again through 2022, and passed 340,000 job cuts by early 2023.
2. Several startups laid off 100% of staff, even after raising millions in funding. 
3. The US had the most layoffs overall. 
4. Post-IPO companies had the most layoffs by funding stage, followed by acquired companies and Series C and D startups. Seed and Series A companies were also affected, so layoffs hit every stage. 
5. Top 5 companies by layoffs each year (ranked with DENSE_RANK()):
   
Year	Top companies
2020	Uber, Booking.com, Groupon
2021	Bytedance, Katerra, Zillow
2022	Meta, Amazon, Cisco
2023	Google, Microsoft, Ericsson

SQL concepts used
. Staging tables and safe, step-by-step data cleaning
. Common Table Expressions (CTEs)
. Window functions: ROW_NUMBER(), DENSE_RANK(), OVER (PARTITION BY ...)
. Aggregation: SUM, AVG, GROUP BY
. Date conversion and rolling totals
. Self-joins to fill missing values

What I learned
. How to clean real-world data without a unique ID
. Why staging tables and documenting each step matter
. How to turn clean data into clear findings with window functions

Limitations
. Some rows were deleted because key columns were null, so totals may be understated.
. The data covers only part of 2023, so 2023 should not be compared with full years.
