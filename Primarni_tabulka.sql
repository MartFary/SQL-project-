--Nejdříve byly vytvořeny dvě dočasné tabulky:
--Tabulka pro mzdy, která propojovala všechny informace o mzdách v ČR za roky 2006-2018. K základní tabulce czechia payroll bylo napojeno odvětví, fyzické mzdy zaměstnanců, hodnoty mezd v Kč a průměrné hrubé mzdy na zaměstnance dle přiložených číselníků.
--Tabulka pro potraviny, která propojovala informace v letech 2006-2018, které se týkají cen potravin, kdy k základní tabulce czechia_price byly napojeny informace z číselníku kategorií potravin.
--Na závěr byly obě tabulky propojeny skrze sledované a shodné časové období a vznikla finální tabulka Tabulka 1 - t_martina_farkavcova_project_sql_primary_final, ze které bylo možné jednoduše získat odpovědi na sledované otázky.

--Tabulka pro mzdy:

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

--Tabulka pro potraviny:

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

--Finální tabulka:

create table t_martina_farkavcova_project_SQL_primary_final
select *
from t_martina_farkavcova_mzdy_verze2
join t_martina_farkavcova_potraviny_verze2
    on t_martina_farkavcova_mzdy_verze2.payroll_year_mzdy = year (t_martina_farkavcova_potraviny_verze2.date_from_food) ;


