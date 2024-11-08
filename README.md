# Průvodní listina k projektu datové akademie od ENGETO (část SQL)
## Zadání projektu

Na vašem analytickém oddělení nezávislé společnosti, která se zabývá životní úrovní občanů, jste se dohodli, že se pokusíte odpovědět na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veřejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovědět a poskytnout tuto informaci tiskovému oddělení. Toto oddělení bude výsledky prezentovat na následující konferenci zaměřené na tuto oblast.
Potřebují k tomu od vás připravit robustní datové podklady, ve kterých bude možné vidět porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období.
Jako dodatečný materiál připravte i tabulku s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

## Datové podklady

Příprava dvou robustních datových podkladů ze základních zdrojových tabulek.

**[Primární tabulka](/Primarni_tabulka.sql) -**  - porovnání dostupnosti potravin na základě průměrných příjmů za určité časové období (roky 2006-2018).

**[Sekundární tabulka](/Sekundarni_tabulka.sql) -** - tabulka s HDP, GINI koeficientem a populací dalších evropských států ve stejném období, jako primární přehled pro ČR.

## Výzkumné otázky
1.	Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
2.	Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?
3.	Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?
4.	Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?
5.	Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

## Odpovědi na výzkumné otázky:

### Rostou v průběhu let mzdy ve všech odvětvích, nebo v některých klesají?
Na základě zadaného dotazu lze ve sloupci s názvem ‚zmeny‘ vyčíst, ve kterém odvětví a ve kterém roce došlo k meziročnímu poklesu mezd a ve kterém k nárůstu. Na tuto otázku není tedy jednoznačná odpověď, neboť během sledovaného období lze zaznamenat nejen nárůsty, ale i poklesy mezd.

Pro demonstraci odpovědi jsou v tabulce níže vypsány odvětví a roky, ve kterých došlo k poklesu mezd.


![image](https://github.com/user-attachments/assets/b70bf3ff-045d-4cfc-929b-3e7b56b3ee13)

**[Datový podklad](/ot1.sql)**


### Kolik je možné si koupit litrů mléka a kilogramů chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

Za první sledované období (rok 2006) lze koupit 742,98 kilo chleba nebo 896,44 litrů mléka.
Za poslední sledované období (rok 2018) lze koupit 858,66 kilo chleba nebo 1 090,03 litrů mléka.

![image](https://github.com/user-attachments/assets/0f72e7af-49c9-4dad-8386-3816d7bca3a8)

**[Datový podklad](/ot2.sql)**

### Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroční nárůst)?

Při porovnání meziročních cen jednotlivých potravin bylo zjištěno, že ne vždy docházelo k nárůstu cen. Výsledným dotazem jsem zjistila, že ve sledovaných letech došlo k největšímu poklesu cen u komodity Jablka konzumní a to v roce 2008, kdy došlo k poklesu o 42,33 %.

![image](https://github.com/user-attachments/assets/18eb124b-795c-455d-abd6-6a6dea563d9a)

**[Datový podklad](/ot3.sql)**

### Existuje rok, ve kterém byl meziroční nárůst cen potravin výrazně vyšší než růst mezd (větší než 10 %)?

V roce 2013 došlo k poklesu mezd (o 1,99 %) a zároveň k nárůstu cen o 8,50 %. Rozdíl v tomto roce je tedy větší než 10 %.

![image](https://github.com/user-attachments/assets/d6b843b2-5c8f-4967-a335-be37f3123cc6)

**[Datový podklad](/ot4.sql)**

### Má výška HDP vliv na změny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výrazněji v jednom roce, projeví se to na cenách potravin či mzdách ve stejném nebo následujícím roce výraznějším růstem?

Pod slovem výrazněji si představím například změnu o 3 %. Ve sledovaném období nelze jednoznačně tvrdit, že společně s významným růstem HDP by došlo v témže či v následujícím roce k významnému růstu mezd či cen potravin. Změny nevykazují žádné pravidelnosti.


![image](https://github.com/user-attachments/assets/63019625-3cd4-47ef-8465-db11bdddc537)


**[Datový podklad](/ot5.sql)**



