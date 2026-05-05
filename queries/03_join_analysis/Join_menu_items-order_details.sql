-- item_id (order_details) é STRING enquanto menu_item_id (menu_items) é INT64.
-- SAFE_CAST converte item_id para INT64 para permitir o JOIN entre as tabelas.
-- Usado SAFE_CAST ao invés de CAST pois a coluna contém valores inválidos, retornando NULL nesses casos ao invés de quebrar a query.

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
   ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id

