-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category, name, revenue
from
(
    select category, name, revenue,
           rank() over (partition by category order by revenue desc) as ranks
    from
    (
        select pizza_types.category,
               pizza_types.name,
               round(sum(order_details.quantity * pizzas.price), 2) as Revenue
        from pizza_types
        join pizzas
            on pizza_types.pizza_type_id = pizzas.pizza_type_id
        join order_details
            on pizzas.pizza_id = order_details.pizza_id
        group by pizza_types.category, pizza_types.name
    ) as a
) as b
where ranks <= 3;