

clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\RAs\0221 Work with proverb Updated"
cd "$myPATH\DID_50 year"


**# Flexible DID regressions #

use Bert88_DID_50y.dta,clear

forvalues i=0(1)87 {
	foreach v in no_steam prop_manuf no_mill_1838 d_mill_1838 mills QJEmill pro_mill_1788 pro_mill_1838 ch_pro_mill_1 Thresh_machines labforce1851_cnty urban1851_cnty Patents MktInt {
		foreach x in 1550 1600 1650 1700 1750 1800 1850 1900{
			gen `v'_`x'=`v'*[time==`x']
		}
			drop `v'_1550
			reg Nindex_`i' `v'_* `v' Market popdens i.time, robust

			coefplot, baselevels keep(`v'_*) vertical coeflabels(`v'_1600=1600 `v'_1650=1650 `v'_1700=1700 `v'_1750=1750 `v'_1800=1800 `v'_1850=1850 `v'_1900=1900) yline(0,lwidth(vthin) lpattern(dash) lcolor(teal)) xline(10,lwidth(vthin) lpattern(dash) lcolor(teal)) ylabel(,labsize(*0.85) angle(0)) xlabel(,labsize(*0.75)) ytitle("Coefficients") xtitle("Time") msymbol(O) msize(small) mcolor(gs1) addplot(line @b @at,lcolor(gs1) lwidth(medthick)) ciopts(recast(rcap) lwidth(thin) lpattern(dash) lcolor(gs2)) graphregion(color(white))
			graph export "C:\Users\Jingwen Shi\Desktop\RAs\0221 Work with proverb Updated\DID_50 year\Parallel trend graph\Cluster`i'_`v'.pdf", as(pdf) name("Graph") replace
			drop `v'_*
	}
}
