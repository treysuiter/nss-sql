-- Write a transaction to:
-- Add a new role for employees called Automotive Mechanic
-- Add five new mechanics, their data is up to you
-- Each new mechanic will be working at all three of these dealerships: Sollowaye Autos of New York, Hrishchenko Autos of New York and Cadreman Autos of New York


-- Create a transaction for:
-- Creating a new dealership in Washington, D.C. called Felphun Automotive
-- Hire 3 new employees for the new dealership: Sales Manager 3, General Manager 6 and Customer Service 4.
-- All employees that currently work at Scrogges Autos of District of Columbia will now start working at Felphun Automotive instead.

begin;

insert into dealerships (business_name, phone, city, state, website, tax_id)
values ('Felphun Automotive', '615-789-7890', 'Washington', 'D.C.', 'http://www.website.com', '45-dgfdg-56-dfg');

insert into employees (first_name, last_name, email_address, phone, employee_type_id)
values 
('jim', 'jam', 'jim@email.com', '789-789-7890', 3),
('jil', 'jones', 'jil@email.com', '456-456-2345', 6),
('jeff', 'jeorge', 'jeff#email.com', '123-123-1234', 4);

update dealershipemployees
set dealership_id = 1011
where dealership_id = 129;
		
commit;

select * from employees order by employee_id desc
select * from employeetypes;
select * from dealershipemployees where dealership_id = 129
select * from dealershipemployees where dealership_id = 1011

Write transactions to handle the following scenarios:

-- Adding 5 brand new 2021 Honda CR-Vs to the inventory. 
-- They have I4 engines and are classified as a Crossover SUV or CUV. 
-- All of them have beige interiors but the exterior colors are Lilac, Dark Red, Lime, Navy and Sand. 
-- The floor price is $21,755 and the MSR price is $18,999.

-- For the CX-5s and CX-9s in the inventory that have not been sold, change the year of the car to 2021 since we will be updating our stock of Mazdas. 
-- For all other unsold Mazdas, update the year to 2020. The newer Mazdas all have red and black interiors.

-- The vehicle with VIN YV4852CT5B1628541 has been brought in for servicing. 
-- Document that the service department did a tire change, windshield wiper fluid refill and an oil change.

insert into vehiclemakes (name)
values ('Honda')

insert into vehiclemodels (name)
values ('CR-V')

insert into vehicletypes (body_type_id, make_id, model_id)
values (4, 6, 17)

begin;

insert into vehicles (vin, engine_type, vehicle_type_id, exterior_color, interior_color, floor_price, msr_price, miles_count, year_of_car, is_sold, is_returned)
values
('4T1BD1EB3DU060460', 'I4', 31, 'Lilac', 'Beige', 21755, 18999, 0, 2021, False, False),
('1C4SDJCT7CC681186', 'I4', 31, 'Dark Red', 'Beige', 21755, 18999, 0, 2021, False, False),
('1FMCU9E79AK568497', 'I4', 31, 'Lime', 'Beige', 21755, 18999, 0, 2021, False, False),
('WUAUUAFG2CN452395', 'I4', 31, 'Navy', 'Beige', 21755, 18999, 0, 2021, False, False),
('19UUA9F27DA778812', 'I4', 31, 'Sand', 'Beige', 21755, 18999, 0, 2021, False, False);

commit;


select vm.name
from vehicletypes vt
join vehiclemakes vm on vm.vehicle_make_id = vt.make_id
group by vm.name

select * from vehicles order by vehicle_id desc
select * from vehiclemakes
select * from vehiclebodytypes
select * from vehiclemodels
select * from vehicletypes order by vehicle_type_id desc
