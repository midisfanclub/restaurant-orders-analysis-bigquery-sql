SELECT MIN(order_date) AS first_order, MAX(order_date) AS last_order
FROM `restaurant-orders-494618.restaurant_db.order_details`
