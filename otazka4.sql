WITH table_5 AS (
    SELECT 
        payroll_year,
        ROUND(AVG(avg_value_food), 6) AS avg_avg_value_food,
        CASE 
            WHEN payroll_year = '2006' THEN 0
            ELSE ROUND(AVG(avg_value_food), 6) - LAG(ROUND(AVG(avg_value_food), 6), 1) OVER (ORDER BY food, payroll_year)
        END AS avg_previous_avg_price,
        ROUND(AVG(avg_value), 6) AS avg_avg_value,
        CASE 
            WHEN payroll_year = '2006' THEN 0
            ELSE ROUND(AVG(avg_value), 6) - LAG(ROUND(AVG(avg_value), 6), 1) OVER (ORDER BY food, payroll_year)
        END AS avg_previous_avg_value,
        (ROUND(AVG(avg_value_food), 6) - LAG(ROUND(AVG(avg_value_food), 6), 1) OVER (ORDER BY payroll_year)) / LAG(ROUND(AVG(avg_value_food), 6), 1) OVER (ORDER BY payroll_year) * 100 AS percentage_increase_avg_avg_value_food,
        (ROUND(AVG(avg_value), 6) - LAG(ROUND(AVG(avg_value), 6), 1) OVER (ORDER BY payroll_year)) / LAG(ROUND(AVG(avg_value), 6), 1) OVER (ORDER BY payroll_year) * 100 AS percentage_increase_avg_avg_value
    FROM t_Alzbeta_Marikova_project_SQL_primary_final
    GROUP BY payroll_year
)
SELECT 
    payroll_year,
    avg_avg_value_food,
    avg_previous_avg_price,
    avg_avg_value,
    avg_previous_avg_value,
    percentage_increase_avg_avg_value_food,
    percentage_increase_avg_avg_value,
    percentage_increase_avg_avg_value_food - percentage_increase_avg_avg_value AS result
FROM table_5;