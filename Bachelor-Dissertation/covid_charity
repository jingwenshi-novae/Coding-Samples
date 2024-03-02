clear
clear matrix
set more off

global myPATH "C:\Users\shiji\Desktop\Bachelor dissertation\UKdata"
cd "$myPATH\STATA data"


//(1) Construct severity dta
import excel "C:\Users\shiji\Desktop\Bachelor dissertation\index\severity_new.xlsx", sheet("severity_new") firstrow clear
bys area: egen severity20=mean(severity)
bys area: gen n=_n
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
save "severity20.dta", replace

//(2) Find common variables
use clrs_2020-21_v1,clear
rename VolBen2a VolBen1a
rename VolBen2b VolBen1b
rename VolBen2g VolBen1g
rename GGroup3f VolBen1g
rename GGroup3h GGroup2h
rename GGroup3x GGroup2v
rename BVLon2 BVLon
rename Religg Relig2g

sum Cserial GOR AIntDate_year Quarter sexg Ragecat CitZen1 Rural11 GHealth Relig2g RelBI Ethnic2 SBeNeigh ZSBeNeigh SBeGB ZSBeGB Slocsat Zslocsat Fullint /*control variables*/

sum LocAct1g LocAct1h GGroup2f GGroup2h GGroup2v Givech3 GivAmtB GivAmtB2 GivAmt2 CausLN /*donate money*/
sum FUnOft BVLon BVHelp Zformon Zforvol Funhrs2g ZIhlpmon Zinfvol Ihlphrs2g Zinffor Zinfform ZLocInv1 ZLocOft RCareHrsg /*help community*/

sum WellB1 WellB2 WellB3 DWorkA Wrking EverWk LeavWkM LeavWkg Stat rnssec8 rnssec5 rnssec3 Teuse3_8 Teuse3_10 /*H1 endowment*/

sum VolBen1a VolBen1g ZLocPeop1 /*H2 altruism*/

sum VolBen1b LonOft /*H3 social*/

use clrs_2018-19,clear /*REPEAT ABOVE*/
use clrs_2019-20_v2,clear /*REPEAT ABOVE*/


//(3) Combine dta files
use clrs_2020-21_v1,clear
rename VolBen2a VolBen1a
rename VolBen2b VolBen1b
rename VolBen2g VolBen1g
rename GGroup3f GGroup2f
rename GGroup3h GGroup2h
rename GGroup3x GGroup2v
rename BVLon2 BVLon
rename Religg Relig2g
append using clrs_2018-19.dta
append using clrs_2019-20_v2.dta
append using clrs_2017-18_v2.dta

//(4) Replacement for missing values
sum Cserial GOR AIntDate_year Quarter sexg Ragecat CitZen1 Rural11 GHealth Relig2g RelBI Ethnic2 SBeNeigh ZSBeNeigh SBeGB ZSBeGB Slocsat Zslocsat Fullint /*control variables*/
replace sexg=. if sexg<=0
replace Ragecat=. if Ragecat<=0
replace CitZen1=. if CitZen1<0
replace Rural11=0 if Rural11==1
replace Rural11=1 if Rural11==2
replace GHealth=. if GHealth<=0
replace Relig2g=. if Relig2g<0
replace RelBI=. if RelBI<0
replace Ethnic2=. if Ethnic2<0
replace SBeNeigh=. if SBeNeigh<=0
replace ZSBeNeigh=. if ZSBeNeigh<=0
replace SBeGB=. if SBeGB<=0
replace ZSBeGB=. if ZSBeGB<=0
replace Slocsat=. if Slocsat<=0
replace Zslocsat=. if Zslocsat<=0

sum LocAct1g LocAct1h GGroup2f GGroup2h GGroup2v Givech3 GivAmtB GivAmtB2 GivAmt2 CausLN /*donate money*/
replace LocAct1g=. if LocAct1g<0
replace LocAct1g=0 if LocInvNg==1
replace LocAct1h=. if LocAct1h<0
replace LocAct1h=0 if LocInvNg==1
replace GGroup2f=. if GGroup2f<0
replace GGroup2h=. if GGroup2h<0
replace GivAmtB=. if GivAmtB<0
replace GivAmtB=0 if GGroup2v==1
replace GivAmtB2=. if GivAmtB2<0
replace GivAmtB2=0 if GGroup2v==1
replace GivAmt2=. if GivAmt2<0
replace GivAmt2=0 if GGroup2v==1
replace CausLN=. if CausLN<=0
sum FUnOft BVLon BVHelp Zformon Zforvol Funhrs2g ZIhlpmon Zinfvol Ihlphrs2g Zinffor Zinfform ZLocInv1 ZLocOft RCareHrsg /*help community*/
replace FUnOft=0 if FUnOft==-1
replace FUnOft=. if FUnOft<0
replace BVLon=. if BVLon<0
replace Funhrs2g=. if Funhrs2g<0
replace Ihlphrs2g=. if Ihlphrs2g<=0
replace ZLocInv1=. if ZLocInv1<0
replace ZLocOft=0 if ZLocOft==-1
replace ZLocOft=. if ZLocOft<-1
replace RCareHrsg=. if RCareHrsg<=0
replace RCareHrsg=0 if RCare==2

sum WellB1 WellB2 WellB3 DWorkA Wrking EverWk LeavWkM LeavWkg Stat rnssec8 rnssec5 rnssec3 Teuse3_8 Teuse3_10 /*H1 endowment*/
replace WellB1=. if WellB1<0
replace WellB2=. if WellB2<0
replace WellB3=. if WellB3<0
replace DWorkA=. if DWorkA<=0
replace DWorkA=0 if DWorkA==2
replace Wrking=. if Wrking<=0
replace Wrking=0 if Wrking==2
replace EverWk=. if EverWk<=0 /* only ask people not wrking*/
replace EverWk=0 if EverWk==2
replace LeavWkM=. if LeavWkM<=0
replace LeavWkg=. if LeavWkg<=0
replace Stat=. if Stat<=0
replace Teuse3_8=. if Teuse3_8<0
replace Teuse3_10=. if Teuse3_10<0
replace Givech3=. if Givech3<0
replace BVHelp=. if BVHelp<0
replace GGroup2v=. if GGroup2v<0

sum VolBen1a VolBen1g ZLocPeop1 /*H2 altruism*/
replace VolBen1a=. if VolBen1a<0
replace VolBen1g=. if VolBen1g<0
replace ZLocPeop1=. if ZLocPeop1<0

sum VolBen1b LonOft /*H3 social*/
replace VolBen1b=. if VolBen1b<0
replace LonOft=. if LonOft<=0

//(5) Selecting variables (sum again)
sum Cserial GOR AIntDate_year Quarter sexg Ragecat CitZen1 Rural11 GHealth Relig2g RelBI Ethnic2 SBeNeigh ZSBeNeigh SBeGB ZSBeGB Slocsat Zslocsat Fullint /*control variables*/
/* GHealth, SBeGB, ZSBeGB*/

sum LocAct1g LocAct1h GGroup2f GGroup2h Givech3 GivAmtB GivAmtB2 GivAmt2 CausLN /*donate money*/
/* GivAmtB~CausLN:16620-25000*/

sum FUnOft BVLon BVHelp Zformon Zforvol Funhrs2g ZIhlpmon Zinfvol Ihlphrs2g Zinffor Zinfform ZLocInv1 ZLocOft RCareHrsg /*help community*/
/* RCareHrsg; FUnOft, Funhrs2g, Ihlphrs2g, BVLon:9000-14900*/

sum WellB1 WellB2 WellB3 DWorkA Wrking EverWk LeavWkM LeavWkg Stat rnssec8 rnssec5 rnssec3 Teuse3_8 Teuse3_10 /*H1 endowment*/
/* DWorkA, Stat, rnssec; EverWk, LeavWkM, LeavWkg:6800-9200*/
sum VolBen1a VolBen1g ZLocPeop1 /*H2 altruism*/
/* ZLocPeop1; VolBen1:11000*/
sum VolBen1b LonOft /*H3 social*/
/* VolBen1b:11000*/

** save process-files **
save "process0220.dta", replace

//(6) Merge AIntDate_year with severity
use process0220.dta, clear

merge m:1 GOR using index.dta
drop _merge            

rename AIntDate_year year
gen post=0
replace post=1 if year>=2020
gen quarter=1 if Quarter==4
replace quarter=2 if Quarter==1
replace quarter=3 if Quarter==2
replace quarter=4 if Quarter==3
gen time=(year-2017)*4+quarter-2 /*time: 1-15*/

save process_new.dta, replace

** Construct a time-invariant metric: severity20
gen severity=severity20_0406
replace severity=severity20_0709 if time>3 & time<7
replace severity=severity20_1012 if time>6 & time<10
replace severity=severity21_0103 if time>9

drop severity20_0406 severity20_0709 severity20_1012 severity21_0103

gen sevpost=severity*post



//(6.2) Merge with Q1 Q2
use process0220.dta, clear

merge m:1 GOR using severityQ2.dta
drop _merge

rename AIntDate_year year
gen post=0
replace post=1 if year>=2020
gen quarter=1 if Quarter==4
replace quarter=2 if Quarter==1
replace quarter=3 if Quarter==2
replace quarter=4 if Quarter==3
gen time=(year-2018)*4+quarter-1
gen severity=severityQ2
gen sevpost=severity*post




// (7) Final Outputs

** Banlancing check **
use process_new.dta, clear
** Stastistical Description: var of interests**
bys year: tabstat sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2, stat(mean v)

** Description of charitable bequest distribution**
ssc install distplot, replace
distplot GivAmt2, recast(spike) fc(%75)name(g0, replace) frequency
distplot GivAmt2, recast(area) fc(%75) name(g1, replace)
distplot GivAmtB, recast(area) fc(%75) name(g2, replace)
distplot GivAmtB2, recast(area) fc(%75) name(g3, replace)
gr combine g0 g1 g2 g3

kdensity GivAmt2, name(g3, replace)
kdensity GivAmtB, name(g2, replace)
kdensity GivAmt2 if GivAmt2>9, name(g3, replace)
kdensity GivAmtB if GivAmtB>2, name(g4, replace)
gr combine g1 g2 g3 g4

ssc install cdfplot
cdfplot GivAmt2, norm
kdensity GivAmt2, norm


** 2.22 Checks **
gen giv0=.
foreach x in 1 2 3 4 5 6 7 8 9{
	qui sum giv_mean if GOR==`x'
	replace giv0=r(mean) if GOR==`x'
}

gen giv_del=giv_mean-giv0
twoway (scatter giv_del time) (lfitci giv_del time if time<=11) (lfitci giv_del time if time>=11) if time>3

aaplot giv_del time
aaplot giv_del time if time>10

// kernal density plot
ssc install tddens
tddens severity20_0406 GivAmt2 if time>10 & GivAmt2<100, s b
tddens impact20_0406 GivAmt2 if time>10, s b

ssc install binscatter
replace rnssec8=0 if rnssec8==1.1
replace rnssec8=1 if rnssec8==1.2
foreach x in 8 7 6 5 4 3 2 1 0{
	replace rnssec8=`x'+1 if rnssec8==`x'
}
binscatter GivAmt2 rnssec8



**#

////// regression final
use process_new.dta, clear

merge m:1 GOR time using gdp.dta
drop _merge
gen post1=1 if time>10
replace post1=0 if post1==.
gen post2=1 if time>11
replace post2=0 if post2==.
gen post3=1 if time>12
replace post3=0 if post3==.
gen post4=1 if time>13
replace post4=0 if post4==.
gen post5=1 if time>14
replace post5=0 if post5==.

gen sevpost=severity21*post1
gen sevpost1=severity20_03*post1
gen sevpost21=severity20_0406*post1
gen sevpost2=severity20_0406*post2
gen sevpost3=severity20_0709*post3
gen sevpost4=severity20_1012*post4
gen sevpost5=severity21_0103*post5
gen lngiv=ln(GivAmt2)
gen sevpostall=severity21*post2

** Robustness Checks: Using "gradient", "impact", or "rank" as alternative explanatory variables **
** Gradient: the gradient of severity change (consider people's reaction to change instead of the absolute circumstances) **
** Impact: consider the lasting severity influence from the previous periods with a decreasing importance of effect
** Rank: Relax the model to a non-linear basis **

gen gradpost=grad*post2
gen gradpost1=grad*post1
gen gradpost2=gradlong1346*post2
gen gradpost21=gradlong1346*post1

gen imppost=impact21*post1
gen imppost1=impact20_03*post1
gen imppost21=impact20_0406*post1
gen imppost2=impact20_0406*post2
gen imppost3=impact20_0709*post3
gen imppost4=impact20_1012*post4
gen imppost5=impact21_0103*post5


gen rank1=0
replace rank1=1 if GOR==2 | GOR==7
gen rank2=0
replace rank2=1 if GOR==1 | GOR==9
gen rank=3
replace rank=1 if GOR==2 | GOR==7
replace rank=2 if GOR==3 | GOR==5 | GOR==6 | GOR==8

gen rank1post2=rank1*post2
gen rank2post2=rank2*post2
gen rank1post1=rank1*post1
gen rank2post1=rank2*post1

// normalization
gen sevQ2=.
replace sevQ2=0.370726379 if GOR==1
replace sevQ2=1 if GOR==2
replace sevQ2=0.620759099 if GOR==3
replace sevQ2=0.475314432 if GOR==4
replace sevQ2=0.673433823 if GOR==5
replace sevQ2=0.604580999 if GOR==6
replace sevQ2=0.937126802 if GOR==7
replace sevQ2=0.876328124 if GOR==8
replace sevQ2=0.351305215 if GOR==9

gen sevpostQ2=sevQ2*post1
rename sevpost21 sevpost21new
rename sevpostQ2 sevpost21

gen impQ2=.
replace impQ2=0.370939035 if GOR==1
replace impQ2=1 if GOR==2
replace impQ2=0.623736072 if GOR==3
replace impQ2=0.475982855 if GOR==4
replace impQ2=0.669107818 if GOR==5
replace impQ2=0.603628958 if GOR==6
replace impQ2=0.922837424 if GOR==7
replace impQ2=0.876445313 if GOR==8
replace impQ2=0.351456956 if GOR==9

gen imppostQ2=impQ2*post1
rename imppost21 imppost21new
rename imppostQ2 imppost21

gen gradQ2=.
replace gradQ2=0.790653051 if GOR==1
replace gradQ2=0.6475251 if GOR==2
replace gradQ2=0.777407835 if GOR==3
replace gradQ2=0.814951133 if GOR==4
replace gradQ2=0.261648875 if GOR==5
replace gradQ2=9.94578E-16 if GOR==6
replace gradQ2=0 if GOR==7
replace gradQ2=0.499884581 if GOR==8
replace gradQ2=1 if GOR==9

gen gradpostQ2=gradQ2*post1
rename gradpost1 gradpost1new
rename gradpostQ2 gradpost1

gen sd=.
replace sd=0.015792854 if GOR==1
replace sd=0.043807808 if GOR==2
replace sd=0.022594309 if GOR==3
replace sd=0.017131333 if GOR==4
replace sd=0.035082666 if GOR==5
replace sd=0.029315572 if GOR==6
replace sd=0.079204065 if GOR==7
replace sd=0.043264708 if GOR==8
replace sd=0.020347179 if GOR==9

gen sdpost=sd*post1
gen sdQ2=(sd)/(0.079204065)
gen sdpostQ2=sdQ2*post1

**# 0315
//rnssec
replace rnssec8=0 if rnssec8==1.1
replace rnssec8=1 if rnssec8==1.2
foreach x in 8 7 6 5 4 3 2 1 0{
	replace rnssec8=`x'+1 if rnssec8==`x'
}

save process0323.dta,replace

use process0323.dta, clear

reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if rnssec8<3,absorb(GOR) cluster(time GOR)
outreg2 using "output\catelogue", replace dta dec(4) adjr2 title(AllH2)
reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if rnssec8>6,absorb(GOR) cluster(time GOR)
outreg2 using "output\catelogue", append dta dec(4) adjr2 ctitle(AllL3)

reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2>50 & rnssec8<3,absorb(GOR) cluster(time GOR)
outreg2 using "output\catelogue", append dta dec(4) adjr2 ctitle(BigH2)
reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2>50 & rnssec8<4,absorb(GOR) cluster(time GOR)
outreg2 using "output\catelogue", append dta dec(4) adjr2 ctitle(BigH3)
reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2>50 & rnssec8>=4,absorb(GOR) cluster(time GOR)
outreg2 using "output\catelogue", append dta dec(4) adjr2 ctitle(BigL)

reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & rnssec8<3,absorb(GOR) cluster(time GOR)
outreg2 using "output\catelogue", append dta dec(4) adjr2 ctitle(SmallH2)
reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & rnssec8==3,absorb(GOR) cluster(time GOR)
outreg2 using "output\catelogue", append dta dec(4) adjr2 ctitle(Small3)
reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & rnssec8>=4,absorb(GOR) cluster(time GOR)
outreg2 using "output\catelogue", append dta dec(4) adjr2 ctitle(SmallL)
reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & rnssec8==8,absorb(GOR) cluster(time GOR)
outreg2 using "output\catelogue", append dta dec(4) adjr2 ctitle(Small8)

use "output\catelogue_dta",clear
export excel using "output\catelogue" , sheet("Table1",replace)




**# old regression
reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\baselinenew", replace dta dec(4) adjr2 title(regression)
reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.time if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\baselinenew", append dta dec(4) adjr2 ctitle(model2)
use "output\baselinenew_dta",clear
export excel using "output\baselinenew" , sheet("Table1",replace)

reghdfe GivAmt2 rank1post1 rank2post1 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\baselinenew", append dta dec(4) adjr2 ctitle(model2)

reghdfe LocAct1h sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\baselinenew", append dta dec(4) adjr2 ctitle(LocAct1h)

reghdfe GGroup2f sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\baselinenew", append dta dec(4) adjr2 ctitle(GGroup2f)

reghdfe GGroup2h sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\baselinenew", append dta dec(4) adjr2 ctitle(GGroup2h)

/*Robustness check*/
reghdfe GivAmt2 imppost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust1", replace dta dec(4) adjr2 title(impact)

reghdfe GivAmt2 imppost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.time if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust1", append dta dec(4) adjr2 ctitle(model2)

reghdfe GivAmt2 sdpostQ2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust1", append dta dec(4) adjr2 ctitle(model3)

reghdfe GivAmt2 sdpostQ2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.time if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust1", append dta dec(4) adjr2 ctitle(model4)

use "output\robust1_dta",clear
export excel using "output\robust1" , sheet("Table1",replace)


reghdfe GivAmt2 sevpost21 i.time if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust2", replace dta dec(4) adjr2 title(regression)

reghdfe GivAmt2 sevpost21 i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust2", append dta dec(4) adjr2 ctitle(model2)

reghdfe GivAmt2 sevpost21 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust2", append dta dec(4) adjr2 ctitle(model3)

reghdfe GivAmt2 sevpost21 GHealth gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust2", append dta dec(4) adjr2 ctitle(model4)

reghdfe GivAmt2 sevpost21 GHealth Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust2", append dta dec(4) adjr2 ctitle(model5)

reghdfe GivAmt2 sevpost21 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust2", append dta dec(4) adjr2 ctitle(model6)

reghdfe GivAmt2 sevpost21 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust2", append dta dec(4) adjr2 ctitle(model7)

reghdfe GivAmt2 sevpost21 CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust2", append dta dec(4) adjr2 ctitle(model8)

reghdfe GivAmt2 sevpost21 Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust2", append dta dec(4) adjr2 ctitle(model9)

reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\robust2", append dta dec(4) adjr2 ctitle(model10)

use "output\robust2_dta",clear
export excel using "output\robust2" , sheet("Table1",replace)



** Placebo Test **

/*Use BVLon (Beneveloence in the past five years) to substitute the dependent var*/
reghdfe BVLon sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\BVLon", replace dta dec(4) adjr2 title(regression)

reghdfe BVLon sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.time if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\BVLon", append dta dec(4) adjr2 ctitle(model2)

reghdfe BVLon rank1post1 rank2post1 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.time if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\BVLon", append dta dec(4) adjr2 ctitle(model2)

reghdfe BVLon imppost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\BVLon", append dta dec(4) adjr2 ctitle(model2)

reghdfe BVLon sdpostQ2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\BVLon", append dta dec(4) adjr2 ctitle(model2)

use "output\BVLon_dta",clear
export excel using "output\BVLon" , sheet("Table1",replace)



/*Different causes*/
/*
foreach x in a b c d e f g h i j k l m n o{
	replace Caus4w`x'=0 if FUnOft==0
	}
	*/
reghdfe Caus4wa sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\cause", replace dta dec(4) adjr2 title(regression)

foreach x in b c d e f g h i j k l m n o{
	reghdfe Caus4w`x' sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
	outreg2 using "output\cause", append dta dec(4) adjr2 ctitle(model`x')
	}
	
use "output\cause_dta",clear
export excel using "output\cause" , sheet("Table1",replace)


/*
reghdfe GivAmt2 sevpost2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevpost", replace dta dec(4) adjr2 title(regression) 
reghdfe GivAmt2 sevpost1 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevpost", append dta dec(4) adjr2 ctitle(model1)
reghdfe lngiv sevpost2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 post2,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevpost", append dta dec(4) adjr2 ctitle(model2)
reghdfe lngiv sevpost3 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 post3,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevpost", append dta dec(4) adjr2 ctitle(model3)
reghdfe lngiv sevpost4 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 post4,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevpost", append dta dec(4) adjr2 ctitle(model4)
use "output\sevpost_dta",clear
export excel using "output\sevpost" , sheet("Table1",replace)
*/

/*
outreg2 using "output\imppost", replace dta dec(4) adjr2 title(regression) ctitle(cdid)
reghdfe lngiv imppost1 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 post1,absorb(GOR) cluster(time GOR)
outreg2 using "output\imppost", append dta dec(4) adjr2 ctitle(model1)
reghdfe lngiv imppost2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 post2,absorb(GOR) cluster(time GOR)
outreg2 using "output\imppost", append dta dec(4) adjr2 ctitle(model2)
reghdfe lngiv imppost3 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 post3,absorb(GOR) cluster(time GOR)
outreg2 using "output\imppost", append dta dec(4) adjr2 ctitle(model3)
reghdfe lngiv imppost4 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 i.time,absorb(GOR) cluster(time GOR)
outreg2 using "output\imppost", append dta dec(4) adjr2 ctitle(model4)
reghdfe lngiv imppost4 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 post4,absorb(GOR) cluster(time GOR)
outreg2 using "output\imppost", append dta dec(4) adjr2 ctitle(model4_2)
*/
use "output\baseline_dta",clear
export excel using "output\baseline" , sheet("Table1",replace)



// (8) Examining channels
/////*1* Income channel
reghdfe Wrking sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevincnew", replace dta dec(4) adjr2 title(regression)

reghdfe GivAmt2 Wrking sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevincnew", append dta dec(4) adjr2 ctitle(GivAmt2)

reghdfe Teuse3_8 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevincnew", append dta dec(4) adjr2 ctitle(Teuse3_8)

reghdfe GivAmt2 Teuse3_8 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevincnew", append dta dec(4) adjr2 ctitle(GivAmt2)

use "output\sevincnew_dta",clear
export excel using "output\sevincnew" , sheet("Table1",replace)


reghdfe Wrking sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if  rnssec8<=3,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevinc1", replace dta dec(4) adjr2 title(H3)
reghdfe Wrking sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & rnssec8>=3,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevinc1", append dta dec(4) adjr2 ctitle(L)

use "output\sevinc1_dta",clear
export excel using "output\sevinc1" , sheet("Table1",replace)




reghdfe Wrking imppost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\sevinc", replace dta dec(4) adjr2 title(regression)

reghdfe GivAmt2 Wrking imppost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\impinc", append dta dec(4) adjr2 ctitle(GivAmt2)

reghdfe Teuse3_8 imppost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\impinc", append dta dec(4) adjr2 ctitle(Teuse3_8)

reghdfe GivAmt2 Teuse3_8 imppost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\impinc", append dta dec(4) adjr2 ctitle(GivAmt2)

use "output\impinc_dta",clear
export excel using "output\impinc" , sheet("Table1",replace)



/////*2* Altruism channel:VolBen1a,VolBen1g

use process0323.dta, clear

reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)

reghdfe VolBen1a sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter,absorb(GOR) cluster(time GOR)
outreg2 using "output\altruismnew", replace dta dec(4) adjr2 title(regression)

reghdfe GivAmt2 VolBen1a sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
outreg2 using "output\altruismnew", append dta dec(4) adjr2 ctitle(GivAmt2)

reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & (rnssec8==8 | rnssec8==3),absorb(GOR) cluster(time GOR)

reghdfe VolBen1a sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & (rnssec8==3 | rnssec8==8),absorb(GOR) cluster(time GOR)
outreg2 using "output\altruism0", replace dta dec(4) adjr2 title(regression)

reghdfe GivAmt2 VolBen1a sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & (rnssec8==3 | rnssec8==8),absorb(GOR) cluster(time GOR)
outreg2 using "output\altruism0", append dta dec(4) adjr2 ctitle(GivAmt2)

use "output\altruism0_dta",clear
export excel using "output\altruism0" , sheet("Table1",replace)

reghdfe ZLocPeop1 sevpost2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter,absorb(GOR) cluster(time GOR)
reg lngiv ZLocPeop1 sevpost2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 severity20_0406 i.time, robust

areg FUnOft sevpost2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 post2, absorb(GOR) robust /*p=0.178*/
areg FUnOft ZLocPeop1 sevpost2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 post2, absorb(GOR) robust


reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & rnssec8<=3,absorb(GOR) cluster(time GOR)
outreg2 using "output\altruism0", append dta dec(4) adjr2 ctitle(GivAmt2)

reghdfe GivAmt2 VolBen1a sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & rnssec8<=3,absorb(GOR) cluster(time GOR)
outreg2 using "output\altruism0", append dta dec(4) adjr2 ctitle(GivAmt2)


reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if rnssec8<=3,absorb(GOR) cluster(time GOR)
outreg2 using "output\altruism0", append dta dec(4) adjr2 ctitle(GivAmt2)

reghdfe GivAmt2 VolBen1a sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if rnssec8<=3,absorb(GOR) cluster(time GOR)
outreg2 using "output\altruism0", append dta dec(4) adjr2 ctitle(GivAmt2)




/////*4* Social interaction channel
use process0323.dta, clear

replace VolBen1b=0 if FUnOft==0

reghdfe LocAct1h sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter,absorb(GOR) cluster(time GOR)
outreg2 using "output\friends", replace dta dec(4) adjr2 title(regression)

reghdfe VolBen1b sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter,absorb(GOR) cluster(time GOR)
outreg2 using "output\friends", append dta dec(4) adjr2 ctitle(VolBen1b)

reghdfe LocAct1h VolBen1b sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter,absorb(GOR) cluster(time GOR)
outreg2 using "output\friends", append dta dec(4) adjr2 ctitle(LocAct1h)


reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & (rnssec8>3 & rnssec8<7),absorb(GOR) cluster(time GOR)
outreg2 using "output\friends", replace dta dec(4) adjr2 title(regression)

reghdfe VolBen1b sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if rnssec8>3 & rnssec8<8,absorb(GOR) cluster(time GOR)
outreg2 using "output\friends", append dta dec(4) adjr2 ctitle(VolBen1b)

reghdfe GivAmt2 VolBen1b sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100 & rnssec8>4 & rnssec8<8,absorb(GOR) cluster(time GOR)
outreg2 using "output\friends", append dta dec(4) adjr2 ctitle(GivAmt2)

use "output\friends_dta",clear
export excel using "output\friends" , sheet("Table1",replace)


reghdfe GivAmt2 sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2>50 & rnssec8<=3,absorb(GOR) cluster(time GOR)
reghdfe GivAmt2 VolBen1b sevpost21 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2>50 & rnssec8<=3,absorb(GOR) cluster(time GOR)
outreg2 using "output\friends", append dta dec(4) adjr2 ctitle(GivAmt2)



reghdfe Funhrs2g VolBen1b sevpost2 sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter,absorb(GOR) cluster(time GOR)



// (9) Parallel trend test

foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
	gen sev_`x'=sevQ2*[time==`x']
	}
drop sev_1
reghdfe GivAmt2 sev_* sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic5a gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(time GOR)
reghdfe GivAmt2 sev_* sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter if GivAmt2<100,absorb(GOR) cluster(year quarter GOR)

coefplot, baselevels keep(sev_*) vertical coeflabels(sev_2=2 sev_3=3 sev_4=4 sev_5=5 sev_6=6 sev_7=7 sev_8=8 sev_9=9 sev_10=10 sev_11=11 sev_12=12 sev_13=13 sev_14=14 sev_15=15) yline(0,lwidth(vthin) lpattern(dash) lcolor(teal)) xline(10,lwidth(vthin) lpattern(dash) lcolor(teal)) ylabel(,labsize(*0.85) angle(0)) xlabel(,labsize(*0.75)) ytitle("Coefficients") xtitle("Time") msymbol(O) msize(small) mcolor(gs1) addplot(line @b @at,lcolor(gs1) lwidth(medthick)) ciopts(recast(rcap) lwidth(thin) lpattern(dash) lcolor(gs2)) graphregion(color(white))

drop sev_*




foreach x in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15{
	gen rank1_`x'=rank1*[time==`x']
	gen rank2_`x'=rank2*[time==`x']
	}
drop rank1_1 rank2_1
reghdfe GivAmt2 rank2_* rank1_* sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic5a gdp i.time if GivAmt2<100,absorb(GOR) cluster(time GOR)

gen coef1=_b[rank1_2] if time==2
foreach x in 3 4 5 6 7 8 9 10 11 12 13 14 15{
	replace coef1=_b[rank1_`x'] if time==`x'
}
gen coef2=_b[rank2_2] if time==2
foreach x in 3 4 5 6 7 8 9 10 11 12 13 14 15{
	replace coef2=_b[rank2_`x'] if time==`x'
}

mat SE=e(V)
gen se1=sqrt(SE[15,15]) if time==2
foreach x in 3 4 5 6 7 8 9 10 11 12 13 14 15{
	replace se1=sqrt(SE[13+`x',13+`x']) if time==`x'
}
gen se2=sqrt(SE[1,1]) if time==2
foreach x in 3 4 5 6 7 8 9 10 11 12 13 14 15{
	replace se2=sqrt(SE[`x'-1,`x'-1]) if time==`x'
}

gen z11=coef1+1.96*se1
gen z12=coef1-1.96*se1
gen z21=coef2+1.96*se2
gen z22=coef2-1.96*se2
twoway(rcap z11 z12 time, blwidth(thick)) (connect coef1 time ,sort)(rcap z21 z22 time, blwidth(thick)) (connect coef2 time ,sort) if time>=2,legend(off)
twoway (connected coef1 coef2 time if time>=2, sort)



coefplot, baselevels keep(rank1_*) vertical coeflabels(rank1_2=2 rank1_3=3 rank1_4=4 rank1_5=5 rank1_6=6 rank1_7=7 rank1_8=8 rank1_9=9 rank1_10=10 rank1_11=11 rank1_12=12 rank1_13=13 rank1_14=14 rank1_15=15) yline(0,lwidth(vthin) lpattern(dash) lcolor(teal)) xline(4,lwidth(vthin) lpattern(dash) lcolor(teal)) ylabel(,labsize(*0.85) angle(0)) xlabel(,labsize(*0.75)) ytitle("Coefficients") xtitle("Time") msymbol(O) msize(small) mcolor(gs1) addplot(line @b @at,lcolor(gs1) lwidth(medthick)) ciopts(recast(rcap) lwidth(thin) lpattern(dash) lcolor(gs2)) graphregion(color(white)) name(g1,replace)

coefplot, baselevels keep(rank2_*) vertical coeflabels(rank2_2=2 rank2_3=3 rank2_4=4 rank2_5=5 rank2_6=6 rank2_7=7 rank2_8=8 rank2_9=9 rank2_10=10 rank2_11=11 rank2_12=12 rank2_13=13 rank2_14=14 rank2_15=15) yline(0,lwidth(vthin) lpattern(dash) lcolor(teal)) xline(4,lwidth(vthin) lpattern(dash) lcolor(teal)) ylabel(,labsize(*0.85) angle(0)) xlabel(,labsize(*0.75)) ytitle("Coefficients") xtitle("Time") msymbol(O) msize(small) mcolor(gs1) addplot(line @b @at,lcolor(gs1) lwidth(medthick)) ciopts(recast(rcap) lwidth(thin) lpattern(dash) lcolor(gs2)) graphregion(color(white)) name(g2, replace)

gr combine g1 g2

drop rank1_* rank2_*








**# IV reg
//0403

use process0323.dta, clear

gen IV=312 if GOR==1
replace IV=522 if GOR==2
replace IV=359 if GOR==3
replace IV=311 if GOR==4
replace IV=459 if GOR==5
replace IV=328 if GOR==6
replace IV=5727 if GOR==7
replace IV=483 if GOR==8
replace IV=237 if GOR==9
replace IV=0 if post==0

ivreg2 GivAmt2 (sevpost21=IV) sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter i.GOR if GivAmt2<100

ivregress 2sls GivAmt2 (sevpost21=IV) sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp i.year i.quarter i.GOR if GivAmt2<100, r cluster(GOR)

ssc install ivreghdfe
ivreghdfe GivAmt2 (sevpost21=IV) sexg Ragecat CitZen1 Rural11 GHealth Relig2g Ethnic2 gdp if GivAmt2<100, absorb(i.time i.GOR)  first
