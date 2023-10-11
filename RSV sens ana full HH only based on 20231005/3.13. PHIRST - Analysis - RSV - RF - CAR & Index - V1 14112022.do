clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\"

*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - RF - CAR.dta", clear
svyset hhid, strata(siteid) vce(linearized) singleunit(missing)

capture log close
qui: log using "PHIRST - Results - RSV - 2017-2018 - RF - CAR & Index.smcl", replace


*************************************************************
*************************************************************
*PHIRST: RSV Community Attack Rate - Risk Factors - Analysis*
*************************************************************
*************************************************************

*Univariate analysis*
*
*Year*
tab year rsv, row chi
mepoisson rsv i.year || site: || hhid:, irr  nolog
*
*Site*
tab site rsv, row chi
mepoisson rsv i.site || site: || hhid:, irr  nolog
*
*Age*
tab agecat5 rsv, row chi
mepoisson rsv b4.agecat5 || site: || hhid:, irr  nolog
*
*Sex*
tab sex rsv, row chi
mepoisson rsv i.sex || site: || hhid:, irr  nolog
*
*HIV*
tab hivfinal rsv, row chi
mepoisson rsv i.hivfinal || site: || hhid:, irr  nolog
*
*UMC*
tab underill rsv, row chi
mepoisson rsv i.underill || site: || hhid:, irr  nolog
*
*BMI*
tab bmicat rsv, row chi
mepoisson rsv i.bmicat || site: || hhid:, irr  nolog
*
*Cotinine*
tab cotinine rsv, row chi
mepoisson rsv i.cotinine || site: || hhid:, irr  nolog
*
*Smoking*
tab cigsmokenow rsv, row chi
mepoisson rsv i.cigsmokenow || site: || hhid:, irr  nolog
*
*Alcohol*
tab alcohol rsv, row chi
mepoisson rsv i.alcohol || site: || hhid:, irr  nolog
*
*Education*
tab educlevel rsv, row chi
mepoisson rsv i.educlevel || site: || hhid:, irr  nolog
*
*Employment*
tab employed rsv, row chi
mepoisson rsv i.employed || site: || hhid:, irr  nolog
*
*Household size*
tab hh_size rsv, row chi
mepoisson rsv i.hh_size || site: || hhid:, irr  nolog
*
*Number of sleeping rooms*
tab numroomsleep rsv, row chi
mepoisson rsv i.numroomsleep || site: || hhid:, irr  nolog
*
*Crowding*
tab crowding rsv, row chi
mepoisson rsv i.crowding || site: || hhid:, irr  nolog
*
*Household income*
tab hh_income rsv, row chi
mepoisson rsv i.hh_income || site: || hhid:, irr  nolog

*Multivariable analysis*


*********************************************************
*********************************************************
*PHIRST: RSV Index vs Comunity - Risk Factors - Analysis*
*********************************************************
*********************************************************

*Univariate analysis*
*
*Year*
tab year ixall, row chi
melogit ixall i.year || site: || hhid:, or  nolog
*
*Site*
tab site ixall, row chi
melogit ixall i.site || site: || hhid:, or  nolog
*
*Age*
tab agecat5 ixall, row chi
melogit ixall b4.agecat5 || site: || hhid:, or  nolog
*
*Sex*
tab sex ixall, row chi
melogit ixall i.sex || site: || hhid:, or  nolog
*
*HIV*
tab hivfinal ixall, row chi
melogit ixall i.hivfinal || site: || hhid:, or  nolog
*
*UMC*
tab underill ixall, row chi
melogit ixall i.underill || site: || hhid:, or  nolog
*
*BMI*
tab bmicat ixall, row chi
melogit ixall i.bmicat || site: || hhid:, or  nolog
*
*Cotinine*
tab cotinine ixall, row chi
melogit ixall i.cotinine || site: || hhid:, or  nolog
*
*Smoking*
tab cigsmokenow ixall, row chi
melogit ixall i.cigsmokenow || site: || hhid:, or  nolog
*
*Alcohol*
tab alcohol ixall, row chi
*melogit ixall i.alcohol || site: || hhid:, or  nolog
svy linearized: logit rsv i.alcohol, or nolog
*
*Education*
tab educlevel ixall, row chi
melogit ixall i.educlevel || site: || hhid:, or  nolog
*
*Employment*
tab employed ixall, row chi
melogit ixall i.employed || site: || hhid:, or  nolog
*
*Household size*
tab hh_size ixall, row chi
melogit ixall i.hh_size || site: || hhid:, or  nolog
*
*Number of sleeping rooms*
tab numroomsleep ixall, row chi
melogit ixall i.numroomsleep || site: || hhid:, or  nolog
*
*Crowding*
tab crowding ixall, row chi
melogit ixall i.crowding || site: || hhid:, or  nolog
*
*Household income*
tab hh_income ixall, row chi
melogit ixall i.hh_income || site: || hhid:, or  nolog

*Multivariable analysis*


qui log off

use "PHIRST - Data - Lab - 2017-2018 - RF - Index.dta", clear

qui log on


***************************************************************************
***************************************************************************
*PHIRST: RSV Index vs Positive Household Members - Risk Factors - Analysis*
***************************************************************************
***************************************************************************

*Univariate analysis*
*
*Year*
tab year ixpos, row chi
melogit ixpos i.year || site: || hhid:, or  nolog
*
*Site*
tab site ixpos, row chi
melogit ixpos i.site || site: || hhid:, or  nolog
*
*Age*
tab agecat5 ixpos, row chi
melogit ixpos b4.agecat5 || site: || hhid:, or  nolog
*
*Sex*
tab sex ixpos, row chi
melogit ixpos i.sex || site: || hhid:, or  nolog
*
*HIV*
tab hivfinal ixpos, row chi
melogit ixpos i.hivfinal || site: || hhid:, or  nolog
*
*UMC*
tab underill ixpos, row chi
melogit ixpos i.underill || site: || hhid:, or  nolog
*
*BMI*
tab bmicat ixpos, row chi
melogit ixpos i.bmicat || site: || hhid:, or  nolog
*
*Cotinine*
tab cotinine ixpos, row chi
melogit ixpos i.cotinine || site: || hhid:, or  nolog
*
*Smoking*
tab cigsmokenow ixpos, row chi
melogit ixpos i.cigsmokenow || site: || hhid:, or  nolog
*
*Alcohol*
tab alcohol ixpos, row chi
melogit ixpos i.alcohol || site: || hhid:, or  nolog
*
*Education*
tab educlevel ixpos, row chi
melogit ixpos i.educlevel || site: || hhid:, or  nolog
*
*Employment*
tab employed ixpos, row chi
melogit ixpos i.employed || site: || hhid:, or  nolog
*
*Household size*
tab hh_size ixpos, row chi
melogit ixpos i.hh_size || site: || hhid:, or  nolog
*
*Number of sleeping rooms*
tab numroomsleep ixpos, row chi
melogit ixpos i.numroomsleep || site: || hhid:, or  nolog
*
*Crowding*
tab crowding ixpos, row chi
melogit ixpos i.crowding || site: || hhid:, or  nolog
*
*Household income*
tab hh_income ixpos, row chi
melogit ixpos i.hh_income || site: || hhid:, or  nolog

*Multivariable analysis*


qui log close

view "PHIRST - Results - RSV - 2017-2018 - RF - CAR & Index.smcl"
