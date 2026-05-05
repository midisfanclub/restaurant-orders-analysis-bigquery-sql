SELECT order_id, ROUND(SUM(mi.price), 2) AS total_spent
FROM `restaurant-orders-494618.restaurant_db.order_details` AS od
INNER JOIN `restaurant-orders-494618.restaurant_db.menu_items` AS mi
 ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
GROUP BY order_id
ORDER BY total_spent DESC 
LIMIT 5;