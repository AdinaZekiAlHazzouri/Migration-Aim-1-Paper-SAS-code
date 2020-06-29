# Migration Aim 1 Paper SAS Code
The SAS files in this repository are the analysis and code for **Quantifying life course drivers of international migration: A cross-national analysis of Mexico and the US**. 

We merged harmonized data on subjects aged 50+ from two nationally representative datasets in the US and Mexico – the US based Health and Retirement Study (HRS) and the Mexican Health and Aging Study (MHAS). Specific datasets for each SAS file are specified below.

## 1-Create Harmonized Dataset_MHAS.sas 

Load harmonized MHAS data. Then select and merge relevant variables from the following sections: 

Section A: Demographics, Identifiers, and Weights 

Section B: Health 

Section D: Cognition 

Section E: Financial and Housing Wealth 

Section F: Income 

Section G: Family Structure 

Section H: Employment History 

## 2-Create Raw Datasets_MHAS.sas 

Load raw MHAS data from 2001, 2003, and 2012. Then select and merge relevant variables from the following sections: 

Section A: Demographics, Identifiers, and Weights 

Section C: Health 

Section I: Employment 

Section L: Biomarkers 

Section X: Childhood 

## 3-Create MHAS50 Dataset_MHAS.sas 

Limit participants to those that have migration information and are aged 50+ in raw and harmonized data.  

## 4-Create RAND Dataset_HRS.sas 

Load longitudinal HRS RAND data and select relevant variables. 

## 5-Create Raw Datasets_HRS.sas 

Load HRS Tracker data and raw HRS data from years 1992-2012. Merge selected variables from Raw HRS data.  

Raw HRS variables come from the following sections: 

Section A: Demographics 

Section B: Health 

Section GH/L: Job History 

## 6-Create HRS50 Dataset_HRS.sas 

Merge tracker and Rand datasets. Limit HRS data to only include interview years 2000, 2002, and 2012 for Hispanic Mexican individuals born in a foreign country, aged 50+.  

## 7-Create dataset for paper1_HRS+MHAS.sas 

Create relevant fixed and time varying covariates. Combine resulting MHAS and HRS datasets. 

## 8-Set up dataset for paper 1_HRS+MHAS.sas 

Create a long-form version of the combined MHAS and HRS data for survival analysis with time-dependent variables. 

## 9-Create migration stabilized weights.sas 

Run models to create propensity scores and stabilized weights for selection into migration. 

## 10-Run Outcome Analyses.sas 

Run the selection model, compare migrants and never migrants on baseline characteristics, and run models for the relationship between migration and all-cause mortality. 
