
clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\RAs\0314 Using 88 clusters"
cd "$myPATH\DID"


**# DID regressions #

///////////////////////////////////////
/*          DID Regressions          */
///////////////////////////////////////

********** DID regression (first without controls: xtdidregress)

foreach v in no_steam prop_manuf {
	use 88_CNTY_DID.dta,clear
	replace Nindex_0=Nindex_0*100

	xtdidregress (Nindex_0) (post_`v', continuous), group(CNTY) time(post)
	** alternative: time(time)
	outreg2 using "output\DID_`v'", replace dta dec(4) title(ALL)

	forvalues i=1(1)87{
		replace Nindex_`i'=Nindex_`i'*100
		xtdidregress (Nindex_`i') (post_`v', continuous), group(CNTY) time(post)
			** alternative: time(time)

		outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
	}
	use "output\DID_`v'_dta",clear
	export excel using "output\xtdidreg" , sheet("`v'",replace)
}


****** DID regressions with time-variant controls: market, popdens, enclosure;
** and time-invariant controls*time trend: cistercian, pcrelief, countrybank, distnews

foreach v in no_steam prop_manuf {
	use 88_CNTY_DID.dta,clear
	replace Nindex_0=Nindex_0*100
	rename county cnty
	encode cnty, gen (county)
	reg Nindex_0 post_`v' market popdens enclosure c.distnews#c.multiplier c.cistercian#c.multiplier c.pcrelief#c.multiplier c.countrybank#c.multiplier c.barley_index#c.multiplier c.river_dist#c.multiplier c.elevation#c.multiplier c.port_dist#c.multiplier c.coast_dist#c.multiplier i.england i.county i.time, robust
	** alternative: reg Nindex_0 post_`v' `v' Market popdens i.time, robust
	outreg2 using "output\DID_`v'", replace dta dec(4) title(ALL)
	reg Nindex_0 post_`v' market popdens c.distnews#c.multiplier c.barley_index#c.multiplier c.river_dist#c.multiplier c.elevation#c.multiplier c.port_dist#c.multiplier c.coast_dist#c.multiplier i.england i.county i.time, robust
	outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
	reg Nindex_0 post_`v' c.barley_index#c.multiplier c.river_dist#c.multiplier c.elevation#c.multiplier c.port_dist#c.multiplier c.coast_dist#c.multiplier i.england i.county i.time, robust
	outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
	reg Nindex_0 post_`v' i.england i.county i.time, robust
	outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)

	forvalues i=1(1)87{
		replace Nindex_`i'=Nindex_`i'*100
		reg Nindex_`i' post_`v' market popdens enclosure c.distnews#c.multiplier c.cistercian#c.multiplier c.pcrelief#c.multiplier c.countrybank#c.multiplier c.barley_index#c.multiplier c.river_dist#c.multiplier c.elevation#c.multiplier c.port_dist#c.multiplier c.coast_dist#c.multiplier i.england i.county i.time, robust
		** alternative: reg Nindex_`i' post_`v' `v' Market popdens i.time, robust
		outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
		reg Nindex_`i' post_`v' market popdens c.distnews#c.multiplier c.barley_index#c.multiplier c.river_dist#c.multiplier c.elevation#c.multiplier c.port_dist#c.multiplier c.coast_dist#c.multiplier i.england i.county i.time, robust
		outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
		reg Nindex_`i' post_`v' c.barley_index#c.multiplier c.river_dist#c.multiplier c.elevation#c.multiplier c.port_dist#c.multiplier c.coast_dist#c.multiplier i.england i.county i.time, robust
		outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
		reg Nindex_`i' post_`v' i.england i.county i.time, robust
		outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
	}
	use "output\DID_`v'_dta",clear
	export excel using "output\all_controls" , sheet("`v'",replace)
}




// Numerical Flexible

foreach v in no_steam prop_manuf {
	use 88_CNTY_DID.dta,clear
	replace Nindex_0=Nindex_0*100
	foreach x in 1550 1600 1650 1800 1850 1900{
		gen `v'_`x'=`v'*[time==`x']
	}
	drop `v'_1550
	reg Nindex_0 `v' `v'_1600 `v'_1650 `v'_1800 `v'_1850 `v'_1900 i.england i.time, robust
	outreg2 using "output\DID_`v'", replace dta dec(4) title(ALL)
	
	forvalues i=1(1)87 {
		replace Nindex_`i'=Nindex_`i'*100
		reg Nindex_`i' `v' `v'_1600 `v'_1650 `v'_1800 `v'_1850 `v'_1900 i.england i.time, robust
		outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
	}
	use "output\DID_`v'_dta",clear
	export excel using "output\flexible_no_control" , sheet("`v'",replace)
}

			
foreach v in no_steam prop_manuf {
	use 88_CNTY_DID.dta,clear
	replace Nindex_0=Nindex_0*100
	foreach x in 1550 1600 1650 1800 1850 1900{
		gen `v'_`x'=`v'*[time==`x']
	}
	drop `v'_1550
	reg Nindex_0 `v' `v'_1600 `v'_1650 `v'_1800 `v'_1850 `v'_1900 market popdens distnews cistercian enclosure pcrelief countrybank barley_index river_dist elevation port_dist coast_dist i.england i.time, robust
	outreg2 using "output\DID_`v'", replace dta dec(4) title(ALL)
	reg Nindex_0 `v' `v'_1600 `v'_1650 `v'_1800 `v'_1850 `v'_1900 barley_index river_dist elevation port_dist coast_dist i.england i.time, robust
	outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
	
	forvalues i=1(1)87 {
		replace Nindex_`i'=Nindex_`i'*100
		reg Nindex_`i' `v' `v'_1600 `v'_1650 `v'_1800 `v'_1850 `v'_1900 market popdens distnews cistercian enclosure pcrelief countrybank barley_index river_dist elevation port_dist coast_dist i.england i.time, robust
		outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
		reg Nindex_`i' `v' `v'_1600 `v'_1650 `v'_1800 `v'_1850 `v'_1900 barley_index river_dist elevation port_dist coast_dist i.england i.time, robust
		outreg2 using "output\DID_`v'", append dta dec(4) title(ALL)
	}
	use "output\DID_`v'_dta",clear
	export excel using "output\flexible_with_control" , sheet("`v'",replace)
}
			
