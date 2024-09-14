create database pizzahut;

use pizzahut;

create table orders(
order_id int not null, 
order_date date not null,
order_time time not null, 
primary key(order_id));

create table orders(
order_id int not null, 
order_date date not null,
order_time time not null, 
primary key(order_id));

create table orders(
order_id int not null, 
order_date date not null,
order_time time not null, 
primary key(order_id));

-- Retrieve the total number of orders placed.
select count(order_id) from orders; 

-- ************************************************************************************************************
-- Calculate the total revenue generated from pizza sales.
SELECT round(sum(order_details.quantity * pizzas.price),2) AS total_sales
FROM order_details JOIN pizzas 
ON pizzas.pizza_id = order_details.pizza_id;

-- ************************************************************************************************************
-- Identify the highest-priced pizza. 
select pizza_types.name, pizzas.price
from pizza_types join pizzas
on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc limit 1; 

-- ************************************************************************************************************
-- Identify the most common pizza size ordered.
SELECT pizzas.size, COUNT(order_details.order_details_id) AS order_count
FROM pizzas
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC limit 1;

-- ************************************************************************************************************
-- List the top 5 most ordered pizza types 
-- along with their quantities.

select pizza_types.name, sum(order_details.quantity) as quantity
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join
order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.name order by quantity desc limit 5;


-- ************************************************************************************************************
-- Intermediate:-- 
-- ************************************************************************************************************

-- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) as quantity
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join
order_details
on order_details.pizza_id=pizzas.pizza_id
group by pizza_types.category;

-- ************************************************************************************************************
-- Determine the distribution of orders by hour of the day.
select hour(order_time) as hour, count(order_id) as order_count from orders
group by hour(order_time);

-- ************************************************************************************************************
-- Join relevant tables to find the category-wise distribution of pizzas.
select category, count(name)
from pizza_types
group by category; 

-- ************************************************************************************************************
-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round(avg(quantity),0) from (select orders.order_date, sum(order_details.quantity) as quantity from 
orders join order_details
on orders.order_id= order_details.order_id
group by orders.order_date) as order_avg;

-- ************************************************************************************************************
-- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name, order_details.quantity*pizzas.price as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join 
order_details
on order_details.pizza_id = pizzas.pizza_id
order by revenue desc limit 3;

-- ************************************************************************************************************
-- Advanced:
-- ************************************************************************************************************

-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT pizza_types.category, 
       round(SUM(order_details.quantity * pizzas.price) * 100 / 
       (SELECT SUM(order_details.quantity * pizzas.price)
        FROM order_details 
        JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id),2) AS revenue_percentage
FROM pizza_types JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category;

-- ************************************************************************************************************
-- Analyze the cumulative revenue generated over time.
-- eg.
-- 200 200
-- 300 500
-- 400 900
-- 500 1400

select order_date,  
sum(revenue) over (ORDER BY order_date) as cum_revenue
from
(select orders.order_date, sum(order_details.quantity*pizzas.price) as revenue
from order_details join orders
on order_details.order_id = orders.order_id
join pizzas
on pizzas.pizza_id = order_details.pizza_id
group by orders.order_date) as table1;


-- ************************************************************************************************************
-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select  name, revenue
from
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category, pizza_types.name, 
sum(order_details.quantity*pizzas.price) as revenue
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on pizzas.pizza_id = order_details.pizza_id 
group by pizza_types.category, pizza_types.name) as t2) as t2
where rn<=3;
