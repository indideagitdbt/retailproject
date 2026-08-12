{{ config(materialized='view')}}

select 
    store as store_id,
    date as store_date,
    temperature as store_temperature,
    fuel_price,
    cpi,
    unemployment,
    isholiday,
    markdown1,
    markdown2,
    markdown3,
    markdown4,
    markdown5
from {{ source('raw','RAW_FEATURE')}}