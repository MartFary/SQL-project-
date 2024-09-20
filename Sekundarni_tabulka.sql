--Tato tabulka byla vytvořena jednoduchou agregací tabulek countries a economies, kdy k tabulce economies byla napojena data, která nám vyselektovala údaje pouze pro státy v Evropě a zároveň sledované údaje v letech 2006-2018 (tedy stejně jako u primární tabulky).

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

