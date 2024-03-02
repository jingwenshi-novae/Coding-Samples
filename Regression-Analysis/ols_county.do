clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\RAs"
cd "$myPATH\Ray1617clusters"

/////////////////////////////////////////////
/*      a. Build county-level dataset      */
/////////////////////////////////////////////

use EEBO1_rename.dta,clear
rename proverb_identifier proverb
merge m:n proverb using proverb_clusters
drop if _merge==2
rename proverb proverb_identifier

drop _merge
keep eebo1_id proverb_identifier Identifier cluster_assignment
save Ray_merge.dta,replace

use 1222MAP.dta,clear
merge m:n Identifier using Ray_merge.dta
keep if _merge==3
drop _merge

forvalues i=0(1)63 {
	bys CNTY: egen cluster_`i'_pre=count(cluster_assignment) if cluster_assignment==`i'
	replace cluster_`i'_pre=0 if cluster_`i'_pre==.
	bys CNTY: egen cluster_`i'=max(cluster_`i'_pre)
	drop cluster_`i'_pre
}

forvalues i=0(1)63 {
	gen iscluster_`i'=1 if cluster_`i'>0
	replace iscluster_`i'=0 if iscluster_`i'==.
}

bys CNTY: gen k=_n
bys CNTY: egen pubNum=count(Identifier)
keep if k==1

egen allcluster=rowtotal(cluster*)
forvalues i=0(1)63 {
	gen per_allcluster_`i'=cluster_`i'/allcluster
	gen cluster_pub_`i'=cluster_`i'/pubNum
}

keep CNTY Clon Clat cluster* iscluster* per_allcluster* cluster_pub* allcluster pubNum
order CNTY Clon Clat allcluster pubNum cluster* iscluster* per_allcluster* cluster_pub*
drop cluster_assignment
rename CNTY GAZ_CNTY
save match_Ray1617cluster.dta,replace


// Normalized_1700_noprov_alltitle
use Normalized_1700_noprov.dta,clear
bys GAZ_CNTY: gen k=_n
keep if k==1
keep GAZ_CNTY count_proverb count_title
merge 1:1 GAZ_CNTY using match_Ray1617cluster.dta
keep if _merge==3
drop _merge
save CNTYmerge.dta,replace

// merge with IR

use Market_QJE.dta,clear
rename STARTcounty GAZ_CNTY
bys GAZ_CNTY: egen Market_1600=sum(market_1600)
bys GAZ_CNTY: egen Thresh_machines=sum(thresh_machines)
bys GAZ_CNTY: egen QJEmill=sum(mill)
bys GAZ_CNTY: egen Patents=sum(NrPatents)
bys GAZ_CNTY: gen n=_n
keep if n==1
keep GAZ_CNTY Market_1600 Thresh_machines QJEmill Patents
save QJE_county.dta,replace

use CNTYmerge.dta,clear
merge 1:1 GAZ_CNTY using QJE_county
drop if _merge==2
drop _merge
merge 1:1 GAZ_CNTY using EMP_County
drop _merge

gen county=lower(GAZ_CNTY)

replace county="bedford" if county=="bedfordshire"
replace county="berk" if county=="berkshire"
replace county="brecknock" if county=="brecknockshire"
replace county="buckingham" if county=="buckinghamshire"
replace county="cambridge" if county=="cambridgeshire"
replace county="cardigan" if county=="cardiganshire"
replace county="carmarthen" if county=="carmarthenshire"
replace county="caernarvon" if county=="carnarvonshire"
replace county="che" if county=="cheshire"
replace county="denbigh" if county=="denbighshire"
replace county="derby" if county=="derbyshire"
replace county="flint" if county=="flintshire"
replace county="glamorgan" if county=="glamorganshire"
replace county="gloucester" if county=="gloucestershire"
replace county="hamp" if county=="hampshire"
replace county="hereford" if county=="herefordshire"
replace county="hertford" if county=="hertfordshire"
replace county="huntingdon" if county=="huntingdonshire"
replace county="lanca" if county=="lancashire"
replace county="leicester" if county=="leicestershire"
replace county="lincoln" if county=="lincolnshire"
replace county="merioneth" if county=="merionethshire"
replace county="monmouth" if county =="monmouthshire"
replace county="montgomery" if county=="montgomeryshire"
replace county="northampton" if county=="northamptonshire"
replace county="nottingham" if county=="nottinghamshire"
replace county="oxford" if county=="oxfordshire"
replace county="pembroke" if county=="pembrokeshire"
replace county="radnor" if county=="radnorshire"
replace county="shrop" if county=="shropshire"
replace county="stafford" if county=="staffordshire"
replace county="warwick" if county=="warwickshire"
replace county="wilt" if county=="wiltshire"
replace county="worcester" if county=="worcestershire"
replace county="york, east" if county=="yorkshire, east riding"
replace county="york, north" if county=="yorkshire, north riding"
replace county="york, west" if county=="yorkshire, west riding"

save CNTYmerge_Ray1617clusters.dta,replace


use steam_engine.dta,clear
merge 1:1 county using coal
drop _merge
merge 1:1 county using controls
drop _merge
merge 1:1 county using mill_panel
drop _merge
merge 1:1 county using uk_county_data
drop _merge
merge m:n county using CNTYmerge_Ray1617clusters
drop _merge
merge m:n county using clusters_all_county_2
drop cluster cluster_count county_total cluster_total other_freq county_freq log_odds neglogodds cluster_rank freq
bys county: gen k=_n
drop if k>1
drop if GAZ_CNTY==""
drop if no_steam==. & _merge!=3
drop _merge k

gen proverb_title=count_proverb/count_title

// Label
gen STEAM_ENGINE=.
gen COAL=.
gen CONTROLS=.
gen MILL_PANEL=.
gen UK_COUNTY_DATA=.
gen Ray1617clusters=.
gen CLUSTERS_all_county_2=.
gen Market_QJE_County=.
gen EMP_County=.

elabel variable (STEAM_ENGINE COAL CONTROLS MILL_PANEL UK_COUNTY_DATA Ray1617clusters CLUSTERS_all_county_2 Market_QJE_County EMP_County)("FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME")

order county STEAM_ENGINE no_steam COAL fid dist_coal coalarea CONTROLS slope_degree slope_percent tri MktInt elevation latitude log_port log_dist_lon log_river log_urban log_coast england whe dist_lond MILL_PANEL no_mill_1838 d_mill_1838 mills sum_mill_1788 sum_mill_1838 pro_mill_1788 pro_mill_1838 ch_pro_mill_1 ch_pro_mill_2 UK_COUNTY_DATA dlogpopdens1377_1801 logpopdens1377 logpopdens1290 dlogpopdens1290_1801 dlogpopdens1600_1801 logpopdens1600 popdens1600 logpopdens1801 popdens1801 popdens1377 dpopdens1377_1801 cistercianshare relhouses rivershare oceandummy agrquality1_2 logarea region area_camp share_coal roads literacy1851 cistercian cist_dum cist_area Rforest forestshare grass cistercianshare_1530 augustinianshare benedictineshare cluniacshare premonshare logpopdens1377_sq popdens1377_sq CLUSTERS_all_county_2 prop_manuf county_mills county_mill county_issue Market_QJE_County Market_1600 Thresh_machines QJEmill Patents EMP_County daysgrass feasibility_general countyacreage poppermilesq1290 percarable1290 percarable1836 percgrass1836 percwood1836 perccommon1836 percarable1871 percarable18361871 dmvsper100kacres parishnkuss countyfractionkuss SM_Kussmaul_1561_1640 SM_Kussmaul_1661_1740 SM_Kussmaul_1741_1820 cattle sheep livestockunits Ray1617clusters GAZ_CNTY count_proverb count_title proverb_title Clon Clat


save CNTY_IR.dta,replace


////////////////////////////////////////////////////////
/*   b. pre-1750 clusters with pre-1750 indicators    */
////////////////////////////////////////////////////////

// Population (per_all&clus_pub) (from uk_county_data)
use CNTY_IR.dta,clear
reg per_allcluster_0 logpopdens1600
outreg2 using "output\b", replace dta dec(4) adjr2 title(per_all0)
forvalues i=1(1)63 {
	reg per_allcluster_`i' logpopdens1600
	outreg2 using "output\b", append dta dec(4) adjr2 title(per_all`i')
}
use "output\b_dta",clear
export excel using "output\b" , sheet("b1_pop_perall",replace)

use CNTY_IR.dta,clear
reg cluster_pub_0 logpopdens1600
outreg2 using "output\b", replace dta dec(4) adjr2 title(clus_pub0)
forvalues i=1(1)63 {
	reg cluster_pub_`i' logpopdens1600
	outreg2 using "output\b", append dta dec(4) adjr2 title(clus_pub`i')
}
use "output\b_dta",clear
export excel using "output\b" , sheet("b2_pop_cluspub",replace)


// medieval water mills (from mill_panel)

use CNTY_IR.dta,clear
reg per_allcluster_0 county_mills
outreg2 using "output\b", replace dta dec(4) adjr2 title(per_all0)
forvalues i=1(1)63 {
	reg per_allcluster_`i' county_mills
	outreg2 using "output\b", append dta dec(4) adjr2 title(per_all`i')
}
use "output\b_dta",clear
export excel using "output\b" , sheet("b3_mills_perall",replace)

use CNTY_IR.dta,clear
reg cluster_pub_0 county_mills
outreg2 using "output\b", replace dta dec(4) adjr2 title(clus_pub0)
forvalues i=1(1)63 {
	reg cluster_pub_`i' county_mills
	outreg2 using "output\b", append dta dec(4) adjr2 title(clus_pub`i')
}
use "output\b_dta",clear
export excel using "output\b" , sheet("b4_mills_cluspub",replace)

use CNTY_IR.dta,clear
reg per_allcluster_0 county_mill
outreg2 using "output\b", replace dta dec(4) adjr2 title(per_all0)
forvalues i=1(1)63 {
	reg per_allcluster_`i' county_mill
	outreg2 using "output\b", append dta dec(4) adjr2 title(per_all`i')
}
use "output\b_dta",clear
export excel using "output\b" , sheet("b5_mill_perall",replace)

use CNTY_IR.dta,clear
reg cluster_pub_0 county_mill
outreg2 using "output\b", replace dta dec(4) adjr2 title(clus_pub0)
forvalues i=1(1)63 {
	reg cluster_pub_`i' county_mill
	outreg2 using "output\b", append dta dec(4) adjr2 title(clus_pub`i')
}
use "output\b_dta",clear
export excel using "output\b" , sheet("b6_mill_cluspub",replace)


// Market_1600 (Market_QJE_county)

use CNTY_IR.dta,clear
reg per_allcluster_0 Market_1600
outreg2 using "output\b", replace dta dec(4) adjr2 title(per_all0)
forvalues i=1(1)63 {
	reg per_allcluster_`i' Market_1600
	outreg2 using "output\b", append dta dec(4) adjr2 title(per_all`i')
}
use "output\b_dta",clear
export excel using "output\b" , sheet("b7_market_perall",replace)

use CNTY_IR.dta,clear
reg cluster_pub_0 Market_1600
outreg2 using "output\b", replace dta dec(4) adjr2 title(clus_pub0)
forvalues i=1(1)63 {
	reg cluster_pub_`i' Market_1600
	outreg2 using "output\b", append dta dec(4) adjr2 title(clus_pub`i')
}
use "output\b_dta",clear
export excel using "output\b" , sheet("b8_market_cluspub",replace)



/////////////////////////////////////////
/*    c. IR with pre-1750 clusters     */
/////////////////////////////////////////

/* (from Steam_engine, Coal, Controls, mill_panel, clusters_all_county_2) */

// LASSO_per_all

use CNTY_IR.dta,clear

/* substitude with pre-19th data: MktInt=Market_1600, log_port=oceandummy+log_river+log_coast, dist_coal?, log_urban?, dist_lond x */

/* What is SM_Kussmaul? */

pdslasso no_steam feasibility_general percarable1290 Market_1600 county_mills slope_degree slope_percent tri elevation latitude log_dist_lon log_river log_coast oceandummy whe (per_allcluster*), robust noisily
outreg2 using "output\c", replace dta dec(4) title(no_steam)

foreach v in coalarea prop_manuf no_mill_1838 d_mill_1838 mills pro_mill_1788 Thresh_machines QJEmill Patents{
	pdslasso `v' feasibility_general percarable1290 Market_1600 county_mills slope_degree slope_percent tri elevation latitude log_dist_lon log_river log_coast oceandummy whe (per_allcluster*), robust noisily
	outreg2 using "output\c", append dta dec(4) title(`v')
}
use "output\c_dta",clear
export excel using "output\c64" , sheet("c1_LASSO_perall",replace)

// LASSO_clus_pub
use CNTY_IR.dta,clear

pdslasso no_steam feasibility_general percarable1290 Market_1600 county_mills slope_degree slope_percent tri elevation latitude log_dist_lon log_river log_coast oceandummy whe (cluster_pub*), robust noisily
outreg2 using "output\c", replace dta dec(4) title(no_steam)

foreach v in coalarea prop_manuf no_mill_1838 d_mill_1838 mills pro_mill_1788 Thresh_machines QJEmill Patents{
	pdslasso `v' feasibility_general percarable1290 Market_1600 county_mills slope_degree slope_percent tri elevation latitude log_dist_lon log_river log_coast oceandummy whe (cluster_pub*), robust noisily
	outreg2 using "output\c", append dta dec(4) title(`v')
}
use "output\c_dta",clear
export excel using "output\c64" , sheet("c2_LASSO_cluspub",replace)


// OLS_per_all

/* I didn't substitude the controls of OLS to pre-19th century. */
use CNTY_IR.dta,clear
reg no_steam per_allcluster_0 dist_coal slope_degree slope_percent tri MktInt elevation latitude log_port log_dist_lon log_river log_urban log_coast whe dist_lond
outreg2 using "output\c", replace dta dec(4) title(per_all0)
forvalues i=1(1)63 {
	reg no_steam per_allcluster_`i' dist_coal slope_degree slope_percent tri MktInt elevation latitude log_port log_dist_lon log_river log_urban log_coast whe dist_lond
	outreg2 using "output\c", append dta dec(4) adjr2 title(per_all`i')
}
use "output\c_dta",clear
export excel using "output\c" , sheet("c3_OLS_perall",replace)

// OLS_clus_pub
use CNTY_IR.dta,clear
reg no_steam cluster_pub_0 dist_coal slope_degree slope_percent tri MktInt elevation latitude log_port log_dist_lon log_river log_urban log_coast whe dist_lond
outreg2 using "output\c", replace dta dec(4) title(clus_pub0)
forvalues i=1(1)63 {
	reg no_steam cluster_pub_`i' dist_coal slope_degree slope_percent tri MktInt elevation latitude log_port log_dist_lon log_river log_urban log_coast whe dist_lond
	outreg2 using "output\c", append dta dec(4) adjr2 title(clus_pub`i')
}
use "output\c_dta",clear
export excel using "output\c" , sheet("c4_OLS_cluspub",replace)

