
--PROJEKT DATOVÁ AKADEMIE

--Tabulka 1 - porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.
--Tabulka 2 - tabulka s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.
--Výzkumné otázky
--1.	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
--2.	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
--3.	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
--4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
--5.	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
--

--Vytvoření tabulky 1 s názvem t_martina_farkavcova_project_SQL_primary_final

--vytvoření pomocné tabulky pro potraviny
create table t_martina_farkavcova_potraviny_verze2 
select
czechia_price.id as id_food, 
czechia_price.value as price_food, 
czechia_price.category_code as category_code_food, 
czechia_price.date_from as date_from_food,
czechia_price.region_code as region_code_food, 
czechia_price_category.name as name_food,
czechia_price_category.price_value as price_value_food, 
czechia_price_category.price_unit as price_unit_food
from czechia_price
join czechia_price_category
on czechia_price.category_code = czechia_price_category.code
where year (date_from) between 2006 AND 2018
group by year (date_from_food) , name_food
having AVG (price_food)
order by name_food, year (date_from) ;


---vytvoření pomocné tabulky pro mzdy (v základní tabulce czechia_payroll_calculation jsem měla u kódu 100 přepočtený , u kódu 200 fyzický - tedy opačně, než bylo n začátku kurzu)
create table t_martina_farkavcova_mzdy_verze2 
select
cp.id as id_mzdy,
cp.value as value_mzdy, 
cp.value_type_code as value_type_code_mzdy,
cpvt.name as value_type_name, 
cp.unit_code as unit_code_mzdy, 
cpu.name as unit_name, 
cp.calculation_code as calculation_code_mzdy, 
cpc.name as calculation_name, 
cp.industry_branch_code as  industry_branch_code_mzdy,
cpib.name as industry_branch_name, 
cp.payroll_year as payroll_year_mzdy 
FROM czechia_payroll cp
JOIN czechia_payroll_calculation cpc
    ON cp.calculation_code = cpc.code
JOIN czechia_payroll_industry_branch cpib
    ON cp.industry_branch_code = cpib.code
JOIN czechia_payroll_unit cpu
    ON cp.unit_code = cpu.code
JOIN czechia_payroll_value_type cpvt
    ON cp.value_type_code = cpvt.code
where payroll_year between 2006 and 2018
      and cpvt.code = 5958
      and cpu.code = 200
      and cpc.code = 100
group by cpib.name , cp.payroll_year ;


--finální tabulka vznikla spojením dvou výše vytvořených tabulek
create table t_martina_farkavcova_project_SQL_primary_final
select *
from t_martina_farkavcova_mzdy_verze2
join t_martina_farkavcova_potraviny_verze2
    on t_martina_farkavcova_mzdy_verze2.payroll_year_mzdy = year (t_martina_farkavcova_potraviny_verze2.date_from_food) ;

--Vytvoření tabulky 2 s názvem t_martina_farkavcova_project_SQL_secondary_final (data za roky 2006-2018 a za Evropu)

create table t_martina_farkavcova_project_SQL_secondary_final
select
e.country,
continent,
`year` , 
GDP, 
gini
from economies e 
join countries c 
on e.country = c.country 
where `year` between 2006 and 2018
    and continent = 'Europe'
group by e.country , `year`;

--1.	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?

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
,case 
	when avg_mzdy > avg_mzdy_porovnani then 'rostoucí'
	when avg_mzdy < avg_mzdy_porovnani then 'klesající'
	else 'beze změny'
end as zmeny
from Rozdil_mezd
group by industry_branch_name, payroll_year_mzdy;

--2.	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

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
    (p.value_mzdy / (p.price_food / p.price_value_food)) AS mozno_koupit
FROM prices p
where p.payroll_year_mzdy = 2006
or p.payroll_year_mzdy = 2018
GROUP BY p.payroll_year_mzdy, p.name_food;

--3.	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

WITH Prumerna_cena AS (
    SELECT
        name_food ,
        YEAR(date_from_food) AS year_date_from_food,
        AVG(price_food) AS avg_price
    FROM
        t_martina_farkavcova_project_sql_primary_final 
    GROUP BY
        name_food, YEAR(date_from_food)
 ),
 procentualni_zmena_ceny as (
     SELECT
        pc1.name_food,
        pc1.year_date_from_food AS year_start,
        pc1.avg_price AS price_start,
        pc2.avg_price AS price_end,
        ((pc2.avg_price - pc1.avg_price) / pc1.avg_price) * 100 AS procentualni_zmena
    FROM
        prumerna_cena pc1
    JOIN
        prumerna_cena pc2
    ON
        pc1.name_food = pc2.name_food
        AND pc2.year_date_from_food = pc1.year_date_from_food + 1
)
SELECT
*
FROM
    procentualni_zmena_ceny
GROUP BY
    name_food, year_start
order by procentualni_zmena;

--4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

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
    procentualni_zmena_mzdy,
    procentualni_zmena_ceny
FROM 
    rocni_zmeny
WHERE 
    procentualni_zmena_ceny - procentualni_zmena_mzdy > 10;

--5.	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

-- Sloučení dvou základních tabulek

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
group by t_martina_farkavcova_project_sql_primary_final.payroll_year_mzdy;


-- Výsledný dotaz

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

Průvodní listina k projektu datové akademie od ENGETO (část SQL)

Příprava dvou robustních datových podkladů ze základních zdrojových tabulek.
Tabulka 1 - porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.
Tabulka 2 - tabulka s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.
Výzkumné otázky
1.	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2.	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3.	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5.	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

POPIS VÝSTUPŮ:
Tabulka 1 - t_martina_farkavcova_project_sql_primary_final
Nejdříve byla vytvořena tabulka, která propojovala všechny informace o mzdách v ČR, za roky 2006-2018. K základní tabulce czechia payroll bylo napojeno odvětví, fyzické mzdy zaměstnanců, hodnoty mezd v Kč a průměrné hrubé mzdy na zaměstnance dle přiložených číselníků.
Další tabulka propojovala informace, které se týkají cen potravin, kdy k základní tabulce czechia_price byly napojeny informace z číselníku kategorií potravin.
Na závěr byly obě tabulky propojeny skrze sledované a shodné časové období.
Tabulka 2 - t_martina_farkavcova_project_sql_secondary_final
Tato tabulka byla vytvořena jednoduchou agregací tabulek countries a economies, kdy k tabulce economies byla napojena data, která nám vyselektovala údaje pouze pro státy v Evropě a zároveň sledované údaje v letech 2006-2018 )tedy stejně jako u tabulky 1.
Výzkumné otázky:
Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Na základě zadaného dotazu lze ve sloupci s názvem ‚zmeny‘ vyčíst, ve kterém odvětví a ve kterém roce došlo k meziročnímu poklesu mezd a ve kterém k nárůstu. Na tuto otázku není tedy jednoznačná odpověď, neboť během sledovaného období lze zaznamenat nejen nárůsty, ale i poklesy mezd. 
Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
Za první sledované období (rok 2006) lze koupit 742,98 kilo chleba nebo 896,44 litrů mléka.
Za poslední sledované období (rok 2018) lze koupit 858,66 kilo chleba nebo 1 090,03 litrů mléka.
Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
Na základě tohoto dotazu jsme zjistili, že ve sledovaných letech došlo k největšímu poklesu cen u komodity Jablka konzumní a to v roce 2008, kdy došlo k poklesu o 42,33 %.
Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
V roce 2013 došlo k poklesu mezd (o 1,99 %) a zároveň k nárůstu cen o 8,50 %. Rozdíl v tomto roce je tedy větší než 10 %.
Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?
Pod slovem výrazněji si představím například změnu o 3 %. Ve sledovaném období nelze jednoznačně tvrdit, že společně s významným růstem HDP by došlo v témže či v následujícím roce k významnému růstu mezd či cen potravin. Změny nevykazují žádné pravidelnosti.





