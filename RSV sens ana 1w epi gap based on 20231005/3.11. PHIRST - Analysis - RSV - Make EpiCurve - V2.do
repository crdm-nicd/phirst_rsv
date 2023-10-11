**********************************
**********************************
*PHIRST: RSV Epi Curve - Analysis*
**********************************
**********************************

clear
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 

*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear 

*Obtain Epi Curve*
*
gen totsampl=1 if rsv<90
format %td npsdatecol
epiweek npsdatecol, epiw(week) epiy(year1)
drop year1
*
collapse (sum) frsvafn frsvbfn frsvutpfn totsampl if week!=., by(siteid year week)
rename frsvafn rsva
rename frsvbfn rsvb
rename frsvutpfn rsvutp
gen rsv=rsva+rsvb+rsvutp
gen rsvp=rsv/totsampl*100
gen rsvap=rsva/totsampl*100
gen rsvbp=rsvb/totsampl*100
gen rsvutpp=rsvutp/totsampl*100
order siteid year week rsva rsvb rsvutp rsv rsvap rsvbp rsvutpp rsvp totsampl
*
save "PHIRST - Data - Lab - 2017-2018 - EpiCurve.dta", replace

clear all 

*EpiCurve with denominator as total number of individuals per week to calculate attack rate
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear 

*Obtain Epi Curve*
*
gen totind=1 if rsv<90
format %td npsdatecol
epiweek npsdatecol, epiw(week) epiy(year1)
drop year1
*
collapse (max) frsvafn frsvbfn frsvutpfn totind if week!=., by(indid siteid year week)
collapse (sum) frsvafn frsvbfn frsvutpfn totind if week!=., by(siteid year week)
rename frsvafn rsva
rename frsvbfn rsvb
rename frsvutpfn rsvutp
gen rsv=rsva+rsvb+rsvutp
gen rsvp=rsv/totind*100
gen rsvap=rsva/totind*100
gen rsvbp=rsvb/totind*100
gen rsvutpp=rsvutp/totind*100

bysort siteid year (week) : gen rsvp_cum = sum(rsvp)
bysort siteid year (week) : gen rsvap_cum = sum(rsvap)
bysort siteid year (week) : gen rsvbp_cum = sum(rsvbp)
bysort siteid year (week) : gen rsvutpp_cum = sum(rsvutpp)

order siteid year week rsva rsvb rsvutp rsv rsvap rsvbp rsvutpp rsvp rsvp_cum rsvap_cum rsvbp_cum rsvutpp_cum totind
keep siteid year week rsva rsvb rsvutp rsvp_cum totind
save "PHIRST - Data - Lab - 2017-2018 - EpiCurve for Fig 1.dta", replace

**************************************************
*Make mosaics of episodes using the final dataset*
**************************************************

use "ClusMaster2Long.dta", clear
*
keep year siteid hhid indid rsvtpep2 funum
reshape wide rsvtpep2, i(year siteid hhid indid) j(funum)
*
forval i=1/83 {
qui gen v`i'=.
}
capture forval i=1/83 {
qui replace v`i'=rsvtpep2`i'
}
foreach var of varlist v* {
qui replace `var'=6 if `var'==4
qui replace `var'=5 if `var'==3
qui replace `var'=4 if `var'==2
qui replace `var'=3 if `var'==1
qui replace `var'=2 if `var'==90
qui replace `var'=1 if `var'==80
}
*
mkmat v* if year==2017 & site=="A", matrix(A17epf)
mkmat v* if year==2018 & site=="A", matrix(A18epf)
mkmat v* if year==2017 & site=="K", matrix(K17epf)
mkmat v* if year==2018 & site=="K", matrix(K18epf)
*
*Agincourt - 2017
capture plotmatrix, m(A17epf) split(1 2 3 4 5) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2017 - Episode Final.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2017 - Episode Final.pdf", as(pdf) replace  
*
*Klerksdorp - 2017
capture plotmatrix, m(K17epf) split(1 2 3 4 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Episode Final.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Episode Final.pdf", as(pdf) replace  
*
*Agincourt - 2018
capture plotmatrix, m(A18epf) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2018 - Episode Final.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2018 - Episode Final.pdf", as(pdf) replace 
*
*Klerksdorp - 2018
capture plotmatrix, m(K18epf) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Episode Final.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Episode Final.pdf", as(pdf) replace 

*Export raw data for figure
keep year siteid v*
save "PHIRST - Data - Lab - 2017-2018 - Mosaic for Fig 1.dta", replace


*****************************
*Make mosaic of reinfections*
*****************************
*
use "ClusMaster2Long.dta", clear
*
keep year siteid hhid indid rsvtpep2 funum
reshape wide rsvtpep2, i(year siteid hhid indid) j(funum)
*
forval i=1/83 {
qui gen v`i'=.
}
capture forval i=1/83 {
qui replace v`i'=rsvtpep2`i'
}
foreach var of varlist v* {
qui replace `var'=6 if `var'==4
qui replace `var'=5 if `var'==3
qui replace `var'=4 if `var'==2
qui replace `var'=3 if `var'==1
qui replace `var'=2 if `var'==90
qui replace `var'=1 if `var'==80
}
*
mkmat v* if year==2017 & site=="A", matrix(A17epf)
mkmat v* if year==2018 & site=="A", matrix(A18epf)
mkmat v* if year==2017 & site=="K", matrix(K17epf)
mkmat v* if year==2018 & site=="K", matrix(K18epf)

merge 1:1 indid using "PHIRST - Data - Lab - 2017-2018 - Individuals.dta"
drop vllog vlcop vlcop_n vlcat
*
mkmat v* if etotmix>1, matrix(Reinfec)
*
*Reinfections*
capture plotmatrix, m(Reinfec) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "7.PHIRST - Mosaic - RSV - 2017-2018 - Reinfections.tif", as(tif) width(1600) height(1200) replace
graph export "7.PHIRST - Mosaic - RSV - 2017-2018 - Reinfections.pdf", as(pdf) replace 

clear
