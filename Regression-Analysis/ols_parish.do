
clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\RAs"
cd "$myPATH\Ray1617clusters"

/////////////////////////////////////////////
/*      d. Build parish-level dataset      */
/////////////////////////////////////////////

use Parishes1851.dta,clear
rename GAZ_CNTY CNTY
keep CNTY PARISH LATITUDE LONGITUDE
save Parish1851match.dta,replace

use Parish_Normalized_1700_noprov.dta,clear
merge 1:1 CNTY PARISH using Parish1851match.dta
drop if _merge==2
drop _merge

gen county=lower(CNTY)
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

save PARISHmerge.dta,replace

//Merge all datasets
use Market_QJE.dta,clear
rename pla parish
rename STARTcounty CNTY
keep CNTY area parish mill lLStax_pc NrPatents WheatYield enclosed thresh_machines mills agr_share_1831 ind_share_1831 copyhold_count_1850 market_1600
save QJEmerge.dta,replace

use steam_engine.dta,clear
merge 1:1 county using coal
drop _merge
merge 1:1 county using controls
drop _merge
merge 1:1 county using mill_panel
drop _merge
merge 1:1 county using uk_county_data
drop _merge
merge m:n county using PARISHmerge
drop _merge
merge m:n county using clusters_all_county_2
drop cluster cluster_count county_total cluster_total other_freq county_freq log_odds neglogodds cluster_rank freq
bys CNTY PARISH: gen k=_n
drop if k>1
drop if PARISH==""
drop if no_steam==. & _merge!=3
drop _merge k
rename PARISH parish

drop Clon Clat
gen proverb_title=count_proverb/count_title
elabel variable (proverb_title) ("#proverb/#title in this parish")

merge m:n CNTY parish using QJEmerge
drop if _merge==2
bys CNTY parish: gen n=_n
drop if n>1 & agr_share_1831==.
drop n
bys CNTY parish: gen n=_n
bys CNTY parish: gen N=_N
drop if N>1 & n==1 & agr_share_1831==.
drop N n
bys CNTY parish: gen n=_n
keep if n==1
drop _merge n

gen dproverb=1 if count_proverb>0 & count_proverb!=.
replace dproverb=0 if count_proverb==0
/* All parishes in the dataset have "Titles" */

// Label
gen STEAM_ENGINE=.
gen COAL=.
gen CONTROLS=.
gen MILL_PANEL=.
gen UK_COUNTY_DATA=.
gen PARISHmerge=.
gen CLUSTERS_all_county_2=.
gen Market_QJE=.

elabel variable (STEAM_ENGINE COAL CONTROLS MILL_PANEL UK_COUNTY_DATA PARISHmerge CLUSTERS_all_county_2 Market_QJE)("FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME" "FILE NAME")

order county STEAM_ENGINE no_steam COAL fid dist_coal coalarea CONTROLS slope_degree slope_percent tri MktInt elevation latitude log_port log_dist_lon log_river log_urban log_coast england whe dist_lond MILL_PANEL no_mill_1838 d_mill_1838 mills sum_mill_1788 sum_mill_1838 pro_mill_1788 pro_mill_1838 ch_pro_mill_1 ch_pro_mill_2 UK_COUNTY_DATA dlogpopdens1377_1801 logpopdens1377 logpopdens1290 dlogpopdens1290_1801 dlogpopdens1600_1801 logpopdens1600 popdens1600 logpopdens1801 popdens1801 popdens1377 dpopdens1377_1801 cistercianshare relhouses rivershare oceandummy agrquality1_2 logarea region area_camp share_coal roads literacy1851 cistercian cist_dum cist_area Rforest forestshare grass cistercianshare_1530 augustinianshare benedictineshare cluniacshare premonshare logpopdens1377_sq popdens1377_sq CLUSTERS_all_county_2 prop_manuf county_mills county_mill county_issue Market_QJE area mill lLStax_pc NrPatents WheatYield enclosed thresh_machines agr_share_1831 ind_share_1831 copyhold_count_1850 market_1600 PARISHmerge CNTY parish count_proverb count_title LATITUDE LONGITUDE proverb_title dproverb

rename LATITUDE lon
rename LONGITUDE lat /*I mistook lon for lat before...*/
elabel variable (lat lon)("latitude" "longitude")
destring lat,replace
destring lon, replace
save Parish_IR.dta,replace


//////////////////////////////////////////////////
/*   e. proverb use with pre-1750 indicators    */
//////////////////////////////////////////////////

use Parish_IR.dta,clear

// Parish-level popul (indep is county-level) (from uk_county_data)
reg proverb_title logpopdens1600
outreg2 using "output\e", replace dta dec(4) adjr2 title(#proverb/#title)

reg dproverb logpopdens1600
outreg2 using "output\e", append dta dec(4) adjr2 title(dproverb)

reg count_proverb logpopdens1600
outreg2 using "output\e", append dta dec(4) adjr2 title(#proverb)

// Parish-level market (indep is parish-level) (from Market_QJE)
reg proverb_title market_1600
outreg2 using "output\e", append dta dec(4) adjr2 title(#proverb/#title)

reg dproverb market_1600
outreg2 using "output\e", append dta dec(4) adjr2 title(dproverb)

reg count_proverb market_1600
outreg2 using "output\e", append dta dec(4) adjr2 title(#proverb)

use "output\e_dta",clear
export excel using "output\e" , sheet("e1_parish",replace)


// County-level popul
use CNTY_IR.dta,clear
reg proverb_title logpopdens1600
outreg2 using "output\e", replace dta dec(4) adjr2 title(#proverb/#title)

reg count_proverb logpopdens1600
outreg2 using "output\e", append dta dec(4) adjr2 title(#proverb)

// County-level market
reg proverb_title Market_1600
outreg2 using "output\e", append dta dec(4) adjr2 title(#proverb/#title)

reg count_proverb Market_1600
outreg2 using "output\e", append dta dec(4) adjr2 title(#proverb)

use "output\e_dta",clear
export excel using "output\e" , sheet("e2_county",replace)



//////////////////////////////////////////
/*   f. IR with pre-1750 proverb use    */
//////////////////////////////////////////

// County-level IR (from Steam_engine, Coal, Controls, mill_panel, clusters_all_county_2)
use Parish_IR.dta,clear
reg no_steam proverb_title dist_coal slope_degree slope_percent tri MktInt elevation latitude log_port log_dist_lon log_river log_urban log_coast whe dist_lond
outreg2 using "output\f", replace dta dec(4) adjr2 title(no_steam)

foreach v in coalarea prop_manuf county_mills county_issue no_mill_1838 d_mill_1838 mills pro_mill_1788 {
	reg `v' proverb_title dist_coal slope_degree slope_percent tri MktInt elevation latitude log_port log_dist_lon log_river log_urban log_coast whe dist_lond
	outreg2 using "output\f", append dta dec(4) adjr2 title(`v')
}

foreach v in no_steam coalarea prop_manuf county_mills county_issue no_mill_1838 d_mill_1838 mills pro_mill_1788 {
	reg `v' dproverb dist_coal slope_degree slope_percent tri MktInt elevation latitude log_port log_dist_lon log_river log_urban log_coast whe dist_lond
	outreg2 using "output\f", append dta dec(4) adjr2 title(`v')
}

foreach v in no_steam coalarea prop_manuf county_mills county_issue no_mill_1838 d_mill_1838 mills pro_mill_1788 {
	reg `v' count_proverb dist_coal slope_degree slope_percent tri MktInt elevation latitude log_port log_dist_lon log_river log_urban log_coast whe dist_lond
	outreg2 using "output\f", append dta dec(4) adjr2 title(`v')
}

use "output\f_dta",clear
export excel using "output\f" , sheet("f1_county",replace)
/* county-level with no controls: also no significance at all */


// Parish-level IR (from V&V 2013)
use Parish_IR.dta,clear
reg mill proverb_title dist_coal slope_degree slope_percent tri lat log_port log_river log_urban log_coast whe dist_lond market_1600 enclosed
outreg2 using "output\f", replace dta dec(4) adjr2 title(mill)

foreach v in NrPatents WheatYield thresh_machines agr_share_1831 ind_share_1831 copyhold_count_1850 {
	reg `v' proverb_title dist_coal slope_degree slope_percent tri lat log_port log_river log_urban log_coast whe dist_lond market_1600 enclosed
	outreg2 using "output\f", append dta dec(4) adjr2 title(`v')
}

foreach v in mill NrPatents WheatYield thresh_machines agr_share_1831 ind_share_1831 copyhold_count_1850 {
	reg `v' dproverb dist_coal slope_degree slope_percent tri lat log_port log_river log_urban log_coast whe dist_lond market_1600 enclosed
	outreg2 using "output\f", append dta dec(4) adjr2 title(`v')
}

foreach v in mill NrPatents WheatYield thresh_machines agr_share_1831 ind_share_1831 copyhold_count_1850 {
	reg `v' count_proverb dist_coal slope_degree slope_percent tri lat log_port log_river log_urban log_coast whe dist_lond market_1600 enclosed
	outreg2 using "output\f", append dta dec(4) adjr2 title(`v')
}

use "output\f_dta",clear
export excel using "output\f" , sheet("f2_Parish",replace)


/////////////////////////////////////////////////
/*   g. Steam engine coding at Parish-level    */
/////////////////////////////////////////////////

use steam_engine_parish.dta,clear
bys GAZ_CNTY PARISH: gen n=_n
destring Number, replace force
bys GAZ_CNTY PARISH: egen N_steam=sum(Number)
keep if n==1
drop Number n
rename GAZ_CNTY CNTY
save Parish_steam.dta,replace

use Parish_IR.dta,clear
gen PARISH=upper(parish)
merge 1:1 CNTY PARISH using Parish_steam

/*
    Result                      Number of obs
    -----------------------------------------
    Not matched                         1,427
        from master                     1,235  (_merge==1)
        from using                        192  (_merge==2)

    Matched                               131  (_merge==3)
    -----------------------------------------
*/

drop if _merge==2
drop _merge
replace N_steam=0 if N_steam==.

reg N_steam proverb_title dist_coal slope_degree slope_percent tri lat log_port log_river log_urban log_coast whe dist_lond market_1600 enclosed /*not significant at all*/

