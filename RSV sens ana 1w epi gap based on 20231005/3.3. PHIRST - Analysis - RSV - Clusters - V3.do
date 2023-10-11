*******************************************
*******************************************
*PHIRST: RSV Household Clusters - Analysis*
*******************************************
*******************************************

clear
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 

*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear 


******************************
*Prepare dataset for analysis*
******************************

foreach var of varlist ersva-ersvutp {
quietly replace `var'=1 if `var'!=.
quietly replace `var'=rsvtpal if (rsvtpal==80 | rsvtpal==90) & `var'==.
quietly replace `var'=80 if `var'==.
}
*
gen indidnum=substr(indid,6,.)
destring indidnum, replace
*
keep year siteid hhid indidnum funum ersva ersvb ersvutp rsvtpep date
reshape wide ersva ersvb ersvutp rsvtpep date, i(year siteid hhid funum) j(indidnum)
*
gen ersvaall=.
foreach var of varlist ersva* {
quietly replace ersvaall=1 if `var'==1
}
replace ersvaall=80 if ersvaall==.
*
gen ersvball=.
foreach var of varlist ersvb* {
quietly replace ersvball=1 if `var'==1
}
replace ersvball=80 if ersvball==.
*
gen ersvutpall=.
foreach var of varlist ersvutp* {
quietly replace ersvutpall=1 if `var'==1
}
replace ersvutpall=80 if ersvutpall==.
*
*Generate cluster variables*
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
gen long obs=_n
encode hhid, gen(group)
sort year siteid hhid funum, stable
*
save "EpisAllMaster.dta", replace


***************************************************
*Define household clusters by RSV A, B and untyped*
***************************************************

clear all

*Generate master dataset*
postfile mysim year using ClusMaster1, replace
postclose mysim

clear all

*LOOP 1: Subset by household*
forval i = 1/1300 {

quietly use "EpisAllMaster.dta", clear
quietly keep if group==`i'
sort funum, stable
*display "Master Run: " `i'

*LOOP 2: Defines the beginning and the end of the cluster*
forval j = 1/`=_N' {
*
quietly replace frsva=1 if ersvaall[_n]==1 & ersvaall[_n-1]>1 & ersvaall[_n-2]>1 & ersvaall[_n-3]>1 & ersvaall[_n-4]>1
quietly replace lrsva=1 if ersvaall[_n]==1 & ersvaall[_n+1]>1 & ersvaall[_n+2]>1 & ersvaall[_n+3]>1 & ersvaall[_n+4]>1
*
quietly replace frsvb=1 if ersvball[_n]==1 & ersvball[_n-1]>1 & ersvball[_n-2]>1 & ersvball[_n-3]>1 & ersvball[_n-4]>1
quietly replace lrsvb=1 if ersvball[_n]==1 & ersvball[_n+1]>1 & ersvball[_n+2]>1 & ersvball[_n+3]>1 & ersvball[_n+4]>1
*
quietly replace frsvutp=1 if ersvutpall[_n]==1 & ersvutpall[_n-1]>1 & ersvutpall[_n-2]>1 & ersvutpall[_n-3]>1 & ersvutpall[_n-4]>1
quietly replace lrsvutp=1 if ersvutpall[_n]==1 & ersvutpall[_n+1]>1 & ersvutpall[_n+2]>1 & ersvutpall[_n+3]>1 & ersvutpall[_n+4]>1
*
}
*
quietly sort frsva funum, stable
quietly gen crsva=_n
quietly replace crsva=. if frsva==.
quietly sort funum, stable
*
quietly sort frsvb funum, stable
quietly gen crsvb=_n
quietly replace crsvb=. if frsvb==.
quietly sort funum, stable
*
quietly sort frsvutp funum, stable
quietly gen crsvutp=_n
quietly replace crsvutp=. if frsvutp==.
quietly sort funum, stable
*
*LOOP 3: Define the entire cluster*
forval k = 1/`=_N' {
*
quietly replace crsva=crsva[_n-1] if ersvaall[_n]==1 & ersvaall[_n-1]>0 & ersvaall[_n-2]>0 & ersvaall[_n-3]>0 & frsva==.
quietly replace crsva=crsva[_n-1] if ersvaall[_n]>1 & (ersvaall[_n-1]==1 | ersvaall[_n-2]==1 | ersvaall[_n-3]==1) & (ersvaall[_n+1]==1 | ersvaall[_n+2]==1 | ersvaall[_n+3]==1)
*
quietly replace crsvb=crsvb[_n-1] if ersvball[_n]==1 & ersvball[_n-1]>0 & ersvball[_n-2]>0 & ersvball[_n-3]>0 & frsvb==.
quietly replace crsvb=crsvb[_n-1] if ersvball[_n]>1 & (ersvball[_n-1]==1 | ersvball[_n-2]==1 | ersvball[_n-3]==1) & (ersvball[_n+1]==1 | ersvball[_n+2]==1 | ersvball[_n+3]==1)
*
quietly replace crsvutp=crsvutp[_n-1] if ersvutpall[_n]==1 & ersvutpall[_n-1]>0 & ersvutpall[_n-2]>0 & ersvutpall[_n-3]>0 & frsvutp==.
quietly replace crsvutp=crsvutp[_n-1] if ersvutpall[_n]>1 & (ersvutpall[_n-1]==1 | ersvutpall[_n-2]==1 | ersvutpall[_n-3]==1) & (ersvutpall[_n+1]==1 | ersvutpall[_n+2]==1 | ersvutpall[_n+3]==1)
*
}
*
quietly gen flrsva=crsva*10+1 if frsva==1
quietly replace flrsva=crsva*10+2 if lrsva==1
*
quietly gen flrsvb=crsvb*10+1 if frsvb==1
quietly replace flrsvb=crsvb*10+2 if lrsvb==1
*
quietly gen flrsvutp=crsvutp*10+1 if frsvutp==1
quietly replace flrsvutp=crsvutp*10+2 if lrsvutp==1
*
quietly save "ClusSim1.dta", replace
quietly clear
quietly use "ClusMaster1.dta"
quietly append using "ClusSim1.dta"
quietly save "ClusMaster1.dta", replace
quietly clear
}
*
use "ClusMaster1.dta", clear
*
tab crsva
tab crsvb
tab crsvutp
*
gen crsva_=crsva
gen crsvb_=crsvb
gen crsvutp_=crsvutp
*
foreach var of varlist crsva_-crsvutp_ {
quietly replace `var'=1 if `var'!=.
}
*
gen rsvtpep0=1 if crsva_==1
replace rsvtpep0=2 if crsvb_==1
replace rsvtpep0=3 if crsva_==1 & crsvb_==1
replace rsvtpep0=4 if crsvutp_==1
replace rsvtpep0=100 if rsvtpep0==.
label define rsvtpep0 100 "No Clusters" 1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values rsvtpep0 rsvtpep0
tab rsvtpep0
*
save "ClusMaster1.dta", replace
*
keep year-funum ersva* ersvb* ersvutp* rsvtpep*
reshape long
order year siteid hhid indidnum funum
sort year siteid hhid indidnum funum, stable
*
tostring indidnum,replace
gen indidlen=length(indidnum)
*
gen indid=hhid+"-00"+indidnum if indidlen==1
replace indid=hhid+"-0"+indidnum if indidlen==2
*
tostring funum,replace
gen funumlen=length(funum)
*
gen fuid=indid+"-00"+funum if funumlen==1
replace fuid=indid+"-0"+funum if funumlen==2
*
drop funumlen indidlen
destring funum, replace 
destring indidnum, replace
*
merge 1:1 fuid using "FuID.dta"
*
replace _merge=3 if indidnum==0
keep if _merge==3
drop _merge
order year siteid hhid indid fuid indidnum funum
*
label define rsvtpepc 80 "Neg" 90 "Missing" 100 "No Cluster" 1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values rsvtpep rsvtpepc
tab rsvtpep
*
save "ClusMaster1Long.dta", replace

*Generate mosaics*
*
gen rsvtpep1=rsvtpep
replace rsvtpep1=200 if rsvtpep<80 & indidnum==0
label define rsvtpep1 80 "Neg" 90 "Missing" 100 "No Cluster" 200 "Cluster" 1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values rsvtpep1 rsvtpep1
tab rsvtpep1
*
save "ClusMaster1Long.dta", replace
*
keep year siteid hhid indid rsvtpep1 funum
reshape wide rsvtpep, i(year siteid hhid indid) j(funum)
*
forval i=1/83 {
qui gen v`i'=.
}
capture forval i=1/83 {
qui replace v`i'=rsvtpep1`i'
}
foreach var of varlist v* {
qui replace `var'=8 if `var'==4
qui replace `var'=7 if `var'==3
qui replace `var'=6 if `var'==2
qui replace `var'=5 if `var'==1
qui replace `var'=4 if `var'==90
qui replace `var'=3 if `var'==80
qui replace `var'=2 if `var'==100
qui replace `var'=1 if `var'==200
}
*
mkmat v* if year==2017 & site=="A", matrix(A17cl1)
mkmat v* if year==2018 & site=="A", matrix(A18cl1)
mkmat v* if year==2017 & site=="K", matrix(K17cl1)
mkmat v* if year==2018 & site=="K", matrix(K18cl1)
*
reshape long
drop v*
*
*Agincourt - 2017
tab rsvtpep1 if year==2017 & site=="A"
capture plotmatrix, m(A17cl1) split(1 2 3 4 5 6 7 8) allcolors(black gray*0.9 gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(1 "Cluster" 2 "No cluster" 5 "RSV A" 6 "RSV B" 7 "RSV A,B" 8 "RSV subgroup not determined" 3 "RSV negative" 4 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "5.PHIRST - Mosaic - RSV - Agincourt 2017 - Cluster (No Allocation).tif", as(tif) width(1600) height(1200) replace
graph export "5.PHIRST - Mosaic - RSV - Agincourt 2017 - Cluster (No Allocation).pdf", as(pdf) replace  
*
*Klerksdorp - 2017
tab rsvtpep1 if year==2017 & site=="K"
capture plotmatrix, m(K17cl1) split(1 2 3 4 5 6 8) allcolors(black gray*0.9 gray*0.5 gray*0.1 cranberry green*0.7 yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(1 "Cluster" 2 "No cluster" 5 "RSV A" 6 "RSV B" 7 "RSV subgroup not determined" 3 "RSV negative" 4 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "5.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Cluster (No Allocation).tif", as(tif) width(1600) height(1200) replace
graph export "5.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Cluster (No Allocation).pdf", as(pdf) replace  
*
*Agincourt - 2018
tab rsvtpep1 if year==2018 & site=="A"
capture plotmatrix, m(A18cl1) split(1 2 3 4 5 6 7 8) allcolors(black gray*0.9 gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(1 "Cluster" 2 "No cluster" 5 "RSV A" 6 "RSV B" 7 "RSV A,B" 8 "RSV subgroup not determined" 3 "RSV negative" 4 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "5.PHIRST - Mosaic - RSV - Agincourt 2018 - Cluster (No Allocation).tif", as(tif) width(1600) height(1200) replace
graph export "5.PHIRST - Mosaic - RSV - Agincourt 2018 - Cluster (No Allocation).pdf", as(pdf) replace   
*
*Klerksdorp - 2018
tab rsvtpep1 if year==2018 & site=="K"
capture plotmatrix, m(K18cl1) split(1 2 3 4 5 6 7 8) allcolors(black gray*0.9 gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(1 "Cluster" 2 "No cluster" 5 "RSV A" 6 "RSV B" 7 "RSV A,B" 8 "RSV subgroup not determined" 3 "RSV negative" 4 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "5.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Cluster (No Allocation).tif", as(tif) width(1600) height(1200) replace
graph export "5.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Cluster (No Allocation).pdf", as(pdf) replace    


************************************************************
*Define household clusters by RSV types and include untyped*
************************************************************

clear all

use "ClusMaster1.dta", clear

*Generate cluster variables with RSV untyped*
*
*RSV A and untyped*
gen frsva1=.
gen lrsva1=.
replace crsva_=1 if crsvutp_==1
*
*RSV B and untyped*
gen frsvb1=.
gen lrsvb1=.
replace crsvb_=1 if crsvutp_==1
*
foreach var of varlist crsva_ crsvb_ {
quietly replace `var'=80 if `var'==.
}
*
save "ClusMaster1.dta", replace

clear all

*Generate master dataset*
postfile mysim year using ClusMaster2, replace
postclose mysim

clear all

*LOOP 1: Subset by household*
forval i = 1/1300 {

quietly use "ClusMaster1.dta", clear
quietly keep if group==`i'
sort funum, stable
*display "Master Run: " `i'

*LOOP 2: Defines the beginning and the end of the cluster*
forval j = 1/`=_N' {
*
quietly replace frsva1=1 if crsva_[_n]==1 & crsva_[_n-1]>1 & crsva_[_n-2]>1 & crsva_[_n-3]>1 & crsva_[_n-4]>1
quietly replace lrsva1=1 if crsva_[_n]==1 & crsva_[_n+1]>1 & crsva_[_n+2]>1 & crsva_[_n+3]>1 & crsva_[_n+4]>1
*
quietly replace frsvb1=1 if crsvb_[_n]==1 & crsvb_[_n-1]>1 & crsvb_[_n-2]>1 & crsvb_[_n-3]>1 & crsvb_[_n-4]>1
quietly replace lrsvb1=1 if crsvb_[_n]==1 & crsvb_[_n+1]>1 & crsvb_[_n+2]>1 & crsvb_[_n+3]>1 & crsvb_[_n+4]>1
*
}
*
quietly sort frsva1 funum, stable
quietly gen crsva1=_n
quietly replace crsva1=. if frsva1==.
quietly sort funum, stable
*
quietly sort frsvb1 funum, stable
quietly gen crsvb1=_n
quietly replace crsvb1=. if frsvb1==.
quietly sort funum, stable
*
*LOOP 3: Define the entire cluster*
forval k = 1/`=_N' {
*
quietly replace crsva1=crsva1[_n-1] if crsva_[_n]==1 & crsva_[_n-1]>0 & crsva_[_n-2]>0 & crsva_[_n-3]>0 & frsva1==.
quietly replace crsva1=crsva1[_n-1] if crsva_[_n]>1 & (crsva_[_n-1]==1 | crsva_[_n-2]==1 | crsva_[_n-3]==1) & (crsva_[_n+1]==1 | crsva_[_n+2]==1 | crsva_[_n+3]==1)
*
quietly replace crsvb1=crsvb1[_n-1] if crsvb_[_n]==1 & crsvb_[_n-1]>0 & crsvb_[_n-2]>0 & crsvb_[_n-3]>0 & frsvb1==.
quietly replace crsvb1=crsvb1[_n-1] if crsvb_[_n]>1 & (crsvb_[_n-1]==1 | crsvb_[_n-2]==1 | crsvb_[_n-3]==1) & (crsvb_[_n+1]==1 | crsvb_[_n+2]==1 | crsvb_[_n+3]==1)
*
}
*
quietly gen flrsva1=crsva1*10+1 if frsva1==1
quietly replace flrsva1=crsva1*10+2 if lrsva1==1
*
quietly gen flrsvb1=crsvb1*10+1 if frsvb1==1
quietly replace flrsvb1=crsvb1*10+2 if lrsvb1==1
*
quietly save "ClusSim2.dta", replace
quietly clear
quietly use "ClusMaster2.dta"
quietly append using "ClusSim2.dta"
quietly save "ClusMaster2.dta", replace
quietly clear
}
*
use "ClusMaster2.dta", clear
*

********************************
*Allocate RSV types to clusters*
********************************
*
gen crsva1_=1 if crsva1!=.
gen crsva2=1 if crsva1!=.
replace crsva2=2 if crsvutp_==1
*
gen crsvb1_=1 if crsvb1!=.
gen crsvb2=1 if crsvb1!=.
replace crsvb2=2 if crsvutp_==1
*
save "ClusMaster2.dta", replace
*
clear all

*Generate master dataset*
postfile mysim year using AllocClus, replace
postclose mysim
clear

forval i = 1/1300 {

quietly use "ClusMaster2.dta", clear
quietly keep if group==`i'
*display "Master Run: " `i'

forval j = 1/`=_N' {
quietly replace crsva2=1 if crsva2==2 & (crsva2[_n-1]==1 | crsva2[_n-2]==1 | crsva2[_n-3]==1 | crsva2[_n-4]==1 | crsva2[_n+1]==1 | crsva2[_n+2]==1 | crsva2[_n+3]==1 | crsva2[_n+4]==1)
quietly replace crsvb2=1 if crsvb2==2 & (crsvb2[_n-1]==1 | crsvb2[_n-2]==1 | crsvb2[_n-3]==1 | crsvb2[_n-4]==1 | crsvb2[_n+1]==1 | crsvb2[_n+2]==1 | crsvb2[_n+3]==1 | crsvb2[_n+4]==1)
*display "Run: " `j'
}

quietly save "AllocSimClus.dta", replace
quietly clear
quietly use "AllocClus.dta"
quietly append using "AllocSimClus.dta"
quietly save "AllocClus.dta", replace
quietly clear

}
*
use "AllocClus.dta", clear
*
*Generate cluster*
*
*RSV A*
gen frsvaf=.
gen lrsvaf=.
replace crsva2=1 if crsva!=.
replace crsva2=. if crsva2==2
*
*RSV B*
gen frsvbf=.
gen lrsvbf=.
replace crsvb2=1 if crsvb!=.
replace crsvb2=. if crsvb2==2
*
*RSV untyped*
gen frsvutpf=.
gen lrsvutpf=.
gen crsvutp2=crsvutp_
replace crsvutp2=. if crsvutp_==1 & (crsva2==1 | crsvb2==1)
*
foreach var of varlist crsva2 crsvb2 crsvutp2 {
quietly replace `var'=80 if `var'==.
}
*
save "AllocClus.dta", replace


*********************************************************
*Define final household clusters by RSV A, B and untyped*
*********************************************************

clear all

*Generate master dataset*
postfile mysim year using ClusMaster3, replace
postclose mysim

clear all

*LOOP 1: Subset by household*
forval i = 1/1300 {

quietly use "AllocClus.dta", clear
quietly keep if group==`i'
sort funum, stable
*display "Master Run: " `i'

*LOOP 2: Defines the beginning and the end of the cluster*
forval j = 1/`=_N' {
*
quietly replace frsvaf=1 if crsva2[_n]==1 & crsva2[_n-1]>1 & crsva2[_n-2]>1 & crsva2[_n-3]>1 & crsva2[_n-4]>1
quietly replace lrsvaf=1 if crsva2[_n]==1 & crsva2[_n+1]>1 & crsva2[_n+2]>1 & crsva2[_n+3]>1 & crsva2[_n+4]>1
*
quietly replace frsvbf=1 if crsvb2[_n]==1 & crsvb2[_n-1]>1 & crsvb2[_n-2]>1 & crsvb2[_n-3]>1 & crsvb2[_n-4]>1
quietly replace lrsvbf=1 if crsvb2[_n]==1 & crsvb2[_n+1]>1 & crsvb2[_n+2]>1 & crsvb2[_n+3]>1 & crsvb2[_n+4]>1
*
quietly replace frsvutpf=1 if crsvutp2[_n]==1 & crsvutp2[_n-1]>1 & crsvutp2[_n-2]>1 & crsvutp2[_n-3]>1 & crsvutp2[_n-4]>1
quietly replace lrsvutpf=1 if crsvutp2[_n]==1 & crsvutp2[_n+1]>1 & crsvutp2[_n+2]>1 & crsvutp2[_n+3]>1 & crsvutp2[_n+4]>1
*
}
*
quietly sort frsvaf funum, stable
quietly gen crsvaf=_n
quietly replace crsvaf=. if frsvaf==.
quietly sort funum, stable
*
quietly sort frsvbf funum, stable
quietly gen crsvbf=_n
quietly replace crsvbf=. if frsvbf==.
quietly sort funum, stable
*
quietly sort frsvutpf funum, stable
quietly gen crsvutpf=_n
quietly replace crsvutpf=. if frsvutpf==.
quietly sort funum, stable
*
*LOOP 3: Define the entire cluster*
forval k = 1/`=_N' {
*
quietly replace crsvaf=crsvaf[_n-1] if crsva2[_n]==1 & crsva2[_n-1]>0 & crsva2[_n-2]>0 & crsva2[_n-3]>0 & frsvaf==.
quietly replace crsvaf=crsvaf[_n-1] if crsva2[_n]>1 & (crsva2[_n-1]==1 | crsva2[_n-2]==1 | crsva2[_n-3]==1) & (crsva2[_n+1]==1 | crsva2[_n+2]==1 | crsva2[_n+3]==1)
*
quietly replace crsvbf=crsvbf[_n-1] if crsvb2[_n]==1 & crsvb2[_n-1]>0 & crsvb2[_n-2]>0 & crsvb2[_n-3]>0 & frsvbf==.
quietly replace crsvbf=crsvbf[_n-1] if crsvb2[_n]>1 & (crsvb2[_n-1]==1 | crsvb2[_n-2]==1 | crsvb2[_n-3]==1) & (crsvb2[_n+1]==1 | crsvb2[_n+2]==1 | crsvb2[_n+3]==1)
*
quietly replace crsvutpf=crsvutpf[_n-1] if crsvutp2[_n]==1 & crsvutp2[_n-1]>0 & crsvutp2[_n-2]>0 & crsvutp2[_n-3]>0 & frsvutpf==.
quietly replace crsvutpf=crsvutpf[_n-1] if crsvutp2[_n]>1 & (crsvutp2[_n-1]==1 | crsvutp2[_n-2]==1 | crsvutp2[_n-3]==1) & (crsvutp2[_n+1]==1 | crsvutp2[_n+2]==1 | crsvutp2[_n+3]==1)
*
}
*
quietly gen flrsvaf=crsvaf*10+1 if frsvaf==1
quietly replace flrsvaf=crsvaf*10+2 if lrsvaf==1
*
quietly gen flrsvbf=crsvbf*10+1 if frsvbf==1
quietly replace flrsvbf=crsvbf*10+2 if lrsvbf==1
*
quietly gen flrsvutpf=crsvutpf*10+1 if frsvutpf==1
quietly replace flrsvutpf=crsvutpf*10+2 if lrsvutpf==1
*
quietly save "ClusSim3.dta", replace
quietly clear
quietly use "ClusMaster3.dta"
quietly append using "ClusSim3.dta"
quietly save "ClusMaster3.dta", replace
quietly clear
}
*
use "ClusMaster3.dta", clear

*Generate episode and cluster variables after the loop*
forval i = 1/20 {
quietly gen ersvaf`i'=ersva`i'
quietly gen ersvbf`i'=ersvb`i'
quietly gen ersvutpf`i'=ersvutp`i'
}
*
*RSV A*
*
forval i = 1/20 {
foreach var of varlist ersvaf`i' {
quietly replace ersvaf`i'=ersvutpf`i' if ersvutpf`i'==1 & crsvaf!=.
quietly replace ersvutpf`i'=80 if ersvutpf`i'==1 & crsvaf!=.
}
}
*
*RSV B*
forval i = 1/20 {
foreach var of varlist ersvbf`i' {
quietly replace ersvbf`i'=ersvutpf`i' if ersvutpf`i'==1 & crsvbf!=.
quietly replace ersvutpf`i'=80 if ersvutpf`i'==1 & crsvbf!=.
}
}
*
*Generate cluster variable*
*
replace rsvtpep0=.
foreach var of varlist crsvaf crsvbf crsvutpf {
quietly replace rsvtpep0=200 if `var'!=.
}
replace rsvtpep0=100 if rsvtpep0==.
label define rsvtpep01 100 "No Cluster" 200 "Cluster"
label values rsvtpep0 rsvtpep01
*
gen clusf=1 if rsvtpep0==200
replace clusf=0 if rsvtpep0==100
label define clusf 0 "No Cluster" 1 "Cluster"
label values clusf clusf
*
save "PHIRST - Data - Lab - 2017-2018 - Clusters.dta", replace 
*
keep year-funum ersva* ersvb* ersvutp* rsvtpep*
drop ersvaall ersvball ersvutpall
reshape long ersva ersvb ersvutp ersvaf ersvbf ersvutpf rsvtpep, i(hhid funum) j(indidnum)
order year siteid hhid indidnum funum
sort year siteid hhid indidnum funum, stable
*
tostring indidnum,replace
gen indidlen=length(indidnum)
*
gen indid=hhid+"-00"+indidnum if indidlen==1
replace indid=hhid+"-0"+indidnum if indidlen==2
*
tostring funum,replace
gen funumlen=length(funum)
*
gen fuid=indid+"-00"+funum if funumlen==1
replace fuid=indid+"-0"+funum if funumlen==2
*
drop funumlen indidlen
destring funum, replace 
destring indidnum, replace
*
merge 1:1 fuid using "FuID.dta"
*
replace _merge=3 if indidnum==0
keep if _merge==3
drop _merge
order year siteid hhid indid fuid indidnum funum
*
label define clus 80 "Neg" 90 "Missing" 100 "No Cluster" 200 "Cluster"  1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values rsvtpep clus
tab rsvtpep
*
save "ClusMaster2Long.dta", replace

*Generate mosaics*
*
gen rsvtpep2=1 if ersvaf==1
replace rsvtpep2=2 if ersvbf==1
replace rsvtpep2=3 if ersvaf==1 & ersvbf==1
replace rsvtpep2=4 if ersvutpf==1
replace rsvtpep2=80 if rsvtpep==80
replace rsvtpep2=90 if rsvtpep==90
replace rsvtpep2=100 if rsvtpep==100
replace rsvtpep2=200 if rsvtpep==200
label define rsvtpep2 80 "Neg" 90 "Missing" 100 "No Cluster" 200 "Cluster"  1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values rsvtpep2 rsvtpep2
tab rsvtpep
tab rsvtpep2
*
save "ClusMaster2Long.dta", replace
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
qui replace `var'=8 if `var'==4
qui replace `var'=7 if `var'==3
qui replace `var'=6 if `var'==2
qui replace `var'=5 if `var'==1
qui replace `var'=4 if `var'==90
qui replace `var'=3 if `var'==80
qui replace `var'=2 if `var'==100
qui replace `var'=1 if `var'==200
}
*
mkmat v* if year==2017 & site=="A", matrix(A17cl2)
mkmat v* if year==2018 & site=="A", matrix(A18cl2)
mkmat v* if year==2017 & site=="K", matrix(K17cl2)
mkmat v* if year==2018 & site=="K", matrix(K18cl2)
*
reshape long
drop v*
*
*Agincourt - 2017
tab rsvtpep2 if year==2017 & site=="A"
capture plotmatrix, m(A17cl2) split(1 2 3 4 5 6 7) allcolors(black gray*0.9 gray*0.5 gray*0.1 cranberry green*0.7 orange) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(1 "Cluster" 2 "No cluster" 5 "RSV A" 6 "RSV B" 7 "RSV A,B" 3 "RSV subgroup not determined" 4 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "6.PHIRST - Mosaic - RSV - Agincourt 2017 - Cluster (Allocation).tif", as(tif) width(1600) height(1200) replace
graph export "6.PHIRST - Mosaic - RSV - Agincourt 2017 - Cluster (Allocation).pdf", as(pdf) replace  
*
*Klerksdorp - 2017
tab rsvtpep2 if year==2017 & site=="K"
capture plotmatrix, m(K17cl2) split(1 2 3 4 5 6 8) allcolors(black gray*0.9 gray*0.5 gray*0.1 cranberry green*0.7 yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(1 "Cluster" 2 "No cluster" 5 "RSV A" 6 "RSV B" 7 "RSV subgroup not determined" 3 "RSV negative" 4 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "6.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Cluster (Allocation).tif", as(tif) width(1600) height(1200) replace
graph export "6.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Cluster (Allocation).pdf", as(pdf) replace  
*
*Agincourt - 2018
tab rsvtpep2 if year==2018 & site=="A"
capture plotmatrix, m(A18cl2) split(1 2 3 4 5 6 7 8) allcolors(black gray*0.9 gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(1 "Cluster" 2 "No cluster" 5 "RSV A" 6 "RSV B" 7 "RSV A,B" 8 "RSV subgroup not determined" 3 "RSV negative" 4 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "6.PHIRST - Mosaic - RSV - Agincourt 2018 - Cluster (Allocation).tif", as(tif) width(1600) height(1200) replace
graph export "6.PHIRST - Mosaic - RSV - Agincourt 2018 - Cluster (Allocation).pdf", as(pdf) replace   
*
*Klerksdorp - 2018
tab rsvtpep2 if year==2018 & site=="K"
capture plotmatrix, m(K18cl2) split(1 2 3 4 5 6 7 8) allcolors(black gray*0.9 gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(1 "Cluster" 2 "No cluster" 5 "RSV A" 6 "RSV B" 7 "RSV A,B" 8 "RSV subgroup not determined" 3 "RSV negative" 4 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "6.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Cluster (Allocation).tif", as(tif) width(1600) height(1200) replace
graph export "6.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Cluster (Allocation).pdf", as(pdf) replace    

clear


***************************
*Define Number of Episodes*
***************************

use "ClusMaster2Long.dta", clear

foreach var of varlist ersvaf-ersvutpf {
quietly gen f`var'n=.
quietly gen l`var'n=.
}
*
drop if indidnum==0
*
sort year siteid indid funum, stable
*
gen long obs=_n
encode indid, gen(group)
sort year siteid indid funum, stable
*
save "ClusMaster2Long.dta", replace

clear all

*Generate master dataset*
postfile mysim year using EpisMasterFinal, replace
postclose mysim

clear all

*LOOP 1: Subset by individual*
forval i = 1/1300 {

quietly use "ClusMaster2Long.dta", clear
quietly keep if group==`i'
sort funum, stable
*display "Master Run: " `i'

*LOOP 2: Defines the beginning and the end of the episode*
forval j = 1/`=_N' {
*
quietly replace fersvafn=1 if ersvaf[_n]==1 & ersvaf[_n-1]>1 & ersvaf[_n-2]>1 & ersvaf[_n-3]>1 & ersvaf[_n-4]>1
quietly replace lersvafn=1 if ersvaf[_n]==1 & ersvaf[_n+1]>1 & ersvaf[_n+2]>1 & ersvaf[_n+3]>1 & ersvaf[_n+4]>1
*
quietly replace fersvbfn=1 if ersvbf[_n]==1 & ersvbf[_n-1]>1 & ersvbf[_n-2]>1 & ersvbf[_n-3]>1 & ersvbf[_n-4]>1
quietly replace lersvbfn=1 if ersvbf[_n]==1 & ersvbf[_n+1]>1 & ersvbf[_n+2]>1 & ersvbf[_n+3]>1 & ersvbf[_n+4]>1
*
quietly replace fersvutpfn=1 if ersvutpf[_n]==1 & ersvutpf[_n-1]>1 & ersvutpf[_n-2]>1 & ersvutpf[_n-3]>1 & ersvutpf[_n-4]>1
quietly replace lersvutpfn=1 if ersvutpf[_n]==1 & ersvutpf[_n+1]>1 & ersvutpf[_n+2]>1 & ersvutpf[_n+3]>1 & ersvutpf[_n+4]>1
*
}
*
quietly sort fersvafn funum, stable
quietly gen ersvafn=_n
quietly replace ersvafn=. if fersvafn==.
quietly sort funum, stable
*
quietly sort fersvbfn funum, stable
quietly gen ersvbfn=_n
quietly replace ersvbfn=. if fersvbfn==.
quietly sort funum, stable
*
quietly sort fersvutpfn funum, stable
quietly gen ersvutpfn=_n
quietly replace ersvutpfn=. if fersvutpfn==.
quietly sort funum, stable
*
*LOOP 3: Define the entire episode*
forval k = 1/`=_N' {
*
quietly replace ersvafn=ersvafn[_n-1] if ersvaf[_n]==1 & ersvaf[_n-1]>0 & ersvaf[_n-2]>0 & ersvaf[_n-3]>0 & fersvafn==.
quietly replace ersvafn=ersvafn[_n-1] if ersvaf[_n]>1 & (ersvaf[_n-1]==1 | ersvaf[_n-2]==1 | ersvaf[_n-3]==1) & (ersvaf[_n+1]==1 | ersvaf[_n+2]==1 | ersvaf[_n+3]==1)
*
quietly replace ersvbfn=ersvbfn[_n-1] if ersvbf[_n]==1 & ersvbf[_n-1]>0 & ersvbf[_n-2]>0 & ersvbf[_n-3]>0 & fersvbfn==.
quietly replace ersvbfn=ersvbfn[_n-1] if ersvbf[_n]>1 & (ersvbf[_n-1]==1 | ersvbf[_n-2]==1 | ersvbf[_n-3]==1) & (ersvbf[_n+1]==1 | ersvbf[_n+2]==1 | ersvbf[_n+3]==1)
*
quietly replace ersvutpfn=ersvutpfn[_n-1] if ersvutpf[_n]==1 & ersvutpf[_n-1]>0 & ersvutpf[_n-2]>0 & ersvutpf[_n-3]>0 & fersvutpfn==.
quietly replace ersvutpfn=ersvutpfn[_n-1] if ersvutpf[_n]>1 & (ersvutpf[_n-1]==1 | ersvutpf[_n-2]==1 | ersvutpf[_n-3]==1) & (ersvutpf[_n+1]==1 | ersvutpf[_n+2]==1 | ersvutpf[_n+3]==1)
*
}
*
quietly gen flrsvafn=ersvafn*10+1 if fersvafn==1
quietly replace flrsvafn=ersvafn*10+2 if lersvafn==1
*
quietly gen flrsvbfn=ersvbfn*10+1 if fersvbfn==1
quietly replace flrsvbfn=ersvbfn*10+2 if lersvbfn==1
*
quietly gen flrsvutpfn=ersvutpfn*10+1 if fersvutpfn==1
quietly replace flrsvutpfn=ersvutpfn*10+2 if lersvutpfn==1
*
quietly save "EpisSimFinal.dta", replace
quietly clear
quietly use "EpisMasterFinal.dta"
quietly append using "EpisSimFinal.dta"
quietly save "EpisMasterFinal.dta", replace
quietly clear
}
*
use "EpisMasterFinal.dta", clear
*
replace ersvafn=. if ersvaf>1
replace ersvbfn=. if ersvbf>1
replace ersvutpfn=. if ersvutpf>1
*
save "EpisMasterFinal.dta", replace
*
rename fersvafn frsvafn
rename fersvbfn frsvbfn
rename fersvutpfn frsvutpfn
*
rename lersvafn lrsvafn
rename lersvbfn lrsvbfn
rename lersvutpfn lrsvutpfn
*
keep fuid ersvaf-ersvutpf frsvafn-lrsvutpfn ersvafn-flrsvutpfn
*
save "EpisMasterFinalMerge.dta", replace
clear
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear
merge 1:1 fuid using "EpisMasterFinalMerge.dta"
drop _merge
save "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", replace

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
*Small font*
capture plotmatrix, m(A17epf) split(1 2 3 4 5) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV A" 4 "RSV B" 5 "RSV A,B" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2017 - Episode Final - SF.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2017 - Episode Final - SF.pdf", as(pdf) replace  
*Large font*
capture plotmatrix, m(A17epf) split(1 2 3 4 5) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange) ylabel(, nolabel notick) xlabel(, labsize(3)) maxt(20) ///
xtitle("Follow-up visit", size(4)) ytitle("Study participants", size(4)) ///
legend(order(3 "RSV A" 4 "RSV B" 5 "RSV A,B" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2017 - Episode Final - LF.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2017 - Episode Final - LF.pdf", as(pdf) replace  
*
*Klerksdorp - 2017
*Small font*
capture plotmatrix, m(K17epf) split(1 2 3 4 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV A" 4 "RSV B" 5 "RSV subgroup not determined" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Episode Final - SF.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Episode Final - SF.pdf", as(pdf) replace  
*Large font*
capture plotmatrix, m(K17epf) split(1 2 3 4 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 yellow) ylabel(, nolabel notick) xlabel(, labsize(3)) maxt(20) ///
xtitle("Follow-up visit", size(4)) ytitle("Study participants", size(4)) ///
legend(order(3 "RSV type A" 4 "RSV type B" 5 "RSV subgroup not determined" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Episode Final - LF.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2017 - Episode Final - LF.pdf", as(pdf) replace  
*
*Agincourt - 2018
*Small font*
capture plotmatrix, m(A18epf) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV A" 4 "RSV B" 5 "RSV A,B" 6 "RSV subgroup not determined" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2018 - Episode Final - SF.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2018 - Episode Final - SF.pdf", as(pdf) replace 
*large font*
capture plotmatrix, m(A18epf) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(3)) maxt(20) ///
xtitle("Follow-up visit", size(4)) ytitle("Study participants", size(4)) ///
legend(order(3 "RSV A" 4 "RSV B" 5 "RSV A,B" 6 "RSV subgroup not determined" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2018 - Episode Final - LF.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Agincourt 2018 - Episode Final - LF.pdf", as(pdf) replace 
*
*Klerksdorp - 2018
*Small font*
capture plotmatrix, m(K18epf) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(1.2)) maxt(60) ///
xtitle("Follow-up visit", size(2)) ytitle("Study participants", size(2)) ///
legend(order(3 "RSV A" 4 "RSV B" 5 "RSV A,B" 6 "RSV subgroup not determined" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Episode Final - SF.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Episode Final - SF.pdf", as(pdf) replace 
*Large font*
capture plotmatrix, m(K18epf) split(1 2 3 4 5 6) allcolors(gray*0.5 gray*0.1 cranberry green*0.7 orange yellow) ylabel(, nolabel notick) xlabel(, labsize(3)) maxt(20) ///
xtitle("Follow-up visit", size(4)) ytitle("Study participants", size(4)) ///
legend(order(3 "RSV A" 4 "RSV B" 5 "RSV A,B" 6 "RSV subgroup not determined" 1 "RSV negative" 2 "No sample/results") size(1.5) rows(1) symysize(2) symxsize(3) region(lcolor(white)) position(6)) ///
xsc(titlegap(*3))
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Episode Final - LF.tif", as(tif) width(1600) height(1200) replace
graph export "4.PHIRST - Mosaic - RSV - Klerksdorp 2018 - Episode Final - LF.pdf", as(pdf) replace 

clear
