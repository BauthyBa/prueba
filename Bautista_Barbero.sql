#Consulta 1:

#Las funciones que no son validas son:
# SORT(), en MySQL se usa ORDER BY para ordenar, no existe SORT().

# TO_DATE(), en MySQL se usa STR_TO_DATE() ya que esta sirve para convertir 
# un texto (string) en un dato tipo fecha, siempre y cuando el texto tenga un formato válido.


#Consulta 2:

use sakila

select * from payment

select 
    concat(staff.first_name, ' ', staff.last_name) as nombre_empleado,
    count(payment.payment_id) as cantidad_pagos,
    sum(payment.amount) as monto_tot,
    min(payment.amount) as monto_min,
    max(payment.amount) AS monto_max,
    avg(payment.amount), 2 as promedio_pagos
from payment
join staff on payment.staff_id = staff.staff_id
group by staff.staff_id
order by monto_tot desc;

#Consulta 3:

select * from film


select 
    film.title as titulo_peli,
    count(distinct rental.customer_id) as clientes_unicos,
    count(rental.rental_id) as tot_alquileres
from film
join inventory on film.film_id = inventory.film_id
join rental on inventory.inventory_id = rental.inventory_id
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
where category.name not in ('Horror', 'Music')
group by film.film_id, film.title
having clientes_unicos = 5;


#Consulta 4:

select * from actor

select 
    actor.first_name AS Nombre,
    actor.last_name AS Apellido,
    film.title AS Pelicula
from actor 
join film_actor on actor.actor_id = film_actor.actor_id
join film on film_actor.film_id = film.film_id
where film.replacement_cost > (select avg(replacement_cost) 
    						   from film)
and length(actor.first_name) != 5;

#Consulta 5:

select 
    f.title,
    f.rental_duration,
    count(r.rental_id) as total_alquileres
from film f
join inventory i on f.film_id = i.film_id
left join rental r on i.inventory_id = r.inventory_id
where f.rental_duration < all (select f2.rental_duration
    						   from film f2
    						   join film_category fc2 on f2.film_id = fc2.film_id
    						   join category c2 on fc2.category_id = c2.category_id
    						   where c2.name = 'Documentary')
and f.film_id not in (select i2.film_id
    				  from inventory i2
    				  join rental r2 on i2.inventory_id = r2.inventory_id
   					  where r2.rental_date >= curdate() - interval 3 month)
group by f.film_id, f.title, f.rental_duration;








