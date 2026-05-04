SELECT 
  order_date,
  FORMAT_DATE('%A', order_date) AS day_of_week,
  COUNT(DISTINCT od.order_id) AS num_orders,
  ROUND(SUM(mi.price) / COUNT(DISTINCT od.order_id), 2) AS avg_ticket_per_order
FROM `restaurant-orders-494618.restaurant_db.order_details` AS od
INNER JOIN `restaurant-orders-494618.restaurant_db.menu_items` AS mi
  ON SAFE_CAST(od.item_id AS INT64) = mi.menu_item_id
GROUP BY order_date, day_of_week
ORDER BY num_orders DESC