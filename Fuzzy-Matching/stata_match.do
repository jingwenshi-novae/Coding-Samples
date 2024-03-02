net install dm0082.pkg
ssc install sdecode
ssc install renvarlab
ssc install freqindex
ssc install matchit

clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\UK modern mental health"
cd "$myPATH\instname"

import excel "output_jw 20230514_Xue.xlsx", sheet("Sheet2") firstrow clear
save matchfile.dta, replace

use 1901_instname.dta, clear

gen IDmaster=_n
reclink2 uk1901a_rc_decode parishuk_1901_decode using matchfile, idmaster(IDmaster) idusing(Asylum_id) gen(Score) required (uk1901a_rc_decode)
keep if _merge==3
drop _merge
keep IDmaster Address parishuk_1901 uk1901a_rc uk1901a_instname uk1901a_instdesc uk1901a_instname_num uk1901a_instdesc_num uk1901a_parish_instname_unique uk1901a_rc_decode parishuk_1901_decode

save matchit0.dta,replace

use matchit0.dta,replace
matchit IDmaster uk1901a_instname using matchfile.dta , idusing (Asylum_id) txtusing(uk1901a_instname)

gen negscore=0-similscore
bysort IDmaster (negscore): gen scorerank = _n
keep if scorerank==1
drop scorerank negscore

keep IDmaster Asylum_id similscore
gen newID=_n
save matchit0output.dta,replace

use matchit0.dta,clear
reclink2 uk1901a_instname using matchfile, idmaster(IDmaster) idusing(Asylum_id) gen(Score) manytoone
drop _merge

bys IDmaster: gen n=_n
keep if n==1
drop n
reclink2 IDmaster Asylum_id using matchit0output, idmaster(IDmaster) idusing(newID) gen(newScore) manytoone

/*
reclink2 uk1901a_rc_decode parishuk_1901_decode uk1901a_instname using matchfile, idmaster(IDmaster) idusing(Asylum_id) gen(Score) required (uk1901a_rc_decode) manytoone

keep if _merge==3
drop _merge
drop if Uuk1901a_instname==""
drop Road postcode
renvarlab Uuk1901a_instname Uuk1901a_rc_decode Uparishuk_1901_decode Score Asylum_id HospitalName PreviousNames Location lonlat PrincipalArchitect Layout Status Opened Closed ,  postfix(_4)
save Previousname4.dta,replace
*/



use 1901_instname.dta, clear
gen IDmaster=_n
merge m:m IDmaster using Hospitalname1.dta
drop _merge
merge m:m IDmaster using Previousname1.dta
drop _merge

sum Uuk1901a_instname Uuk1901a_rc_decode Uparishuk_1901_decode Score Asylum_id HospitalName PreviousNames Location lonlat PrincipalArchitect Layout Status Opened Closed

replace Uuk1901a_instname=Uuk1901a_instname_5 if Uuk1901a_instname==""
replace Uuk1901a_rc_decode=Uuk1901a_rc_decode_5 if Uuk1901a_rc_decode==""
replace Uparishuk_1901_decode=Uparishuk_1901_decode_5 if Uparishuk_1901_decode==""
replace Score=Score_5 if Score==.
replace Asylum_id=Asylum_id_5 if Asylum_id==.
replace HospitalName=HospitalName_5 if HospitalName==""
replace PreviousNames=PreviousNames_5 if PreviousNames==""
replace Location=Location_5 if Location==""
replace lonlat=lonlat_5 if lonlat==""
replace PrincipalArchitect=PrincipalArchitect_5 if PrincipalArchitect==""
replace Layout=Layout_5 if Layout==""
replace Status=Status_5 if Status==""
replace Opened=Opened_5 if Opened==""
replace Closed=Closed_5 if Closed==""

drop *_5

/* Why?
local varlist Uuk1901a_instname Uuk1901a_rc_decode Uparishuk_1901_decode Score Asylum_id HospitalName PreviousNames Location lonlat PrincipalArchitect Layout Status Opened Closed
foreach v in varlist{
	drop `v_1'
}
*//////

merge m:m IDmaster using Previousname2.dta
drop _merge
merge m:m IDmaster using Previousname3.dta
drop _merge
merge m:m IDmaster using Previousname4.dta
drop _merge
merge m:m IDmaster using Previousname5.dta
drop _merge

save 1901_instname_output.dta,replace

use 1901_instname_output.dta, clear
foreach i in Uuk1901a_instname Uuk1901a_rc_decode Uparishuk_1901_decode HospitalName PreviousNames Location lonlat PrincipalArchitect Layout Status Opened Closed{
	replace `i'="" if (Score<0.7132 & IDmaster!=767 & IDmaster!=476 & IDmaster!=1136 & IDmaster!=1150 & IDmaster!=367 & IDmaster!=343 & IDmaster!=362 & IDmaster!=330 & IDmaster!=461 & IDmaster!=734 & IDmaster!=1518 & IDmaster!=942 & IDmaster!=955 & IDmaster!=631 & IDmaster!=634 & IDmaster!=517 & IDmaster!=518 & IDmaster!=1476 & IDmaster!=792 & IDmaster!=674 & IDmaster!=1479 & IDmaster!=1471 & IDmaster!=843 & IDmaster!=491 & IDmaster!=1301 & IDmaster!=1022 & IDmaster!=892 & IDmaster!=1379 & IDmaster!=298 & IDmaster!=472 & IDmaster!=1108 & IDmaster!=1369 & IDmaster!=724 & IDmaster!=899 & IDmaster!=1206 & IDmaster!=22)
}

foreach i in Score{
	replace `i'=. if (Score<0.7132 & IDmaster!=767 & IDmaster!=476 & IDmaster!=1136 & IDmaster!=1150 & IDmaster!=367 & IDmaster!=343 & IDmaster!=362 & IDmaster!=330 & IDmaster!=461 & IDmaster!=734 & IDmaster!=1518 & IDmaster!=942 & IDmaster!=955 & IDmaster!=631 & IDmaster!=634 & IDmaster!=517 & IDmaster!=518 & IDmaster!=1476 & IDmaster!=792 & IDmaster!=674 & IDmaster!=1479 & IDmaster!=1471 & IDmaster!=843 & IDmaster!=491 & IDmaster!=1301 & IDmaster!=1022 & IDmaster!=892 & IDmaster!=1379 & IDmaster!=298 & IDmaster!=472 & IDmaster!=1108 & IDmaster!=1369 & IDmaster!=724 & IDmaster!=899 & IDmaster!=1206 & IDmaster!=22)
}

bys IDmaster: gen n=_n
drop if n>1
drop n
save 1901_instname_output_check.dta,replace







import excel "output_jw 20230514_Xue.xlsx", sheet("Sheet4") firstrow clear
save matchfile2.dta, replace

use 1911_withaddresses_c.dta, clear
gen IDmaster=_n



reclink2 uk1911a_county parishuk_1911_id Address using matchfile2, idmaster(IDmaster) idusing(Asylum_id) gen(Score) required (uk1911a_county) manytoone

reclink2 uk1911a_county parishuk_1911_id using matchfile2, idmaster(IDmaster) idusing(Asylum_id) gen(Score) required (uk1911a_county)

save reclink2.dta,replace
keep if _merge==3
drop _merge
export delimited using "reclink2", replace


/**/
merge m:m uk1911a_county using matchfile2
keep Address countyuk parishuk_1911 uk1911a_county parishuk_1911_id Address_unique_id IDmaster _merge
gen match=1 if _merge==3
drop _merge
export delimited using "1911_withaddresses_c", replace

duplicates drop address_unique_id, force
gen idmaster=_n
drop IDmaster
rename idmaster IDmaster
reclink2 parishuk_1911_id Address using matchfile2, idmaster(IDmaster) idusing(Asylum_id) gen(Score)

replace Asylum_id=. if match==.
replace HospitalName="" if match==.
replace PreviousNames="" if match==.
replace Location="" if match==.
replace PrincipalArchitect="" if match==.
replace Layout="" if match==.
replace Status="" if match==.
replace Opened="" if match==.
replace Closed="" if match==.
replace Uparishuk_1911_id="" if match==.
replace UAddress="" if match==.
replace Score=. if match==.
rename match match_county
gen match_parish_address=1 if _merge==3
drop _merge
rename Score matchScore
drop IDmaster
drop UAddress Uparishuk_1911_id
order Address countyuk parishuk_1911 uk1911a_county parishuk_1911_id address_unique_id Asylum_id match_county match_parish_address matchScore HospitalName PreviousNames Location PrincipalArchitect Layout Status Opened Closed
save 1911_withaddresses_output2.dta,replace


/**/





/*new*/
use reclink2.dta, clear
rename _merge match,replace
keep Address countyuk parishuk_1911 uk1911a_county parishuk_1911_id Address_unique_id IDmaster Score match

rename IDmaster idmaster
gen IDmaster=_n
reclink2 uk1911a_county Address using matchfile2, idmaster(IDmaster) idusing(Asylum_id) gen(newScore) required (uk1911a_county) manytoone

save reclink2match.dta,replace

use reclink2.dta,clear
keep if _merge==3
keep IDmaster Asylum_id Uuk1911a_county HospitalName PreviousNames Location PrincipalArchitect Layout Status Opened Closed Uparishuk_1911_id
rename IDmaster idmaster
renvarlab Uuk1911a_county Uparishuk_1911_id Asylum_id HospitalName PreviousNames Location PrincipalArchitect Layout Status Opened Closed ,  postfix(_2)
save noaddressmatch.dta,replace

use reclink2match.dta,clear
rename _merge match2 /* not matched means：not matched through address */
merge m:m Asylum_id using Uparish.dta
drop if _merge==2
drop _merge

/*
only matched through address: match==1, match2==3
only matched through parish: match==3, match2==1   (now focused)
matched through both address and parish: match==3, match2==3
*/

merge m:m idmaster using noaddressmatch.dta
save middle.dta,replace

replace UAddress="" if UAddress=="" | Address==""
replace Uuk1911a_county=. if UAddress=="" | Address==""
replace newScore=. if UAddress=="" | Address==""
replace Asylum_id=. if UAddress=="" | Address==""
replace HospitalName="" if UAddress=="" | Address==""
replace PreviousNames="" if UAddress=="" | Address==""
replace PrincipalArchitect="" if UAddress=="" | Address==""
replace Layout="" if UAddress=="" | Address==""
replace Status="" if UAddress=="" | Address==""
replace Opened="" if UAddress=="" | Address==""
replace Closed="" if UAddress=="" | Address==""

replace Asylum_id=Asylum_id_2 if Asylum_id==. & Asylum_id_2>0
replace HospitalName=HospitalName_2 if match==3 & match2==1
replace PreviousNames=PreviousNames_2 if match==3 & match2==1
replace Location=Location_2 if match==3 & match2==1
replace PrincipalArchitect=PrincipalArchitect_2 if match==3 & match2==1
replace Layout=Layout_2 if match==3 & match2==1
replace Status=Status_2 if match==3 & match2==1
replace Opened=Opened_2 if match==3 & match2==1
replace Closed=Closed_2 if match==3 & match2==1
replace Uparishuk_1911_id=Uparishuk_1911_id_2 if match==3 & match2==1

drop Uparishuk_1911_id Uuk1911a_county_2 Uparishuk_1911_id_2 Asylum_id_2 HospitalName_2 PreviousNames_2 Location_2 PrincipalArchitect_2 Layout_2 Status_2 Opened_2 Closed_2 _merge Uuk1911a_county UAddress
save middle2.dta,replace



rename Score Score_parish_match
rename newScore Score_address_match
replace match=. if match==1
replace match=1 if match==3
rename match match_county
replace match2=. if match2==1
replace match2=1 if match2==3
rename match2 match_address
drop IDmaster
rename idmaster n
order n Address countyuk parishuk_1911 uk1911a_county parishuk_1911_id Address_unique_id Asylum_id Score_parish_match match_county Score_address_match match_address HospitalName PreviousNames Location PrincipalArchitect Layout Status Opened Closed
save 1911_withaddresses_output.dta,replace
