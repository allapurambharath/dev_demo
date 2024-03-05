{{ config(
    materialized = 'incremental',
    pre_hook = "{{abac_job_start()}}",
  )
}}

select 
    item_id,
    item_name,
    item_category,
    CAST(item_price AS numeric) AS item_price,
    item_description
from 
{{source('RAW','MENU_STG_ITEMS')}}