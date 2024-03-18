SELECT 
	industry_branch_code 
	,payroll_year 
	,name 
	,avg_value
	,food 
	,avg_value_food 
	,price_value 
	,price_unit 
	,CASE
		WHEN code ='114201'
		THEN round (avg_value/avg_value_food,2)
		WHEN code = '111301'
		THEN round (avg_value/avg_value_food,2)
		ELSE null
	END AS amount_purchased
FROM	t_Alzbeta_Marikova_project_SQL_primary_final tampspf 
WHERE (code='114201' OR code='111301')
ORDER BY industry_branch_code, payroll_year, food;
