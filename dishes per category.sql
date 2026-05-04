SELECT category, COUNT(item_id) AS dishes_per_category
FROM `restaurant-orders-494618.restaurant_db.order_details` AS od
INNER JOIN `restaurant-orders-494618.restaurant_db.menu_items` AS mi
 ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
 WHERE order_id = 440
 GROUP BY category