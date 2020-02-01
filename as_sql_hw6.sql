use sakila;

-- line for referencing tables
select *
from address;

-- 1.a
select first_name, last_name
from actor;

-- 1.b
select concat(first_name, " ", last_name) as Actor_Name
from actor;

-- 2.a
select actor_id, first_name, last_name
from actor
where first_name = 'Joe';

-- 2.b NOTE: I assume the instructions mean any last names containing any
-- 	combinations of the letters "G", "E", and "N". (Not a single "GEN")
-- 	If the instructions mean a single "GEN" the code is below the 1st block.
select *
from actor
where last_name like ('%G%')
	and last_name like ('%E%')
	and last_name like ('%N%');

select *
from actor
where last_name like ('%GEN%');

-- 2.c NOTE: same situation as above^ (2.b)
select *
from actor
where last_name like ('%L%')
	and last_name like ('%I%')
order by last_name, first_name;

select *
from actor
where last_name like ('%LI%')
order by last_name, first_name;

-- 2.d
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3.a
alter table actor
add column description blob; 

-- 3.b
alter table actor
drop column description;

-- 4.a
select last_name, count(last_name) as count
from actor
group by last_name;

-- 4.b
select last_name, count(last_name) as count
from actor
group by last_name
having count >= 2
order by count desc;

-- 4.c
select actor_id, first_name, last_name
from actor
where first_name = 'Groucho' 
and last_name = 'Williams';

update actor
set first_name = 'HARPO'
where actor_id = 172;

-- 4.d
update actor
set first_name = 'GROUCHO'
where actor_id = 172;

-- 5.a
show create table address;

-- 6.a
select first_name, last_name, address
from staff
join address
on staff.address_id = address.address_id;

-- 6.b
select first_name, last_name, sum(amount) as total_amount
from staff
join payment
on staff.staff_id = payment.staff_id
group by first_name, last_name
order by total_amount desc;

-- 6.c
select title, count(actor_id) as actor_count
from film
inner join film_actor
on film.film_id = film_actor.film_id
group by title;

-- 6.d *There are 6 copies of "Hunchback Impossible"
select title, count(inventory.film_id) as film_count
from film
join inventory
on film.film_id = inventory.film_id
where film.title = "Hunchback Impossible"
group by title;

-- 6.e 
select first_name, last_name, sum(amount) as total_paid
from customer
join payment
on customer.customer_id = payment.customer_id
group by first_name, last_name
order by last_name;

-- 7.a
select title, name as language
from film
join language
on film.language_id = language.language_id
where (title LIKE 'K%' OR title LIKE 'Q%')
and name = 'English'
group by title;

-- 7.b
select first_name, last_name
from actor
where actor_id in 
	(select actor_id 
	from film_actor 
    where film_id in 
		(select film_id 
        from film 
        where title = 'Alone Trip'));

-- 7.c
select first_name, last_name, email
from customer
join address
on customer.address_id = address.address_id
where city_id in
	(select city_id
    from city
    join country
    on city.country_id = country.country_id
    where country.country = 'Canada');

-- 7.d 
select title
from film
join film_category
on film.film_id = film_category.film_id
where category_id in
	(select category_id
    from category
    where name = 'Family');
    
-- 7.e *I think this is correct?
select title, count(inventory.inventory_id) as rental_count
from film
join inventory
on film.film_id = inventory.film_id
where inventory.inventory_id in
	(select inventory.inventory_id
    from inventory
    join rental
    on inventory.inventory_id = rental.inventory_id)
group by title
order by count(inventory.inventory_id) desc;

-- 7.f
select staff.store_id as store, sum(payment.amount) as net_profit
from payment
join staff
on payment.staff_id = staff.staff_id
where staff.store_id in 
	(select staff.store_id
    from staff
    join store
    on staff.store_id = store.store_id)
group by staff.store_id;

-- 7.g
select store.store_id as store, city.city as city, country.country as country
from store
	join address
		on store.address_id = address.address_id
	join city 
		on address.city_id = city.city_id
	join country
		on city.country_id = country.country_id
group by store.store_id;

-- 7.h
select category.name as category, sum(payment.amount) as gross_revenue
from category
	join film_category
		on category.category_id = film_category.category_id
	join inventory
		on film_category.film_id = inventory.film_id
	join rental
		on inventory.inventory_id = rental.inventory_id
	join payment
		on rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5;

-- 8.a
create view top_five_genres as
	select category.name as category, sum(payment.amount) as gross_revenue
from category
	join film_category
		on category.category_id = film_category.category_id
	join inventory
		on film_category.film_id = inventory.film_id
	join rental
		on inventory.inventory_id = rental.inventory_id
	join payment
		on rental.rental_id = payment.rental_id
group by category.name
order by sum(payment.amount) desc
limit 5;

-- 8.b
select *
from top_five_genres;

-- 8.c
drop view top_five_genres;