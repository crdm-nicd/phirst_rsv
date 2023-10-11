*********************************
*********************************
*PHIRST: RSV Episodes - Analysis*
*********************************
*********************************

clear
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 

*Import dataset*
use "PHIRST - Data - Lab - RSV - 2017-2018.dta", clear


******************************************
*Attribute RSV types and generate mosaics*
******************************************

*Obtain missing visits*
drop if rsv==.
*
reshape wide rsv rsvtp rsvautp rsvbutp npsdatecol, i(year siteid hhid indid) j(funum)
reshape long
*
foreach var of varlist rsv-rsvbutp {
quietly replace `var'=90 if `var'==.
quietly replace `var'=80 if `var'==0
}
*
reshape wide
*
forval i=1/83 {
qui gen v`i'=.
}
capture forval i=1/83 {
qui replace v`i'=rsvtp`i'
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
set matsize 1000
mkmat v* if year==2017 & siteid=="A", matrix(A17)
mkmat v* if year==2018 & siteid=="A", matrix(A18)
mkmat v* if year==2017 & siteid=="K", matrix(K17)
mkmat v* if year==2018 & siteid=="K", matrix(K18)
reshape long
drop v*
*
drop if funum>82 & year==2017
tab year, m
*
label define rsv1 80 "Neg" 90 "Missing" 1 "Pos"
label values rsv rsv1
*
label define rsvtp1 80 "Neg" 90 "Missing" 1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values rsvtp rsvtp1
*
label define rsvautp1 80 "Neg" 90 "Missing" 1 "A" 2 "Untyped"
label values rsvautp rsvautp1
*
label define rsvbutp1 80 "Neg" 90 "Missing" 1 "B" 2 "Untyped"
label values rsvbutp rsvbutp1

*Generate individual ID with numeric code*
encode indid, gen(indid1)

*Generate mosaics*
*
*Agincourt - 2017
tab rsvtp if year==2017 & site=="A"
capture plotmatrix, m(A17) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "1.PHIRST - Mosaic - RSV - Agincourt 2017 - No Allocation.tif", as(tif) width(1600) height(1200) replace
graph export "1.PHIRST - Mosaic - RSV - Agincourt 2017 - No Allocation.pdf", as(pdf) replace  
*
*Klerksdorp - 2017
tab rsvtp if year==2017 & site=="K"
capture plotmatrix, m(K17) split(1 2 3 4 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "1.PHIRST - Mosaic - RSV - Klerksdorp 2017 - No Allocation.tif", as(tif) width(1600) height(1200) replace
graph export "1.PHIRST - Mosaic - RSV - Klerksdorp 2017 - No Allocation.pdf", as(pdf) replace  
*
*Agincourt - 2018
tab rsvtp if year==2018 & site=="A"
capture plotmatrix, m(A18) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "1.PHIRST - Mosaic - RSV - Agincourt 2018 - No Allocation.tif", as(tif) width(1600) height(1200) replace
graph export "1.PHIRST - Mosaic - RSV - Agincourt 2018 - No Allocation.pdf", as(pdf) replace 
*
*Klerksdorp - 2018
tab rsvtp if year==2018 & site=="K"
capture plotmatrix, m(K18) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "1.PHIRST - Mosaic - RSV - Klerksdorp 2018 - No Allocation.tif", as(tif) width(1600) height(1200) replace
graph export "1.PHIRST - Mosaic - RSV - Klerksdorp 2018 - No Allocation.pdf", as(pdf) replace  
*
tab rsvtp year
tab siteid year
*
sort year siteid indid funum, stable
gen funum1=funum
tostring funum1, replace
gen funuml=length(funum1)
gen fuid=indid+"-00"+funum1 if funuml==1
replace fuid=indid+"-0"+funum1 if funuml==2
drop funuml funum1
duplicates list fuid
*
gen long obs=_n
encode indid, gen(group)
sort year siteid indid funum, stable
*
gen total=1 if rsv<90
bysort indid: egen totfu=total(total)
bysort indid: egen totvis=total(1)
gen percfu=totfu/totvis*100
drop if totfu<11
*
save "PHIRST - Data - Lab - 2017-2018 - No Allocation.dta", replace
tab year site


********************
*Allocate RSV types*
********************

clear all

*Generate master dataset*
postfile mysim year using AllocEpis, replace
postclose mysim
clear

*Allocate RSV types*
forval i = 1/1300 {

quietly use "PHIRST - Data - Lab - 2017-2018 - No Allocation.dta", clear
quietly keep if group==`i'
sort funum, stable
*display "Master Run: " `i'

forval j = 1/`=_N' {
quietly replace rsvautp=1 if rsvautp==2 & (rsvautp[_n-1]==1 | rsvautp[_n-2]==1 | rsvautp[_n-3]==1 | rsvautp[_n+1]==1 | rsvautp[_n+2]==1 | rsvautp[_n+3]==1)
quietly replace rsvbutp=1 if rsvbutp==2 & (rsvbutp[_n-1]==1 | rsvbutp[_n-2]==1 | rsvbutp[_n-3]==1 | rsvbutp[_n+1]==1 | rsvbutp[_n+2]==1 | rsvbutp[_n+3]==1)
*display "Run: " `j'
}

quietly save "AllocSimEpis.dta", replace
quietly clear
quietly use "AllocEpis.dta"
quietly append using "AllocSimEpis.dta"
quietly save "AllocEpis.dta", replace
quietly clear

}
*
use "AllocEpis.dta", clear

*Generate mosaics*
*
gen rsvtpal=1 if rsvautp==1
replace rsvtpal=2 if rsvbutp==1
replace rsvtpal=3 if rsvautp==1 & rsvbutp==1
replace rsvtpal=4 if rsvautp==2 & rsvbutp==2
replace rsvtpal=rsvautp if rsvtpal==.
label define rsvtpal 80 "Neg" 90 "Missing" 1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values rsvtpal rsvtpal
*
tab rsvtpal
tab rsvtp rsvtpal
*
keep year siteid hhid indid funum rsv rsvtp rsvautp rsvbutp rsvtpal npsdatecol
reshape wide rsv rsvtp rsvautp rsvbutp rsvtpal npsdatecol, i(year siteid hhid indid) j(funum)
*
forval i=1/83 {
qui gen v`i'=.
}
capture forval i=1/83 {
qui replace v`i'=rsvtpal`i'
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
mkmat v* if year==2017 & site=="A", matrix(A17al)
mkmat v* if year==2018 & site=="A", matrix(A18al)
mkmat v* if year==2017 & site=="K", matrix(K17al)
mkmat v* if year==2018 & site=="K", matrix(K18al)
*
reshape long
drop v*
*
sort year siteid indid funum, stable
gen funum1=funum
tostring funum1, replace
gen funuml=length(funum1)
gen fuid=indid+"-00"+funum1 if funuml==1
replace fuid=indid+"-0"+funum1 if funuml==2
drop funuml funum1
duplicates list fuid
*
gen long obs=_n
encode indid, gen(group)
sort year siteid indid funum, stable
*
*Agincourt - 2017
tab rsvtp if year==2017 & site=="A"
capture plotmatrix, m(A17al) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "2.PHIRST - Mosaic - RSV - Agincourt 2017 - Allocation.tif", as(tif) width(1600) height(1200) replace
graph export "2.PHIRST - Mosaic - RSV - Agincourt 2017 - Allocation.pdf", as(pdf) replace  
*
*Klerksdorp - 2017
tab rsvtp if year==2017 & site=="K"
capture plotmatrix, m(K17al) split(1 2 3 4 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "2.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Allocation.tif", as(tif) width(1600) height(1200) replace
graph export "2.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Allocation.pdf", as(pdf) replace  
*
*Agincourt - 2018
tab rsvtp if year==2018 & site=="A"
capture plotmatrix, m(A18al) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "2.PHIRST - Mosaic - RSV - Agincourt 2018 - Allocation.tif", as(tif) width(1600) height(1200) replace
graph export "2.PHIRST - Mosaic - RSV - Agincourt 2018 - Allocation.pdf", as(pdf) replace 
*
*Klerksdorp - 2018
tab rsvtp if year==2018 & site=="K"
capture plotmatrix, m(K18al) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "2.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Allocation.tif", as(tif) width(1600) height(1200) replace
graph export "2.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Allocation.pdf", as(pdf) replace  
*
tab rsvtpal year
*
*Generate RSV A, B and untyped variables*
*
*RSV A*
gen rsvaal=rsvautp
replace rsvaal=80 if rsvautp==2
label define rsvaal 1 "A" 80 "Neg" 90 "Missing"
label values rsvaal rsvaal
*
*RSV B*
gen rsvbal=rsvbutp
replace rsvbal=80 if rsvbutp==2
label define rsvbal 1 "B" 80 "Neg" 90 "Missing"
label values rsvbal rsvbal
*
*RSV untyped*
gen rsvutp=1 if rsvtpal==4
replace rsvutp=rsvtpal if rsvtpal>4
replace rsvutp=80 if rsvtpal<4
label define rsvutp 1 "Untyped" 80 "Neg" 90 "Missing"
label values rsvutp rsvutp
*
*Generate episodes variables*
*
*RSV A*
gen frsva=.
gen lrsva=.
*
*RSV B*
gen frsvb=.
gen lrsvb=.
*
*RSV untyped*
gen frsvutp=.
gen lrsvutp=.
*
save "AllocEpis.dta", replace
save "PHIRST - Data - Lab - 2017-2018 - Allocation.dta", replace

*********************
*Define RSV episodes*
*********************

clear all

*Generate master dataset*
postfile mysim year using EpisMaster, replace
postclose mysim

clear all

*LOOP 1: Subset by individual*
forval i = 1/1300 {

quietly use "AllocEpis.dta", clear
quietly keep if group==`i'
sort funum, stable
*display "Master Run: " `i'

*LOOP 2: Defines the beginning and the end of the episode*
forval j = 1/`=_N' {
*
quietly replace frsva=1 if rsvaal[_n]==1 & rsvaal[_n-1]>1 & rsvaal[_n-2]>1 & rsvaal[_n-3]>1 & rsvaal[_n-4]>1
quietly replace lrsva=1 if rsvaal[_n]==1 & rsvaal[_n+1]>1 & rsvaal[_n+2]>1 & rsvaal[_n+3]>1 & rsvaal[_n+4]>1
*
quietly replace frsvb=1 if rsvbal[_n]==1 & rsvbal[_n-1]>1 & rsvbal[_n-2]>1 & rsvbal[_n-3]>1 & rsvbal[_n-4]>1
quietly replace lrsvb=1 if rsvbal[_n]==1 & rsvbal[_n+1]>1 & rsvbal[_n+2]>1 & rsvbal[_n+3]>1 & rsvbal[_n+4]>1
*
quietly replace frsvutp=1 if rsvutp[_n]==1 & rsvutp[_n-1]>1 & rsvutp[_n-2]>1 & rsvutp[_n-3]>1 & rsvutp[_n-4]>1
quietly replace lrsvutp=1 if rsvutp[_n]==1 & rsvutp[_n+1]>1 & rsvutp[_n+2]>1 & rsvutp[_n+3]>1 & rsvutp[_n+4]>1
*
}
*
quietly sort frsva funum, stable
quietly gen ersva=_n
quietly replace ersva=. if frsva==.
quietly sort funum, stable
*
quietly sort frsvb funum, stable
quietly gen ersvb=_n
quietly replace ersvb=. if frsvb==.
quietly sort funum, stable
*
quietly sort frsvutp funum, stable
quietly gen ersvutp=_n
quietly replace ersvutp=. if frsvutp==.
quietly sort funum, stable
*
*LOOP 3: Define the entire episode*
forval k = 1/`=_N' {
*
quietly replace ersva=ersva[_n-1] if rsvaal[_n]==1 & rsvaal[_n-1]>0 & rsvaal[_n-2]>0 & rsvaal[_n-3]>0 & frsva==.
quietly replace ersva=ersva[_n-1] if rsvaal[_n]>1 & (rsvaal[_n-1]==1 | rsvaal[_n-2]==1 | rsvaal[_n-3]==1) & (rsvaal[_n+1]==1 | rsvaal[_n+2]==1 | rsvaal[_n+3]==1)
*
quietly replace ersvb=ersvb[_n-1] if rsvbal[_n]==1 & rsvbal[_n-1]>0 & rsvbal[_n-2]>0 & rsvbal[_n-3]>0 & frsvb==.
quietly replace ersvb=ersvb[_n-1] if rsvbal[_n]>1 & (rsvbal[_n-1]==1 | rsvbal[_n-2]==1 | rsvbal[_n-3]==1) & (rsvbal[_n+1]==1 | rsvbal[_n+2]==1 | rsvbal[_n+3]==1)
*
quietly replace ersvutp=ersvutp[_n-1] if rsvutp[_n]==1 & rsvutp[_n-1]>0 & rsvutp[_n-2]>0 & rsvutp[_n-3]>0 & frsvutp==.
quietly replace ersvutp=ersvutp[_n-1] if rsvutp[_n]>1 & (rsvutp[_n-1]==1 | rsvutp[_n-2]==1 | rsvutp[_n-3]==1) & (rsvutp[_n+1]==1 | rsvutp[_n+2]==1 | rsvutp[_n+3]==1)
*
}
*
quietly gen flrsva=ersva*10+1 if frsva==1
quietly replace flrsva=ersva*10+2 if lrsva==1
*
quietly gen flrsvb=ersvb*10+1 if frsvb==1
quietly replace flrsvb=ersvb*10+2 if lrsvb==1
*
quietly gen flrsvutp=ersvutp*10+1 if frsvutp==1
quietly replace flrsvutp=ersvutp*10+2 if lrsvutp==1
*
quietly save "EpisSim.dta", replace
quietly clear
quietly use "EpisMaster.dta"
quietly append using "EpisSim.dta"
quietly save "EpisMaster.dta", replace
quietly clear
}
*
use "EpisMaster.dta", clear

*Generate RSV variable*

gen rsvtpep=1 if ersva==1
replace rsvtpep=2 if ersvb==1
replace rsvtpep=3 if ersva==1 & ersvb==1
replace rsvtpep=4 if ersvutp==1
replace rsvtpep=rsvtpal if rsvtpep==.
label define rsvtpep 80 "Neg" 90 "Missing" 1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values rsvtpep rsvtpep
*
tab rsvtpep
tab rsvtpep rsvtpal
*
order year siteid hhid indid fuid funum
*
save "EpisMaster.dta", replace
*
foreach var of varlist ersva-ersvutp {
quietly gen `var'o=`var'
}
*
gen date=npsdatecol

*Correct the start and end of each episode with a uniform distribution to correct for period between swabs
*Generate uniform dist for start and finish of episode
set seed 11111
generate uf = round(runiform(0, 3))
generate ul = round(runiform(0, 3))

*Change the value to zero if it is not the first or last swab in the episode
replace uf = 0 if frsva==. & frsvb==. & frsvutp==.
replace ul = 0 if lrsva==. & lrsvb==. & lrsvutp==.

*Update the date using uniform distribution (only for first and last swab)
replace date = date - uf
replace date = date + ul

*
save "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", replace
keep fuid indid
save "FuID.dta", replace
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear
keep fuid indid ersvao-ersvutpo
save "FuIDEpis.dta", replace
use "EpisMaster.dta", clear

*Generate mosaics*
*
keep year siteid hhid indid rsvtpep funum
reshape wide rsvtpep, i(year siteid hhid indid) j(funum)
*
forval i=1/83 {
qui gen v`i'=.
}
capture forval i=1/83 {
qui replace v`i'=rsvtpep`i'
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
mkmat v* if year==2017 & site=="A", matrix(A17ep)
mkmat v* if year==2018 & site=="A", matrix(A18ep)
mkmat v* if year==2017 & site=="K", matrix(K17ep)
mkmat v* if year==2018 & site=="K", matrix(K18ep)
*
reshape long
drop v*
*
*Agincourt - 2017
tab rsvtp if year==2017 & site=="A"
capture plotmatrix, m(A17ep) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "3.PHIRST - Mosaic - RSV - Agincourt 2017 - Episode.tif", as(tif) width(1600) height(1200) replace
graph export "3.PHIRST - Mosaic - RSV - Agincourt 2017 - Episode.pdf", as(pdf) replace  
*
*Klerksdorp - 2017
tab rsvtp if year==2017 & site=="K"
capture plotmatrix, m(K17ep) split(1 2 3 4 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "3.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Episode.tif", as(tif) width(1600) height(1200) replace
graph export "3.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Episode.pdf", as(pdf) replace  
*
*Agincourt - 2018
tab rsvtp if year==2018 & site=="A"
capture plotmatrix, m(A18ep) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "3.PHIRST - Mosaic - RSV - Agincourt 2018 - Episode.tif", as(tif) width(1600) height(1200) replace
graph export "3.PHIRST - Mosaic - RSV - Agincourt 2018 - Episode.pdf", as(pdf) replace 
*
*Klerksdorp - 2018
tab rsvtp if year==2018 & site=="K"
capture plotmatrix, m(K18ep) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV type A,B" 6 "RSV untyped" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "3.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Episode.tif", as(tif) width(1600) height(1200) replace
graph export "3.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Episode.pdf", as(pdf) replace  
*
clear all
