{{config(materialized='view')}}

select
    f.dept_id,
    sum(store_weekly_sales) as sum_weekly_sales
from {{ref('fact_sales')}} f
join {{ref('dim_store')}} ds on ds.store_id = f.store_id and f.dept_id = ds.dept_id
where f.vrsn_end_date > current_timestamp()
group by f.dept_id
