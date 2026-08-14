select
    f.store_id,
    year(dd.store_date) as years,
    sum(markdown1) as markdown1,
    sum(markdown2) as markdown2,
    sum(markdown3) as markdown3,
    sum(markdown4) as markdown4,
    sum(markdown5) as markdown5
from {{ref('fact_sales')}} f
join {{ref('dim_date')}} dd on dd.date_id = f.date_id
where f.vrsn_end_date > current_timestamp()
group by f.store_id, year(dd.store_date)
order by f.store_id, year(dd.store_date)