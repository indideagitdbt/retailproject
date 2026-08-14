select
    f.store_id,
    year(dd.store_date) as years,
    sum(fuel_price) as fuel_price
from {{ref('fact_sales')}} f
join {{ref('dim_date')}} dd on dd.date_id = f.date_id
where f.vrsn_end_date > current_timestamp()
group by f.store_id, year(dd.store_date)
order by f.store_id, year(dd.store_date)