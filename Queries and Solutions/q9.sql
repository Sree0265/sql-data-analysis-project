-- Group the orders by date and calculate the average number of pizzas ordered per day.

select avg(Average_number_of_Pizzas)
from
(
    select orders.order_date,
           sum(order_details.quantity) as Average_number_of_Pizzas
    from orders
    join order_details
        on orders.order_id = order_details.order_id
    group by orders.order_date
) as B;