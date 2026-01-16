-- Calculate the total revenue generated from pizza sales.

select round(sum(order_details.quantity * pizzas.price),0) as Total_revenue from order_details
inner join pizzas
on order_details.pizza_id = pizzas.pizza_id;