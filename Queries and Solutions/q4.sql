-- Identify the most common pizza size ordered.

select pizzas.size, count(order_details.order_deatils) as most_common from pizzas
join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by most_common desc
limit 1;