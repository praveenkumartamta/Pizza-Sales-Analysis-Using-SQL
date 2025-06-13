
1 --Retrieve the total number of orders placed.

select count(order_id) as Total_orders
from orders


2 -- Calculate the total revenue generated from pizza sales.

select 
round(sum(order_details.quantity * pizzas.price),2) as Total_revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id


3 -- Identify the highest-priced pizza.

select
pizza_types.name,pizzas.price as Highest_priced_pizza
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id 
order by price desc
limit 1


4 -- Identify the most common pizza size ordered.

select pizzas.size,order_details.order_id
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size,order_details.order_id
order by  pizzas.size,order_details.order_id desc
limit 1


5 -- List the top 5 most orderd pizza types along with their quantities.

select pizza_types.name ,sum(order_details.quantity)as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name
order by total_quantity desc
limit 5


6 -- Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category, sum(order_details.quantity) as total_quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category 
order by total_quantity desc



7 -- Determine the distribution of orders by hour of the day.

select extract(hour from time) as hour , count(order_id)  as order_count
from orders
group by hour
order by order_count desc


8 -- Join relevant tables to find the category-wise distribution of pizzas.

select category , count(name) as count_of_pizza_name
from pizza_types
group by category
order by count_of_pizza_name desc 


9 -- Group the orders by date and calculate the average number of pizzas ordered per day.


select round(avg(quantity),0)
from
  (select orders.date , sum(order_details.quantity) as quantity
   from orders join order_details
   on orders.order_id = order_details.order_id
   Group by orders.date)


10 -- Determine the top 3 most ordered pizza types based on revenue.

select pizza_types.name , 
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
Group by pizza_types.name
order by revenue desc
limit 3



11 -- Calculate the percentage contribution of each pizza type to total revenue.



select pizza_types.category,
round(sum(order_details.quantity * pizzas.price) /  (select sum(order_details.quantity * pizzas.price)
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id) * 100 ,2) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
Group by pizza_types.category
order by revenue desc



12 -- Analyze the cumulative revenue generated over time.

select date,
sum(dally_revenue) over(order by date)  as cumulative_revenue
from
(select orders.date ,
sum(order_details.quantity * pizzas.price) as dally_revenue
from orders join order_details
on orders.order_id = order_details.order_id
join pizzas
on pizzas.pizza_id = order_details.pizza_id
Group by orders.date)



13 -- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category, name , revenue, rn
from
(select category , name , revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.category,pizza_types.name,
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
Group by pizza_types.category,pizza_types.name)as a) as b
where rn<=3






























