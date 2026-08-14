{{config(materialized='view')}}


select
    sum(store_weekly_sales) as sum_weekly_sales,
    cpi
from {{ref('fact_sales')}} f
where f.vrsn_end_date > current_timestamp()
group by cpi
order by cpi