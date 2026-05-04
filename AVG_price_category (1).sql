SELECT category, AVG(price) AS avg_price
FROM restaurant_db.menu_items AS M
GROUP BY category

