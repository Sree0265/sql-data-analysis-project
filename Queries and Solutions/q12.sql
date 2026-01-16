-- Analyze the cumulative revenue generated over time.

select order_date,
       sum(revenue) over (order by order_date) as Cum_Revenue
from
(
    select orders.order_date,
           sum(order_details.quantity * pizzas.price) as Revenue
    from orders
    join order_details
        on orders.order_id = order_details.order_id
    join pizzas
        on order_details.pizza_id = pizzas.pizza_id
    group by orders.order_date
) as Sales;
