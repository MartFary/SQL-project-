--Nejdříve jsem vypočítala průměrnou cenu potravin pro každou kategorii v každém roce. Následně byla spočítána meziroční procentuální změna cen pro každou kategorii a výsledek byl seřazen, abych mohla najít komoditu, která měla nejmenší (v našem případě záporný) meziroční růst a finálně jsem si nechala zobrazit pouze 1 výsledek.

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
order by procentualni_zmena
limit 1;
