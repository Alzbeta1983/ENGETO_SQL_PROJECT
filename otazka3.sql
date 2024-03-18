WITH table_4 AS (
    SELECT 
	code,
	food,
	payroll_year,
	avg_value_food,
	CASE 
		WHEN payroll_year = '2006' THEN 0
		ELSE avg_value_food - LAG(avg_value_food, 1) OVER (ORDER BY food, payroll_year)
	END AS previous_avg_price
FROM t_Alzbeta_Marikova_project_SQL_primary_final
WHERE code <> 212101
GROUP BY code, payroll_year
ORDER BY food, payroll_year
)
SELECT 
	code,
	food,
	payroll_year,
	avg_value_food,
	previous_avg_price,
	SUM(previous_avg_price) OVER (PARTITION BY food) AS price_increase
	FROM table_4
	GROUP BY food, payroll_year
	ORDER BY price_increase, payroll_year ;
