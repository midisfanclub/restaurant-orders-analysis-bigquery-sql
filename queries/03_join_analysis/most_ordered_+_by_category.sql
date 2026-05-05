SELECT mi.item_name, mi.category, price, COUNT(order_details_id) AS num_purchases
FROM `restaurant-orders-494618.restaurant_db.order_details` AS od
INNER JOIN `restaurant-orders-494618.restaurant_db.menu_items` AS mi
 ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
GROUP BY category, price, item_name
ORDER BY num_purchases DESC
