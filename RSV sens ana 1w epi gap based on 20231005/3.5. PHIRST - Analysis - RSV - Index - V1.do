**********************************************
**********************************************
* PHIRST: RSV Household Index Case - Analysis*
**********************************************
**********************************************

clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 

*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - Clusters.dta", clear 
sort hhid funum, stable

*********************************************************
*Identify the index and last case of a household cluster*
*********************************************************

*RSV A*
forval i = 1/20 {
quietly gen ersvai`i'=ersvaf`i'
}
*
gen rsvai=.
foreach var of varlist ersvai* {
quietly replace `var'=2 if `var'==1 & frsvaf==1
quietly replace rsvai=2 if `var'==2
}
tab rsvai frsvaf, m
*
gen coprrsva=0
forval i = 1/20 {
replace coprrsva=coprrsva+ersvai`i' if ersvai`i'==2
}
replace coprrsva=. if coprrsva==0
replace coprrsva=coprrsva/2
*
forval i = 1/20 {
quietly gen ersval`i'=ersvaf`i'
}
gen rsval=.
foreach var of varlist ersval* {
quietly replace `var'=3 if `var'==1 & lrsvaf==1
quietly replace rsval=3 if `var'==3
}
tab rsval lrsvaf, m

*RSV B*
forval i = 1/20 {
quietly gen ersvbi`i'=ersvbf`i'
}
*
gen rsvbi=.
foreach var of varlist ersvbi* {
quietly replace `var'=2 if `var'==1 & frsvbf==1
quietly replace rsvbi=2 if `var'==2
}
tab rsvbi frsvbf, m
*
gen coprrsvb=0
forval i = 1/20 {
replace coprrsvb=coprrsvb+ersvbi`i' if ersvbi`i'==2
}
replace coprrsvb=. if coprrsvb==0
replace coprrsvb=coprrsvb/2
*
forval i = 1/20 {
quietly gen ersvbl`i'=ersvbf`i'
}
*
gen rsvbl=.
foreach var of varlist ersvbl* {
quietly replace `var'=3 if `var'==1 & lrsvbf==1
quietly replace rsvbl=3 if `var'==3
}
tab rsvbl lrsvbf, m

*RSV untyped*
forval i = 1/20 {
quietly gen ersvutpi`i'=ersvutpf`i'
}
*
gen rsvutpi=.
foreach var of varlist ersvutpi* {
quietly replace `var'=2 if `var'==1 & frsvutpf==1
quietly replace rsvutpi=2 if `var'==2
}
tab rsvutpi frsvutpf, m
*
gen coprrsvutp=0
forval i = 1/20 {
replace coprrsvutp=coprrsvutp+ersvutpi`i' if ersvutpi`i'==2
}
replace coprrsvutp=. if coprrsvutp==0
replace coprrsvutp=coprrsvutp/2
*
forval i = 1/20 {
quietly gen ersvutpl`i'=ersvutpf`i'
}
*
gen rsvutpl=.
foreach var of varlist ersvutpl* {
quietly replace `var'=3 if `var'==1 & lrsvutpf==1
quietly replace rsvutpl=3 if `var'==3
}
tab rsvutpl lrsvutpf, m
*
sort hhid funum, stable
save "PHIRST - Data - Lab - 2017-2018 - Index (Wide).dta", replace

