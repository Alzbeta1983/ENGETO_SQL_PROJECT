# SQL PROJEKT

## ZADÁNÍ
Na vašem analytickém oddìlení nezávislé spoleènosti, která se zabývá životní úrovní obèanù, jste se dohodli, že se pokusíte odpovìdìt na pár definovaných výzkumných otázek, které adresují dostupnost základních potravin široké veøejnosti. Kolegové již vydefinovali základní otázky, na které se pokusí odpovìdìt a poskytnout tuto informaci tiskovému oddìlení. Toto oddìlení bude výsledky prezentovat na následující konferenci zamìøené na tuto oblast.

Potøebují k tomu od vás pøipravit robustní datové podklady, ve kterých bude možné vidìt porovnání dostupnosti potravin na základì prùmìrných pøíjmù za urèité èasové období.

Jako dodateèný materiál pøipravte i tabulku s HDP, GINI koeficientem a populací dalších evropských státù ve stejném období, jako primární pøehled pro ÈR.

### Primární tabulky:

czechia_payroll – Informace o mzdách v rùzných odvìtvích za nìkolikaleté období. Datová sada pochází z Portálu otevøených dat ÈR.
czechia_payroll_calculation – Èíselník kalkulací v tabulce mezd.
czechia_payroll_industry_branch – Èíselník odvìtví v tabulce mezd.
czechia_payroll_unit – Èíselník jednotek hodnot v tabulce mezd.
czechia_payroll_value_type – Èíselník typù hodnot v tabulce mezd.
czechia_price – Informace o cenách vybraných potravin za nìkolikaleté období. Datová sada pochází z Portálu otevøených dat ÈR.
czechia_price_category – Èíselník kategorií potravin, které se vyskytují v našem pøehledu.

### Dodateèné tabulky:

countries - Všemožné informace o zemích na svìtì, napøíklad hlavní mìsto, mìna, národní jídlo nebo prùmìrná výška populace.
economies - HDP, GINI, daòová zátìž, atd. pro daný stát a rok.

## ANALÝZA
### czechia_payroll
* tabulka, která obsahuje industry_branch_code (od A až po S) - v nìkterých øádcích uvedeno NULL, s tìmi nebudu pracovat
* pokud je ve sloupci value_type_code 5958, jedná se o hrubou mzdu zamìstnancù => ve sloupci value vidím konkrétní výši hrubé mzdy
* selektem zjistím, kdy tabulka zaèíná: **2000**
SELECT payroll_year 
FROM czechia_payroll cp  
ORDER BY payroll_year ;
* selektem zjistím, kdy tabulka konèí: **2021**
SELECT payroll_year 
FROM czechia_payroll cp  
ORDER BY payroll_year desc;
### czechia_payroll_industry_branch 
* tabulka, kdy ke každému kódu odvìtví (od A až po S) je pøiøazené name (název tohoto odvìtví)
### czechia_payroll_value_type 
* tabulka, ve které vidím, že code 5958 znamená prùmìrná hrubá mzda na zamìstnance
### czechia_price 
* tabulka, ve které vidím jednotlivé category_code (rùzné potraviny) a value (cenu tìchto potravin)
* selektem zjistím, kdy tabulka zaèíná: **2006**
SELECT date_from
FROM czechia_price cp 
ORDER BY date_from;
* selekterm zjistím, kdy tabulka konèí: **2018**
SELECT date_from
FROM czechia_price cp 
ORDER BY date_from DESC ;
### czechia_price_category
* tabulka, ve které vidím code pro každou potravinu a její name
* price_value a price_unit mi zobrazují, jestli se poèítá 1ks nebo 1l 
### economies
* tabulka, ve které ve sloupci country najdu "Czech Republic"
* tabulka, ve které ve sloupci year najdu data od roku **1960** do roku **2020**

* **=> výsledkem této analýzy je, že kompletní data mám pouze pro rok 2006 až rok 2018**


## POSTUP
* => na základì tìchto znalostí, vytvoøím tøikrát with, kde spojím tabulku czechia_payroll a czechia_payroll_industry_branch, czechia_price_category a czechia_price a selektuji data z tabulky economie

* => následnì tyto tøi tabulky spojím dohromady a vyberu konkrétní sloupce, které potøebuji pro výslednou tabulku t_Alzbeta_Marikova_project_SQL_primary_final

* => v této tabulce jsem vytvoøila nový sloupec avg_value, ve kterém je prùmìrná mzda v daném odvìtví pro každý rok

* => v této tabulce jsem vytvoøila nový sloupec avg_value_food, ve kterém je prùmìrná cena každé potraviny pro každý rok


## VÝSLEDKY
### Otázka è.1 - Rostou v prùbìhu let mzdy ve všech odvìtvích, nebo v nìkterých klesají?

* vytvoøím sql dotaz - vložený jako otazka1.sql
* pomocí CASE vytvoøím sloupec, ve kterém znázorním pro každý rok 2006 hodnotu first_value (tento rok nemám s èím porovnávat, protože data za rok 2005 nemám), hodnotu Growth_? pro roky, kdy prùmìrná mzda v daném odvìtví a daném roce oproti pøedchozímu vzrostla a hodnotu Decline pro roky, kdy prùmìrná mmzda v daném odvìtví a daném roce oproti pøedchozímu klesla
* **ve všech odvìtvích v prùbìhu let mzdy rostou**

### Otázka è.2 - Kolik je možné si koupit litrù mléka a kilogramù chleba za první a poslední srovnatelné období v dostupných datech cen a mezd?

* vytvoøím sql dotaz - vložený jako otazka2.sql
* pomocí CASE vytvoøím nový sloupec amount_purchased, ve kterém pro kód 114201 (1l mléka) a kód 111301 (1kg chleba) vypoèítám, kolik litrù nebo kg dané potraviny je možné koupit za prùmìrný plat v daném roce

### Otázka è.3 - Která kategorie potravin zdražuje nejpomaleji (je u ní nejnižší percentuální meziroèní nárùst)?

* vytvoøím sql dotaz - vložený jako otazka3.sql
* vytvorím si nový pomocný sloupec previous_avg_price (pro svou kontrolu) - v roce 2006 zadám hodnotu 0, v každém dalším roce vypoèítám o kolik se oproti pøedchozímu roku zdražilo nebo zlevnilo
* vytvoøím výsledný sloupec price_increase jako SUM(previous_avg_price) OVER (PARTITION BY food), kde vidím souèet z mého pomocného sloupce previous_avg_price
* zjistila jsem, že pro jakostní víno (code 212101) nemám ceny za všechny roky (mám hodnoty pouze pro roky 2015-2018), proto jsem tuto položku z tohoto sql dotazu vylouèila
* **nejpomaleji zdražují rajská jablka èervená kulatá (naopak zlevnila), stejnì tak zlevnil cukr krystalový, potravina u které je nejnižší nárùst ceny je pøírodní minirální voda uhlièitá**


### Otázka è.4 - Existuje rok, ve kterém byl meziroèní nárùst cen potravin výraznì vyšší než rùst mezd (vìtší než 10 %)?

* vytvoøím sql dotaz - vložený jako otazka4.sql
* pro každý rok jsem si spoèítala prùmìr z prùmìrných cen daných potravin avg_avg_value_food
* pro svoji kontrolu vytvoøím sloupec avg_previous_avg_price, kde porovnávám, zda oproti pøedchozímu roku došlo ke zdražení nebo zlevnìní prùmìrných cen potravin
* pro každý rok jsem si spoèítala prùmìr z prùmìrných hrubých mezd všech odvìtví avg_avg_value
* pro svoji kontrolu vytvoøím sloupec avg_previous_avg_value, kde porovnávám, zda oproti pøedchozímu roku došlo ke zvýšení nebo snížení prùmìrných mezd
* rok 2006 opìt nastavuji nárùst jako 0, protože nemám data za rok 2005
* vytvoøím sloupec percentage_increase_avg_avg_value_food, který obsahuje procentuální zmìnu prùmìrné hodnoty avg_value_food mezi aktuálním a pøedchozím obdobím, vyjádøenou jako celoèíselné procento.
* vytvoøím sloupec percentace_increase_avg_avg_value, který obsahuje procentuální zmìnu prùmìrné hodnoty avg_value mezi aktuálním a pøedchozím obdobím, vyjádøenou jako celoèíselné procento.
* vytvoøím sloupec result, kde vypoèítám rozdíl mezi percentage_increase_avg_avg_value_food a percentage_increase_avg_avg_value


* **nejhorší výsledky má rok 2013, kdy potraviny zdražily o 5,1% a mzdy klesly o 1,6%** Meziroèní nárùst cen potravin (5,10 %) nepøevyšuje 10 % a rozdíl mezi rùstem cen potravin a poklesem mezd. Výsledek je 6,64 %. Tudíž meziroèní nárùst cen potravin nebyl ani v nejhorším roce 2013 výraznì vyšší než rùst mezd o více než 10 %.


### Otázka è.5 - Má výška HDP vliv na zmìny ve mzdách a cenách potravin? Neboli, pokud HDP vzroste výraznìji v jednom roce, projeví se to na cenách potravin èi mzdách ve stejném nebo násdujícím roce výraznìjším rùstem?

* vytvoøím sql dotaz - vložený jako otazka5.sql
* vytvoøím sloupec, ve kterém vidím rozdíly prùmìrných cen potravin, rozdíly prùmìrných mezd a rozdíl ve výši GDP

* **Vývoj GDP témìø souhlasí s vývojem cen potravin. Vývoj prùmìrných mezd je na GDP spíše nezávislý. Mzdy témìø stále stoupaly (kromì roku 2013), bez ohledu na roky, kdy došlo k poklesu GDP nebo cen potravin. Ale jednoznaèná souvislost mezi GDP, vývojem cen potravin a vývojem prùmìrných mezd není.**
