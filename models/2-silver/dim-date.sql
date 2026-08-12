{{config(
    materialized='incremental',
    unique_key='date_id',
    incremental_strategy='merge',
    merge_exclude_columns=['insert_date']
    )}}

with dates as (
    select distinct
        store_date,
        isholiday
    from {{ref('stg_sales')}}
)
select 
    to_number(to_char(store_date, 'yyyymmdd')) as date_id,
    store_date,
    isholiday,
    current_timestamp() as insert_date, 
    current_timestamp() as update_date
from dates