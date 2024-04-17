
clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\RAs\0314 Using 88 clusters"
cd "$myPATH\DID"


**# Flexible DID regressions #

use 88_CNTY_DID.dta,clear
encode county, gen(cnty)


forvalues i=0(1)87 {
	foreach v in no_steam prop_manuf {
		foreach x in 1550 1600 1650 1800 1850 1900{
			gen `v'_`x'=`v'*[time==`x']
		}
			reg Nindex_`i' `v'_* i.england i.time i.cnty, robust
			
			foreach x in 1550 1600 1650{
				gen b_`x'=_b[`v'_`x']
			}
			gen avg_coef=(b_1550+b_1600+b_1650)/3
			su avg_coef

			coefplot, baselevels keep(`v'_*) vertical coeflabels(`v'_1550=1550 `v'_1600=1600 `v'_1650=1650 `v'_1800=1800 `v'_1850=1850 `v'_1900=1900) yline(0,lwidth(vthin) lpattern(dash) lcolor(teal)) xline(4,lwidth(vthin) lpattern(dash) lcolor(teal)) ylabel(,labsize(*0.85) angle(0)) xlabel(,labsize(*0.75)) ytitle("Coefficients") xtitle("Time") transform(*=@-r(mean)) msymbol(O) msize(small) mcolor(gs1) addplot(line @b @at,lcolor(gs1) lwidth(medthick)) ciopts(recast(rcap) lwidth(thin) lpattern(dash) lcolor(gs2) msize(mdedium)) graphregion(color(white)) scheme(s1mono)
			graph export "C:\Users\Jingwen Shi\Desktop\RAs\0314 Using 88 clusters\DID\graph\nocontrol`i'_`v'.pdf", as(pdf) name("Graph") replace
			drop `v'_* b_* avg_coef
	}
}






use 88_CNTY_DID.dta,clear
encode county, gen(cnty)

forvalues i=0(1)87 {
	foreach v in no_steam prop_manuf {
		foreach x in 1550 1600 1650 1800 1850 1900{
			gen `v'_`x'=`v'*[time==`x']
		}
			reg Nindex_`i' `v'_* market popdens distnews c.barley_index#c.multiplier c.river_dist#c.multiplier c.elevation#c.multiplier c.port_dist#c.multiplier c.coast_dist#c.multiplier i.england i.time i.cnty, robust
			
			foreach x in 1550 1600 1650{
				gen b_`x'=_b[`v'_`x']
			}
			gen avg_coef=(b_1550+b_1600+b_1650)/3
			su avg_coef

			coefplot, baselevels keep(`v'_*) vertical coeflabels(`v'_1550=1550 `v'_1600=1600 `v'_1650=1650 `v'_1800=1800 `v'_1850=1850 `v'_1900=1900) yline(0,lwidth(vthin) lpattern(dash) lcolor(teal)) xline(4,lwidth(vthin) lpattern(dash) lcolor(teal)) ylabel(,labsize(*0.85) angle(0)) xlabel(,labsize(*0.75)) ytitle("Coefficients") xtitle("Time") transform(*=@-r(mean)) msymbol(O) msize(small) mcolor(gs1) addplot(line @b @at,lcolor(gs1) lwidth(medthick)) ciopts(recast(rcap) lwidth(thin) lpattern(dash) lcolor(gs2) msize(mdedium)) graphregion(color(white)) scheme(s1mono)
			graph export "C:\Users\Jingwen Shi\Desktop\RAs\0314 Using 88 clusters\DID\graph\withcontrol`i'_`v'.pdf", as(pdf) name("Graph") replace
			drop `v'_* b_* avg_coef
	}
}
