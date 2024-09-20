--Nejdříve jsem potřebovala vytvořit sloučená data z vlastní primární a sekundární datové sady. Následně jsem vypočítala míry růstu a poté vytvořila SQL dotaz, který mi identifikoval roky, ve kterých došlo k významnému růstu HDP (v mém případě 3%).

with data_sloucena as (
 SELECT 
    t_martina_farkavcova_project_sql_primary_final.payroll_year_mzdy, 
    AVG (value_mzdy) AS avg_mzda,
    AVG (price_food) AS avg_cena_potravin,
    t_martina_farkavcova_project_sql_secondary_final.GDP 
FROM 
    t_martina_farkavcova_project_sql_primary_final
inner JOIN 
    t_martina_farkavcova_project_sql_secondary_final 
ON 
    t_martina_farkavcova_project_sql_primary_final.payroll_year_mzdy = t_martina_farkavcova_project_sql_secondary_final.`year` 
WHERE 
    t_martina_farkavcova_project_sql_secondary_final.Country = 'Czech Republic'  
group by t_martina_farkavcova_project_sql_primary_final.payroll_year_mzdy)
,data_zmeny AS (
    SELECT
        payroll_year_mzdy,
        (GDP - LAG(GDP) OVER (ORDER BY payroll_year_mzdy)) / LAG(GDP) OVER (ORDER BY payroll_year_mzdy) * 100 AS rust_GDP,
        (avg_mzda - LAG(avg_mzda) OVER (ORDER BY payroll_year_mzdy)) / LAG(avg_mzda) OVER (ORDER BY payroll_year_mzdy) * 100 AS rust_mezd,
        (avg_cena_potravin - LAG(avg_cena_potravin) OVER (ORDER BY payroll_year_mzdy)) / LAG(avg_cena_potravin) OVER (ORDER BY payroll_year_mzdy) * 100 AS rust_cen
    FROM
        data_sloucena
)
SELECT
    payroll_year_mzdy,
    rust_GDP,
    rust_mezd,
    rust_cen,
    CASE
        WHEN rust_GDP > 3 THEN 'Vyznamny_rust_GDP'
        ELSE 'Normalni_rust_GDP'
    END AS GDP_zmeny
FROM
    data_zmeny
group BY
    payroll_year_mzdy;

