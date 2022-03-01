use magist;
select count(order_id)
from orders;
select count(*)
from orders;

select order_status, count(order_status)
from orders
group by order_status;

select year(order_purchase_timestamp) as year, month(order_purchase_timestamp) as month, count(order_id)
from orders
group by year, month
order by year, month;

select *
from products;

select count(distinct product_id)
from products;

select count(product_id), count(distinct product_id), product_category_name
from products
group by product_category_name
order by count(product_id) desc;

select count(distinct product_id)
from order_items;

select max(price), min(price)
from order_items;

select max(payment_value), min(payment_value)
from order_payments;