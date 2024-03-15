clear
clear matrix
set more off

global myPATH "C:\Users\shiji\Desktop"
cd "$myPATH\EventData"

//(1) import excel and save files
import excel "$myPATH\EventData\EventDate.xlsx",sheet("sheet1") firstrow clear
rename ListedCoID ID
label var ID "CompanyID"
rename Symbol Stock
label var Stock "StockID"
drop ShortName
label var EventDate "EventDate"
save EventDate.dta,replace

/*
import excel "$myPATH\EventData\RiskFree.xlsx",sheet("sheet1") firstrow clear
drop Nrr1
rename Clsdt Date
drop Nrrdata
rename Nrrdaydt rf
save RiskFree.dta,replace
*/

import excel "$myPATH\EventData\Returns2.xlsx",sheet("sheet1") firstrow clear
rename Stkcd Stock
label var Stock "StockID"
rename Trddt Date
rename Dretnd ret_nd
label var ret_nd "Return(No Dividend)"
rename Dsmvtll size
label var size "Market Capitalization (Total)"
save Returns2.dta,replace

import excel "$myPATH\EventData\Returns3.xlsx",sheet("sheet1") firstrow clear
rename Stkcd Stock
label var Stock "StockID"
rename Trddt Date
rename Dretnd ret_nd
label var ret_nd "Return(No Dividend)"
rename Dsmvtll size
label var size "Market Capitalization (Total)"
save Returns3.dta,replace

import excel "$myPATH\EventData\Returns4.xlsx",sheet("sheet1") firstrow clear
rename Stkcd Stock
label var Stock "StockID"
rename Trddt Date
rename Dretnd ret_nd
label var ret_nd "Return(No Dividend)"
rename Dsmvtll size
label var size "Market Capitalization (Total)"
save Returns4.dta,replace

import excel "$myPATH\EventData\Returns1.xlsx",sheet("sheet1") firstrow clear
rename Stkcd Stock
label var Stock "StockID"
rename Trddt Date
rename Dretnd ret_nd
label var ret_nd "Return(No Dividend)"
rename Dsmvtll size
label var size "Market Capitalization (Total)"
save Returns1.dta,replace

append using Returns2.dta
append using Returns3.dta
append using Returns4.dta
save Returns.dta,replace

import excel "$myPATH\EventData\BMrate.xlsx",sheet("sheet1") firstrow clear
rename Stkcd Stock
label var Stock "StockID"
rename Accper Date
rename F101001A BMrate
save BMrate.dta,replace

use Returns,clear
merge m:1 Stock Date using BMrate
keep if _merge == 3
drop _merge
keep if Date=="2022-03-31"
drop Date ret_nd
save sizeBM.dta,replace

import excel "$myPATH\EventData\Hushen300.xlsx",sheet("sheet1") firstrow clear
rename Trddt Date
drop Hushen300
label var rm "market return"
save Hushen300.dta,replace

/*
import excel "$myPATH\EventData\Factors.xlsx",sheet("sheet1") firstrow clear
keep TradingDate RiskPremium2 SMB2 HML2
rename TradingDate Date
rename RiskPremium2 MKT
rename SMB2 SMB
rename HML2 HML
label var MKT "Market Factor"
label var SMB "Scale Factor"
label var HML "BM Factor"
save Factors.dta,replace
*/

import excel "$myPATH\EventData\Company.xlsx",sheet("sheet1") firstrow clear
rename ListedCoID ID
label var ID "CompanyID"
rename Symbol Stock
label var Stock "StockID"
drop ShortName
rename EndDate Date
drop IndustryName
rename IndustryCode Industry
label var Industry "IndustryCode"
rename PROVINCECODE Province
label var Province "ProvinceCode"
drop PROVINCE
keep if Date=="2021-12-31"
keep if LISTINGSTATE=="正常上市"
drop Date
drop LISTINGSTATE
gen industry=substr(Industry,2,2)
destring industry,generate(indus)
destring Province,generate(prov)
drop industry Industry Province
save Company.dta,replace

import excel "$myPATH\EventData\Operation.xlsx",sheet("sheet1") firstrow clear
rename Stkcd Stock
label var Stock "StockID"
rename Reptdt Date
drop Stknme Nindcd Nindnme Province
rename Prisg SOE
label var SOE "private firms"
gen emp=Empnum
gen ln_emp=ln(Empnum)
label var ln_emp "log of employee numbers"
drop Empnum
gen ln_board=ln(Bdnum)
label var ln_board "log of board size"
drop Bdnum
rename Presmn Duality
label var Duality "whether CEO is also chairman"
rename A001000000 Assets
label var Assets "Total Assets"
gen ln_assets=ln(Assets)
rename A002100000 Debt
gen Leverage=Debt/Assets
drop A001100000
gen inc=B001100000
gen ln_inc=ln(B001100000)
drop B001100000
gen ln_profit=ln(B002000000)
drop B002000000
drop Debt
keep if Date=="2020-12-31"
drop Date
destring SOE,replace
save Operation.dta,replace

import excel "$myPATH\EventData\Subsid.xlsx",sheet("sheet1") firstrow clear
rename InstitutionID ID
label var ID "CompanyID"
rename Symbol Stock
label var Stock "StockID"
drop EndDate
drop RalatedParty
keep if RelationshipCode=="P7502"
drop RelationshipCode
drop Relationship
keep if RegisterAddress=="上海"
drop RegisterAddress
drop if ISExit==1
drop ISExit
bys Stock:gen n=_n
bys Stock: egen subsid=max(n)
keep if n==1
drop n
save Subsid.dta,replace

/*
import excel "$myPATH\EventData\wage.xlsx",sheet("sheet1") firstrow clear
rename Sgnyea year
rename Prvcnm_id Province
label var Province "ProvinceCode"
drop Prvcnm
drop Indunm
rename Epwa0501 wage
save wage.dta,replace
*/


use Company,clear
drop Stock
rename ID Anchor
save CompanyList.dta,replace
import excel "$myPATH\EventData\Purchase.xlsx",sheet("sheet1") firstrow clear
keep if EndDate=="2020-12-31"
drop Rank StateTypeCode EndDate
rename BusinessInstitutionID Anchor
rename Symbol Stock
label var Stock "StockID"
save Purchase.dta,replace
merge m:1 Anchor using CompanyList
keep if _merge==3
drop _merge
drop Anchor indus
keep if prov==310000
gen SHsupply=1
drop prov
save Purchase.dta,replace

import excel "$myPATH\EventData\Custom.xlsx",sheet("sheet1") firstrow clear
keep if EndDate=="2020-12-31"
drop Rank StateTypeCode EndDate
rename BusinessInstitutionID Anchor
rename Symbol Stock
label var Stock "StockID"
save Custom.dta,replace
merge m:1 Anchor using CompanyList
keep if _merge==3
drop _merge
drop Anchor indus
keep if prov==310000
gen SHsupply=1
drop prov
save Custom.dta,replace
append using Purchase.dta
save Supply.dta,replace

/* Distinguish SME: Small and Median size Enterprises */
import excel "$myPATH\EventData\Company.xlsx",sheet("sheet1") firstrow clear
rename IndustryCode Industry
label var Industry "IndustryCode"
gen industry=substr(Industry,2,2)
destring industry,generate(indus)
keep IndustryName indus
sort indus
by indus: gen n=_n
keep if n==1
drop n
gen max_inc=20000 if indus>=1 & indus<=5
replace max_inc=40000 if indus>=6 & indus <=46
gen max_emp=1000 if indus>=6 & indus<=46
replace max_inc=80000 if indus>=46 & indus<=50
gen max_aset=80000 if indus>=46 & indus<=50
replace max_inc=40000 if indus==51
replace max_emp=200 if indus==51
replace max_inc=20000 if indus==52
replace max_emp=300 if indus==52
replace max_inc=30000 if indus>=53 & indus<=58
replace max_emp=1000 if indus>=53 & indus<=58
replace max_inc=30000 if indus==59
replace max_emp=200 if indus==59
replace max_inc=30000 if indus==60
replace max_emp=1000 if indus==60
replace max_inc=10000 if indus>=61 & indus<=62
replace max_emp=300 if indus>=61 & indus<=62
replace max_inc=100000 if indus>=63 & indus<=64
replace max_emp=2000 if indus>=63 & indus<=64
replace max_inc=10000 if indus==65
replace max_emp=300 if indus==65
replace max_aset=100000000000 if indus>=66 & indus<=67
replace max_aset=500000000000 if indus==68
replace max_aset=100000000000 if indus==69
replace max_inc=200000 if indus==70
replace max_emp=10000 if indus==70
replace max_inc=120000 if indus==71
replace max_emp=300 if indus==71
replace max_emp=300 if indus>71
save Small.dta,replace

use Operation,clear
merge m:1 Stock using Company.dta
keep if _merge==3
drop _merge
merge m:1 indus using Small.dta
keep if _merge==3
drop _merge
drop IndustryName
replace max_emp=0 if max_emp==.
replace max_aset=0 if max_aset==.
replace max_inc=0 if max_inc==.
gen SME=1 if Assets<=max_aset
replace SME=1 if emp<=max_emp
replace SME=1 if inc<=max_inc
replace SME=0 if SME==.
count if SME==1
drop Assets emp inc
save SME.dta,replace


//(2) combine event and stock data
use Returns, clear
sort Stock
merge m:1 Stock using EventDate
keep if _merge==3
drop _merge
merge m:1 Date using Hushen300
keep if _merge==3
drop _merge
rename ret_nd ret


//(3) event study with Stata
gen year=substr(Date,1,4)
drop if year=="2019"
drop if year=="2020"
gen month=substr(Date,6,2)
drop if year=="2021" & month=="01"
drop if year=="2021" & month=="02"
sort ID Date
by ID: gen datenum=_n
by ID: gen target=datenum if Date==EventDate
egen td=min(target), by(ID)
drop target
gen dif=datenum-td
tab td
keep if td==263

by ID: gen event_window=1 if dif==0
by ID: gen estimation_window=1 if dif>=-263 & dif<0
by ID: gen post_window1=1 if dif==1
by ID: gen post_window5=1 if dif>=1 & dif<5
by ID: gen post_window10=1 if dif>=1 & dif<=10
by ID: gen post_window15=1 if dif>=1 & dif<=15

replace event_window=0 if event_window==.
replace estimation_window=0 if estimation_window==.
replace post_window1=0 if post_window1==.
replace post_window5=0 if post_window5==.
replace post_window10=0 if post_window10==.
replace post_window15=0 if post_window15==.
save EventStudy.dta,replace


//(4) the last categories

//(4.1) 1daypost
use EventStudy.dta,clear
gen predicted_return=.
egen id=group(ID)
sum id
forvalues i=1(1)2608 {
	reg ret rm if id==`i' & estimation_window==1
	predict p if id==`i'
	replace predicted_return=p if id==`i' & post_window1==1
	drop p
}
/* Test significance */
sort id Date
gen abnormal_return=ret-predicted_return if post_window1==1
by id: egen cumulative_abnormal_return=total(abnormal_return)
by id: egen ar_sd=sd(abnormal_return)
gen test=(1/sqrt(7))*(cumulative_abnormal_return)
reg cumulative_abnormal_return if dif==0, robust
mean(cumulative_abnormal_return) if cumulative_abnormal_return<0
mean(cumulative_abnormal_return) if cumulative_abnormal_return>0
/* collaborate all vars */
rename cumulative_abnormal_return CAR
keep if datenum==1
keep Stock ID CAR
save CAR_1.dta,replace

//(4.2) 5daypost
use EventStudy.dta,clear
gen predicted_return=.
egen id=group(ID)
sum id
forvalues i=1(1)2608 {
	reg ret rm if id==`i' & estimation_window==1
	predict p if id==`i'
	replace predicted_return=p if id==`i' & post_window5==1
	drop p
}
/* test significance */
sort id Date
gen abnormal_return=ret-predicted_return if post_window5==1
by id: egen cumulative_abnormal_return=total(abnormal_return)
by id: egen ar_sd=sd(abnormal_return)
gen test=(1/sqrt(7))*(cumulative_abnormal_return)
reg cumulative_abnormal_return if dif==0, robust
mean(cumulative_abnormal_return) if cumulative_abnormal_return<0
mean(cumulative_abnormal_return) if cumulative_abnormal_return>0
/* collaborate all vars */
rename cumulative_abnormal_return CAR
keep if datenum==1
keep Stock ID CAR
save CAR_5.dta,replace


//(4.3) 10daypost
use EventStudy.dta,clear
gen predicted_return=.
egen id=group(ID)
sum id
forvalues i=1(1)2608 {
	reg ret rm if id==`i' & estimation_window==1
	predict p if id==`i'
	replace predicted_return=p if id==`i' & post_window10==1
	drop p
}
/* test significance */
sort id Date
gen abnormal_return=ret-predicted_return if post_window10==1
by id: egen cumulative_abnormal_return=total(abnormal_return)
by id: egen ar_sd=sd(abnormal_return)
gen test=(1/sqrt(7))*(cumulative_abnormal_return)
reg cumulative_abnormal_return if dif==0, robust
mean(cumulative_abnormal_return) if cumulative_abnormal_return<0
mean(cumulative_abnormal_return) if cumulative_abnormal_return>0
/* collaborate all vars */
rename cumulative_abnormal_return CAR
keep if datenum==1
keep Stock ID CAR
save CAR_10.dta,replace


//(4.4) 15daypost
use EventStudy.dta,clear
gen predicted_return=.
egen id=group(ID)
sum id
forvalues i=1(1)2608 {
	reg ret rm if id==`i' & estimation_window==1
	predict p if id==`i'
	replace predicted_return=p if id==`i' & post_window15==1
	drop p
}
/* test significance */
sort id Date
gen abnormal_return=ret-predicted_return if post_window15==1
by id: egen cumulative_abnormal_return=total(abnormal_return)
by id: egen ar_sd=sd(abnormal_return)
gen test=(1/sqrt(7))*(cumulative_abnormal_return)
reg cumulative_abnormal_return if dif==0, robust
mean(cumulative_abnormal_return) if cumulative_abnormal_return<0
mean(cumulative_abnormal_return) if cumulative_abnormal_return>0
/* collaborate all vars */
rename cumulative_abnormal_return CAR
keep if datenum==1
keep Stock ID CAR
save CAR_15.dta,replace




//(5) Main Regression
use CAR_15.dta,clear
merge 1:1 Stock using SME
drop if _merge==2
drop _merge
merge 1:1 Stock using Subsid
drop if _merge==2
drop _merge
replace subsid=0 if subsid==.
gen sub_SH=1 if subsid>0
replace sub_SH=0 if sub_SH==.
merge 1:1 Stock using sizeBM
drop if _merge==2
drop _merge
merge 1:m Stock using Supply
drop if _merge==2
drop _merge
replace SHsupply=0 if SHsupply==.
gen SHprov=1 if prov==310000
replace SHprov=0 if SHprov==.
gen pharma=1 if indus==27
replace pharma=0 if pharma==.
sort prov indus
save CAR15.dta



/*
use CAR10.dta,clear
reg CAR SME subsid SHsupply i.prov i.indus,robust
estadd local indus "Yes"
estadd local prov "Yes"
est store m1
reg CAR SME sub_SH SHsupply i.prov i.indus, robust
estadd local indus "Yes"
estadd local prov "Yes"
est store m2

reghdfe CAR sub_SH SHsupply ln_assets ln_emp Leverage SOE ln_board Duality,absorb(prov indus) cluster(prov indus)
estadd local indus "Yes"
estadd local prov "Yes"
est store m3
reghdfe CAR subsid sub_SH SHsupply size BMrate ln_assets ln_emp Leverage SOE ln_board Duality,absorb(prov indus) cluster(prov indus)
estadd local indus "Yes"
estadd local prov "Yes"
est store m4
reghdfe CAR sub_SH SHsupply pharma ln_assets ln_emp Leverage SOE ln_board Duality,absorb(prov) vce(robust)
estadd local indus "No"
estadd local prov "Yes"
est store m5

local s "using Table_10.rtf"
local m "m1 m2 m3 m4 m5"
local mt "subsid sub_SH Controls Factors Pharma"
esttab `m' `s',mtitle(`mt') b(%6.3f) nogap compress ///
	star(* 0.1 ** 0.05 *** 0.01) ///
	drop(*.indus *.prov) ///
	ar2 scalar(N indus prov)
	*/

//(6) Statistical Description
use CAR15.dta,clear
logout,save(stats_15) word: tabstat CAR SME subsid sub_SH SHsupply SHprov ln_assets ln_emp Leverage SOE Duality ln_board ln_inc size BMrate pharma, stats(n mean sd min max) columns(stats)


use CAR15.dta,clear
reg CAR, robust
mean(CAR) if CAR<0
mean(CAR) if CAR>0
reg CAR if SME==1
reg CAR if SME==0
count if CAR<0
count if CAR>0
count if CAR<0 & SME==1
count if CAR>0 & SME==1
count if CAR<0 & SME==0
count if CAR>0 & SME==0




//(7) Heterogeneity: Interaction effect
use CAR15.dta,clear
gen SOE_sub=SOE*sub_SH
gen SOE_sup=SOE*SHsupply
gen SOE_SME=SOE*SME
gen SME_sub=SME*sub_SH
gen SME_SH=SME*SHprov
gen BMsup=BMrate*SHsupply
gen SME_lev=SME*Leverage

reg CAR SME subsid SHsupply i.prov i.indus,robust
estadd local indus "Yes"
estadd local prov "Yes"
est store m1
reg CAR SME sub_SH SHsupply i.prov i.indus, robust
estadd local indus "Yes"
estadd local prov "Yes"
est store m2
reghdfe CAR sub_SH SHsupply SME ln_assets ln_emp Leverage SOE ln_board Duality,absorb(prov indus) cluster(prov indus)
estadd local indus "Yes"
estadd local prov "Yes"
est store m3
reghdfe CAR sub_SH SHsupply SME pharma ln_assets ln_emp Leverage SOE,absorb(prov) vce(robust)
estadd local indus "No"
estadd local prov "Yes"
est store m4
reghdfe CAR sub_SH SHsupply SME SOE_SME SOE_sup SME_lev size BMrate ln_assets ln_emp Leverage SOE,absorb(prov indus) cluster(prov indus)
estadd local indus "Yes"
estadd local prov "Yes"
est store m5
local s "using Table15.rtf"
local m "m1 m2 m3 m4 m5"
local mt "subsid sub_SH Controls Pharma Interaction"
esttab `m' `s',mtitle(`mt') b(%6.3f) nogap compress ///
	star(* 0.1 ** 0.05 *** 0.01) ///
	ar2 scalar(N indus prov)







//(8) DID
use EventStudy.dta,clear
by ID: gen before_window1=1 if dif==-1
by ID: gen before_window5=1 if dif<-1 & dif>-5
by ID: gen before_window10=1 if dif<-5 & dif>-10
by ID: gen before_window15=1 if dif<-10 & dif>-15
replace before_window1=0 if before_window1==.
replace before_window5=0 if before_window5==.
replace before_window10=0 if before_window10==.
replace before_window15=0 if before_window15==.
save EventDID.dta,replace

//(8.1) 1daybefore
use EventDID.dta,clear
gen predicted_return=.
egen id=group(ID)
sum id
forvalues i=1(1)2608 {
	reg ret rm if id==`i' & estimation_window==1
	predict p if id==`i'
	replace predicted_return=p if id==`i' & before_window1==1
	drop p
}
/* test significance */
sort id Date
gen abnormal_return=ret-predicted_return if before_window1==1
by id: egen cumulative_abnormal_return=total(abnormal_return)
by id: egen ar_sd=sd(abnormal_return)
gen test=(1/sqrt(7))*(cumulative_abnormal_return)
reg cumulative_abnormal_return if dif==0, robust
mean(cumulative_abnormal_return) if cumulative_abnormal_return<0
mean(cumulative_abnormal_return) if cumulative_abnormal_return>0
/* collaborate all vars */
rename cumulative_abnormal_return CARd
keep if datenum==1
keep Stock ID CARd
save CARd_1.dta,replace

/*
gen dCAR=CAR-CARd
sum dCAR if pharma==1
sum dCAR if pharma==0
sum dCAR if SHsupply==1
sum dCAR if SHsupply==0

reghdfe dCAR sub_SH SHsupply pharma size BMrate ln_assets ln_emp Leverage SOE ln_board Duality,absorb(prov) vce(robust)
*/


//(8.2) 5daybefore
use EventDID.dta,clear
gen predicted_return=.
egen id=group(ID)
sum id
forvalues i=1(1)2608 {
	reg ret rm if id==`i' & estimation_window==1
	predict p if id==`i'
	replace predicted_return=p if id==`i' & before_window5==1
	drop p
}
/* test significance */
sort id Date
gen abnormal_return=ret-predicted_return if before_window5==1
by id: egen cumulative_abnormal_return=total(abnormal_return)
by id: egen ar_sd=sd(abnormal_return)
gen test=(1/sqrt(7))*(cumulative_abnormal_return)
reg cumulative_abnormal_return if dif==0, robust
mean(cumulative_abnormal_return) if cumulative_abnormal_return<0
mean(cumulative_abnormal_return) if cumulative_abnormal_return>0
/* collaborate all vars */
rename cumulative_abnormal_return CARd
keep if datenum==1
keep Stock ID CARd
save CARd_5.dta,replace

//(8.3) 10daybefore
use EventDID.dta,clear
gen predicted_return=.
egen id=group(ID)
sum id
forvalues i=1(1)2608 {
	reg ret rm if id==`i' & estimation_window==1
	predict p if id==`i'
	replace predicted_return=p if id==`i' & before_window10==1
	drop p
}
/* test significance */
sort id Date
gen abnormal_return=ret-predicted_return if before_window10==1
by id: egen cumulative_abnormal_return=total(abnormal_return)
by id: egen ar_sd=sd(abnormal_return)
gen test=(1/sqrt(7))*(cumulative_abnormal_return)
reg cumulative_abnormal_return if dif==0, robust
mean(cumulative_abnormal_return) if cumulative_abnormal_return<0
mean(cumulative_abnormal_return) if cumulative_abnormal_return>0
/* collaborate all vars */
rename cumulative_abnormal_return CARd
keep if datenum==1
keep Stock ID CARd
save CARd_10.dta,replace


//(8.4) 15daybefore
use EventDID.dta,clear
gen predicted_return=.
egen id=group(ID)
sum id
forvalues i=1(1)2608 {
	reg ret rm if id==`i' & estimation_window==1
	predict p if id==`i'
	replace predicted_return=p if id==`i' & before_window15==1
	drop p
}
/* test significance */
sort id Date
gen abnormal_return=ret-predicted_return if before_window15==1
by id: egen cumulative_abnormal_return=total(abnormal_return)
by id: egen ar_sd=sd(abnormal_return)
gen test=(1/sqrt(7))*(cumulative_abnormal_return)
reg cumulative_abnormal_return if dif==0, robust
mean(cumulative_abnormal_return) if cumulative_abnormal_return<0
mean(cumulative_abnormal_return) if cumulative_abnormal_return>0
/* collaborate all vars */
rename cumulative_abnormal_return CARd
keep if datenum==1
keep Stock ID CARd
save CARd_15.dta,replace


/////// DID Regression
use CAR15.dta,clear
merge m:1 Stock using CARd_15
drop _merge
drop CAR
rename CARd CAR
gen post=0
save DID15.dta,replace

use CAR15.dta,clear
gen post=1
append using DID15.dta

gen did=post*SME
replace did=0 if did==.

gen sup_did=post*SHsupply
replace sup_did=0 if sup_did==.
gen ddd=SME*SHprov*post
replace ddd=0 if ddd==.

reghdfe CAR did post SME SHsupply size BMrate ln_assets ln_emp Leverage SOE ln_board Duality,absorb(prov indus) cluster(prov indus)
estadd local indus "Yes"
estadd local prov "Yes"
est store m1
reghdfe CAR did post SME SHsupply size BMrate pharma ln_assets ln_emp Leverage SOE ln_board Duality,absorb(prov) vce(robust)
estadd local indus "No"
estadd local prov "Yes"
est store m2
reghdfe CAR did ddd post sup_did SME SHsupply size BMrate ln_assets ln_emp Leverage SOE ln_board,absorb(prov indus) cluster(prov indus)
estadd local indus "Yes"
estadd local prov "Yes"
est store m3
reghdfe CAR did ddd post sup_did SME SHsupply size BMrate pharma ln_assets ln_emp Leverage SOE ln_board,absorb(prov) vce(robust)
estadd local indus "No"
estadd local prov "Yes"
est store m4
local s "using TableDID10.rtf"
local m "m1 m2 m3 m4"
local mt "DID Pharma DDD +Pharma"
esttab `m' `s',mtitle(`mt') b(%6.3f) nogap compress ///
	star(* 0.1 ** 0.05 *** 0.01) ///
	ar2 scalar(N indus prov)


/////DID plot
use CAR01.dta,clear
gen time=1
save CAR01plot.dta,replace
use DID01.dta,clear
drop post
gen time=-1
save DID01plot.dta,replace
use CAR05.dta,clear
gen time=5
save CAR05plot.dta,replace
use DID05.dta,clear
drop post
gen time=-5
save DID05plot.dta,replace
use CAR10.dta,clear
gen time=10
save CAR10plot.dta,replace
use DID10.dta,clear
drop post
gen time=-10
save DID10plot.dta,replace
use CAR15.dta,clear
gen time=15
save CAR15plot.dta,replace
use DID15.dta,clear
drop post
gen time=-15
save DID15plot.dta,replace

use CAR01plot.dta,clear
append using DID01plot.dta
append using CAR05plot.dta
append using DID05plot.dta
append using CAR10plot.dta
append using DID10plot.dta
append using CAR15plot.dta
append using DID15plot.dta

logout,save(stats) word: bysort time SME: tabstat CAR, stats(mean sd) columns(stats)
twoway (scatter CAR time if SME==0, mc(grey))(lfit CAR time if SME==0,lpattern(longdash) lwidth(medium thick))(scatter CAR time if SME==1, mc(green) msymbol(square))(lfit CAR time if SME==1),ytitle("CAR")xtitle("time")legend(label(1 "控制组") label(2 "控制组拟合线") label(3 "处理组") label(4 "处理组拟合线"))
graph export "didSME.png", as(png) name("Graph")
twoway (scatter CAR time if SME==1 & SOE==1, mc(green) msymbol(square))(lfit CAR time if SME==1 & SOE==1)(scatter CAR time if SME==1 & SOE==0, mc(grey))(lfit CAR time if SME==1 & SOE==0,lpattern(longdash) lwidth(medium thick)),ytitle("CAR")xtitle("time")legend(label(1 "处理组") label(2 "处理组拟合线") label(3 "控制组") label(4 "控制组拟合线"))
graph export "didSOE.png", as(png) name("Graph")

