clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 
*cd "C:\Users\cherylc\Documents\PHIRST 2019_2020\RSV analysis\"
capture log close
qui: log using "PHIRST - Results - RSV - 2017-2018 - Summary Statistics.smcl", replace

***********************************
***********************************
*PHIRST: RSV - Summary Statistics**
***********************************
***********************************

qui log off

use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear

gen total1=1 if rsv<90
bysort indid: egen totfu1=total(total)
bysort indid: egen totvis1=total(1)
gen percfu=totfu/totvis*100
*
replace rsv=0 if rsv==80
replace rsv=. if rsv==90
*
gen rsvab=1 if ersvafn==1 & ersvbfn==1
*
keep year siteid hhid indid fuid funum rsv ersvafn ersvbfn ersvutpfn rsvab percfu
*
collapse (max) rsv ersvafn ersvbfn ersvutpfn rsvab (mean) percfu, by(year siteid hhid indid)
order year siteid hhid indid rsv ersvafn ersvbfn ersvutpfn rsvab percfu
*
foreach var of varlist ersvafn-rsvab {
quietly replace `var'=0 if `var'==.
}

*Generate variables*
*
*Total episodes by individual*
*
*Double counting coinfection*
gen etotall=ersvafn+ersvbfn+ersvutpfn
*
*Not double counting coinfection*
gen etotmix=ersvafn+ersvbfn+ersvutpfn-rsvab
*
*Total number of episodes*
*
*Double counting coinfection*
egen toteall=total(etotall)
*
*Not double counting coinfection*
egen totemix=total(etotmix)
*
*Episodes combination*
*
*Double counting coinfection*
gen ecomball=1 if ersvafn>0
replace ecomball=2 if ersvbfn>0
replace ecomball=3 if ersvafn>0 & ersvbfn>0
replace ecomball=4 if ersvutpfn>0
replace ecomball=5 if ersvafn>0 & ersvutpfn>0
replace ecomball=6 if ersvbfn>0 & ersvutpfn>0
replace ecomball=7 if ersvafn>0 & ersvbfn>0 & ersvutpfn>0
replace ecomball=0 if ecomball==.
label define ecomball 0 "Neg" 1 "A" 2 "B" 3 "A/B" 4 "Untyped" 5 "A/Untyped" 6 "B/Untyped" 7 "A/B/Untyped"
label values ecomball ecomball
sort indid, stable
tab ecomball if ecomball>0
tab ecomball if etotall>1
tab ecomball etotall if etotall>1
sort ecomball
list ecomball ersvafn ersvbfn ersvutpfn etotall if etotall>1
*
save "EpisCombAll.dta", replace
*
*Not double counting coinfection*
replace ersvafn=0 if rsvab==1
replace ersvbfn=0 if rsvab==1
gen ecombmix=1 if ersvafn>0
replace ecombmix=2 if ersvbfn>0
replace ecombmix=3 if rsvab>0
replace ecombmix=4 if ersvafn>0 & ersvbfn>0
replace ecombmix=5 if ersvutpfn>0
replace ecombmix=6 if ersvafn>0 & ersvutpfn>0
replace ecombmix=7 if ersvbfn>0 & ersvutpfn>0
replace ecombmix=8 if ersvafn>0 & ersvbfn>0 & ersvutpfn>0
replace ecombmix=9 if rsvab & ersvutpfn>0
replace ecombmix=0 if ecombmix==.
label define ecombmix 0 "Neg" 1 "A" 2 "B" 3 "A,B" 4 "A/B" 5 "Untyped" 6 "A/Untyped" 7 "B/Untyped" 8 "A/B/Untyped" 9 "A,B/Untyped"
label values ecombmix ecombmix
sort indid, stable
tab ecombmix if ecombmix>0
tab ecombmix if etotmix>1
tab ecombmix etotmix if etotmix>1
sort ecombmix
list ecombmix ersvafn ersvbfn rsvab ersvutpfn etotmix if etotmix>1
*
save "EpisCombMix.dta", replace
keep indid ecombmix
save "EComMixID.dta", replace
use "EpisCombAll.dta", clear
merge 1:1 indid using "EComMixID.dta"
drop _merge

*Generate variables for at least 1 episode of infection by type*
gen rsvaepis=0
replace rsvaepis=1 if ersvafn>0 & ersvafn!=.
gen rsvbepis=0
replace rsvbepis=1 if ersvbfn>0 & ersvbfn!=.
gen rsvutpepis=0
replace rsvutpepis=1 if ersvutpfn>0 & ersvutpfn!=.

*Generate heirarchical variable for seasonal breakdown*
gen type=0
replace type=1 if ersvutpfn>0 & type<1
replace type=2 if ersvafn>0 & type<2
replace type=3 if ersvbfn>0 & type<3
label define type 0 "Negative" 1 "Untyped" 2 "A" 3 "B" 
label values type type

*Generate non heirarchichal variable for season breakdown*
gen type1=0
replace type1=1 if (ersvafn>0 | ersvbfn>0 | ersvutpfn>0)
replace type1=2 if ersvafn>0 & (ersvbfn<1 & ersvutpfn<1)
replace type1=3 if ersvbfn>0 & (ersvafn<1 & ersvutpfn<1)
replace type1=4 if ersvutpfn>0 & (ersvafn<1 & ersvbfn<1)
label define type1 0 "Negative" 1 "Mixed" 2 "A" 3 "B" 4 "Untyped" 
label values type1 type1
tab type type1
tab type if type>0
tab type1 if type1>0

*Merge in masterlist
gen ind_id=indid
merge 1:1 ind_id using "PHIRST - Data - Individual and HH-Level 2016-2018.dta" 
keep if _merge==3
drop _merge

qui log on

********************
*Seasonal breakdown*
********************

*Heirarchical variable for seasonal breakdown*
tab type if type>0
bysort year site: tab type if type>0
bysort year : tab type if  type>0
bysort site: tab type if type>0

*Non-heirarchical variable for seasonal breakdown*
tab type1 if type1>0
bysort year site: tab type1 if type1>0
bysort year : tab type1 if  type1>0
bysort site: tab type1 if type1>0


**********************************************
*Community attack rate and number of episodes*
**********************************************

*Number of participants*

*By year and site*
bysort year siteid: sum year // *Obs is number of participants*
*By year*
bysort year: sum year // *Obs is number of participants*
*By site*
bysort siteid: sum year // *Obs is number of participants*
*Total*
sum year // *Obs is number of participants*

*Follow up rate*

*By year and site*
bysort year siteid: sum percfu
*By year*
bysort year: sum percfu
*By site*
bysort siteid: sum percfu
*Total*
sum percfu

***********************
*Community attack rate*
***********************

*By year and site*
bysort year: tab siteid rsv, row
*By year*
tab year rsv, row
*By site*
tab siteid rsv, row
*Total*
tab rsv
*By RSV types
tab ersvafn
tab rsvaepis
tab ersvbfn
tab rsvbepis
tab ersvutpfn
tab rsvutpepis

******************************
*Double counting coinfections*
******************************
*
*Total number of episodes*
tab toteall

*Number and combination of episodes*
tab etotall if etotall>0
tab ecomball
tab ecomball etotall
tab ecomball etotall if etotall>0, col
list indid ersvafn ersvbfn ersvutpfn if etotall==2
sort indid
list indid ersvafn ersvbfn ersvutpfn if etotall==3

*Number of individuals with more than one episode*
tab ecomball if etotall>1
tab ecomball etotall if etotall>1
sort ecomball
list ecomball ersvafn ersvbfn ersvutpfn etotall if etotall>1

*Community infection risk*
sum etotall
bysort siteid year: sum etotall
bysort agecat5: sum etotall
*

**********************************
*Not Double counting coinfections*
**********************************
*
*Total number of episodes*
tab totemix

*Number and combination of episodes*
tab etotmix if totemix>0
tab etotmix
tab etotmix totemix
tab etotmix totemix if totemix>0, col
list indid ersvafn ersvbfn ersvutpfn rsvab if totemix==2
sort indid
list indid ersvafn ersvbfn ersvutpfn rsvab if totemix==3

*Number of individuals with more than one episode*
tab etotmix if etotmix>1
tab etotmix etotmix if etotmix>1
sort etotmix
list etotmix ersvafn ersvbfn ersvutpfn rsvab etotmix if etotmix>1

tab ecombmix etotall if etotall>0, col
tab ecombmix etotmix 
tab ecombmix etotmix if etotmix>0, col
*Community infection risk*
sum etotmix
bysort siteid year: sum etotmix
bysort agecat5: sum etotmix

qui log off

save "PHIRST - Data - Lab - 2017-2018 - Individuals.dta", replace

qui log on

***************************
*Mean duration of episodes*
***************************

qui: log off

use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear

*RSV A*
drop if flrsvafn==.
keep year siteid hhid indid funum date frsvafn lrsvafn flrsvafn ersvafn
gen edur=.
*
forval i = 1/`=_N' {
quietly replace edur=date-date[_n-1] if lrsvafn==1 & frsvafn==.
}
*Single positives adjusted with uniform distribution
set seed 1111
gen unif = round(runiform(0, 6))
replace edur=unif if frsvafn==1 & lrsvafn==1
drop if edur==.
rename ersvafn epis
keep year siteid hhid indid edur epis funum
gen type=1
*
save "EpisDurRSVA.dta", replace
clear all

*RSV B*
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear
drop if flrsvbfn==.
keep year siteid hhid indid funum date frsvbfn lrsvbfn flrsvbfn ersvbfn
gen edur=.
*
forval i = 1/`=_N' {
quietly replace edur=date-date[_n-1] if lrsvbfn==1 & frsvbfn==.
}
*
set seed 1111
gen unif = round(runiform(0, 6))
replace edur=unif if frsvbfn==1 & lrsvbfn==1
drop if edur==.
rename ersvbfn epis
keep year siteid hhid indid edur epis funum
gen type=2
*
save "EpisDurRSVB.dta", replace
clear all

*RSV untyped*
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear
drop if flrsvutpfn==.
keep year siteid hhid indid funum date frsvutpfn lrsvutpfn flrsvutpfn ersvutpfn
gen edur=.
*
forval i = 1/`=_N' {
quietly replace edur=date-date[_n-1] if lrsvutpfn==1 & frsvutpfn==.
}
*
set seed 1111
gen unif = round(runiform(0, 6))
replace edur=unif if frsvutpfn==1 & lrsvutpfn==1
drop if edur==.
rename ersvutpfn epis
keep year siteid hhid indid edur epis funum
gen type=3
*
save "EpisDurRSVUtp.dta", replace
clear all

*Append types datasets*
use "EpisDurRSVA.dta", clear
append using "EpisDurRSVB.dta"
append using "EpisDurRSVUtp.dta"
label define type 1 "A" 2 "B" 3 "Untyped" 
label values type type
save "EpisDurAll", replace

qui: log on

*Mean, min. and max duration of episodes*
sum edur
*
*By type*
bysort type: sum edur
bysort type: sum edur, d

*All*
sum edur
sum edur, d
hist edur, bin(35) normal

qui log off

*Merge in baseline data*
*Merge in masterlist*
gen ind_id=indid
merge m:1 ind_id using "PHIRST - Data - Individual and HH-Level 2016-2018.dta" 
keep if _merge==3
drop _merge

*Merge in symptom data*
merge 1:1 indid epis type using "PHIRST - Data - Epi - 2017-2018 - Symptoms - Double Count Coinfections - Yes.dta"
drop _merge

**Merge in ct value data*
merge 1:1 indid epis type using "PHIRST - Data - Lab - Ct Episodes - Wide - 2017-2018 - Double Count Coinfections - Yes"
*
*Ct value
gen ctcat=1 if minct<30
replace ctcat=0 if minct>=30 & minct!=.
label define ctcat 0 ">=30" 1 "<30"
label values ctcat ctcat
tab ctcat

qui log on

*By Age*
bysort agecat5: sum edur
bysort agecat5: sum edur, d

*By sex*
bysort sex: sum edur
bysort sex: sum edur, d

*By hiv*
bysort hiv_status: sum edur
bysort hiv_status: sum edur, d

*By underill*
bysort underill: sum edur
bysort underill: sum edur, d

*By bmicat*
bysort bmicat: sum edur
bysort bmicat: sum edur, d

*By symcat*
bysort symcat: sum edur
bysort symcat: sum edur, d

*Ct value
bysort ctcat: sum edur
bysort ctcat: sum edur, d

qui: log off

save "PHIRST - Data - Lab - 2017-2018 - RF - Episode Duration.dta", replace

clear all

qui: log on

**********************
*Household level data*
**********************

qui: log off

use "PHIRST - Data - Lab - 2017-2018 - Individuals.dta", clear

gen indnum=1
gen rsvinfect=rsv
gen rsvainfect=rsvaepis
gen rsvbinfect=rsvbepis
gen rsvutpinfect=rsvutpepis

collapse (sum) indnum rsv etotall rsvaepis rsvbepis (max) rsvinfect rsvainfect rsvbinfect rsvutpinfect, by(year siteid hhid)

qui: log on

*Number of household*

*By year and site*
bysort year siteid: sum year // *Obs is number of households*
*By year*
bysort year: sum year // *Obs is number of households*
*By site*
bysort siteid: sum year // *Obs is number of households*
*Total*
sum year // *Obs is number of households*

*Number of participants per household*

*By year and site*
bysort year siteid: sum indnum 
*By year*
bysort year: sum indnum 
*By site*
bysort siteid: sum indnum 
*Total*
sum indnum

*Number of household with at least one infected individual*
*All RSV
*By year and site*
bysort year siteid: tab rsvinfec
*By year*
bysort year: tab rsvinfec 
*By site*
bysort siteid: tab rsvinfec
*Total*
tab rsvinfec
*By RSV types*
*Total*
tab rsvainfect
tab rsvbinfect
tab rsvutpinfect 

*Number of infected households with only one infected individual*

*By year and site*
bysort year siteid: tab rsv if rsv>0
*By year*
bysort year: tab rsv if rsv>0
*By site*
bysort siteid: tab rsv if rsv>0
*Total*
tab rsv if rsv>0

*Mean and range of infected individuals per infected household*
*By year and site*
bysort year siteid: sum rsv if rsv>0
*By year*
bysort year: sum rsv if rsv>0
*By site*
bysort siteid: sum rsv if rsv>0
*Total*
sum rsv if rsv>0

*Mean and range of RSV episodes per infected household*
*By year and site*
bysort year siteid: sum etotall if rsv>0
*By year*
bysort year: sum etotall if rsv>0
*By site*
bysort siteid: sum etotall if rsv>0
*Total*
sum etotall if rsv>0

qui: log off

save "PHIRST - Data - Lab - 2017-2018 - Household.dta", replace

qui: log on

********************
*Number of clusters*
********************

qui: log off

use "PHIRST - Data - Lab - 2017-2018 - Clusters.dta", clear 

keep year siteid hhid crsvaf crsvbf crsvutpf clusf
*
collapse (max) crsvaf crsvbf crsvutpf clusf, by(year siteid hhid)
*
foreach var of varlist crsvaf-crsvutpf {
quietly replace `var'=0 if `var'==.
}
*
gen crsvtf=crsvaf+crsvbf+crsvutpf

qui: log on

*Proportion of households with clusters and number of clusters per household*
*
*RSV A*
tab crsvaf
tab crsvaf if crsvaf>0
sum crsvaf if crsvaf>0
*
*RSV B*
tab crsvbf
tab crsvbf if crsvbf>0
sum crsvbf if crsvbf>0
*
*RSV untyped*
tab crsvutpf
tab crsvutpf if crsvutpf>0
sum crsvutpf if crsvutpf>0
*
*RSV Total*
tab crsvtf
tab crsvtf if crsvtf>0
sum crsvtf if crsvtf>0

*Total number of clusters*
*
egen totc=total(crsvtf)
tab totc
*
*Average number of clusters per infected household
*By year/site*
bysort year siteid: sum crsvtf if crsvtf>0
bysort year : sum crsvtf if crsvtf>0
bysort siteid: sum crsvtf if crsvtf>0
*Total*
sum crsvtf if crsvtf>0
sum crsvaf if crsvaf>0 
sum crsvbf if crsvbf>0 
sum crsvutpf if crsvutpf>0 


******************
*Cluster duration*
******************

qui: log off

*RSV A*
use "PHIRST - Data - Lab - 2017-2018 - Index (Wide).dta", clear
gen rsvad=.
forval i = 1/20 {
quietly replace rsvad=date`i' if ersvai`i'==2
quietly replace rsvad=date`i' if ersval`i'==3
}
*
drop if flrsvaf==.
keep hhid funum rsvad frsvaf lrsvaf flrsvaf crsvaf
gen cdur=.
*
forval i = 1/`=_N' {
quietly replace cdur=rsvad-rsvad[_n-1] if lrsvaf==1 & frsvaf==.
}
*Correct cdur to edur for single positives in single person clusters*
merge 1:m hhid funum using "C:\Users\jackiel\Desktop\RSV 20231005\EpisDurRSVA.dta", keepusing(edur)
drop if _merge==2
replace cdur = edur if frsvaf==1 & lrsvaf==1
drop edur _merge
gsort hhid funum -cdur
duplicates drop hhid funum, force
drop if cdur==.
keep hhid funum cdur crsvaf
gen type=1
*
save "ClusDurRSVA.dta", replace
clear all
*
*RSV B*
use "PHIRST - Data - Lab - 2017-2018 - Index (Wide).dta", clear
sort hhid funum, stable
gen rsvbd=.
forval i = 1/20 {
quietly replace rsvbd=date`i' if ersvbi`i'==2
quietly replace rsvbd=date`i' if ersvbl`i'==3
}
*
drop if flrsvbf==.
keep hhid funum rsvbd frsvbf lrsvbf flrsvbf crsvbf
gen cdur=.
*
forval i = 1/`=_N' {
quietly replace cdur=rsvbd-rsvbd[_n-1] if lrsvbf==1 & frsvbf==.
}
*
*Correct cdur to edur for single positives in single person clusters*
merge 1:m hhid funum using "C:\Users\jackiel\Desktop\RSV 20231005\EpisDurRSVB.dta", keepusing(edur)
drop if _merge==2
replace cdur = edur if frsvbf==1 & lrsvbf==1
drop edur _merge
gsort hhid funum -cdur
duplicates drop hhid funum, force
drop if cdur==.
keep hhid funum cdur crsvbf
gen type=2
*
save "ClusDurRSVB.dta", replace
clear all
*
*RSV untyped*
use "PHIRST - Data - Lab - 2017-2018 - Index (Wide).dta", clear
sort hhid funum, stable
gen rsvutpd=.
forval i = 1/20 {
quietly replace rsvutpd=date`i' if ersvutpi`i'==2
quietly replace rsvutpd=date`i' if ersvutpl`i'==3
}
*
drop if flrsvutpf==.
keep hhid funum rsvutpd frsvutpf lrsvutpf flrsvutpf crsvutpf
gen cdur=.
*
forval i = 1/`=_N' {
quietly replace cdur=rsvutpd-rsvutpd[_n-1] if lrsvutpf==1 & frsvutpf==.
}
*
*Correct cdur to edur for single positives in single person clusters*
merge 1:m hhid funum using "C:\Users\jackiel\Desktop\RSV 20231005\EpisDurRSVUtp.dta", keepusing(edur)
drop if _merge==2
replace cdur = edur if frsvutpf==1 & lrsvutpf==1
drop edur _merge
gsort hhid funum -cdur
duplicates drop hhid funum, force
drop if cdur==.
keep hhid funum cdur crsvutpf
gen type=3
*
save "ClusDurRSVUtp.dta", replace
clear all
*
*Append types datasets*
use "ClusDurRSVA.dta", clear
append using "ClusDurRSVB.dta"
append using "ClusDurRSVUtp.dta"
label define type 1 "A" 2 "B" 3 "Untyped"
label values type type
order hhid funum cdur type crsvaf crsvbf crsvutpf
save "ClusDurAll", replace

qui: log on

*Mean, min. and max duration of ALL clusters*
*
*By type*
bysort type: sum cdur
bysort type: sum cdur, d
*
*All*
sum cdur
sum cdur, d
hist cdur, bin(35) normal

*Mean, min. and max duration of clusters*
*
*By type*
bysort type: sum cdur
bysort type: sum cdur, d
*
*All*
sum cdur
sum cdur, d
hist cdur, bin(35) normal


qui: log off

save "PHIRST - Data - Lab - 2017-2018 - Cluster Duration.dta", replace

use "PHIRST - Data - Lab - 2017-2018 - HCIR.dta", clear

qui: log on


**************************************************************************
*HCIR and proportion of community vs. household acquired infections - All*
**************************************************************************

*NOTE: Not reported in manuscript, manuscript limits to generation interval <17 days
		*See HCIR RF do file

*By type*
bysort type: tab ixnix if ixnix<2
bysort type: tab ixnix if ixnix>0

*All*
tab ixnix if ixnix<2
tab ixnix if ixnix>0


*************************
*HCIR - Only susceptible*
*************************

*By type*
bysort type: tab ixnix if ixnix<2 & sus==1

*All*
tab ixnix if ixnix<2 & sus==1

**********************************
*Infected individuals per cluster*
**********************************

*By year/site*
collapse (sum) epis, by (year type site hhid clus)
bysort year site: sum epis
bysort year : sum epis
bysort site: sum epis
sum epis

*By type*
bysort  type: sum epi
sum epis

***********************************************************
*Number and % of cluster by number of episodes per cluster*
***********************************************************

tab epis

**********************
*Symptomatic Fraction*
**********************

qui: log off

use "PHIRST - Data - Epi - 2017-2018 - Symptoms - Double Count Coinfections - Yes.dta", clear
gen ind_id=indid

*Merge in masterlist
merge m:1 ind_id using "PHIRST - Data - Individual and HH-Level 2016-2018.dta" 
keep if _merge==3
drop _merge

qui: log on

*Symptomatic fraction*

*By year*
bysort year: tab symany

*All*
tab symany

*By type*
bysort type: tab symany

*By age*
tab  agecat5 symany, row chi

*Number of symptoms among symptomatic individuals*

*All and by age*
tab symcat if symcat>0
tab agecat5 symcat if symcat>0, row chi
*
tab symili if symili>0
tab agecat5 symili if symili>0, row chi

*By type*
bysort type: tab symcat if symcat>0 
bysort type: tab symili if symili>0 

*Proportion of ILI among individuals with 2+ symptoms*

*All*
tab symili if symili>1

*By types*
bysort type: tab symili if symili>1


***********************
*Missed school or work*
***********************

*By symptom*
tab symcat missed, row chi
tab symili missed, row chi

*By type*
tab type missed, row chi


*******************
*Outpatient visits*
*******************

*By symptom - all*
tab symcat outvisit if symcat>0, row chi
tab symili outvisit if symili>0, row chi

*By symptom and age*
bysort agecat5: tab symcat outvisit if symcat>0, row chi
bysort agecat5: tab symili outvisit if symili>0, row chi

*By type*
tab type outvisit if symcat>0, row chi

qui: log close

view "PHIRST - Results - RSV - 2017-2018 - Summary Statistics.smcl"
