-- Create a trigger for when a new Sales record is added, set the purchase date to 3 days from the current date.

-- Example
-- CREATE FUNCTION set_pickup_date() 
--   RETURNS TRIGGER 
--   LANGUAGE PlPGSQL
-- AS $$
-- BEGIN
--   -- trigger function logic
--   UPDATE sales
--   SET pickup_date = NEW.purchase_date + integer '7'
--   WHERE sales.sale_id = NEW.sale_id;
  
--   RETURN NULL;
-- END;
-- $$

CREATE or replace FUNCTION set_purchase_date()
returns trigger
language PlPGSQL
as $$
begin
update sales
set purchase_date = current_date + integer '3'
where sales.sale_id = NEW.sale_id;
return null;
end;
$$

-- Example
-- CREATE TRIGGER new_sale_made
--   AFTER INSERT
--   ON sales
--   FOR EACH ROW
--   EXECUTE PROCEDURE set_pickup_date();

create trigger new_sale_made
after insert
on sales
for each row
execute procedure set_purchase_date()

insert into sales values
(default);

select * from sales order by sale_id desc;

-- Create a trigger for updates to the Sales table. 
-- If the pickup date is on or before the purchase date, set the pickup date to 7 days after the purchase date. 
-- If the pickup date is after the purchase date but less than 7 days out from the purchase date, add 4 additional days to the pickup date.

-- Example
-- if condition then
--   statements;
-- else
--   alternative-statements;
-- END if;

CREATE or replace FUNCTION set_pickup_date()
returns trigger
language PlPGSQL
as $$
begin
if new.pickup_date <= new.purchase_date then
new.pickup_date := new.purchase_date + integer '7';
elsif new.pickup_date > new.purchae_date and new.pickup_date < new.purchase_date + integer '7' then
new.pickup_date := new.pickup_date + integer '4';
end if;
return new;
end;
$$;

create trigger update_pickup_date
before update
on sales
for each row
execute procedure set_pickup_date();

-- drop trigger update_pickup_date on sales;


-- Because Carnival is a single company, we want to ensure that there is consistency in the data provided to the user. 
-- Each dealership has it's own website but we want to make sure the website URL are consistent and easy to remember. 
-- Therefore, any time a new dealership is added or an existing dealership is updated, 
-- we want to ensure that the website URL has the following format: http://www.carnivalcars.com/{name of the dealership with underscores separating words}.

CREATE OR REPLACE FUNCTION format_dealership_webiste() 
  RETURNS TRIGGER 
  LANGUAGE PlPGSQL
AS $$
BEGIN
-- 	NEW.website := CONCAT('http://www.carnivalcars.com/', REGEXP_REPLACE(LOWER(NEW.business_name), '( ){1,}', '_', 'g'));
	NEW.website := CONCAT('http://www.carnivalcars.com/', REPLACE(LOWER(NEW.business_name), ' ', '_'));
	
	RETURN NEW;
END;
$$

CREATE TRIGGER dealership_website
BEFORE INSERT OR UPDATE
ON dealerships
FOR EACH ROW EXECUTE PROCEDURE format_dealership_webiste();

-- If a phone number is not provided for a new dealership, set the phone number to the default customer care number 777-111-0305.

create or replace function set_default_dealer_phone()
returns trigger
language PlPGSQL
AS $$
begin
if new.phone is NULL then
update dealerships
set phone = '777-111-0305'
where dealership_id = new.dealership_id;
end if;
return null;
end;
$$

create trigger default_dealer_phone
after insert
on dealerships
for each row execute procedure set_default_dealer_phone();

-- drop trigger default_dealer_phone on dealerships;

insert into dealerships default values;

select * from dealerships order by dealership_id desc;

-- delete from dealerships
-- where dealership_id >= 1001;

-- For accounting purposes, the name of the state needs to be part of the dealership's tax id. 
-- For example, if the tax id provided is bv-832-2h-se8w for a dealership in Virginia, 
-- then it needs to be put into the database as bv-832-2h-se8w--virginia.

create or replace function set_concat_state_and_tax()
returns trigger
language PlPGSQL
AS $$
begin
update dealerships
set tax_id = concat(new.tax_id || '--' || new.state)
where dealership_id = new.dealership_id;
return null;
end;
$$

create trigger concat_state_and_tax
after insert
on dealerships
for each row execute procedure set_concat_state_and_tax();

insert into dealerships (state, tax_id) values ('Tennessee', 'yy-456-yt-1234')

select * from dealerships order by dealership_id desc;

