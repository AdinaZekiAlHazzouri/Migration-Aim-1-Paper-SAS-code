
libname library 'C:\Users\\\\\\\harmonized dataset';
options fmtsearch = (library);
libname Raw 'C:\Users\\\\\\\raw datasets';
libname Harmo 'C:\Users\\\\\\\harmonized dataset';
libname Next 'C:\Users\\\\\\\next-of-kin raw datasets';
libname created 'C:\Users\\\\\\\SAS datasets';
run;


***********************************************Section A: Demographics, Identifiers,and Weights************************************************;
/***********Keep variables**********/
data h_mhas_A; 
set Harmo.h_mhas;
keep
  CODENT01 CODENT03 PS3      ENT2     NP       UNHHIDNP RAHHIDNP                                                /*Person Specific Identifier*/
  UNHHID   CUNICAH  H1HHID   H2HHID   H3HHID   H1HHIDC  H2HHIDC  H3HHIDC  ACTHOG   SUBHOG_01 SUBHOG_03 SUBHOG_12/*Household Identifier*/
  INW1     INW2     INW3                                                                                        /*Wave Status: Response indicator*/
  R1IWSTAT R2IWSTAT R3IWSTAT                                                                                    /*Wave Status: Interview status*/
  R1PROXY  R2PROXY  R3PROXY                                                                                     /*Whether Proxy Interview*/
  R1WTRESP R2WTRESP R3WTRESP                                                                                    /*Person-Level Analysis Weight*/
  R1IW     R2IW     R3IW     R1IWF    R2IWF    R3IWF    R1IWM    R2IWM    R3IWM    R1IWY     R2IWY     R3IWY    /*Interview Dates*/
  RABYEAR  RABMONTH RABFLAG                                                                                     /*Birth Date: Month and year*/
  RADYEAR  RADMONTH                                                                                             /*Death Date: Month and year*/
  R1AGEY   R2AGEY   R3AGEY   R1AGEM   R2AGEM   R3AGEM                                                           /*Age at Interview (months and years)*/
  RAGENDER                                                                                                      /*Gender*/
  RAEDYRS                                                                                                       /*Education*/
  RAEDISCED                                                                                                     /*Education: Categories by ISCED Codes*/
  RAEDUCL                                                                                                       /*Education: Harmonized Education*/
  R1MPART  R2MPART  R3MPART                                                                                     /*Current Marital Status: Current partnership status*/
  R1MSTAT  R2MSTAT  R3MSTAT                                                                                     /*Current Marital Status: With partnership*/
  R1MSTATH R2MSTATH R3MSTATH                                                                                    /*Current Marital Status: Without partnership*/
  R1MRCT   R2MRCT   R3MRCT                                                                                      /*Number of marriages*/
;
/**********Rename variables**********/
/*Person specific identifier*/
*rename CODENT01 = RI01;
*rename CODENT03 = RI03;
*rename PS3      = RIA01;
*rename ENT2     = RIA03;
*rename NP       = RI12;
*rename UNHHIDNP = RID;
*rename RAHHIDNP = RIDA;
/*Household identifier*/
*rename UNHHID    = HI;
*rename CUNICAH   = HIA;
*rename H1HHID    = HI01;
*rename H2HHID    = HI03;
*rename H3HHID    = HI12;
*rename H1HHIDC   = HIC01;
*rename H2HHIDC   = HIC03;
*rename H3HHIDC   = HIC12;
*rename ACTHOG    = HIU03;
*rename SUBHOG_01 = HSI01;
*rename SUBHOG_03 = HSI03;
*rename SUBHOG_12 = HSI12;
/*Wave Status: response indicator*/
rename INW1 = RINW01;
rename INW2 = RINW03;
rename INW3 = RINW12;
/*Wave status: interview status*/
rename R1IWSTAT = RIWSTAT01;
rename R2IWSTAT = RIWSTAT03;
rename R3IWSTAT = RIWSTAT12;
/*Whether proxy interview*/
rename R1PROXY  = RPROXY01;
rename R2PROXY  = RPROXY03;
rename R3PROXY  = RPROXY12;
/*Person-level analysis weight*/
rename R1WTRESP = RWTRESP01;
rename R2WTRESP = RWTRESP03;
rename R3WTRESP = RWTRESP12;
/*Interview dates*/
rename R1IW  = RIW01;
rename R2IW  = RIW03;
rename R3IW  = RIW12;
rename R1IWF = RIWF01;
rename R2IWF = RIWF03;
rename R3IWF = RIWF12;
rename R1IWM = RIWM01;
rename R2IWM = RIWM03;
rename R3IWM = RIWM12;
rename R1IWY = RIWY01;
rename R2IWY = RIWY03;
rename R3IWY = RIWY12;
/*Birth date: keep RABYEAR;RABMONTH;RABFLAG*/
/*Death date: keep RADYEAR;RADMONTH*/
/*Age at interview*/
rename R1AGEY = RAGEY01;
rename R2AGEY = RAGEY03;
rename R3AGEY = RAGEY12;
rename R1AGEM = RAGEM01;
rename R2AGEM = RAGEM03;
rename R3AGEM = RAGEM12;
/*Gender: keep RAGENDER*/
/*Education: keep RAEDYRS; RAEDISCED; RAEDUCL*/
/*Marital status*/
rename R1MPART = RMPART01;
rename R2MPART = RMPART03;
rename R3MPART = RMPART12;
rename R1MSTAT = RMSTAT01;
rename R2MSTAT = RMSTAT03;
rename R3MSTAT = RMSTAT12;
rename R1MSTATH = RMSTATH01;
rename R2MSTATH = RMSTATH03;
rename R3MSTATH = RMSTATH12;
/*Number of marriages*/
rename R1MRCT   = RMRCT01;
rename R2MRCT   = RMRCT03;
rename R3MRCT   = RMRCT12;
/**********Label variables**********/
/*Person specific identifier*/
	label CODENT01 = "Person identification code 2001 (=ps3)";
	label CODENT03 = "Person identification code 2003 (=ent2)";
	label PS3      = "Person identification code 2001 (=codent01)";
	label ENT2     = "Person identification code 2003 (=codent03)";
	label NP       = "Person Number";
	label UNHHIDNP = "UNHHIDNP:Unique Person Identifier (HH ID + Person Number)/Cont";
	label RAHHIDNP = "RAHHIDNP:Unique Person Identifier (HH ID + Person Number)/Char";
	/*Household identifier*/
	label UNHHID   = "Unique household identifier (=cunicah)";
	label CUNICAH  = "Unique household identifier (=unhhid)";
	label H1HHID   = "h1hhid:2001 Unique Household Identifier (HH ID + SubHH)/ Num";
	label H2HHID   = "h2hhid:2003 Unique Household Identifier (HH ID + SubHH)/ Num";
	label H3HHID   = "h3hhid:2012 Unique Household Identifier (HH ID + SubHH)/ Num";
	label H1HHIDC  = "h1hhidc:2001 Unique Household Identifier (HH ID + SubHH)/ 7-C";
	label H2HHIDC  = "h2hhidc:2003 Unique Household Identifier (HH ID + SubHH)/ 7-C";
	label H3HHIDC  = "h3hhidc:2012 Unique Household Identifier (HH ID + SubHH)/ 7-C";
	label ACTHOG   = "Update household code 2003";
	label SUBHOG_01= "2001 sub-household identifier";
	label SUBHOG_03= "2003 sub-household identifier";
	label SUBHOG_12= "2012 sub-household identifier";
    /*Wave status: response indicator*/
	label INW1 = "2001 Response Indicator";
	label INW2 = "2003 Response Indicator";
	label INW3 = "2012 Response Indicator";
	/*Wave status: interview status*/
	label R1IWSTAT = "riwstat01: 2001 R Interview Status";
	label R2IWSTAT = "riwstat03: 2003 R Interview Status";
	label R3IWSTAT = "riwstat12: 2012 R Interview Status";
	/*Whether proxy interview*/
    label R1PROXY = "rproxy01: 2001 R Whether Proxy Interview";
	label R2PROXY = "rproxy03: 2003 R Whether Proxy Interview";
	label R3PROXY = "rproxy12: 2012 R Whether Proxy Interview";
    /*Person-level analysis weight*/
    label R1WTRESP = "rwtresp01: 2001 R Person-Level Analysis Weight";
	label R2WTRESP = "rwtresp03: 2003 R Person-Level Analysis Weight";
	label R3WTRESP = "rwtresp12: 2012 R Person-Level Analysis Weight";
    /*Interview dates*/
	label R1IW  = "riw01: 2001 R Interview Date";
    label R2IW  = "riw03: 2003 R Interview Date";
    label R3IW  = "riw12: 2012 R Interview Date";
    label R1IWF = "riwf01: 2001 R Interview Date Flag";
	label R2IWF = "riwf03: 2003 R Interview Date Flag";
	label R3IWF = "riwf12: 2012 R Interview Date Flag";
	label R1IWM = "riwm01: 2001 R Household Interview Month";
	label R2IWM = "riwm03: 2003 R Household Interview Month";
	label R3IWM = "riwm12: 2012 R Household Interview Month";
	label R1IWY = "riwy01: 2001 R Household Interview Year";
	label R2IWY = "riwy03: 2003 R Household Interview Year";
	label R3IWY = "riwy12: 2012 R Household Interview Year";
	/*Birth date*/
	label RABYEAR  = "rabyear: R Birth Year";
	label RABMONTH = "rabmonth: R Birth Month";
	label RABFLAG  = "rabflag: R Birthdate Flag";
	/*Death date*/
	label RADYEAR  = "radyear: R Death Year";
	label RADMONTH = "radmonth: R Death Month";
	/*Age at interview*/
	label R1AGEY = "ragey01: 2001 R Age (years) at interview";
	label R2AGEY = "ragey03: 2003 R Age (years) at interview";
	label R3AGEY = "ragey12: 2012 R Age (years) at interview";
	label R1AGEM = "ragem01: 2001 R Age (months) at interview";
	label R2AGEM = "ragem03: 2003 R Age (months) at interview";
	label R3AGEM = "ragem12: 2012 R Age (months) at interview";
	/*Gender*/
	label RAGENDER = "ragender: R Gender";
	/*Education*/
	label RAEDYRS   = "raedyrs: R Years of Education";
	label RAEDISCED = "raedisced: R Education by ISCED Code";
	label RAEDUCL   = "raeducl: R Harmonized Education";
	/*Marital status*/
	label R1MPART  = "rmpart01: 2001 R Current Partnership Status";
	label R2MPART  = "rmpart03: 2003 R Current Partnership Status";
	label R3MPART  = "rmpart12: 2012 R Current Partnership Status";
	label R1MSTAT  = "rmstat01: 2001 R Marital Status";
	label R2MSTAT  = "rmstat03: 2003 R Marital Status";
	label R3MSTAT  = "rmstat12: 2012 R Marital Status";
	label R1MSTATH = "rmstath01: 2001 R Marital Status w/o Partnership Filled";
	label R2MSTATH = "rmstath03: 2003 R Marital Status w/o Partnership Filled";
    label R3MSTATH = "rmstath12: 2012 R Marital Status w/o Partnership Filled";
	/*Number of marriages*/
	label R1MRCT = "rmrct01: 2001 R Number of marriages";
	label R2MRCT = "rmrct03: 2003 R Number of marriages";
	label R3MRCT = "rmrct12: 2012 R Number of marriages";
run;




**************************************************************Section B: Health****************************************************************;
/***********Keep variables**********/
data h_mhas_B;
set Harmo.h_mhas;
keep
  UNHHIDNP
  R1SHLT   R2SHLT   R3SHLT                                                                                      /*Self-Report of Health*/
  R1DRESS  R2DRESS  R3DRESS  R1DRESSH R2DRESSH R3DRESSH R1WALKR  R2WALKR  R3WALKR  R1WALKRE  R2WALKRE  R3WALKRE
  R1WALKRH R2WALKRH R3WALKRH R1BATH   R2BATH   R3BATH   R1BATHH  R2BATHH  R3BATHH  R1EAT     R2EAT     R3EAT      
  R1EATH   R2EATH   R3EATH   R1BED    R2BED    R3BED    R1BEDE   R2BEDE   R3BEDE   R1BEDH    R2BEDH    R3BEDH    

  R1TOILT  R2TOILT  R3TOILT  R1TOILTH R2TOILTH R3TOILTH                                                         /*ADLs: Raw Recodes*/
  R1WALKRA R2WALKRA R3WALKRA R1DRESSA R2DRESSA R3DRESSA R1BATHA  R2BATHA  R3BATHA  R1EATA    R2EATA    R3EATA
  R1BEDA   R2BEDA   R3BEDA   R1TOILTA R2TOILTA R3TOILTA                                                         /*ADLs: Some Difficulty*/
  R1MONEY  R2MONEY  R3MONEY  R1MEDS   R2MEDS   R3MEDS   R1SHOP   R2SHOP   R3SHOP   R1MEALS   R2MEALS   R3MEALS  /*IADLs: Raw Recodes*/
  R1MONEYA R2MONEYA R3MONEYA R1MEDSA  R2MEDSA  R3MEDSA  R1SHOPA  R2SHOPA  R3SHOPA  R1MEALSA  R2MEALSA  R3MEALSA /*IADLs: Some Difficulty*/
  R1WALKS  R2WALKS  R3WALKS  R1JOG    R2JOG    R3JOG    R1WALK1  R2WALK1  R3WALK1  R1SIT     R2SIT     R3SIT
  R1CHAIR  R2CHAIR  R3CHAIR  R1CLIMS  R2CLIMS  R3CLIMS  R1CLIM1  R2CLIM1  R3CLIM1  R1STOOP   R2STOOP   R3STOOP
  R1LIFT   R2LIFT   R3LIFT   R1DIME   R2DIME   R3DIME   R1ARMS   R2ARMS   R3ARMS   R1PUSH    R2PUSH    R3PUSH   /*Other Functional Limitations: Raw Recodes*/
  R1WALKSA R2WALKSA R3WALKSA R1JOGA   R2JOGA   R3JOGA   R1WALK1A R2WALK1A R3WALK1A R1SITA    R2SITA    R3SITA
  R1CHAIRA R2CHAIRA R3CHAIRA R1CLIMSA R2CLIMSA R3CLIMSA R1CLIM1A R2CLIM1A R3CLIM1A R1STOOPA  R2STOOPA  R3STOOPA
  R1LIFTA  R2LIFTA  R3LIFTA  R1DIMEA  R2DIMEA  R3DIMEA  R1ARMSA  R2ARMSA  R3ARMSA  R1PUSHA   R2PUSHA   R3PUSHA  /*Other Functional Limitations: Some Difficulty*/
  R1ADLA   R2ADLA   R3ADLA   R1ADLAM  R2ADLAM  R3ADLAM  R1ADLA_M R2ADLA_M R3ADLA_M R1ADLAM_M R2ADLAM_M R3ADLAM_M
  R1ADLWA  R2ADLWA  R3ADLWA  R1ADLWAM R2ADLWAM R3ADLWAM                                                         /*ADL Summary: Sum ADLs Where Respondent Reports Any Difficulty*/
  R1IADLZA_M R2IADLZA_M R3IADLZA_M R1IADLZAM_M R2IADLZAM_M R3IADLZAM_M                                          /*IADL Summary: Sum IADLs Where Respondent Reports Any Difficulty*/
/*R1MOBILA   R2MOBILA   R3MOBILA   R1MOBILAM   R2MOBILAM   R3MOBILAM   R1LGMUSA   R2LGMUSA   R3LGMUSA
  R1LGMUSAM  R2LGMUSAM  R3LGMUSAM  R1GROSSA    R2GROSSA    R3GROSSA    R1GROSSAM  R2GROSSAM  R3GROSSAM
  R1FINEA    R2FINEA    R3FINEA    R1FINEAM    R2FINEAM    R3FINEAM*/                                           /*Other Summary Indices: Mobility, Large Muscle, Gross, Fine Motor Activities*/

  R1DEPRES R2DEPRES R3DEPRES R1EFFORT R2EFFORT R3EFFORT R1SLEEPR R2SLEEPR R3SLEEPR R1WHAPPY R2WHAPPY R3WHAPPY
  R1FLONE  R2FLONE  R3FLONE  R1ENLIFE R2ENLIFE R3ENLIFE R1FSAD   R2FSAD   R3FSAD   R1FTIRED R2FTIRED R3FTIRED
  R1ENERG  R2ENERG  R3ENERG  R1CESD_M R2CESD_M R3CESD_M R1CESDM_M R2CESDM_M R3CESDM_M                           /*Mental Health (CESD score)*/

  R1HIBPE  R2HIBPE  R3HIBPE  R1DIABE  R2DIABE  R3DIABE  R1CANCRE R2CANCRE R3CANCRE 
  R1HEARTE_M R2HEARTE_M R3HEARTE_M R1STROKE R2STROKE R3STROKE                                                   /*Doctor Diagnosed Health Problems: Ever have condition*/

  R1BMI    R2BMI    R3BMI    R1BMIA   R2BMIA   R3BMIA   R1HEIGHT R2HEIGHT R3HEIGHT R1HEIGHTA R2HEIGHTA R3HEIGHTA
  R1WEIGHT R2WEIGHT R3WEIGHT R1WEIGHTA R2WEIGHTA R3WEIGHTA                                                      /*BMI*/

  R1VIGACT R2VIGACT R3VIGACT                                                                                    /*Health Behaviors: Physical Activity or Exercise*/
  R1DRINK  R2DRINK  R3DRINK  R1DRINKD R2DRINKD R3DRINKD R1DRINKN R2DRINKN R3DRINKN                              /*Health Behaviors: Drinking*/
  R1SMOKEV R2SMOKEV R3SMOKEV R1SMOKEN R2SMOKEN R3SMOKEN R1SMOKET R2SMOKET R3SMOKET                              /*Health Behaviors: Smoking (cigarettes)*/
;

/**********Rename variables**********/
/*ID*/
*rename UNHHIDNP = RID;
/*Self-Report of Health*/
rename R1SHLT = RSHLT01;
rename R2SHLT = RSHLT03;
rename R3SHLT = RSHLT12;
/*ADLs: raw recodes*/
rename R1DRESS  = RDRESS01;
rename R2DRESS  = RDRESS03;
rename R3DRESS  = RDRESS12;
rename R1DRESSH = RDRESSH01;
rename R2DRESSH = RDRESSH03;
rename R3DRESSH = RDRESSH12;
rename R1WALKR  = RWALKR01;
rename R2WALKR  = RWALKR03;
rename R3WALKR  = RWALKR12;
rename R1WALKRE = RWALKRE01;
rename R2WALKRE = RWALKRE03;
rename R3WALKRE = RWALKRE12;
rename R1WALKRH = RWALKRH01;
rename R2WALKRH = RWALKRH03;
rename R3WALKRH = RWALKRH12;
rename R1BATH   = RBATH01;
rename R2BATH   = RBATH03;
rename R3BATH   = RBATH12;
rename R1BATHH  = RBATHH01;
rename R2BATHH  = RBATHH03;
rename R3BATHH  = RBATHH12;
rename R1EAT    = REAT01;
rename R2EAT    = REAT03;
rename R3EAT    = REAT12;
rename R1EATH   = REATH01;
rename R2EATH   = REATH03;
rename R3EATH   = REATH12;
rename R1BED    = RBED01;
rename R2BED    = RBED03;
rename R3BED    = RBED12;
rename R1BEDE   = RBEDE01;
rename R2BEDE   = RBEDE03;
rename R3BEDE   = RBEDE12;
rename R1BEDH   = RBEDH01;
rename R2BEDH   = RBEDH03;
rename R3BEDH   = RBEDH12;
rename R1TOILT  = RTOILT01;
rename R2TOILT  = RTOILT03;
rename R3TOILT  = RTOILT12;
rename R1TOILTH = RTOILTH01;
rename R2TOILTH = RTOILTH03;
rename R3TOILTH = RTOILTH12;
/*ADLs:Some Difficulty*/
rename R1WALKRA = RWALKRA01;
rename R2WALKRA = RWALKRA03;
rename R3WALKRA = RWALKRA12;
rename R1DRESSA = RDRESSA01;
rename R2DRESSA = RDRESSA03;
rename R3DRESSA = RDRESSA12;
rename R1BATHA  = RBATHA01;
rename R2BATHA  = RBATHA03;
rename R3BATHA  = RBATHA12;
rename R1EATA   = REATA01;
rename R2EATA   = REATA03;
rename R3EATA   = REATA12;
rename R1BEDA   = RBEDA01;
rename R2BEDA   = RBEDA03;
rename R3BEDA   = RBEDA12;
rename R1TOILTA = RTOILTA01;
rename R2TOILTA = RTOILTA03;
rename R3TOILTA = RTOILTA12;
/*IADLs: raw recodes*/
rename R1MONEY = RMONEY01;
rename R2MONEY = RMONEY03;
rename R3MONEY = RMONEY12;
rename R1MEDS  = RMEDS01;
rename R2MEDS  = RMEDS03;
rename R3MEDS  = RMEDS12;
rename R1SHOP  = RSHOP01;
rename R2SHOP  = RSHOP03;
rename R3SHOP  = RSHOP12;
rename R1MEALS = RMEALS01;
rename R2MEALS = RMEALS03;
rename R3MEALS = RMEALS12;
/*IADLs:Some Difficulty*/
rename R1MONEYA = RMONEYA01;
rename R2MONEYA = RMONEYA03;
rename R3MONEYA = RMONEYA12;
rename R1MEDSA  = RMEDSA01;
rename R2MEDSA  = RMEDSA03;
rename R3MEDSA  = RMEDSA12;
rename R1SHOPA  = RSHOPA01;
rename R2SHOPA  = RSHOPA03;
rename R3SHOPA  = RSHOPA12;
rename R1MEALSA = RMEALSA01;
rename R2MEALSA = RMEALSA03;
rename R3MEALSA = RMEALSA12;
/*Other functional limitations: raw recodes*/
rename R1WALKS = RWALKS01;
rename R2WALKS = RWALKS03;
rename R3WALKS = RWALKS12;
rename R1JOG   = RJOG01;
rename R2JOG   = RJOG03;
rename R3JOG   = RJOG12;
rename R1WALK1 = RWALK1_01;
rename R2WALK1 = RWALK1_03;
rename R3WALK1 = RWALK1_12;
rename R1SIT   = RSIT01;
rename R2SIT   = RSIT03;
rename R3SIT   = RSIT12;
rename R1CHAIR = RCHAIR01;
rename R2CHAIR = RCHAIR03;
rename R3CHAIR = RCHAIR12;
rename R1CLIMS = RCLIMS01;
rename R2CLIMS = RCLIMS03;
rename R3CLIMS = RCLIMS12;
rename R1CLIM1 = RCLIM1_01;
rename R2CLIM1 = RCLIM1_03;
rename R3CLIM1 = RCLIM1_12;
rename R1STOOP = RSTOOP01;
rename R2STOOP = RSTOOP03;
rename R3STOOP = RSTOOP12;
rename R1LIFT  = RLIFT01;
rename R2LIFT  = RLIFT03;
rename R3LIFT  = RLIFT12;
rename R1DIME  = RDIME01;
rename R2DIME  = RDIME03;
rename R3DIME  = RDIME12;
rename R1ARMS  = RARMS01;
rename R2ARMS  = RARMS03;
rename R3ARMS  = RARMS12;
rename R1PUSH  = RPUSH01;
rename R2PUSH  = RPUSH03;
rename R3PUSH  = RPUSH12;
/*Other functional limitations: some difficulty*/
rename R1WALKSA = RWALKSA01;
rename R2WALKSA = RWALKSA03;
rename R3WALKSA = RWALKSA12;
rename R1JOGA   = RJOGA01;
rename R2JOGA   = RJOGA03;
rename R3JOGA   = RJOGA12;
rename R1WALK1A = RWALK1A01;
rename R2WALK1A = RWALK1A03;
rename R3WALK1A = RWALK1A12;
rename R1SITA   = RSITA01;
rename R2SITA   = RSITA03;
rename R3SITA   = RSITA12;
rename R1CHAIRA = RCHAIRA01;
rename R2CHAIRA = RCHAIRA03;
rename R3CHAIRA = RCHAIRA12;
rename R1CLIMSA = RCLIMSA01;
rename R2CLIMSA = RCLIMSA03;
rename R3CLIMSA = RCLIMSA12;
rename R1CLIM1A = RCLIM1A01;
rename R2CLIM1A = RCLIM1A03;
rename R3CLIM1A = RCLIM1A12;
rename R1STOOPA = RSTOOPA01;
rename R2STOOPA = RSTOOPA03;
rename R3STOOPA = RSTOOPA12;
rename R1LIFTA  = RLIFTA01;
rename R2LIFTA  = RLIFTA03;
rename R3LIFTA  = RLIFTA12;
rename R1DIMEA  = RDIMEA01;
rename R2DIMEA  = RDIMEA03;
rename R3DIMEA  = RDIMEA12;
rename R1ARMSA  = RARMSA01;
rename R2ARMSA  = RARMSA03;
rename R3ARMSA  = RARMSA12;
rename R1PUSHA  = RPUSHA01;
rename R2PUSHA  = RPUSHA03;
rename R3PUSHA  = RPUSHA12;
/*ADL Summary: sum ADLs where respondent reports any difficulty*/
rename R1ADLA    = RADLA01;
rename R2ADLA    = RADLA03;
rename R3ADLA    = RADLA12;
rename R1ADLAM   = RADLAM01;
rename R2ADLAM   = RADLAM03;
rename R3ADLAM   = RADLAM12;
rename R1ADLA_M  = RADLA_M_01;
rename R2ADLA_M  = RADLA_M_03;
rename R3ADLA_M  = RADLA_M_12;
rename R1ADLAM_M = RADLAM_M_01;
rename R2ADLAM_M = RADLAM_M_03;
rename R3ADLAM_M = RADLAM_M_12;
rename R1ADLWA   = RADLWA01;
rename R2ADLWA   = RADLWA03;
rename R3ADLWA   = RADLWA12;
rename R1ADLWAM  = RADLWAM01;
rename R2ADLWAM  = RADLWAM03;
rename R3ADLWAM  = RADLWAM12;
/*IADL Summary: sum IADLs where respondent reports any difficulty*/
rename R1IADLZA_M  = RIADLZA_M_01;
rename R2IADLZA_M  = RIADLZA_M_03;
rename R3IADLZA_M  = RIADLZA_M_12;
rename R1IADLZAM_M = RIADLZAM_M_01;
rename R2IADLZAM_M = RIADLZAM_M_03;
rename R3IADLZAM_M = RIADLZAM_M_12;
/*Mental health (CESD score)*/
rename R1DEPRES  = RDEPRES01;
rename R2DEPRES  = RDEPRES03;
rename R3DEPRES  = RDEPRES12;
rename R1EFFORT  = REFFORT01;
rename R2EFFORT  = REFFORT03;
rename R3EFFORT  = REFFORT12;
rename R1SLEEPR  = RSLEEPR01;
rename R2SLEEPR  = RSLEEPR03;
rename R3SLEEPR  = RSLEEPR12;
rename R1WHAPPY  = RWHAPPY01;
rename R2WHAPPY  = RWHAPPY03;
rename R3WHAPPY  = RWHAPPY12;
rename R1FLONE   = RFLONE01;
rename R2FLONE   = RFLONE03;
rename R3FLONE   = RFLONE12;
rename R1ENLIFE  = RENLIFE01;
rename R2ENLIFE  = RENLIFE03;
rename R3ENLIFE  = RENLIFE12;
rename R1FSAD    = RFSAD01;
rename R2FSAD    = RFSAD03;
rename R3FSAD    = RFSAD12;
rename R1FTIRED  = RFTIRED01;
rename R2FTIRED  = RFTIRED03;
rename R3FTIRED  = RFTIRED12;
rename R1ENERG   = RENERG01;
rename R2ENERG   = RENERG03;
rename R3ENERG   = RENERG12;
rename R1CESD_M  = RCESD_M_01;
rename R2CESD_M  = RCESD_M_03;
rename R3CESD_M  = RCESD_M_12;
rename R1CESDM_M = RCESDM_M_01;
rename R2CESDM_M = RCESDM_M_03;
rename R3CESDM_M = RCESDM_M_12;
/*Doctor diagnosed health problems: ever have condition*/
rename R1HIBPE    = RHIBPE01;
rename R2HIBPE    = RHIBPE03;
rename R3HIBPE    = RHIBPE12;
rename R1DIABE    = RDIABE01;
rename R2DIABE    = RDIABE03;
rename R3DIABE    = RDIABE12;
rename R1CANCRE   = RCANCRE01;
rename R2CANCRE   = RCANCRE03;
rename R3CANCRE   = RCANCRE12;
rename R1HEARTE_M = RHEARTE_M_01;
rename R2HEARTE_M = RHEARTE_M_03;
rename R3HEARTE_M = RHEARTE_M_12;
rename R1STROKE   = RSTROKE01;
rename R2STROKE   = RSTROKE03;
rename R3STROKE   = RSTROKE12;
/*BMI*/
rename R1BMI     = RBMI01;
rename R2BMI     = RBMI03;
rename R3BMI     = RBMI12;
rename R1BMIA    = RBMIA01;
rename R2BMIA    = RBMIA03;
rename R3BMIA    = RBMIA12;
rename R1HEIGHT  = RHEIGHT01;
rename R2HEIGHT  = RHEIGHT03;
rename R3HEIGHT  = RHEIGHT12;
rename R1HEIGHTA = RHEIGHTA01;
rename R2HEIGHTA = RHEIGHTA03;
rename R3HEIGHTA = RHEIGHTA12;
rename R1WEIGHT  = RWEIGHT01;
rename R2WEIGHT  = RWEIGHT03;
rename R3WEIGHT  = RWEIGHT12;
rename R1WEIGHTA = RWEIGHTA01;
rename R2WEIGHTA = RWEIGHTA03;
rename R3WEIGHTA = RWEIGHTA12;
/*Health behaviors: physical activity or exercise*/
rename R1VIGACT = RVIGACT01;
rename R2VIGACT = RVIGACT03;
rename R3VIGACT = RVIGACT12;
/*Health behaviors: drinking*/
rename R1DRINK  = RDRINK01;
rename R2DRINK  = RDRINK03;
rename R3DRINK  = RDRINK12;
rename R1DRINKD = RDRINKD01;
rename R2DRINKD = RDRINKD03;
rename R3DRINKD = RDRINKD12;
rename R1DRINKN = RDRINKN01;
rename R2DRINKN = RDRINKN03;
rename R3DRINKN = RDRINKN12;
/*Health behaviors: smoking (cigarettes)*/
rename R1SMOKEV = RSMOKEV01;
rename R2SMOKEV = RSMOKEV03;
rename R3SMOKEV = RSMOKEV12;
rename R1SMOKEN = RSMOKEN01;
rename R2SMOKEN = RSMOKEN03;
rename R3SMOKEN = RSMOKEN12;
rename R1SMOKET = RSMOKET01;
rename R2SMOKET = RSMOKET03;
rename R3SMOKET = RSMOKET12;

/**********Label variables**********/
/*Self-Report of Health*/
	label R1SHLT = "rshlt01: 2001 R Self-report of health";
	label R2SHLT = "rshlt03: 2003 R Self-report of health";
	label R3SHLT = "rshlt12: 2012 R Self-report of health";
	/*ADLs: raw recodes*/
	label R1DRESS  = "rdress01: 2001 R Difficulty-Dressing";
	label R2DRESS  = "rdress03: 2003 R Difficulty-Dressing";
	label R3DRESS  = "rdress12: 2012 R Difficulty-Dressing";
	label R1DRESSH = "rdressh01: 2001 R Gets help-Dressing";
	label R2DRESSH = "rdressh03: 2003 R Gets help-Dressing";
	label R3DRESSH = "rdressh12: 2012 R Gets help-Dressing";
	label R1WALKR  = "rwalkr01: 2001 R Difficulty-Walking across room";
	label R2WALKR  = "rwalkr03: 2003 R Difficulty-Walking across room";
	label R3WALKR  = "rwalkr12: 2012 R Difficulty-Walking across room";
	label R1WALKRE = "rwalkre01: 2001 R Equipment-Walking across room";
	label R2WALKRE = "rwalkre03: 2003 R Equipment-Walking across room";
	label R3WALKRE = "rwalkre12: 2012 R Equipment-Walking across room";
	label R1WALKRH = "rwalkrh01: 2001 R Gets help-Walking across room";
	label R2WALKRH = "rwalkrh03: 2003 R Gets help-Walking across room";
	label R3WALKRH = "rwalkrh12: 2012 R Gets help-Walking across room";
	label R1BATH   = "rbath01: 2001 R Difficulty-Bathing or showering";
	label R2BATH   = "rbath03: 2003 R Difficulty-Bathing or showering";
	label R3BATH   = "rbath12: 2012 R Difficulty-Bathing or showering";
	label R1BATHH  = "rbathh01: 2001 R Gets help-Bathing or showering";
	label R2BATHH  = "rbathh03: 2003 R Gets help-Bathing or showering";
	label R3BATHH  = "rbathh12: 2012 R Gets help-Bathing or showering";
	label R1EAT    = "reat01: 2001 R Difficulty-Eating";
	label R2EAT    = "reat03: 2003 R Difficulty-Eating";
	label R3EAT    = "reat12: 2012 R Difficulty-Eating";
	label R1EATH   = "reath01: 2001 R Gets help-Eating";
	label R2EATH   = "reath03: 2003 R Gets help-Eating";
	label R3EATH   = "reath12: 2012 R Gets help-Eating";
	label R1BED    = "rbed01: 2001 R Difficulty-Getting in/out of bed";
	label R2BED    = "rbed03: 2003 R Difficulty-Getting in/out of bed";
	label R3BED    = "rbed12: 2012 R Difficulty-Getting in/out of bed";
	label R1BEDE   = "rbede01: 2001 R Equipment-Getting in/out of bed";
	label R2BEDE   = "rbede03: 2003 R Equipment-Getting in/out of bed";
	label R3BEDE   = "rbede12: 2012 R Equipment-Getting in/out of bed";
	label R1BEDH   = "rbedh01: 2001 R Gets help-Getting in/out of bed";
	label R2BEDH   = "rbedh03: 2003 R Gets help-Getting in/out of bed";
	label R3BEDH   = "rbedh12: 2012 R Gets help-Getting in/out of bed";
	label R1TOILT  = "rtoilt01: 2001 R Difficulty-Using the toilet";
	label R2TOILT  = "rtoilt03: 2003 R Difficulty-Using the toilet";
	label R3TOILT  = "rtoilt12: 2012 R Difficulty-Using the toilet";
	label R1TOILTH = "rtoilth01: 2001 R Gets help-Using the toilet";
	label R2TOILTH = "rtoilth03: 2003 R Gets help-Using the toilet";
	label R3TOILTH = "rtoilth12: 2012 R Gets help-Using the toilet";
	/*ADLs:Some Difficulty*/
	label R1WALKRA = "rwalkra01: 2001 R Some difficulty-Walking across room";
	label R2WALKRA = "rwalkra03: 2003 R Some difficulty-Walking across room";
	label R3WALKRA = "rwalkra12: 2012 R Some difficulty-Walking across room";
	label R1DRESSA = "rdressa01: 2001 R Some difficulty-Dressing";
	label R2DRESSA = "rdressa03: 2003 R Some difficulty-Dressing";
	label R3DRESSA = "rdressa12: 2012 R Some difficulty-Dressing";
	label R1BATHA  = "rbatha01: 2001 R Some difficulty-Bathing or showering";
	label R2BATHA  = "rbatha03: 2003 R Some difficulty-Bathing or showering";
	label R3BATHA  = "rbatha12: 2012 R Some difficulty-Bathing or showering";
	label R1EATA   = "reata01: 2001 R Some difficulty-Bathing or showering";
	label R2EATA   = "reata03: 2003 R Some difficulty-Bathing or showering";
	label R3EATA   = "reata12: 2012 R Some difficulty-Bathing or showering";
	label R1BEDA   = "rbeda01: 2001 R Some difficulty-Getting in/out of bed";
	label R2BEDA   = "rbeda03: 2003 R Some difficulty-Getting in/out of bed";
	label R3BEDA   = "rbeda12: 2012 R Some difficulty-Getting in/out of bed";
	label R1TOILTA = "rtoilta01: 2001 R Some difficulty-Using the toilet";
	label R2TOILTA = "rtoilta03: 2003 R Some difficulty-Using the toilet";
	label R3TOILTA = "rtoilta12: 2012 R Some difficulty-Using the toilet";
	/*IADLs: raw recodes*/
	label R1MONEY = "rmoney01: 2001 R Difficulty-Managing money";
	label R2MONEY = "rmoney03: 2003 R Difficulty-Managing money";
	label R3MONEY = "rmoney12: 2012 R Difficulty-Managing money";
	label R1MEDS  = "rmeds01: 2001 R Difficulty-Taking medications";
	label R2MEDS  = "rmeds03: 2003 R Difficulty-Taking medications";
	label R3MEDS  = "rmeds12: 2012 R Difficulty-Taking medications";
	label R1SHOP  = "rshop01: 2001 R Difficulty-Shopping for groceries";
	label R2SHOP  = "rshop03: 2003 R Difficulty-Shopping for groceries";
	label R3SHOP  = "rshop12: 2012 R Difficulty-Shopping for groceries";
	label R1MEALS = "rmeals01: 2001 R Difficulty-Preparing hot meals";
	label R2MEALS = "rmeals03: 2003 R Difficulty-Preparing hot meals";
	label R3MEALS = "rmeals12: 2012 R Difficulty-Preparing hot meals";
	/*IADLs:Some Difficulty*/
	label R1MONEYA = "rmoneya01: 2001 R Some difficulty-Managing money";
	label R2MONEYA = "rmoneya03: 2003 R Some difficulty-Managing money";
	label R3MONEYA = "rmoneya12: 2012 R Some difficulty-Managing money";
	label R1MEDSA  = "rmedsa01: 2001 R Some difficulty-Taking medications";
	label R2MEDSA  = "rmedsa03: 2003 R Some difficulty-Taking medications";
	label R3MEDSA  = "rmedsa12: 2012 R Some difficulty-Taking medications";
	label R1SHOPA  = "rshopa01: 2001 R Some difficulty-Shopping for groceries";
	label R2SHOPA  = "rshopa03: 2003 R Some difficulty-Shopping for groceries";
	label R3SHOPA  = "rshopa12: 2012 R Some difficulty-Shopping for groceries";
	label R1MEALSA = "rmealsa01: 2001 R Some difficulty-Preparing hot meals";
	label R2MEALSA = "rmealsa03: 2003 R Some difficulty-Preparing hot meals";
	label R3MEALSA = "rmealsa12: 2012 R Some difficulty-Preparing hot meals";
	/*Other functional limitations: raw recodes*/
	label R1WALKS = "rwalks01: 2001 R Difficulty-Walking several blocks";
	label R2WALKS = "rwalks03: 2003 R Difficulty-Walking several blocks";
	label R3WALKS = "rwalks12: 2012 R Difficulty-Walking several blocks";
	label R1JOG   = "rjog01: 2001 R Difficulty-Run/Jogging one km";
	label R2JOG   = "rjog03: 2003 R Difficulty-Run/Jogging one km";
	label R3JOG   = "rjog12: 2012 R Difficulty-Run/Jogging one km";
	label R1WALK1 = "rwalk1_01: 2001 R Difficulty-Walking one block";
	label R2WALK1 = "rwalk1_03: 2003 R Difficulty-Walking one block";
	label R3WALK1 = "rwalk1_12: 2012 R Difficulty-Walking one block";
	label R1SIT   = "rsit01: 2001 R Difficulty-Sitting for 2 hours";
	label R2SIT   = "rsit03: 2003 R Difficulty-Sitting for 2 hours";
	label R3SIT   = "rsit12: 2012 R Difficulty-Sitting for 2 hours";
	label R1CHAIR = "rchair01: 2001 R Difficulty-Getting up from chair";
	label R2CHAIR = "rchair03: 2003 R Difficulty-Getting up from chair";
	label R3CHAIR = "rchair12: 2012 R Difficulty-Getting up from chair";
	label R1CLIMS = "rclims01: 2001 R Difficulty-Climbing sev flts stairs";
	label R2CLIMS = "rclims03: 2003 R Difficulty-Climbing sev flts stairs";
	label R3CLIMS = "rclims12: 2012 R Difficulty-Climbing sev flts stairs";
	label R1CLIM1 = "rclim1_01: 2001 R Difficulty-Climbing one flts stairs";
	label R2CLIM1 = "rclim1_03: 2003 R Difficulty-Climbing one flts stairs";
	label R3CLIM1 = "rclim1_12: 2012 R Difficulty-Climbing one flts stairs";
	label R1STOOP = "rstoop01: 2001 R Difficulty-Stoop/kneel/crouching";
	label R2STOOP = "rstoop03: 2003 R Difficulty-Stoop/kneel/crouching";
	label R3STOOP = "rstoop12: 2012 R Difficulty-Stoop/kneel/crouching";
	label R1LIFT  = "rlift01: 2001 R Difficulty-Lift/carrying 5 kgs";
	label R2LIFT  = "rlift03: 2003 R Difficulty-Lift/carrying 5 kgs";
	label R3LIFT  = "rlift12: 2012 R Difficulty-Lift/carrying 5 kgs";
	label R1DIME  = "rdime01: 2001 R Difficulty-Picking up a coin";
	label R2DIME  = "rdime03: 2003 R Difficulty-Picking up a coin";
	label R3DIME  = "rdime12: 2012 R Difficulty-Picking up a coin";
	label R1ARMS  = "rarms01: 2001 R Difficulty-Reach/extending arms up";
	label R2ARMS  = "rarms03: 2003 R Difficulty-Reach/extending arms up";
	label R3ARMS  = "rarms12: 2012 R Difficulty-Reach/extending arms up";
	label R1PUSH  = "rpush01: 2001 R Difficulty-Push/pulling large objects";
	label R2PUSH  = "rpush03: 2003 R Difficulty-Push/pulling large objects";
	label R3PUSH  = "rpush12: 2012 R Difficulty-Push/pulling large objects";
	/*Other functional limitations: some difficulty*/
	label R1WALKSA = "rwalksa01: 2001 R Some difficulty-Walking several blocks";
	label R2WALKSA = "rwalksa03: 2003 R Some difficulty-Walking several blocks";
	label R3WALKSA = "rwalksa12: 2012 R Some difficulty-Walking several blocks";
	label R1JOGA   = "rjoga01: 2001 R Some difficulty-Run/Jogging one km";
	label R2JOGA   = "rjoga03: 2003 R Some difficulty-Run/Jogging one km";
	label R3JOGA   = "rjoga12: 2012 R Some difficulty-Run/Jogging one km";
	label R1WALK1A = "rwalk1a01: 2001 R Some difficulty-Walking one block";
	label R2WALK1A = "rwalk1a03: 2003 R Some difficulty-Walking one block";
	label R3WALK1A = "rwalk1a12: 2012 R Some difficulty-Walking one block";
	label R1SITA   = "rsita01: 2001 R Some difficulty-Sitting for 2 hours";
	label R2SITA   = "rsita03: 2003 R Some difficulty-Sitting for 2 hours";
	label R3SITA   = "rsita12: 2012 R Some difficulty-Sitting for 2 hours";
	label R1CHAIRA = "rchaira01: 2001 R Some difficulty-Getting up from chair";
	label R2CHAIRA = "rchaira03: 2003 R Some difficulty-Getting up from chair";
	label R3CHAIRA = "rchaira12: 2012 R Some difficulty-Getting up from chair";
	label R1CLIMSA = "rclimsa01: 2001 R Some difficulty-Climbing sev flts stairs";
	label R2CLIMSA = "rclimsa03: 2003 R Some difficulty-Climbing sev flts stairs";
	label R3CLIMSA = "rclimsa12: 2012 R Some difficulty-Climbing sev flts stairs";
	label R1CLIM1A = "rclim1a01: 2001 R Some difficulty-Climbing one flts stairs";
	label R2CLIM1A = "rclim1a03: 2003 R Some difficulty-Climbing one flts stairs";
	label R3CLIM1A = "rclim1a12: 2012 R Some difficulty-Climbing one flts stairs";
	label R1STOOPA = "rstoopa01: 2001 R Some difficulty-Stoop/kneel/crouching";
	label R2STOOPA = "rstoopa03: 2003 R Some difficulty-Stoop/kneel/crouching";
	label R3STOOPA = "rstoopa12: 2012 R Some difficulty-Stoop/kneel/crouching";
	label R1LIFTA  = "rlifta01: 2001 R Some difficulty-Lift/carrying 5 kgs";
	label R2LIFTA  = "rlifta03: 2003 R Some difficulty-Lift/carrying 5 kgs";
	label R3LIFTA  = "rlifta12: 2012 R Some difficulty-Lift/carrying 5 kgs";
	label R1DIMEA  = "rdimea01: 2001 R Some difficulty-Picking up a coin";
	label R2DIMEA  = "rdimea03: 2003 R Some difficulty-Picking up a coin";
	label R3DIMEA  = "rdimea12: 2012 R Some difficulty-Picking up a coin";
	label R1ARMSA  = "rarmsa01: 2001 R Some difficulty-Reach/extending arms up";
	label R2ARMSA  = "rarmsa03: 2003 R Some difficulty-Reach/extending arms up";
	label R3ARMSA  = "rarmsa12: 2012 R Some difficulty-Reach/extending arms up";
	label R1PUSHA  = "rpusha01: 2001 R Some difficulty-Push/pulling large objects";
	label R2PUSHA  = "rpusha03: 2003 R Some difficulty-Push/pulling large objects";
	label R3PUSHA  = "rpusha12: 2012 R Some difficulty-Push/pulling large objects";
	/*ADL Summary: sum ADLs where respondent reports any difficulty*/
	label R1ADLA    = "radla01: 2001 R Some difficulty-ADLs 0-5";
	label R2ADLA    = "radla03: 2003 R Some difficulty-ADLs 0-5";
	label R3ADLA    = "radla12: 2012 R Some difficulty-ADLs 0-5";
	label R1ADLAM   = "radlam01: 2001 R Some difficulty-Missings in ADLs 0-5 Score";
	label R2ADLAM   = "radlam03: 2003 R Some difficulty-Missings in ADLs 0-5 Score";
	label R3ADLAM   = "radlam12: 2012 R Some difficulty-Missings in ADLs 0-5 Score";
	label R1ADLA_M  = "radla_m_01: 2001 R Some difficulty-ADLs 0-4";
	label R2ADLA_M  = "radla_m_03: 2003 R Some difficulty-ADLs 0-4";
	label R3ADLA_M  = "radla_m_12: 2012 R Some difficulty-ADLs 0-4";
	label R1ADLAM_M = "radlam_m_01: 2001 R Some difficulty-Missings in ADLs 0-4 Score";
	label R2ADLAM_M = "radlam_m_03: 2003 R Some difficulty-Missings in ADLs 0-4 Score";
	label R3ADLAM_M = "radlam_m_12: 2012 R Some difficulty-Missings in ADLs 0-4 Score";
	label R1ADLWA   = "radlwa01: 2001 R Some difficulty-ADLs: Wallace 0-3";
	label R2ADLWA   = "radlwa03: 2003 R Some difficulty-ADLs: Wallace 0-3";
	label R3ADLWA   = "radlwa12: 2012 R Some difficulty-ADLs: Wallace 0-3";
	label R1ADLWAM  = "radlwam01: 2001 R Some difficulty-Missings Wallace Score 0-3";
	label R2ADLWAM  = "radlwam03: 2003 R Some difficulty-Missings Wallace Score 0-3";
	label R3ADLWAM  = "radlwam12: 2012 R Some difficulty-Missings Wallace Score 0-3";
	/*IADL Summary: sum IADLs where respondent reports any difficulty*/
	label R1IADLZA_M  = "riadlza_m_01: 2001 R Some difficulty-IADLs 0-4";
	label R2IADLZA_M  = "riadlza_m_03: 2003 R Some difficulty-IADLs 0-4";
	label R3IADLZA_M  = "riadlza_m_12: 2012 R Some difficulty-IADLs 0-4";
	label R1IADLZAM_M = "riadlzam_m_01: 2001 R Some difficulty-Missings in IADLs Score";
	label R2IADLZAM_M = "riadlzam_m_03: 2003 R Some difficulty-Missings in IADLs Score";
	label R3IADLZAM_M = "riadlzam_m_12: 2012 R Some difficulty-Missings in IADLs Score";
	/*Mental health (CESD score)*/
	label R1DEPRES  = "rdepres01: 2001 R CESD-Felt depressed";
	label R2DEPRES  = "rdepres03: 2003 R CESD-Felt depressed";
	label R3DEPRES  = "rdepres12: 2012 R CESD-Felt depressed";
	label R1EFFORT  = "reffort01: 2001 R CESD-Everything an effort";
	label R2EFFORT  = "reffort03: 2003 R CESD-Everything an effort";
	label R3EFFORT  = "reffort12: 2012 R CESD-Everything an effort";
	label R1SLEEPR  = "rsleepr01: 2001 R CESD-Sleep was restless";
	label R2SLEEPR  = "rsleepr03: 2003 R CESD-Sleep was restless";
	label R3SLEEPR  = "rsleepr12: 2012 R CESD-Sleep was restless";
	label R1WHAPPY  = "rwhappy01: 2001 R CESD-Felt happy";
	label R2WHAPPY  = "rwhappy03: 2003 R CESD-Felt happy";
	label R3WHAPPY  = "rwhappy12: 2012 R CESD-Felt happy";
	label R1FLONE   = "rflone01: 2001 R CESD-Felt lonely";
	label R2FLONE   = "rflone03: 2003 R CESD-Felt lonely";
	label R3FLONE   = "rflone12: 2012 R CESD-Felt lonely";
	label R1ENLIFE  = "renlife01: 2001 R CESD-Enjoyed life";
	label R2ENLIFE  = "renlife03: 2003 R CESD-Enjoyed life";
	label R3ENLIFE  = "renlife12: 2012 R CESD-Enjoyed life";
	label R1FSAD    = "rfsad01: 2001 R CESD-Felt sad";
	label R2FSAD    = "rfsad03: 2003 R CESD-Felt sad";
	label R3FSAD    = "rfsad12: 2012 R CESD-Felt sad";
	label R1FTIRED  = "rftired01: 2001 R CESD-Felt tired";
	label R2FTIRED  = "rftired03: 2003 R CESD-Felt tired";
	label R3FTIRED  = "rftired12: 2012 R CESD-Felt tired";
	label R1ENERG   = "renerg01: 2001 R CESD-Had a lot of energy";
	label R2ENERG   = "renerg03: 2003 R CESD-Had a lot of energy";
	label R3ENERG   = "renerg12: 2012 R CESD-Had a lot of energy";
	label R1CESD_M  = "rcesd_m_01: 2001 R CESD Modified Score";
	label R2CESD_M  = "rcesd_m_03: 2003 R CESD Modified Score";
	label R3CESD_M  = "rcesd_m_12: 2012 R CESD Modified Score";
	label R1CESDM_M = "rcesdm_m_01: 2001 R CESD-Missings in Modified Score";
	label R2CESDM_M = "rcesdm_m_03: 2003 R CESD-Missings in Modified Score";
	label R3CESDM_M = "rcesdm_m_12: 2012 R CESD-Missings in modified Score";
	/*Doctor diagnosed health problems: ever have condition*/
	label R1HIBPE    = "rhibpe01: 2001 R Ever had high blood pressure";
	label R2HIBPE    = "rhibpe03: 2003 R Ever had high blood pressure";
	label R3HIBPE    = "rhibpe12: 2012 R Ever had high blood pressure";
	label R1DIABE    = "rdiabe01: 2001 R Ever had diabetes";
	label R2DIABE    = "rdiabe03: 2003 R Ever had diabetes";
	label R3DIABE    = "rdiabe12: 2012 R Ever had diabetes";
	label R1CANCRE   = "rcancre01: 2001 R Ever had cancer";
	label R2CANCRE   = "rcancre03: 2003 R Ever had cancer";
	label R3CANCRE   = "rcancre12: 2012 R Ever had cancer";
	label R1HEARTE_M = "rhearte_m_01: 2001 R Ever had heart problems";
	label R2HEARTE_M = "rhearte_m_03: 2003 R Ever had heart problems";
	label R3HEARTE_M = "rhearte_m_12: 2012 R Ever had heart problems";
	label R1STROKE   = "rstroke01: 2001 R Ever had stroke";
	label R2STROKE   = "rstroke03: 2003 R Ever had stroke";
	label R3STROKE   = "rstroke12: 2012 R Ever had stroke";
	/*BMI*/
	label R1BMI     = "rbmi01: 2001 R Body Mass Index=kg/m2";
	label R2BMI     = "rbmi03: 2003 R Body Mass Index=kg/m2";
	label R3BMI     = "rbmi12: 2012 R Body Mass Index=kg/m2";
	label R1BMIA    = "rbmia01: 2001 R Measured Body Mass Index=kg/m2";
	label R2BMIA    = "rbmia03: 2003 R Measured Body Mass Index=kg/m2";
	label R3BMIA    = "rbmia12: 2012 R Measured Body Mass Index=kg/m2";
	label R1HEIGHT  = "rheight01: 2001 R Height in meters";
	label R2HEIGHT  = "rheight03: 2003 R Height in meters";
	label R3HEIGHT  = "rheight12: 2012 R Height in meters";
	label R1HEIGHTA = "rheighta01: 2001 R Measured Height in meters";
	label R2HEIGHTA = "rheighta03: 2003 R Measured Height in meters";
	label R3HEIGHTA = "rheighta12: 2012 R Measured Height in meters";
	label R1WEIGHT  = "rweight01: 2001 R Weight in kilograms";
	label R2WEIGHT  = "rweight03: 2003 R Weight in kilograms";
	label R3WEIGHT  = "rweight12: 2012 R Weight in kilograms";
	label R1WEIGHTA = "rweighta01: 2001 R Measured Weight in kilograms";
	label R2WEIGHTA = "rweighta03: 2003 R Measured Weight in kilograms";
	label R3WEIGHTA = "rweighta12: 2012 R Measured Weight in kilograms";
	/*Health behaviors: physical activity or exercise*/
	label R1VIGACT  = "rvigact01: 2001 R Wtr vigorus phys act 3+/wk";
	label R2VIGACT  = "rvigact03: 2003 R Wtr vigorus phys act 3+/wk";
	label R3VIGACT  = "rvigact12: 2012 R Wtr vigorus phys act 3+/wk";
	/*Health behaviors: drinking*/
	label R1DRINK  = "rdrink01: 2001 R Ever drinks any alcohol";
	label R2DRINK  = "rdrink03: 2003 R Ever drinks any alcohol";
	label R3DRINK  = "rdrink12: 2012 R Ever drinks any alcohol";
	label R1DRINKD = "rdrinkd01: 2001 R Number of days/week drinks";
	label R2DRINKD = "rdrinkd03: 2003 R Number of days/week drinks";
	label R3DRINKD = "rdrinkd12: 2012 R Number of days/week drinks";
	label R1DRINKN = "rdrinkn01: 2001 R Number of drinks/day when drinks";
	label R2DRINKN = "rdrinkn03: 2003 R Number of drinks/day when drinks";
	label R3DRINKN = "rdrinkn12: 2012 R Number of drinks/day when drinks";
	/*Health behaviors: smoking (cigarettes)*/
	label R1SMOKEV = "rsmokev01: 2001 R Ever smoked";
	label R2SMOKEV = "rsmokev03: 2003 R Ever smoked";
	label R3SMOKEV = "rsmokev12: 2012 R Ever smoked";
	label R1SMOKEN = "rsmoken01: 2001 R Smokes now";
	label R2SMOKEN = "rsmoken03: 2003 R Smokes now";
	label R3SMOKEN = "rsmoken12: 2012 R Smokes now";
	label R1SMOKET = "rsmoket01: 2001 R Number of cigarettes/day";
	label R2SMOKET = "rsmoket03: 2003 R Number of cigarettes/day";
	label R3SMOKET = "rsmoket12: 2012 R Number of cigarettes/day";
run;

	



*************************************************************Section D: Cognition**************************************************************;
/***********Keep variables**********/
data h_mhas_D;
set Harmo.h_mhas;
keep
UNHHIDNP
R1NOVISUAL R2NOVISUAL R3NOVISUAL R1NOPENCIL R2NOPENCIL R3NOPENCIL                                               /*Cognition Testing Conditions*/
R3SLFMEM   R3PSTMEM                                                                                             /*Self-Reported Memory*/
R1IMRC_M   R2IMRC_M   R3IMRC_M                                                                                  /*Immediate Word Recall*/
R1DLRC_M   R2DLRC_M   R3DLRC_M                                                                                  /*Delayed Word Recall*/
R1TR8_M    R2TR8_M    R3TR8_M                                                                                   /*Summary Scores*/
R1IDRAW2   R2IDRAW2   R3IDRAW1   R1DDRAW2   R2DDRAW2   R3DDRAW1                                                 /*Picture Drawing*/
R3VERBF                                                                                                         /*Verbal Fluency*/
R1VSCAN    R2VSCAN    R3VSCAN                                                                                   /*Visual Scanning*/
R3BWC20                                                                                                         /*Backwards Counting From 20*/
R2DY       R3DY       R2MO       R3MO       R2YR       R3YR       R2ORIENT_M  R3ORIENT_M                        /*Date Naming/Orientation*/
;

/**********Rename variables**********/
/*ID*/
*rename UNHHIDNP = RID;
/*Cognition testing conditions*/
rename R1NOVISUAL = RNOVISUAL01;
rename R2NOVISUAL = RNOVISUAL03;
rename R3NOVISUAL = RNOVISUAL12;
rename R1NOPENCIL = RNOPENCIL01;
rename R2NOPENCIL = RNOPENCIL03;
rename R3NOPENCIL = RNOPENCIL12;
/*Self-reported memory*/
rename R3SLFMEM = RSLFMEM12;
rename R3PSTMEM = RPSTMEM12;
/*Immediate word recall*/
rename R1IMRC_M = RIMRC_M_01;
rename R2IMRC_M = RIMRC_M_03;
rename R3IMRC_M = RIMRC_M_12;
/*Delayed word recall*/
rename R1DLRC_M = RDLRC_M_01;
rename R2DLRC_M = RDLRC_M_03;
rename R3DLRC_M = RDLRC_M_12;
/*Summary scores*/
rename R1TR8_M  = RTR8_M_01;
rename R2TR8_M  = RTR8_M_03;
rename R3TR8_M  = RTR8_M_12;
/*Picture Drawing*/
rename R1IDRAW2 = RIDRAW2_01;
rename R2IDRAW2 = RIDRAW2_03;
rename R3IDRAW1 = RIDRAW1_12;
rename R1DDRAW2 = RDDRAW2_01;
rename R2DDRAW2 = RDDRAW2_03;
rename R3DDRAW1 = RDDRAW1_12;
/*Verbal Fluency*/
rename R3VERBF  = RVERBF12;
/*Visual Scanning*/
rename R1VSCAN  = RVSCAN01;
rename R2VSCAN  = RVSCAN03;
rename R3VSCAN  = RVSCAN12;
/*Backwards counting from 20*/ 
rename R3BWC20  = RBWC20_12;
/*Date naming/orientation*/
rename R2DY = RDY03;
rename R3DY = RDY12;
rename R2MO = RMO03;
rename R3MO = RMO12;
rename R2YR = RYR03;
rename R3YR = RYR12;
rename R2ORIENT_M = RORIENT_M_03;
rename R3ORIENT_M = RORIENT_M_12;

/**********Label variables**********/
	/*Cognition testing conditions*/
	label R1NOVISUAL = "rnovisual01: 2001 R Visual Problems";
	label R2NOVISUAL = "rnovisual03: 2003 R Visual Problems";
	label R3NOVISUAL = "rnovisual12: 2012 R Visual Problems";
	label R1NOPENCIL = "rnopencil01: 2001 R Problem Holding a Pencil";
	label R2NOPENCIL = "rnopencil03: 2003 R Problem Holding a Pencil";
	label R3NOPENCIL = "rnopencil12: 2012 R Problem Holding a Pencil";
	/*Self-reported memory*/
	label R3SLFMEM = "rslfmem12: 2012 R Self-Rated Memory";
	label R3PSTMEM = "rpstmem12: 2012 R Memory Compared to the Past";
	/*Immediate word recall*/
	label R1IMRC_M = "rimrc_m_01: 2001 R Immediate Word Recall 0-8";
	label R2IMRC_M = "rimrc_m_03: 2003 R Immediate Word Recall 0-8";
	label R3IMRC_M = "rimrc_m_12: 2012 R Immediate Word Recall 0-8";
	/*Delayed word recall*/
	label R1DLRC_M = "rdlrc_m_01: 2001 R Delayed Word Recall 0-8";
	label R2DLRC_M = "rdlrc_m_03: 2003 R Delayed Word Recall 0-8";
	label R3DLRC_M = "rdlrc_m_12: 2012 R Delayed Word Recall 0-8";
	/*Summary scores*/
	label R1TR8_M = "rtr8_m_01: 2001 R Word Recall Summary Score 0-16";
	label R2TR8_M = "rtr8_m_03: 2003 R Word Recall Summary Score 0-16";
	label R3TR8_M = "rtr8_m_12: 2012 R Word Recall Summary Score 0-16";
	/*Picture Drawing*/
	label R1IDRAW2 = "ridraw2_01: 2001 R Picture Drawing immediate 2 fig";
	label R2IDRAW2 = "ridraw2_03: 2003 R Picture Drawing immediate 2 fig";
	label R3IDRAW1 = "ridraw1_12: 2012 R Picture Drawing immediate 1 fig";
	label R1DDRAW2 = "rddraw2_01: 2001 R Picture Drawing delayed 2 fig";
	label R2DDRAW2 = "rddraw2_03: 2003 R Picture Drawing delayed 2 fig";
	label R3DDRAW1 = "rddraw1_12: 2012 R Picture Drawing delayed 1 fig";
	/*Verbal Fluency*/
	label R3VERBF = "rverbf12: 2012 R Verbal Fluency Score";
	/*Visual Scanning*/
	label R1VSCAN = "rvscan01: 2001 R Visual Scanning";
	label R2VSCAN = "rvscan03: 2003 R Visual Scanning";
	label R3VSCAN = "rvscan12: 2012 R Visual Scanning";
	/*Backwards counting from 20*/ 
	label R3BWC20 = "rbwc20_12: 2012 R Backwards Counting From 20";
	/*Date naming/orientation*/
	label R2DY = "rdy03: 2003 R Date Naming: Day of the Month";
	label R3DY = "rdy12: 2012 R Date Naming: Day of the Month";
	label R2MO = "rmo03: 2003 R Date Naming: Month";
	label R3MO = "rmo12: 2012 R Date Naming: Month";
	label R2YR = "ryr03: 2003 R Date Naming: Year";
	label R3YR = "ryr12: 2012 R Date Naming: Year";
	label R2ORIENT_M = "rorient_m_03: 2003 R Date Naming Correctness";
	label R3ORIENT_M = "rorient_m_12: 2012 R Date Naming Correctness";
run;







**************************************************Section E: Financial and Housing Wealth*******************************************************;
/***********Keep variables**********/
data h_mhas_E;
set Harmo.h_mhas;
keep
UNHHIDNP
H1ATOTB  H2ATOTB  H3ATOTB  H1AFTOTB H2AFTOTB H3AFTOTB                                                           /*Total Wealth*/
;

/**********Rename variables**********/
/*ID*/
*rename UNHHIDNP = RID;
/*Total wealth*/
rename H1ATOTB  = HATOTB01;
rename H2ATOTB  = HATOTB03;
rename H3ATOTB  = HATOTB12;
rename H1AFTOTB = HAFTOTB01;
rename H2AFTOTB = HAFTOTB03;
rename H3AFTOTB = HAFTOTB12;

/**********Label variables**********/
	/*Total wealth*/
	label H1ATOTB  = "hatotb01:2001 total all assets inc. 2nd hm";
	label H2ATOTB  = "hatotb03:2003 total all assets inc. 2nd hm";
	label H3ATOTB  = "hatotb12:2012 total all assets inc. 2nd hm";
	label H1AFTOTB = "haftotb01:2001 flag total all assets inc. 2nd hm";
	label H2AFTOTB = "haftotb03:2003 flag total all assets inc. 2nd hm";
	label H3AFTOTB = "haftotb12:2012 flag total all assets inc. 2nd hm";
run;




*************************************************************Section F: Income******************************************************************;
/***********Keep variables**********/
data h_mhas_F;
set Harmo.h_mhas;
keep
UNHHIDNP
H1ITOT   H2ITOT   H3ITOT   H1IFTOT  H2IFTOT  H3IFTOT                                                            /*Total Household Income (respondent & spouse)*/                                                                                                                                                    
;

/**********Rename variables**********/
/*ID*/
*rename UNHHIDNP = RID;
/*Total household income (respondent & spouse)*/
rename H1ITOT  = HITOT01;
rename H2ITOT  = HITOT03;
rename H3ITOT  = HITOT12;
rename H1IFTOT = HIFTOT01;
rename H2IFTOT = HIFTOT03;
rename H3IFTOT = HIFTOT12;

/**********Label variables**********/
	/*Total household income (respondent & spouse)*/
	label H1ITOT = "hitot01:2001 Incm:H Total Income";
	label H2ITOT = "hitot03:2003 Incm:H Total Income";
	label H3ITOT = "hitot12:2012 Incm:H Total Income";
run;




********************************************************Section G: Family Structure*************************************************************;
/***********Keep variables**********/
data h_mhas_G;
set Harmo.h_mhas;
keep
UNHHIDNP
R1MOMAGE R2MOMAGE R3MOMAGE R1DADAGE R2DADAGE R3DADAGE                                                           /*Parents' Current Age or Age at Death*/
RAMEDUC_M RAFEDUC_M                                                                                             /*Parents'Education*/ 
;

/**********Rename variables**********/
/*ID*/
*rename UNHHIDNP = RID;
/*Parents' current age or age at death*/
rename R1MOMAGE = RMOMAGE01;
rename R2MOMAGE = RMOMAGE03;
rename R3MOMAGE = RMOMAGE12;
rename R1DADAGE = RDADAGE01;
rename R2DADAGE = RDADAGE03;
rename R3DADAGE = RDADAGE12;
/*Parents' education: keep RAMEDUC_M; RAFEDUC_M*/

/**********Label variables**********/
	/*Parents' current age or age at death*/
	label R1MOMAGE = "rmomage01: 2001 R Mother's age - current/at death";
	label R2MOMAGE = "rmomage03: 2003 R Mother's age - current/at death";
	label R3MOMAGE = "rmomage12: 2012 R Mother's age - current/at death";
	label R1DADAGE = "rdadage01: 2001 R Father's age - current/at death";
	label R2DADAGE = "rdadage03: 2003 R Father's age - current/at death";
	label R3DADAGE = "rdadage12: 2012 R Father's age - current/at death";
	/*Parents' education*/
	label RAMEDUC_M = "rameduc_m: R Mother's Education";
	label RAFEDUC_M = "rafeduc_m: R Father's Education";
run;




*******************************************************Section H: Employment History************************************************************;
/***********Keep variables**********/
data h_mhas_H;
set Harmo.h_mhas;
keep
UNHHIDNP
R1WORK R2WORK R3WORK                                                                                            /*Currently working for pay*/
R1LBRF_M R2LBRF_M R3LBRF_M                                                                                      /*Labor Force Status*/
R2INLBRF R3INLBRF                                                                                               /*In the Labor Force*/  
;

/**********Rename variables**********/
/*ID*/
*rename UNHHIDNP = RID;
/*Currently working for pay*/
rename R1WORK = RWORK01;
rename R2WORK = RWORK03;
rename R3WORK = RWORK12;
/*Labor force status*/
rename R1LBRF_M = RLBRF_M_01;
rename R2LBRF_M = RLBRF_M_03;
rename R3LBRF_M = RLBRF_M_12;
/*In the labor force*/
rename R2INLBRF = RINLBRF03;
rename R3INLBRF = RINLBRF12;

/**********Label variables**********/
	/*Currently working for pay*/
	label R1WORK = "rwork01: 2001 R Currently working for pay";
	label R2WORK = "rwork03: 2003 R Currently working for pay";
	label R3WORK = "rwork12: 2012 R Currently working for pay";
	/*Labor force atatus*/
	label R1LBRF_M = "rlbrf_m_01: 2001 R Labor force status";
	label R2LBRF_M = "rlbrf_m_03: 2003 R Labor force status";
	label R3LBRF_M = "rlbrf_m_12: 2012 R Labor force status";
	/*In the labor force*/
	label R2INLBRF = "rinlbrf03: 2003 R In the Labor Force";
	label R3INLBRF = "rinlbrf12: 2012 R In the Labor Force";
run; 




/**********************************************************************************************************************************************/
/*********************************************************Merge Harmonized Datasets************************************************************/
/**********************************************************************************************************************************************/ 

proc sort data = h_mhas_A; by unhhidnp; run;
proc sort data = h_mhas_B; by unhhidnp; run;
proc sort data = h_mhas_D; by unhhidnp; run;
proc sort data = h_mhas_E; by unhhidnp; run;
proc sort data = h_mhas_F; by unhhidnp; run;	
proc sort data = h_mhas_G; by unhhidnp; run;
proc sort data = h_mhas_H; by unhhidnp; run;

data mhas; 
merge h_mhas_A h_mhas_B h_mhas_D h_mhas_E h_mhas_F h_mhas_G h_mhas_H; 
	by unhhidnp; 
run;

/*
*save the dataset;
data created.mhas; set mhas; run; 
*/
