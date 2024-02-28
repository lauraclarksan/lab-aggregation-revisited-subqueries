-- Lab 4 Unit 6

/* 
Write the SQL queries to answer the following questions:

1. Select the first name, last name, and email address of all the customers who have rented a movie.

2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

3. Select the name and email address of all the customers who have rented the "Action" movies:

 - Write the query using multiple join statements
 - Write the query using sub queries with multiple WHERE clause and IN condition
 - Verify if the above two queries produce the same results or not
 
4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, then it should be high.
*/

-- 1. Select the first name, last name, and email address of all the customers who have rented a movie.
 
select a.first_name, a.last_name, a.email from sakila.customer as a
 join sakila.rental as b
 on a.customer_id = b.customer_id
 group by a.customer_id;

-- 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).

select b.customer_id, concat(a.first_name, ' ', a.last_name) as customer_name, avg(c.amount) as average_payment from sakila.customer as a
join sakila.rental as b
on a.customer_id = b.customer_id
join sakila.payment as c
on b.customer_id = c.customer_id
group by b.customer_id, customer_name;

-- 3. Select the name and email address of all the customers who have rented the "Action" movies:

-- A) Write the query using multiple join statements

select a.first_name, a.last_name, a.email from sakila.customer as a
join sakila.rental as b
on a.customer_id = b.customer_id
join sakila.inventory as c
on b.inventory_id = c.inventory_id
join sakila.film_category as d
on c.film_id = d.film_id
where d.category_id = 1 -- category_id for Action movies is 1
group by a.customer_id;

-- B) Write the query using sub queries with multiple WHERE clause and IN condition

select first_name, last_name, email
from sakila.customer
where customer_id in (
    select distinct a.customer_id
    from sakila.rental as a
    where inventory_id in (
        select distinct b.inventory_id
        from sakila.inventory as b
        where film_id in (
            select film_id
            from sakila.film_category
            where category_id = 1
        )
    )
);

-- C) Verify if the above two queries produce the same results or not? It does produce the same result

/* 4.  Use the case statement to create a new column classifying existing columns as either or high value transactions based 
on the amount of payment. If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label 
should be medium, and if it is more than 4, then it should be high
*/

select payment_id, amount,
case 
when amount between 0 and 2 then 'Low'
when amount between 2 and 4 then 'Medium'
when amount > 4 then 'High'
else 'Unknown'
end as payment_label
from sakila.payment;