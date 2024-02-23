{{ config(
    materialized = 'table'
) }}


select 
    order_id,
    CAST(customer_id AS INT) AS customer_id,
    TO_DATE(order_date, 'YYYY-MM-DD') AS order_date,
    CAST(total_amount AS numeric) AS total_amount
from 
{{source('RAW','STG_ORDERS')}}