create or replace database walmartdb;

create or replace schema raw;
create or replace schema staging;
create or replace schema mart;

use database walmartdb;
use schema raw;

create or replace table raw_store (
    store int,
    type string,
    size int
);

--using snowflake to infer the SCHEMA then you have to load by doing the copy into command
CREATE OR REPLACE TABLE RAW.RAW_SALES
USING TEMPLATE (
    SELECT ARRAY_AGG(OBJECT_CONSTRUCT(*))
    FROM TABLE(
        INFER_SCHEMA(
            LOCATION=>'@walmart_stage/department.csv',
            FILE_FORMAT=>'csv_format'
        )
    )
);

create or replace table raw_sales (
    store int,
    dept int,
    date date,
    weekly_sales decimal(18,2),
    isholiday boolean
);


create or replace table raw_feature(
    store int,
    date date,
    temperature float,
    fuel_price float,
    markdown1 float,
    markdown2 float,
    markdown3 float,
    markdown4 float,
    markdown5 float,
    cpi float,
    unemployment float,
    isholiday boolean
);

    SELECT *
    FROM TABLE(
        INFER_SCHEMA(
            LOCATION=>'@walmart_stage/fact.csv',
            FILE_FORMAT=>'my_csv'
        )
    );
    
create or replace stage walmart_stage
url = 's3://dea-walmart-project-i/data/'
credentials=(aws_key_id='AKIAR4PWB5A23KDIED3O'
aws_secret_key='z/GvbwTwK8FM/kNur0915yPOLTZpw/vfUIZm/XHy');

ls @walmart_stage;

create or replace file format my_csv
type ='csv'
field_optionally_enclosed_by = '"'
skip_header = 1
null_if=('na','null','','NA');

copy into raw_store
from @walmart_stage/stores.csv
file_format=(format_name=my_csv);

copy into raw_sales
from @walmart_stage/department.csv
file_format=(format_name= my_csv);

copy into raw_feature
from @walmart_stage/fact.csv
file_format=(format_name=my_csv);