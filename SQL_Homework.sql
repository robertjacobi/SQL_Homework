USE sakila;

-- Display First Name and Last Name --
Select first_name, last_name
from sakila.actor
;
-- Display First and Last name as Actor --
Select concat(first_name,' ', last_name) as 'Actor'
from sakila.actor
;
-- Find the ID number, first name, and last name of actor whom first LIKE Joe
Select actor_id, first_name, last_name
from sakila.actor
where first_name like 'Joe'
;
-- Find all Actors whose last name conatain the letters GEN
Select actor_id, first_name, last_name
from sakila.actor
where last_name like '%GEN%'
;
-- Find all Actors whose last name  conatin the letters LI ORDER rows lastname, firstname
select last_name, first_name
from sakila.actor
where last_name like '%LI%'
;
-- Using IN, display country_id and country columns for the following countries: afghanistan, Bangladesh, and China

Select country_id, country
from sakila.country
where country in (
	'Afghanisatan',
    'Bangladesh',
    'China')
 ;
 -- Create column in Actor called description dtype blob  --
 Alter table Sakila.Actor
 ADD Column Description BLOB
 ;
 -- Delete Description Column --
 Alter Table Sakila.Actor
 Drop Description
 ;
 -- List the last name of actors and count the last names --
 Select last_name, count(last_name)
 from sakila.actor
 group by last_name
 ;
 -- List last names of actors and the number of actors who have that last name, but only for the names that are shared by at least two actors --
 Select last_name, count(last_name) as 'CNT'
 from sakila.actor
 group by last_name
 having cnt > 1
 ;
 -- Change Groucho Williams to Harpo Wiliams in Actor Table --
 Update Sakila.Actor
	Set first_name = 'HARPO'
 
 WHERE first_name = 'GROUCHO'
 AND last_name = 'Williams'
 ;
-- If first name actor is Harpo change it to Groucho --
 Update Sakila.Actor
	Set first_name = 'GROUCHO'
 
 WHERE first_name = 'HARPO'
 AND last_name = 'Williams'
 ;
 -- Locate Address Schema --
 Show Create Table Sakila.address
 ;
 -- Use JOIN to show firstname, lastname, address, of each staff member: staff and address tables
 Select s.first_name, s.last_name, a.address
 from sakila.staff s
 JOIN sakila.address a ON s.address_id = a.address_id
;
-- Display Total amount rung up by each staff member in Aug 2005. STAFF and PAYMENT
 select s.first_name, s.last_name, sum(p.amount) 
 from sakila.staff s
 JOIN sakila.payment p on s.staff_id = p.staff_id
 group by s.last_name
 ;
 -- List each film  and the number of actors who are listed for that film: film_actor and film
 select f.title, count(distinct fa.actor_id)
 from sakila.film f
 JOIN sakila.film_actor fa ON f.film_id = fa.film_id
 Group by f.title
 ;
 -- How many copies of the film Hunchback Impossible exits in the inventory system --
 select count(i.inventory_id) as 'Number of Copies', f.title
 from sakila.inventory i
 Join sakila.film f on i.film_id = f.film_id
 Where f.title = 'Hunchback Impossible'
 ;
 -- using tables payment and customer and the JOIN command, list total paid by each customer listed alphabetically by last name
 select c.first_name, c.last_name, sum(p.amount) as 'total paid'
 from sakila.customer c
 JOIN sakila.payment p on c.customer_id = p.Customer_id
 group by c.last_name
 order by c.last_name asc
 ;
 -- Use suqueries to display the titles of movies starting with the letters K and Q whose language is English
 Select title
 FROM Sakila.Film
 Where title IN (
	
    Select title
    FROM Sakila.Film
	Where (title like 'K%' OR title like 'Q%')
    AND language_id IN (
		
        Select language_id
		FROM sakila.`language`
		WHERE `name` = 'English' ) )
;
-- use subqueries to dislay all actors who appear in the film Alone Trip
Select first_name, Last_name
FROM Sakila.actor
where actor_id IN (
	
    Select Actor_id
    FROM sakila.film_actor
    where film_id IN (
		
        Select film_id
        FROM sakila.film
        where title = 'Alone Trip' ) )
;
-- Names and Email addresses of all Canadian Customers
Select concat(cu.first_name, ' ', cu.last_name) as 'Customer_Name', cu.email
FROM Sakila.customer cu
JOIN sakila.address a on cu.address_id = a.address_id
JOIN sakila.city ci on a.city_id = ci.city_id
JOIN sakila.country co on ci.country_id = co.country_id
WHERE co.country = 'Canada'
;
-- All movies categorized as Family
SELECT *
FROM Sakila.film f
JOIN Sakila.film_category c on f.film_id=c.film_id
JOIN Sakila.category ca on c.category_id=ca.category_id
WHERE ca.name = 'Family'
;
-- display most frequent movies in decending order
SELECT title, rental_rate
FROM sakila.film
ORDER BY rental_rate desc
;
-- Display how much business in dollars each store brought in
SELECT s.store_id, SUM(p.amount) as 'total'
FROM Sakila.store s
JOIN Sakila.customer c on s.store_id=c.store_id
JOIN Sakila.payment p on c.customer_id=p.customer_id
GROUP BY s.store_id
;
-- store id, city, and country
SELECT s.store_id, c.city, co.country
FROM Sakila.Store s
JOIN Sakila.address a on s.address_id=a.address_id
JOIN Sakila.city c on a.city_id=c.city_id
JOIN Sakila.country co on  c.country_id=co.country_id
;
-- top 5 generes in gross revenue in desc order
SELECT c.`name`, sum(p.amount) as 'Total'
FROM Sakila.Category c
JOIN Sakila.Film_Category fc on c.category_id=fc.category_id
JOIN Sakila.inventory i on fc.film_id=i.film_id
JOIN Sakila.rental r on i.inventory_id=r.inventory_id
JOIN Sakila.payment p on r.rental_id=p.rental_id
GROUP BY c.`name`
ORDER BY Total desc
LIMIT 5
;
-- Create view for top 5 genres -------------
Create View sakila.VIEW_TOPGENRES AS
SELECT c.`name`, sum(p.amount) as 'Total'
FROM Sakila.Category c
JOIN Sakila.Film_Category fc on c.category_id=fc.category_id
JOIN Sakila.inventory i on fc.film_id=i.film_id
JOIN Sakila.rental r on i.inventory_id=r.inventory_id
JOIN Sakila.payment p on r.rental_id=p.rental_id
GROUP BY c.`name`
ORDER BY Total desc
LIMIT 5
;
-- display new view ---------------------------------
SELECT *
FROM sakila.view_topgenres
;
-- delete view -------
DROP VIEW if exists  Sakila.view_topgenres
;


