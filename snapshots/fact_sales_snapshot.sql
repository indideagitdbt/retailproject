{% snapshot fact_sales_snapshot %}

{{
    config(
        target_schema = 'mart',
        unique_key = ['store_id','dept_id', 'date_id'],
        strategy = 'check',
        check_cols=['store_weekly_sales',
                    'fuel_price',
                    'store_temperature',
                    'unemployment',
                    'cpi',
                    'markdown1',
                    'markdown2',
                    'markdown3',
                    'markdown4',
                    'markdown5']
    )
}}

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
    f.markdown5

from {{ref('stg_sales')}} s
join {{ref('dim_store')}} ds on ds.store_id = s.store_id and ds.dept_id=s.dept_id
join {{ref('dim_date')}} dd on dd.store_date = s.store_date
join {{ref('stg_feature')}} f on f.store_id = s.store_id and f.store_date = s.store_date 

{% endsnapshot %}