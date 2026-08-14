{{config(materialized='view')}}

select
    sum(store_weekly_sales) as sum_weekly_sales,
    store_type, 
    month(dd.store_date) as months
from {{ref('fact_sales')}} f
join {{ref('dim_store')}} ds on ds.store_id = f.store_id and f.dept_id = ds.dept_id
join {{ref('dim_date')}} dd on dd.date_id = f.date_id
where f.vrsn_end_date > current_timestamp()
group by store_type, month(dd.store_date)
