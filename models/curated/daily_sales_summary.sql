
{{ config(
    materialized = 'table'
) }}

SELECT 
    order_date,
    COUNT(DISTINCT order_id) AS total_orders,
    SUM(total_amount) AS total_sales
FROM 
    {{ref('order_details')}}
GROUP BY 
    order_date