clear
clear matrix
set more off


ssc install ivreghdfe, replace
ssc install eventcoefplot, replace
ssc install tuples,replace
ssc install eststo,replace


global myPATH "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters"
cd "$myPATH\Pre-condition (change over time)"

* Check Pre-conditions

* b) Did the relationship changeover time?

use 44_CNTY_IR_period.dta,clear


gen mkt13_1600=MarketsBefore1349*per1600
gen mkt13_1650=MarketsBefore1349*per1650
gen mkt13_1700=MarketsBefore1349*per1700

gen mkt16_1600=Market_1600*per1600
gen mkt16_1650=Market_1600*per1650
gen mkt16_1700=Market_1600*per1700

save 44_CNTY_IR_periodreg.dta,replace



use 44_CNTY_IR_periodreg.dta,clear
forvalues i=0(1)42 {
	eventcoefplot cluster_pub_`i', window(mkt13_1600 mkt13_1650 mkt13_1700) legend(off) command controls(log_dist_lon log_river log_coast oceandummy whe feasibility_general percarable1290)
	graph export "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters\Building datasets\event_plot\mkt13_cluspub_`i'.png", as(png) name("Graph")
	eventcoefplot per_allcluster_`i', window(mkt13_1600 mkt13_1650 mkt13_1700) legend(off) command controls(log_dist_lon log_river log_coast oceandummy whe feasibility_general percarable1290)
	graph export "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters\Building datasets\event_plot\mkt13_perall_`i'.png", as(png) name("Graph")
	eventcoefplot cluster_pub_`i', window(mkt16_1600 mkt16_1650 mkt16_1700) legend(off) command controls(log_dist_lon log_river log_coast oceandummy whe feasibility_general percarable1290)
	graph export "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters\Building datasets\event_plot\mkt16_cluspub_`i'.png", as(png) name("Graph")
	eventcoefplot per_allcluster_`i', window(mkt16_1600 mkt16_1650 mkt16_1700) legend(off) command controls(log_dist_lon log_river log_coast oceandummy whe feasibility_general percarable1290)
	graph export "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters\Building datasets\event_plot\mkt16_perall_`i'.png", as(png) name("Graph")
}
