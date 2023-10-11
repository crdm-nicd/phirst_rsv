***********************************
***********************************
* PHIRST: RSV HCIR & SI - Analysis*
***********************************
***********************************

clear all
set more off

* Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 

*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - Index (Wide).dta", clear 

*Reshape long and define variables*
*
keep year-funum ersvai* ersvbi* ersvutpi* ersvaf* ersvbf* ersvutpf* rsvtpep* crsvaf crsvbf crsvutpf coprrsva coprrsvb coprrsvutp
reshape long ersvai ersvbi ersvutpi ersvaf ersvbf ersvutpf rsvtpep, i(hhid funum) j(indidnum)
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
merge m:m indid using "FuID.dta"
*
keep if _merge==3
drop _merge
order year siteid hhid indid fuid indidnum funum
sort year siteid hhid indid funum, stable
*
merge 1:1 fuid using "FuIDEpis.dta"
drop _merge
*
merge 1:1 fuid using "EpisMasterFinalMerge.dta"
drop _merge
*
tab rsvtpep
*
foreach var of varlist ersvai-ersvutpi ersvaf-ersvutpf {
quietly replace `var'=0 if `var'==80
quietly replace `var'=. if `var'==90
}
*
save "PHIRST - Data - Lab - 2017-2018 - Index (Long).dta", replace


********************************************************************************************
*Generate dataset with index cases and infected and uninfected household members by cluster*
********************************************************************************************

*RSV A*
keep if crsvaf!=.
collapse (max) ersvai coprrsva, by(year siteid hhid indid ersvafn crsvaf)
rename ersvafn epis
rename crsvaf clus
rename ersvai ixnix
rename coprrsva copr
bysort clus indid: egen ind=max(epis)
drop if epis==. & ind!=.
gen type=1
bysort type hhid clus: egen copr1=max(copr)
drop copr
rename copr1 copr
tab ixnix if ixnix<2
tab ixnix if ixnix>0
save "IndexClusRSVA.dta", replace
clear
*
*RSV B*
use "PHIRST - Data - Lab - 2017-2018 - Index (Long).dta", clear
keep if crsvbf!=.
collapse (max) ersvbi coprrsvb, by(year siteid hhid indid ersvbfn crsvbf)
rename ersvbfn epis
rename crsvbf clus
rename ersvbi ixnix
rename coprrsvb copr
bysort clus indid: egen ind=max(epis)
drop if epis==. & ind!=.
gen type=2
bysort type hhid clus: egen copr1=max(copr)
drop copr
rename copr1 copr
tab ixnix if ixnix<2
tab ixnix if ixnix>0
save "IndexClusRSVB.dta", replace
clear
*
*RSV untyped*
use "PHIRST - Data - Lab - 2017-2018 - Index (Long).dta", clear
keep if crsvutpf!=.
collapse (max) ersvutpi coprrsvutp, by(year siteid hhid indid ersvutpfn crsvutpf)
rename ersvutpfn epis
rename crsvutpf clus
rename ersvutpi ixnix
rename coprrsvutp copr
bysort clus indid: egen ind=max(epis)
drop if epis==. & ind!=.
gen type=3
bysort type hhid clus: egen copr1=max(copr)
drop copr
rename copr1 copr
tab ixnix if ixnix<2
tab ixnix if ixnix>0
save "IndexClusRSVUtp.dta", replace
clear
*
*Append subtypes/lineages datasets*
use "IndexClusRSVA.dta", clear
append using "IndexClusRSVB.dta"
append using "IndexClusRSVUtp.dta"
label define type 1 "A" 2 "B" 3 "Untyped"
label values type type
order year siteid hhid indid type clus ixnix
save "IndexClusAll", replace
tab ixnix if ixnix<2
tab ixnix if ixnix>0


***************************************************************************************************************
*Exclude as susceptible individuals that were infected by the same RSV type during previous household clusters*
***************************************************************************************************************

gen sus=.
sort year type indid clus epis, stable
*
forval i = 1/`=_N' {
quietly replace sus=1 if clus==2 & (ixnix[_n-1]==0 | ixnix[_n-1]==.)
quietly replace sus=1 if clus==3 & (ixnix[_n-1]==0 | ixnix[_n-1]==.) & sus[_n-1]==1
}
replace sus=1 if ixnix==1 | ixnix==2
replace sus=1 if clus==1
*
sort year type siteid hhid indid clus epis, stable

save "PHIRST - Data - Lab - 2017-2018 - HCIR.dta", replace


**************************************
*Obtain dataset for HCIR risk factors*
**************************************

gsort type hhid clus-ixnix
gen ixindid=indid if ixnix==2 & copr==1
gen ixepis=epis if ixnix==2 & copr==1
*
forval i = 1/`=_N' {
quietly replace ixindid=ixindid[_n-1] if ixindid=="" & copr==1
quietly replace ixepis=ixepis[_n-1] if ixepis==. & copr==1
}
*
drop if ixnix==2
rename indid hmindid
rename epis hmepis
replace hmepis=1 if hmepis>1 & hmepis<2
replace ixepis=1 if ixepis>1 & ixepis<2

save "PHIRST - Data - Lab - 2017-2018 - HCIR RF.dta", replace

clear all

************************
*Obtain Serial Interval*
************************

*Generate episode number, type and date of first positive variables*
*
*RSV A*
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear 
gen epis=ersvafn if frsvafn==1
gen type=1 if frsvafn==1
gen fdate=date if frsvafn==1
keep indid epis type fdate
drop if epis==.
save "FirstDateRSVA.dta", replace
clear
*
*RSV B*
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear 
gen epis=ersvbfn if frsvbfn==1
gen type=2 if frsvbfn==1
gen fdate=date if frsvbfn==1
keep indid epis type fdate
drop if epis==.
save "FirstDateRSVB.dta", replace
clear
*
*RSV untyped*
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear 
gen epis=ersvutpfn if frsvutpfn==1
gen type=3 if frsvutpfn==1
gen fdate=date if frsvutpfn==1
keep indid epis type fdate
drop if epis==.
save "FirstDateRSVUtp.dta", replace
clear
*
*Append subtypes/lineages datasets*
use "FirstDateRSVA.dta", clear
append using "FirstDateRSVB.dta"
append using "FirstDateRSVUtp.dta"
label define type 1 "A" 2 "B" 3 "Untyped"
label values type type
gen hmindid=indid
gen ixindid=indid
gen hmepis=epis
gen ixepis=epis
save "FirstDateAll.dta", replace
drop indid epis hmindid hmepis
save "FirstDateAllIX.dta", replace
use "FirstDateAll.dta", clear
drop indid epis ixindid ixepis
save "FirstDateAllHM.dta", replace
clear
*
*Merge HCIR database with First Date Database*
*
use "PHIRST - Data - Lab - 2017-2018 - HCIR RF.dta", clear
merge m:1 hmindid type hmepis using "FirstDateAllHM.dta"
drop if _merge==2
drop _merge
rename fdate hmfdate
*
merge m:1 ixindid type ixepis using "FirstDateAllIX.dta"
drop if _merge==2
drop _merge 
rename fdate ixfdate
sort siteid year type hhid clus hmindid
*
*Obtain Serial Interval*
gen si=hmfdate-ixfdate
sum si, d
tab si
sum si if si<=10, d
hist si
hist si if si<=10
*
save "PHIRST - Data - Lab - 2017-2018 - HCIR-SI.dta", replace

