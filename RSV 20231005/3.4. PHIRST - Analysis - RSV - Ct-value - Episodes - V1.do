***********************************************************************
***********************************************************************
* PHIRST: RSV Ct-Values - Analysis - Do Not Double Count Co-Infections*
***********************************************************************
***********************************************************************

clear
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 

*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear 

*Merge Ct-Values*
merge 1:1 fuid using "PHIRST - Data - Lab - RSV - Ct-Value - 2017-2018.dta"
drop _merge
*
gen rsvab=1 if ersvafn==1 & ersvbfn==1
gen meanct=rsvct
gen maxct=rsvct
gen minct=rsvct
*
save "PHIRST - Data - Lab - Ct Episodes - 2017-2018 - Long.dta", replace


*******************************************************************************
*Generate dataset with ct-values by episode - Do Not Double Count Coinfections*
*******************************************************************************

*RSV A*
keep if ersvafn!=.
collapse (max) maxct rsvab (min) minct (mean) meanct, by(year siteid hhid indid ersvafn)
rename ersvafn epis
gen type=1
replace type=3 if rsvab==1
drop rsvab
save "EpisCtRSVA.dta", replace
clear

*RSV B*
use "PHIRST - Data - Lab - Ct Episodes - 2017-2018 - Long.dta", clear
keep if ersvbfn!=.
collapse (max) maxct rsvab (min) minct (mean) meanct, by(year siteid hhid indid ersvbfn)
rename ersvbfn epis
gen type=2
drop if rsvab==1
save "EpisCtRSVB.dta", replace
clear

*RSV Untyped*
use "PHIRST - Data - Lab - Ct Episodes - 2017-2018 - Long.dta", clear
keep if ersvutpfn!=.
collapse (max) maxct (min) minct (mean) meanct, by(year siteid hhid indid ersvutpfn)
rename ersvutpfn epis
gen type=4
save "EpisCtRSVUtp.dta", replace
clear

*Append RSV types datasets*
use "EpisCtRSVA.dta", clear
append using "EpisCtRSVB.dta"
append using "EpisCtRSVUtp.dta"
label define type 1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values type type
order year siteid hhid indid type epis 
drop rsvab

save "PHIRST - Data - Lab - Ct Episodes - Wide - 2017-2018 - Double Count Coinfections - No", replace
tab type year


************************************************************************
*Generate dataset with ct-values by episode - Double Count Coinfections*
************************************************************************

*RSV A*
use "PHIRST - Data - Lab - Ct Episodes - 2017-2018 - Long.dta", clear
keep if ersvafn!=.
collapse (max) maxct (min) minct (mean) meanct, by(year siteid hhid indid ersvafn)
rename ersvafn epis
gen type=1
save "EpisCtRSVA.dta", replace
clear

*RSV B*
use "PHIRST - Data - Lab - Ct Episodes - 2017-2018 - Long.dta", clear
keep if ersvbfn!=.
collapse (max) maxct rsvab (min) minct (mean) meanct, by(year siteid hhid indid ersvbfn)
rename ersvbfn epis
gen type=2
save "EpisCtRSVB.dta", replace
clear

*RSV Untyped*
use "PHIRST - Data - Lab - Ct Episodes - 2017-2018 - Long.dta", clear
keep if ersvutpfn!=.
collapse (max) maxct (min) minct (mean) meanct, by(year siteid hhid indid ersvutpfn)
rename ersvutpfn epis
gen type=3
save "EpisCtRSVUtp.dta", replace
clear

*Append RSV types datasets*
use "EpisCtRSVA.dta", clear
append using "EpisCtRSVB.dta"
append using "EpisCtRSVUtp.dta"
label define type1 1 "A" 2 "B" 3 "Untyped"
label values type type1
order year siteid hhid indid type epis 
drop rsvab

save "PHIRST - Data - Lab - Ct Episodes - Wide - 2017-2018 - Double Count Coinfections - Yes", replace
tab type year

