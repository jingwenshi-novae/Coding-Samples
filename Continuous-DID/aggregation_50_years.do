
clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\RAs\0221 Work with proverb Updated"
cd "$myPATH\DID_50 year"

///////////////////////////////////
/*   Aggregation on 50 years     */
///////////////////////////////////

use DID_all_vars_new,clear

gen time=1550 if year>=1550 & year<1600
replace time=1600 if year>=1600 & year<1650
replace time=1650 if year>=1650 & year<=1700
replace time=1700 if year>1700 & year<1750
replace time=1750 if year>=1750 & year<1800
replace time=1800 if year>=1800 & year<1850
replace time=1850 if year>=1850 & year<1900
replace time=1900 if year>=1900 & year<1950

** Mean(proverb/title) and Mean(issue/newspaper)

forvalues i=0(1)87 {

}
forvalues i=0(1)87 {
	gen aggproverb_`i'=.
	gen aggtitle_`i'=.
	gen index_`i'=.
	gen Nindex_`i'=.
	bysort county year: egen proverb_`i'=sum(cnty_clus_prov) if cluster_assignment==`i'
	replace proverb_`i'=0 if proverb_`i'==.
	bysort county year: egen title_`i'=sum(cnty_clus_title) if cluster_assignment==`i'
	replace title_`i'=0 if title_`i'==.
	foreach v in 1550 1600 1650{
		bysort county: egen aggproverb_`i'_`v'=sum(proverb_`i') if time==`v' & cluster_assignment==`i'
		replace aggproverb_`i'=aggproverb_`i'_`v' if time==`v' & cluster_assignment==`i'
		replace aggproverb_`i'=0 if aggproverb_`i'==. & time==`v' & cluster_assignment==`i'
		bysort county: egen aggtitle_`i'_`v'=sum(title_`i') if time==`v' & cluster_assignment==`i'
		replace aggtitle_`i'=aggtitle_`i'_`v' if time==`v' & cluster_assignment==`i'
		replace aggtitle_`i'=0 if aggtitle_`i'==. & time==`v' & cluster_assignment==`i'
		drop aggproverb_`i'_`v' aggtitle_`i'_`v'
	}
	replace index_`i'=aggproverb_`i'/aggtitle_`i' if cluster_assignment==`i' & index_`i'==.
	replace index_`i'=0 if index_`i'==. & cluster_assignment==`i'
	egen max_`i'=max(index_`i')
	egen min_`i'=min(index_`i')
	replace Nindex_`i'=(index_`i'-min_`i')/(max_`i'-min_`i')
	drop max*  min*
}
drop index* aggproverb* aggtitle*


forvalues i=0(1)87 {
	gen index2_`i'=.
	gen aggissue_`i'=.
	gen aggnews_`i'=.
	bysort county year: egen issue_`i'=sum(cnty_clus_issue) if cluster_assignment==`i'
	replace issue_`i'=0 if issue_`i'==.
	bysort county year: egen news_`i'=sum(cnty_clus_news) if cluster_assignment==`i'
	replace news_`i'=0 if news_`i'==.
	foreach v in 1700 1750 1800 1850 1900{
		bysort county: egen aggissue_`i'_`v'=sum(issue_`i') if time==`v' & cluster_assignment==`i'
		replace aggissue_`i'=aggissue_`i'_`v' if time==`v' & cluster_assignment==`i'
		replace aggissue_`i'=0 if aggissue_`i'==. & time==`v' & cluster_assignment==`i'
		bysort county: egen aggnews_`i'_`v'=sum(news_`i') if time==`v' & cluster_assignment==`i'
		replace aggnews_`i'=aggnews_`i'_`v' if time==`v' & cluster_assignment==`i'
		replace aggnews_`i'=0 if aggnews_`i'==. & time==`v' & cluster_assignment==`i'
		drop aggissue_`i'_`v' aggnews_`i'_`v'
	}
	replace index2_`i'=aggissue_`i'/aggnews_`i' if index2_`i'==. & cluster_assignment==`i'
	replace index2_`i'=0 if index2_`i'==. & cluster_assignment==`i'
	egen max_`i'=max(index2_`i')
	egen min_`i'=min(index2_`i')
	replace Nindex_`i'=(index2_`i'-min_`i')/(max_`i'-min_`i') if Nindex_`i'==. | Nindex_`i'==0
	replace Nindex_`i'=0 if Nindex_`i'==.
	bys county time: egen max_Nindex_`i'=max(Nindex_`i')
	drop Nindex_`i'
	rename max_Nindex_`i' Nindex_`i'
	drop max*  min*
}
drop index2* aggissue* aggnews*


bys county time: gen n=_n
keep if n==1
drop n year

save pri.dta,replace

//buquan

use pri.dta,clear
keep if time<=1700
drop Nindex_*
bys county: gen n=_n
keep if n==1
drop n cnty_clus*
save pri1700.dta,replace

use pri.dta,clear
keep if time>=1750
drop Nindex_*
bys county: gen n=_n
keep if n==1
drop n cnty_clus*
save pri1750.dta,replace

use samples.dta,clear
keep if time<=1700
merge m:n county using pri1700
keep if _merge==3
drop _merge
save pro1700.dta,replace
use samples.dta,clear
keep if time>=1750
merge m:n county using pri1750
keep if _merge==3
drop _merge
save pro1750.dta,replace

use samples.dta,clear
merge 1:1 county time using pro1700
drop _merge
merge 1:1 county time using pro1750
drop _merge
save buquan.dta,replace

use pri.dta,clear
merge 1:1 county time using buquan.dta
drop issue* news* proverb* title*
drop cnty_clus_* _merge


** create DID var

gen post=1 if time>=1750
replace post=0 if post==.

save DID_50y.dta,replace

foreach v in no_steam prop_manuf no_mill_1838 d_mill_1838 mills Thresh_machines QJEmill Patents labforce1851_cnty{
	gen post_`v'=post*`v'
}

foreach v in urban1851_cnty MktInt sum_mill_1788 sum_mill_1838 pro_mill_1788 pro_mill_1838 ch_pro_mill_1{
	gen post_`v'=post*`v'
}

******* Compile the final dataset

bys post: sum Nindex_*

encode county, generate (CNTY)
xtset CNTY time

gen popdens=logpopdens1600 if post==0
replace popdens=logpopdens1801 if post==1

foreach v in Market_1600 MktInt {
	egen max_`v'=max(`v')
	egen min_`v'=min(`v')
	gen Normalized_`v'=(`v'-min_`v')/(max_`v'-min_`v')
	drop max* min*
}
gen Market=Normalized_Market_1600 if post==0
replace Market=Normalized_MktInt if post==1
drop Normalized_*

keep county time post Nindex_* no_steam prop_manuf no_mill_1838 d_mill_1838 mills Thresh_machines QJEmill Patents labforce1851_cnty urban1851_cnty MktInt sum_mill_1788 sum_mill_1838 pro_mill_1788 pro_mill_1838 ch_pro_mill_1 post_* CNTY Market popdens

label variable Market "Market pre1750(1600) and post 1750"
label variable popdens "population density pre1750(1600) and post 1750(1801)"

save Bert88_DID_50y.dta,replace

