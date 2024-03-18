# SQL PROJEKT

## ZAD�N�
Na va�em analytick�m odd�len� nez�visl� spole�nosti, kter� se zab�v� �ivotn� �rovn� ob�an�, jste se dohodli, �e se pokus�te odpov�d�t na p�r definovan�ch v�zkumn�ch ot�zek, kter� adresuj� dostupnost z�kladn�ch potravin �irok� ve�ejnosti. Kolegov� ji� vydefinovali z�kladn� ot�zky, na kter� se pokus� odpov�d�t a poskytnout tuto informaci tiskov�mu odd�len�. Toto odd�len� bude v�sledky prezentovat na n�sleduj�c� konferenci zam��en� na tuto oblast.

Pot�ebuj� k tomu od v�s p�ipravit robustn� datov� podklady, ve kter�ch bude mo�n� vid�t porovn�n� dostupnosti potravin na z�klad� pr�m�rn�ch p��jm� za ur�it� �asov� obdob�.

Jako dodate�n� materi�l p�ipravte i tabulku s HDP, GINI koeficientem a populac� dal��ch evropsk�ch st�t� ve stejn�m obdob�, jako prim�rn� p�ehled pro �R.

### Prim�rn� tabulky:

czechia_payroll � Informace o mzd�ch v r�zn�ch odv�tv�ch za n�kolikalet� obdob�. Datov� sada poch�z� z Port�lu otev�en�ch dat �R.
czechia_payroll_calculation � ��seln�k kalkulac� v tabulce mezd.
czechia_payroll_industry_branch � ��seln�k odv�tv� v tabulce mezd.
czechia_payroll_unit � ��seln�k jednotek hodnot v tabulce mezd.
czechia_payroll_value_type � ��seln�k typ� hodnot v tabulce mezd.
czechia_price � Informace o cen�ch vybran�ch potravin za n�kolikalet� obdob�. Datov� sada poch�z� z Port�lu otev�en�ch dat �R.
czechia_price_category � ��seln�k kategori� potravin, kter� se vyskytuj� v na�em p�ehledu.

### Dodate�n� tabulky:

countries - V�emo�n� informace o zem�ch na sv�t�, nap��klad hlavn� m�sto, m�na, n�rodn� j�dlo nebo pr�m�rn� v��ka populace.
economies - HDP, GINI, da�ov� z�t�, atd. pro dan� st�t a rok.

## ANAL�ZA
### czechia_payroll
* tabulka, kter� obsahuje industry_branch_code (od A a� po S) - v n�kter�ch ��dc�ch uvedeno NULL, s t�mi nebudu pracovat
* pokud je ve sloupci value_type_code 5958, jedn� se o hrubou mzdu zam�stnanc� => ve sloupci value vid�m konkr�tn� v��i hrub� mzdy
* selektem zjist�m, kdy tabulka za��n�: **2000**
SELECT payroll_year 
FROM czechia_payroll cp  
ORDER BY payroll_year ;
* selektem zjist�m, kdy tabulka kon��: **2021**
SELECT payroll_year 
FROM czechia_payroll cp  
ORDER BY payroll_year desc;
### czechia_payroll_industry_branch 
* tabulka, kdy ke ka�d�mu k�du odv�tv� (od A a� po S) je p�i�azen� name (n�zev tohoto odv�tv�)
### czechia_payroll_value_type 
* tabulka, ve kter� vid�m, �e code 5958 znamen� pr�m�rn� hrub� mzda na zam�stnance
### czechia_price 
* tabulka, ve kter� vid�m jednotliv� category_code (r�zn� potraviny) a value (cenu t�chto potravin)
* selektem zjist�m, kdy tabulka za��n�: **2006**
SELECT date_from
FROM czechia_price cp 
ORDER BY date_from;
* selekterm zjist�m, kdy tabulka kon��: **2018**
SELECT date_from
FROM czechia_price cp 
ORDER BY date_from DESC ;
### czechia_price_category
* tabulka, ve kter� vid�m code pro ka�dou potravinu a jej� name
* price_value a price_unit mi zobrazuj�, jestli se po��t� 1ks nebo 1l 
### economies
* tabulka, ve kter� ve sloupci country najdu "Czech Republic"
* tabulka, ve kter� ve sloupci year najdu data od roku **1960** do roku **2020**

* **=> v�sledkem t�to anal�zy je, �e kompletn� data m�m pouze pro rok 2006 a� rok 2018**


## POSTUP
* => na z�klad� t�chto znalost�, vytvo��m t�ikr�t with, kde spoj�m tabulku czechia_payroll a czechia_payroll_industry_branch, czechia_price_category a czechia_price a selektuji data z tabulky economie

* => n�sledn� tyto t�i tabulky spoj�m dohromady a vyberu konkr�tn� sloupce, kter� pot�ebuji pro v�slednou tabulku t_Alzbeta_Marikova_project_SQL_primary_final

* => v t�to tabulce jsem vytvo�ila nov� sloupec avg_value, ve kter�m je pr�m�rn� mzda v dan�m odv�tv� pro ka�d� rok

* => v t�to tabulce jsem vytvo�ila nov� sloupec avg_value_food, ve kter�m je pr�m�rn� cena ka�d� potraviny pro ka�d� rok


## V�SLEDKY
### Ot�zka �.1 - Rostou v pr�b�hu let mzdy ve v�ech odv�tv�ch, nebo v n�kter�ch klesaj�?

* vytvo��m sql dotaz - vlo�en� jako otazka1.sql
* pomoc� CASE vytvo��m sloupec, ve kter�m zn�zorn�m pro ka�d� rok 2006 hodnotu first_value (tento rok nem�m s ��m porovn�vat, proto�e data za rok 2005 nem�m), hodnotu Growth_? pro roky, kdy pr�m�rn� mzda v dan�m odv�tv� a dan�m roce oproti p�edchoz�mu vzrostla a hodnotu Decline pro roky, kdy pr�m�rn� mmzda v dan�m odv�tv� a dan�m roce oproti p�edchoz�mu klesla
* **ve v�ech odv�tv�ch v pr�b�hu let mzdy rostou**

### Ot�zka �.2 - Kolik je mo�n� si koupit litr� ml�ka a kilogram� chleba za prvn� a posledn� srovnateln� obdob� v dostupn�ch datech cen a mezd?

* vytvo��m sql dotaz - vlo�en� jako otazka2.sql
* pomoc� CASE vytvo��m nov� sloupec amount_purchased, ve kter�m pro k�d 114201 (1l ml�ka) a k�d 111301 (1kg chleba) vypo��t�m, kolik litr� nebo kg dan� potraviny je mo�n� koupit za pr�m�rn� plat v dan�m roce

### Ot�zka �.3 - Kter� kategorie potravin zdra�uje nejpomaleji (je u n� nejni��� percentu�ln� meziro�n� n�r�st)?

* vytvo��m sql dotaz - vlo�en� jako otazka3.sql
* vytvor�m si nov� pomocn� sloupec previous_avg_price (pro svou kontrolu) - v roce 2006 zad�m hodnotu 0, v ka�d�m dal��m roce vypo��t�m o kolik se oproti p�edchoz�mu roku zdra�ilo nebo zlevnilo
* vytvo��m v�sledn� sloupec price_increase jako SUM(previous_avg_price) OVER (PARTITION BY food), kde vid�m sou�et z m�ho pomocn�ho sloupce previous_avg_price
* zjistila jsem, �e pro jakostn� v�no (code 212101) nem�m ceny za v�echny roky (m�m hodnoty pouze pro roky 2015-2018), proto jsem tuto polo�ku z tohoto sql dotazu vylou�ila
* **nejpomaleji zdra�uj� rajsk� jablka �erven� kulat� (naopak zlevnila), stejn� tak zlevnil cukr krystalov�, potravina u kter� je nejni��� n�r�st ceny je p��rodn� minir�ln� voda uhli�it�**


### Ot�zka �.4 - Existuje rok, ve kter�m byl meziro�n� n�r�st cen potravin v�razn� vy��� ne� r�st mezd (v�t�� ne� 10 %)?

* vytvo��m sql dotaz - vlo�en� jako otazka4.sql
* pro ka�d� rok jsem si spo��tala pr�m�r z pr�m�rn�ch cen dan�ch potravin avg_avg_value_food
* pro svoji kontrolu vytvo��m sloupec avg_previous_avg_price, kde porovn�v�m, zda oproti p�edchoz�mu roku do�lo ke zdra�en� nebo zlevn�n� pr�m�rn�ch cen potravin
* pro ka�d� rok jsem si spo��tala pr�m�r z pr�m�rn�ch hrub�ch mezd v�ech odv�tv� avg_avg_value
* pro svoji kontrolu vytvo��m sloupec avg_previous_avg_value, kde porovn�v�m, zda oproti p�edchoz�mu roku do�lo ke zv��en� nebo sn�en� pr�m�rn�ch mezd
* rok 2006 op�t nastavuji n�r�st jako 0, proto�e nem�m data za rok 2005
* vytvo��m sloupec percentage_increase_avg_avg_value_food, kter� obsahuje procentu�ln� zm�nu pr�m�rn� hodnoty avg_value_food mezi aktu�ln�m a p�edchoz�m obdob�m, vyj�d�enou jako celo��seln� procento.
* vytvo��m sloupec percentace_increase_avg_avg_value, kter� obsahuje procentu�ln� zm�nu pr�m�rn� hodnoty avg_value mezi aktu�ln�m a p�edchoz�m obdob�m, vyj�d�enou jako celo��seln� procento.
* vytvo��m sloupec result, kde vypo��t�m rozd�l mezi percentage_increase_avg_avg_value_food a percentage_increase_avg_avg_value


* **nejhor�� v�sledky m� rok 2013, kdy potraviny zdra�ily o 5,1% a mzdy klesly o 1,6%** Meziro�n� n�r�st cen potravin (5,10 %) nep�evy�uje 10 % a rozd�l mezi r�stem cen potravin a poklesem mezd. V�sledek je 6,64 %. Tud� meziro�n� n�r�st cen potravin nebyl ani v nejhor��m roce 2013 v�razn� vy��� ne� r�st mezd o v�ce ne� 10 %.


### Ot�zka �.5 - M� v��ka HDP vliv na zm�ny ve mzd�ch a cen�ch potravin? Neboli, pokud HDP vzroste v�razn�ji v jednom roce, projev� se to na cen�ch potravin �i mzd�ch ve stejn�m nebo n�sduj�c�m roce v�razn�j��m r�stem?

* vytvo��m sql dotaz - vlo�en� jako otazka5.sql
* vytvo��m sloupec, ve kter�m vid�m rozd�ly pr�m�rn�ch cen potravin, rozd�ly pr�m�rn�ch mezd a rozd�l ve v��i GDP

* **V�voj GDP t�m�� souhlas� s v�vojem cen potravin. V�voj pr�m�rn�ch mezd je na GDP sp�e nez�visl�. Mzdy t�m�� st�le stoupaly (krom� roku 2013), bez ohledu na roky, kdy do�lo k poklesu GDP nebo cen potravin. Ale jednozna�n� souvislost mezi GDP, v�vojem cen potravin a v�vojem pr�m�rn�ch mezd nen�.**
