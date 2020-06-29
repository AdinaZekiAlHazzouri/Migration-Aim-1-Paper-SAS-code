
libname library 'C:\Users\\\\\\\harmonized dataset';
options fmtsearch = (library);
libname Raw 'C:\Users\\\\\\\raw datasets';
libname Harmo 'C:\Users\\\\\\\harmonized dataset';
libname Next 'C:\Users\\\\\\\next-of-kin raw datasets';
libname created 'C:\Users\\\\\\\SAS datasets';
run;


***********************************************Section A: Demographics, Identifiers,and Weights************************************************;
/*Demographics of respondents in 2001*/
data raw_a_2001;
set raw.sect_a_2001;
/***********Keep variables**********/
keep
unhhid 
ps3 
/*Marital status*/
a10--a18

/*Migration details*/
a22--a34
;
run;

/*Demographics of follow-up respondents in 2003*/
data raw_a_2003;
set raw.sect_a_2003;
/***********Keep variables**********/
keep
cunicah  
acthog  
ent2   

/*Marital status*/
a3--a6   

/*Migration details*/
a12--a33b   
;
run;

/*Demographics of new respondents in 2003*/
data raw_a_2003n;
set raw.sect_a_2003n;
keep
cunicah 
acthog
ent2  

/*Marital status*/
aa10--aa18
aa13a
/*Migration details*/
aa22--aa34
aa26a aa26b
;
run;

/*Demographics of follow-up respondents in 2012*/
data raw_a_2012;
set raw.sect_a_c_d_e_pc_f_h_i_em_2012;
keep
cunicah	
np	    
codent01 
acthog	
codent03 

/*Marital status*/
a3_12--a6_12

/*Migration details*/
a14_12--a33c_12
a29a2_12
;
run;

/*Demographics of new respondents in 2012*/
data raw_a_2012n;
set raw.sect_a_c_d_e_pc_f_h_i_em_2012;
keep
cunicah	  
np	      
codent01   /*=ps3*/
acthog	
codent03   /*=ent2*/

/*Marital status*/
aa10_12--aa18_2_12
aa12_2_12
aa15_2_12



/****Migration details****/
aa22_12--aa34_12
aa26_2_12
aa32b2_12
;
run;

***********************************************************Section C: Health************************************************************************;
/*Health of respondents in 2001*/
data raw_c_2001;
set raw.sect_c_2001;
keep
unhhid         /*Unique household ID*/
ps3            /*Individual code of respondent*/

c18    /*Year of cancer*/
c23    /*Year of heart attack*/
c32    /*Year of stroke*/
c57    /*Age of first smoke*/
;
run;

/*Health of respondents in 2003*/
data raw_c_2003;
set raw.sect_c_2003;
keep
cunicah  /*Household ID - 2001*/
acthog   /*Updated household ID 2001*/
ent2     /*Individual code of respondent*/

c18      /*Year of cancer (most recent)*/
c22b     /*Year of heart attack (most recent)*/
c30      /*Year of stroke (most recent)*/
c52      /*Age of first smoke*/
;
run;

/*Health of respondents in 2012*/
data raw_c_2012;
set raw.sect_a_c_d_e_pc_f_h_i_em_2012;
keep
cunicah	   /*Unique household ID - 2001*/
np	       /*Person number*/
codent01   /*Person identification code 2001 (=ps3)*/
acthog	   /*Update household code 2003*/
codent03   /*Person identification code 2003 (=ent2)*/

c18_1_12   /*Year of cancer (most recent)*/
c22b1_12   /*Year of heart attack (most recent)*/
c22b2_12   /*Age of heart attack (most recent)*/
c30_1_12   /*Year of stroke (most recent)*/
c30_2_12   /*Age of stroke (most recent)*/
c52_1_12   /*Age of first smoke*/
c52_2_12   /*Year of first smoke*/
c52_3_12
;
run;

***********************************************************Section I: Employment************************************************************************;
/*Employment of respondents in 2001*/
data raw_i_2001;
set raw.sect_i_2001;
keep
unhhid         /*Unique household ID*/
ps3            /*Individual code of respondent*/

i1 /*ever worked for pay*/
i2 /*ever worked without pay*/
i3 /*Year of first job*/
;
run;

/*Employment of respondents in 2003*/
data raw_i_2003;
set raw.sect_i_2003;
keep
cunicah  /*Household ID - 2001*/
acthog   /*Updated household ID 2001*/
ent2     /*Individual code of respondent*/

i1
i2 /*ever worked for pay (for new)*/
i3 /*ever worked without pay (for new)*/
i4 /*Year of first job (for new)*/
i16 /*currently work (for follow up)*/
i26 /*reason for not working (= 2 retired)*/
i27 /*ever worked without pay*/
;
run;

/*Employment of respondents in 2012*/
data raw_i_2012;
set raw.sect_a_c_d_e_pc_f_h_i_em_2012;
keep
cunicah	   /*Unique household ID - 2001*/
np	       /*Person number*/
codent01   /*Person identification code 2001 (=ps3)*/
acthog	   /*Update household code 2003*/
codent03   /*Person identification code 2003 (=ent2)*/

tipent_12 /*type of interview in 2012*/
i2_12 /*ever worked for pay*/
i3_12 /*ever worked without pay*/
i4_1_12 /*Year of first job*/
i4_2_12 /*Age of first job*/
;
run;

***********************************************************Section L: Biomarkers************************************************************************;
data raw_l_2001;
set raw.sect_l_2001;
run;
/*
proc contents data = raw_l_2001; run;
*/

data raw_l_2003;
set raw.sect_l_2003;
rename 
tipent = tipent_03
l1 = l1_03
l3 = l3_03
l4 = l4_03
l5 = l5_03
l6 = l6_03
l8 = l8_03
l10 = l10_03
l1a = l1a_03
l7_1 = l7_1_03
l7_2 = l7_2_03
l9_1 = l9_1_03
l9_2 = l9_2_03
;
run;
/*
proc contents data = raw_l_2003; run;
*/

data raw_l_2012;
set raw.sect_l_biomarkers_2012;
run;
/*
proc contents data = raw_l_2012; run;
*/

/*Merge datasets*/
proc sort data = raw_l_2001; by unhhid ps3; run;
proc sort data = raw_l_2012; by cunicah codent01; run;

data raw_l_01;
merge raw_l_2001 (rename=(unhhid = cunicah ps3 = codent01) in = inrawl2001) raw_l_2012 (in = inrawl2012);
by cunicah codent01;
run;

proc sort data = raw_l_2003; by cunicah acthog ent2; run;
proc sort data = raw_l_2012; by cunicah acthog codent03; run;

data raw_l_2012;
set raw_l_2012 (rename = (acthog = acthognum));
acthog = put (acthognum,2.);
drop acthognum;
run;

data raw_l;
merge raw_l_2003 (rename = (ent2 = codent03) in = inrawl2003) raw_l_2012 (in = inrawl2012);
by cunicah acthog codent03;
run;



***********************************************************Section X: CHILDHOOD****************************************************************;
data raw_x_2001;
set raw.sect_a_2001;
/***********Keep variables**********/
keep
unhhid 
ps3 
a6--a9e
;
run;

data raw_x_2003;
set raw.sect_a_2003;
/***********Keep variables**********/
keep
cunicah  
acthog  
ent2   
a11a--a11g
;
run;

data raw_x_2003n;
set raw.sect_a_2003n;
keep
cunicah 
acthog
ent2
aa6
aa7
aa8_1
aa8_2
aa9a--aa9f
;
run;

data raw_x_2012;
set raw.sect_a_c_d_e_pc_f_h_i_em_2012;
keep
cunicah
np
codent01
acthog
codent03
a10_12
a11_1_12--a11_3_12
;
run;

data raw_x_2012n;
set raw.sect_a_c_d_e_pc_f_h_i_em_2012;
keep
cunicah
np
codent01
acthog
codent03
aa6_12
aa7_12
aa8a1_12--aa8a5_12
aa8b_12
aa8b_a_12
aa8c_12
aa9a_12--aa9f_12
;
run;



/******************************************************Merge datasets to 2001,2003,2012********************************************************/
proc sort data = raw_a_2001; by unhhid ps3; run;
proc sort data = raw_c_2001; by unhhid ps3; run;
proc sort data = raw_i_2001; by unhhid ps3; run;
proc sort data = raw_x_2001; by unhhid ps3; run;

proc sort data = raw_a_2003; by cunicah acthog ent2; run;
proc sort data = raw_a_2003n;by cunicah acthog ent2; run;
proc sort data = raw_c_2003; by cunicah acthog ent2; run;
proc sort data = raw_i_2003; by cunicah acthog ent2; run;
proc sort data = raw_x_2003; by cunicah acthog ent2; run;
proc sort data = raw_x_2003n; by cunicah acthog ent2; run;

proc sort data = raw_a_2012;  by cunicah np; run;
proc sort data = raw_a_2012n; by cunicah np; run;
proc sort data = raw_c_2012;  by cunicah np; run;
proc sort data = raw_i_2012;  by cunicah np; run;
proc sort data = raw_x_2012;  by cunicah np; run;
proc sort data = raw_x_2012n;  by cunicah np; run;

data raw_2001;
	merge raw_a_2001 raw_c_2001 raw_i_2001 raw_x_2001;
	by unhhid ps3;
run;

data raw_2003;
	merge raw_a_2003 raw_a_2003n raw_c_2003 raw_i_2003 raw_x_2003 raw_x_2003n;
	by cunicah acthog ent2;
run;

data raw_2012;
	merge raw_a_2012 raw_a_2012n raw_c_2012 raw_i_2012 raw_x_2012 raw_x_2012n;
	by cunicah np;
run;



/**************************************************Rename variables in year 2003 for merging***************************************************/
data raw_2003_final;
set raw_2003;
/*Marital status*/
rename a3 = a3_03
       a4 = a4_03
       a5 = a5_03
       a6 = a6_03
       ;
/*Migration details*/
rename a12 = a12_03
       a14 = a14_03
       a15 = a15_03
       a16 = a16_03
       a17 = a17_03
       a18 = a18_03
       a19 = a19_03
       a20 = a20_03
       a21 = a21_03
       a22 = a22_03
       a23 = a23_03
       a24 = a24_03
       a25 = a25_03
       a26 = a26_03
       a27 = a27_03
     a28_1 = a28_1_03
     a28_2 = a28_2_03
     a28_3 = a28_3_03
     a28_4 = a28_4_03
     a28_5 = a28_5_03
     a29_1 = a29_1_03
     a29_2 = a29_2_03
     a29_3 = a29_3_03
     a29_4 = a29_4_03
     a29_5 = a29_5_03
     a29_6 = a29_6_03
     a29_7 = a29_7_03
     a29_8 = a29_8_03
       a30 = a30_03
       a31 = a31_03
       a32 = a32_03
      a33a = a33a_03
      a33b = a33b_03
      ;
/*Marital status_n*/
rename aa10 = aa10_03
       aa11 = aa11_03
       aa12 = aa12_03
      aa13a = aa13a_03
	   aa14 = aa14_03 
       aa15 = aa15_03
       aa16 = aa16_03
	   aa18 = aa18_03
       ;
/*Migration details_n*/
rename aa22 = aa22_03
       aa25 = aa25_03
      aa26a = aa26a_03
      aa26b = aa26b_03
       aa27 = aa27_03
       aa28 = aa28_03
       aa29 = aa29_03
       aa30 = aa30_03
       aa31 = aa31_03
       aa32 = aa32_03
       aa33 = aa33_03
       aa34 = aa34_03
       ;
/*Health*/
rename c18 = c18_03
      c22b = c22b_03
       c30 = c30_03
       c52 = c52_03
       ;
/*Employment*/
rename i1 = i1_03
	   i2 = i2_03
	   i3 = i3_03
       i4 = i4_03
	   i16 = i16_03
	   i26 = i26_03
	   i27 = i27_03
       ;
/*Childhood*/
rename a11a = a11a_03
	   a11b = a11b_03
       a11c = a11c_03
	   a11d = a11d_03
	   a11e = a11e_03
	   a11f = a11f_03
	   a11g = a11g_03
	   aa6  = aa6_03
	   aa7  = aa7_03
	   aa8_1 = aa8_1_03
	   aa8_2 = aa8_2_03
       aa9a = aa9a_03
	   aa9b = aa9b_03
	   aa9c = aa9c_03
	   aa9d = aa9d_03
	   aa9e = aa9e_03
	   aa9f = aa9f_03
       ;
run;




/*********************************************************Merge raw datasets with harmonized MHAS********************************************************/
data mhas;
set created.mhas;
keep
unhhidnp
unhhid cunicah 
acthog ps3 ent2 np
rabyear
RMSTAT01 RMSTAT03 RMSTAT12
rinw01 rinw03 rinw12
;
run;

/*Merge raw_2001_final with harmonized dataset*/
proc sort data = raw_2001; by unhhid ps3; run;
proc sort data = mhas; by unhhid ps3; run;

data raw_01;
merge raw_2001(in = inraw2001) mhas(in = inmhas);
by unhhid ps3;
if inmhas;
run;

/*Merge raw_2003_final with harmonized dataset(+2001)*/
proc sort data = raw_2003_final; by cunicah acthog ent2; run;
proc sort data = raw_01; by cunicah acthog ent2; run;

data raw_02;
merge raw_2003_final(in = inraw2003) raw_01(in = inraw01);
by cunicah acthog ent2;
if inraw01;
run;

/*Merge raw_2012 with harmonized dataset(+2001,2003)*/
proc sort data = raw_2012; by cunicah np; run;
proc sort data = raw_02; by cunicah np; run;

data raw_2012;
set raw_2012(rename=(acthog = acthognum));
acthog = put(acthognum, 2.);
drop acthognum;
run;

data raw_all;
merge raw_02(in = inraw02) raw_2012 (in = inraw2012);
by cunicah np;
if inraw02;
run;



/**********************************************************************************************************************************************/
/**************************************************************CREATE VARIABLES****************************************************************/
/**********************************************************************************************************************************************/


/*********************************************************************************************************/
/*************************************Section A Demographics**********************************************/


/****************                                         ****************/
/*                          Age at first marriage                        */
/****************                                         ****************/
data raw_a;
set raw_all;
if a12 in (8888,9999) then a12 =.;
if a15 in (8888,9999) then a15 =.;
if aa12_03 in (8888,9999) then aa12_03 =.;
if aa15_03 in (8888,9999) then aa15_03 =.;
if aa12_1_12 in (8888,9999) then aa12_1_12 =.;
if aa12_2_12 in (88,99) then aa12_2_12 =.;
if aa15_1_12 in (8888,9999) then aa15_1_12 =.;
if aa15_2_12 in (88,99) then aa15_2_12 =.;
run;

data raw_a;
set raw_a;
/*2001*/
if a10 in (2,3,4,5,6,7,8) and a13 = 1 then agefstm01 = a15 - rabyear;
else if a10 in (2,3,4,5,6,7,8) and a13 = 2 then agefstm01 = a12 - rabyear;
/*2003*/
if agefstm01 =. then do;
    if a3_03 in (2,3,4,5,6,7,8) then agefstm03 = 2002 - rabyear;
    else if aa10_03 in (2,3,4,5,6,7,8) and aa13a_03 = 1 then agefstm03 = aa15_03 - rabyear;
    else if aa10_03 in (2,3,4,5,6,7,8) and aa13a_03 = 2 then agefstm03 = aa12_03 - rabyear;
end;
/*2012*/
if agefstm03 =. then do;
	if a3_12 in (2,3,4,5,6,7,8) then agefstm12 = 2007 - rabyear;
   	else if aa10_12 in (2,3,4,5,6,7,8) and aa13a_12 = 1 and aa15_1_12 ^=. then agefstm12 = aa15_1_12 - rabyear;
    else if aa10_12 in (2,3,4,5,6,7,8) and aa13a_12 = 1 and aa15_2_12 ^=. then agefstm12 = aa15_2_12;
    else if aa10_12 in (2,3,4,5,6,7,8) and aa13a_12 = 2 and aa12_1_12 ^=. then agefstm12 = aa12_1_12 - rabyear;
    else if aa10_12 in (2,3,4,5,6,7,8) and aa13a_12 = 2 and aa12_2_12 ^=. then agefstm12 = aa12_2_12;
end;
run;

/*Set negative age as missing*/
data raw_a;
set raw_a;
if agefstm01 < 0  then agefstm01 =.;
if agefstm03 < 0  then agefstm03 =.;
if agefstm12 < 0  then agefstm12 =.;
run;

data raw_a;
set raw_a;
/*Give specific code to missing values for marital status
.R = didn't show up this wave
.M = missing marital status this wave*/
if rinw01 ^= 1 then RMSTATN01 = .R;
else if rinw01 = 1 and RMSTAT01 > 0 then RMSTATN01 = RMSTAT01;
else if rinw01 = 1 and RMSTAT01 < 0 then RMSTATN01 = .M;

if rinw03 ^= 1 then RMSTATN03 = .R;
else if rinw03 = 1 and RMSTAT03 > 0 then RMSTATN03 = RMSTAT03;
else if rinw03 = 1 and RMSTAT03 < 0 then RMSTATN03 = .M;

if rinw12 ^= 1 then RMSTATN12 = .R;
else if rinw12 = 1 and RMSTAT12 > 0 then RMSTATN12 = RMSTAT12;
else if rinw12 = 1 and RMSTAT12 < 0 then RMSTATN12 = .M;

/*Age at first marriage*/
if agefstm01 ^=. then agefstm = agefstm01;
else if agefstm03 ^=. then agefstm = agefstm03;
else if agefstm12 ^=. then agefstm = agefstm12;
else if RMSTATN01 in (.R,8) and RMSTATN03 in (.R,8) and RMSTATN12 in (.R,8) then agefstm = .N;
run;



/****************                                         ****************/
/*                          Age at first divorce                         */
/****************                                         ****************/

data raw_a1;
set raw_a;
if aa11_12 in (8888,9999) then aa11_12 =.;
if aa14_12 in (88,99) then aa14_12 =.;
if aa18_2_12 = 99 then aa18_2_12 =.;
if aa18_1_12 in (8888,9999) then aa18_1_12 =.;
if aa11_03 = 9999 then aa11_03 =.;
if aa14_03 =99 then aa14_03 =.;
if aa18_03 in (8888,9999) then aa18_03 =.;
if a11 in (8888,9999) then a11 =.;
if a14 in (88,99) then a14 =.;
if a18 in (8888,9999) then a18 =.;
run;

data raw_a1;
set raw_a1;
/*2001*/
if a18 ^=. then agefstd01 = a18 - rabyear;
else if a14 = 0 then agefstd01 = a11 - rabyear;
/*2003*/
if agefstd01 =. then do;
	if aa18_03 ^=. then agefstd03 = aa18_03 - rabyear;
	else if aa14_03 = 0 then agefstd03 = aa11_03 - rabyear;
	else agefstd03 =.;
end;
/*2012*/
if agefstd03 =. then do;
	if aa18_1_12 ^=. then agefstd12 = aa18_1_12 - rabyear;
	else if aa18_2_12 ^=. then agefstd12 = aa18_2_12;
	else if aa14_12 = 0 then agefstd12 = aa11_12 - rabyear;
	else agefstd12 =.;
end;
run;

/*Set negative age as missing*/
data raw_a1;
set raw_a1;
if agefstd01 < 0 then agefstd01 =.;
if agefstd03 < 0 then agefstd03 =.;
if agefstd12 < 0 then agefstd12 =.;
run;

/*Age at first divorce*/
data raw_a1;
set raw_a1;
if agefstd01 ^=. then agefstd = agefstd01;
else if agefstd03 ^=. then agefstd = agefstd03;
else if agefstd12 ^=. then agefstd = agefstd12;
else if agefstm =.N then agefstd =.N;
else if agefstm not in (.,.N) and agefstd =. then agefstd =.F;
run;


/****************                                         ****************/
/*                          Age at last marriage                         */
/****************                                         ****************/

data raw_a2;
set raw_a1;
if a12 in (8888,9999) then a12 =.;
if aa12_03 in (8888,9999) then aa12_03 =.;
if a6_03 in (8,9) then a6_03 =.;
if aa12_2_12 = 99 then aa12_2_12 =.;
if aa12_1_12 in (8888,9999) then aa12_1_12 =.;
if a6_12 in (8,9) then a6_12 =.;
if a4_12 in (8,9) then a4_12 =.;
run;

data raw_a2;
set raw_a2;
/*2012*/
if a4_12 = 2 and a6_12 = 1 then agelstm12 = 2007 - rabyear;
else if aa12_1_12 ^=. then agelstm12 = aa12_1_12 - rabyear;
else if aa12_2_12 ^=. then agelstm12 = aa12_2_12;
else agelstm12 =.;
/*2003*/
if agelstm12 =. then do;
	if a4_03 = 2 and a6_03 = 1 then agelstm03 = 2002 - rabyear;
	else if aa12_03 ^=. then agelstm03 = aa12_03 - rabyear;
	else agelstm03 =.;
end;
/*2001*/
if agelstm03 =. then do;
	if a13 = 1 then agelstm01 = a12 - rabyear;
	else agelstm01 =.;
end;
run;

/*Set negative age as missing*/
data raw_a2;
set raw_a2;
if agelstm01 < 0 then agelstm01 =.;
if agelstm03 < 0 then agelstm03 =.;
if agelstm12 < 0 then agelstm12 =.;
run;

data raw_a2;
set raw_a2;
/*Age at last marriage*/
if agelstm12 ^=. then agelstm = agelstm12;
else if agelstm03 ^=. then agelstm = agelstm03;
else if agelstm01 ^=. then agelstm = agelstm01;
else if agefstm = .N then agelstm = .N;
else if agefstd = .F then agelstm = .F;
else if agefstd not in (.,.N,.F) and agelstm =. then agelstm =.R;
run;


/****************                                         ****************/
/*                          Age at last divorce                          */
/****************                                         ****************/

data raw_a3;
set raw_a2;
if a5_12 in (8,9) then a5_12 =.;
if a5_03 in (8,9) then a5_03 =.;
run;

data raw_a3;
set raw_a3;
/*2012*/
if a5_12 = 1 then agelstd12 = 2007 - rabyear;
else if aa14_12 ^= 0 then agelstd12 = aa11_12 - rabyear;
else agelstd12 =.;
/*2003*/
if agelstd12 =. then do;
	if a5_03 = 1 then agelstd03 = 2002 - rabyear;
	else if aa14_03 ^=0 then agelstd03 = aa11_03 - rabyear;
	else agelstd03 =.;
end;
/*2001*/
if agelstd03 =. then do;
	if a13 = 1 then agelstd01 = a11 - rabyear;
	else agelstd01 =.;
end;
run;

/*Set negative age as missing*/
data raw_a3;
set raw_a3;
if agelstd01 < 0 then agelstd01 =.;
if agelstd03 < 0 then agelstd03 =.;
if agelstd12 < 0 then agelstd12 =.;
run;

data raw_a3;
set raw_a3;
/*Age at last divorce*/
if agelstd12 ^=. then agelstd = agelstd12;
else if agelstd03 ^=. then agelstd = agelstd03;
else if agelstd01 ^=. then agelstd = agelstd01;
else if agefstm = .N then agelstd = .N;
else if agefstd = .F then agelstd = .F;
else if agelstm = .R then agelstd = .R;
else if agelstm not in (.,.N,.F,.R) and agelstd =. then agelstd = .L;
run;

/****************                                         ****************/
/*                           Migration categories                        */
/****************                                         ****************/
data raw_a4;
set raw_a3;
/*          Migration categories at each wave          */
/*2001*/
if a22 = 3 then migration01 = 1;
else migration01 =.;
if migration01 ^=1 then do;
	if a25 = 1 then migration01 = 1;
	else if a25 = 2 then migration01 = 0;
	else migration01 =.;
end;
/*2003*/
if migration01 ^=1 then do;
	if (a12_03 = 1 or a14_03 = 1) or (aa22_03 = 3 or aa25_03 = 1) then migration03 = 1;
	else if (a12_03 = 2 and a14_03 = 2) or aa25_03 = 2 then migration03 = 0;
	else migration03 =.;
end;
/*2012*/
if migration03 ^=1 then do;
	if a14_12 = 1 or (aa22_12 = 3 or aa25_12 = 1) then migration12 = 1;
	else if a14_12 = 2 or aa25_12 = 2 then migration12 = 0;
	else migration12 =.;
end;
/*Migration categories*/
if migration01 ^=. then migration = migration01;
else if migration03 ^=. then migration = migration03;
else if migration12 ^=. then migration = migration12;
else migration =.;
run;


/****************                                         ****************/
/*                           Age at Migration                            */
/****************                                         ****************/
data raw_a5;
set raw_a4;
if a27 in (7777,8888,9999) then a27 =.;
if a16_03 in (7777,8888,9999) then a16_03 =.;
if aa27_03 in (7777,8888,9999) then aa27_03 =.;
if a16a_12 in (7777,8888,9999) then a16a_12 =.;
if aa26_1_12 in (7777,8888,9999) then aa26_1_12 =.;
if aa26_2_12 in (88,99) then aa26_2_12 =.;
if a29a1_12 in (7777,8888,9999) then a29a1_12 =.;
if a29a2_12 in (88,99) then a29a2_12 =.;
if aa32b1_12 in (7777,8888,9999) then aa32b1_12 =.;
if aa32b2_12 in (88,99) then aa32b2_12 =.;
if a19_03 in (7777,8888,9999) then a19_03 =.;
if aa32_03 in (7777,8888,9999) then aa32_03 =.;
if a32 in (7777,8888,9999) then a32 =.;
run;

data raw_a_final;
set raw_a5;
/*          Age at first migration          */
/*2001*/
if a27 ^=. then agefstmig01 = a27 - rabyear;
else agefstmig01 =.;
/*2003*/
if agefstmig01 =. then do;
	if a16_03 ^=. then agefstmig03 = a16_03 - rabyear;
	else if aa27_03 ^=. then agefstmig03 = aa27_03 - rabyear;
	else agefstmig03 =.;
end;
/*2012*/
if agefstmig03 =. then do;
	if a16a_12 ^=. then agefstmig12 = a16a_12 - rabyear;
	else if aa26_1_12 ^=. then agefstmig12 = aa26_1_12 - rabyear;
	else if aa26_2_12 ^=. then agefstmig12 = aa26_2_12;
	else agefstmig12 =.;
end;
/*Age at first migration*/
if migration = 0 then agefstmig = .N;
else if agefstmig01 ^=. then agefstmig = agefstmig01;
else if agefstmig03 ^=. then agefstmig = agefstmig03;
else if agefstmig12 ^=. then agefstmig = agefstmig12;


/*          Age at return migration          */
/*2012*/
if a29a1_12 ^=. then agertmig12 = a29a1_12 - rabyear;
else if a29a2_12 ^=. then agertmig12 = a29a2_12;
else if aa32b1_12 ^=. then agertmig12 = aa32b1_12 - rabyear;
else if aa32b2_12 ^=. then agertmig12 = aa32b2_12;
else agertmig12 =.;
/*2003*/
if agertmig12 =. then do;
	if a19_03 ^=. then agertmig03 = a19_03 - rabyear;
	else if aa32_03 ^=. then agertmig03 = aa32_03 - rabyear;
	else agertmig03 =.;
end;
/*2001*/
if agertmig03 =. then do;
	if a32 ^=. then agertmig01 = a32 - rabyear;
	else agertmig01 =.;
end;
/*Age at return migration*/
if migration = 0 then agertmig = .N;
else if agertmig12 ^=. then agertmig = agertmig12;
else if agertmig03 ^=. then agertmig = agertmig03;
else if agertmig01 ^=. then agertmig = agertmig01;
run;


/*********************************************************************************************************/
/******************************************Section c Health***********************************************/
data raw_c_final;
set raw_all;
/*          Age at first smoke         */
/*2001*/
if c57 not in (88,99,.) then agefstsmk01 = c57;
else agefstsmk01 =.;
/*2003*/
if agefstsmk01 =. and c52_03 not in (88,99,.) then agefstsmk03 = c52_03;
else agefstsmk03 =.;
/*2012*/
if agefstsmk03 =. then do;
	if c52_1_12 not in (88,99,.) then agefstsmk12 = c52_1_12;
	else if c52_2_12 not in (8888,9999,.) then agefstsmk12 = c52_2_12 - rabyear;
	else if c52_3_12 not in (88,99,.) then agefstsmk12 = 2012 - c52_3_12 - rabyear;
	else agefstsmk12 =.;
end;
/*Age at first smoke*/
if agefstsmk01 ^=. then agefstsmk = agefstsmk01;
else if agefstsmk03 ^=. then agefstsmk = agefstsmk03;
else if agefstsmk12 ^=. then agefstsmk = agefstsmk12;
run;


/*********************************************************************************************************/
/*****************************************Section I  Employment*******************************************/
data raw_i;
set raw_all;
/*          Ever Worked       */
/*2001*/
if i1 = 1 then worked01 = 1;
else if i1 = 2 then worked01 = 0;
/*2003*/
if i2_03 = 1 then worked03 = 1;
else if i2_03 = 2 then worked03 = 0;
/*2012*/
if i2_12 = 1 then worked12 = 1;
else if i2_12 = 2 then worked12 = 0;
/*Ever worked*/
if worked01 = 1 or worked03 = 1 or worked12 = 1 then worked = 1;
else if worked01 =. and worked03 =. and worked12 =. then worked = .;
else worked = 0;

/*          Age at first job       */
/*2001*/
if i3 not in (8888,9999,.) then agefstjob01 = i3 - rabyear;
else agefstjob01 =.;
/*2003*/
if agefstjob01 =. and i4_03 not in (8888,9999,.) then agefstjob03 = i4_03 - rabyear;
else agefstjob03 =.;
/*2012*/
if agefstjob03 =. then do;
	if i4_1_12 not in (8888,9999,.) then agefstjob12 = i4_1_12 - rabyear;
	else if i4_2_12 not in (88,99,.) then agefstjob12 = i4_2_12;
	else agefstjob12 =.;
end;
/*Age at first job*/
if agefstjob01 ^=. then agefstjob = agefstjob01;
else if agefstjob03 ^=. then agefstjob = agefstjob03;
else if agefstjob12 ^=. then agefstjob = agefstjob12;
/*Set negative age as missing*/
if agefstjob01 < 0 then agefstjob01 =.;
if agefstjob03 < 0 then agefstjob03 =.;
if agefstjob12 < 0 then agefstjob12 =.;
if agefstjob < 0 then agefstjob =.;
run;

/*********************************************************************************************************/
/******************************************Section X  Childhood*******************************************/
data raw_x;
set raw_all;
if a10_12 in (8,9) then a10_12 =.;
if aa8c_12 in (8,9) then aa8c_12 =.;
/*        Receive help from relatives due to economic problems        */
if a11f_03 = 1 or aa9f_03 = 1 or aa9f_12 = 1 then help_ecom = 1;
else if a11f_03 = 2 or aa9f_03 = 2 or aa9f_12 = 2 then help_ecom = 0;
else help_ecom =.;

/*        Parental occupation        */
if a11g_03 not in (88,99,.,9)  then job_father = a11g_03;
else if aa8b_12 not in (88,99,.,9) then job_father = aa8b_12;
else job_father =.;

/*        Blow to head that made you faint*/
if a9e = 1 or aa8_2_03 = 1 or aa8a2_12 = 1 then blow_head = 1;
else if a9e = 2 or aa8_2_03 = 2 or aa8a2_12 = 2 then blow_head = 0;
else blow_head =.;

/*        Self health as child        */
if a10_12 ^=. then health_child = a10_12;
else if aa8c_12 ^=. then health_child = aa8c_12;
run;


/**********************************************************************************************************************************************/
/*************************************************************Merge Raw Datasets***************************************************************/
/**********************************************************************************************************************************************/
proc sort data = raw_a_final; by unhhidnp; run;
proc sort data = raw_c_final; by unhhidnp; run;
proc sort data = raw_i; by unhhidnp; run;
proc sort data = raw_x; by unhhidnp; run;

data raw_all_final01;
merge raw_a_final raw_c_final raw_i raw_x;
by unhhidnp;
run; 

/**********************************************************************************************************************************************/
/****************************************************************Label variables***************************************************************/
/**********************************************************************************************************************************************/
data raw_all_final;
set raw_all_final01;
label
	agefstm = "Age at first marriage"
	agefstd = "Age at first divorce"
	agelstm = "Age at last marriage"
	agelstd = "Age at last divorce"
	migration = "Migration categories"
	agefstmig = "Age at first migration"
	agertmig = "Age at return migration"
	agefstsmk = "Age at first smoking"
	agefstjob = "Age at first job"
	worked    = "Ever worked"
	help_ecom = "Receive help from relatives because of economic problems in childhood"
	job_father = "Father's occupation in childhood"
	blow_head = "A serious blow to the head that made you faint in childhood"
	health_child = "Self-reported health as a child"
;
run;

/*****************CREATING RAW_FINAL DATASET*****************/
/*
data created.mhas_raw; 
set raw_all_final;
keep
unhhidnp unhhid np
agefstm
agefstd
agelstm
agelstd
migration
agefstmig
agertmig
agefstsmk
agefstjob
worked
;
run;  
*/
