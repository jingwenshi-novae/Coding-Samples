* MADE BY JINGWEN SHI
* predoc 2024

* PACKAGE USED:
ssc install reghdfe,replace


clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop"
cd "$myPATH\Jingwen Shi_predoc2024"


use table_2a,clear

* keep the objective cohort and patent year
keep if cohort>=1970 & cohort<1980
keep if year==2005
order cz czname state stateabbrv cohort age

* check duplicate groups: no duplicates
bys cz cohort age: gen n=_n
count if n>1
drop n

// Generation of main variables
gen n=_n
rename count_g_m gendercount1
rename count_g_f gendercount2
reshape long gendercount, i(n) j(j)
gen females=0 if j==1
replace females=1 if j==2
label define femalesvalues 0 "male" 1 "female"
label values females femalesvalues
label var females "A dummy variable indicating the group gender is female"
drop n j
rename gendercount count_g
label var count_g "Number of individuals in this single-gender group"

** adjust the scale of num_grants
gen grantspc=num_grants*1000000
label var grantspc "Average number of patents granted every million of people"
order cz czname state stateabbrv cohort age year count females count_g grantspc

* independent var: females
* fweight: count
* dependent var: grantspc
* cohort fe: cohorts
* region fe: cz


////////////////////////////////////////
/*  Regression 1: Patents on female   */
////////////////////////////////////////

reg grantspc females [fweight=count_g],robust

estimates store Regression_1


/////////////////////////////////////////////////
/*  Regression 2: Patents on female, with FE   */
/////////////////////////////////////////////////

reghdfe grantspc females [fweight=count_g], vce(robust) absorb(cohort state)

estimates store Regression_2

esttab Regression_1 Regression_2 using "C:\Users\Jingwen Shi\Desktop\Jingwen Shi_predoc2024\output.tex", b(%9.3f) se(%9.3f) r2(%9.2f) title("Table2") star(* 0.1 ** 0.05 *** 0.01)replace




