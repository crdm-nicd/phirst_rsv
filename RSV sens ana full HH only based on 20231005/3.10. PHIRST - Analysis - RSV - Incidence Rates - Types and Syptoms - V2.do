clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 

capture log close
qui: log using "PHIRST - Results - RSV - 2017-2018 - Incidence.smcl", replace

**********************************
**********************************
*PHIRST: RSV Incidence - Analysis*
**********************************
**********************************

qui log off

*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear 

*Generate RSV types*
*
gen ab1=100 if ersvafn==1 & ersvbfn==1
bysort indid ersvafn: egen ab2=max(ab1)
bysort indid ersvbfn: egen ab3=max(ab1)
gen ab4=ab2
replace ab4=100 if ab3==100
*
gen type=ab4
replace type=3 if frsvafn==1 & ersvbfn==1
replace type=3 if ersvafn==1 & frsvbfn==1
replace type=1 if frsvafn==1 & type==.
replace type=2 if frsvbfn==1 & type==.
replace type=4 if frsvutpfn==1 & type==.
replace type=. if type==100
label define type 1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values type type
tab type
drop ab1-ab4

*Generate number of episodes for all types*
gen rsvepis=1 if type!=.
replace rsvepis=0 if rsvepis==.
tab rsvepis

*Generate number of episodes by types*
*
*RSV A*
gen rsvaepis=1 if type==1 | type==3
replace rsvaepis=0 if rsvaepis==.
tab rsvaepis
*
*RSV B*
gen rsvbepis=1 if type==2 | type==3
replace rsvbepis=0 if rsvbepis==.
tab rsvbepis
*
*RSV untyped*
gen rsvutpepis=1 if type==4
replace rsvutpepis=0 if rsvutpepis==.
tab rsvutpepis

*Generate episode number for all types*
gen epis=ersvafn if type==1
replace epis=ersvafn if type==3
replace epis=ersvbfn if type==2
replace epis=ersvutpfn if type==4
tab epis

*Time on follow-up*
bysort indid: egen datemax=max(npsdatecol)
bysort indid: egen datemin=min(npsdatecol)
gen ptimevis=npsdatecol-datemin+1
gen ptimeall=datemax-datemin+1

*Drop missing follow-up visits*
drop if rsv==90

save "PHIRST - Data - Lab - 2017-2018 - Incidence.dta", replace

*Merge symptoms dataset*
merge m:1 indid epis type using "PHIRST - Data - Epi - 2017-2018 - Symptoms - Double Count Coinfections - No.dta"
drop _merge

*Generate symptomatic illness variables irrespective of seeking care (any RSV)*
*
*>=1 symptom*
gen symone=1 if symany==1
*
*>=2 symptom*
gen symtwo=1 if symnum>1 & symnum!=.
*
*ILI*
gen symili1=1 if symili==3

*Generate medically attended symptomatic illness variables (any RSV)*
*
*>=1 symptom*
gen symonema=1 if symone==1 & outvisit==1
*
*>=2 symptom*
gen symtwoma=1 if symtwo==1 & outvisit==1
*
*ILI*
gen symili1ma=1 if symili1==1 & outvisit==1

*Generate non-medically attended symptomatic illness variables (any RSV)*
*
*>=1 symptom*
gen symonenma=1 if symone==1 & outvisit==0
*
*>=2 symptom*
gen symtwonma=1 if symtwo==1 & outvisit==0
*
*ILI*
gen symili1nma=1 if symili1==1 & outvisit==0

*Generate symptomatic illness variables irrespective of seeking care (RSV A)*
*
*>=1 symptom*
gen symonea=1 if symany==1 & rsvaepis==1
*
*>=2 symptom*
gen symtwoa=1 if symnum>1 & symnum!=. & rsvaepis==1
*
*ILI*
gen symili1a=1 if symili==3 & rsvaepis==1

*Generate medically attended symptomatic illness variables (RSV A)*
*
*>=1 symptom*
gen symoneama=1 if symone==1 & outvisit==1 & rsvaepis==1
*
*>=2 symptom*
gen symtwoama=1 if symtwo==1 & outvisit==1 & rsvaepis==1
*
*ILI*
gen symili1ama=1 if symili1==1 & outvisit==1 & rsvaepis==1

*Generate non-medically attended symptomatic illness variables (RSV A)*
*
*>=1 symptom*
gen symoneanma=1 if symone==1 & outvisit==0 & rsvaepis==1
*
*>=2 symptom*
gen symtwoanma=1 if symtwo==1 & outvisit==0 & rsvaepis==1
*
*ILI*
gen symili1anma=1 if symili1==1 & outvisit==0 & rsvaepis==1

*Generate symptomatic illness variables irrespective of seeking care (RSV B)*
*
*>=1 symptom*
gen symoneb=1 if symany==1 & rsvbepis==1
*
*>=2 symptom*
gen symtwob=1 if symnum>1 & symnum!=. & rsvbepis==1
*
*ILI*
gen symili1b=1 if symili==3 & rsvbepis==1

*Generate medically attended symptomatic illness variables (RSV B)*
*
*>=1 symptom*
gen symonebma=1 if symone==1 & outvisit==1 & rsvbepis==1
*
*>=2 symptom*
gen symtwobma=1 if symtwo==1 & outvisit==1 & rsvbepis==1
*
*ILI*
gen symili1bma=1 if symili1==1 & outvisit==1 & rsvbepis==1

*Generate non-medically attended symptomatic illness variables (RSV B)*
*
*>=1 symptom*
gen symonebnma=1 if symone==1 & outvisit==0 & rsvbepis==1
*
*>=2 symptom*
gen symtwobnma=1 if symtwo==1 & outvisit==0 & rsvbepis==1
*
*ILI*
gen symili1bnma=1 if symili1==1 & outvisit==0 & rsvbepis==1

*Generate symptomatic illness variables irrespective of seeking care (RSV untyped)*
*
*>=1 symptom*
gen symoneutp=1 if symany==1 & rsvutpepis==1
*
*>=2 symptom*
gen symtwoutp=1 if symnum>1 & symnum!=. & rsvutpepis==1
*
*ILI*
gen symili1utp=1 if symili==3 & rsvutpepis==1

*Generate medically attended symptomatic illness variables (RSV untyped)*
*
*>=1 symptom*
gen symoneutpma=1 if symone==1 & outvisit==1 & rsvutpepis==1
*
*>=2 symptom*
gen symtwoutpma=1 if symtwo==1 & outvisit==1 & rsvutpepis==1
*
*ILI*
gen symili1utpma=1 if symili1==1 & outvisit==1 & rsvutpepis==1

*Generate non-medically attended symptomatic illness variables (RSV untyped)*
*
*>=1 symptom*
gen symoneutpnma=1 if symone==1 & outvisit==0 & rsvutpepis==1
*
*>=2 symptom*
gen symtwoutpnma=1 if symtwo==1 & outvisit==0 & rsvutpepis==1
*
*ILI*
gen symili1utpnma=1 if symili1==1 & outvisit==0 & rsvutpepis==1

*Merge dataset with masterlist*
merge m:1 indid using "PHIRST - Data - Individual and HH-Level 2016-2018.dta"
drop if _merge==2
drop _merge
*
save "PHIRST - Data - Lab - 2017-2018 - Incidence - Variables.dta", replace

qui log on

*************************************
*************************************
*RSV Incidence (per 100 person week)*
*************************************
*************************************


***************
*RSV infection*
***************

stset ptimevis, id(indid) failure(rsvepis=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*****************
*RSV any symptom*
*****************

stset ptimevis, id(indid) failure(symone=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

****************
*RSV 2+ symtoms*
****************

stset ptimevis, id(indid) failure(symtwo=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*********
*RSV ILI*
*********

stset ptimevis, id(indid) failure(symili1=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

************************************
*RSV any symptom medically attended*
************************************

stset ptimevis, id(indid) failure(symonema=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

***********************************
*RSV 2+ symtoms medically attended*
***********************************

stset ptimevis, id(indid) failure(symtwoma=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

****************************
*RSV ILI medically attended*
****************************

stset ptimevis, id(indid) failure(symili1ma=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)


*****************
*RSV A infection*
*****************

stset ptimevis, id(indid) failure(rsvaepis=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*******************
*RSV A any symptom*
*******************

stset ptimevis, id(indid) failure(symonea=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

******************
*RSV A 2+ symtoms*
******************

stset ptimevis, id(indid) failure(symtwoa=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

***********
*RSV A ILI*
***********

stset ptimevis, id(indid) failure(symili1a=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

**************************************
*RSV A any symptom medically attended*
**************************************

stset ptimevis, id(indid) failure(symoneama=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*************************************
*RSV A 2+ symtoms medically attended*
*************************************

stset ptimevis, id(indid) failure(symtwoama=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

******************************
*RSV A ILI medically attended*
******************************

stset ptimevis, id(indid) failure(symili1ama=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)


*****************
*RSV B infection*
*****************

stset ptimevis, id(indid) failure(rsvbepis=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*******************
*RSV B any symptom*
*******************

stset ptimevis, id(indid) failure(symoneb=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

******************
*RSV B 2+ symtoms*
******************

stset ptimevis, id(indid) failure(symtwob=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

***********
*RSV B ILI*
***********

stset ptimevis, id(indid) failure(symili1b=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

**************************************
*RSV B any symptom medically attended*
**************************************

stset ptimevis, id(indid) failure(symonebma=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*************************************
*RSV B 2+ symtoms medically attended*
*************************************

stset ptimevis, id(indid) failure(symtwobma=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

******************************
*RSV B ILI medically attended*
******************************

stset ptimevis, id(indid) failure(symili1bma=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)


***********************
*RSV untyped infection*
***********************

stset ptimevis, id(indid) failure(rsvutpepis=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*************************
*RSV untyped any symptom*
*************************

stset ptimevis, id(indid) failure(symoneutp=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

************************
*RSV untyped 2+ symtoms*
************************

stset ptimevis, id(indid) failure(symtwoutp=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*****************
*RSV untyped ILI*
*****************

stset ptimevis, id(indid) failure(symili1utp=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

********************************************
*RSV untyped any symptom medically attended*
********************************************

stset ptimevis, id(indid) failure(symoneutpma=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*******************************************
*RSV untyped 2+ symtoms medically attended*
*******************************************

stset ptimevis, id(indid) failure(symtwoutpma=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

************************************
*RSV untyped ILI medically attended*
************************************

stset ptimevis, id(indid) failure(symili1utpma=1) scale(7) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)




*************************************
*************************************
*RSV Incidence (per 100 person year)*
*************************************
*************************************


***************
*RSV infection*
***************

stset ptimevis, id(indid) failure(rsvepis=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*****************
*RSV any symptom*
*****************

stset ptimevis, id(indid) failure(symone=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

****************
*RSV 2+ symtoms*
****************

stset ptimevis, id(indid) failure(symtwo=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*********
*RSV ILI*
*********

stset ptimevis, id(indid) failure(symili1=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

************************************
*RSV any symptom medically attended*
************************************

stset ptimevis, id(indid) failure(symonema=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

***********************************
*RSV 2+ symtoms medically attended*
***********************************

stset ptimevis, id(indid) failure(symtwoma=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

****************************
*RSV ILI medically attended*
****************************

stset ptimevis, id(indid) failure(symili1ma=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)


*****************
*RSV A infection*
*****************

stset ptimevis, id(indid) failure(rsvaepis=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*******************
*RSV A any symptom*
*******************

stset ptimevis, id(indid) failure(symonea=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

******************
*RSV A 2+ symtoms*
******************

stset ptimevis, id(indid) failure(symtwoa=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

***********
*RSV A ILI*
***********

stset ptimevis, id(indid) failure(symili1a=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

**************************************
*RSV A any symptom medically attended*
**************************************

stset ptimevis, id(indid) failure(symoneama=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*************************************
*RSV A 2+ symtoms medically attended*
*************************************

stset ptimevis, id(indid) failure(symtwoama=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

******************************
*RSV A ILI medically attended*
******************************

stset ptimevis, id(indid) failure(symili1ama=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)


*****************
*RSV B infection*
*****************

stset ptimevis, id(indid) failure(rsvbepis=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*******************
*RSV B any symptom*
*******************

stset ptimevis, id(indid) failure(symoneb=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

******************
*RSV B 2+ symtoms*
******************

stset ptimevis, id(indid) failure(symtwob=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

***********
*RSV B ILI*
***********

stset ptimevis, id(indid) failure(symili1b=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

**************************************
*RSV B any symptom medically attended*
**************************************

stset ptimevis, id(indid) failure(symonebma=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*************************************
*RSV B 2+ symtoms medically attended*
*************************************

stset ptimevis, id(indid) failure(symtwobma=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

******************************
*RSV B ILI medically attended*
******************************

stset ptimevis, id(indid) failure(symili1bma=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)


***********************
*RSV untyped infection*
***********************

stset ptimevis, id(indid) failure(rsvutpepis=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*************************
*RSV untyped any symptom*
*************************

stset ptimevis, id(indid) failure(symoneutp=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

************************
*RSV untyped 2+ symtoms*
************************

stset ptimevis, id(indid) failure(symtwoutp=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*****************
*RSV untyped ILI*
*****************

stset ptimevis, id(indid) failure(symili1utp=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

********************************************
*RSV untyped any symptom medically attended*
********************************************

stset ptimevis, id(indid) failure(symoneutpma=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

*******************************************
*RSV untyped 2+ symtoms medically attended*
*******************************************

stset ptimevis, id(indid) failure(symtwoutpma=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

************************************
*RSV untyped ILI medically attended*
************************************

stset ptimevis, id(indid) failure(symili1utpma=1) scale(365) exit(time .)
*
*All*
stptime, per(100) dd(2)
*
*By year*
stptime, per(100) dd(2) by(year)
*
*By site*
stptime, per(100) dd(2) by(siteid)
*
*By year & site*
bysort year: stptime, per(100) dd(2) by(siteid)
*
*By age*
stptime, per(100) dd(2) by(agecat5)

qui: log close

view "PHIRST - Results - RSV - 2017-2018 - Incidence.smcl"

use "PHIRST - Data - Lab - 2017-2018 - Incidence.dta", clear

*Obtain collepsed dataset (one row per individual)
collapse (sum) rsvepis (max) ptimeall, by (year siteid hhid indid)

*Generate RSV-positive at least once variable*
gen rsvany=1 if rsvepis>0
replace rsvany=0 if rsvany==.

*Merge dataset with masterlist*
merge m:1 indid using "PHIRST - Data - Individual and HH-Level 2016-2018.dta"
drop if _merge==2
drop _merge
*
save "PHIRST - Data - Lab - 2017-2018 - RF - Incidence.dta", replace


