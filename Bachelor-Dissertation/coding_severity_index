clear
clear matrix
set more off

global myPATH "C:\Users\shiji\Desktop\Bachelor dissertation"
cd "$myPATH\index"

import excel "C:\Users\shiji\Desktop\Bachelor dissertation\index\severity_with0.xlsx", sheet("severity_with0") firstrow

xtline severity , overlay t(date) i(area)

sort area date

rename severity sev
rename severity21 sev21
rename severity20_03 sev20_03
rename severity20_0406 sev20_0406
rename severity20_0709 sev20_0709
rename severity20_1012 sev20_1012
rename severity21_0103 sev21_0103
rename impact severity

rename severity impact
rename severity21 impact21
rename severity20_03 impact20_03
rename severity20_0406 impact20_0406
rename severity20_0709 impact20_0709
rename severity20_1012 impact20_1012
rename severity21_0103 impact21_0103

rename sev severity
rename sev21 severity21
rename sev20_03 severity20_03
rename sev20_0406 severity20_0406
rename sev20_0709 severity20_0709
rename sev20_1012 severity20_1012
rename sev21_0103 severity21_0103

//fitting lines with seperate periods
bys area: gen n=_n
twoway (scatter severity date) (lfit severity date if n>=32 & n<=72)(lfit severity date if n>=72 & n<=154)(lfit severity date if n>=154 & n<=246)(lfit severity date if n>=246 & n<=307)(lfit severity date if n>=307 & n<=356)(lfit severity date if n>=356), by (area)


twoway (scatter severity date) (qfit severity date if n>=32 & n<=124)(qfit severity date if n>=124 & n<=216)(qfit severity date if n>=216 & n<=307)(qfit severity date if n>=307 & n<=397)(qfit severity date if n>=397), by (area)

search marginscontplot
ssc install marginscontplot
bys area: reg severity date c.date#c.date c.date#c.date#c.date
marginscontplot date

// minus
xtline sev_minus if n>1, overlay t(date) i(area)
bys area: egen sd20_0103=sd (sev_minus) if n<63
bys area: egen sd20_0406=sd (sev_minus) if n>62 & n<154
bys area: egen sd20_0709=sd (sev_minus) if n>153 & n<246
bys area: egen sd20_1012=sd (sev_minus) if n>245 & n<338
bys area: egen sd21_0103=sd (sev_minus) if n>337

bys area: egen minus20_0103=mean (sev_minus) if n<63
bys area: egen minus20_0406=mean (sev_minus) if n>62 & n<154
bys area: egen minus20_0709=mean (sev_minus) if n>153 & n<246
bys area: egen minus20_1012=mean (sev_minus) if n>245 & n<338
bys area: egen minus21_0103=mean (sev_minus) if n>337

rename severity sev
rename severity21 sev21
rename severity20_03 sev20_03
rename severity20_0406 sev20_0406
rename severity20_0709 sev20_0709
rename severity20_1012 sev20_1012
rename severity21_0103 sev21_0103
rename sev_minus severity

rename severity sev_minus
rename severity21 sd21
rename severity20_03 sd20_0103
rename severity20_0406 sd20_0406
rename severity20_0709 sd20_0709
rename severity20_1012 sd20_1012
rename severity21_0103 sd21_0103

rename sev severity
rename sev21 severity21
rename sev20_03 severity20_03
rename sev20_0406 severity20_0406
rename sev20_0709 severity20_0709
rename sev20_1012 severity20_1012
rename sev21_0103 severity21_0103

// gradient
xtline gradient, overlay t(date) i(area)
/*长时段日环比*/
bys area: gen gradlong1346=(severity20_0406-severity20_03)/severity20_03
bys area: gen gradlong4679=(severity20_0709-severity20_0406)/severity20_0406
bys area: gen gradlong7902=(severity20_1012-severity20_0709)/severity20_0709
bys area: gen gradlong0213=(severity21_0103-severity20_1012)/severity20_1012

// severity21
bys area: gen n=_n
quietly sum severity if area=="East Midlands"
return list
gen severity21=r(mean)
quietly sum severity if area=="East of England"
return list
replace severity21=r(mean) if area=="East of England"
quietly sum severity if area=="North East"
return list
replace severity21=r(mean) if area=="North East"
quietly sum severity if area=="London"
return list
replace severity21=r(mean) if area=="London"
quietly sum severity if area=="North West"
return list
replace severity21=r(mean) if area=="North West"
quietly sum severity if area=="South East"
return list
replace severity21=r(mean) if area=="South East"
quietly sum severity if area=="South West"
return list
replace severity21=r(mean) if area=="South West"
quietly sum severity if area=="West Midlands"
return list
replace severity21=r(mean) if area=="West Midlands"
quietly sum severity if area=="Yorkshire and The Humber"
return list
replace severity21=r(mean) if area=="Yorkshire and The Humber"

//severity20_03
quietly sum severity if area=="East Midlands" & n<63
return list
gen severity20_03=r(mean)
quietly sum severity if area=="East of England" & n<63
return list
replace severity20_03=r(mean) if area=="East of England"
quietly sum severity if area=="North East" & n<63
return list
replace severity20_03=r(mean) if area=="North East"
quietly sum severity if area=="London" & n<63
return list
replace severity20_03=r(mean) if area=="London"
quietly sum severity if area=="North West" & n<63
return list
replace severity20_03=r(mean) if area=="North West"
quietly sum severity if area=="South East" & n<63
return list
replace severity20_03=r(mean) if area=="South East"
quietly sum severity if area=="South West" & n<63
return list
replace severity20_03=r(mean) if area=="South West"
quietly sum severity if area=="West Midlands" & n<63
return list
replace severity20_03=r(mean) if area=="West Midlands"
quietly sum severity if area=="Yorkshire and The Humber" & n<63
return list
replace severity20_03=r(mean) if area=="Yorkshire and The Humber"

//severity20_0406
quietly sum severity if area=="East Midlands" & n>62 & n<154
return list
gen severity20_0406=r(mean)
quietly sum severity if area=="East of England" & n>62 & n<154
return list
replace severity20_0406=r(mean) if area=="East of England"
quietly sum severity if area=="North East" & n>62 & n<154
return list
replace severity20_0406=r(mean) if area=="North East"
quietly sum severity if area=="London" & n>62 & n<154
return list
replace severity20_0406=r(mean) if area=="London"
quietly sum severity if area=="North West" & n>62 & n<154
return list
replace severity20_0406=r(mean) if area=="North West"
quietly sum severity if area=="South East" & n>62 & n<154
return list
replace severity20_0406=r(mean) if area=="South East"
quietly sum severity if area=="South West" & n>62 & n<154
return list
replace severity20_0406=r(mean) if area=="South West"
quietly sum severity if area=="West Midlands" & n>62 & n<154
return list
replace severity20_0406=r(mean) if area=="West Midlands"
quietly sum severity if area=="Yorkshire and The Humber" & n>62 & n<154
return list
replace severity20_0406=r(mean) if area=="Yorkshire and The Humber"


//severity20_0709

quietly sum severity if area=="East Midlands" & n>153 & n<246
return list
gen severity20_0709=r(mean)
quietly sum severity if area=="East of England" & n>153 & n<246
return list
replace severity20_0709=r(mean) if area=="East of England"
quietly sum severity if area=="North East" & n>153 & n<246
return list
replace severity20_0709=r(mean) if area=="North East"
quietly sum severity if area=="London" & n>153 & n<246
return list
replace severity20_0709=r(mean) if area=="London"
quietly sum severity if area=="North West" & n>153 & n<246
return list
replace severity20_0709=r(mean) if area=="North West"
quietly sum severity if area=="South East" & n>153 & n<246
return list
replace severity20_0709=r(mean) if area=="South East"
quietly sum severity if area=="South West" & n>153 & n<246
return list
replace severity20_0709=r(mean) if area=="South West"
quietly sum severity if area=="West Midlands" & n>153 & n<246
return list
replace severity20_0709=r(mean) if area=="West Midlands"
quietly sum severity if area=="Yorkshire and The Humber" & n>153 & n<246
return list
replace severity20_0709=r(mean) if area=="Yorkshire and The Humber"

//severity1012

quietly sum severity if area=="East Midlands" & n>245 & n<338
return list
gen severity20_1012=r(mean)
quietly sum severity if area=="East of England" & n>245 & n<338
return list
replace severity20_1012=r(mean) if area=="East of England"
quietly sum severity if area=="North East" & n>245 & n<338
return list
replace severity20_1012=r(mean) if area=="North East"
quietly sum severity if area=="London" & n>245 & n<338
return list
replace severity20_1012=r(mean) if area=="London"
quietly sum severity if area=="North West" & n>245 & n<338
return list
replace severity20_1012=r(mean) if area=="North West"
quietly sum severity if area=="South East" & n>245 & n<338
return list
replace severity20_1012=r(mean) if area=="South East"
quietly sum severity if area=="South West" & n>245 & n<338
return list
replace severity20_1012=r(mean) if area=="South West"
quietly sum severity if area=="West Midlands" & n>245 & n<338
return list
replace severity20_1012=r(mean) if area=="West Midlands"
quietly sum severity if area=="Yorkshire and The Humber" & n>245 & n<338
return list
replace severity20_1012=r(mean) if area=="Yorkshire and The Humber"


//severity21_0103

quietly sum severity if area=="East Midlands" & n>337
return list
gen severity21_0103=r(mean)
quietly sum severity if area=="East of England" & n>337
return list
replace severity21_0103=r(mean) if area=="East of England"
quietly sum severity if area=="North East" & n>337
return list
replace severity21_0103=r(mean) if area=="North East"
quietly sum severity if area=="London" & n>337
return list
replace severity21_0103=r(mean) if area=="London"
quietly sum severity if area=="North West" & n>337
return list
replace severity21_0103=r(mean) if area=="North West"
quietly sum severity if area=="South East" & n>337
return list
replace severity21_0103=r(mean) if area=="South East"
quietly sum severity if area=="South West" & n>337
return list
replace severity21_0103=r(mean) if area=="South West"
quietly sum severity if area=="West Midlands" & n>337
return list
replace severity21_0103=r(mean) if area=="West Midlands"
quietly sum severity if area=="Yorkshire and The Humber" & n>337
return list
replace severity21_0103=r(mean) if area=="Yorkshire and The Humber"


keep if n==1
drop n date severity impact D E sev_minus sev_ratio
gen GOR=1
replace GOR=2 if area=="North West"
replace GOR=3 if area=="Yorkshire and The Humber"
replace GOR=4 if area=="East Midlands"
replace GOR=5 if area=="West Midlands"
replace GOR=6 if area=="East of England"
replace GOR=7 if area=="London"
replace GOR=8 if area=="South East"
replace GOR=9 if area=="South West"
save "sev+imp.dta", replace


//severityQ1
clear
clear matrix
set more off

global myPATH "C:\Users\shiji\Desktop\Bachelor dissertation"
cd "$myPATH\index"

import excel "C:\Users\shiji\Desktop\Bachelor dissertation\index\severityQ2.xlsx", sheet("severityQ2") firstrow

xtline severity , overlay t(date) i(area)

sort area date

bys area: gen n=_n
quietly sum severity if area=="East Midlands"
return list
gen severityQ2=r(mean)
quietly sum severity if area=="East of England"
return list
replace severityQ2=r(mean) if area=="East of England"
quietly sum severity if area=="North East"
return list
replace severityQ2=r(mean) if area=="North East"
quietly sum severity if area=="London"
return list
replace severityQ2=r(mean) if area=="London"
quietly sum severity if area=="North West"
return list
replace severityQ2=r(mean) if area=="North West"
quietly sum severity if area=="South East"
return list
replace severityQ2=r(mean) if area=="South East"
quietly sum severity if area=="South West"
return list
replace severityQ2=r(mean) if area=="South West"
quietly sum severity if area=="West Midlands"
return list
replace severityQ2=r(mean) if area=="West Midlands"
quietly sum severity if area=="Yorkshire and The Humber"
return list
replace severityQ2=r(mean) if area=="Yorkshire and The Humber"

keep if n==1
drop n date severity
gen GOR=1
replace GOR=2 if area=="North West"
replace GOR=3 if area=="Yorkshire and The Humber"
replace GOR=4 if area=="East Midlands"
replace GOR=5 if area=="West Midlands"
replace GOR=6 if area=="East of England"
replace GOR=7 if area=="London"
replace GOR=8 if area=="South East"
replace GOR=9 if area=="South West"
save "severityQ2.dta", replace


//severity separate
clear
clear matrix
set more off

global myPATH "C:\Users\shiji\Desktop\毕业论文"
cd "$myPATH\index"

import excel "C:\Users\shiji\Desktop\毕业论文\index\Cases_all.xlsx", sheet("Cases_all") firstrow

xtline newDeath , overlay t(date) i(area)

sort area date


bys area: gen n=_n
quietly sum cumCases if area=="East Midlands" & n>300
return list
gen severityQ2=r(mean)
quietly sum cumCases if area=="East of England" & n>300
return list
replace severityQ2=r(mean) if area=="East of England"
quietly sum cumCases if area=="North East" & n>300
return list
replace severityQ2=r(mean) if area=="North East"
quietly sum cumCases if area=="London" & n>300
return list
replace severityQ2=r(mean) if area=="London"
quietly sum cumCases if area=="North West" & n>300
return list
replace severityQ2=r(mean) if area=="North West"
quietly sum cumCases if area=="South East" & n>300
return list
replace severityQ2=r(mean) if area=="South East"
quietly sum cumCases if area=="South West" & n>300
return list
replace severityQ2=r(mean) if area=="South West"
quietly sum cumCases if area=="West Midlands" & n>300
return list
replace severityQ2=r(mean) if area=="West Midlands"
quietly sum cumCases if area=="Yorkshire and The Humber" & n>300
return list
replace severityQ2=r(mean) if area=="Yorkshire and The Humber"


quietly sum newCases if area=="East Midlands" & n>300
return list
gen severity21=r(mean)
quietly sum newCases if area=="East of England" & n>300
return list
replace severity21=r(mean) if area=="East of England"
quietly sum newCases if area=="North East" & n>300
return list
replace severity21=r(mean) if area=="North East"
quietly sum newCases if area=="London" & n>300
return list
replace severity21=r(mean) if area=="London"
quietly sum newCases if area=="North West" & n>300
return list
replace severity21=r(mean) if area=="North West"
quietly sum newCases if area=="South East" & n>300
return list
replace severity21=r(mean) if area=="South East"
quietly sum newCases if area=="South West" & n>300
return list
replace severity21=r(mean) if area=="South West"
quietly sum newCases if area=="West Midlands" & n>300
return list
replace severity21=r(mean) if area=="West Midlands"
quietly sum newCases if area=="Yorkshire and The Humber" & n>300
return list
replace severity21=r(mean) if area=="Yorkshire and The Humber"


quietly sum newDeath if area=="East Midlands" & n>300
return list
gen severity1=r(mean)
quietly sum newDeath if area=="East of England" & n>300
return list
replace severity1=r(mean) if area=="East of England"
quietly sum newDeath if area=="North East" & n>300
return list
replace severity1=r(mean) if area=="North East"
quietly sum newDeath if area=="London" & n>300
return list
replace severity1=r(mean) if area=="London"
quietly sum newDeath if area=="North West" & n>300
return list
replace severity1=r(mean) if area=="North West"
quietly sum newDeath if area=="South East" & n>300
return list
replace severity1=r(mean) if area=="South East"
quietly sum newDeath if area=="South West" & n>300
return list
replace severity1=r(mean) if area=="South West"
quietly sum newDeath if area=="West Midlands" & n>300
return list
replace severity1=r(mean) if area=="West Midlands"
quietly sum newDeath if area=="Yorkshire and The Humber" & n>300
return list
replace severity1=r(mean) if area=="Yorkshire and The Humber"



keep if n==1
drop n date cumCases
gen GOR=1
replace GOR=2 if area=="North West"
replace GOR=3 if area=="Yorkshire and The Humber"
replace GOR=4 if area=="East Midlands"
replace GOR=5 if area=="West Midlands"
replace GOR=6 if area=="East of England"
replace GOR=7 if area=="London"
replace GOR=8 if area=="South East"
replace GOR=9 if area=="South West"

save "separate.dta", replace





// severity delta

clear
clear matrix
set more off

global myPATH "C:\Users\shiji\Desktop\Bachelor dissertation"
cd "$myPATH\index"

import excel "C:\Users\shiji\Desktop\Bachelor dissertation\index\severity_delta.xlsx", sheet("severity_delta") firstrow
sort area date
bys area: gen n=_n

twoway (scatter severity date)(lfit severity date if n<01apr2020)(lfit severity date if n<01apr2020)(lfit severity date if n>=01apr2020 & n<01jul2020)(lfit severity date if n>=01jul2020 & n<01oct2020)(lfit severity date if n>=01oct2020 & n<01jan2021)(lfit severity date if n>=01jan2021), by (area)

xtline gradient , overlay t(date) i(area)


quietly sum gradient if area=="East Midlands" & n<63
return list
gen grad=r(mean)
quietly sum gradient if area=="East of England" & n<63
return list
replace grad=r(mean) if area=="East of England"
quietly sum gradient if area=="North East" & n<63
return list
replace grad=r(mean) if area=="North East"
quietly sum gradient if area=="London" & n<63
return list
replace grad=r(mean) if area=="London"
quietly sum gradient if area=="North West" & n<63
return list
replace grad=r(mean) if area=="North West"
quietly sum gradient if area=="South East" & n<63
return list
replace grad=r(mean) if area=="South East"
quietly sum gradient if area=="South West" & n<63
return list
replace grad=r(mean) if area=="South West"
quietly sum gradient if area=="West Midlands" & n<63
return list
replace grad=r(mean) if area=="West Midlands"
quietly sum gradient if area=="Yorkshire and The Humber" & n<63
return list
replace grad=r(mean) if area=="Yorkshire and The Humber"

quietly sum gradient if n>62
gen gradc=r(mean)

keep if n==1
drop n date gradient sev_delta severity
gen GOR=1
replace GOR=2 if area=="North West"
replace GOR=3 if area=="Yorkshire and The Humber"
replace GOR=4 if area=="East Midlands"
replace GOR=5 if area=="West Midlands"
replace GOR=6 if area=="East of England"
replace GOR=7 if area=="London"
replace GOR=8 if area=="South East"
replace GOR=9 if area=="South West"
save "gradient.dta", replace



save "index.dta", replace
