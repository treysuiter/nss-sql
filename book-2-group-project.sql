-- Best Sellers
-- Who are the top 5 employees for generating sales income?

select concat(e.first_name || ' ' || e.last_name) as name, sum(s.price) as total_sales
from employees e
join sales s on s.employee_id = e.employee_id
group by name
order by total_sales desc
limit 5
;

-- Who are the top 5 dealership for generating sales income?

select d.business_name as dealership, sum(s.price) as total_sales
from dealerships d
join sales s on d.dealership_id = s.dealership_id
group by dealership
order by total_sales desc
limit 5;

-- Which vehicle model generated the most sales income?

select vm.name as model_name, sum(s.price) as total_sales
from vehiclemodels vm
join vehicletypes vt on vt.model_id = vm.vehicle_model_id
join vehicles v on v.vehicle_type_id = vt.vehicle_type_id
join sales s on s.vehicle_id = v.vehicle_id
group by model_name
order by total_sales desc
limit 1;

-- Top Performance
-- Which employees generate the most income per dealership?

select d.dealership_id, d.business_name as dealership, sum(s.price) as total_sales, concat(e.first_name || ' ' || e.last_name) as employee
from dealerships d
join dealershipemployees de on de.dealership_id = d.dealership_id
join employees e on e.employee_id = de.employee_id
join sales s on s.employee_id = e.employee_id
group by dealership, d.dealership_id, employee
;




-- Vehicle Reports
-- Inventory
-- In our Vehicle inventory, show the count of each Model that is in stock.
-- In our Vehicle inventory, show the count of each Make that is in stock.
-- In our Vehicle inventory, show the count of each BodyType that is in stock.

-- Which US state's customers have the highest average purchase price for a vehicle?
-- Now using the data determined above, which 5 states have the customers with the highest average purchase price for a vehicle?