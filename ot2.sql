--Nejdříve bylo nutné najít si záznamy pouze pro mléko a chléb a následně vypočítat množství těchto potravin za průměrnou mzdu v roce 2006 a v roce 2018.

WITH 
prices AS (
    SELECT 
        tmf.payroll_year_mzdy,
        tmf.value_mzdy,
        tmf.name_food,
        tmf.price_food,
        tmf.price_unit_food,
        tmf.price_value_food
    FROM t_martina_farkavcova_project_sql_primary_final tmf
    WHERE tmf.name_food like '%Chléb%'
    or tmf.name_food like '%Mléko%'
)
SELECT 
    p.payroll_year_mzdy,
    p.name_food ,
    p.value_mzdy,
    p.price_food ,
    p.price_value_food ,
    round ((p.value_mzdy / (p.price_food / p.price_value_food)),2) AS mozno_koupit
FROM prices p
where p.payroll_year_mzdy = 2006
or p.payroll_year_mzdy = 2018
GROUP BY p.payroll_year_mzdy, p.name_food;



