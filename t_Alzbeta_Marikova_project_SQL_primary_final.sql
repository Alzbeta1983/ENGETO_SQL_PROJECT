CREATE OR REPLACE TABLE t_Alzbeta_Marikova_project_SQL_primary_final AS
WITH table_1 AS (
    SELECT 
       cp.industry_branch_code
       ,cp.payroll_year 
       ,cpib.name
       ,ROUND(AVG(cp.value), 2) AS avg_value
    FROM czechia_payroll cp
    JOIN czechia_payroll_industry_branch cpib ON cp.industry_branch_code = cpib.code
    WHERE value_type_code = '5958' AND industry_branch_code IS NOT NULL AND payroll_year BETWEEN 2006 AND 2018
    GROUP BY industry_branch_code, payroll_year
),
table_2 AS (
    SELECT 
       extract(YEAR FROM date_from) AS year_price
       ,cp.date_from
       ,cpc.code
       ,cpc.name AS food
       ,cpc.price_value
       ,cpc.price_unit
       ,ROUND(AVG(cp.value), 6) AS avg_value_food
    FROM czechia_price_category cpc
    JOIN czechia_price cp ON cpc.code = cp.category_code 
    GROUP BY code, year_price
    ORDER BY year_price, food
),
table_3 AS (
    SELECT 
        e.year
        ,e.GDP
    FROM economies e
    WHERE country = 'Czech Republic' AND year BETWEEN 2006 AND 2018
    GROUP BY year
)
SELECT 
    table_1.industry_branch_code
    ,table_1.payroll_year 
    ,table_1.name
    ,table_1.avg_value 
    ,table_2.code
    ,table_2.food 
    ,table_2.price_value
    ,table_2.price_unit
    ,table_2.avg_value_food 
    ,table_3.GDP
FROM table_1
JOIN table_2 ON table_1.payroll_year = table_2.year_price
JOIN table_3 ON table_1.payroll_year = table_3.year
ORDER BY industry_branch_code, payroll_year, table_2.food;