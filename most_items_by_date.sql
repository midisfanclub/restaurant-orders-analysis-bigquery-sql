SELECT order_date, COUNT (order_id) AS num_orders
FROM `restaurant-orders-494618.restaurant_db.order_details`
GROUP BY order_date
ORDER BY num_orders DESC


--SELECT order_date, COUNT (order_id) AS num_orders
--FROM `restaurant-orders-494618.restaurant_db.order_details`
--GROUP BY order_date
--ORDER BY num_orders DESC

