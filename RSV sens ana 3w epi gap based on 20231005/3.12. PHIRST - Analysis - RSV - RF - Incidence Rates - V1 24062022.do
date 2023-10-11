clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 
*cd "C:\Users\cherylc\Documents\PHIRST 2019_2020\RSV analysis"
capture log close
qui: log using "PHIRST - Results - RSV - 2017-2018 - RF - Incidence.smcl", replace

*************************************************
*************************************************
*PHIRST: RSV Incidence - Risk Factors - Analysis*
*************************************************
*************************************************

qui log off

use "PHIRST - Data - Lab - 2017-2018 - Incidence - Variables.dta", clear

stset ptimevis, id(indid) failure(rsvepis=1) scale(7) exit(time .)

qui log on

******************************************************
*Factors associated with RSV incidence (all episodes)*
******************************************************

*Rates by exposure (per 100 person week)*
*
*Year*
stptime, per(100) by(year) dd(2)
*
*Site*
stptime, per(100) by(siteid) dd(2)
*
*Age*
stptime, per(100) by(agecat5) dd(2)
*
*Sex*
stptime, per(100) by(sex) dd(2)
*
*HIV*
stptime, per(100) by(hivfinal) dd(2)
*
*UMC*
stptime, per(100) by(underill) dd(2)
*
*BMI*
stptime, per(100) by(bmicat) dd(2)
*
*Cotinine*
stptime, per(100) by(cotinine) dd(2)
*
*Smoking*
stptime, per(100) by(cigsmokenow) dd(2)
*
*Alcohol*
stptime, per(100) by(alcohol) dd(2)
*
*Education*
stptime, per(100) by(educlevel) dd(2)
*
*Employment*
stptime, per(100) by(employed) dd(2)
*
*Household size*
stptime, per(100) by(hh_size) dd(2)
*
*Number of sleeping rooms*
stptime, per(100) by(numroomsleep) dd(2)
*
*Crowding*
stptime, per(100) by(crowding) dd(2)

qui log off

stset ptimevis, id(indid) failure(rsvepis=1) scale(365) exit(time .)

qui log on


*Rates by exposure (per 100 person year)*
*
*Year*
stptime, per(100) by(year) dd(2)
*
*Site*
stptime, per(100) by(siteid) dd(2)
*
*Age*
stptime, per(100) by(agecat5) dd(2)
stptime, per(100) by(agecat3) dd(2)
*
*Sex*
stptime, per(100) by(sex) dd(2)
*
*HIV*
stptime, per(100) by(hivfinal) dd(2)
*
*UMC*
stptime, per(100) by(underill) dd(2)
*
*BMI*
stptime, per(100) by(bmicat) dd(2)
*
*Cotinine*
stptime, per(100) by(cotinine) dd(2)
*
*Smoking*
stptime, per(100) by(cigsmokenow) dd(2)
*
*Alcohol*
stptime, per(100) by(alcohol) dd(2)
*
*Education*
stptime, per(100) by(educlevel) dd(2)
*
*Employment*
stptime, per(100) by(employed) dd(2)
*
*Household size*
stptime, per(100) by(hh_size) dd(2)
*
*Number of sleeping rooms*
stptime, per(100) by(numroomsleep) dd(2)
*
*Crowding*
stptime, per(100) by(crowding) dd(2)
*
*Household income*
stptime, per(100) by(hh_income) dd(2)

qui log off

use "PHIRST - Data - Lab - 2017-2018 - RF - Incidence.dta", clear
svyset hhid, strata(siteid) vce(linearized) singleunit(missing)

qui log on

*Univariate analysis*
*
*Year*
svy linearized: poisson rsvepis i.year, irr nolog exposure(ptimeall)
*
*Site*
svy linearized: poisson rsvepis i.site, irr nolog exposure(ptimeall)
*
*Age*
svy linearized: poisson rsvepis b4.agecat5, irr nolog exposure(ptimeall)
*
*Sex*
svy linearized: poisson rsvepis i.sex, irr nolog exposure(ptimeall)
*
*HIV*
svy linearized: poisson rsvepis i.hivfinal, irr nolog exposure(ptimeall)
*
*UMC*
svy linearized: poisson rsvepis i.underill, irr nolog exposure(ptimeall)
*
*BMI*
svy linearized: poisson rsvepis i.bmicat, irr nolog exposure(ptimeall)
*
*Cotinine*
svy linearized: poisson rsvepis i.cotinine, irr nolog exposure(ptimeall)
*
*Smoking*
svy linearized: poisson rsvepis i.cigsmokenow, irr nolog exposure(ptimeall)
*
*Alcohol*
svy linearized: poisson rsvepis i.alcohol, irr nolog exposure(ptimeall)
*
*Education*
svy linearized: poisson rsvepis i.educlevel, irr nolog exposure(ptimeall)
*
*Employment*
svy linearized: poisson rsvepis i.employed, irr nolog exposure(ptimeall)
*
*Household size*
svy linearized: poisson rsvepis i.hh_size, irr nolog exposure(ptimeall)
*
*Number of sleeping rooms*
svy linearized: poisson rsvepis i.numroomsleep, irr nolog exposure(ptimeall)
*
*Crowding*
svy linearized: poisson rsvepis i.crowding, irr nolog exposure(ptimeall)
*
*Household income*
svy linearized: poisson rsvepis i.hh_income, irr nolog exposure(ptimeall)

svy linearized: poisson rsvepis i.wpm4, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis i.spm4, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis i.windoortemp, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis i.sindoortemp, irr nolog exposure(ptimeall)


*Multivariable analysis*
svy linearized: poisson rsvepis b4.agecat5 i.crowding i.wpm4 i.windoortemp i.year, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis b4.agecat5 i.crowding i.wpm4 i.windoortemp i.underill i.hivfinal, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis b4.agecat5 i.crowding i.wpm4 i.windoortemp i.site , irr nolog exposure(ptimeall)

svy linearized: poisson rsvepis b4.agecat5 i.crowding i.site i.year, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis b4.agecat5 i.crowding i.year, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis b4.agecat5 i.year, irr nolog exposure(ptimeall)
qui log off

stset ptimeall, id(indid) failure(rsvany=1) scale(7) exit(time .)

qui log on

**************************************************************
*Factors associated with RSV incidence (at least one episode)*
**************************************************************

*Rates by exposure (per 100 person week)*
*
*Year*
stptime, per(100) by(year) dd(2)
*
*Site*
stptime, per(100) by(siteid) dd(2)
*
*Year & Site*
bysort year: stptime, per(100) by(siteid) dd(2)
*
*Age*
stptime, per(100) by(agecat5) dd(2)
*
*Sex*
stptime, per(100) by(sex) dd(2)
*
*HIV*
stptime, per(100) by(hivfinal) dd(2)
*
*UMC*
stptime, per(100) by(underill) dd(2)
*
*BMI*
stptime, per(100) by(bmicat) dd(2)
*
*Cotinine*
stptime, per(100) by(cotinine) dd(2)
*
*Smoking*
stptime, per(100) by(cigsmokenow) dd(2)
*
*Alcohol*
stptime, per(100) by(alcohol) dd(2)
*
*Education*
stptime, per(100) by(educlevel) dd(2)
*
*Employment*
stptime, per(100) by(employed) dd(2)
*
*Household size*
stptime, per(100) by(hh_size) dd(2)
*
*Number of sleeping rooms*
stptime, per(100) by(numroomsleep) dd(2)
*
*Crowding*
stptime, per(100) by(crowding) dd(2)

qui log off

stset ptimeall, id(indid) failure(rsvany=1) scale(365) exit(time .)

qui log on


*Rates by exposure (per 100 person year)*
*
*Year*
stptime, per(100) by(year) dd(2)
*
*Site*
stptime, per(100) by(siteid) dd(2)
*
*Year & Site*
bysort year: stptime, per(100) by(siteid) dd(2)
*
*Age*
stptime, per(100) by(agecat5) dd(2)
*
*Sex*
stptime, per(100) by(sex) dd(2)
*
*HIV*
stptime, per(100) by(hivfinal) dd(2)
*
*UMC*
stptime, per(100) by(underill) dd(2)
*
*BMI*
stptime, per(100) by(bmicat) dd(2)
*
*Cotinine*
stptime, per(100) by(cotinine) dd(2)
*
*Smoking*
stptime, per(100) by(cigsmokenow) dd(2)
*
*Alcohol*
stptime, per(100) by(alcohol) dd(2)
*
*Education*
stptime, per(100) by(educlevel) dd(2)
*
*Employment*
stptime, per(100) by(employed) dd(2)
*
*Household size*
stptime, per(100) by(hh_size) dd(2)
*
*Number of sleeping rooms*
stptime, per(100) by(numroomsleep) dd(2)
*
*Crowding*
stptime, per(100) by(crowding) dd(2)
*
*Household income*
stptime, per(100) by(hh_income) dd(2)


*Univariate analysis*
*
*Year*
svy linearized: poisson rsvany i.year, irr nolog exposure(ptimeall)
*
*Site*
svy linearized: poisson rsvany i.site, irr nolog exposure(ptimeall)
*
*Age*
svy linearized: poisson rsvany b4.agecat5, irr nolog exposure(ptimeall)
*
*Sex*
svy linearized: poisson rsvany i.sex, irr nolog exposure(ptimeall)
*
*HIV*
svy linearized: poisson rsvany i.hivfinal, irr nolog exposure(ptimeall)
*
*UMC*
svy linearized: poisson rsvany i.underill, irr nolog exposure(ptimeall)
*
*BMI*
svy linearized: poisson rsvany i.bmicat, irr nolog exposure(ptimeall)
*
*Cotinine*
svy linearized: poisson rsvany i.cotinine, irr nolog exposure(ptimeall)
*
*Smoking*
svy linearized: poisson rsvany i.cigsmokenow, irr nolog exposure(ptimeall)
*
*Alcohol*
svy linearized: poisson rsvany i.alcohol, irr nolog exposure(ptimeall)
*
*Education*
svy linearized: poisson rsvany i.educlevel, irr nolog exposure(ptimeall)
*
*Employment*
svy linearized: poisson rsvany i.employed, irr nolog exposure(ptimeall)
*
*Household size*
svy linearized: poisson rsvany i.hh_size, irr nolog exposure(ptimeall)
*
*Number of sleeping rooms*
svy linearized: poisson rsvany i.numroomsleep, irr nolog exposure(ptimeall)
*
*Crowding*
svy linearized: poisson rsvany i.crowding, irr nolog exposure(ptimeall)
*
*Household income*
svy linearized: poisson rsvany i.hh_income, irr nolog exposure(ptimeall)

*Multivariable analysis*
*Multivariable analysis*
svy linearized: poisson rsvepis b4.agecat5 i.crowding i.wpm4 i.windoortemp i.year, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis b4.agecat5 i.crowding i.wpm4 i.windoortemp i.underill i.hivfinal, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis b4.agecat5 i.crowding i.wpm4 i.windoortemp i.site , irr nolog exposure(ptimeall)

svy linearized: poisson rsvepis b4.agecat5 i.crowding i.site i.year, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis b4.agecat5 i.crowding i.year, irr nolog exposure(ptimeall)
svy linearized: poisson rsvepis b4.agecat5 i.year, irr nolog exposure(ptimeall)

qui log close

view "PHIRST - Results - RSV - 2017-2018 - RF - Incidence.smcl"
