explain analyze SELECT * from Employees WHERE employee_type_id = 1;

create index idx_emp_type_id on employees
(
	employee_type_id
);

explain analyze SELECT * from Sales WHERE dealership_id = 500;

create index idx_dship_id on sales
(
	dealership_id
);


explain analyze SELECT * from customers WHERE state = 'CA';

create index idx_cust_state on customers
(
	state
);

explain analyze SELECT * from vehicles where year_of_car BETWEEN 2018 AND 2020;

create index idx_car_year on vehicles 
(
	year_of_car
);

explain analyze SELECT * from vehicles where floor_price < 30000;

create index idx_floor_price on vehicles
(
	floor_price
);

drop index idx_floor_price;