SELECT COUNT(*) FROM

(SELECT order_id, COUNT (item_id) AS num_items
FROM `restaurant-orders-494618.restaurant_db.order_details`
GROUP BY order_id
HAVING num_items > 12) AS num_ord