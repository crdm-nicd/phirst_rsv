clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\"
*cd "C:\Users\cherylc\Documents\PHIRST 2019_2020\RSV analysis"

*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - RF - HCIR.dta", clear
merge 1:1  hmindid type clus hmepis  using "PHIRST - Data - Lab - 2017-2018 - HCIR-SI.dta"
drop _merge
keep if sus==1
encode siteid, gen(site)

capture log close
qui: log using "PHIRST - Results - RSV - 2017-2018 - RF - HCIR - All SI.smcl", replace


****************************************************************
****************************************************************
*PHIRST: RSV HCIR - Risk Factors - Analysis (No SI restriction)*
****************************************************************
****************************************************************

qui log off

*Generate additional variables
*
*Episode duration (index case)
*
gen ixedurcat=1 if ixedur==3
replace ixedurcat=2 if ixedur>3 & ixedur<11
replace ixedurcat=3 if ixedur>10 & ixedur!=.
label define ixedurcat 1 "<=3" 2 "4-10" 3 "11+"
label values ixedurcat ixedurcat
*
gen ixedurcat1=1 if ixedur==3
replace ixedurcat1=2 if ixedur>3 & ixedur<7
replace ixedurcat1=3 if ixedur>6 & ixedur<10
replace ixedurcat1=4 if ixedur>9 & ixedur<13
replace ixedurcat1=5 if ixedur>12 & ixedur<16
replace ixedurcat1=6 if ixedur>15 & ixedur<19
replace ixedurcat1=7 if ixedur>18 & ixedur!=.
label define ixedurcat1 1 "<=3" 2 "4-6" 3 "7-9" 4 "10-12" 5 "13-15" 6 "16-18" 7 "19+"
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


*********************************************************
*********************************************************
*PHIRST: RSV HCIR - Risk Factors - Analysis (SI <17 days)*
*********************************************************
*********************************************************

*Univariate analysis*
*
*All (any)*
*
tab rsv
ci proportion rsv
*
*All (included in the risk factor analysis - excludes HH with coprimary index cases)*
*
tab rsv if ixindid!=""
ci proportion rsv if ixindid!=""

*General/household caracteristics*
*
*Year*
tab year rsv, row chi
melogit rsv i.year || site: || hhid:, or  nolog
*
*Site*
tab site rsv, row chi
melogit rsv i.site || site: || hhid:, or  nolog
*
*Household size*
tab hmhh_size rsv, row chi
melogit rsv i.hmhh_size || site: || hhid:, or  nolog
*
*Number of sleeping rooms*
tab hmnumroomsleep rsv, row chi
melogit rsv i.hmnumroomsleep || site: || hhid:, or  nolog
*
*Crowding*
tab hmcrowding rsv, row chi
melogit rsv i.hmcrowding || site: || hhid:, or  nolog
*
*Household income*
tab hmhh_income rsv, row chi
melogit rsv i.hmhh_income || site: || hhid:, or  nolog

*Index case*
*
*Age*
tab ixagecat5 rsv, row chi
melogit rsv b3.ixagecat5 || site: || hhid:, or  nolog
melogit rsv b5.ixagecat5 || site: || hhid:, or  nolog
*
*Sex*
tab ixsex rsv, row chi
melogit rsv i.ixsex || site: || hhid:, or  nolog
*
*HIV*
tab ixhivfinal rsv, row chi
melogit rsv i.ixhivfinal || site: || hhid:, or  nolog
*
*UMC*
tab ixunderill rsv, row chi
melogit rsv i.ixunderill || site: || hhid:, or  nolog
*
*BMI*
tab ixbmicat rsv, row chi
melogit rsv i.ixbmicat || site: || hhid:, or  nolog
*
*Cotinine*
tab ixcotinine rsv, row chi
melogit rsv i.ixcotinine || site: || hhid:, or  nolog
*
*Smoking*
tab ixcigsmokenow rsv, row chi
melogit rsv i.ixcigsmokenow || site: || hhid:, or  nolog
*
*Alcohol*
tab ixalcohol rsv, row chi
melogit rsv i.ixalcohol || site: || hhid:, or  nolog
*
*Education*
tab ixeduclevel rsv, row chi
melogit rsv i.ixeduclevel || site: || hhid:, or  nolog
*
*Employment*
tab ixemployed rsv, row chi
melogit rsv i.ixemployed || site: || hhid:, or  nolog
*
*RSV types*
tab type rsv, row chi
melogit rsv i.type || site: || hhid:, or  nolog
*
*Symptoms*
*
tab ixsymany rsv, row chi
melogit rsv i.ixsymany || site: || hhid:, or  nolog
*
tab ixsymcat rsv, row chi
melogit rsv i.ixsymcat || site: || hhid:, or  nolog
*
tab ixsymili rsv, row chi
melogit rsv i.ixsymili || site: || hhid:, or  nolog
*
*Episode duration*
*
tab ixedurcat rsv, row chi
melogit rsv i.ixedurcat || site: || hhid:, or  nolog
*
tab ixedurcat1 rsv, row chi
melogit rsv i.ixedurcat1 || site: || hhid:, or  nolog
*
*Ct-Value*
*
tab ixctcat rsv, row chi
melogit rsv i.ixctcat || site: || hhid:, or  nolog

*Household members*
*
*Age*
tab hmagecat5 rsv, row chi
melogit rsv b3.hmagecat5 || site: || hhid:, or  nolog
melogit rsv b6.hmagecat5 || site: || hhid:, or  nolog
*
*Sex*
tab hmsex rsv, row chi
melogit rsv i.hmsex || site: || hhid:, or  nolog
*
*HIV*
tab hmhivfinal rsv, row chi
melogit rsv i.hmhivfinal || site: || hhid:, or  nolog
*
*UMC*
tab hmunderill rsv, row chi
melogit rsv i.hmunderill || site: || hhid:, or  nolog
*
*BMI*
tab hmbmicat rsv, row chi
melogit rsv i.hmbmicat || site: || hhid:, or  nolog
*
*Cotinine*
tab hmcotinine rsv, row chi
melogit rsv i.hmcotinine || site: || hhid:, or  nolog
*
*Smoking*
tab hmcigsmokenow rsv, row chi
melogit rsv i.hmcigsmokenow || site: || hhid:, or  nolog
*
*Alcohol*
tab hmalcohol rsv, row chi
melogit rsv i.hmalcohol || site: || hhid:, or  nolog
*
*Education*
tab hmeduclevel rsv, row chi
melogit rsv i.hmeduclevel || site: || hhid:, or  nolog
*
*Employment*
tab hmemployed rsv, row chi
melogit rsv i.hmemployed || site: || hhid:, or  nolog


*Multivariable analysis*
melogit rsv b5.ixagecat5 b6.hmagecat5  i.ixsymcat i.ixctcat i.ixedurcat|| site: || hhid:, or  nolog

melogit rsv  i.ixsymcat i.ixctcat i.ixedurcat|| site: || hhid:, or  nolog

melogit rsv b6.hmagecat5  i.ixedurcat|| site: || hhid:, or  nolog
melogit rsv b6.hmagecat5  i.ixsymcat  i.ixctcat i.ixedurcat|| site: || hhid:, or  nolog
melogit rsv b6.hmagecat5  i.ixsymcat  i.ixedurcat|| site: || hhid:, or  nolog

melogit rsv b3.ixagecat5 b6.hmagecat5  i.ixsymcat i.ixctcat i.ixedurcat|| site: || hhid:, or  nolog
melogit rsv b6.hmagecat5  i.ixsymili i.ixctcat i.ixedurcat|| site: || hhid:, or  nolog
melogit rsv b6.hmagecat5  i.ixsymcat i.ixedurcat|| site: || hhid:, or  nolog
**Different age categories
melogit rsv b5.ixagecat6 b5.hmagecat6  i.ixsymcat i.ixedurcat|| site: || hhid:, or  nolog
melogit rsv b5.ixagecat b5.hmagecat  i.ixsymcat i.ixedurcat|| site: || hhid:, or  nolog
**Final model

melogit rsv b5.ixagecat5 b6.hmagecat5  i.ixsymcat i.ixedurcat|| site: || hhid:, or  nolog

**Number of included clusters
collapse (max) rsv, by(hhid clus)
di _N
**Number of cluster
collapse (max) clus, by(hhid)
**number ohh included
di _N
**Average num clusters per hh with range
sum clus
tab clus

**Number of included hh
use "PHIRST - Data - Lab - 2017-2018 - RF - HCIR.dta", clear
merge 1:1  hmindid type clus hmepis  using "PHIRST - Data - Lab - 2017-2018 - HCIR-SI.dta"
drop _merge
keep if sus==1

collapse (max) rsv, by(hhid)
di _N
qui log close

view "PHIRST - Results - RSV - 2017-2018 - RF - HCIR - All SI.smcl"
