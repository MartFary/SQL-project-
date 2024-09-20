--Dotazem níže jsem nejdříve zjistila průměrné roční mzdy a ceny potravin. Následně byly zjištěny meziroční změny v procentech a vyfiltrovány roky, ve kterých byl rozdíl více než 10 %.

WITH rocni_prumery as (
    SELECT 
        payroll_year_mzdy,
        AVG(value_mzdy) AS avg_mzdy,
        AVG(price_food) AS avg_ceny
    FROM 
        t_martina_farkavcova_project_sql_primary_final tmfpspf 
    GROUP BY 
        payroll_year_mzdy
),
rocni_zmeny AS (
    SELECT 
        payroll_year_mzdy,
        LAG(avg_mzdy) OVER (ORDER by payroll_year_mzdy) AS avg_mzdy_porovnani,
        LAG(avg_ceny) OVER (ORDER BY payroll_year_mzdy) AS avg_ceny_porovnani,
        avg_mzdy,
        avg_ceny,
        ((avg_mzdy - LAG(avg_mzdy) OVER (ORDER BY payroll_year_mzdy)) / LAG(avg_mzdy) OVER (ORDER BY payroll_year_mzdy)) * 100 AS procentualni_zmena_mzdy,
        ((avg_ceny - LAG(avg_ceny) OVER (ORDER BY payroll_year_mzdy)) / LAG(avg_ceny) OVER (ORDER BY payroll_year_mzdy)) * 100 AS procentualni_zmena_ceny
    FROM 
        rocni_prumery
)
SELECT 
    payroll_year_mzdy,
    round (procentualni_zmena_mzdy, 2) as procentualni_zmena_mzdy,
    round (procentualni_zmena_ceny, 2) as procentualni_zmena_ceny
FROM 
    rocni_zmeny
WHERE 
    procentualni_zmena_ceny - procentualni_zmena_mzdy > 10;



