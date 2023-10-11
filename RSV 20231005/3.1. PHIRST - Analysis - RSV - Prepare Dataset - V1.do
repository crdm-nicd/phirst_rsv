**************************************
**************************************
*PHIRST: Prepare dataset for analysis*
**************************************
**************************************

clear
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 

*Import dataset*
use "PHIRST - Data - Individual and HH-Level 2016-2018.dta", clear
keep ind_id
rename ind_id indid
save "IndID.dta", replace
use "PHIRST - Data - Lab - 2016-2018_21Dec2021.dta", clear

*Generate variables*
*
*RSV types*
replace rsvtp=0 if rsv==0
replace rsvtp=1 if final_based_on_ct_rsv=="RSVA"
replace rsvtp=2 if final_based_on_ct_rsv=="RSVB"
replace rsvtp=3 if final_based_on_ct_rsv=="RSVAB"
replace rsvtp=4 if final_based_on_ct_rsv=="RSV unsubtyped"
*label define rsvtp 0 "Neg" 1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values rsvtp rsvtp
*
*RSV type A (with untyped)*
gen rsvautp=1 if rsvtp==1 | rsvtp==3
replace rsvautp=2 if rsvtp==4
replace rsvautp=0 if rsvtp==0 | rsvtp==2
label define rsvautp 0 "Neg" 1 "A" 2 "Untyped"
label values rsvautp rsvautp
*
*RSV type B (with untyped)*
gen rsvbutp=1 if rsvtp==2 | rsvtp==3
replace rsvbutp=2 if rsvtp==4
replace rsvbutp=0 if rsvtp==0 | rsvtp==1
label define rsvbutp 0 "Neg" 1 "B" 2 "Untyped"
label values rsvbutp rsvbutp

*Subset dataset for analysis*
drop if year==2016
keep if ind_inc_ana==1
keep year siteid hhid indid funum rsv rsvtp rsvautp rsvbutp npsdatecol
order year siteid hhid indid funum rsv rsvtp rsvautp rsvbutp npsdatecol
merge m:1 indid using "IndID.dta"
keep if _merge==3
drop _merge
*
save "PHIRST - Data - Lab - RSV - 2017-2018.dta", replace

*Import dataset*
use "PHIRST - Data - Lab - 2016-2018_21Dec2021.dta", clear

*Subset dataset for analysis*
gen rsvct=npsrsvct if rsv==1
keep if rsv==1
drop if year==2016
keep if ind_inc_ana==1
merge m:1 indid using "IndID.dta"
keep if _merge==3
drop _merge
keep fuid rsvct
*
save "PHIRST - Data - Lab - RSV - Ct-Value - 2017-2018.dta", replace
