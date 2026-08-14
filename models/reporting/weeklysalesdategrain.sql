{{config(materialized='view')}}


select
    sum(store_weekly_sales) as sum_weekly_sales,
    year(dd.store_date) as years,
    month(dd.store_date) as months,
    day(dd.store_date) as daysnum
from {{ref('fact_sales')}} f
join {{ref('dim_date')}} dd on dd.date_id = f.date_id
where f.vrsn_end_date > current_timestamp()
group by year(dd.store_date),
    month(dd.store_date),
    day(dd.store_date)
order by year(dd.store_date),
    month(dd.store_date),
    day(dd.store_date)