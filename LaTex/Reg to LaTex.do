clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters"
cd "$myPATH\Determinant Analysis"



////////////////////////////////////
/*      Make the LaTeX Table      */
////////////////////////////////////

** Only Geo controls
foreach i in 3 7 10 13 26 34 36 39 40 {
	use 44_CNTY_IR.dta,clear
	gen cluster_pub=cluster_pub_`i'*100
	reg no_steam cluster_pub coalarea dist_coal slope_percent elevation latitude log_dist_lon log_river log_coast, robust
	estimates store model`i'
}
esttab model3 model7 model10 model13 model26 model34 model36 model39 model40 using "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters\Determinant Analysis\output\steam_Cluspub_geo.tex", b(%9.3f) se(%9.3f) r2(%9.2f) ar2(%9.2f) title("Table1") star(* 0.1 ** 0.05 *** 0.01)replace


** Geo+Agricultural controls
foreach i in 0 3 7 10 13 17 39 42{
	use 44_CNTY_IR.dta,clear
	gen cluster_pub=cluster_pub_`i'*100
	reg no_steam cluster_pub whe feasibility_general percarable1290 tri coalarea dist_coal slope_percent elevation latitude log_dist_lon log_river log_coast, robust
	estimates store model`i'
}
esttab model0 model3 model7 model10 model13 model17 model39 model42 using "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters\Determinant Analysis\output\steam_Cluspub_agr.tex", b(%9.3f) se(%9.3f) r2(%9.2f) ar2(%9.2f) title("Table2") star(* 0.1 ** 0.05 *** 0.01)replace



** Market1349+agr+geo
/*significant*/
foreach i in 3 7 10 13 26 39 42{
	use 44_CNTY_IR.dta,clear
	gen cluster_pub=cluster_pub_`i'*100
	reg no_steam cluster_pub MarketsBefore1349 whe feasibility_general percarable1290 tri coalarea dist_coal slope_percent elevation latitude log_dist_lon log_river log_coast, robust
	estimates store model`i'
}
esttab model3 model7 model10 model13 model26 model39 model42 using "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters\Determinant Analysis\output\steam_Cluspub_mkt13agr.tex", b(%9.3f) se(%9.3f) r2(%9.2f) ar2(%9.2f) title("Table3") star(* 0.1 ** 0.05 *** 0.01)replace

/*random insignificant*/
foreach i in 6 14 18 29 33 34 37{
	use 44_CNTY_IR.dta,clear
	gen cluster_pub=cluster_pub_`i'*100
	reg no_steam cluster_pub MarketsBefore1349 whe feasibility_general percarable1290 tri coalarea dist_coal slope_percent elevation latitude log_dist_lon log_river log_coast, robust
	estimates store model`i'
}
esttab model6 model14 model18 model29 model33 model34 model37 using "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters\Determinant Analysis\output\steam_Cluspub_mkt13agr_insig.tex", b(%9.3f) se(%9.3f) r2(%9.2f) ar2(%9.2f) title("Table4") star(* 0.1 ** 0.05 *** 0.01)replace


*** prop_manuf 1851
/*significant*/
foreach i in 1 2 12 13 20 25 26 29 39{
	use 44_CNTY_IR.dta,clear
	gen cluster_pub=cluster_pub_`i'
	reg prop_manuf cluster_pub MarketsBefore1349 whe feasibility_general percarable1290 tri coalarea dist_coal slope_percent elevation latitude log_dist_lon log_river log_coast, robust
	estimates store model`i'
}
esttab model1 model2 model12 model13 model20 model25 model26 model29 model39 using "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters\Determinant Analysis\output\manuf_Cluspub_mkt13agr.tex", b(%9.3f) se(%9.3f) r2(%9.2f) ar2(%9.2f) title("Table5") star(* 0.1 ** 0.05 *** 0.01)replace

/*random insignificant*/
foreach i in 5 11 16 22 24 33 35 41 42{
	use 44_CNTY_IR.dta,clear
	gen cluster_pub=cluster_pub_`i'
	reg prop_manuf cluster_pub MarketsBefore1349 whe feasibility_general percarable1290 tri coalarea dist_coal slope_percent elevation latitude log_dist_lon log_river log_coast, robust
	estimates store model`i'
}
esttab model5 model11 model16 model22 model24 model33 model35 model41 model42 using "C:\Users\Jingwen Shi\Desktop\RAs\0307 Using 44 clusters\Determinant Analysis\output\manuf_Cluspub_mkt13agr_insig.tex", b(%9.3f) se(%9.3f) r2(%9.2f) ar2(%9.2f) title("Table6") star(* 0.1 ** 0.05 *** 0.01)replace
