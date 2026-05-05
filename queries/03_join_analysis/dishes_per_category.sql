SELECT order_id, category, COUNT(item_id) AS num_items
FROM `restaurant-orders-494618.restaurant_db.order_details` AS od
INNER JOIN `restaurant-orders-494618.restaurant_db.menu_items` AS mi
 ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
WHERE order_id IN (440, 2075, 1957, 330, 2675)
 GROUP BY order_id, category