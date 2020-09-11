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
if pickup_date <= purchase_date then
update sales
set pickup_date = purchase_date + integer '7'
where sales.sale_id = NEW.sale_id;
elsif pickup_date > purchae_date and pickup_date < purchase_date + integer '7' then
update sales
set pickup_date = purchase_date + integer '4'
where sales.sale_id = TG_ARGV[0];
end if;
return null;
end;
$$;

create trigger update_pickup_date
after update
on sales
for each row
execute procedure set_pickup_date(sale_id);

-- drop trigger update_pickup_date on sales;


select * from dealerships;