USE sakila;

SET SQL_SAFE_UPDATES = 0;

#1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name FROM actor;

#1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT CONCAT(first_name, " ", last_name) as "Actor Name" FROM actor;

#2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name FROM actor WHERE first_name = "Joe";

#2b. Find all actors whose last name contain the letters GEN:
SELECT * FROM actor WHERE last_name LIKE "%GEN%";

#2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name FROM actor WHERE last_name LIKE "%LI%" ORDER BY last_name, first_name;

#2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country FROM country WHERE country IN ("Afghanistan", "Bangladesh", "China");

#3a. create a column in the table actor named description and use the data type BLOB.
ALTER TABLE actor
ADD description BLOB;

#3b. Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

#4a. List the last names of actors, as well as how many actors have that last name.
SELECT COUNT(last_name), last_name FROM actor GROUP BY last_name;

#4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT COUNT(last_name), last_name FROM actor GROUP BY last_name HAVING (COUNT(last_name)) >= 2;

#4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.
UPDATE actor SET first_name = "HARPO" WHERE first_name = "GROUCHO";

#4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct name after all! In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.
UPDATE actor SET first_name = "GROUCHO" WHERE first_name = "HARPO";

#5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

#6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address:
SELECT first_name, last_name, address FROM staff INNER JOIN address on address.address_id = staff.address_id;

#6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment.
SELECT first_name, last_name, SUM(amount) as "Total Amount Rung (Aug 2005)" FROM payment INNER JOIN staff ON staff.staff_id = payment.staff_id AND payment.payment_date LIKE "%2005-08%" GROUP BY staff.first_name;

#6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join.
SELECT film.title, COUNT(actor_id) as "Number of Actors" FROM film INNER JOIN film_actor ON film.film_id = film_actor.film_id GROUP BY film.title ORDER BY COUNT(actor_id) Desc;

#6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT COUNT(film_id) FROM inventory WHERE film_id = (SELECT film_id FROM film WHERE title = "Hunchback Impossible");

#6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount) FROM customer INNER JOIN payment ON customer.customer_id = payment.customer_id GROUP BY customer.customer_id ORDER BY customer.last_name;

#7a. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title FROM film WHERE title LIKE "K%" OR title LIKE "Q%" AND language_id = (SELECT language_id FROM language WHERE name = "English");

#7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name FROM actor WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = (SELECT film_id FROM film WHERE title = "Alone Trip"));

#7c. ...you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT first_name, last_name, email, country FROM customer INNER JOIN address ON address.address_id = customer.address_id INNER JOIN city ON city.city_id = address.city_id INNER JOIN country ON country.country_id = city.country_id WHERE country = "Canada";

#7d. Identify all movies categorized as family films.
SELECT title, name FROM film INNER JOIN film_category ON film_category.film_id = film.film_id INNER JOIN category ON film_category.category_id = category.category_id WHERE name = "Family";

#7e. Display the most frequently rented movies in descending order.
SELECT COUNT(title) as "Rents", title as "Movie"  FROM rental INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id INNER JOIN film ON inventory.film_id = film.film_id GROUP BY title ORDER BY COUNT(title) DESC;

#7f. Write a query to display how much business, in dollars, each store brought in.
SELECT CONCAT("$", CAST( SUM(amount) AS CHAR)) as "Gross", store_id as "Store" FROM payment INNER JOIN rental ON rental.rental_id = payment.rental_id INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id GROUP BY inventory.store_id;

#7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city, country FROM store INNER JOIN address ON address.address_id = store.address_id INNER JOIN city ON address.city_id = city.city_id INNER JOIN country ON country.country_id = city.country_id;

#7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT name AS "Genre", CONCAT("$", CAST( SUM(amount) AS CHAR)) as "Gross" FROM payment INNER JOIN rental ON payment.rental_id = rental.rental_id INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id INNER JOIN film_category ON inventory.film_id = film_category.film_id INNER JOIN category ON film_category.category_id = category.category_id GROUP BY category.name ORDER BY SUM(amount) DESC LIMIT 5;

#8a. Use the solution from the problem above to create a view.
CREATE VIEW top_five_genres AS SELECT name AS "Genre", CONCAT("$", CAST( SUM(amount) AS CHAR)) as "Gross" FROM payment INNER JOIN rental ON payment.rental_id = rental.rental_id INNER JOIN inventory ON rental.inventory_id = inventory.inventory_id INNER JOIN film_category ON inventory.film_id = film_category.film_id INNER JOIN category ON film_category.category_id = category.category_id GROUP BY category.name ORDER BY SUM(amount) DESC LIMIT 5;

#8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres;

#8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres;