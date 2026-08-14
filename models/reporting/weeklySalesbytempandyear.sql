{{config(materialized='view')}}


select
    sum(store_weekly_sales) as sum_weekly_sales,
    store_temperature,
    year(dd.store_date) as years
from {{ref('fact_sales')}} f
join {{ref('dim_date')}} dd on dd.date_id = f.date_id
where f.vrsn_end_date > current_timestamp()
group by store_temperature, year(dd.store_date)
order by store_temperature, years