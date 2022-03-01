USE magist;

# number of product categories (is 74):
SELECT COUNT(*) FROM product_category_name_translation;

# list of all product categories:
SELECT product_category_name, product_category_name_english FROM product_category_name_translation
ORDER BY product_category_name_english;

# number of products sold (is 32 951):
select count(distinct product_id) from products;

# total number of orders (is 99441):
SELECT COUNT(DISTINCT order_id) FROM orders;

# total of orders, regardless of its size (is 98 666):
SELECT COUNT(DISTINCT order_id) FROM order_items;

# total number of ordered items (is 112 650):
SELECT COUNT(order_item_id) FROM order_items;
SELECT COUNT(order_id) FROM order_items;
SELECT COUNT(*) FROM order_items;

# is 99441!:
SELECT COUNT(order_id) FROM orders;
SELECT COUNT(DISTINCT order_id) FROM orders;
SELECT COUNT(*) FROM orders;

# number of times a product from each category was ordered:
SELECT t.product_category_name_english, COUNT(oi.order_item_id)
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY 2 DESC;

# categories for which no order exists (is 0):
SELECT t.product_category_name_english
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE oi.order_item_id IS NULL
GROUP BY t.product_category_name_english;

# total number of tech category orders (is 15342):
SELECT COUNT(order_item_id)
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IN ("pcs", "informatica_acessorios", "eletronicos", "telefonia");

# average price of all orders (is 120.65):
SELECT AVG(price) FROM order_items;

# average price for which products from each category were ordered:
SELECT t.product_category_name_english, ROUND(AVG(price), 2)
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY t.product_category_name_english;

# per category: number of orders and average price:
SELECT t.product_category_name_english,
	COUNT(oi.order_item_id),
    ROUND(AVG(price), 2)
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
GROUP BY t.product_category_name_english
ORDER BY t.product_category_name_english;

# average, max, min price of all orders in tech categories
# computers (is 1098.34 // 6729 // 34.5)
# computers_accessories (is 116.51 // 3699.99 // 3.9)
# electronics (is 57.91 // 2470.5 // 3.99)
# pc_gamer (is 171.77 // 239 // 129.99)
# telephony (is 71.21 // 2428 // 5)
SELECT t.product_category_name_english, ROUND(AVG(oi.price), 2), MAX(oi.price), MIN(oi.price)
FROM order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE t.product_category_name_english IN ("computers", "computers_accessories", "electronics", "pc_gamer", "telephony")
GROUP BY t.product_category_name_english;

select t.product_category_name_english,
    oi.price,
    count(oi.order_id)
from order_items oi
LEFT JOIN products p ON oi.product_id = p.product_id
LEFT JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE t.product_category_name_english IN ("computers", "computers_accessories", "electronics", "telephony")
group by t.product_category_name_english, oi.price;

# are expensive tech products popular?
SELECT t.product_category_name_english,
    CASE
		WHEN oi.price > 4400 AND t.product_category_name_english = "computers" THEN "1_very high"
        WHEN oi.price > 2200 AND t.product_category_name_english = "computers" THEN "2_high"
        WHEN oi.price >= 1098.34 AND t.product_category_name_english = "computers" THEN "3_above average"
        WHEN oi.price < 1098.34 AND t.product_category_name_english = "computers" THEN "4_below average"
        
        WHEN oi.price > 466 AND t.product_category_name_english = "computers_accessories" THEN "1_very high"
        WHEN oi.price > 233 AND t.product_category_name_english = "computers_accessories" THEN "2_high"
        WHEN oi.price >= 116.51 AND t.product_category_name_english = "computers_accessories" THEN "3_above average"
        WHEN oi.price < 116.51 AND t.product_category_name_english = "computers_accessories" THEN "4_below average"
        
        WHEN oi.price > 232 AND t.product_category_name_english = "electronics" THEN "1_very high"
        WHEN oi.price > 116 AND t.product_category_name_english = "electronics" THEN "2_high"
        WHEN oi.price >= 57.91 AND t.product_category_name_english = "electronics" THEN "3_above average"
        WHEN oi.price < 57.91 AND t.product_category_name_english = "electronics" THEN "4_below average"
        
        WHEN oi.price > 284 AND t.product_category_name_english = "telephony" THEN "1_very high"
        WHEN oi.price > 142 AND t.product_category_name_english = "telephony" THEN "2_high"
        WHEN oi.price >= 71.21 AND t.product_category_name_english = "telephony" THEN "3_above average"
        WHEN oi.price < 71.21 AND t.product_category_name_english = "telephony" THEN "4_below average"
	END AS price_category,
    COUNT(order_item_id),
    ROUND(SUM(oi.price), 2) AS turnover
FROM order_items oi
INNER JOIN products p ON oi.product_id = p.product_id
INNER JOIN product_category_name_translation t ON p.product_category_name = t.product_category_name
WHERE p.product_category_name IN ("pcs", "informatica_acessorios", "eletronicos", "telefonia")
GROUP BY t.product_category_name_english, price_category
ORDER BY t.product_category_name_english, price_category;

# number of sellers (is 3095):
SELECT COUNT(distinct seller_id) FROM sellers;

# number of tech sellers (is 444):
SELECT COUNT(distinct s.seller_id)
FROM sellers s
inner join order_items oi on s.seller_id = oi.seller_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IN ("pcs", "informatica_acessorios", "eletronicos", "telefonia");

# total revenues per month:
SELECT YEAR(o.order_purchase_timestamp) AS year, MONTH(o.order_purchase_timestamp) AS month, ROUND(SUM(oi.price), 2) AS revenue
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp)
ORDER BY YEAR(o.order_purchase_timestamp), MONTH(o.order_purchase_timestamp);

# number of months:
SELECT COUNT(*)
FROM
	(SELECT DISTINCT YEAR(order_purchase_timestamp), MONTH(order_purchase_timestamp)
	FROM orders) AS _count;

# number of active sellers per month:
SELECT YEAR(o.order_purchase_timestamp) AS _year, MONTH(o.order_purchase_timestamp) AS _month, COUNT(oi.seller_id)
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY _year, _month
ORDER BY _year, _month;

# monthly revenue per seller:
SELECT YEAR(o.order_purchase_timestamp) AS _year,
	MONTH(o.order_purchase_timestamp) AS _month,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT oi.seller_id) AS total_active_sellers,
    COUNT(oi.order_item_id) AS total_orders,
    ROUND((SUM(oi.price)/COUNT(DISTINCT oi.seller_id)), 2) AS revenue_per_seller
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY _year, _month
ORDER BY _year, _month;

# turnover per tech seller and month:
select YEAR(o.order_purchase_timestamp) AS _year,
	MONTH(o.order_purchase_timestamp) AS _month,
    oi.seller_id,
    sum(oi.price) as sum_per_seller_month
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IN ("pcs", "informatica_acessorios", "eletronicos", "telefonia")
GROUP BY _year, _month, oi.seller_id
ORDER BY _year, _month, oi.seller_id;

select _year,
	_month,
    max(sum_per_seller_month) as max_per_month
from (select YEAR(o.order_purchase_timestamp) AS _year,
	MONTH(o.order_purchase_timestamp) AS _month,
    oi.seller_id,
    sum(oi.price) as sum_per_seller_month
	FROM orders o
	INNER JOIN order_items oi ON o.order_id = oi.order_id
    INNER JOIN products p ON oi.product_id = p.product_id
	WHERE p.product_category_name IN ("pcs", "informatica_acessorios", "eletronicos", "telefonia")
	GROUP BY _year, _month, oi.seller_id
	ORDER BY _year, _month, oi.seller_id)
as biggest_seller_per_month
GROUP BY _year, _month
ORDER BY _year, _month;
	

# average monthly revenue per seller (is 701.72):
SELECT ROUND(AVG(revenue_per_seller), 2)
FROM
	(SELECT YEAR(o.order_purchase_timestamp) AS _year,
	MONTH(o.order_purchase_timestamp) AS _month,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT oi.seller_id) AS total_active_sellers,
    COUNT(oi.order_item_id) AS total_orders,
    ROUND((SUM(oi.price)/COUNT(DISTINCT oi.seller_id)), 2) AS revenue_per_seller
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY _year, _month
ORDER BY _year, _month)
AS monthly_avg_per_seller;

# monthly revenue per tech seller:
SELECT YEAR(o.order_purchase_timestamp) AS _year,
	MONTH(o.order_purchase_timestamp) AS _month,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT oi.seller_id) AS total_active_sellers,
    COUNT(oi.order_item_id) AS total_orders,
    ROUND((SUM(oi.price)/COUNT(DISTINCT oi.seller_id)), 2) AS revenue_per_seller
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IN ("pcs", "informatica_acessorios", "eletronicos", "telefonia")
GROUP BY _year, _month
ORDER BY _year, _month;

# average monthly revenue per tech seller (is 678.42):
SELECT ROUND(AVG(revenue_per_seller), 2)
FROM
	(SELECT YEAR(o.order_purchase_timestamp) AS _year,
	MONTH(o.order_purchase_timestamp) AS _month,
    ROUND(SUM(oi.price), 2) AS total_revenue,
    COUNT(DISTINCT oi.seller_id) AS total_active_sellers,
    COUNT(oi.order_item_id) AS total_orders,
    ROUND((SUM(oi.price)/COUNT(DISTINCT oi.seller_id)), 2) AS revenue_per_seller
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE p.product_category_name IN ("pcs", "informatica_acessorios", "eletronicos", "telefonia")
GROUP BY _year, _month
ORDER BY _year, _month)
AS monthly_avg_revenue_tech;

# largest order (21 items)
SELECT MAX(order_item_id) FROM order_items;

# overview of order sizes:
SELECT order_item_id, COUNT(order_item_id) FROM order_items
GROUP BY order_item_id
ORDER BY 2;



# different values in order_status and frequency:
SELECT DISTINCT order_status, COUNT(order_status) FROM orders
GROUP BY order_status
ORDER BY 2 DESC;

# overview of time between order placement and delivery:
SELECT order_id,
	order_status,
    order_purchase_timestamp,
    order_delivered_customer_date,
    TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) AS delivery_time
FROM orders
WHERE order_status = "delivered"
ORDER BY delivery_time DESC;

# average time between order placement and delivery (is 12.0960 in days):
SELECT AVG(TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date)) AS avg FROM orders;

# average time between order placement and delivery (is 300.9438 in hours):
SELECT AVG(TIMESTAMPDIFF(HOUR, order_purchase_timestamp, order_delivered_customer_date)) AS avg FROM orders;

# categories of delivery times:
SELECT order_id,
	CASE
		WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 1 THEN "express"
        WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 3 THEN "fast"
        WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 5 THEN "ok"
        WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 7 THEN "long"
        ELSE "delayed"
	END AS "delivery_duration"
FROM orders
WHERE order_status = "delivered";

# overview of delivery duration in categories:
SELECT
	CASE
		WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 1 THEN "express"
        WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 3 THEN "fast"
        WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 5 THEN "ok"
        WHEN TIMESTAMPDIFF(DAY, order_purchase_timestamp, order_delivered_customer_date) <= 7 THEN "long"
        ELSE "delayed"
	END AS "delivery_duration",
    COUNT(order_id)
FROM orders
WHERE order_status = "delivered"
GROUP BY delivery_duration
ORDER BY COUNT(order_id);

# delivered within estimated time vs. delayed (91.9% vs 8.1%):
SELECT
	CASE
		WHEN order_delivered_customer_date <= order_estimated_delivery_date THEN "in time"
        ELSE "delayed"
	END AS "delivery_duration",
    COUNT(order_id)
FROM orders
WHERE order_status = "delivered"
GROUP BY delivery_duration
ORDER BY COUNT(order_id);

# delivered tech products within estimated time vs. delayed (91.7% vs 8.3%):
SELECT
	CASE
		WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN "in time"
        ELSE "delayed"
	END AS "delivery_duration",
    COUNT(o.order_id)
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE order_status = "delivered" and p.product_category_name IN ("pcs", "informatica_acessorios", "eletronicos", "telefonia")
GROUP BY delivery_duration
ORDER BY COUNT(o.order_id);

# delivery rates across product:
SELECT oi.product_id,
	CASE
		WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN "in time"
        ELSE "delayed"
	END AS "delivery_duration",
    COUNT(o.order_id)
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = "delivered"
GROUP BY oi.product_id, delivery_duration
ORDER BY delivery_duration, oi.product_id;

# delivery rates across product weight:
SELECT p.product_weight_g,
	CASE
		WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN "in time"
        ELSE "delayed"
	END AS "delivery_duration",
    COUNT(o.order_id)
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = "delivered"
GROUP BY p.product_weight_g, delivery_duration
ORDER BY delivery_duration, p.product_weight_g;

# delivery rates across product length:
SELECT p.product_length_cm,
	CASE
		WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN "in time"
        ELSE "delayed"
	END AS "delivery_duration",
    COUNT(o.order_id)
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
WHERE o.order_status = "delivered"
GROUP BY p.product_length_cm, delivery_duration
ORDER BY delivery_duration, p.product_length_cm;

# delivery rates across price:
SELECT oi.price,
	CASE
		WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN "in time"
        ELSE "delayed"
	END AS "delivery_duration",
    COUNT(o.order_id)
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = "delivered"
GROUP BY oi.price, delivery_duration
ORDER BY delivery_duration, oi.price;

# delivery rates across seller:
SELECT oi.seller_id,
	CASE
		WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN "in time"
        ELSE "delayed"
	END AS "delivery_duration",
    COUNT(o.order_id)
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = "delivered"
GROUP BY oi.seller_id, delivery_duration
ORDER BY delivery_duration, oi.seller_id, COUNT(o.order_id) desc;

# delivery rates across customer:
SELECT o.customer_id,
	CASE
		WHEN o.order_delivered_customer_date <= o.order_estimated_delivery_date THEN "in time"
        ELSE "delayed"
	END AS "delivery_duration",
    COUNT(o.order_id)
FROM orders o
INNER JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = "delivered"
GROUP BY o.customer_id, delivery_duration
ORDER BY delivery_duration, o.customer_id;

# delivery rates across order size (number of order items):

	

# list of order ids, each with respective number of items:
select order_id, count(order_item_id) as count_orders
from order_items
group by order_id
order by count(order_item_id) desc;

select count_orders, count(order_id)
from (
	select order_id, count(order_item_id) as count_orders
	from order_items
	group by order_id
	order by count(order_item_id) desc)
as order_size_frequency
group by count_orders;

SELECT * FROM order_items
WHERE order_item_id > 1
ORDER BY order_id;