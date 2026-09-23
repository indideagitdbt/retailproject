Walmart Retail Sales: End-to-End Data Pipeline (AWS S3 + Snowflake + dbt)

This project takes raw Walmart weekly sales files and turns them into a tested, analytics-ready star schema in Snowflake, with history tracking and reporting on top.

Architecture
CSV files -> AWS S3 -> Snowflake RAW -> dbt STAGING -> dbt MART (star schema + SCD Type 2) -> dbt REPORTING -> Python / Tableau
Data

Three source files, loaded into Snowflake RAW tables:

Source	What it holds
RAW_SALES	Weekly sales by store and department, holiday flag
RAW_STORE	Store type and size
RAW_FEATURE	Temperature, fuel price, CPI, unemployment, markdowns by store and week
How it works

1. Ingestion (Snowflake + S3) Walmartporoject.sql sets up the database and schemas, then loads the CSVs from S3 through a Snowflake storage integration that uses an IAM role (no hardcoded keys), an external stage, and a CSV file format that cleans up null values like na and NULL.

2. Staging (models/1staging) Views that rename and standardize columns from the raw tables so everything downstream uses consistent names like store_id, dept_id, and store_date.

3. Mart (models/2mart)

dim_store and dim_date: incremental models using a merge strategy, so reruns update existing rows without rebuilding the table or overwriting the original insert date
fact_sales: weekly sales joined with economic and markdown features at the store, department, and week grain
fact_sales_snapshot (snapshots/): SCD Type 2 snapshot that tracks changes to sales and feature values over time, exposed in fact_sales as version start and end dates

4. Data tests Defined in schema.yml and mart.yml, using dbt tests and dbt_utils:

not_null and unique on keys
Composite uniqueness on store_id + dept_id + date_id for the fact table
Relationship tests so every fact row matches a valid store and date

5. Reporting (models/reporting) Ten reporting views built on the mart, including weekly sales by store, store type, store size, department, and month, plus sales against temperature, fuel price, CPI, and markdowns. These feed a Python notebook (walmatreports.ipynb) and a Tableau workbook (wa.twb).

Tech

AWS S3, AWS IAM, Snowflake, dbt Core, dbt_utils, SQL, Python (Jupyter), Tableau

How to run
Run Walmartporoject.sql in Snowflake to create the database, stage, and raw tables, and load the data
Set up a dbt profile named default pointing to your Snowflake account
Install packages: dbt deps
Build everything (snapshots, models, and tests): dbt build
Optional: dbt docs generate && dbt docs serve to browse lineage
What I learned
Why a storage integration with an IAM role is safer than putting AWS keys in a COPY statement
How incremental merge models let reruns stay fast without losing when a row was first inserted
How dbt snapshots handle SCD Type 2 history, and how relationship tests catch broken joins before they reach a report
