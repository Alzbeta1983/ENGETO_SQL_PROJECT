SELECT
    industry_branch_code
    ,name
    ,avg_value
    ,payroll_year
    ,CASE
        WHEN LAG(avg_value,1) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) < avg_value THEN 'Growth_?'
        WHEN LAG(avg_value,1) OVER (PARTITION BY industry_branch_code ORDER BY payroll_year) > avg_value THEN 'Decline'
        ELSE 'first_value'
    END AS wage_trend
FROM t_Alzbeta_Marikova_project_SQL_primary_final
GROUP BY industry_branch_code, name, payroll_year
ORDER BY industry_branch_code, payroll_year;
