SELECT 
  od.order_id,
  od.order_date,
  od.order_time,
  od.item_id,
  mi.menu_item_id,
  mi.item_name,
  mi.category,
  mi.price
FROM `restaurant-orders-494618.restaurant_db.order_details` AS od
INNER JOIN `restaurant-orders-494618.restaurant_db.menu_items` AS mi
  ON mi.menu_item_id = SAFE_CAST(od.item_id AS INT64)
-- SAFE_CAST necessário pois item_id está como STRING na tabela order_details
