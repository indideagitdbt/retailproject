{{config( materialized='view' )}}

select 
    store as store_id,
    dept as dept_id,
    date as store_date,
    weekly_sales AS store_weekly_sales,
    isholiday
from {{ source('raw','RAW_SALES')}}
