{{ config(
    materialized = 'incremental',
    pre_hook = "{{abac_job_start()}}",
  )
}}

{%set source_schema = 'RAW' %}
{%set source_table = 'MENU_STG_ITEMS'%}

select 
    item_id,
    item_name,
    item_category,
    CAST(item_price AS numeric) AS item_price,
    item_description
from 
{{source(source_schema , source_table)}}