clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\"
*cd "C:\Users\cherylc\Documents\PHIRST 2019_2020\RSV analysis"
*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - RF - Symptoms - Double Count Coinfections - No.dta", clear

capture log close
qui: log using "PHIRST - Results - RSV - 2017-2018 - RF - Symptoms.smcl", replace


***********************************************************************************
***********************************************************************************
*PHIRST: RSV Symptoms - Risk Factors - Analysis (Not Double Counting Coinfections)*
***********************************************************************************
***********************************************************************************

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
*Episode duration*
*
gen edurcat=0 if edur!=.
replace edurcat=1 if edur>3 & edur<11
replace edurcat=2 if edur>10 & edur!=.
label define edurcat 0 "<=3" 1 "4-10" 2 ">10"
label values edurcat edurcat
*
gen edurcat1=0 if edur!=.
replace edurcat1=1 if edur>3 & edur<=7
replace edurcat1=2 if edur>7 & edur<=14
replace edurcat1=3 if edur>14 & edur!=.
label define edurcat1 0 "<=3" 1 "4-7" 2 "8-14" 3 ">14"
label values edurcat1 edurcat1
*
gen edurcat2=0 if edur!=.
replace edurcat2=1 if edur>3 & edur<=7
replace edurcat2=2 if edur>7 & edur<=12
replace edurcat2=3 if edur>12 & edur!=.
label define edurcat2 0 "<=3" 1 "4-7" 2 "8-12" 3 ">12"
label values edurcat2 edurcat2
*
*Ct value
*
gen ctcat=1 if minct<30
replace ctcat=0 if minct>=30 & minct!=.
label define ctcat 0 ">=30" 1 "<30"
label values ctcat ctcat
tab ctcat
*
gen ctcat1=1 if minct<35
replace ctcat1=0 if minct>=35 & minct!=.
label define ctcat1 0 ">=35" 1 "<35"
label values ctcat1 ctcat1
tab ctcat1

qui log on

*Symptom description*
*
tab fever if symany==1
tab cough if symany==1
tab runnynose if symany==1
tab chestpain if symany==1
tab muscleache if symany==1
tab headache if symany==1
tab vomiting if symany==1
tab diarrhoea if symany==1
tab diffbreath if symany==1
tab sorethroat if symany==1

*symptoms associated with absenteeism*
*
tab  fever missed if symany==1, row chi
tab  cough missed if symany==1, row chi
tab  runnynose missed if symany==1, row chi
tab  chestpain missed if symany==1, row chi
tab  muscleache missed if symany==1, row chi
tab  headache missed if symany==1, row chi
tab  vomiting missed if symany==1, row chi
tab  diarrhoea missed if symany==1, row chi
tab  diffbreath missed if symany==1, row chi
tab  sorethroat missed if symany==1, row chi
tab  symany missed if symany==1, row chi
tab  symcat missed if symany==1, row chi
tab  symnum missed if symany==1, row chi

*Univariate analysis*
*
*Year*
tab year symany, row chi
melogit symany i.year || site: || hhid:, or  nolog
*
*Site*
tab site symany, row chi
melogit symany i.site || site: || hhid:, or  nolog
*
*Age*
tab agecat5 symany, row chi
melogit symany b3.agecat5 || site: || hhid:, or  nolog
*
*Sex*
tab sex symany, row chi
melogit symany i.sex || site: || hhid:, or  nolog
*
*HIV*
tab hivfinal symany, row chi
melogit symany i.hivfinal || site: || hhid:, or  nolog
*
*UMC*
tab underill symany, row chi
melogit symany i.underill || site: || hhid:, or  nolog
*
*BMI*
tab bmicat symany, row chi
melogit symany i.bmicat || site: || hhid:, or  nolog
*
*Cotinine*
tab cotinine symany, row chi
melogit symany i.cotinine || site: || hhid:, or  nolog
*
*Smoking*
tab cigsmokenow symany, row chi
melogit symany i.cigsmokenow || site: || hhid:, or  nolog
*
*Alcohol*
tab alcohol symany, row chi
melogit symany i.alcohol || site: || hhid:, or  nolog
*
*Education*
tab educlevel symany, row chi
melogit symany i.educlevel || site: || hhid:, or  nolog
*
*Employment*
tab employed symany, row chi
melogit symany i.employed || site: || hhid:, or  nolog
*
*Household size*
tab hh_size symany, row chi
melogit symany i.hh_size || site: || hhid:, or  nolog
*
*Number of sleeping rooms*
tab numroomsleep symany, row chi
melogit symany i.numroomsleep || site: || hhid:, or  nolog
*
*Crowding*
tab crowding symany, row chi
melogit symany i.crowding || site: || hhid:, or  nolog
*
*Household income*
tab hh_income symany, row chi
melogit symany i.hh_income || site: || hhid:, or  nolog
*
*RSV types*
tab type symany, row chi
melogit symany i.type || site: || hhid:, or  nolog
*
*Episode duration*
*
tab edurcat symany, row chi
melogit symany i.edurcat || site: || hhid:, or  nolog
*
tab edurcat1 symany, row chi
melogit symany i.edurcat1 || site: || hhid:, or  nolog
*
tab edurcat2 symany, row chi
melogit symany i.edurcat2 || site: || hhid:, or  nolog
*
*Ct-Value*
*
tab ctcat symany, row chi
melogit symany i.ctcat || site: || hhid:, or  nolog
*
tab ctcat1 symany, row chi
melogit symany i.ctcat1 || site: || hhid:, or  nolog

**Environmental
tab spm4 symany, row chi
melogit symany i.spm4 || site: || hhid:, or  nolog

tab wpm4 symany, row chi
melogit symany i.wpm4 || site: || hhid:, or  nolog


*Multivariable analysis*

melogit symany b3.agecat5 i.ctcat i.edurcat i.hh_income  i.crowding i.cigsmokenow i.hiv i.underill || site: || hhid:, or  nolog 

melogit symany b3.agecat5 i.ctcat i.edurcat i.cigsmokenow i.hiv i.underill || site: || hhid:, or  nolog 

melogit symany b3.agecat5 i.ctcat i.edurcat b1.cigsmokenow || site: || hhid:, or  nolog 
melogit symany b3.agecat5 i.ctcat i.edurcat || site: || hhid:, or  nolog 
qui log off

use "PHIRST - Data - Lab - 2017-2018 - RF - Symptoms - Double Count Coinfections - Yes.dta", clear

qui log on

*******************************************************************************
*******************************************************************************
*PHIRST: RSV Symptoms - Risk Factors - Analysis (Double Counting Coinfections)*
*******************************************************************************
*******************************************************************************

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
*Episode duration*
*
gen edurcat=0 if edur!=.
replace edurcat=1 if edur>3 & edur<=12
replace edurcat=2 if edur>12 & edur!=.
label define edurcat 0 "<=3" 1 "4-12" 2 ">12"
label values edurcat edurcat
*
gen edurcat1=0 if edur!=.
replace edurcat1=1 if edur>3 & edur<=7
replace edurcat1=2 if edur>7 & edur<=14
replace edurcat1=3 if edur>14 & edur!=.
label define edurcat1 0 "<=3" 1 "4-7" 2 "8-14" 3 ">14"
label values edurcat1 edurcat1
*
gen edurcat2=0 if edur!=.
replace edurcat2=1 if edur>3 & edur<=7
replace edurcat2=2 if edur>7 & edur<=12
replace edurcat2=3 if edur>12 & edur!=.
label define edurcat2 0 "<=3" 1 "4-7" 2 "8-12" 3 ">12"
label values edurcat2 edurcat2
*
*Ct value
*
gen ctcat=1 if minct<30
replace ctcat=0 if minct>=30 & minct!=.
label define ctcat 0 ">=30" 1 "<30"
label values ctcat ctcat
tab ctcat
*
gen ctcat1=1 if minct<35
replace ctcat1=0 if minct>=35 & minct!=.
label define ctcat1 0 ">=35" 1 "<35"
label values ctcat1 ctcat1
tab ctcat1

qui log on

*Symptom description*
*
tab fever if symany==1
tab cough if symany==1
tab runnynose if symany==1
tab chestpain if symany==1
tab muscleache if symany==1
tab headache if symany==1
tab vomiting if symany==1
tab diarrhoea if symany==1
tab diffbreath if symany==1
tab sorethroat if symany==1

*symptoms associated with absenteeism*
*
tab  fever missed if symany==1, row chi
tab  cough missed if symany==1, row chi
tab  runnynose missed if symany==1, row chi
tab  chestpain missed if symany==1, row chi
tab  muscleache missed if symany==1, row chi
tab  headache missed if symany==1, row chi
tab  vomiting missed if symany==1, row chi
tab  diarrhoea missed if symany==1, row chi
tab  diffbreath missed if symany==1, row chi
tab  sorethroat missed if symany==1, row chi
tab  symany missed if symany==1, row chi
tab  symcat missed if symany==1, row chi
tab  symnum missed if symany==1, row chi

*Univariate analysis*
*
*Year*
tab year symany, row chi
melogit symany i.year || site: || hhid:, or  nolog
*
*Site*
tab site symany, row chi
melogit symany i.site || site: || hhid:, or  nolog
*
*Age*
tab agecat5 symany, row chi
melogit symany b4.agecat5 || site: || hhid:, or  nolog
*
*Sex*
tab sex symany, row chi
melogit symany i.sex || site: || hhid:, or  nolog
*
*HIV*
tab hivfinal symany, row chi
melogit symany i.hivfinal || site: || hhid:, or  nolog
*
*UMC*
tab underill symany, row chi
melogit symany i.underill || site: || hhid:, or  nolog
*
*BMI*
tab bmicat symany, row chi
melogit symany i.bmicat || site: || hhid:, or  nolog
*
*Cotinine*
tab cotinine symany, row chi
melogit symany i.cotinine || site: || hhid:, or  nolog
*
*Smoking*
tab cigsmokenow symany, row chi
melogit symany i.cigsmokenow || site: || hhid:, or  nolog
*
*Alcohol*
tab alcohol symany, row chi
melogit symany i.alcohol || site: || hhid:, or  nolog
*
*Education*
tab educlevel symany, row chi
melogit symany i.educlevel || site: || hhid:, or  nolog
*
*Employment*
tab employed symany, row chi
melogit symany i.employed || site: || hhid:, or  nolog
*
*Household size*
tab hh_size symany, row chi
melogit symany i.hh_size || site: || hhid:, or  nolog
*
*Number of sleeping rooms*
tab numroomsleep symany, row chi
melogit symany i.numroomsleep || site: || hhid:, or  nolog
*
*Crowding*
tab crowding symany, row chi
melogit symany i.crowding || site: || hhid:, or  nolog
*
*Household income*
tab hh_income symany, row chi
melogit symany i.hh_income || site: || hhid:, or  nolog
*
*RSV types*
tab type symany, row chi
melogit symany i.type || site: || hhid:, or  nolog
*
*Episode duration*
*
tab edurcat symany, row chi
melogit symany i.edurcat || site: || hhid:, or  nolog
*
tab edurcat1 symany, row chi
melogit symany i.edurcat1 || site: || hhid:, or  nolog
*
tab edurcat2 symany, row chi
melogit symany i.edurcat2 || site: || hhid:, or  nolog
*
*Ct-Value*
*
tab ctcat symany, row chi
melogit symany i.ctcat || site: || hhid:, or  nolog
*
tab ctcat1 symany, row chi
melogit symany i.ctcat1 || site: || hhid:, or  nolog


*Multivariable analysis*


qui log close

view "PHIRST - Results - RSV - 2017-2018 - RF - Symptoms.smcl"
