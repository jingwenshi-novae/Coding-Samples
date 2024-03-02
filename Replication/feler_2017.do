clear
clear matrix
set more off 
set matsize 800
cd "C:\Users\shiji\Desktop\statistics\Replicate" 

use "20150578R1Data/PublicFinancesGoods.dta", clear

// ********************************************************* //
// Table 1: Local Revenue and Expenditure Shares by Category //
// ********************************************************* //

/* Panel A: Revenue Share by Category */
gen own_in_totrev = 100*lgf_rev_totown_pc/lgf_rev_tot_pc
gen gen_in_totown=100*lgf_rev_gen_own_pc/lgf_rev_totown_pc
gen ttax_in_gen=100*lgf_rev_tottaxes_pc/lgf_rev_gen_own_pc
gen proptax_in_ttax=100*lgf_rev_proptax_pc/lgf_rev_tottaxes_pc
gen salinclictax_in_tax=100*lgf_rev_salesinclictax_pc/lgf_rev_tottaxes_pc
gen othtax_in_tax=100*lgf_rev_othtax_saprop/lgf_rev_tottaxes_pc
gen charge_in_gen=100*lgf_rev_charge_pc/lgf_rev_gen_own_pc
gen othrev_in_totrev=100*lgf_rev_tot_utempli_pc/lgf_rev_gen_own_pc
gen intgov_in_totrev=100*lgf_rev_totig_pc/lgf_rev_tot_pc
gen fedgov_in_intgov=100*lgf_rev_totfedig_pc/lgf_rev_totig_pc
gen stagov_in_intgov=100*lgf_rev_totstateig_pc/lgf_rev_totig_pc
gen locgov_in_intgov=100*lgf_rev_totlocalig_pc/lgf_rev_totig_pc

logout,save(Panel_A_1990) word: tabstat own_in_totrev gen_in_totown ttax_in_gen proptax_in_ttax salinclictax_in_tax othtax_in_tax charge_in_gen othrev_in_totrev intgov_in_totrev fedgov_in_intgov stagov_in_intgov locgov_in_intgov if year==1990, stats(mean sd) columns(stats)

logout,save(Panel_A_2007) word: tabstat own_in_totrev gen_in_totown ttax_in_gen proptax_in_ttax salinclictax_in_tax othtax_in_tax charge_in_gen othrev_in_totrev intgov_in_totrev fedgov_in_intgov stagov_in_intgov locgov_in_intgov if year==2007, stats(mean sd) columns(stats)

/* Panel B: Expenditure Shares by Category */
gen edu_share=100*lgf_exp_toteduc_pc/lgf_exp_tot_pc
gen safe_share=100*lgf_exp_totsafety_pc/lgf_exp_tot_pc
gen wel_share=100*lgf_exp_welfare_pc/lgf_exp_tot_pc
gen hous_share=100*lgf_exp_hou/lgf_exp_tot_pc
gen trans_share=100*lgf_exp_transp_pc/lgf_exp_tot_pc
gen park_share=100*lgf_exp_environ_pc/lgf_exp_tot_pc
gen sew_share=100*lgf_exp_sew_pc/lgf_exp_tot_pc
gen health_share=100*lgf_exp_tothealth_pc/lgf_exp_tot_pc
gen gov_share=100*lgf_exp_gov_pc/lgf_exp_tot_pc
gen int_share=100*lgf_exp_int_debt_pc/lgf_exp_tot_pc
gen nec_share=100*lgf_exp_nec/lgf_exp_tot_pc
gen other_share=100*lgf_exp_utliq_pc/lgf_exp_tot_pc

logout,save(Panel_B_1990) word: tabstat edu_share safe_share wel_share hous_share trans_share park_share sew_share health_share gov_share int_share nec_share other_share if year==1990, stats(mean sd) columns(stats)

logout,save(Panel_B_2007) word: tabstat edu_share safe_share wel_share hous_share trans_share park_share sew_share health_share gov_share int_share nec_share other_share if year==2007, stats(mean sd) columns(stats)

/* Some adjustments in the article */
keep czone year lgf_exp_tot_pc lgf_exp_toteduc_pc lgf_exp_toteduc_psa lgf_rev_totstateig_pc crm_prop_pc1000 lgf_rev_totown_pc shinc_0_30 shinc_30_60 shinc_60plus pov*  median_ownocc_cty_pop_p h_0_149 h_150_299 h_300plus median_rent_cty_pop_p est small medium large lgf_rev_tot_pc lgf_rev_totig_pc lgf_rev_gen_own_pc lgf_rev_tottaxes_pc lgf_rev_proptax_pc lgf_rev_salesinclictax_pc lgf_rev_othtax_saprop lgf_rev_charge_pc lgf_rev_tot_utempli_pc lgf_exp_gen_pc lgf_exp_totsafety_pc lgf_exp_welfare_pc lgf_exp_hou lgf_exp_transp_pc lgf_exp_environ_pc lgf_exp_sew_pc lgf_exp_oth_pc lgf_exp_utliq_pc crm_violent_pc1000 *pupil_teacher* lgf_exp_welfhou_pc lgf_rev_emp_pc lgf_rev_util_pc  lgf_rev_liq_pc

gen t=.
for any 1 2 3 \ any 1990 2000 2007 : replace t=X if year==Y
tsset czone t
foreach v of var lgf_exp_tot_pc lgf_exp_toteduc_pc lgf_exp_toteduc_psa lgf_rev_totstateig_pc crm_prop_pc1000 lgf_rev_totown_pc shinc_0_30 shinc_30_60 shinc_60plus pov*  median_ownocc_cty_pop_p h_0_149 h_150_299 h_300plus median_rent_cty_pop_p est small medium large lgf_rev_tot_pc lgf_rev_totig_pc lgf_rev_gen_own_pc lgf_rev_tottaxes_pc lgf_rev_proptax_pc lgf_rev_salesinclictax_pc lgf_rev_othtax_saprop lgf_rev_charge_pc lgf_rev_tot_utempli_pc lgf_exp_gen_pc lgf_exp_totsafety_pc lgf_exp_welfare_pc lgf_exp_hou lgf_exp_transp_pc lgf_exp_environ_pc lgf_exp_sew_pc lgf_exp_oth_pc lgf_exp_utliq_pc crm_violent_pc1000 lgf_exp_welfhou_pc lgf_rev_emp_pc lgf_rev_util_pc  lgf_rev_liq_pc {
gen ln_`v'=ln(`v')
gen d`v'=F.`v'-`v'
}

foreach v of var ln_* {
gen d`v'=F.`v'-`v'
}

tsset czone t
foreach v of var dln* dshinc_* {
replace `v'=`v'*100
}

foreach v of var  median_* crm_* lgf_* pov* ln_median_* ln_crm_* ln_lgf_*  shinc_*  ln_h_*  h_* ln_small ln_medium ln_large ln_est  {
replace d`v' = (d`v'/7)*10 if year==2000
}

rename year yr
save "20150578R1Data/temp/AdditionalVars", replace


// *************************** //
// Table 2: Summary Statistics //
// *************************** //

use "20150578R1Data/workfile_china.dta", clear
merge 1:1 czone yr using "20150578R1Data/temp/AdditionalVars"

keep if _merge==3
drop _merge
preserve
keep if yr==1990
keep czone statefip city yr timepwt48 reg_*
replace yr=2007
save tempfile,replace
restore
append using tempfile
erase tempfile.dta
sort czone yr
drop t
rename t2 t
replace t=1 if yr==1990
replace t=2 if yr==2000
replace t=3 if yr==2007
xtset czone t
replace timepwt48=L.timepwt48 if yr==2000
replace l_sh_empl_mfg=L.l_sh_empl_mfg+(L.d_sh_empl_mfg*(7/10)) if yr==2007
replace l_avg_hhincsum_pc_pw=L.d_avg_hhincsum_pc_pw*0.7+L.l_avg_hhincsum_pc_pw if yr==2007
replace l_tradeusch_pw=L.l_tradeusch_pw+(L.d_tradeusch_pw*(7/10)) if yr==2007
foreach v in  median_ownocc_cty_pop_p pov_shinpov lgf_rev_proptax_pc lgf_rev_totig_pc lgf_rev_totstateig_pc lgf_rev_tot_pc lgf_exp_tot_pc lgf_exp_toteduc_psa pupil_teacher_v4 pupil_teacher_v5 crm_prop_pc1000 {
replace `v'=L.`v'+(L.d`v'*(7/10)) if yr==2007
}

logout,save(Table2) word: bysort yr: tabstat l_avg_hhincsum_pc_pw pov_shinpov median_ownocc_cty_pop_p lgf_rev_tot_pc lgf_exp_tot_pc lgf_exp_toteduc_psa pupil_teacher_v4 crm_prop_pc1000,stats(mean sd) columns(stats)


// *************************************************** //
// Figure 1: Trade Shocks' Effect on Public Goods 2000 //
// *************************************************** //

use "20150578R1Data/workfile_china.dta", clear
merge 1:1 czone yr using "20150578R1Data/temp/AdditionalVars"
keep if _merge==3
keep if yr==2000

/* Panel A: log home values - log income per capita */
gen lnhhincpc=ln(l_avg_hhincsum_pc_pw)
tw scatter ln_median_ownocc_cty_pop_p lnhhincpc || lfit ln_median_ownocc_cty_pop_p lnhhincpc,ytitle("log home values") xtitle("log income per capita") subtitle("A. Relationship between Home Values and Income")
graph save "Graph" "Figure_1_A.gph"
graph export "Figure_1_A.png", as(png) name("Graph")

/* Panel B: log gov.own revenue per capita - log home values */
tw scatter ln_lgf_rev_totown_pc ln_median_ownocc_cty_pop_p || lfit ln_lgf_rev_totown_pc ln_median_ownocc_cty_pop_p,ytitle("log gov. own revenue per capita") xtitle("log home values")subtitle("B. Relationship between Local Gov. Revenue from Own Sources and Home Values")
graph save "Graph" "Figure_1_B.gph"
graph export "Figure_1_B.png", as(png) name("Graph")

/* Panel C: log gov.expend. per capita - log gov revenue per capita */
tw scatter ln_lgf_exp_tot_pc ln_lgf_rev_tot_pc || lfit ln_lgf_exp_tot_pc ln_lgf_rev_tot_pc,ytitle("log gov. expend. per capita") xtitle("log gov. revenue per capita") subtitle("C. Relationship between Local Gov. Expenditure and Revenue")
graph save "Graph" "Figure_1_C.gph"
graph export "Figure_1_C.png", as(png) name("Graph")

/* Panel D: log educ. expend. per student - log gov. expend. per capita */
tw scatter ln_lgf_exp_toteduc_psa ln_lgf_exp_tot_pc || lfit ln_lgf_exp_toteduc_psa ln_lgf_exp_tot_pc,ytitle("log educ. exp. per student") xtitle("log gov. expend. per capita")subtitle("D.  Relationship between Local Gov. Expenditure and Educ. Expenditure Per Student")
graph save "Graph" "Figure_1_D.gph"
graph export "Figure_1_D.png", as(png) name("Graph")

/* Panel E: Students per teacher - log educ. expend. per student */
tw scatter pupil_teacher_v4 ln_lgf_exp_toteduc_psa || lfit pupil_teacher_v4 ln_lgf_exp_toteduc_psa,ytitle("Students per teacher") xtitle("log educ. exp. per student") subtitle("E. Relationship between Stu-Tea Ratio and Local Gov. Educ. Expend. Per Stu") 
graph save "Graph" "Figure_1_E.gph"
graph export "Figure_1_E.png", as(png) name("Graph")

/* Panel F: log property crime rate - log gov. expend. per capita */
tw scatter ln_crm_prop_pc1000 ln_lgf_exp_tot_pc || lfit ln_crm_prop_pc1000 ln_lgf_exp_tot_pc,ytitle("log property crime rate") xtitle("log pub. safety expend. per capita")subtitle("F. Relationship between Property Crime and Local Gov. Expenditures")
graph save "Graph" "Figure_1_F.gph"
graph export "Figure_1_F.png", as(png) name("Graph")


// **************************************************** //
// Table 3: Comm= Zones with Larg and Smal Trade Shocks //
// **************************************************** //

use "20150578R1Data/workfile_china.dta", clear
merge 1:1 czone yr using "20150578R1Data/temp/AdditionalVars"
keep if _merge==3
drop _merge

keep if yr==2000
gen dlnavg_hhincsum_pc_pw=(ln(d_avg_hhincsum_pc_pw*0.7+l_avg_hhincsum_pc_pw)-ln(l_avg_hhincsum_pc_pw))*10/7*100
xtile quartile = d_tradeusch_pw, nq(4) 
gen topquart=0 if quartile==4
replace topquart=1 if quartile==1
drop if topquart==.

foreach v in d_tradeusch_pw dlnavg_hhincsum_pc_pw dpov_shinpov dln_median_ownocc_cty_pop_p dln_lgf_rev_tot_pc dln_lgf_exp_tot_pc dln_lgf_exp_toteduc_psa dpupil_teacher_v4 dln_crm_prop_pc1000 {
replace `v'=`v'*0.7
}

logout,save(Table_3) word: bysort topquart: tabstat d_tradeusch_pw dlnavg_hhincsum_pc_pw dpov_shinpov dln_median_ownocc_cty_pop_p dln_lgf_rev_tot_pc dln_lgf_exp_tot_pc dln_lgf_exp_toteduc_psa dpupil_teacher_v4 dln_crm_prop_pc1000, stats(mean) columns(stats)


// ****************************************************** //
// Table 4: Effect of ChiImp Exposure on Emp, Inc and Pov //
// ****************************************************** //

use "20150578R1Data/workfile_china.dta", clear
merge 1:1 czone yr using "20150578R1Data/temp/AdditionalVars"
keep if _merge==3
drop _merge

/* Panel_A: Emp and Inc */
ssc install outreg2
foreach v of varlist d_sh_unempl d_sh_nilf relchg_avg_hhincsum_pc_pw relchg_avg_hhincwage_pc_pw relchg_avg_hhinctrans_pc_pw  {
ivregress 2sls `v'  (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2 [aw=timepwt48], cluster(czone)
outreg2 using Table_4_A.doc,cttop(two) tstat bdec(3) tdec(2)
}

/* Panel_B: Inc Distribution and Poverty */
eststo clear
foreach v of varlist dshinc_0_30 dshinc_30_60 dshinc_60plus dpov_shinpov dpov_shchildinpov {
ivregress 2sls `v'  (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2 [aw=timepwt48], cluster(czone)
outreg2 using Table_4_B.doc,cttop(two) tstat bdec(3) tdec(2)
}


// ********************************************************* //
// Table 5: Effect of Chinese Import Exposure on Home Values //
// ********************************************************* //

eststo clear
foreach v of varlist dln_median_ownocc_cty_pop_p dmedian_ownocc_cty_pop_p dh_0_149 dh_150_299 dh_300plus dln_median_rent_cty_pop_p dmedian_rent_cty_pop_p {
ivregress 2sls `v'  (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2 [aw=timepwt48], cluster(czone)
outreg2 using Table_5.doc,cttop(two) tstat bdec(3) tdec(2)
}


// ******************************************************* //
// Table 6: Effect of Chinese Imp Exposure on Bus Activity //
// ******************************************************* //

eststo clear
foreach v of varlist  dln_est dln_small dln_medium dln_large {
replace `v'=0 if `v'==.
ivregress 2sls `v'  (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2 [aw=timepwt48], cluster(czone)
outreg2 using Table_6.doc,cttop(two) tstat bdec(3) tdec(2)
}


// ********************************************************* //
// Table 7: Effect of Chin Imp Exposure on Local Rev Per Cap //
// ********************************************************* //

/* Panel_A: Percent Changes(per capita) */
eststo clear
foreach v of varlist  lgf_rev_tot_pc lgf_rev_totig_pc lgf_rev_totown_pc lgf_rev_gen_own_pc lgf_rev_tottaxes_pc lgf_rev_proptax_pc lgf_rev_salesinclictax_pc lgf_rev_othtax_saprop lgf_rev_charge_pc lgf_rev_tot_utempli_pc {
ivregress 2sls dln_`v' (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2  [aw=timepwt48], cluster(czone) r
outreg2 using Table_7_per.doc,cttop(two) tstat bdec(3) tdec(2)
}

/* Panel_B: Value Changes(per capita) */
eststo clear
foreach v of varlist  lgf_rev_tot_pc lgf_rev_totig_pc lgf_rev_totown_pc lgf_rev_gen_own_pc lgf_rev_tottaxes_pc lgf_rev_proptax_pc lgf_rev_salesinclictax_pc lgf_rev_othtax_saprop lgf_rev_charge_pc lgf_rev_tot_utempli_pc {
ivregress 2sls d`v' (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2  [aw=timepwt48], cluster(czone) r
outreg2 using Table_7_val.doc,cttop(two) tstat bdec(3) tdec(2)
}


// ********************************************************* //
// Table 8: Effect of Chin Imp Exposure on Local Exp Per Cap //
// ********************************************************* //

/* Panel_A: Percent Changes(per capita) */
eststo clear
foreach v of varlist  dln_lgf_exp_tot_pc  dln_lgf_exp_gen_pc dln_lgf_exp_toteduc_pc dln_lgf_exp_totsafety_pc dln_lgf_exp_welfare_pc dln_lgf_exp_hou dln_lgf_exp_transp_pc dln_lgf_exp_environ_pc dln_lgf_exp_sew_pc dln_lgf_exp_oth_pc dln_lgf_exp_utliq_pc {
ivregress 2sls `v' (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2 [aw=timepwt48] , cluster(czone) r
outreg2 using Table_8_A.doc,cttop(two) tstat bdec(3) tdec(2)
}

/* Panel_B: Value changes(per capita) */
eststo clear
foreach v of varlist  dlgf_exp_tot_pc dlgf_exp_gen_pc dlgf_exp_toteduc_pc dlgf_exp_totsafety_pc dlgf_exp_welfare_pc dlgf_exp_hou dlgf_exp_transp_pc    dlgf_exp_environ_pc dlgf_exp_sew_pc dlgf_exp_oth_pc dlgf_exp_utliq_pc {
ivregress 2sls `v' (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2 [aw=timepwt48] , cluster(czone) r
outreg2 using Table_8_B.doc,cttop(two) tstat bdec(3) tdec(2)
}


// ******************************************************* //
// Table 9: Effect of Chin Imp on Local Pub Goods Provision//
// ******************************************************* //

eststo clear
foreach v of varlist    dln_crm_prop_pc1000 dln_crm_violent_pc1000 dpupil_teacher_v4 dpupil_teacher_v5   {
ivregress 2sls `v' (d_tradeusch_pw=d_tradeotch_pw_lag) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2 [aw=timepwt48] , cluster(czone) r
outreg2 using Table_9.doc,cttop(two) tstat bdec(3) tdec(2)
}


// ****************************************************** //
// Table 10: State Level Smoothing Via Intergov Transfers//
// ****************************************************** //

/* Panel_A: Local outcomes on state-level imp prw */
bys statefip yr: egen total_pop_state=total(l_popcount)
gen weight_tradeusch_pw= d_tradeusch_pw*l_popcount/total_pop_state
bys statefip yr: egen st_tradeusch_pw=total(weight_tradeusch_pw)
gen weight_tradeotch_pw= d_tradeotch_pw_lag*l_popcount/total_pop_state
bys statefip yr: egen st_tradeotch_pw=total(weight_tradeotch_pw)

eststo clear
foreach v of varlist dln_lgf_rev_tot_pc dln_lgf_rev_totown_pc dln_lgf_rev_totig_pc dln_lgf_exp_toteduc_pc dpupil_teacher_v4 dln_lgf_exp_transp_pc dln_lgf_exp_welfhou_pc   {
ivregress 2sls `v' (st_tradeusch_pw=st_tradeotch_pw) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2 [aw=timepwt48] , cluster(statefip) r
outreg2 using Table_10_A.doc,cttop(two) tstat bdec(3) tdec(2)
}

/* Panel_B: Local outcomes on CZ and rest of state imp prw */
eststo clear
foreach cz of local czones {
gen h=statefip if czone==`cz'
egen h1=min(h)
drop if czone==`cz'
keep if statefip==h1
}
bys statefip yr: egen total_pop_state_minus=total(l_popcount)
gen weight_tradeotch_pw_minus= d_tradeotch_pw_lag*l_popcount/total_pop_state_minus
bys statefip yr: egen st_tradeotch_pw_m=total(weight_tradeotch_pw_minus)
gen weight_tradeusch_pw_minus= d_tradeusch_pw*l_popcount/total_pop_state_minus
bys statefip yr: egen st_tradeusch_pw_m=total(weight_tradeusch_pw_minus)

foreach v of varlist dln_lgf_rev_tot_pc dln_lgf_rev_totown_pc dln_lgf_rev_totig_pc  dln_lgf_exp_toteduc_pc dpupil_teacher_v4 dln_lgf_exp_transp_pc dln_lgf_exp_welfhou_pc   {
ivregress 2sls `v' (d_tradeusch_pw st_tradeusch_pw_m=d_tradeotch_pw_lag st_tradeotch_pw_m) l_shind_manuf_cbp reg* l_sh_popedu_c l_sh_popfborn l_sh_empl_f l_sh_routine33 l_task_outsource t2 [aw=timepwt48] , cluster(statefip) r
outreg2 using Table_10_B.doc,cttop(two) tstat bdec(3) tdec(2)
}
