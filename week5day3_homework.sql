-- 1. List all customers who live in Texas (use JOINs)
SELECT customer.first_name, customer.last_name, address.district
FROM address 
FULL JOIN customer
ON address.address_id = customer.address_id
WHERE address.district = 'Texas'
-- "Jennifer"	"Davis"	"Texas"
-- "Kim"	"Cruz"	"Texas"
-- "Richard"	"Mccrary"	"Texas"
-- "Bryan"	"Hardison"	"Texas"
-- "Ian"	"Still"	"Texas"
------5 total customers in TX-------------------------



-- 2. Get all payments above $6.99 with the Customer's Full Name
SELECT customer.first_name, customer.last_name, payment.amount
FROM customer
FULL JOIN payment
ON payment.customer_id = customer.customer_id
WHERE payment.amount > 6.99
ORDER BY payment.amount;
------1406 payments greater than $6.99 value ---------------



-- 3. Show all customers names who have made payments over $175(use subqueries)
--SubQur method
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	GROUP BY customer_id
	HAVING SUM(amount) > 175
	ORDER BY SUM(amount) DESC
)
GROUP BY customer_id;

-- "Clara"	"Shaw"
-- "Karl"	"Seal"
-- "Tommy"	"Collazo"
-- "Rhonda"	"Kennedy"
-- "Marion"	"Snyder"
-- "Eleanor"	"Hunt"

--Alternative FULL JOIN method... I like this bc sum price collumn can be included too
SELECT SUM(amount), first_name, last_name, payment.customer_id
FROM payment
FULL JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY first_name, last_name, payment.customer_id
HAVING SUM(amount) > 175
ORDER BY SUM(amount) DESC;
-------------------------------------------------------------------------------


-- 4. List all customers that live in Nepal (use the city table)
SELECT customer.first_name, last_name, country.country
FROM country
FULL JOIN city
ON country.country_id = city.country_id
FULL JOIN address
ON address.city_id = city.city_id
FULL JOIN customer
ON customer.address_id = address.address_id
WHERE country.country = 'Nepal';
--"Kevin"	"Schuler"	"Nepal"
--------------------------------------------------------------



-- 5. Which staff member had the most transactions?
SELECT COUNT(payment.payment_id),  staff.staff_id, staff.first_name
FROM staff
FULL JOIN payment
ON payment.staff_id = staff.staff_id
GROUP BY staff.staff_id;
------------Jon with 7,304------------------ 



-- 6. How many movies of each rating are there?
SELECT rating, COUNT(film_id)
FROM film
GROUP BY rating
ORDER BY rating;
-- "G"	178
-- "PG"	194
-- "PG-13"	223
-- "R"	195
-- "NC-17"	210
---------------------------------------------


-- 7.Show all customers who have made a single payment above $6.99 (Use Subqueries)
SELECT first_name, last_name, customer_id
FROM customer
WHERE customer_id IN (
	SELECT customer_id
	FROM payment
	WHERE amount > 6.99
	GROUP BY customer_id
	HAVING COUNT(customer_id) = 1
	)
ORDER BY customer_id DESC; 

-- tried FULL JOIN method too... can't get it to filter for only ppl with single > 6.99 payments :(
SELECT amount, payment_id, first_name, last_name, customer.customer_id --, COUNT(customer.customer_id)
FROM customer
FULL JOIN payment
ON customer.customer_id = payment.customer_id
GROUP BY first_name, last_name, customer.customer_id, payment_id, amount
HAVING amount > 6.99 --AND COUNT(customer.customer_id) = 1
ORDER BY customer_id DESC;
-----------------------------------------------------------------------------------------
	
	
-- 8. How many free rentals did our stores give away?
SELECT COUNT(payment_id)
FROM payment
WHERE amount = 0;
------24 freebees ----------------------------------
