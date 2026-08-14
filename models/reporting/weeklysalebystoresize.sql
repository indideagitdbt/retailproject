{{config(materialized='view')}}

select
    f.store_id,
    sum(store_weekly_sales) as sum_weekly_sales,
    store_size
from {{ref('fact_sales')}} f
join {{ref('dim_store')}} ds on ds.store_id = f.store_id and f.dept_id = ds.dept_id
where f.vrsn_end_date > current_timestamp()
group by f.store_id, store_size
