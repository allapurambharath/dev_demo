{{ config(
    materialized = 'table'
) }}

with orders as 
(
    select 
    order_id,
    order_date,
    total_amount
    from 
    {{ref('orders')}}
),
menu_items as 
(
    select 
    item_id,
    item_name,
    item_category,
    item_price,
    item_description
    from 
    {{ref('menu_items')}}
)
SELECT 
    orders.order_id,
    orders.order_date,
    menu_items.item_name,
    menu_items.item_category,
    menu_items.item_price,
    menu_items.item_description,
    orders.total_amount
FROM 
    orders 
inner JOIN 
    menu_items  ON orders.order_id = menu_items.item_id
