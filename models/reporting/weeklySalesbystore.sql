{{config(materialized='view')}}

select
    f.store_id,
    sum(store_weekly_sales) as sum_weekly_sales,
    isholiday
from {{ref('fact_sales')}} f
join {{ref('dim_date')}} dd on dd.date_id = f.date_id
where f.vrsn_end_date > current_timestamp()
group by store_id, isholiday