use sakila;

-- CHALLENGE --

-- 1. Determine the number of copies of the film "Hunchback Impossible" that exist in the inventory system.
select count(*) as copies_hunchback_impossible
from inventory
where film_id in (select film_id from film where film.title = 'Hunchback Impossible');

-- 2. List all films whose length is longer than the average length of all the films in the Sakila database.
select title, length
from film
where length > (select avg(length) from film);

-- 3. Use a subquery to display all actors who appear in the film "Alone Trip".
select actor.first_name, actor.last_name
from actor
where actor_id in (select actor_id from film_actor where film_id in
(select film_id from film where title = 'Alone Trip'));


-- BONUS --

-- 4. Sales have been lagging among young families, and you want to target family movies for a promotion. 
-- Identify all movies categorized as family films.

select film.film_id, 
film.title,
(select name from category where category_id = 
(select category_id from film_category where film_category.film_id = film.film_id)) as category_name
from film
where film_id in (select film_id
from film_category
where category_id = (select category_id
from category
where name = 'Family'));

-- 5. Retrieve the name and email of customers from Canada using both subqueries and joins. To use joins, you will need to identify the relevant tables and their primary and foreign keys.

select
first_name,
last_name,
email,
'Canada' as country
from customer
where address_id in (select address_id from address
where city_id in (select city_id from city
where country_id in (select country_id from country
where country = 'Canada')))

or customer.customer_id in 
(select customer_id from customer
join address
	on customer.address_id = address.address_id
join city
	on address.city_id = city.city_id
join country
	on city.country_id = country.country_id
where country.country = 'Canada');

-- 6. Determine which films were starred by the most prolific actor in the Sakila database. A prolific actor is defined as the actor who has acted in the most number of films. First, you will need to find the most prolific actor and then use that actor_id to find the different films that he or she starred in.

-- find the most prolific actor:
select actor_id,
count(*) as film_count
from film_actor
group by actor_id
order by film_count DESC
limit 1;

-- use that actor_id to find the different films that he or she starred in:

select film.title as film_title
from film
join film_actor 
	on film.film_id = film_actor.film_id
where film_actor.actor_id = (select actor_id
from film_actor
group by actor_id
order by count(*) desc
limit 1);

-- 7. Find the films rented by the most profitable customer in the Sakila database. You can use the customer and payment tables to find the most profitable customer, i.e., the customer who has made the largest sum of payments.

-- identify the most profitable customer:

select
customer_id,
sum(amount) as total_payments
from payment
group by customer_id
order by total_payments DESC
limit 1;

-- find the films rented by the most profitable customer:


-- 8. Retrieve the client_id and the total_amount_spent of those clients who spent more than the average of the total_amount spent by each client. You can use subqueries to accomplish this.





