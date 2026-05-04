SELECT category, ROUND(AVG(price), 2) AS avg_price
FROM restaurant_db.menu_items AS M
GROUP BY category

