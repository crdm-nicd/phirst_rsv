*********************************
*********************************
* Merge Datasets with Masterlist*
*********************************
*********************************

clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 


********************
*CAR - Risk Factors*
********************

use "PHIRST - Data - Lab - 2017-2018 - Individuals.dta", clear

merge 1:1 indid using "PHIRST - Data - Individual and HH-Level 2016-2018.dta"
keep if _merge==3
drop _merge

*New age category and HIV*
gen agegrp1=1 if ageyears<5
replace agegrp1=2 if ageyears>=5 & ageyears<10
replace agegrp1=3 if ageyears>=10 & ageyears<15
replace agegrp1=4 if ageyears>=15 & ageyears<20
replace agegrp1=5 if ageyears>=20 & ageyears<25
replace agegrp1=6 if ageyears>=25 & ageyears<45
replace agegrp1=7 if ageyears>=45 & ageyears<65
replace agegrp1=8 if ageyears>=65 & ageyears<75
replace agegrp1=9 if ageyears>=75
label define agegrp1 1 "<5" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-44" 7 "45-64" 8 "65-74" 9 "75+"
label values agegrp1 agegrp1
rename hiv_status hiv
replace hiv=. if hiv==2

*RSV types (including mixed infections)
gen mixed = ersvafn+ersvbfn+ersvutpfn
tab mixed
gen rsvtype=0 if rsv==1
replace rsvtype=1 if ersvafn==1 & ersvbfn==0 & ersvutpfn==0
replace rsvtype=2 if ersvbfn==1 & ersvafn==0 & ersvutpfn==0
replace rsvtype=3 if ersvutpfn==1 & ersvbfn==0 & ersvafn==0
replace rsvtype=4 if mixed>1 & mixed!=.

label define rsvtype 1 "A" 2 "B" 3 "Untyped" 4 "Mixed"
label values rsvtype rsvtype
tab rsvtype
save "PHIRST - Data - Lab - 2017-2018 - RF - CAR.dta", replace


*********************************
*Episode Duration - Risk Factors*
*********************************

use "PHIRST - Data - Lab - 2017-2018 - RF - Episode Duration.dta", clear
capture drop _merge
merge m:1 indid using "PHIRST - Data - Individual and HH-Level 2016-2018.dta"
keep if _merge==3
drop _merge
merge 1:1 indid epis type using "PHIRST - Data - Epi - 2017-2018 - Symptoms - Double Count Coinfections - Yes.dta"
keep if _merge==3
drop _merge
merge 1:1 indid epis type using "PHIRST - Data - Lab - Ct Episodes - Wide - 2017-2018 - Double Count Coinfections - Yes.dta"
keep if _merge==3
drop _merge

*New age category and HIV*
gen agegrp1=1 if ageyears<5
replace agegrp1=2 if ageyears>=5 & ageyears<10
replace agegrp1=3 if ageyears>=10 & ageyears<15
replace agegrp1=4 if ageyears>=15 & ageyears<20
replace agegrp1=5 if ageyears>=20 & ageyears<25
replace agegrp1=6 if ageyears>=25 & ageyears<45
replace agegrp1=7 if ageyears>=45 & ageyears<65
replace agegrp1=8 if ageyears>=65 & ageyears<75
replace agegrp1=9 if ageyears>=75
label define agegrp1 1 "<5" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-44" 7 "45-64" 8 "65-74" 9 "75+"
label values agegrp1 agegrp1
rename hiv_status hiv
replace hiv=. if hiv==2
*
save "PHIRST - Data - Lab - 2017-2018 - RF - Episode Duration.dta", replace
keep indid epis type edur
save "IDEpisDur", replace


******************************************
*Index and Non-Index Cases - Risk Factors*
******************************************

clear
use "PHIRST - Data - Lab - 2017-2018 - HCIR.dta", clear
*drop if ixnix==.
merge m:1 indid using "PHIRST - Data - Individual and HH-Level 2016-2018.dta"
keep if _merge==3
drop _merge
merge m:1 indid epis type using "PHIRST - Data - Epi - 2017-2018 - Symptoms - Double Count Coinfections - Yes.dta"
keep if _merge==3
drop _merge
merge m:1 indid epis type using "PHIRST - Data - Lab - Ct Episodes - Wide - 2017-2018 - Double Count Coinfections - Yes.dta"
keep if _merge==3
drop _merge
gen ixpos=1 if ixnix==2
replace ixpos=0 if ixnix==1
gen ixall=1 if ixnix==2
replace ixall=0 if ixnix<2

*New age category and HIV*
gen agegrp1=1 if ageyears<5
replace agegrp1=2 if ageyears>=5 & ageyears<10
replace agegrp1=3 if ageyears>=10 & ageyears<15
replace agegrp1=4 if ageyears>=15 & ageyears<20
replace agegrp1=5 if ageyears>=20 & ageyears<25
replace agegrp1=6 if ageyears>=25 & ageyears<45
replace agegrp1=7 if ageyears>=45 & ageyears<65
replace agegrp1=8 if ageyears>=65 & ageyears<75
replace agegrp1=9 if ageyears>=75
label define agegrp1 1 "<5" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-44" 7 "45-64" 8 "65-74" 9 "75+"
label values agegrp1 agegrp1
rename hiv_status hiv
replace hiv=. if hiv==2
*
save "PHIRST - Data - Lab - 2017-2018 - RF - Index.dta", replace
keep indid ixall
collapse (max) ixall, by(indid)
merge 1:1 indid using "PHIRST - Data - Lab - 2017-2018 - RF - CAR.dta"
replace ixall=0 if ixall==.
save "PHIRST - Data - Lab - 2017-2018 - RF - CAR.dta", replace


*********************
*HCIR - Risk Factors*
*********************

*Index case*
*
clear 
use "PHIRST - Data - Individual and HH-Level 2016-2018.dta", clear
drop year site hh_id
foreach var of varlist ind_id-indid {
quietly rename `var' ix`var'
}
save "PHIRST - Data - Masterlist - Index - 2016-2018.dta", replace
*
clear 
use "PHIRST - Data - Epi - 2017-2018 - Symptoms - Double Count Coinfections - Yes.dta", clear
drop year-hhid 
foreach var of varlist indid-symili {
quietly rename `var' ix`var'
}
rename ixtype type
save "PHIRST - Data - Epi - 2017-2018 - Symptoms - Index - Double Count Coinfections - Yes.dta", replace
*
clear
use "PHIRST - Data - Lab - Ct Episodes - Wide - 2017-2018 - Double Count Coinfections - Yes"
drop year-hhid
foreach var of varlist indid-meanct {
quietly rename `var' ix`var'
}
rename ixtype type
save "PHIRST - Data - Lab - Ct Episodes - Wide - 2017-2018 - Index", replace
*
clear 
use "IDEpisDur", clear
foreach var of varlist * {
quietly rename `var' ix`var'
}
rename ixtype type
save "PHIRST - Data - Epi - 2017-2018 - EpisDur - Index.dta", replace

*Household member*
clear 
use "PHIRST - Data - Individual and HH-Level 2016-2018.dta", clear
drop year site hh_id
foreach var of varlist ind_id-indid {
quietly rename `var' hm`var'
}
save "PHIRST - Data - Masterlist - HM - 2016-2018.dta", replace
*
clear 
use "PHIRST - Data - Epi - 2017-2018 - Symptoms - Double Count Coinfections - Yes.dta", clear
drop year-hhid
foreach var of varlist indid-symili {
quietly rename `var' hm`var'
}
rename hmtype type
save "PHIRST - Data - Epi - 2017-2018 - Symptoms - HM - Double Count Coinfections - Yes.dta", replace
*
clear
use "PHIRST - Data - Lab - 2017-2018 - HCIR RF.dta", clear
merge m:1 ixindid using "PHIRST - Data - Masterlist - Index - 2016-2018.dta"
drop if _merge==2
drop _merge
merge m:1 ixindid ixepis type using "PHIRST - Data - Epi - 2017-2018 - Symptoms - Index - Double Count Coinfections - Yes.dta"
drop if _merge==2
drop _merge
merge m:1 ixindid ixepis type using "PHIRST - Data - Epi - 2017-2018 - EpisDur - Index.dta"
drop if _merge==2
drop _merge
merge m:1 ixindid ixepis type using "PHIRST - Data - Lab - Ct Episodes - Wide - 2017-2018 - Index"
drop if _merge==2
drop _merge
*
merge m:1 hmindid using "PHIRST - Data - Masterlist - HM - 2016-2018.dta"
keep if _merge==3
drop _merge
merge m:1 hmindid hmepis type using "PHIRST - Data - Epi - 2017-2018 - Symptoms - HM - Double Count Coinfections - Yes.dta"
drop if _merge==2
drop _merge
sort year siteid type hhid clus hmindid, stable
*
gen ixagegrp1=1 if ixageyears<5
replace ixagegrp1=2 if ixageyears>=5 & ixageyears<10
replace ixagegrp1=3 if ixageyears>=10 & ixageyears<15
replace ixagegrp1=4 if ixageyears>=15 & ixageyears<20
replace ixagegrp1=5 if ixageyears>=20 & ixageyears<25
replace ixagegrp1=6 if ixageyears>=25 & ixageyears<45
replace ixagegrp1=7 if ixageyears>=45 & ixageyears<65
replace ixagegrp1=8 if ixageyears>=65 & ixageyears<75
replace ixagegrp1=9 if ixageyears>=75
label define ixagegrp1 1 "<5" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-44" 7 "45-64" 8 "65-74" 9 "75+"
label values ixagegrp1 ixagegrp1
*
rename ixhiv_status ixhiv
replace ixhiv=. if ixhiv==2
*
gen hmagegrp1=1 if hmageyears<5
replace hmagegrp1=2 if hmageyears>=5 & hmageyears<10
replace hmagegrp1=3 if hmageyears>=10 & hmageyears<15
replace hmagegrp1=4 if hmageyears>=15 & hmageyears<20
replace hmagegrp1=5 if hmageyears>=20 & hmageyears<25
replace hmagegrp1=6 if hmageyears>=25 & hmageyears<45
replace hmagegrp1=7 if hmageyears>=45 & hmageyears<65
replace hmagegrp1=8 if hmageyears>=65 & hmageyears<75
replace hmagegrp1=9 if hmageyears>=75
label define hmagegrp1 1 "<5" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-44" 7 "45-64" 8 "65-74" 9 "75+"
label values hmagegrp1 hmagegrp1
*
rename hmhiv_status hmhiv
replace hmhiv=. if hmhiv==2
*
rename ixnix rsv
*
save "PHIRST - Data - Lab - 2017-2018 - RF - HCIR.dta", replace


*************************
*Symptoms - Risk Factors*
*************************

*Not double counting coinfections*
*
use "PHIRST - Data - Epi - 2017-2018 - Symptoms - Double Count Coinfections - No.dta", clear
merge m:1 indid using "PHIRST - Data - Individual and HH-Level 2016-2018.dta"
keep if _merge==3
drop _merge
merge 1:1 indid epis type using "PHIRST - Data - Lab - Ct Episodes - Wide - 2017-2018 - Double Count Coinfections - No"
drop _merge
*
gen agegrp1=1 if ageyears<5
replace agegrp1=2 if ageyears>=5 & ageyears<10
replace agegrp1=3 if ageyears>=10 & ageyears<15
replace agegrp1=4 if ageyears>=15 & ageyears<20
replace agegrp1=5 if ageyears>=20 & ageyears<25
replace agegrp1=6 if ageyears>=25 & ageyears<45
replace agegrp1=7 if ageyears>=45 & ageyears<65
replace agegrp1=8 if ageyears>=65 & ageyears<75
replace agegrp1=9 if ageyears>=75
label define agegrp1 1 "<5" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-44" 7 "45-64" 8 "65-74" 9 "75+"
label values agegrp1 agegrp1
rename hiv_status hiv
replace hiv=. if hiv==2
*
rename type type1
gen type=type1
replace type=1 if type==3
replace type=3 if type==4
merge 1:1 indid epis type using "EpisDurAll.dta"
keep if _merge==3
drop _merge type
rename type1 type

save "PHIRST - Data - Lab - 2017-2018 - RF - Symptoms - Double Count Coinfections - No.dta", replace

*Double counting coinfections*
*
use "PHIRST - Data - Epi - 2017-2018 - Symptoms - Double Count Coinfections - Yes.dta", clear
merge m:1 indid using "PHIRST - Data - Individual and HH-Level 2016-2018.dta"
keep if _merge==3
drop _merge
merge 1:1 indid epis type using "PHIRST - Data - Lab - Ct Episodes - Wide - 2017-2018 - Double Count Coinfections - Yes"
drop _merge
*
gen agegrp1=1 if ageyears<5
replace agegrp1=2 if ageyears>=5 & ageyears<10
replace agegrp1=3 if ageyears>=10 & ageyears<15
replace agegrp1=4 if ageyears>=15 & ageyears<20
replace agegrp1=5 if ageyears>=20 & ageyears<25
replace agegrp1=6 if ageyears>=25 & ageyears<45
replace agegrp1=7 if ageyears>=45 & ageyears<65
replace agegrp1=8 if ageyears>=65 & ageyears<75
replace agegrp1=9 if ageyears>=75
label define agegrp1 1 "<5" 2 "5-9" 3 "10-14" 4 "15-19" 5 "20-24" 6 "25-44" 7 "45-64" 8 "65-74" 9 "75+"
label values agegrp1 agegrp1
rename hiv_status hiv
replace hiv=. if hiv==2
*
*
merge 1:1 indid epis type using "EpisDurAll.dta"
keep if _merge==3
drop _merge

save "PHIRST - Data - Lab - 2017-2018 - RF - Symptoms - Double Count Coinfections - Yes.dta", replace
