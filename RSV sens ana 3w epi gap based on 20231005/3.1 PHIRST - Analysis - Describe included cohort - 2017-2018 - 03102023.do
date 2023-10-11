**Household level analysis
*use "C:\Users\cherylc\Documents\Articles written\PHIRST Influenza Main Paper\Baseline characteristics\PHIRST - Data - HH-Level 2016-2018 - Variables - Short.dta", clear
use "\\appshare\crdm databases\PHIRST\Analyses\Influenza Cohen 2021 Lancet GH\Baseline characteristics\PHIRST - Data - HH-Level 2016-2018 - Variables - Short.dta", clear

***Keep households included in the influenza paper
**if using a different population amend this statement
keep if hh_inc_flu_ana==1
*****Restrict to 2017-2018
keep if year>2016
**Descriptive analysis

tab year site  , col chi
xi:logistic site i.year  , or
tab hh_size site  , col chi
xi:logistic site i.hh_size  , or

sum hh_size_master   , detail  
sum hh_size_master   if site==0, detail   
sum hh_size_master   if site==1, detail 

sum true_hh_size   , detail  
sum true_hh_size  if site==0, detail   
sum true_hh_size if  site==1, detail 

tab numroom site  , col chi
xi:logistic site i.numroom  , or

sum totalnorooms   , detail  
sum totalnorooms if  site==0, detail   
sum totalnorooms if  site==1, detail 

tab numroomsleep site  , col chi
xi:logistic site i.numroomsleep  , or
sum totalslprooms   , detail  
sum totalslprooms if site==0, detail   
sum totalslprooms if  site==1, detail 
 
tab crowding site  , col chi
xi:logistic site i.crowding  , or

tab under5children site  , col chi
xi:logistic site i.under5children  , or

 tab smokein site  , col chi
 xi:logistic site i.smokein  , or

 tab homewateravail site  , col chi
 xi:logistic site i.homewateravail  , or

 tab handwateravail site  , col chi
 xi:logistic site i.handwateravail  , or

 tab fuel site  , col chi
 xi:logistic site b1.fuel  , or
 
  tab hh_income site  , col chi
 xi:logistic site i.hh_income  , or
 
 sum S_Q50_Grav_Indoor_PM4   , detail  
sum S_Q50_Grav_Indoor_PM4 if  site==0, detail   
sum S_Q50_Grav_Indoor_PM4 if site==1, detail 
kwallis S_Q50_Grav_Indoor_PM4 , by(site)

 sum W_Q50_Grav_Indoor_PM4   , detail  
sum W_Q50_Grav_Indoor_PM4 if  site==0, detail   
sum W_Q50_Grav_Indoor_PM4 if site==1, detail 
kwallis W_Q50_Grav_Indoor_PM4 , by(site)
sum S_Q50_Temp_Indoor  , detail  
sum S_Q50_Temp_Indoor if  site==0, detail   
sum S_Q50_Temp_Indoor if  site==1, detail 
kwallis S_Q50_Temp_Indoor , by(site)
sum W_Q50_Temp_Indoor  , detail  
sum W_Q50_Temp_Indoor if  site==0, detail   
sum W_Q50_Temp_Indoor if  site==1, detail 
kwallis W_Q50_Temp_Indoor , by(site)

tab spm4 site , col chi
xi:logistic site spm4, or
tab wpm4 site , col chi
xi:logistic site wpm4, or
tab sindoortemp site , col chi
xi:logistic site i.sindoortemp, or
tab windoortemp site , col chi
xi:logistic site windoortemp, or

**Individual level analysis
*use "C:\Users\cherylc\Documents\Articles written\PHIRST Influenza Main Paper\Baseline characteristics\PHIRST Baseline characterstics individual.dta", replace
*use "C:\Users\cherylc\Documents\Articles written\PHIRST Influenza Main Paper\Baseline characteristics\PHIRST - Data - Individual and HH-Level 2016-2018.dta", replace
use "\\appshare\crdm databases\PHIRST\Analyses\Influenza Cohen 2021 Lancet GH\Baseline characteristics\PHIRST - Data - Individual and HH-Level 2016-2018.dta", replace


***************************************************************************************************************************
**descriptive analysis of the included cohort
**************************************************************************************************
**restrict to cohort included in the flu analysis
keep if ind_inc_flu_ana==1
tab year
*****Restrict to 2017-2018
keep if year>2016
tab agecat5 site    , col chi m

xi:logistic site1  b1.agecat5 

tab sex site   , col chi
xi:logistic site1 b2.sex if agecat1==1 
tab year site   , col chi
xi:logistic site1 i.year if agecat1==1 
tab educlevel site if agecat1==1, col chi
tab educlevel site if agecat1==1, col chi m
xi:logistic site1 i.educlevel if agecat1==1
xi:logistic site1 b1.educlevel if agecat1==1
tab employed site if agecat1==1, col chi m
xi:logistic site1 b0.employed if agecat1==1
tab alcohol site if agecat2==1, col chi m
xi:logistic site1 i.alcohol if agecat2==1
tab cigsmokenow site if agecat2==1, col chi m
xi:logistic site1 i.cigsmokenow if agecat2==1
tab smokesnuffnow1 site if agecat2==1, col chi m
xi:logistic site1 i.smokesnuffnow1 if agecat2==1
tab anysmokenow site if agecat2==1, col chi m
xi:logistic site1 i.anysmokenow if agecat2==1
tab anysmokeprev site if agecat2==1, col chi m
xi:logistic site1 i.anysmokeprev if agecat2==1
tab smokeinside1 site if agecat2==1 & anysmokenow==1, col chi m
xi:logistic site1 i.smokeinside1 if agecat2==1 & anysmokenow==1
tab cotinine site    , col chi m
tab cotinine site    , col chi 
xi:logistic site1  i.cotinine  
tab hiv_status site    , col chi m
tab hivfinal site    , col chi 
xi:logistic site1  i.hivfinal  
tab underill site    , col chi m
xi:logistic site1  i.underill  
tab fluvac site    , col chi m
xi:logistic site1  i.fluvac  
tab pasttb site    , col chi m
xi:logistic site1  i.pasttb  
tab currenttb site    , col chi m
xi:logistic site1  i.currenttb  

tab agecat3 site1   , col
gen HIB_Full_N_1_missing=HIB_Full_N_1
replace HIB_Full_N_1_missing=. if HIB_Full_N_1_missing==2

gen PCV_Full_N_1_missing=PCV_Full_N_1
replace PCV_Full_N_1_missing=. if PCV_Full_N_1_missing==2

tab HIB_Full_N_1 site1 if agecat<2 , m col
tab HIB_Full_N_1_missing site1 if agecat<2 , col
xi:logistic site1  i.HIB_Full_N_1_missing   if agecat<2

tab PCV_Full_N_1 site1 if agecat<2 , m col
tab PCV_Full_N_1_missing site1 if agecat<2 , col
xi:logistic site1  b1.HIB_Full_N_1_missing   if agecat<2
xi:logistic site1  b1.PCV_Full_N_1_missing   if agecat<2
tab  arv_current_self hivfinal, m
tab arv_current_self if hivfinal==1

tab  arv_current_vl hivfinal, m
tab arv_current_vl if hivfinal==1
tab arv_current_self if hivfinal==1
tab  viral_suppression hivfinal, m
tab  viral_suppression arv_current_self, m

tab arv_current_vl arv_current_self
gen arv_current_vl1=arv_current_vl
label values arv_current_vl1 arv_current_vl
replace arv_current_vl1=1 if arv_current_self==1
tab arv_current_vl1 arv_current_self

tab viral_suppression site1 if arv_current_vl1==1, col chi

tab arv_current_vl1 site1 if hivfinal==1, col chi

tab cd4_cat site1 if hivfinal==1, col chi


**************************************************************



