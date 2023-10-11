# The PHIRST cohort study: Incidence and transmission of respiratory syncytial virus (RSV)

## About PHIRST
The Prospective Household observational cohort study of Influenza, Respiratory Syncytial virus and other respiratory pathogens community burden and Transmission dynamics in South Africa (The PHIRST Study) was a prospective cohort study in a rural and urban site from 2017-2018, with approximately 100 new households enrolled each year and followed up for 10 months. Nasopharyngeal swabs were collected twice-weekly from consenting household members irrespective of symptoms and tested for influenza virus, respiratory syncytial virus (RSV), *B. pertussis* and *S. pneumoniae* using a real-time reverse transcription polymerase chain reaction. We collected and tested over 100,000 nasopharyngeal swabs and over 7,000 serum samples. Although the follow-up of the cohort has stopped, we are currently doing serology testing and analysis.

## Repository
This repository houses code, analysis log files and data to generate figures from Cohen et al. Incidence and transmission of respiratory syncytial virus in urban and rural communities in South Africa, 2017-2018: results of the PHIRST cohort study.

### Abstract
Data on RSV incidence and household transmission are limited. To describe RSV incidence and transmission, we conducted a prospective cohort study in rural and urban communities over two seasons during 2017-2018. Nasopharyngeal swabs were collected twice-weekly for 10 months annually and tested for RSV using PCR. We tested 81,430 samples from 1,116 participants in 225 households (follow-up 90%). 32% (359/1116) of individuals had ≥1 RSV infection; 10%(37/359) had a repeat infection during the same season, 33% (132/396) of infections were symptomatic, and 2% (9/396) sought medical care. Incidence was 47.2 infections/100 person-years and highest in children <5 years (78.3). Symptoms were commonest in individuals aged <12 and ≥65 years. Individuals 1-12 years accounted for 55% (134/242) of index cases. Household cumulative infection risk was 11%. On multivariable analysis, index cases with ≥2 symptoms and shedding duration ≥4 days were more likely to transmit infection; household contacts aged 1-4 years vs. age ≥65 years were more likely to acquire infection. Within two South African communities, RSV attack rate was high, and most infections asymptomatic. Young children were more likely to introduce RSV into the home, and to be infected. Future studies should examine whether vaccines targeting children aged <12 years could reduce community transmission. 

## Data availability
Individual-level data cannot be publicly shared because of ethical restrictions and the potential for identifying included individuals. Accessing individual participant data and a data dictionary defining each field in the dataset would require provision of protocol and ethics approval for the proposed use. To request individual participant data access, please submit a proposal to Prof Cheryl Cohen (cherylc@nicd.ac.za) who will respond within 1 month of request. Upon approval, data can be made available through a data sharing agreement.
However, aggregate data to reproduce the figures are available in this repository, along with the code and log files for the analysis. 
All statistical analyses were conducted using Stata version 14.1 (Stata Corp LP, College Station, Texas, USA), and we therefore provide the code and logs in Stata format (.do and .smcl), which is viewable on this GitHub repo.

## Aggregate data to reproduce figures
Provided in file: [Cohen PHIRST RSV Figure data.xlsx](https://github.com/crdm-nicd/phirst_rsv/blob/main/Cohen%20PHIRST%20RSV%20Figure%20data.xlsx)
Figure 1 (Epi curves and mosaics): See excel file in repository
Figure 2 (Burden Venn): Data included on figure
Figure 3 (Infection and illness rates by symptoms and medical attendance): Data presented in Supplementary table 4
Supplementary figure 1 (Map): N/A
Supplementary figure 2 (Methods): N/A 
Supplementary figure 3 (Participation flow diagram): Data included on figure
Supplementary figure 4 (Mosaics): See excel file in repository (same data as for figure 1)
Supplementary figure 5 (RSV infection rates by age and RSV type): Excel 
Supplementary figure 6 (Episode duration): See excel file in repository
Supplementary figure 7 (Generation interval): See excel file in repository

## Code and log files for analysis
Stata .do (code) and .smcl (logs) files for the analysis has been included in this repository for review.
### Main analysis
Code and logs used for the main analysis, including the sensitivity analysis using uniform distributions for the episode start and end: [RSV 20231005](https://github.com/crdm-nicd/phirst_rsv/tree/main/RSV%2020231005)

### Sensitivity analysis
Code and logs used for the sensitivity analysis including only households where all members participated in the study: [RSV sens ana full HH only based on 202310055](https://github.com/crdm-nicd/phirst_rsv/tree/main/RSV%20sens%20ana%20full%20HH%20only%20based%20on%2020231005)

Code and logs used for the sensitivity analysis with only a 1-week gap between episodes: [RSV sens ana 1w epi gap based on 20231005](https://github.com/crdm-nicd/phirst_rsv/tree/main/RSV%20sens%20ana%201w%20epi%20gap%20based%20on%2020231005)

Code and logs used for the sensitivity analysis with a 3-week gap between episodes: [RSV sens ana 3w epi gap based on 20231005](https://github.com/crdm-nicd/phirst_rsv/tree/main/RSV%20sens%20ana%203w%20epi%20gap%20based%20on%2020231005)


## Additional information on PHIRST
https://crdm.nicd.ac.za/projects/phirst/

## Publications for PHIRST
PHIRST Cohort description: Cohen C, McMorrow ML, Martinson NA, Kahn K, Treurnicht FK, Moyes J, et al. Cohort profile: A Prospective Household cohort study of Influenza, Respiratory syncytial virus and other respiratory pathogens community burden and Transmission dynamics in South Africa, 2016–2018. Influenza Other Respi Viruses. 2021;15(6):789-803. Epub 2021/07/24. doi: https://doi.org/10.1111/irv.12881.

Influenza: Cohen C, Kleynhans J, Moyes J, McMorrow ML, Treurnicht FK, Hellferscee O, et al. Asymptomatic transmission and high community burden of seasonal influenza in an urban and a rural community in South Africa, 2017-18 (PHIRST): a population cohort study. The Lancet Global Health. 2021;9(6):e863-e74. Epub 2021/05/22. doi: https://doi.org/10.1016/S2214-109X(21)00141-8. 

Pneumococcal Carriage: Carrim M, Tempia S, Thindwa D, Martinson NA, Kahn K, Flasche S, et al. Unmasking Pneumococcal Carriage in a High Human Immunodeficiency Virus (HIV) Prevalence Population in two Community Cohorts in South Africa, 2016–2018: The PHIRST Study. Clin Infect Dis. 2022;76(3):e710-e7. doi: https://doi.org/10.1093/cid/ciac499.

HIV and pneumococcal transmission: Thindwa D, Wolter N, Pinsent A, Carrim M, Ojal J, Tempia S, et al. Estimating the contribution of HIV-infected adults to household pneumococcal transmission in South Africa, 2016–2018: A hidden Markov modelling study. PLoS Comput Biol. 2021;17(12):e1009680. doi: https://doi.org/10.1371/journal.pcbi.1009680.

Bordetella pertussis: Moosa F, Tempia S, Kleynhans J, McMorrow M, Moyes J, du Plessis M, et al. Incidence and Transmission Dynamics of Bordetella pertussis Infection in Rural and Urban Communities, South Africa, 2016‒2018. Emerging Infectious Disease journal. 2023;29(2):294. doi: https://doi.org/10.3201/eid2902.221125.

Contact patterns: Kleynhans J, Tempia S, McMorrow ML, von Gottberg A, Martinson NA, Kahn K, et al. A cross-sectional study measuring contact patterns using diaries in an urban and a rural community in South Africa, 2018. BMC Public Health. 2021;21:1055. Epub 2021/06/04. doi: https://doi.org/10.1186/s12889-021-11136-6. 

Houseing quality: Mathee A, Moyes J, Mkhencele T, Kleynhans J, Language B, Piketh S, et al. Housing Quality in a Rural and an Urban Settlement in South Africa. Int J Environ Res Public Health. 2021;18(5):2240. Epub 2021/03/07. doi: https://doi.org/10.3390/ijerph18052240. 

