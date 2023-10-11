clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\"
*cd "C:\Users\cherylc\Documents\PHIRST 2019_2020\RSV analysis\"
*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - RF - HCIR.dta", clear
merge 1:1  hmindid type clus hmepis using "PHIRST - Data - Lab - 2017-2018 - HCIR-SI.dta"
drop _merge
drop if si==.
encode siteid, gen(site)
stset si, failure(rsv)

capture log close
qui: log using "PHIRST - Results - RSV - 2017-2018 - RF - Serial Interval.smcl", replace


***************************************************************************
***************************************************************************
*PHIRST: RSV Serial Interval - Risk Factors - Analysis (No SI restriction)*
***************************************************************************
***************************************************************************

qui log off

*Generate additional variables
*
*Episode duration (index case)
*
gen ixedurcat=1 if ixedur==3
replace ixedurcat=2 if ixedur>3 & ixedur<11
replace ixedurcat=3 if ixedur>10 & ixedur!=.
label define ixedurcat 1 ">=3" 2 "4-10" 3 "11+"
label values ixedurcat ixedurcat
*
gen ixedurcat1=1 if ixedur==3
replace ixedurcat1=2 if ixedur>3 & ixedur<7
replace ixedurcat1=3 if ixedur>6 & ixedur<10
replace ixedurcat1=4 if ixedur>9 & ixedur<13
replace ixedurcat1=5 if ixedur>12 & ixedur<16
replace ixedurcat1=6 if ixedur>15 & ixedur<19
replace ixedurcat1=7 if ixedur>18 & ixedur!=.
label define ixedurcat1 1 ">=3" 2 "4-6" 3 "7-9" 4 "10-12" 5 "13-15" 6 "16-18" 7 "19+"
label values ixedurcat1 ixedurcat1
*
*Ct-value (index case)
*
gen ixctcat=1 if ixminct<30
replace ixctcat=0 if ixminct>=30 & ixminct!=.
label define ixctcat 0 ">=30" 1 "<30"
label values ixctcat ixctcat
tab ixctcat
*
*Age*
gen ixagecat14=1 if ixageyears>=0 & ixageyears<5
replace ixagecat14=2 if ixageyears>=5 & ixageyears<13
replace ixagecat14=3 if ixageyears>=13 & ixageyears<19
replace ixagecat14=4 if ixageyears>=19 & ixageyears<44
replace ixagecat14=5 if ixageyears>=45 & ixageyears!=.
label define ixagecat14 1 "<5" 2 "5-12" 3 "13-18" 4 "19-44" 5 "45+"
label values ixagecat14 ixagecat14
*
gen hmagecat14=1 if hmageyears>=0 & hmageyears<5
replace hmagecat14=2 if hmageyears>=5 & hmageyears<13
replace hmagecat14=3 if hmageyears>=13 & hmageyears<19
replace hmagecat14=4 if hmageyears>=19 & hmageyears<44
replace hmagecat14=5 if hmageyears>=45 & hmageyears!=.
label define hmagecat14 1 "<5" 2 "5-12" 3 "13-18" 4 "19-44" 5 "45+"
label values hmagecat14 hmagecat14
*
gen ixagecat15=1 if ixageyears>=0 & ixageyears<5
replace ixagecat15=2 if ixageyears>=5 & ixageyears<19
replace ixagecat15=3 if ixageyears>=19 & ixageyears!=.
label define ixagecat15 1 "<5" 2 "5-18" 3 "19+" 
label values ixagecat15 ixagecat15
*
gen hmagecat15=1 if hmageyears>=0 & hmageyears<5
replace hmagecat15=2 if hmageyears>=5 & hmageyears<19
replace hmagecat15=3 if hmageyears>=19 & hmageyears!=.
label define hmagecat15 1 "<5" 2 "5-18" 3 "19+" 
label values hmagecat15 hmagecat15

qui log on

*Univariate analysis*
*
*All*
*
sum si
sum si, d
ci mean si

*General/household caracteristics*
*
*Year*
bysort year: sum si, d
sts graph, by(year)
mestreg i.year || site: || hhid:, dist(weibull) nolog
*
*Site*
bysort site: sum si, d
sts graph, by(site)
mestreg i.site || site: || hhid:, dist(weibull) nolog
*
*Household size*
bysort hmhh_size: sum si, d
sts graph, by(hmhh_size)
mestreg i.hmhh_size || site: || hhid:, dist(weibull) nolog
*
*Number of sleeping rooms*
bysort hmnumroomsleep: sum si, d
sts graph, by(hmnumroomsleep)
mestreg i.hmnumroomsleep || site: || hhid:, dist(weibull) nolog
*
*Crowding*
bysort hmcrowding: sum si, d
sts graph, by(hmcrowding)
mestreg i.hmcrowding || site: || hhid:, dist(weibull) nolog
*
*Household income*
bysort hmhh_income: sum si, d
sts graph, by(hmhh_income)
mestreg i.hmhh_income || site: || hhid:, dist(weibull) nolog

*Index case*
*
*Age*
bysort ixagecat5: sum si, d
sts graph, by(ixagecat5)
mestreg b5.ixagecat5 || site: || hhid:, dist(weibull) nolog
*
*Sex*
bysort ixsex: sum si, d
sts graph, by(ixsex)
mestreg i.ixsex || site: || hhid:, dist(weibull) nolog
*
*HIV*
bysort ixhivfinal: sum si, d
sts graph, by(ixhivfinal)
mestreg i.ixhivfinal || site: || hhid:, dist(weibull) nolog
*
*UMC*
bysort ixunderill: sum si, d
sts graph, by(ixunderill)
mestreg i.ixunderill || site: || hhid:, dist(weibull) nolog
*
*BMI*
bysort ixbmicat: sum si, d
sts graph, by(ixbmicat)
mestreg b2.ixbmicat || site: || hhid:, dist(weibull) nolog
*
*Cotinine*
bysort ixcotinine: sum si, d
sts graph, by(ixcotinine)
mestreg i.ixcotinine || site: || hhid:, dist(weibull) nolog
*
*Smoking*
bysort ixcigsmokenow: sum si, d
sts graph, by(ixcigsmokenow)
mestreg i.ixcigsmokenow || site: || hhid:, dist(weibull) nolog
*
*Alcohol*
bysort ixalcohol: sum si, d
sts graph, by(ixalcohol)
mestreg i.ixalcohol || site: || hhid:, dist(weibull) nolog
*
*Education*
bysort ixeduclevel: sum si, d
sts graph, by(ixeduclevel)
mestreg i.ixeduclevel || site: || hhid:, dist(weibull) nolog
*
*Employment*
bysort ixemployed: sum si, d
sts graph, by(ixemployed)
mestreg i.ixemployed || site: || hhid:, dist(weibull) nolog
*
*RSV types*
bysort type: sum si, d
sts graph, by(type)
mestreg i.type || site: || hhid:, dist(weibull) nolog
*
*Symptoms*
*
bysort ixsymany: sum si, d
sts graph, by(ixsymany)
mestreg i.ixsymany || site: || hhid:, dist(weibull) nolog
*
bysort ixsymcat: sum si, d
sts graph, by(ixsymcat)
mestreg i.ixsymcat || site: || hhid:, dist(weibull) nolog
*
bysort ixsymili: sum si, d
sts graph, by(ixsymili)
mestreg i.ixsymili || site: || hhid:, dist(weibull) nolog
*
*Episode duration*
*
bysort ixedurcat: sum si, d
sts graph, by(ixedurcat)
mestreg i.ixedurcat || site: || hhid:, dist(weibull) nolog
*
bysort ixedurcat1: sum si, d
sts graph, by(ixedurcat1)
mestreg i.ixedurcat1 || site: || hhid:, dist(weibull) nolog
*
*Ct-Value*
*
bysort ixctcat: sum si, d
sts graph, by(ixctcat)
mestreg i.ixctcat || site: || hhid:, dist(weibull) nolog

*Household members*
*
*Age*
bysort hmagecat5: sum si, d
sts graph, by(hmagecat5)
mestreg b5.hmagecat5 || site: || hhid:, dist(weibull) nolog
*
*Sex*
bysort hmsex: sum si, d
sts graph, by(hmsex)
mestreg i.hmsex || site: || hhid:, dist(weibull) nolog
*
*HIV*
bysort hmhivfinal: sum si, d
sts graph, by(hmhivfinal)
mestreg i.hmhivfinal || site: || hhid:, dist(weibull) nolog
*
*UMC*
bysort hmunderill: sum si, d
sts graph, by(hmunderill)
mestreg i.hmunderill || site: || hhid:, dist(weibull) nolog
*
*BMI*
bysort hmbmicat: sum si, d
sts graph, by(hmbmicat)
mestreg b2.hmbmicat || site: || hhid:, dist(weibull) nolog
*
*Cotinine*
bysort hmcotinine: sum si, d
sts graph, by(hmcotinine)
mestreg i.hmcotinine || site: || hhid:, dist(weibull) nolog
*
*Smoking*
bysort hmcigsmokenow: sum si, d
sts graph, by(hmcigsmokenow)
mestreg i.hmcigsmokenow || site: || hhid:, dist(weibull) nolog
*
*Alcohol*
bysort hmalcohol: sum si, d
sts graph, by(hmalcohol)
mestreg i.hmalcohol || site: || hhid:, dist(weibull) nolog
*
*Education*
bysort hmeduclevel: sum si, d
sts graph, by(hmeduclevel)
mestreg i.hmeduclevel || site: || hhid:, dist(weibull) nolog
*
*Employment*
bysort hmemployed: sum si, d
sts graph, by(hmemployed)
mestreg i.hmemployed || site: || hhid:, dist(weibull) nolog


*Multivariable analysis*


qui log off

keep if si<17

qui log on 


********************************************************************
********************************************************************
*PHIRST: RSV Serial Interval - Risk Factors - Analysis (SI <17 days)*
********************************************************************
********************************************************************

*Univariate analysis*
*
*All*
*
sum si
sum si, d
*ci mean si

*General/household caracteristics*
*
*Year*
bysort year: sum si, d
sts graph, by(year)
mestreg i.year || site: || hhid:, dist(weibull) nolog
*
*Site*
bysort site: sum si, d
sts graph, by(site)
mestreg i.site || site: || hhid:, dist(weibull) nolog
*
*Household size*
bysort hmhh_size: sum si, d
sts graph, by(hmhh_size)
mestreg i.hmhh_size || site: || hhid:, dist(weibull) nolog
*
*Number of sleeping rooms*
bysort hmnumroomsleep: sum si, d
sts graph, by(hmnumroomsleep)
mestreg i.hmnumroomsleep || site: || hhid:, dist(weibull) nolog
*
*Crowding*
bysort hmcrowding: sum si, d
sts graph, by(hmcrowding)
mestreg i.hmcrowding || site: || hhid:, dist(weibull) nolog
*
*Household income*
bysort hmhh_income: sum si, d
sts graph, by(hmhh_income)
mestreg i.hmhh_income || site: || hhid:, dist(weibull) nolog

*Index case*
*
*Age*
bysort ixagecat5: sum si, d
sts graph, by(ixagecat5)
mestreg b5.ixagecat5 || site: || hhid:, dist(weibull) nolog
*
*Sex*
bysort ixsex: sum si, d
sts graph, by(ixsex)
mestreg i.ixsex || site: || hhid:, dist(weibull) nolog
*
*HIV*
bysort ixhivfinal: sum si, d
sts graph, by(ixhivfinal)
mestreg i.ixhivfinal || site: || hhid:, dist(weibull) nolog
*
*UMC*
bysort ixunderill: sum si, d
sts graph, by(ixunderill)
mestreg i.ixunderill || site: || hhid:, dist(weibull) nolog
*
*BMI*
bysort ixbmicat: sum si, d
sts graph, by(ixbmicat)
mestreg b2.ixbmicat || site: || hhid:, dist(weibull) nolog
*
*Cotinine*
bysort ixcotinine: sum si, d
sts graph, by(ixcotinine)
mestreg i.ixcotinine || site: || hhid:, dist(weibull) nolog
*
*Smoking*
bysort ixcigsmokenow: sum si, d
sts graph, by(ixcigsmokenow)
mestreg i.ixcigsmokenow || site: || hhid:, dist(weibull) nolog
*
*Alcohol*
bysort ixalcohol: sum si, d
sts graph, by(ixalcohol)
mestreg i.ixalcohol || site: || hhid:, dist(weibull) nolog
*
*Education*
bysort ixeduclevel: sum si, d
sts graph, by(ixeduclevel)
mestreg i.ixeduclevel || site: || hhid:, dist(weibull) nolog
*
*Employment*
bysort ixemployed: sum si, d
sts graph, by(ixemployed)
mestreg i.ixemployed || site: || hhid:, dist(weibull) nolog
*
*RSV types*
bysort type: sum si, d
sts graph, by(type)
mestreg i.type || site: || hhid:, dist(weibull) nolog
mestreg b2.type || site: || hhid:, dist(weibull) nolog
*
*
*Symptoms*
*
bysort ixsymany: sum si, d
sts graph, by(ixsymany)
mestreg i.ixsymany || site: || hhid:, dist(weibull) nolog
*
bysort ixsymcat: sum si, d
sts graph, by(ixsymcat)
mestreg i.ixsymcat || site: || hhid:, dist(weibull) nolog
*
bysort ixsymili: sum si, d
sts graph, by(ixsymili)
mestreg i.ixsymili || site: || hhid:, dist(weibull) nolog
*
*Episode duration*
*
bysort ixedurcat: sum si, d
sts graph, by(ixedurcat)
mestreg i.ixedurcat || site: || hhid:, dist(weibull) nolog
*
bysort ixedurcat1: sum si, d
sts graph, by(ixedurcat1)
mestreg i.ixedurcat1 || site: || hhid:, dist(weibull) nolog
*
*Ct-Value*
*
bysort ixctcat: sum si, d
sts graph, by(ixctcat)
mestreg i.ixctcat || site: || hhid:, dist(weibull) nolog

*Household members*
*
*Age*
bysort hmagecat5: sum si, d
sts graph, by(hmagecat5)
mestreg b5.hmagecat5 || site: || hhid:, dist(weibull) nolog
mestreg b2.hmagecat5 || site: || hhid:, dist(weibull) nolog
*
*Sex*
bysort hmsex: sum si, d
sts graph, by(hmsex)
mestreg i.hmsex || site: || hhid:, dist(weibull) nolog
*
*HIV*
bysort hmhivfinal: sum si, d
sts graph, by(hmhivfinal)
mestreg i.hmhivfinal || site: || hhid:, dist(weibull) nolog
*
*UMC*
bysort hmunderill: sum si, d
sts graph, by(hmunderill)
mestreg i.hmunderill || site: || hhid:, dist(weibull) nolog
*
*BMI*
bysort hmbmicat: sum si, d
sts graph, by(hmbmicat)
mestreg b2.hmbmicat || site: || hhid:, dist(weibull) nolog
*
*Cotinine*
bysort hmcotinine: sum si, d
sts graph, by(hmcotinine)
mestreg i.hmcotinine || site: || hhid:, dist(weibull) nolog
*
*Smoking*
bysort hmcigsmokenow: sum si, d
sts graph, by(hmcigsmokenow)
mestreg i.hmcigsmokenow || site: || hhid:, dist(weibull) nolog
*
*Alcohol*
bysort hmalcohol: sum si, d
sts graph, by(hmalcohol)
mestreg i.hmalcohol || site: || hhid:, dist(weibull) nolog
*
*Education*
bysort hmeduclevel: sum si, d
sts graph, by(hmeduclevel)
mestreg i.hmeduclevel || site: || hhid:, dist(weibull) nolog
*
*Employment*
bysort hmemployed: sum si, d
sts graph, by(hmemployed)
mestreg i.hmemployed || site: || hhid:, dist(weibull) nolog


*Multivariable analysis*
mestreg b2.hmagecat5 i.hmhivfinal i.ixedurcat i.ixctcat i.type b5.ixagecat5|| site: || hhid:, dist(weibull) nolog

mestreg b2.hmagecat5 i.type b5.ixagecat5|| site: || hhid:, dist(weibull) nolog

mestreg b2.hmagecat5 i.type b5.ixagecat5 i.ixsymcat|| site: || hhid:, dist(weibull) nolog
mestreg b2.hmagecat5 i.type b5.ixagecat5 i.ixedurcat|| site: || hhid:, dist(weibull) nolog

mestreg b2.hmagecat5 i.type b5.ixagecat5 i.ixunderill|| site: || hhid:, dist(weibull) nolog

**FInal Model
mestreg  i.type b5.ixagecat5 b2.hmagecat5|| site: || hhid:, dist(weibull) nolog
**Sensitivty analysis - SI <10 days
**Multivariable analysis*


qui log off

keep if si<10

qui log on 


********************************************************************
********************************************************************
*PHIRST: RSV Serial Interval - Risk Factors - Analysis (SI <10 days)*
********************************************************************
********************************************************************

*Univariate analysis*
*
*All*
*
sum si
sum si, d
*ci mean si
**FInal Model
mestreg  i.type || site: || hhid:, dist(weibull) nolog
mestreg   b5.ixagecat5 || site: || hhid:, dist(weibull) nolog
mestreg  b2.hmagecat5|| site: || hhid:, dist(weibull) nolog

mestreg  i.type b5.ixagecat5 b2.hmagecat5|| site: || hhid:, dist(weibull) nolog

**Sensitivty analysis - SI <8 days
*Multivariable analysis*


qui log off

keep if si<8

qui log on 


********************************************************************
********************************************************************
*PHIRST: RSV Serial Interval - Risk Factors - Analysis (SI <8 days)*
********************************************************************
********************************************************************

*Univariate analysis*
*
*All*
*
sum si
sum si, d
*ci mean si
**FInal Model
mestreg  i.type || site: || hhid:, dist(weibull) nolog

bysort ixagecat5: sum si, d
sts graph, by(ixagecat5)
mestreg   b5.ixagecat5 || site: || hhid:, dist(weibull) nolog
mestreg  b2.hmagecat5|| site: || hhid:, dist(weibull) nolog
mestreg  i.type b5.ixagecat5 b2.hmagecat5|| site: || hhid:, dist(weibull) nolog

qui log close

view "PHIRST - Results - RSV - 2017-2018 - RF - Serial Interval.smcl"
