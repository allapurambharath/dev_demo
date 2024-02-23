{{ config(
    materialized = 'table'
) }}


select 
    item_id,
    item_name,
    item_category,
    CAST(item_price AS numeric) AS item_price,
    item_description
from 
{{source('RAW','MENU_STG_ITEMS')}}