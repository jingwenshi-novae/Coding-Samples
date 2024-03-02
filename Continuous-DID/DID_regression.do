
clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\RAs\0221 Work with proverb Updated"
cd "$myPATH\DID_50 year"


**# DID regressions #

///////////////////////////////////////
/*          DID Regressions          */
///////////////////////////////////////

********** DID regression (first without controls: xtdidregress)

foreach v in no_steam prop_manuf no_mill_1838 d_mill_1838 mills QJEmill pro_mill_1788 pro_mill_1838 ch_pro_mill_1 Thresh_machines labforce1851_cnty urban1851_cnty Patents MktInt {
	use Bert88_DID_50y.dta,clear

	xtdidregress (Nindex_0) (post_`v', continuous), group(CNTY) time(post)
	** alternative: time(time)
	outreg2 using "output\DID_`v'", replace dta dec(4) title(ALL)

	forvalues i=0(1)87{
			xtdidregress (Nindex_`i') (post_`v', continuous), group(CNTY) time(post)
			** alternative: time(time)

		outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
	}
	use "output\DID_`v'_dta",clear
	export excel using "output\88DID_50y" , sheet("`v'",replace)
}


****** DID regressions with time-variant controls: Market, popdens

foreach v in no_steam prop_manuf no_mill_1838 d_mill_1838 mills QJEmill pro_mill_1788 pro_mill_1838 sum_mill_1788 sum_mill_1838 ch_pro_mill_1 Thresh_machines labforce1851_cnty urban1851_cnty Patents MktInt {
	use Bert88_DID_50y.dta,clear
	
	reg Nindex_0 post_`v' post `v'  Market popdens, robust
	** alternative: reg Nindex_0 post_`v' `v' Market popdens i.time, robust
	outreg2 using "output\DID_`v'", replace dta dec(4) title(ALL)

	forvalues i=0(1)87{
		reg Nindex_`i' post_`v' post `v'  Market popdens, robust
		** alternative: reg Nindex_`i' post_`v' `v' Market popdens i.time, robust
		outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
	}
	use "output\DID_`v'_dta",clear
	export excel using "output\88DID_control_50y" , sheet("`v'",replace)
}


