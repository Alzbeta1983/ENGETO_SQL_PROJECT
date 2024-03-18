CREATE TABLE t_Alzbeta_Marikova_project_SQL_secondary_final AS
SELECT 
    e.YEAR AS year, 	
    e.country,
    e.GDP,
    e.gini,
    e.population
FROM 
    economies e
WHERE 
    e.country IN ('Finland', 'Iceland', 'Norway', 'Serbia', 'Sweden')
    AND e.YEAR BETWEEN 2006 AND 2018
UNION
SELECT 
    years.year,
    e.country,
    e.GDP,
    e.gini,
    e.population
FROM 
    (SELECT DISTINCT YEAR FROM economies WHERE YEAR BETWEEN 2006 AND 2018) AS years
CROSS JOIN 
    countries c
LEFT JOIN 
    economies e ON e.country = c.country AND e.YEAR = years.year
WHERE 
    c.continent = 'Europe'
    AND c.country NOT IN ('Finland', 'Iceland', 'Norway', 'Serbia', 'Sweden')
    AND e.YEAR IS NOT NULL
ORDER BY 
    country ASC, year ASC;