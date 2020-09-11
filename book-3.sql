-- Practice: Employees
-- Rheta Raymen an employee of Carnival has asked to be transferred to a different dealership location. 
-- She is currently at dealership 751. She would like to work at dealership 20. Update her record to reflect her transfer.

update dealershipemployees
set dealership_id = 20
where dealership_id = 751 and employee_id = (select e.employee_id from employees e where e.last_name = 'Raymen' and e.first_name = 'Rheta')

select * from dealershipemployees where employee_id = (select e.employee_id from employees e where e.last_name = 'Raymen' and e.first_name = 'Rheta')

-- Practice: Sales
-- A Sales associate needs to update a sales record because her customer want so pay wish Mastercard instead of American Express. 
-- Update Customer, Layla Igglesden Sales record which has an invoice number of 2781047589.

select * from sales where invoice_number = '2781047589';

update sales
set payment_method = 'mastercard'
where invoice_number = '2781047589';

-- A sales employee at carnival creates a new sales record for a sale they are trying to close. 
-- The customer, last minute decided not to purchase the vehicle. 
-- Help delete the Sales record with an invoice number of '7628231837'.

select * from sales WHERE sales.invoice_number = '7628231837';

DELETE FROM sales WHERE sales.invoice_number = '7628231837';

-- An employee was recently fired so we must delete them from our database. 
-- Delete the employee with employee_id of 35. What problems might you run into when deleting? 
-- How would you recommend fixing it?

select * from employees where employee_id = '35'

delete from employees
where employee_id='35'

--I would not perform this delete. Maybe possibly create another employee type for employees who no longer work here?

-- Stored Procedures Practice
-- Carnival would like to use stored procedures to process valuable business logic surrounding their business. 
-- Since they understand that procedures can hold many SQL statements related to a specific task they think it will work perfectly for their current problem.

-- Inventory Management

-- Selling a Vehicle
-- Carnival would like to create a stored procedure that handles the case of updating their vehicle inventory when a sale occurs. 
-- They plan to do this by flagging the vehicle as is_sold which is a field on the Vehicles table. 
-- When set to True this flag will indicate that the vehicle is no longer available in the inventory. 
-- Why not delete this vehicle? We don't want to delete it because it is attached to a sales record.

-- alter table vehicles
-- add column is_sold boolean;

CREATE or replace PROCEDURE mark_sold(this_vehicle int)
LANGUAGE plpgsql
AS $$
BEGIN

update vehicles
set is_sold = True
where vehicles.vehicle_id = this_vehicle;

commit;

END;
$$;

call mark_sold(1)

select * from vehicles where vehicles.vehicle_id = 1;

-- Returning a Vehicle
-- Carnival would also like to handle the case for when a car gets returned by a customer. 
-- When this occurs they must add the car back to the inventory and mark the original sales record as returned = True.

-- alter table vehicles
-- add column is_returned boolean;

CREATE or replace PROCEDURE mark_returned(this_vehicle int)
LANGUAGE plpgsql
AS $$
BEGIN

update vehicles
set is_returned = True
where vehicles.vehicle_id = this_vehicle;

commit;

END;
$$;

call mark_returned(1)

select * from vehicles where vehicles.vehicle_id = 1;

-- Carnival staff are required to do an oil change on the returned car before putting it back on the sales floor. 
-- In our stored procedure, we must also log the oil change within the OilChangeLog table.

  
-- create table OilChangeLog (
--   oil_change_log_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
--   vehicle_id INT,
--   olid_change_date date,
--   FOREIGN KEY (vehicle_id) REFERENCES vehicles (vehicle_id)
-- );

CREATE or replace PROCEDURE oil_change(this_vehicle int)
LANGUAGE plpgsql
AS $$
BEGIN

insert into oilchangelog(vehicle_id, olid_change_date)
values (this_vehicle, current_date);

commit;

END;
$$;

call oil_change(33);
select * from oilchangelog;

-- Goals
-- Use the story above and extract the requirements.
-- Build two stored procedures for Selling a car and Returning a car. Be ready to share with your class or instructor your result.



