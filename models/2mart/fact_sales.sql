{{config(
    materialized= 'table',
    schema= 'mart',
)}}

select 
    store_id,
    dept_id, 
    date_id,
    store_weekly_sales,
    fuel_price,
    store_temperature,
    unemployment,
    cpi,
    markdown1,
    markdown2,
    markdown3,
    markdown4,
    markdown5,
    dbt_valid_from as insert_date,
    dbt_updated_at as update_date,
    dbt_valid_from as vrsn_start_date,
    coalesce(dbt_valid_to, to_timestamp('9999-12-31')) as vrsn_end_date

from {{ref('fact_sales_snapshot')}}