/* 
Za použití dočasných tabulek jsem zjistila průměrné mzdy za jednotlivé odvětví a za jednotlivé roky. 
Výsledné hodnoty byly vždy porovnány s hodnotami předchozího roku. 
Finálním dotazem pak bylo identifikováno, zda ve srovnání s předchozím rokem dochází k nárůstu či poklesu mezd.
*/

WITH Prumer_mezd AS (
     SELECT 
        industry_branch_name,
        payroll_year_mzdy,
        AVG(value_mzdy) AS avg_mzdy
    FROM 
        t_martina_farkavcova_project_sql_primary_final tmfpspf 
    GROUP BY 
        industry_branch_name,
        payroll_year_mzdy),
 Rozdil_mezd as (
     SELECT 
        industry_branch_name,
        payroll_year_mzdy,
        avg_mzdy,
        LAG(avg_mzdy, 1) OVER (PARTITION BY industry_branch_name ORDER BY payroll_year_mzdy) AS avg_mzdy_porovnani
    FROM Prumer_mezd )
SELECT
*
,CASE 
	WHEN avg_mzdy > avg_mzdy_porovnani then 'rostoucí'
	WHEN avg_mzdy < avg_mzdy_porovnani then 'klesající'
	else 'beze změny'
end as zmeny
from Rozdil_mezd
group by industry_branch_name, payroll_year_mzdy;

--Pokud chci zjistit odvětví a roky, ve kterých došlo čistě k poklesu mezd, pak na konec celého příkazu využiji klauzuli HAVING (having zmeny = 'klesající')

