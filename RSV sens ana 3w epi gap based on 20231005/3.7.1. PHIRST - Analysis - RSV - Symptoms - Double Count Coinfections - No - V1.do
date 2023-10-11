**********************************************************************
**********************************************************************
* PHIRST: RSV Symptoms - Analysis - Do Not Double Count Co-Infections*
**********************************************************************
**********************************************************************

clear all
set more off

*Set directory*
*cd "D:\Projects Folders\AI - CDC South Africa\AI South Africa - South Africa\Manuscripts for Publication\Cheryl\PHIRST - RSV\Data\" 

*Import dataset*
use "PHIRST - Data - Lab - 2017-2018 - Episodes.dta", clear 
*
gen srsva=.
gen srsvb=.
gen srsvutp=.
*
gen rsvab=1 if ersvafn==1 & ersvbfn==1
*
save "EpisSympt.dta", replace


******************************************************
*Add one follow-up visit before and after the episode*
******************************************************

clear all

*Generate master dataset*
postfile mysim year using EpisSymptMaster, replace
postclose mysim

clear all

*LOOP 1: Subset by individual*
forval i = 1/1300 {

quietly use "EpisSympt.dta", clear
quietly keep if group==`i'
*display "Master Run: " `i'

*LOOP 2: Add one follow-up visit before and after the episode*
forval j = 1/`=_N' {
*
quietly replace srsva=1 if ersvafn[_n]==. & ersvafn[_n+1]!=. & ersvafn[_n-1]==.
quietly replace srsva=2 if ersvafn[_n]==. & ersvafn[_n-1]!=. & ersvafn[_n+1]==. 
*
quietly replace srsvb=1 if ersvbfn[_n]==. & ersvbfn[_n+1]!=. & ersvbfn[_n-1]==.
quietly replace srsvb=2 if ersvbfn[_n]==. & ersvbfn[_n-1]!=. & ersvbfn[_n+1]==. 
*
quietly replace srsvutp=1 if ersvutpfn[_n]==. & ersvutpfn[_n+1]!=. & ersvutpfn[_n-1]==.
quietly replace srsvutp=2 if ersvutpfn[_n]==. & ersvutpfn[_n-1]!=. & ersvutpfn[_n+1]==. 
}
forval k = 1/`=_N' {
*
quietly replace ersvafn=ersvafn[_n+1] if srsva==1
quietly replace ersvafn=ersvafn[_n-1] if srsva==2
*
quietly replace ersvbfn=ersvbfn[_n+1] if srsvb==1
quietly replace ersvbfn=ersvbfn[_n-1] if srsvb==2
*
quietly replace ersvutpfn=ersvutpfn[_n+1] if srsvutp==1
quietly replace ersvutpfn=ersvutpfn[_n-1] if srsvutp==2
}
*
quietly save "EpisSymptSim.dta", replace
quietly clear
quietly use "EpisSymptMaster.dta"
quietly append using "EpisSymptSim.dta"
quietly save "EpisSymptMaster.dta", replace
quietly clear
}
*

*******************
*Merge Epi dataset*
*******************

use "PHIRST - Data - Epi - 2016-2018.dta", clear
*
rename finalid fuid
rename date epidate
merge 1:1 fuid using "EpisSymptMaster.dta"
drop if _merge==1
drop _merge
*
gen period1=1 if period=="2017 Jan_May"
replace period1=2 if period=="2017 Jun_Nov"
replace period1=2 if year==2018
tab period1 period


*****************************
*Generate symptoms variables*
*****************************
*
*Fever*
destring fever10, replace
gen fever=0 if fever4a!=. | fever4b!=. | fever4c!=. | fever4d!=. | fever10!=. | fever14!=.
replace fever=1 if fever4a==1 | fever4b==1 | fever4c==1 | fever4d==1 | fever14==1 | (fever10>1 & fever10!=.)
tab fever
*
*Cough*
destring cough10, replace
destring whoopcough10, replace
gen cough=0 if cough4!=. | cough10!=. | cough14!=. | paroxysmalcough14!=.
replace cough=1 if cough4==1 | coughingfitbreath4==1 | coughingfitvomiting4==1 | cough14==1 | paroxysmalcough14==1 | (cough10>1 & cough10!=.) | (whoopcough10>1 & whoopcough10!=.)
tab cough 
*
*Sore throat
destring sorethroat10, replace
gen sorethroat=0 if sorethroat4!=. | sorethroat10!=. | sorethroat14!=.
replace sorethroat=1 if sorethroat4==1 | (sorethroat10>1 & sorethroat10!=.) | sorethroat14==1 
tab sorethroat
*
*Myalgia*
destring muscleache10, replace
gen muscleache=0 if muscleache4!=. | muscleache10!=. | muscleache14!=.
replace muscleache=1 if muscleache4==1 | (muscleache10>1 & muscleache10!=.) | muscleache14==1 
tab muscleache 
*
*Diarrhoea*
gen diarrhoea=0 if diarrhoea4!=. | diarrhoea14!=.
replace diarrhoea=1 if diarrhoea4==1 | diarrhoea14==1 
tab diarrhoea 
*
*Rhinorrhoea*
destring runnynose10, replace
destring blockednose10, replace
gen runnynose=0 if runnynose4!=. | runnynose10!=. | runnynose14!=. | blockednose10!=.
replace runnynose=1 if runnynose4==1 | (runnynose10>1 & runnynose10!=.) | runnynose14==1 | (blockednose10>1 & blockednose10!=.) 
tab runnynose 
*
*Difficulty breathing*
replace difficultybreathing10="1" if difficultybreathing10=="Absent"
replace difficultybreathing10="2" if difficultybreathing10=="Mild"
replace difficultybreathing10="3" if difficultybreathing10=="Moderate"
replace difficultybreathing10="4" if difficultybreathing10=="Severe"
destring difficultybreathing10, replace
gen difficultybreathing=0 if difficultybreathing4!=. |  difficultybreathing10!=. |difficultybreathing14!=.
replace difficultybreathing=1 if difficultybreathing4==1 & period1==3
replace difficultybreathing=1 if difficultybreathing4>1 & difficultybreathing4!=. & period1!=3 
replace difficultybreathing=1 if (difficultybreathing10>1 & difficultybreathing10!=.)
replace difficultybreathing=1 if difficultybreathing14==1
gen diffbreath=0 if fever!=.
replace diffbreath=1 if difficultybreathing==1
drop difficultybreathing
tab diffbreath
*
*Chest pain*
gen chestpain1=0 if chestpain4!=. | chestpain14!=.
replace chestpain1=1 if chestpain4==1 & period1==3
replace chestpain1=1 if chestpain4>1 & chestpain4!=. & period1!=3 
gen chestpain=0 if fever!=.
replace chestpain=1 if chestpain1==1
drop chestpain1
tab chestpain
*
*Vomiting*
gen vomiting1=0 if vomiting4!=. | vomiting14!=.
replace vomiting1=1 if vomiting4==1 & period1==3
replace vomiting1=1 if vomiting4>1 & vomiting4!=. & period1!=3 
gen vomiting=0 if fever!=.
replace vomiting=1 if vomiting1==1
drop vomiting1
tab vomiting
*
*Headache
gen headache1=0 if headache4!=. | headache14!=.
replace headache1=1 if headache4==1 & period1==3
replace headache1=1 if headache4>1 & headache4!=. & period1!=3 
gen headache=0 if fever!=.
replace headache=1 if headache1==1
drop headache1
tab headache
*
*Coughing fit (breath) 
gen coughingfitbreath1=0 if coughingfitbreath4!=.
replace coughingfitbreath1=1 if coughingfitbreath4==1 & period1==3
replace coughingfitbreath1=1 if coughingfitbreath4>1 & period1!=3 & coughingfitbreath4!=.
gen coughingfitbreath=0 if fever!=.
replace coughingfitbreath=1 if coughingfitbreath1==1
drop coughingfitbreath1
tab coughingfitbreath
*
*Coughing fit (vomit) 
gen coughingfitvomiting1=0 if coughingfitvomiting4!=.
replace coughingfitvomiting1=1 if coughingfitvomiting4==1
gen coughingfitvomiting=0 if fever!=. & period1==3
replace coughingfitvomiting=1 if coughingfitvomiting1==1 & period1==3
drop coughingfitvomiting1
tab coughingfitvomiting
*
*Other symptoms
destring sneezing10, replace
destring wheezing10, replace
destring apnea10, replace
destring whoopcough10, replace
destring nightsweats10, replace
destring earache10, replace
destring burnmicturition10, replace
destring vaginaldis_charge10, replace
destring abscess10, replace
gen othersymptomlist4e="Sneezing" if sneezing10>1 & sneezing10!=.
replace othersymptomlist4e="Wheezing" if wheezing10>1 & wheezing10!=.
replace othersymptomlist4e="Apnea" if apnea10>1 & apnea10!=.
replace othersymptomlist4e="Whoop cough" if whoopcough10>1 & whoopcough10!=.
replace othersymptomlist4e="Nightsweats" if nightsweats10>1 & nightsweats10!=.
replace othersymptomlist4e="Earache" if earache10>1 & earache10!=.
replace othersymptomlist4e="Burn micturition" if burnmicturition10>1 & burnmicturition10!=.
replace othersymptomlist4e="Vaginal Discharge" if vaginaldis_charge10>1 & vaginaldis_charge10!=.
replace othersymptomlist4e="Abscess" if abscess10>1 & abscess10!=.
*
gen othersymptom=0 if othersymptoms4!=.
replace othersymptom=0 if sneezing10!=.
replace othersymptom=0 if wheezing10!=.
replace othersymptom=0 if apnea10!=.
replace othersymptom=0 if whoopcough10!=.
replace othersymptom=0 if nightsweats10!=.
replace othersymptom=0 if earache10!=.
replace othersymptom=0 if burnmicturition10!=.
replace othersymptom=0 if vaginaldis_charge10!=.
replace othersymptom=0 if abscess10!=.
*
replace othersymptom=1 if othersymptoms4==1
replace othersymptom=1 if sneezing10>1 & sneezing10!=.
replace othersymptom=1 if wheezing10>1 & wheezing10!=.
replace othersymptom=1 if apnea10>1 & apnea10!=.
replace othersymptom=1 if whoopcough10>1 & whoopcough10!=.
replace othersymptom=1 if nightsweats10>1 & nightsweats10!=.
replace othersymptom=1 if earache10>1 & earache10!=.
replace othersymptom=1 if burnmicturition10>1 & burnmicturition10!=.
replace othersymptom=1 if vaginaldis_charge10>1 & vaginaldis_charge10!=.
replace othersymptom=1 if abscess10>1 & abscess10!=.
replace othersymptom=1 if othersymptomlist4e!=""
tab othersymptom
*
*Missed school or work*
generate missed=0 if missedschoolwork4==2
replace missed=1 if missedschoolwork4==3 | missedschoolwork4==4
label define missed 0 "Did not miss" 1 "Have missed"
label values missed missed
tab missed
*
*Outpatient visits*
destring outpatientvisited4a, replace
destring outpatientvisit4a, replace
destring outpatientvisit4b, replace
destring outpatientvisit4c, replace
destring outpatientvisit4d, replace
destring outpatientvisited4b, replace
destring outpatientvisited4c, replace
destring outpatientvisited4d, replace
destring privatedrclinic10, replace
destring publicclinic, replace
destring privatehospital10, replace
destring privatedrclinic10, replace
destring healthprovidervisited11, replace
destring hospitaloutpatient11, replace
gen outvisit=0 if outpatientvisited4a!=. |  outpatientvisit4a!=. | outpatientvisit4b!=.  |  outpatientvisit4c!=. |  outpatientvisit4d!=. | outpatientvisited4b!=.  |  outpatientvisited4c!=. |  outpatientvisited4d!=.
replace outvisit=1 if outpatientvisited4a==1 | outpatientvisited4b==1  | outpatientvisited4c==1  | outpatientvisited4d==1  | outpatientvisit4a==1 | outpatientvisit4b==1 | outpatientvisit4c==1 | outpatientvisit4d==1
replace outvisit=1 if privatedrclinic10==1 | publicclinic==1 | privatehospital10==1 | privatedrclinic10==1 | healthprovidervisited11==3 | healthprovidervisited11==4 | hospitaloutpatient11==1
tab outvisit
*
*Hospitalization*
gen hospitalised=0 if hospitalsincelastvisit4a!=.
replace hospitalised=1 if  hospitalsincelastvisit4a==1|hospitalsincelastvisit4b==1|hospitalsincelastvisit4c==1|hospitalsincelastvisit4d==1
replace hospitalised=1 if hospitalised4b==1|hospitalised4c==1|hospitalised4d==1
tab hospitalized

save "EpisSymptMaster.dta", replace


******************************************************
*Generate dataset with indivudual symptoms by episode*
******************************************************

*RSV A*
keep if ersvafn!=.
collapse (max) fever cough sorethroat muscleache diarrhoea runnynose diffbreath chestpain vomiting headache coughingfitbreath coughingfitvomiting othersymptom missed outvisit hospitalised rsvab, by(year siteid hhid indid ersvafn)
rename ersvafn epis
gen type=1
replace type=3 if rsvab==1
drop rsvab
save "EpisSymptRSVA.dta", replace
clear

*RSV B*
use "EpisSymptMaster.dta", clear
keep if ersvbfn!=.
collapse (max) fever cough sorethroat muscleache diarrhoea runnynose diffbreath chestpain vomiting headache coughingfitbreath coughingfitvomiting othersymptom missed outvisit hospitalised rsvab, by(year siteid hhid indid ersvbfn)
rename ersvbfn epis
gen type=2
drop if rsvab==1
drop rsvab
save "EpisSymptRSVB.dta", replace
clear

*RSV untyped*
use "EpisSymptMaster.dta", clear
keep if ersvutpfn!=.
collapse (max) fever cough sorethroat muscleache diarrhoea runnynose diffbreath chestpain vomiting headache coughingfitbreath coughingfitvomiting othersymptom missed outvisit hospitalised, by(year siteid hhid indid ersvutpfn)
rename ersvutpfn epis
gen type=4
save "EpisSymptRSVUtp.dta", replace
clear

*
*Append subtypes/lineages datasets*
use "EpisSymptRSVA.dta", clear
append using "EpisSymptRSVB.dta"
append using "EpisSymptRSVUtp.dta"
label define type 1 "A" 2 "B" 3 "A,B" 4 "Untyped"
label values type type
order year siteid hhid indid type epis 
*
foreach var of varlist fever-othersymptom {
quietly replace `var'=0 if `var'==.
} 
*
*Generate cobined symptoms variables"
*
*Any symptom*
gen symany=.
foreach var of varlist fever-othersymptom {
quietly replace symany=1 if `var'==1
}
replace symany=0 if symany==.
label define symany 0 "No" 1 "Yes"
label values symany symany
*
*Number of symptoms*
gen symnum=fever+cough+sorethroat+muscleache+diarrhoea+runnynose+diffbreath+chestpain+vomiting+headache+coughingfitbreath+coughingfitvomiting+othersymptom
*
*Symtmoms: 0, 1, >=2*
gen symcat=symnum
replace symcat=2 if symcat>1
label define symcat 0 "0" 1 "1" 2 "2+"
label values symcat symcat
*
*Symptoms/ILI*
gen symili=symcat
replace symili=3 if fever==1 & cough==1
label define symili 0 "0" 1 "1" 2 "2+" 3 "ILI"
label values symili symili
*
save "PHIRST - Data - Epi - 2017-2018 - Symptoms - Double Count Coinfections - No.dta", replace

tab year symany if year>2016, row
tab year symcat if year>2016, row
tab year symili if year>2016 & symili>0, row
*
tab symili missed, row
bysort year: tab symili missed, row
tab symili outvisit if symili>0 & year>2016, row
bysort year: tab symili outvisit if symili>0, row

