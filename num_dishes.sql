SELECT category, Count(*) AS num_dishes
FROM restaurant_db.menu_items AS M
GROUP BY category
