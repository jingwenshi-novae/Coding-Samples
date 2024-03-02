clear
clear matrix
set more off

global myPATH "C:\Users\Jingwen Shi\Desktop\RAs"
cd "$myPATH\EEBO"

import excel "scrape.xlsx", sheet("cleaned") firstrow

drop F
replace Birth=. if Birth==Death
drop if name=="None"
drop if name=="Printed from Oxford Dictionary of National Biography. Under the terms of the licence agreement, an individual user may print out a single article for personal use"

save oxfdic.dta,replace

drop if born=="None"
gen code=_n
save oxfdic_match.dta,replace

// merge

use historical_eebo_oxf.dta,clear
rename Name name
merge m:n name using oxfdic_match.dta
save oxf_merge.dta,replace
use oxf_merge.dta,clear
keep if _merge==3
drop _merge

destring Upyear,force replace
destring Lowyear,force replace
drop if Upyear<Birth-6 & Birth!=.
drop if Lowyear>Death+6 & Lowyear!=.

bys n: gen k=_n
count if k>1
replace Upyear=. if Upyear>2023
replace Upyear=. if Lowyear>2023
drop if Upyear==. & Lowyear<Death-100 & Death!=.
drop if Lowyear==. & Upyear>Birth+100 & Upyear!=.
count if k>1
drop if name==""
drop if born==""
rename born BornPlace
rename occupation Occupation
rename Birth Birthyear
rename Death Deathyear
drop n k
save oxf_merge_clean.dta,replace

// reclink2

reclink2 name using oxfdic_match, idmaster(n) idusing(code) gen(matchscore) wmatch(10)
save oxf_reclink_clean.dta,replace
count if matchscore>0.9875

keep if _merge==3
drop _merge
destring Upyear,force replace
destring Lowyear,force replace
drop if Upyear<Birth-6 & Birth!=.
drop if Lowyear>Death+6 & Lowyear!=.

bys n: gen k=_n
count if k>1
replace Upyear=. if Upyear>2023
replace Upyear=. if Lowyear>2023
drop if Upyear==. & Lowyear<Death-100 & Death!=.
drop if Lowyear==. & Upyear>Birth+100 & Upyear!=.
count if k>1
drop if name==""
drop if born==""
rename born BornPlace
rename occupation Occupation
rename Birth Birthyear
rename Death Deathyear

drop if matchscore<0.98
drop k
bys n: gen k=_n
count if k>1

drop n k
save oxf_reclink_clean.dta,replace



// match

use historical_eebo_oxf.dta,clear
matchit n Name using oxfdic_match.dta , idusing(code) txtusing(name) time
save matched_oxf.dta,replace

use matched_new.dta,replace
keep if similscore>0.7
merge m:n code using wikidata_uk_new
drop if _merge==2
drop _merge
merge m:n n using historical_eebo_new
replace death=updated_death_date if updated_death_date!=.

save merged_new.dta,replace
use merged_new.dta,clear

replace death_max=updated_death_date if updated_death_date!=.
destring Upyear,force replace
destring Lowyear,force replace
drop if Upyear<birth_min-6
drop if Lowyear>death_max+6

bys n: gen k=_n
count if k>1
replace Upyear=. if Upyear>2023
replace Upyear=. if Lowyear>2023
drop if similscore<0.8 & Upyear==. & Lowyear==.
drop if Upyear==. & Lowyear<death_max-100
drop if Lowyear==. & Upyear>birth_max+100
count if k>1
drop if name==""
save merged_tight.dta,replace

use merged_tight.dta,clear
bys n: egen max=max(similscore)
drop if similscore<max-0.000001
drop k
bys n: gen k=_n
count if k>1

drop Identifier Bibliographicnumber Collection Title Link Author Name Upyear Lowyear PrinterPublisher Publicationdate Publicationplace Pagenumber Matcheswithintext MainTitle TypeGenre Othercreator Creatororganisation Physicaldescription _merge

merge m:n n using historical_eebo_new

save final_match_new.dta,replace
use final_match_new.dta,clear

save final_match_best.dta,replace

count if _merge==3
count if k>1 & _merge==3

rename name wiki_name
rename Name eebo_name
order Identifier eebo_name wikidata_code wiki_name similscore Bibliographicnumber Collection Title Link Author Upyear Lowyear PrinterPublisher Publicationdate Publicationplace Pagenumber Matcheswithintext MainTitle TypeGenre Othercreator Creatororganisation Physicaldescription

save final_clean_best.dta,replace
