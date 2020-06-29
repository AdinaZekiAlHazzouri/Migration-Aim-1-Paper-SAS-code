
libname Raw_HRS 'C:\Users\\\\\\\Raw_Files';
libname created 'C:\Users\\\\\\\SAS datasets';
libname RAND 'C:\Users\\\\\\\RAND_Files';
libname Tracker 'C:\Users\\\\\\\Tracker_Files';
options nofmterr;


/**********************************************************************************************************************************************/
/*************************************************************CALL IN DATASETS*****************************************************************/
/**********************************************************************************************************************************************/
/******** Tracker DATA *************/
data tracker;
set Tracker.trk2014TR_R;
run;

/**********SECTION A: Demographics**********/
data a_1992;
set Raw_HRS.a_1992;
keep
hhid
pn
V225--V249
;
run;

data a_1993;
set Raw_HRS.h93br21;
keep hhid pn
V150 V156-V163 V166;
run;
	
data a_1994;
set Raw_HRS.a_1994;
keep
hhid
pn
W200--W211
;
run;

data a_1995;
set raw_hrs.a95a_r;
keep hhid pn 
D674--D685;
run;

data a_1996;
set Raw_HRS.a_1996;
keep
hhid
pn
E674--E685
;
run;

data a_1998;
set Raw_HRS.a_1998;
keep
hhid
pn
F1059--F1088
F992 /*Rate health as child*/
F995
F996
F997HM
;
run;

data a_2000;
set Raw_HRS.a_2000;
keep
hhid
pn
G1146--G1175
G1079 /*Rate health as child*/
G1082
G1083
G1084M
G1085
;
run;

data a_2002;
set Raw_HRS.a_2002;
keep
hhid
pn
HMARITAL
HB055--HB070_3
HB019
HB022
HB023
HB024M
HB025
;
run;

data a_2004;
set Raw_HRS.a_2004;
keep
hhid
pn
JB055--JB070_4
JB019
JB022
JB023
JB024M
JB025
;
run;

data a_2006;
set Raw_HRS.a_2006;
keep
hhid
pn
KB055--KB070_4
KB019
KB022
KB023
KB024M
KB025
;
run;

data a_2008;
set Raw_HRS.a_2008;
keep
hhid
pn
LB055--LB070_4
LB019
LB022
LB023
LB024M
LB025
LB099
LB119
;
run;

data a_2010;
set Raw_HRS.a_2010;
keep
hhid
pn
MB055--MB070_4
MB019
MB022
MB023
MB024M
MB025
MB099
MB119
;
run;

data a_2012;
set Raw_HRS.a_2012;
keep
hhid
pn
NB055--NB070_4
NB019
NB022
NB023
NB024M
NB025
NB099
NB119
;
run;

/**********SECTION B: Health**********/
data b_1998;
set Raw_HRS.b_1998;
keep
hhid
pn
F1271
F1272
F1273
;
run;


data b_2000;
set Raw_HRS.b_2000;
keep
hhid
pn
G1404
G1405
G1406
;
run;

data b_2002;
set Raw_HRS.b_2002;
keep
hhid
pn
HC120
HC121
HC122
;
run;

data b_2004;
set Raw_HRS.b_2004;
keep
hhid
pn
JC120
JC121
JC122
;
run;

data b_2006;
set Raw_HRS.b_2006;
keep
hhid
pn
KC120
KC121
KC122
;
run;

data b_2008;
set Raw_HRS.b_2008;
keep
hhid
pn
LC120
LC121
LC122
;
run;

data b_2010;
set Raw_HRS.b_2010;
keep
hhid
pn
MC120
MC121
MC122
;
run;

data b_2012;
set Raw_HRS.b_2012;
keep
hhid
pn
NC120
NC121
NC122
;
run;

/**********SECTION GH/L: JOB HISTORY**********/
data gh_1996;
set raw_hrs.gh_1996;
keep
hhid
pn
E3461
E3462
;
run;

data gh_1998;
set raw_hrs.gh_1998;
keep
hhid
pn
F3973
F3974
;
run;

data gh_2000;
set raw_hrs.gh_2000;
keep
hhid
pn
G4263
G4264
;
run;

data l_2002;
set raw_hrs.l_2002;
keep
hhid
pn
HL129
HL152
HL177
;
run;

data l_2004;
set raw_hrs.l_2004;
keep
hhid
pn
JL067
JL068
JL094
;
run;

data l_2006;
set raw_hrs.l_2006;
keep
hhid
pn
KL067
KL068
KL094
;
run;

data l_2008;
set raw_hrs.l_2008;
keep
hhid
pn
LL067
LL068
LL094
;
run;

data l_2010;
set raw_hrs.l_2010;
keep
hhid
pn
ML067
ML068
ML094
;
run;

data l_2012;
set raw_hrs.l_2012;
keep
hhid
pn
NL067
NL068
NL094
;
run;

/*RAND*/
data rand;
set rand.rndhrs_p; 
keep
hhidpn
hhid
pn
rabyear rabmonth
R1MNEV--R11MNEV   /*ever married*/
;
run;




/**********************************************************************************************************************************************/
/**************************************************************MERGE DATASETS******************************************************************/
/**********************************************************************************************************************************************/
/*Section A: Demographics*/
proc sort data = a_1992; by hhid pn; run;
proc sort data = a_1993; by hhid pn; run;
proc sort data = a_1994; by hhid pn; run;
proc sort data = a_1995; by hhid pn; run; 
proc sort data = a_1996; by hhid pn; run;
proc sort data = a_1998; by hhid pn; run;
proc sort data = a_2000; by hhid pn; run;
proc sort data = a_2002; by hhid pn; run;
proc sort data = a_2004; by hhid pn; run;
proc sort data = a_2006; by hhid pn; run;
proc sort data = a_2008; by hhid pn; run;
proc sort data = a_2010; by hhid pn; run;
proc sort data = a_2012; by hhid pn; run;

data a_hrs00;
merge a_1992 a_1993 a_1994 a_1995 a_1996 a_1998 a_2000 a_2002 a_2004 a_2006 a_2008 a_2010 a_2012;
by hhid pn;
run;

proc sort data = rand; by hhid pn; run;
proc sort data= tracker; by hhid pn; run;
data a_hrs;
merge a_hrs00 (in = A) rand (in = B) tracker (in=C);
by hhid pn;
if C;
run;

/*Section B: Health*/
proc sort data = b_1998; by hhid pn; run;
proc sort data = b_2000; by hhid pn; run;
proc sort data = b_2002; by hhid pn; run;
proc sort data = b_2004; by hhid pn; run;
proc sort data = b_2006; by hhid pn; run;
proc sort data = b_2008; by hhid pn; run;
proc sort data = b_2010; by hhid pn; run;
proc sort data = b_2012; by hhid pn; run;

data b_hrs00;
merge b_1998 b_2000 b_2002 b_2004 b_2006 b_2008 b_2010 b_2012;
by hhid pn;
run;

data b_hrs;
merge b_hrs00 (in = A) rand (in = B) tracker (in=C);
by hhid pn;
if C;
run;



/*Section GH/L: Job history*/
proc sort data = gh_1996; by hhid pn; run;
proc sort data = gh_1998; by hhid pn; run;
proc sort data = gh_2000; by hhid pn; run;
proc sort data = l_2002; by hhid pn; run;
proc sort data = l_2004; by hhid pn; run;
proc sort data = l_2006; by hhid pn; run;
proc sort data = l_2008; by hhid pn; run;
proc sort data = l_2010; by hhid pn; run;
proc sort data = l_2012; by hhid pn; run;

data gh_l_hrs00;
merge gh_1996 gh_1998 gh_2000 l_2002 l_2004 l_2006 l_2008 l_2010 l_2012;
by hhid pn;
run;

data gh_l_hrs;
merge gh_l_hrs00 (in = A) rand (in = B) tracker (in=C);
by hhid pn;
if C;
run;


/**********************************************************************************************************************************************/
/*********************************************************CONSTRUCT NEW VARIABLES**************************************************************/
/**********************************************************************************************************************************************/


/****************************************************************************/
/*                          Section A Demographics                          */
/****************************************************************************/


 
/****************************************************************/
/*                     AGE AT FIRST MARRIAGE                    */

/*Set all the DK RF as missing*/
data a_hrs1; 
set a_hrs;
if W202 in (0,98,99) then W202 =.;
if W203 in (0,9998,9999) then W203 =.;
if W208 in (0,98,99) then W208 =.;
if W209 in (0,9998,9999) then W209 =.;
if D678 in (0,9998,9999) then D678 =.;
if D679 in (0,98,99) then D679 =.;
if E678 in (0,9998,9999) then E678 =.;
if E679 in (0,98,99) then E679 =.;
if F1061 in (0,98,99) then F1061 =.;
if F1062 in (0,9998,9999) then F1062 =.;
if F1073 in (0,9998,9999) then F1073 =.;
if F1074 in (0,98,99) then F1074 =.;
if G1148 in (0,98,99) then G1148 =.;
if G1149 in (0,9998,9999) then G1149 =.;
if G1160 in (0,9998,9999) then G1160 =.;
if G1161 in (0,98,99) then G1161 =.;
if HB056 in (98,99) then HB056 =.;
if HB057 in (9998,9999) then HB057 =.;
if HB066_1 in (9998,9999) then HB066_1 =.;
if HB067_1 in (98,99) then HB067_1 =.;
if JB056 in (98,99) then JB056 =.;
if JB057 in (9998,9999) then JB057 =.;
if JB066_1 in (9998,9999) then JB066_1 =.;
if JB067_1 in (98,99) then JB067_1 =.;
if KB056 in (98,99) then KB056 =.;
if KB057 in (9998,9999) then KB057 =.;
if KB066_1 in (9998,9999) then KB066_1 =.;
if KB067_1 in (98,99) then KB067_1 =.;
if LB056 in (98,99) then LB056 =.;
if LB057 in (9998,9999) then LB057 =.;
if LB066_1 in (9998,9999) then LB066_1 =.;
if LB067_1 in (98,99) then LB067_1 =.;
if MB056 in (98,99) then MB056 =.;
if MB057 in (9998,9999) then MB057 =.;
if MB066_1 in (9998,9999) then MB066_1 =.;
if MB067_1 in (98,99) then MB067_1 =.;
if NB056 in (98,99) then NB056 =.;
if NB057 in (9998,9999) then NB057 =.;
if NB066_1 in (9998,9999) then NB066_1 =.;
if NB067_1 in (98,99) then NB067_1 =.;
run;

/*Year at first marriage*/
data a_hrs1a;
set a_hrs1;
/*1992*/
	if V225 in (1,7,8) and V239 = 1 then yearfstm92 = V227;
	else if V225 in (1,7,8) and V239 ^= 1 then yearfstm92 = V241;
	else if V225 = 2 and V228 = 1 and V229 = 1 then yearfstm92 = V231; 
	else if V225 = 2 and V228 = 1 and V229 ^= 1 then yearfstm92 = V241;
	else if V225 = 2 and V228 ^= 1 then yearfstm92 =.; 
	else if V225 in (3,4,5) and V239 = 1 then yearfstm92 = V238;
	else if V225 in (3,4,5) and V239 ^= 1 then yearfstm92 = V241; 
	else if V225 in (9,.) then yearfstm92 =.; 
/*1993*/
	if yearfstm92 =. then do;
		if V166 =1 and V150 in (1,2) then yearfstm93 = V156;
		else if V150=3 and V158=1 and V166=1 then yearfstm93=V159-V161;
		else if V150 in (4,5)  and V166=1 then yearfstm93=V162-V163;
		else if V150 in (.) then yearfstm93=.;
		else if yearsfstm93<0 then yearsfstm93=.;
	end;
/*1994*/
	if yearfstm93 =. then do;
		if W208 = 1 and W200 in (1,3,7,8) then yearfstm94 = W203;
		else if W209 >=0 then yearfstm94 = W209;
	end;
/*1995*/
	if yearfstm94 =. then yearfstm95 = D678;
/*1996*/
	if yearfstm95 =. then yearfstm96 = E678;
/*1998*/
	if yearfstm96 =. then yearfstm98 = F1073;
/*2000*/
	if yearfstm98 =. then yearfstm00 = G1160;
/*2002*/
	if yearfstm00 =. then yearfstm02 = HB066_1;
/*2004*/
	if yearfstm02 =. then yearfstm04 = JB066_1;
/*2006*/
	if yearfstm04 =. then yearfstm06 = KB066_1;
/*2008*/
	if yearfstm06 =. then yearfstm08 = LB066_1;
/*2010*/
	if yearfstm08 =. then yearfstm10 = MB066_1;
/*2012*/
	if yearfstm10 =. then yearfstm12 = NB066_1;

/***
/*Month at first marriage*/
/*1992*/
if V225 in (1,7,8) and V239 = 1 then monthfstm92 = V226;
else if V225 in (1,7,8) and V239 ^= 1 then monthfstm92 =.;
else if V225 = 2 and V228 = 1 and V229 = 1 then monthfstm92 = V230;
else if V225 = 2 and V228 = 1 and V229 ^= 1 then monthfstm92 =.;
else if V225 = 2 and V228 ^= 1 then monthfstm92 =.;
else if V225 in (3,4,5) and V239 = 1 then monthfstm92 = V237;
else if V225 in (3,4,5) and V239 ^= 1 then monthfstm92 =.;
else if V225 in (9,.) then monthfstm92 =.;
/*1993 does not provide months*/
/*1994*/
	if yearfstm92 =. then do;
		if W208 = 1 and W200 in (1,3,7,8) then monthfstm94 = W202;
		else monthfstm94 =.;
	end;
/*1995*/
	if yearfstm94=. then monthfstm95 = D679;
/*1996*/
	if yearfstm95=. then monthfstm96 = E679;
/*1998*/
	if yearfstm96=. then monthfstm98 = F1074;
/*2000*/
	if yearfstm98=. then monthfstm00 = G1161;
/*2002*/
	if yearfstm00=. then monthfstm02 = HB067_1;
/*2004*/
	if yearfstm02=. then monthfstm04 = JB067_1;
/*2006*/
	if yearfstm04=. then monthfstm06 = KB067_1;
/*2008*/
	if yearfstm06=. then monthfstm08 = LB067_1;
/*2010*/
	if yearfstm08=. then monthfstm10 = MB067_1;
/*2012*/
	if yearfstm10=. then monthfstm12 = NB067_1;
run;


/*Age at first marriage*/
data a_hrs1a;
set a_hrs1a;
/*1992*/
if yearfstm92 ^=. and monthfstm92 ^=. then agefstm92 = round((mdy(monthfstm92,1,yearfstm92) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm92 ^=. and monthfstm92 =. then agefstm92 = yearfstm92 - rabyear;
else agefstm92 =.;
/*1993*/
if yearfstm93 ^=. then agefstm93 = yearfstm93 - rabyear;
else agefstm93 =.;
/*1994*/
if yearfstm94 ^=. and monthfstm94 ^=. then agefstm94 = round((mdy(monthfstm94,1,yearfstm94) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm94 ^=. and monthfstm94 =. then agefstm94 = yearfstm94 - rabyear;
else agefstm94 =.;
/*1995*/
if yearfstm95 ^=. and monthfstm95 ^=. then agefstm95 = round((mdy(monthfstm95,1,yearfstm95) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm95 ^=. and monthfstm95 =. then agefstm95 = yearfstm95 - rabyear;
else agefstm95 =.;
/*1996*/
if yearfstm96 ^=. and monthfstm96 ^=. then agefstm96 = round((mdy(monthfstm96,1,yearfstm96) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm96 ^=. and monthfstm96 =. then agefstm96 = yearfstm96 - rabyear;
else agefstm96 =.;
/*1998*/
if yearfstm98 ^=. and monthfstm98 ^=. then agefstm98 = round((mdy(monthfstm98,1,yearfstm98) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm98 ^=. and monthfstm98 =. then agefstm98 = yearfstm98 - rabyear;
else agefstm98 =.;
/*2000*/
if yearfstm00 ^=. and monthfstm00 ^=. then agefstm00 = round((mdy(monthfstm00,1,yearfstm00) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm00 ^=. and monthfstm00 =. then agefstm00 = yearfstm00 - rabyear;
else agefstm00 =.;
/*2002*/
if yearfstm02 ^=. and monthfstm02 ^=. then agefstm02 = round((mdy(monthfstm02,1,yearfstm02) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm02 ^=. and monthfstm02 =. then agefstm02 = yearfstm02 - rabyear;
else agefstm02 =.;
/*2004*/
if yearfstm04 ^=. and monthfstm04 ^=. then agefstm04 = round((mdy(monthfstm04,1,yearfstm04) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm04 ^=. and monthfstm04 =. then agefstm04 = yearfstm04 - rabyear;
else agefstm04 =.;
/*2006*/
if yearfstm06 ^=. and monthfstm06 ^=. then agefstm06 = round((mdy(monthfstm06,1,yearfstm06) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm06 ^=. and monthfstm06 =. then agefstm06 = yearfstm06 - rabyear;
else agefstm06 =.;
/*2008*/
if yearfstm08 ^=. and monthfstm08 ^=. then agefstm08 = round((mdy(monthfstm08,1,yearfstm08) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm08 ^=. and monthfstm08 =. then agefstm08 = yearfstm08 - rabyear;
else agefstm08 =.;
/*2010*/
if yearfstm10 ^=. and monthfstm10 ^=. then agefstm10 = round((mdy(monthfstm10,1,yearfstm10) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm10 ^=. and monthfstm10 =. then agefstm10 = yearfstm10 - rabyear;
else agefstm10 =.;
/*2012*/
if yearfstm12 ^=. and monthfstm12 ^=. then agefstm12 = round((mdy(monthfstm12,1,yearfstm12) - mdy(rabmonth,1,rabyear))/365);
else if yearfstm12 ^=. and monthfstm12 =. then agefstm12 = yearfstm12 - rabyear;
else agefstm12 =.;
run;

/*Set negative ages as missing*/
data a_hrs2;
set a_hrs1a;
if agefstm92 < 0 then agefstm92 =.;
if agefstm93 < 0 then agefstm93 =.;
if agefstm94 < 0 then agefstm94 =.;
if agefstm95 < 0 then agefstm95 =.;
if agefstm96 < 0 then agefstm96 =.;
if agefstm98 < 0 then agefstm98 =.;
if agefstm00 < 0 then agefstm00 =.;
if agefstm02 < 0 then agefstm02 =.; 
if agefstm04 < 0 then agefstm04 =.; 
if agefstm06 < 0 then agefstm06 =.; 
if agefstm08 < 0 then agefstm08 =.; 
if agefstm10 < 0 then agefstm10 =.; 
if agefstm12 < 0 then agefstm12 =.;
run; 


data a_hrs2;
set a_hrs2;
/*Give specific code to missing values for marital status
.R = didn't show up this wave
.M = missing marital status this wave*/
if AIWTYPE ^= 1 then R1MNEVN = .R;
else if AIWTYPE = 1 and R1MNEV < 0  then R1MNEVN = .M;
else if AIWTYPE = 1 and R1MNEV >= 0 then R1MNEVN = R1MNEV;

if BIWTYPE ^= 1 then R2MNEVN_A = .R;
else if BIWTYPE = 1 and R2MNEV < 0  then R2MNEVN_A = .M;
else if BIWTYPE = 1 and R2MNEV >= 0 then R2MNEVN_A = R2MNEV;

if CIWTYPE ^= 1 then R2MNEVN = .R;
else if CIWTYPE = 1 and R2MNEV < 0  then R3MNEVN = .M;
else if CIWTYPE = 1 and R2MNEV >= 0 then R3MNEVN = R2MNEV;

if DIWTYPE ^= 1 then R3MNEVN_A = .R;
else if DIWTYPE = 1 and R3MNEV < 0  then R3MNEVN_A = .M;
else if DIWTYPE = 1 and R3MNEV >= 0 then R3MNEVN_A = R3MNEV;

if EIWTYPE ^= 1 then R3MNEVN = .R;
else if EIWTYPE = 1 and R3MNEV < 0  then R3MNEVN = .M;
else if EIWTYPE = 1 and R3MNEV >= 0 then R3MNEVN = R3MNEV;

if FIWTYPE ^= 1 then R4MNEVN = .R;
else if FIWTYPE = 1 and R4MNEV < 0  then R4MNEVN = .M;
else if FIWTYPE = 1 and R4MNEV >= 0 then R4MNEVN = R4MNEV;

if GIWTYPE ^= 1 then R5MNEVN = .R;
else if GIWTYPE = 1 and R5MNEV < 0  then R5MNEVN = .M;
else if GIWTYPE = 1 and R5MNEV >= 0 then R5MNEVN = R5MNEV;

if HIWTYPE ^= 1 then R6MNEVN = .R;
else if HIWTYPE = 1 and R6MNEV < 0  then R6MNEVN = .M;
else if HIWTYPE = 1 and R6MNEV >= 0 then R6MNEVN = R6MNEV;

if JIWTYPE ^= 1 then R7MNEVN = .R;
else if JIWTYPE = 1 and R7MNEV < 0  then R7MNEVN = .M;
else if JIWTYPE = 1 and R7MNEV >= 0 then R7MNEVN = R7MNEV;

if KIWTYPE ^= 1 then R8MNEVN = .R;
else if KIWTYPE = 1 and R8MNEV < 0  then R8MNEVN = .M;
else if KIWTYPE = 1 and R8MNEV >= 0 then R8MNEVN = R8MNEV;

if LIWTYPE ^= 1 then R9MNEVN = .R;
else if LIWTYPE = 1 and R9MNEV < 0  then R9MNEVN = .M;
else if LIWTYPE = 1 and R9MNEV >= 0 then R9MNEVN = R9MNEV;

if MIWTYPE ^= 1 then R10MNEVN = .R;
else if MIWTYPE = 1 and R10MNEV < 0  then R10MNEVN = .M;
else if MIWTYPE = 1 and R10MNEV >= 0 then R10MNEVN = R10MNEV;

if NIWTYPE ^= 1 then R11MNEVN = .R;
else if NIWTYPE = 1 and R11MNEV < 0  then R11MNEVN = .M;
else if NIWTYPE = 1 and R11MNEV >= 0 then R11MNEVN = R11MNEV;

/*Age at first marriage*/
if agefstm92 ^=. then agefstm = agefstm92;
else if agefstm93 ^=. then agefstm = agefstm93;
else if agefstm94 ^=. then agefstm = agefstm94;
else if agefstm95 ^=. then agefstm = agefstm95;
else if agefstm96 ^=. then agefstm = agefstm96;
else if agefstm98 ^=. then agefstm = agefstm98;
else if agefstm00 ^=. then agefstm = agefstm00;
else if agefstm02 ^=. then agefstm = agefstm02;
else if agefstm04 ^=. then agefstm = agefstm04;
else if agefstm06 ^=. then agefstm = agefstm06;
else if agefstm08 ^=. then agefstm = agefstm08;
else if agefstm10 ^=. then agefstm = agefstm10;
else if agefstm12 ^=. then agefstm = agefstm12;
else if R1MNEVN in (.R,0) and R2MNEVN_A in (.R,0) and R2MNEVN in (.R,0) and R3MNEVN_A in (.R,0) and R3MNEVN in (.R,0) and R4MNEVN in (.R,0) and R5MNEVN in (.R,0) and 
R6MNEVN in (.R,0) and R7MNEVN in (.R,0) and R8MNEVN in (.R,0) and R9MNEVN in (.R,0) and R10MNEVN in (.R,0) and R11MNEVN in (.R,0) then agefstm =.N;
run;


/****************************************************************/
/*                 AGE AT FIRST DIVORCED/WIDOWED                */

/*Set all the DK RF as missing*/
data a_hrs3; 
set a_hrs2;
if V243 in (0,9996,9998) then V243 =.;
if V233 in (0,9996,9998) then V233 =.;
if W211 in (0,9996,9998) then W211 =.;
if D681 in (98,99) then D681 =.;
if E681 in (98,99) then E681 =.;
if F1076 in (98,99) then F1076 =.;
if G1163 in (98,99) then G1163 =.;
if HB070_1 in (98,99) then HB070_1 =.;
if JB070_1 in (98,99) then JB070_1 =.; 
if KB070_1 in (98,99) then KB070_1 =.; 
if LB070_1 in (98,99) then LB070_1 =.; 
if MB070_1 in (98,99) then MB070_1 =.; 
if NB070_1 in (98,99) then NB070_1 =.;
run;

/*Year at first divorce*/
data a_hrs3a;
set a_hrs3;
/*1992*/
if V225 in (1,7,8) then yearfstd92 = V243;
else if V225=2 and V229 = 1 then yearfstd92 = V233;
else if V225=2 and V229 ^=1 then yearfstd92=V243;
else if V225 in (3,4,5) and V239 = 1 then yearfstd92= V236;
else if V225 in (3,4,5) and V239 ^= 1 then yearfstd92=V243;
/*1993*/
if yearfstd92 =. then do;
	if V166 =1 and V150 in (1,2) then yearfstd93 =.;
	else if V150=3 and V158=1 and V166=1 then yearfstd93=V162;
	else if V150 in (4,5)  and V166=1 then yearfstd93=V162;
	else if V150 in (6,.) then yearfstd93=.;
end;
/*1994*/
if yearfstd93 =. then yearfstd94 = W211;
/*1995*/
if yearfstd94 =. then yearfstd95 = D678 + D681;
/*1996*/
if yearfstd95 =. then yearfstd96 = E678 + E681;
/*1998*/
if yearfstd96=. then yearfstd98= F1073 + F1076;
/*2000*/
if yearfstd98=. then yearfstd00= G1160 + G1163;
/*2002*/
if yearfstd00=. then yearfstd02= HB066_1 + HB070_1;
/*2004*/
if yearfstd02=. then yearfstd04= JB066_1 + JB070_1;
/*2006*/
if yearfstd04=. then yearfstd06=KB066_1 + KB070_1;
/*2008*/
if yearfstd06=. then yearfstd08=LB066_1 + LB070_1;
/*2010*/
if yearfstd08=. then yearfstd10=MB066_1 + MB070_1;
/*2012*/
if yearfstd10=. then yearfstd12=NB066_1 + NB070_1;

/*Set yearfstd > interview year as missing*/
if yearfstd92 > 1992 then yearfstd92 =.;
if yearfstd93 > 1993 then yearfstd93 =.;
if yearfstd94 > 1994 then yearfstd94 =.;
if yearfstd95 > 1995 then yearfstd95 =.;
if yearfstd96 > 1996 then yearfstd96 =.;
if yearfstd98 > 1998 then yearfstd98 =.;
if yearfstd00 > 2000 then yearfstd00 =.;
if yearfstd02 > 2002 then yearfstd02 =.;
if yearfstd04 > 2004 then yearfstd04 =.;
if yearfstd06 > 2006 then yearfstd06 =.;
if yearfstd08 > 2008 then yearfstd08 =.;
if yearfstd10 > 2010 then yearfstd10 =.;
if yearfstd12 > 2012 then yearfstd12 =.;
run;


/*Age at first divorce*/
data a_hrs3a;
set a_hrs3a;
/*1992*/
agefstd92 = yearfstd92 - rabyear;
/*1993*/
agefstd93 = yearfstd93 - rabyear;
/*1994*/
agefstd94 = yearfstd94 - rabyear;
/*1995*/
agefstd95 = yearfstd95 - rabyear;
/*1996*/
agefstd96 = yearfstd96 - rabyear;
/*1998*/
agefstd98 = yearfstd98 - rabyear;
/*2000*/
agefstd00 = yearfstd00 - rabyear;
/*2002*/
agefstd02 = yearfstd02 - rabyear;
/*2004*/
agefstd04 = yearfstd04 - rabyear;
/*2006*/
agefstd06 = yearfstd06 - rabyear;
/*2008*/
agefstd08 = yearfstd08 - rabyear;
/*2010*/
agefstd10 = yearfstd10 - rabyear;
/*2012*/
agefstd12 = yearfstd12 - rabyear;
run;


/*Set negative ages as missing*/
data a_hrs4a;
set a_hrs3a;
if agefstd92 < 0 then agefstd92 =.;
if agefstd93 < 0 then agefstd93 =.;
if agefstd94 < 0 then agefstd94 =.;
if agefstd95 < 0 then agefstd95 =.;
if agefstd96 < 0 then agefstd96 =.;
if agefstd98 < 0 then agefstd98 =.;
if agefstd00 < 0 then agefstd00 =.;
if agefstd02 < 0 then agefstd02 =.; 
if agefstd04 < 0 then agefstd04 =.; 
if agefstd06 < 0 then agefstd06 =.; 
if agefstd08 < 0 then agefstd08 =.; 
if agefstd10 < 0 then agefstd10 =.; 
if agefstd12 < 0 then agefstd12 =.;
run; 


/*Age at first divorce*/
data a_hrs4a;
set a_hrs4a;
if agefstd92 ^=. then agefstd = agefstd92;
else if agefstd93 ^=. then agefstd = agefstd93;
else if agefstd94 ^=. then agefstd = agefstd94;
else if agefstd95 ^=. then agefstd = agefstd95;
else if agefstd96 ^=. then agefstd = agefstd96;
else if agefstd98 ^=. then agefstd = agefstd98;
else if agefstd00 ^=. then agefstd = agefstd00;
else if agefstd02 ^=. then agefstd = agefstd02;
else if agefstd04 ^=. then agefstd = agefstd04;
else if agefstd06 ^=. then agefstd = agefstd06;
else if agefstd08 ^=. then agefstd = agefstd08;
else if agefstd10 ^=. then agefstd = agefstd10;
else if agefstd12 ^=. then agefstd = agefstd12;
else if agefstm=.N then agefstd=.N;
else if agefstm not in (.,.N) and agefstd=. then agefstd=.F;
run;


/****************************************************************/
/*       AGE AT SECOND/THIRD MARRIAGE OR DIVORCED/WIDOWED       */

/*Set all the DK RF as missing*/
data a_hrs5; 
set a_hrs4a;
array md[24] V244 V246 V247 V249 V231 V233 
             D682 E682 F1077 F1081 G1164 G1168
             HB066_2 HB066_3 JB066_2 JB066_3 KB066_2 KB066_3
             LB066_2 LB066_3 MB066_2 MB066_3 NB066_2 NB066_3;
do i = 1 to 24;
	if md[i] in (0,9996,9998,9999) then md[i] =.;
end;
array md2[18] D685 E685 F1080 F1084 G1167 G1171 HB070_2 HB070_3
			  JB070_2 JB070_3 KB070_2 KB070_3 LB070_2 LB070_3
              MB070_2 MB070_3 NB070_2 NB070_3;
do i = 1 to 18;
	if md2[i] in (98,99) then md2[i] =.;
end;
run;

/*Year at second/third marriage/divorce*/
data a_hrs5;
set a_hrs5;
/*1992*/
if V225 in (1,3,4,5,7,8) then do;
	yearscdm92 = V244;
	yearscdd92 = V246;
	yeartrdm92 = V247;
	yeartrdd92 = V249;
end;
else if V225 = 2 and V240 = 2 then do;
	yearscdm92 = V231;
	yearscdd92 = V233;
end;
else if V225 = 2 and V240 = 3 then do;
	yearscdm92 = V244;
	yearscdd92 = V246;
	yeartrdm92 = V231;
	yeartrdd92 = V233;
end;
else if V225 = 2 and V240 > 3 then do;
	yearscdm92 = V244;
	yearscdd92 = V246;
	yeartrdm92 = V247;
	yeartrdd92 = V249;
end;
/*1993*/
if V150 in (1 2 4 5) and V166=2 then do;
	yearscdm93 = V162-V163;
	yearscdd93 = V162;
end;
if V150 in (1 2 4 5) and V166=3 then do;
	yeartrdm93 = V162-V163;
	yeartrdd93 = V162;
end;
if V158=1 and V166=2 then do;
	yearscdm93 = V159-V161;
	yearscdd93 = V159;
end;
if V158=1 and V166=3 then do;
	yeartrdm93 = V159-V161;
	yeartrdd93 = V159;
end;
if V150=3 and V166=2 and V158=^1 then do;
	yearscdm93 = V162-V163;
	yearscdd93 = V162;
end;
if V150=3 and V166=3 and V158=^1 then do;
	yeartrdm93 = V162-V163;
	yeartrdd93 = V162;
end;
/*1994:not available*/
/*1995*/
if yearscdm93 =. and D677 = 2 then yearscdm95 = D682;
if yearscdd93 =. and D677 = 2 then yearscdd95 = D682 + D685;
if yeartrdm93 =. and D677 = 3 then yeartrdm95 = D682;
if yeartrdd93 =. and D677 = 3 then yeartrdd95 = D682 + D685; 
/*1996*/
if yearscdm95 =. and E677 = 2 then yearscdm96 = E682;
if yearscdd95 =. and E677 = 2 then yearscdd96 = E682 + E685;
if yeartrdm95 =. and E677 = 3 then yeartrdm96 = E682;
if yeartrdd95 =. and E677 = 3 then yeartrdd96 = E682 + E685; 
/*1998*/
if yearscdm96 =. then yearscdm98 = F1077;
if yearscdd96 =. then yearscdd98 = F1077 + F1080;
if yeartrdm96 =. then yeartrdm98 = F1081;
if yeartrdd96 =. then yeartrdd98 = F1081 + F1084; 
/*2000*/
if yearscdm98 =. then yearscdm00 = G1164;
if yearscdd98 =. then yearscdd00 = G1164 + G1167;
if yeartrdm98 =. then yeartrdm00 = G1168;
if yeartrdd98 =. then yeartrdd00 = G1168 + G1171; 
/*2002*/
if yearscdm00 =. then yearscdm02 = HB066_2;
if yearscdd00 =. then yearscdd02 = HB066_2 + HB070_2;
if yeartrdm00 =. then yeartrdm02 = HB066_3;
if yeartrdd00 =. then yeartrdd02 = HB066_3 + HB070_3; 
/*2004*/
if yearscdm02 =. then yearscdm04 = JB066_2;
if yearscdd02 =. then yearscdd04 = JB066_2 + JB070_2;
if yeartrdm02 =. then yeartrdm04 = JB066_3;
if yeartrdd02 =. then yeartrdd04 = JB066_3 + JB070_3; 
/*2006*/
if yearscdm04 =. then yearscdm06 = KB066_2;
if yearscdd04 =. then yearscdd06 = KB066_2 + KB070_2;
if yeartrdm04 =. then yeartrdm06 = KB066_3;
if yeartrdd04 =. then yeartrdd06 = KB066_3 + KB070_3; 
/*2008*/
if yearscdm06 =. then yearscdm08 = LB066_2;
if yearscdd06 =. then yearscdd08 = LB066_2 + LB070_2;
if yeartrdm06 =. then yeartrdm08 = LB066_3;
if yeartrdd06 =. then yeartrdd08 = LB066_3 + LB070_3; 
/*2010*/
if yearscdm08 =. then yearscdm10 = MB066_2;
if yearscdd08 =. then yearscdd10 = MB066_2 + MB070_2;
if yeartrdm08 =. then yeartrdm10 = MB066_3;
if yeartrdd08 =. then yeartrdd10 = MB066_3 + MB070_3; 
/*2012*/
if yearscdm10 =. then yearscdm12 = NB066_2;
if yearscdd10 =. then yearscdd12 = NB066_2 + NB070_2;
if yeartrdm10 =. then yeartrdm12 = NB066_3;
if yeartrdd10 =. then yeartrdd12 = NB066_3 + NB070_3; 

/*Set marriage/divorce year > interview year as missing*/
if yearscdm92 > 1992 then yearscdm92 =.;
if yearscdd92 > 1992 then yearscdd92 =.;
if yeartrdm92 > 1992 then yeartrdm92 =.;
if yeartrdd92 > 1992 then yeartrdd92 =.;
if yearscdm93 > 1993 then yearscdm93 =.;
if yearscdd93 > 1993 then yearscdd93 =.;
if yeartrdm93 > 1993 then yeartrdm93 =.;
if yeartrdd93 > 1993 then yeartrdd93 =.;
if yearscdm95 > 1995 then yearscdm95 =.;
if yearscdd95 > 1995 then yearscdd95 =.;
if yeartrdm95 > 1995 then yeartrdm95 =.;
if yeartrdd95 > 1995 then yeartrdd95 =.;
if yearscdm96 > 1996 then yearscdm96 =.;
if yearscdd96 > 1996 then yearscdd96 =.;
if yeartrdm96 > 1996 then yeartrdm96 =.;
if yeartrdd96 > 1996 then yeartrdd96 =.;
if yearscdm98 > 1998 then yearscdm98 =.;
if yearscdd98 > 1998 then yearscdd98 =.;
if yeartrdm98 > 1998 then yeartrdm98 =.;
if yeartrdd98 > 1998 then yeartrdd98 =.;
if yearscdm00 > 2000 then yearscdm00 =.;
if yearscdd00 > 2000 then yearscdd00 =.;
if yeartrdm00 > 2000 then yeartrdm00 =.;
if yeartrdd00 > 2000 then yeartrdd00 =.;
if yearscdm02 > 2002 then yearscdm02 =.;
if yearscdd02 > 2002 then yearscdd02 =.;
if yeartrdm02 > 2002 then yeartrdm02 =.;
if yeartrdd02 > 2002 then yeartrdd02 =.;
if yearscdm04 > 2004 then yearscdm04 =.;
if yearscdd04 > 2004 then yearscdd04 =.;
if yeartrdm04 > 2004 then yeartrdm04 =.;
if yeartrdd04 > 2004 then yeartrdd04 =.;
if yearscdm06 > 2006 then yearscdm06 =.;
if yearscdd06 > 2006 then yearscdd06 =.;
if yeartrdm06 > 2006 then yeartrdm06 =.;
if yeartrdd06 > 2006 then yeartrdd06 =.;
if yearscdm08 > 2008 then yearscdm08 =.;
if yearscdd08 > 2008 then yearscdd08 =.;
if yeartrdm08 > 2008 then yeartrdm08 =.;
if yeartrdd08 > 2008 then yeartrdd08 =.;
if yearscdm10 > 2010 then yearscdm10 =.;
if yearscdd10 > 2010 then yearscdd10 =.;
if yeartrdm10 > 2010 then yeartrdm10 =.;
if yeartrdd10 > 2010 then yeartrdd10 =.;
if yearscdm12 > 2012 then yearscdm12 =.;
if yearscdd12 > 2012 then yearscdd12 =.;
if yeartrdm12 > 2012 then yeartrdm12 =.;
if yeartrdd12 > 2012 then yeartrdd12 =.;
run;


/*Age at second/third marriage/divorce*/
data a_hrs5;
set a_hrs5;
/*1992*/
agescdm92 = yearscdm92 - rabyear;
agescdd92 = yearscdd92 - rabyear;
agetrdm92 = yeartrdm92 - rabyear;
agetrdd92 = yeartrdd92 - rabyear;
/*1993*/
agescdm93 = yearscdm93 - rabyear;
agescdd93 = yearscdd93 - rabyear;
agetrdm93 = yeartrdm93 - rabyear;
agetrdd93 = yeartrdd93 - rabyear;
/*1994: not available*/
/*1995*/
agescdm95 = yearscdm95 - rabyear;
agescdd95 = yearscdd95 - rabyear;
agetrdm95 = yeartrdm95 - rabyear;
agetrdd95 = yeartrdd95 - rabyear;
/*1996*/
agescdm96 = yearscdm96 - rabyear;
agescdd96 = yearscdd96 - rabyear;
agetrdm96 = yeartrdm96 - rabyear;
agetrdd96 = yeartrdd96 - rabyear;
/*1998*/
agescdm98 = yearscdm98 - rabyear;
agescdd98 = yearscdd98 - rabyear;
agetrdm98 = yeartrdm98 - rabyear;
agetrdd98 = yeartrdd98 - rabyear;
/*2000*/
agescdm00 = yearscdm00 - rabyear;
agescdd00 = yearscdd00 - rabyear;
agetrdm00 = yeartrdm00 - rabyear;
agetrdd00 = yeartrdd00 - rabyear;
/*2002*/
agescdm02 = yearscdm02 - rabyear;
agescdd02 = yearscdd02 - rabyear;
agetrdm02 = yeartrdm02 - rabyear;
agetrdd02 = yeartrdd02 - rabyear;
/*2004*/
agescdm04 = yearscdm04 - rabyear;
agescdd04 = yearscdd04 - rabyear;
agetrdm04 = yeartrdm04 - rabyear;
agetrdd04 = yeartrdd04 - rabyear;
/*2006*/
agescdm06 = yearscdm06 - rabyear;
agescdd06 = yearscdd06 - rabyear;
agetrdm06 = yeartrdm06 - rabyear;
agetrdd06 = yeartrdd06 - rabyear;
/*2008*/
agescdm08 = yearscdm08 - rabyear;
agescdd08 = yearscdd08 - rabyear;
agetrdm08 = yeartrdm08 - rabyear;
agetrdd08 = yeartrdd08 - rabyear;
/*2010*/
agescdm10 = yearscdm10 - rabyear;
agescdd10 = yearscdd10 - rabyear;
agetrdm10 = yeartrdm10 - rabyear;
agetrdd10 = yeartrdd10 - rabyear;
/*2012*/
agescdm12 = yearscdm12 - rabyear;
agescdd12 = yearscdd12 - rabyear;
agetrdm12 = yeartrdm12 - rabyear;
agetrdd12 = yeartrdd12 - rabyear;
run;

/*Set negative ages as missing*/
data a_hrs6;
set a_hrs5;
array md3[48]
agescdm92 agescdm93 agescdm95 agescdm96 agescdm98 agescdm00 agescdm02 agescdm04 agescdm06 agescdm08 agescdm10 agescdm12
agescdd92 agescdd93 agescdd95 agescdd96 agescdd98 agescdd00 agescdd02 agescdd04 agescdd06 agescdd08 agescdd10 agescdd12 
agetrdm92 agetrdm93 agetrdm95 agetrdm96 agetrdm98 agetrdm00 agetrdm02 agetrdm04 agetrdm06 agetrdm08 agetrdm10 agetrdm12 
agetrdd92 agetrdd93 agetrdd95 agetrdd96 agetrdd98 agetrdd00 agetrdd02 agetrdd04 agetrdd06 agetrdd08 agetrdd10 agetrdd12
;
do i = 1 to 48;
	if md3[i] < 0 then md3[i] =.;
end;
run;

/*Age at second/third marriage/divorce*/
data a_hrs6a;
set a_hrs6;
if agescdm92 ^=. then agescdm = agescdm92;
else if agescdm93 ^=. then agescdm = agescdm93;
else if agescdm95 ^=. then agescdm = agescdm95;
else if agescdm96 ^=. then agescdm = agescdm96;
else if agescdm98 ^=. then agescdm = agescdm98;
else if agescdm00 ^=. then agescdm = agescdm00;
else if agescdm02 ^=. then agescdm = agescdm02;
else if agescdm04 ^=. then agescdm = agescdm04;
else if agescdm06 ^=. then agescdm = agescdm06;
else if agescdm08 ^=. then agescdm = agescdm08;
else if agescdm10 ^=. then agescdm = agescdm10;
else if agescdm12 ^=. then agescdm = agescdm12;
else if agefstm=.N then agescdm=.N;
else if agefstd=.F then agescdm=.F;
else if agefstd not in (., .N ,.F) and agescdm=. then agescdm=.R;

if agescdd92 ^=. then agescdd = agescdd92;
else if agescdd93 ^=. then agescdd = agescdd93;
else if agescdd95 ^=. then agescdd = agescdd95;
else if agescdd96 ^=. then agescdd = agescdd96;
else if agescdd98 ^=. then agescdd = agescdd98;
else if agescdd00 ^=. then agescdd = agescdd00;
else if agescdd02 ^=. then agescdd = agescdd02;
else if agescdd04 ^=. then agescdd = agescdd04;
else if agescdd06 ^=. then agescdd = agescdd06;
else if agescdd08 ^=. then agescdd = agescdd08;
else if agescdd10 ^=. then agescdd = agescdd10;
else if agescdd12 ^=. then agescdd = agescdd12;
else if agefstm=.N then agescdd=.N;
else if agefstd=.F then agescdd=.F;
else if agescdm=.R then agescdd=.R;
else if agescdm not in (., .N, .F, .R) and agescdd=. then agescdd=.S;

if agetrdm92 ^=. then agetrdm = agetrdm92;
else if agetrdm93 ^=. then agetrdm = agetrdm93;
else if agetrdm95 ^=. then agetrdm = agetrdm95; 
else if agetrdm96 ^=. then agetrdm = agetrdm96;
else if agetrdm98 ^=. then agetrdm = agetrdm98;
else if agetrdm00 ^=. then agetrdm = agetrdm00;
else if agetrdm02 ^=. then agetrdm = agetrdm02;
else if agetrdm04 ^=. then agetrdm = agetrdm04;
else if agetrdm06 ^=. then agetrdm = agetrdm06;
else if agetrdm08 ^=. then agetrdm = agetrdm08;
else if agetrdm10 ^=. then agetrdm = agetrdm10;
else if agetrdm12 ^=. then agetrdm = agetrdm12;
else if agefstm=.N then agetrdm=.N;
else if agefstd=.F then agetrdm=.F;
else if agescdm=.R then agetrdm=.R;
else if agescdd=.S then agetrdm=.S;
else if agescdd not in (., .N, .F, .R, .S) and agetrdm=. then agetrdm=.D;

if agetrdd92 ^=. then agetrdd = agetrdd92;
else if agetrdd93 ^=. then agetrdd = agetrdd93;
else if agetrdd95 ^=. then agetrdd = agetrdd95;
else if agetrdd96 ^=. then agetrdd = agetrdd96;
else if agetrdd98 ^=. then agetrdd = agetrdd98;
else if agetrdd00 ^=. then agetrdd = agetrdd00;
else if agetrdd02 ^=. then agetrdd = agetrdd02;
else if agetrdd04 ^=. then agetrdd = agetrdd04;
else if agetrdd06 ^=. then agetrdd = agetrdd06;
else if agetrdd08 ^=. then agetrdd = agetrdd08;
else if agetrdd10 ^=. then agetrdd = agetrdd10;
else if agetrdd12 ^=. then agetrdd = agetrdd12;
else if agefstm=.N then agetrdd=.N;
else if agefstd=.F then agetrdd=.F;
else if agescdm=.R then agetrdd=.R;
else if agescdd=.S then agetrdd=.S;
else if agetrdm=.D then agetrdd=.D;
else if agetrdm not in (., .N, .F, .R, .S, .D) and agetrdd=. then agetrdd=.T;
run;


/****************************************************************/
/*                 SELF RATE HEALTH AS CHILD                    */

data a_hrs_child;
set a_hrs6a;
array child[8] F992 G1079 HB019 JB019 KB019 LB019 MB019 NB019;
do i = 1 to 8;
	if child[i] in (8,9) then child[i] =.;
end;
run;

data a_hrs_child;
set a_hrs_child;
/*1998*/
if F992 >=0 then Health_child98 = F992;
/*2000*/
if Health_child98 =. and G1079 >=0 then Health_child00 = G1079;
/*2002*/
if Health_child00 =. and HB019 >=0 then Health_child02 = HB019;
/*2004*/
if Health_child02 =. and JB019 >=0 then Health_child04 = JB019;
/*2006*/
if Health_child04 =. and KB019 >=0 then Health_child06 = KB019;
/*2008*/
if Health_child06 =. and LB019 >=0 then Health_child08 = LB019;
/*2010*/
if Health_child08 =. and MB019 >=0 then Health_child10 = MB019;
/*2012*/
if Health_child10 =. and NB019 >=0 then Health_child12 = NB019;
run;


data a_hrs_child;
set a_hrs_child;
if Health_child98 ^=. then Health_child = Health_child98;
else if Health_child00 ^=. then Health_child = Health_child00;
else if Health_child02 ^=. then Health_child = Health_child02;
else if Health_child04 ^=. then Health_child = Health_child04;
else if Health_child06 ^=. then Health_child = Health_child06;
else if Health_child08 ^=. then Health_child = Health_child08;
else if Health_child10 ^=. then Health_child = Health_child10;
else if Health_child12 ^=. then Health_child = Health_child12;
run;


/****************************************************************/
/*                     CHILDHOOD OTHERS                         */
data a_hrs_final;
set a_hrs_child;
/*Financial help from relatives*/
if F995 = 1 or G1082 = 1 or HB022 = 1 or JB022 = 1 or KB022 = 1 or
   LB022 = 1 or MB022 = 1 or NB022 = 1 then help_ecom = 1;
else if F995 = 5 or G1082 = 5 or HB022 = 5 or JB022 = 5 or KB022 = 5 or
   LB022 = 5 or MB022 = 5 or NB022 = 5 then help_ecom = 0;
else cccc =.;
/*Father's occupation before 16*/

/*Blow to head cause loss of consciousness*/
if LB119 = 1 or MB119 = 1 or NB119 = 1 then blow_head = 1;
else if LB119 = 5 or MB119 = 5 or NB119 = 5 then blow_head = 0;
else blow_head =.;
run;




/****************************************************************************/
/*                             Section B Health                             */
/****************************************************************************/

/*Set all the DK RF as missing*/
data b_hrs;
set b_hrs;
if F1271 in (98,99) then F1271 =.;
if F1272 in (9998,9999) then F1272 =.;
if F1273 in (98,99) then F1273 =.;
if G1404 in (98,99) then G1404 =.;
if G1405 in (9998,9999) then G1405 =.;
if G1406 in (98,99) then G1406 =.;
if HC120 in (98,99) then HC120 =.;
if HC121 in (9998,9999) then HC121 =.;
if HC122 in (8,9) then HC122 =.;
if JC120 in (98,99) then JC120 =.;
if JC121 in (9998,9999) then JC121 =.;
if JC122 in (98,99) then JC122 =.;
if KC120 in (98,99) then KC120 =.;
if KC121 in (9998,9999) then KC121 =.;
if KC122 in (98,99) then KC122 =.;
if LC120 in (98,99) then LC120 =.;
if LC121 in (9998,9999) then LC121 =.;
if LC122 in (98,99) then LC122 =.;
if MC120 in (98,99) then MC120 =.;
if MC121 in (9998,9999) then MC121 =.;
if MC122 in (98,99) then MC122 =.;
if NC120 in (98,99) then NC120 =.;
if NC121 in (9998,9999) then NC121 =.;
if NC122 in (98,99) then NC122 =.;
run;

/*Age at first smoking*/
data b_hrs1;
set b_hrs;
/*1998*/
if F1271 >=0 then agefstsmk98 = F1271;
else if F1272 >=0 then agefstsmk98 = F1272 - rabyear;
else if F1273 >=0 then agefstsmk98 = 1998 - F1273 - rabyear;
/*2000*/
if agefstsmk98 =. then do;
	if G1404 >=0 then agefstsmk00 = G1404;
	else if G1405 >=0 then agefstsmk00 = G1405 - rabyear;
	else if G1406 >=0 then agefstsmk00 = 2000 - G1406 - rabyear;
end;
/*2002*/
if agefstsmk00 =. then do;
	if HC120 >=0 then agefstsmk02 = HC120;
	else if HC121 >=0 then agefstsmk02 = HC121 - rabyear;
	else if HC122 >=0 then agefstsmk02 = 2002 - HC122 - rabyear;
end;
/*2004*/
if agefstsmk02 =. then do;
	if JC120 >=0 then agefstsmk04 = JC120;
	else if JC121 >=0 then agefstsmk04 = JC121 - rabyear;
	else if JC122 >=0 then agefstsmk04 = 2004 - JC122 - rabyear;
end;
/*2006*/
if agefstsmk04 =. then do;
	if KC120 >=0 then agefstsmk06 = KC120;
	else if KC121 >=0 then agefstsmk06 = KC121 - rabyear;
	else if KC122 >=0 then agefstsmk06 = 2006 - KC122 - rabyear;
end;
/*2008*/
if agefstsmk06 =. then do;
	if LC120 >=0 then agefstsmk08 = LC120;
	else if LC121 >=0 then agefstsmk08 = LC121 - rabyear;
	else if LC122 >=0 then agefstsmk08 = 2008 - LC122 - rabyear;
end;
/*2010*/
if agefstsmk08 =. then do;
	if MC120 >=0 then agefstsmk10 = MC120;
	else if MC121 >=0 then agefstsmk10 = MC121 - rabyear;
	else if MC122 >=0 then agefstsmk10 = 2010 - MC122 - rabyear;
end;
/*2012*/
if agefstsmk10 =. then do;
	if NC120 >=0 then agefstsmk12 = NC120;
	else if NC121 >=0 then agefstsmk12 = NC121 - rabyear;
	else if NC122 >=0 then agefstsmk12 = 2012 - NC122 - rabyear;
end;
run;


data b_hrs_final;
set b_hrs1;
if agefstsmk98 ^=. then agefstsmk = agefstsmk98;
else if agefstsmk00 ^=. then agefstsmk = agefstsmk00;
else if agefstsmk02 ^=. then agefstsmk = agefstsmk02;
else if agefstsmk04 ^=. then agefstsmk = agefstsmk04;
else if agefstsmk06 ^=. then agefstsmk = agefstsmk06;
else if agefstsmk08 ^=. then agefstsmk = agefstsmk08;
else if agefstsmk10 ^=. then agefstsmk = agefstsmk10;
else if agefstsmk12 ^=. then agefstsmk = agefstsmk12;
run;


/****************************************************************************/
/*                         Section GH/L Job History                         */
/****************************************************************************/
/*Tips: no data in 1992 and 1994

             age at first job: E3461 F3973 G4263 HL129 JL067 KL067 LL067 ML067 NL067
first work more than 6 months: E3462 F3974 G4264 HL152 JL068 KL068 LL068 ML068 NL068
                  earlist job:                   HL177 JL094 KL094 LL094 ML094 NL094
*/

data gh_l_hrs; 
set gh_l_hrs;
if E3462>=9995 then E3462=.;
if F3974>=9995 then F3974=.;
if G4264>=9995 then G4264=.;
if HL152>=9995 then HL152=.;                                             
if JL068>=9995 then JL068=.;
if KL068>=9995 then KL068=.;
if LL068>=9995 then LL068=.;
if ML068>=9995 then ML068=.;
if NL068>=9995 then NL068=.;

if HL177>=9998 then HL177=.;
if JL094>=9998 then JL094=.;
if KL094>=9998 then KL094=.;
if LL094>=9998 then LL094=.;
if ML094>=9998 then ML094=.;
if NL094>=9998 then NL094=.;
run;

data gh_l_hrs;
set gh_l_hrs;

array yearjob_ori [9] E3461 F3973 G4263 HL129 JL067 KL067 LL067 ML067 NL067;
array yearjob_6mo [9] E3462 F3974 G4264 HL152 JL068 KL068 LL068 ML068 NL068;
array yearjob_erli [6] HL177 JL094 KL094 LL094 ML094 NL094;
array agejob_ori [9] agefstjob96_ori agefstjob98_ori agefstjob00_ori agefstjob02_ori agefstjob04_ori agefstjob06_ori agefstjob08_ori agefstjob10_ori agefstjob12_ori;
array agejob_6mo [9] agefstjob96_6mo agefstjob98_6mo agefstjob00_6mo agefstjob02_6mo agefstjob04_6mo agefstjob06_6mo agefstjob08_6mo agefstjob10_6mo agefstjob12_6mo;
array agejob_erli [6] agefstjob02_erli agefstjob04_erli agefstjob06_erli agefstjob08_erli agefstjob10_erli agefstjob12_erli;

/*Create agefstjob_ori and agefstjob_6mo*/
do i = 1 to 9;
	agejob_ori[i] = yearjob_ori[i] - rabyear;
	if agejob_ori[i] > .Z and agejob_ori[i] <= 0 then agejob_ori[i] =.;

	agejob_6mo[i] = yearjob_6mo[i] - rabyear;
	if agejob_6mo[i] > .Z and agejob_6mo[i] <= 0 then agejob_6mo[i] =.;
end;
/*Create agefstjob_erli*/
do i = 1 to 6;
	agejob_erli[i] = yearjob_erli[i] - rabyear;
	if agejob_erli[i] > .Z and agejob_erli[i] <= 0 then agejob_erli[i] =.;
end;
run;
/*

*Conclusion: as the distribution of age at first reported job is weird, I decided to use only the first two vars to find min
             age in each wave
*/

data gh_l_hrs;
set gh_l_hrs;
/*Find minimum age at first job among three vars above*/
/*1996*/
agefstjob96 = min(agefstjob96_ori, agefstjob96_6mo);
/*1998*/
agefstjob98 = min(agefstjob98_ori, agefstjob98_6mo);
/*2000*/
agefstjob00 = min(agefstjob00_ori, agefstjob00_6mo);
/*2002*/
agefstjob02 = min(agefstjob02_ori, agefstjob02_6mo);
/*2004*/
agefstjob04 = min(agefstjob04_ori, agefstjob04_6mo);
/*2006*/
agefstjob06 = min(agefstjob06_ori, agefstjob06_6mo);
/*2008*/
agefstjob08 = min(agefstjob08_ori, agefstjob08_6mo);
/*2010*/
agefstjob10 = min(agefstjob10_ori, agefstjob10_6mo);
/*2012*/
agefstjob12 = min(agefstjob12_ori, agefstjob12_6mo);


/*1996*/
agefstjob96_3v = min(agefstjob96_ori, agefstjob96_6mo);
/*1998*/
agefstjob98_3v = min(agefstjob98_ori, agefstjob98_6mo);
/*2000*/
agefstjob00_3v = min(agefstjob00_ori, agefstjob00_6mo);
/*2002*/
agefstjob02_3v = min(agefstjob02_ori, agefstjob02_6mo);
/*2004*/
agefstjob04_3v = min(agefstjob04_ori, agefstjob04_6mo);
/*2006*/
agefstjob06_3v = min(agefstjob06_ori, agefstjob06_6mo, agefstjob06_erli);
/*2008*/
agefstjob08_3v = min(agefstjob08_ori, agefstjob08_6mo, agefstjob08_erli);
/*2010*/
agefstjob10_3v = min(agefstjob10_ori, agefstjob10_6mo, agefstjob10_erli);
/*2012*/
agefstjob12_3v = min(agefstjob12_ori, agefstjob12_6mo, agefstjob12_erli);
run;

data gh_l_hrs_final;
set gh_l_hrs;
/*age at first job final version1: use agefstjob and agefstjob_6mo*/
if agefstjob96 ^=. then agefstjob = agefstjob96;
else if agefstjob98 ^=. then agefstjob = agefstjob98;
else if agefstjob00 ^=. then agefstjob = agefstjob00;
else if agefstjob02 ^=. then agefstjob = agefstjob02;
else if agefstjob04 ^=. then agefstjob = agefstjob04;
else if agefstjob06 ^=. then agefstjob = agefstjob06;
else if agefstjob08 ^=. then agefstjob = agefstjob08;
else if agefstjob10 ^=. then agefstjob = agefstjob10;
else if agefstjob12 ^=. then agefstjob = agefstjob12;

/*age at first job final version2: only use agefstjob_6mo*/
if agefstjob96_6mo ^=. then agefstjob_6mo = agefstjob96_6mo;
else if agefstjob98_6mo ^=. then agefstjob_6mo = agefstjob98_6mo;
else if agefstjob00_6mo ^=. then agefstjob_6mo = agefstjob00_6mo;
else if agefstjob02_6mo ^=. then agefstjob_6mo = agefstjob02_6mo;
else if agefstjob04_6mo ^=. then agefstjob_6mo = agefstjob04_6mo;
else if agefstjob06_6mo ^=. then agefstjob_6mo = agefstjob06_6mo;
else if agefstjob08_6mo ^=. then agefstjob_6mo = agefstjob08_6mo;
else if agefstjob10_6mo ^=. then agefstjob_6mo = agefstjob10_6mo;
else if agefstjob12_6mo ^=. then agefstjob_6mo = agefstjob12_6mo;

/*age at first job final version3: use agefstjob_ori, agefstjob_6mo and agefstjob_erli*/
if agefstjob96_3v ^=. then agefstjob_3v = agefstjob96_3v;
else if agefstjob98_3v ^=. then agefstjob_3v = agefstjob98_3v;
else if agefstjob00_3v ^=. then agefstjob_3v = agefstjob00_3v;
else if agefstjob02_3v ^=. then agefstjob_3v = agefstjob02_3v;
else if agefstjob04_3v ^=. then agefstjob_3v = agefstjob04_3v;
else if agefstjob06_3v ^=. then agefstjob_3v = agefstjob06_3v;
else if agefstjob08_3v ^=. then agefstjob_3v = agefstjob08_3v;
else if agefstjob10_3v ^=. then agefstjob_3v = agefstjob10_3v;
else if agefstjob12_3v ^=. then agefstjob_3v = agefstjob12_3v;
run;                                                      

data gh_l_hrs_final;
set gh_l_hrs_final;
keep
hhid pn
agefstjob_6mo
;
rename agefstjob_6mo = agefstjob;
run;                                                                    




/**********************************************************************************************************************************************/
/**************************************************************MERGE DATASETS******************************************************************/
/**********************************************************************************************************************************************/
proc sort data = a_hrs_final; by hhid pn; run;
proc sort data = b_hrs_final; by hhid pn; run;
proc sort data = gh_l_hrs_final; by hhid pn; run;

data hrs_raw;
merge a_hrs_final b_hrs_final gh_l_hrs_final;
by hhid pn;
run;

/**********************************************************************************************************************************************/
/**************************************************************LABEL VARIABLES*****************************************************************/
/**********************************************************************************************************************************************/
data hrs_raw;
set hrs_raw;
label
	agefstm = "Age at first marriage"
	agefstd = "Age at first divorce"
	agescdm = "Age at second marriage"
	agescdd = "Age at second divorce"
	agetrdm = "Age at third marriage"
	agetrdd = "Age at third divorce"
	agefstsmk = "Age at first smoking"
	agefstjob = "Age at first job"
	Health_child = "Self-reported health as child"
	help_ecom = "Receive help from relatives because of economic problems in childhood"
	blow_head = "Blow to the head"
;
run;

/*
data created.hrs_raw; 
set hrs_raw; 
keep
hhidpn hhid pn
agefstm
agefstd
agescdm
agescdd
agetrdm
agetrdd
agefstsmk
agefstjob

V225
V227
;
run;
*/
