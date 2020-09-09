-- Get a list of sales records where the sale was a lease.
-- Get a list of sales where the purchase date is within the last two years.
-- Get a list of sales where the deposit was above 5000 or the customer payed with American Express.
-- Get a list of employees whose first names start with "M" or ends with "E".
-- Get a list of employees whose phone numbers have the 600 area code.

select * from sales
select *
from sales
where sales_type_id = 2;

select *
from sales
where purchase_date >= '2018-09-01'
order by purchase_date;

select deposit, payment_method
from sales
where deposit > 5000 or payment_method='americanexpress'
order by deposit;

select c.first_name
from customers c
where first_name like 'M%' or first_name like '%e';

select *
from employees
where phone like '600%';

select * from employees;

