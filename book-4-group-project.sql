-- Times (normalized tables w/ joins)
-- Pl: 0.355
-- Ex: 2.343

EXPLAIN ANALYZE SELECT 
	v.msr_price, vbt.name bodytype, 
	vma.name make, vmo.name model 
FROM vehicles v
JOIN vehicletypes vt on v.vehicle_type_id = vt.vehicle_type_id
JOIN vehiclebodytypes vbt 
ON vt.body_type_id = vbt.vehicle_body_type_id
JOIN vehiclemakes vma
ON vt.make_id = vma.vehicle_make_id
JOIN vehiclemodels vmo
ON vt.model_id = vmo.vehicle_model_id
WHERE msr_price > 15000
ORDER BY msr_price;

-- CREATE TABLE denormvehicletypes AS SELECT vbt.name bodytype, vma.name make, vmo.name model 
-- FROM vehicletypes vt 
-- JOIN vehiclebodytypes vbt 
-- ON vt.body_type_id = vbt.vehicle_body_type_id
-- JOIN vehiclemakes vma
-- ON vt.make_id = vma.vehicle_make_id
-- JOIN vehiclemodels vmo
-- ON vt.model_id = vmo.vehicle_model_id;

-- ALTER TABLE denormvehicletypes ADD COLUMN vehicle_type_id SERIAL PRIMARY KEY;
-- select * from denormvehicletypes;

-- ALTER TABLE vehicles
-- DROP CONSTRAINT vehicles_vehicle_type_id_fkey;
-- ALTER TABLE vehicles 
-- ADD CONSTRAINT vehicles_vehicle_type_id_fkey 
-- FOREIGN KEY (vehicle_type_id) 
-- REFERENCES denormvehicletypes (vehicle_type_id);

-- Times (denormalized tables no joins)
-- PT: 0.219 ms
-- ET: 1.9 ms
-- PT: 0.143 ms
-- ET: 1.127 ms

EXPLAIN ANALYZE SELECT v.msr_price,  dvt.*
FROM vehicles v
JOIN denormvehicletypes dvt
ON v.vehicle_type_id = dvt.vehicle_type_id
WHERE v.msr_price > 15000
ORDER BY msr_price;


--get sales per dealership for given month in current year (needs to be a view)
CREATE or REPLACE function get_sales_per_dhsip_for_month(my_month int) RETURNS table (name varchar, total numeric)
LANGUAGE plpgsql
AS $$
BEGIN
RETURN QUERY
SELECT d.business_name, sum(s.price) as monthly_sales
FROM dealerships d
JOIN sales s on d.dealership_id = s.dealership_id
WHERE EXTRACT(MONTH FROM s.purchase_date) = my_month AND EXTRACT(YEAR FROM s.purchase_date) = EXTRACT(YEAR FROM CURRENT_DATE)
GROUP BY d.business_name
ORDER BY monthly_sales DESC;

END
$$;


select * from get_sales_per_dhsip_for_month(6);


