-- 1
SELECT p.part_number, p.part_name, SUM(s.qty) AS "quantity_sold"
FROM fact_sales s
JOIN dim_part p on s.part_id = p.part_id
GROUP BY p.part_number, p.part_name
ORDER BY "quantity_sold" DESC
LIMIT 10;

-- 2
SELECT b.branch_name, p.part_number, p.part_name, i.stock_on_hand, i.min_stock
FROM fact_inventory i
JOIN dim_branch b ON i.branch_id = b.branch_id
JOIN dim_part p on i.part_id = p.part_id
WHERE i.stock_on_hand < i.min_stock;

-- 3
SELECT 
s.sale_id, 
b.branch_name, 
p_main.part_number, 
i_main.stock_on_hand as "main_part_stock", 
p_alt.part_number,
i_alt.stock_on_hand as "alt_part_stock",
s.unit_price,
s.currency
FROM fact_sales s
JOIN dim_branch b ON s.branch_id = b.branch_id
JOIN dim_date d ON s.sale_date_id = d.date_id
JOIN dim_part p_main ON p_main.part_id = s.part_id
JOIN dim_part p_alt  ON p_alt.part_number = p_main.alt_part_number
JOIN fact_inventory i_main ON i_main.branch_id = s.branch_id 
                           AND i_main.part_id = s.part_id
JOIN fact_inventory i_alt  ON i_alt.branch_id = s.branch_id 
                           AND i_alt.part_id = p_alt.part_id
WHERE i_main.stock_on_hand = 0
	AND p_main.alt_part_number IS NOT NULL
	AND p_main.alt_part_number != '-'
	AND i_alt.stock_on_hand > 0
ORDER BY s.qty DESC, d.full_date DESC;


-- 4
SELECT 
    p.part_number,
    p.part_name,
    SUM(s.qty) AS demand
FROM fact_sales s
JOIN dim_part p ON s.part_id = p.part_id
GROUP BY p.part_id, p.part_number, p.part_name
ORDER BY part_number asc;

SELECT 
	p.part_number,
	SUM(i.stock_on_hand) as stock
FROM fact_inventory i
JOIN dim_part p ON p.part_id = i.part_id
GROUP BY p.part_number
ORDER BY part_number asc;

-- highest demand = GET-CE-210  order = 351 
-- demand = order - stock
-- demand = 351 - 264
-- demand = 87

SELECT b.branch_name, i.stock_on_hand
FROM fact_inventory i
JOIN dim_branch b ON b.branch_id = i.branch_id
JOIN dim_part p ON p.part_id = i.part_id
WHERE p.part_number = 'GET-CE-210'
ORDER BY i.stock_on_hand DESC
LIMIT 1;

