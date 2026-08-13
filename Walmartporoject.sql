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
--this works but is not secure due to hardcode secret key and access code
create or replace stage walmart_stage
url = 's3://dea-walmart-project-i/data/'
credentials=(aws_key_id='AKIAR4PWB5A23KDIED3O'
aws_secret_key='z/GvbwTwK8FM/kNur0915yPOLTZpw/vfUIZm/XHy');

ls @walmart_stage;

--THIS is more secure with the iam role
create or replace storage integration walmart_int
type = external_stage
storage_provider = 'S3'
enabled = TRUE
storage_aws_role_arn = 'arn:aws:iam::129901914165:role/snowflakeloadrole'
storage_allowed_locations=('s3://dea-walmart-project-i/data/');

desc integration walmart_int;

--create the STAGE
create or replace stage walmart_int_stage
storage_integration= walmart_int
url='s3://dea-walmart-project-i/data/';

ls @walmart_int_stage;


create or replace file format my_csv
type ='csv'
field_optionally_enclosed_by = '"'
skip_header = 1
null_if=('na','null','','NA');

copy into raw_store
from @walmart_int_stage/stores.csv
file_format=(format_name=my_csv);

copy into raw_sales
from @walmart_int_stage/department.csv
file_format=(format_name= my_csv);

copy into raw_feature
from @walmart_int_stage/fact.csv
file_format=(format_name=my_csv);

select * from raw_store;
SELECT * FROM RAW_SALES;
select * from raw_feature;