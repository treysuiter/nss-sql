-- Provide a way for the accounting team to track all financial transactions by creating a new table called Accounts Receivable. 
-- The table should have the following columns: 
-- credit_amount, debit_amount, date_received as well as a PK and a FK to associate a sale with each transaction.

create table accounts_receivable (
	accounts_receivable_id INT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
	credit_amount money,
	debit_amount money,
	date_received date,
	sale_id int,
	FOREIGN KEY (sale_id) REFERENCES sales (sale_id)
)

-- Set up a trigger on the Sales table. 
-- When a new row is added, add a new record to the Accounts Receivable table with the deposit as credit_amount, 
-- the timestamp as date_received and the appropriate sale_id.

create or replace function add_deposit_to_credit_amount()
	
	RETURNS TRIGGER 
	LANGUAGE PlPGSQL
AS $$
BEGIN

	insert into accounts_receivable (credit_amount, date_received, sale_id)
	values (new.deposit, current_date, new.sale_id);

	RETURN NULL;
END;
$$

create trigger deposit_to_credit_trigger
after insert
on sales
for each row
execute procedure add_deposit_to_credit_amount()

insert into sales (deposit)
values(10000)

select * from accounts_receivable order by accounts_receivable_id desc;

-- Set up a trigger on the Sales table for when the sale_returned flag is updated. 
-- Add a new row to the Accounts Receivable table with the deposit as debit_amount, the timestamp as date_received, etc.

CREATE OR REPLACE FUNCTION return_vehicle()
	returns trigger
	language plpgsql
AS $$
BEGIN
	IF new.returned IS true THEN
		INSERT INTO accounts_receivable(debit_amount, date_received, sale_id)
		VALUES (new.deposit, current_date, new.sale_id);
	END IF;
	
	RETURN NULL;
END;
$$
CREATE TRIGGER return_vehicle_trigger
	AFTER UPDATE
	ON sales
	FOR EACH ROW
	EXECUTE PROCEDURE return_vehicle();
	
UPDATE sales
SET returned = true
WHERE sale_id = 1008;
SELECT * FROM sales ORDER BY sale_id DESC;
SELECT * FROM accounts_receivable;

-- Help out HR fast track turnover by providing the following:

-- Create a stored procedure with a transaction to handle hiring a new employee. 
-- Add a new record for the employee in the Employees table and add a record to the 
-- Dealershipemployees table for the two dealerships the new employee will start at.

CREATE OR REPLACE PROCEDURE new_employee()
LANGUAGE plpgsql
AS $$
DECLARE
  NewEmployeeId integer;
  NewDealershipId integer = 2;
BEGIN
	INSERT INTO employees(first_name, last_name, email_address, phone, employee_type_id)
	VALUES('John', 'Hana', 'johnhana@gmail.com', '615-876-5243', 1)
	RETURNING employee_id INTO NewEmployeeId;
	
	INSERT INTO dealershipemployees(employee_id, dealership_id)
	VALUES(NewEmployeeId, NewDealershipId);
	
END
$$;
CALL new_employee();
SELECT * FROM employees
ORDER BY employee_id DESC
SELECT * FROM dealershipemployees
ORDER BY dealership_employee_id DESC

-- Create a stored procedure with a transaction to handle an employee leaving. 
-- The employee record is removed and all records associating the employee with dealerships must also be removed.

CREATE OR REPLACE PROCEDURE remove_employee(employeeId int)
	LANGUAGE PLPGSQL
	AS $$
BEGIN
	DELETE FROM dealershipemployees
	WHERE employee_id = employeeId;
	DELETE FROM employees
	WHERE employee_id = employeeId;
	
END;
$$
CALL remove_employee(1005);
-- Tests
SELECT * FROM employees ORDER BY employee_id DESC;
SELECT * FROM dealershipemployees ORDER BY dealership_employee_id DESC;