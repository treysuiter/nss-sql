--Write a query that shows the total purchase sales income per dealership.

select d.business_name, SUM(s.price) as total_sales
from dealerships d
inner join sales s
on d.dealership_id = s.dealership_id
group by d.business_name
order by total_sales;

--Write a query that shows the purchase sales income per dealership for the current year.

select d.business_name, SUM(s.price) as total_sales_this_year
from dealerships d
inner join sales s
on d.dealership_id = s.dealership_id
where EXTRACT(YEAR from s.purchase_date) = EXTRACT(YEAR from CURRENT_DATE)
group by d.business_name
order by d.business_name;

--Which model of vehicle has the lowest/highest current inventory? This will help dealerships know which models the purchase from manufacturers.

select vm.name, COUNT(v.vehicle_id) AS total_inv
from vehiclemodels vm
inner join vehicletypes vt on vt.model_id = vehicle_model_id
inner join vehicles v on v.vehicle_type_id = vt.vehicle_type_id
where vm.vehicle_model_id = vt.model_id
group by vm.name
order by total_inv desc limit 1;

select count(v.vehicle_id)
from vehicles v
inner join vehicletypes vt on v.vehicle_type_id = vt.vehicle_type_id
inner join vehiclemodels vm on vm.vehicle_model_id = vt.model_id
where vm.name = 'Atlas'

--Which dealerships are currently selling the least number of vehicle models? This will let dealerships market vehicle models more effectively per region.

-- select d.business_name, count (vt.vehicle_type_id) as model_toal
-- from dealerships d
-- inner join vehicles v on d.dealership_id = v.dealership_id
-- inner join vehicletypes vt on v.vehicle_types_id = vt.vehicle_types_id;

SELECT d.business_name, COUNT(v.vehicle_type_id) as num_of_models
FROM Dealerships d
JOIN Sales s ON d.dealership_id = s.dealership_id
JOIN Vehicles v ON s.vehicle_id = v.vehicle_id
GROUP BY d.business_name
ORDER BY num_of_models;

-- How many emloyees are there for each role?
-- How many finance managers work at each dealership?
-- Get the names of the top 3 employees who work shifts at the most dealerships?
-- Get a report on the top two employees who has made the most sales through leasing vehicles.

select et.name, count(e.employee_type_id) as total
from employeetypes et
join employees e on et.employee_type_id = e.employee_type_id
where et.name = 'Finance Manager'
group by et.name;

select d.business_name, count(et.name) as total
from dealerships d
join dealershipemployees de on d.dealership_id = de.dealership_id
join employees em on em.employee_id = de.employee_id
join employeetypes et on et.employee_type_id = em.employee_type_id
where et.name = 'Finance Manager'
group by d.business_name
order by total desc;

select em.last_name, count(de.dealership_id) as total
from employees em
join dealershipemployees de on em.employee_id = de.employee_id
where em.employee_id = de.employee_id
group by em.last_name
order by total desc limit 3;

select em.last_name, sum(s.price) as total
from employees em
join sales s on s.employee_id = em.employee_id and s.sales_type_id = 2
group by em.last_name
order by total desc limit 2;

-- What are the top 5 US states with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
-- What are the top 5 US zipcodes with the most customers who have purchased a vehicle from a dealership participating in the Carnival platform?
-- What are the top 5 dealerships with the most customers?


select d.state, count(c.customer_id) as total
from dealerships d
join sales s on s.dealership_id = d.dealership_id
join customers c on c.customer_id = s.customer_id
group by d.state
order by total desc limit 5;

select c.zipcode, count(c.customer_id) as total
from customers c
join sales s on c.customer_id = s.customer_id
group by c.zipcode
order by total desc limit 5;

select d.business_name, count(c.customer_id) as total_cust
from dealerships d
join sales s on s.dealership_id = d.dealership_id
join customers c on c.customer_id = s.customer_id
group by d.business_name
order by total_cust desc limit 5;

--make these work with CTE

