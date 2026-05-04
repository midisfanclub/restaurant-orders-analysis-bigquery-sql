SELECT category, COUNT(menu_item_id) AS num_dishes
FROM `restaurant-orders-494618.restaurant_db.menu_items`
GROUP BY category