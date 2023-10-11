clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\"
*cd "C:\Users\cherylc\Documents\PHIRST 2019_2020\RSV analysis"
*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - RF - Episode Duration.dta", clear

capture log close
qui: log using "PHIRST - Results - RSV - 2017-2018 - RF - Episode Duration.smcl", replace


********************************************************
********************************************************
*PHIRST: RSV Episode Duration - Risk Factors - Analysis*
********************************************************
********************************************************

qui log off

*Generate additional variables*
*
*Age*
*
gen agecat11=1 if ageyears>=0 & ageyears<5
replace agecat11=2 if ageyears>=5 & ageyears<15
replace agecat11=3 if ageyears>=15 & ageyears<19
replace agecat11=4 if ageyears>=19 & ageyears<65
replace agecat11=5 if ageyears>=65 & ageyears!=.
label define agecat11 1 "<5" 2 "5-14" 3 "15-18" 4 "19-64" 5 "65+"
label values agecat11 agecat11
*
gen agecat12=1 if ageyears>=0 & ageyears<5
replace agecat12=2 if ageyears>=5 & ageyears<10
replace agecat12=3 if ageyears>=10 & ageyears<15
replace agecat12=4 if ageyears>=15 & ageyears<19
replace agecat12=5 if ageyears>=19 & ageyears<65
replace agecat12=6 if ageyears>=65 & ageyears!=.
label define agecat12 1 "<5" 2 "5-9" 3 "10-14" 4 "15-18" 5 "19-64" 6 "65+"
label values agecat12 agecat12
*
gen agecat13=1 if ageyears>=0 & ageyears<5
replace agecat13=2 if ageyears>=5 & ageyears<13
replace agecat13=3 if ageyears>=13 & ageyears<19
replace agecat13=4 if ageyears>=19 & ageyears<64
replace agecat13=5 if ageyears>=65 & ageyears!=.
label define agecat13 1 "<5" 2 "5-12" 3 "13-18" 4 "19-64" 5 "65+"
label values agecat13 agecat13
*
gen agecat14=1 if ageyears>=0 & ageyears<5
replace agecat14=2 if ageyears>=5 & ageyears<13
replace agecat14=3 if ageyears>=13 & ageyears<19
replace agecat14=4 if ageyears>=19 & ageyears<44
replace agecat14=5 if ageyears>=45 & ageyears!=.
label define agecat14 1 "<5" 2 "5-12" 3 "13-18" 4 "19-44" 5 "45+"
label values agecat14 agecat14
*
*Ct value
*
drop ctcat
gen ctcat=1 if minct<30
replace ctcat=0 if minct>=30 & minct!=.
label define ctcata 0 ">=30" 1 "<30"
label values ctcat ctcata
tab ctcat
*
gen ctcat1=1 if minct<35
replace ctcat1=0 if minct>=35 & minct!=.
label define ctcat1 0 ">=35" 1 "<35"
label values ctcat1 ctcat1
tab ctcat1
*
gen rsv=1
stset edur, failure(rsv)

qui log on

*Univariate analysis*
*All*
sum edur
sum edur, d

sort indid

gen gr21=0
replace gr21=1 if edur>21 & edur!=.
tab gr21

tab agecat5 gr21, col chi



*
*Year*
bysort year: sum edur, d
sts graph, by(year)
mestreg i.year || site: || hhid:, dist(weibull) nolog
*
*Site*
bysort site: sum edur, d
sts graph, by(site)
mestreg i.site || site: || hhid:, dist(weibull) nolog
*
*Age*
bysort agecat5: sum edur, d
sts graph, by(agecat5)
mestreg b5.agecat5 || site: || hhid:, dist(weibull) nolog
*
*Sex*
bysort sex: sum edur, d
sts graph, by(sex)
mestreg i.sex || site: || hhid:, dist(weibull) nolog
*
*HIV*
bysort hivfinal: sum edur, d
sts graph, by(hivfinal)
mestreg i.hivfinal || site: || hhid:, dist(weibull) nolog
*
*UMC*
bysort underill: sum edur, d
sts graph, by(underill)
mestreg i.underill || site: || hhid:, dist(weibull) nolog
*
*BMI*
bysort bmicat: sum edur, d
sts graph, by(bmicat)
mestreg b2.bmicat || site: || hhid:, dist(weibull) nolog
*
*Cotinine*
bysort cotinine: sum edur, d
sts graph, by(cotinine)
mestreg i.cotinine || site: || hhid:, dist(weibull) nolog
*
*Smoking*
bysort cigsmokenow: sum edur, d
sts graph, by(cigsmokenow)
mestreg i.cigsmokenow || site: || hhid:, dist(weibull) nolog
*
*Alcohol*
bysort alcohol: sum edur, d
sts graph, by(alcohol)
mestreg i.alcohol || site: || hhid:, dist(weibull) nolog
*
*Education*
bysort educlevel: sum edur, d
sts graph, by(educlevel)
mestreg i.educlevel || site: || hhid:, dist(weibull) nolog
*
*Employment*
bysort employed: sum edur, d
sts graph, by(employed)
mestreg i.employed || site: || hhid:, dist(weibull) nolog
*
*Household size*
bysort hh_size: sum edur, d
sts graph, by(hh_size)
mestreg i.hh_size || site: || hhid:, dist(weibull) nolog
*
*Number of sleeping rooms*
bysort numroomsleep: sum edur, d
sts graph, by(numroomsleep)
mestreg i.numroomsleep || site: || hhid:, dist(weibull) nolog
*
*Crowding*
bysort crowding: sum edur, d
sts graph, by(crowding)
mestreg i.crowding || site: || hhid:, dist(weibull) nolog
*
*Household income*
bysort hh_income: sum edur, d
sts graph, by(hh_income)
mestreg i.hh_income || site: || hhid:, dist(weibull) nolog
*
*RSV types*
bysort type: sum edur, d
sts graph, by(type)
mestreg i.type || site: || hhid:, dist(weibull) nolog
*
*Symptoms*
*
bysort symany: sum edur, d
sts graph, by(symany)
mestreg i.symany || site: || hhid:, dist(weibull) nolog
*
bysort symcat: sum edur, d
sts graph, by(symcat)
mestreg i.symcat || site: || hhid:, dist(weibull) nolog
*
bysort symili: sum edur, d
sts graph, by(symili)
mestreg i.symili || site: || hhid:, dist(weibull) nolog
*
*Ct-Value*
*
bysort ctcat: sum edur, d
sts graph, by(ctcat)
mestreg i.ctcat || site: || hhid:, dist(weibull) nolog
*
bysort ctcat1: sum edur, d
sts graph, by(ctcat1)
mestreg i.ctcat1 || site: || hhid:, dist(weibull) nolog


*Multivariable analysis*
mestreg i.ctcat i.symcat b5.agecat5 || site: || hhid:, dist(weibull) nolog

qui log close

view "PHIRST - Results - RSV - 2017-2018 - RF - Episode Duration.smcl"
