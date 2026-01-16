use dominos;

-- Retrieve the total number of orders placed.

		select count(order_id) as total_orders_placed from orders;

-- Calculate the total revenue generated from pizza sales.

		select round(sum(order_details.quantity * pizzas.price),0) as Total_revenue from order_details
		inner join pizzas
		on order_details.pizza_id = pizzas.pizza_id;
    
-- Identify the highest-priced pizza.

		select pizza_types.name, pizzas.price from pizza_types
		inner join pizzas
		on pizza_types.pizza_type_id = pizzas.pizza_type_id
		order by price desc
		limit 1;
    
-- Identify the most common pizza size ordered.

		select pizzas.size, count(order_details.order_deatils) as most_common from pizzas
		join order_details
		on pizzas.pizza_id = order_details.pizza_id
		group by pizzas.size
		order by most_common desc
		limit 1;
    
-- List the top 5 most ordered pizza types along with their quantities.

		select pizza_types.name,sum(order_details.quantity) as quantity from pizza_types
		inner join pizzas
		on pizza_types.pizza_type_id= pizzas.pizza_type_id
		inner join order_details
		on pizzas.pizza_id = order_details.pizza_id
		group by pizza_types.name
		order by quantity desc
		limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.

		select pizza_types.category,
			   sum(order_details.quantity) as Quantity
		from pizza_types
		join pizzas
			on pizza_types.pizza_type_id = pizzas.pizza_type_id
		join order_details
			on pizzas.pizza_id = order_details.pizza_id
		group by pizza_types.category
		order by Quantity desc;

-- Determine the distribution of orders by hour of the day.

		select hour(order_time),
			   count(order_id)
		from orders
		group by hour(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.

		select category,
			   count(name)
		from pizza_types
		group by category;

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

-- Determine the top 3 most ordered pizza types based on revenue.

		select pizza_types.name as Names,
			   sum(order_details.quantity * pizzas.price) as Revenue
		from pizza_types
		join pizzas
			on pizzas.pizza_type_id = pizza_types.pizza_type_id
		join order_details
			on order_details.pizza_id = pizzas.pizza_id
		group by Names
		order by Revenue desc
		limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.

		select pizza_types.category as Category,
			   round(
				   sum(order_details.quantity * pizzas.price) /
				   (select round(sum(order_details.quantity * pizzas.price))
					from order_details
					join pizzas
						on pizzas.pizza_id = order_details.pizza_id
				   ) * 100, 2
			   ) as Total
		from pizza_types
		join pizzas
			on pizza_types.pizza_type_id = pizzas.pizza_type_id
		join order_details
			on pizzas.pizza_id = order_details.pizza_id
		group by Category;

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