{{config(
    materialized='incremental',
    incremental_strategy='merge',
    unique_key=['store_id', 'dept_id', 'date_id'],
    merge_exclude_columns= ['insert_date']
)}}

select 
    s.store_id,
    s.dept_id, 
    dd.date_id,
    s.store_weekly_sales,
    f.fuel_price,
    f.store_temperature,
    f.unemployment,
    f.cpi,
    f.markdown1,
    f.markdown2,
    f.markdown3,
    f.markdown4,
    f.markdown5,
    current_timestamp() as insert_date,
    current_timestamp() as update_date

from {{ref('stg_sales')}} s
join {{ref('dim_store')}} ds on ds.store_id = s.store_id and ds.dept_id=s.dept_id
join {{ref('dim_date')}} dd on dd.store_date = s.store_date
join {{ref('stg_feature')}} f on f.store_id = s.store_id and f.store_date = s.store_date 
