****************************************
****************************************
*PHIRST: RSV - Analysis - Master DoFile*
****************************************
****************************************

clear all
set more off

*Set directory*
*cd "\\appshare\crdm databases\PHIRST\Analyses\RSV\From Stefano 20221104\RSV 20221115\" 
cd "C:\Users\jackiel\Desktop\RSV sens ana 3w epi gap based on 20231005"

*Run all DoFiles sequentially*
*
*Descriptive analysis*
do "3.1. PHIRST - Analysis - RSV - Prepare Dataset - V1.do"
do "3.2. PHIRST - Analysis - RSV - Episodes - V2s1 3w epi gap.do"
do "3.3. PHIRST - Analysis - RSV - Clusters - V3.do"
do "3.4. PHIRST - Analysis - RSV - Ct-value - Episodes - V1.do"
do "3.5. PHIRST - Analysis - RSV - Index - V1.do"
do "3.6. PHIRST - Analysis - RSV - HCIR-SI - V2.do"
do "3.7.1. PHIRST - Analysis - RSV - Symptoms - Double Count Coinfections - No - V1.do"
do "3.7.2. PHIRST - Analysis - RSV - Symptoms - Double Count Coinfections - Yes - V1.do"
do "3.8. PHIRST - Analysis - RSV - Summary Statistics - V3.do"
do "3.9. PHIRST - Analysis - RSV - Merge Epi Data - V1.do"
do "3.10. PHIRST - Analysis - RSV - Incidence Rates - Types and Syptoms - V2.do"
do "3.11. PHIRST - Analysis - RSV - Make EpiCurve - V2.do"
*
*Risk factors analysis*
do "3.12. PHIRST - Analysis - RSV - RF - Incidence Rates - V1 24062022.do"
do "3.13. PHIRST - Analysis - RSV - RF - CAR & Index - V1 14112022.do"
do "3.14. PHIRST - Analysis - RSV - RF - Symptoms - V1 31032022.do"
do "3.15. PHIRST - Analysis - RSV - RF - Episode Duration - V1 21102022.do"
do "3.16. PHIRST - Analysis - RSV - RF - HCIR - V4 - SI lt 17 days.do"
do "3.16. PHIRST - Analysis - RSV - RF - HCIR - V4 - SI all.do"
do "3.17. PHIRST - Analysis - RSV - RF - Serial interval - V3.do"
*
do "3.1 PHIRST - Analysis - Describe included cohort - 2017-2018 - 03102023.do"
*
clear all
