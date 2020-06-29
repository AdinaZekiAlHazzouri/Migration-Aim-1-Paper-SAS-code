
libname created 'C:\Users\\\\\\\SAS datasets';
libname RAND 'C:\Users\\\\\\\RAND_Files';
libname Tracker 'C:\Users\\\\\\\Tracker_Files';
run;
options nofmterr;


/**********************************************************************************************************************************************/
/************************************************************CALL IN HRS DATASETS**************************************************************/
/**********************************************************************************************************************************************/
data raw;
set created.hrs_raw;
run;

data hrs50;
set created.hrs50_harmonized;
run;

data rand;
set created.hrs_rand;
run;


proc sort data = raw; by hhid pn; run;
proc sort data = hrs50; by hhid pn; run;
proc sort data = rand; by hhid pn; run;

data hrs;
merge raw (in = raw) hrs50 (in = hrs50) rand (in = rand);
by hhid pn;
if hrs50;
run;

/**********************************************************************************************************************************************/
/********************************************************CREATE VARIABLES IN HRS***************************************************************/
/**********************************************************************************************************************************************/

data hrs1;
set hrs;
HRS=1;
migration=2;
/*Parent' education categories*/
if RAMEDUC= 0 then rameduc_m=1;
else if RAMEDUC>=1 and RAMEDUC<=5 then rameduc_m=2;
else if RAMEDUC=6 then rameduc_m=3;
else if RAMEDUC>6 then rameduc_m=4;
else  rameduc_m=RAMEDUC;

if RAFEDUC= 0 then rafeduc_m=1;
else if RAFEDUC>=1 and RAFEDUC<=5 then rafeduc_m=2;
else if RAFEDUC=6 then rafeduc_m=3;
else if RAFEDUC>6 then rafeduc_m=4;
else  rafeduc_m=RAFEDUC;
/*Ever smoked*/
if r1smokev = 1 or r2smokev = 1 or r3smokev = 1 or r4smokev = 1 or r5smokev = 1 or r6smokev = 1 or r7smokev = 1 
   or r8smokev = 1 or r9smokev = 1 or r10smokev = 1 or r11smokev = 1 then rasmokev = 1;
else rasmokev = 0;
/*Ever worked*/
if R1JJOBS in (.,0,9) and R2JJOBS in (.,0,9) and R3JJOBS in (.,0,9) and R4JJOBS in (.,0,9) and R5JJOBS in (.,0,9) and R6JJOBS in (.,0,9) 
and R7JJOBS in (.,0,9) and R8JJOBS in (.,0,9) and R9JJOBS in (.,0,9) and R10JJOBS in (.,0,9) and R11JJOBS in (.,0,9) then RAJJOBS = 0;
else RAJJOBS = 1;
/*Age at migration*/
if immgyear >= 0 and immgyear ^= 9999 then agefstmig = immgyear - rabyear;
if agefstmig < 0 then agefstmig =.; /*Set negative age as missing*/
run;




/**********************************************************************************************************************************************/
/***********************************************************CALL IN MHAS DATASETS**************************************************************/
/**********************************************************************************************************************************************/
data mhas50_harmonized;
set created.mhas50_harmonized;
/*keep
unhhidnp
unhhid
np
ragey01 ragey03 ragey12
rabyear rabmonth
radyear radmonth
rinw01 rinw03 rinw12
firstage lastage
mortality agedeath
ragender             
raedyrs                  
rameduc_m rafeduc_m      
rheight01 rheight03 rheight12 
rbmi01 rbmi03 rbmi12         
RSMOKEV01 RSMOKEV03 RSMOKEV12   
RSMOKEN01 RSMOKEN03 RSMOKEN12   
RWORK01 RWORK03 RWORK12        
RMRCT01 RMRCT03 RMRCT12
;
*/
rename
unhhidnp  = hhidpn
unhhid    = hhid
np        = pn
ragey01   = GAGE
ragey03   = HAGE
ragey12   = NAGE
rheight01 = r5height
rheight03 = r6height
rheight12 = r11height
rbmi01    = r5bmi
rbmi03    = r6bmi
rbmi12    = r11bmi      
rsmokev01 = r5smokev
rsmokev03 = r6smokev
rsmokev12 = r11smokev
rsmoken01 = r5smoken
rsmoken03 = r6smoken
rsmoken12 = r11smoken
RWORK01   = R5WORK
RWORK03   = R6WORK
RWORK12   = R11WORK
RMRCT01   = R5MRCT
RMRCT03   = R6MRCT 
RMRCT12   = R11MRCT
;
run;

data mhas_raw;
set created.mhas_raw;
rename
unhhidnp  = hhidpn
unhhid    = hhid
np        = pn
worked    = RAJJOBS
;
run;

proc sort data = mhas50_harmonized; by hhid pn; run;
proc sort data = mhas_raw; by hhid pn; run;

data mhas;
merge mhas_raw(in = mhasraw) mhas50_harmonized(in = mhas50);
by hhid pn;
if mhas50;
run;

/**********************************************************************************************************************************************/
/**********************************************************CREATE VARIABLES IN MHAS************************************************************/
/**********************************************************************************************************************************************/
data mhas1;
set mhas;
/*Ever smoked*/
if r5smokev = 1 or r6smokev = 1 or r11smokev = 1 then rasmokev = 1;
else rasmokev = 0;
run;


/**********************************************************************************************************************************************/
/*************************************************************MERGE MHAS AND HRS DATASETS******************************************************/
/**********************************************************************************************************************************************/
proc sort data = mhas1; by hhid pn; run;
proc sort data = hrs1; by hhid pn; run;

data mhas1;
set mhas1 (rename = (hhid = hhidnum pn = pnnum));
hhid = put (hhidnum, 5.);
pn = put (pnnum,2.);
drop hhidnum pnnum;
run;

data hrs_mhas_paper1;
merge hrs1 mhas1;
by hhid pn;
if hrs ^= 1 then hrs = 0;
run;

/*****************************************************************************************************************/
/****************************************CREATE MIGRATION RELATED VARIABLES***************************************/
/*****************************************************************************************************************/
data hrs_mhas_paper1;
set hrs_mhas_paper1;
/*Migration binary categories*/
if migration = 0 then migration_bi = 0;
if migration in (1,2)then migration_bi = 1; /*migrants in HRS and return migrants of MHAS*/
run;

/* Check if age at death for all deceased non-migrants >= age at first interview */
proc freq data = hrs_mhas_paper1; tables agedeath/missing; where HRS = 0 and migration_bi = 0; run;

data hrs_mhas_paper1;
set hrs_mhas_paper1;
if HRS = 0 and migration_bi = 0 then do;
	if agedeath in (.M, .X) then isError = 0;
	else if agedeath >= firstage then isError = 0;
	else isError = 1;
end;
else isError = 0;
run; 
proc freq data = hrs_mhas_paper1; tables isError; run; *there is 1 person with agedeath < firstage;

/*Delete the person with agedeath < firstage*/
data hrs_mhas_paper1;
set hrs_mhas_paper1;
if isError = 1 then delete;
run; 

/*Create variable time to event*/
data hrs_mhas_paper2;
set hrs_mhas_paper1;
/*Time to event: where event is age at migration for migrants and age at first interview for non-migrants*/
if HRS = 0 then do;
	if migration_bi = 1 then timetoev = agefstmig; *229 missing;
	if migration_bi = 0 then timetoev = firstage; *22 missing;
end;
if HRS = 1 then do;
	timetoev = agefstmig; /*Sample only includes migrants*/     * 57 missing;
end;
run;

/********************Limit participants to individuals with time to event************************/
data HRS_MHAS_PAPER2;
set HRS_MHAS_PAPER2;
where timetoev not in (.,.M); 
label
migration_bi = "Migration binary categories"
rasmokev = "Ever smoke or not"
timetoev = "Time to event (migration or first interview)"
;
run;


/*****************************************************************************************************************/
/********************************************FIX MARITAL HISTORY ISSUES ******************************************/
/*****************************************************************************************************************/

/*****HRS****/
*****************************************************************************************************
.N = never married
.F = married once, never divorced
.R = married and divorced once, not remarried
.S = married twice, divorced only once
.D = married and divorced twice, not remarried
.T = married three times, divorced only twice

Rules decided for marital status coding:
	- if missing first marriage and divorce, but have second marriage and divorce -> assign second marriage/divorce as first marriage/divorce
    - if missing age at second divorce then give half way of second marriage and third marriage
	- if missing in weird pattern - given median value of sample
******************************************************************************************************;

/*Filling in Missing Information - According to Created Rules*/
data HRS_MHAS_PAPER3; 
set HRS_MHAS_PAPER2;
if HRS = 1 then do;
	*picking up missed age at first marriage > actually there; 
	if V227 ne . and agefstm=. then agefstm=V227-rabyear;
	*imputing those with missing age values but that indicate they were married at some point with median age at first marriage of sample (median= 23 mean=24.3);
	if agefstm=. and V225 ne 6 and V225 ne . then agefstm=23;
	else if agefstm=. and JMARST in (1, 2, 3)then agefstm=23;
	else if agefstm=. and MMARST in (1, 2, 3) then agefstm=23;
	*imputing those have second marriage/divorce but no first m/d: move second marriage/divorce to first;
	if agefstm =. and agefstd =. and agescdm >0 and agescdd >0 then do;
		agefstm = agescdm;
		agefstd = agescdd;
		agescdm = .;
		agescdd = .;
	end;
	*pick up missing value of agescdd: half way between agescdm and agetrdm;
	if agescdm > 0 and agetrdm > 0 and agescdd=.S then do;
		agescdd=(agescdm + agetrdm)/2;
		if agetrdd =.S then agetrdd =.T;
	end;

	*for the 30 individuals with missing in all 6 marital variables: I checked their times of marriage/divorce/widow/unknown end all show number 0, so set them as single;
	if agefstm =. and agefstd =. and agescdm =. and agescdd =. and agetrdm =. and agetrdd =. then agefstm =.N;
	*fix wierd patterns;
	*marriage pattern:second marriage < first end: check==> married twice and divorced/unknown end once==> give sample median in hrs to second marriage (median = 35.5);
	if hhidpn = 500510020 then agescdm = 35.5;
	if hhidpn = 904315010 then agescdm = 35.5;
	if hhidpn = 500975010 then agescdm = 35.5;
	*marriage pattern (21,32,31,41,D,D): check==> married three and divorce twice==> give sample median in hrs to second and third marriage (median = 35.5,47);
	if hhidpn = 501146010 then do;
		agescdm = 35.5;
		agetrdm = 47;
		agetrdd = .T;
	end;
	*marriage pattern (38,51,42,50,D,D): check==> married twice and divorce once (first wave is 2004, age 51 reported)==>flip agefstd and agescdm and delete agescdd;
	if hhidpn = 501955010 then do;
		agefstd = 42;
		agescdm = 51;
		agescdd = .S;
		agetrdm = .S;
		agetrdd = .S;
	end;
	*marriage pattern (30,38,31,44,D,D): check==> married twice and widowed once (first wave is 2010, age 54 reported)==>give agescdd to agescdm;
	if hhidpn = 903105010 then do;
		agescdm = 44;
		agescdd = .S;
		agetrdm = .S;
		agetrdd = .S;
	end;
	******Updating missing indicators*********;
	if agefstm=.N then do;
		agefstd=.N;
		agescdm=.N;
		agescdd=.N;
		agetrdm=.N;
		agetrdd=.N;
	end;
	if agefstm not in (., .N) and agefstd=. then agefstd=.F;
	if agefstd=.F then do;
		agescdm=.F;
		agescdd=.F;
		agetrdm=.F;
		agetrdd=.F;
	end;
	if agefstd not in (., .N ,.F) and agescdm=. then agescdm=.R;
	if agescdm=.R then do;
		agescdd=.R;
		agetrdm=.R;
		agetrdd=.R;
	end;
end;
run;



/*****MHAS****/

**************************************************************************************************************************
.N = never married
.F = married once, never divorced
.R = married and divorced once, not remarried
.L = married n times and divorced n-1 times, not remarried

Fixed age by pattern, extra rules for weird patterns:
	- marriage/divorce age < 3: give sample median age
    - 3 <= marriage/divorce age < 13: add decade
    - agefstd < agefstm: agefstd = agefstm + sample median length of first marriage
    - agelstd < agelstm: agelstd = agelstm + sample median length of last marriage
    - agelstm < agefstd: agelstm = agefstd + sample median length of (agelstm - agefstd)
    - Use marital status in 2012 to double check number of marriages, and delete last marriage if only reported 1 marriage
**************************************************************************************************************************;

data HRS_MHAS_PAPER4; 
set HRS_MHAS_PAPER3;
if hrs = 0 then do;
	/*Create marital history pattern in MHAS*/
	if agefstm >=0 and agefstd >=0 and agelstm >=0 and agelstd >=0 then mstat_mhas = 1;

	else if agefstm <0 and agefstd >=0 and agelstm >=0 and agelstd >=0 then mstat_mhas = 2;
	else if agefstm >=0 and agefstd <0 and agelstm >=0 and agelstd >=0 then mstat_mhas = 3;
	else if agefstm >=0 and agefstd >=0 and agelstm <0 and agelstd >=0 then mstat_mhas = 4;
	else if agefstm >=0 and agefstd >=0 and agelstm >=0 and agelstd <0 then mstat_mhas = 5;

	else if agefstm <0 and agefstd <0 and agelstm >=0 and agelstd >=0 then mstat_mhas = 6;
	else if agefstm <0 and agefstd >=0 and agelstm <0 and agelstd >=0 then mstat_mhas = 7;
	else if agefstm <0 and agefstd >=0 and agelstm >=0 and agelstd <0 then mstat_mhas = 8;
	else if agefstm >=0 and agefstd <0 and agelstm <0 and agelstd >=0 then mstat_mhas = 9;
	else if agefstm >=0 and agefstd <0 and agelstm >=0 and agelstd <0 then mstat_mhas = 10;
	else if agefstm >=0 and agefstd >=0 and agelstm <0 and agelstd <0 then mstat_mhas = 11;

	else if agefstm <0 and agefstd <0 and agelstm <0 and agelstd >=0 then mstat_mhas = 12;
	else if agefstm <0 and agefstd <0 and agelstm >=0 and agelstd <0 then mstat_mhas = 13;
	else if agefstm <0 and agefstd >=0 and agelstm <0 and agelstd <0 then mstat_mhas = 14;
	else if agefstm >=0 and agefstd <0 and agelstm <0 and agelstd <0 then mstat_mhas = 15;

	else if agefstm =.N and agefstd =.N and agelstm =.N and agelstd =.N then mstat_mhas = 16;
	else if agefstm =. and agefstd =. and agelstm =. and agelstd =. then mstat_mhas = 17;
	else mstat_mhas = 18;
end;
run;


data HRS_MHAS_PAPER5;
set HRS_MHAS_PAPER4;
	/****Fix marital history errors by pattern****/
    *sample median of agefstm = 22 agefstd =28 agelstm = 25 agelstd = 60;
	if mstat_mhas = 2 then do;
		agefstm = agelstm;
		agefstd = agelstd;
		agelstm = .R;
		agelstd = .R;
	end;
	else if mstat_mhas = 3 then do;
		agefstd = (agefstm + agelstm)/2;
	end;
	else if mstat_mhas = 4 then do;
		agelstm = (agefstd + agelstd)/2;
	end;
	else if mstat_mhas = 5 then do;
		agelstd = .L;
	end;
	else if mstat_mhas = 6 then do;
		agefstm = agelstm;
		agefstd = agelstd;
		agelstm = .R;
		agelstd = .R;
	end;
	else if mstat_mhas = 8 then do;
		agefstm = agelstm;
		agelstm = .R;
		agelstd = .R;
	end;
	else if mstat_mhas = 9 then do;
		agefstd = agelstd;
		agelstm = .R;
		agelstd = .R;
	end;
	else if mstat_mhas = 10 then do;
		agefstd = (agefstm + agelstm)/2;
		agelstd = .L;
	end;
	else if mstat_mhas = 11 then do;
		agelstm = .R;
		agelstd = .R;
	end;
	else if mstat_mhas = 12 then do; 
		agefstm = 22;
		agefstd = agelstd;
		agelstm = .R;
		agelstd = .R;
	end;
	else if mstat_mhas = 13 then do;
		agefstm = agelstm;
		agefstd = .F;
		agelstm = .F;
		agelstd = .F;
	end;
	else if mstat_mhas = 14 then do;
		if 0 <= agefstd < 22 then agefstm = agefstd - 1;
		else if agefstd >= 22 then agefstm = 22;
		agelstm = .R;
		agelstd = .R;
	end;
	else if mstat_mhas = 15 then do;
		agefstd = .F;
		agelstm = .F;
		agelstd = .F;
	end;
	else if mstat_mhas = 17 then do;
		if R11MRCT = 1 then do;
			agefstm = 22;
			agefstd = .F;
			agelstm = .F;
			agelstd = .F;
		end;
		if R11MRCT >= 2 then do;
			agefstm = 22;
			agefstd = 23.5;
			agelstm = 25;
			agelstd = .L;
		end;
	end;
/*fix weird patterns*/
if hrs = 0 then do;
	/*Give sample median to age less than 3*/
	if agefstm in (0,1,2) then agefstm = 22;
	if agefstd in (0,1,2) then agefstd = 28;
	if agelstm in (0,1,2) then agelstm = 25;
	if agelstd in (0,1,2) then agelstd = 60;
	/*Add decade to age less than 13*/
	if 0 <= agefstm < 13 or 0 <= agefstd < 13 and agelstm < 0 and agelstd < 0 then do;
		agefstm = agefstm + 10;
		agefstd = .F;
		agelstm = .F;
		agelstd = .F;
	end;
	if 0 <= agefstm < 13 or 0 <= agefstd < 13 and 0 <= agelstm < 13 and agelstd < 0 then do;
		agefstm = agefstm + 10;
		agefstd = agefstm + 10;
		agelstm = agelstm + 10;
		agelstd = .L;
	end;
	if 0 <= agefstm < 13 or 0 <= agefstd < 13 and (agelstm < agefstd + 10) and agelstd < 0 then do;
		agefstm = agefstm + 10;
		agefstd = agefstm + 10;
		agelstm = agelstm + 10;
		agelstd = .L;
	end;
	if 0 <= agefstm < 13 or 0 <= agefstd < 13 and (agelstm >= agefstd + 10) and agelstd < 0 then do;
		agefstm = agefstm + 10;
		agefstd = agefstd + 10;
		agelstm = agelstm;
		agelstd = .L;
	end;
	if hhidpn = 788720 then agelstm = 25;

	/*if agefstd < agefstm: add median length of first marriage to agefstm
	 *if agelstm < agefstd: add 1 to agefstd*/
	if 0 < agefstd < agefstm and agelstm < 0 and agelstd < 0 then do;
		agefstd = agefstm + 7;
	end;
	if 0 < agefstd < agefstm and agelstm > 0 and agelstd < 0 then do;
		agefstd = agefstm + 7;
		if R11MRCT > 1 and agelstm < agefstd then agelstm = agefstd + 4;
		if R11MRCT <= 1 and agelstm < agefstd then do;
			agelstm = .R;
			agelstd = .R;
		end;
	end;
	if 0 < agefstm <= agefstd and agelstm > 0 and agelstd < 0 then do;
		if R11MRCT > 1 and agelstm < agefstd then agelstm = agefstd + 4;
		if R11MRCT <= 1 and agelstm < agefstd then do;
			agelstm = .R;
			agelstd = .R;
		end;
	end;

	if 0 < agefstd < agefstm then agefstd = agefstm + 7;
	if 0 < agelstm < agefstd then agelstm = agefstd + 4;
    if 0 < agelstd < agelstm then agelstd = agelstm + 20;
	/*Set age at last marriage/divorce as missing of only one marriage*/
	if hrs = 0 and R11MRCT = 1 and (agelstd = .L or agelstd > 0) then do;
		agelstm = .R;
		agelstd = .R;
	end;
end;
run;


/*****************************************************************************************************************/
/**********************************************IMPUTATION FOR VARIABLES*******************************************/
/*****************************************************************************************************************/
data HRS_MHAS_PAPER6;
set HRS_MHAS_PAPER5;
/*Create categorical variable about education for later imputation purposes*/
if raedyrs > 12 then raed_c = 4;
else if raedyrs = 12 then raed_c = 3;
else if raedyrs > 7 then raed_c = 2;
else if raedyrs >= 0 then raed_c = 1;

if hrs = 0 then do;
	/*Carry forward values in Height/Smoking status/Working status*/
	if R5HEIGHT <= 0 and R6HEIGHT > 0 then R5HEIGHT = R6HEIGHT;
	if R5HEIGHT <= 0 and R6HEIGHT <= 0 and R11HEIGHT > 0 then R5HEIGHT = R11HEIGHT;

	if R6HEIGHT <= 0 and R5HEIGHT > 0 then R6HEIGHT = R5HEIGHT;
	if R6HEIGHT <= 0 and R5HEIGHT <= 0 and R11HEIGHT > 0 then R6HEIGHT = R11HEIGHT;
	if R6SMOKEN < 0 and R5SMOKEN >= 0 then R6SMOKEN = R5SMOKEN;
	if R6WORK < 0 and R5WORK >= 0 then R6WORK = R5WORK;

	if R11HEIGHT <= 0 and R6HEIGHT > 0 then R11HEIGHT = R6HEIGHT;
	if R11HEIGHT <= 0 and R6HEIGHT <= 0 and R5HEIGHT > 0 then R11HEIGHT = R5HEIGHT;
	if R11SMOKEN < 0 and R6SMOKEN >= 0 then R11SMOKEN = R6SMOKEN;
	if R11SMOKEN < 0 and R6SMOKEN < 0 and R5SMOKEN >= 0 then R11SMOKEN = R5SMOKEN;
	if R11WORK < 0 and R6WORK >= 0 then R11WORK = R6WORK;
	if R11WORK < 0 and R6WORK < 0 and R5WORK >= 0 then R11WORK = R5WORK;

	if R5SMOKEN < 0 and R6SMOKEN  < 0 and R11SMOKEN  < 0 then do;
		R5SMOKEN = 0;
		R6SMOKEN = 0;
		R11SMOKEN = 0;
	end;
	if R5WORK < 0 and R6WORK  < 0 and R11WORK  < 0 and RAJJOBS = 0 then do;
		R5WORK = 0;
		R6WORK = 0;
		R11WORK = 0;
	end;
	/*Create height*/
	if firstage = gage then height = R5HEIGHT;
	if firstage = hage then height = R6HEIGHT;
	if firstage = nage then height = R11HEIGHT;
	/*create age as placeholder in MHAS*/
	if gage = .R then gage_h = 2001 - rabyear;
	else gage_h = gage;
	if hage = .R then hage_h = 2003 - rabyear;
	else hage_h = hage;
	if nage = .R then nage_h = 2012 - rabyear;
	else nage_h = nage;
	oage_h = nage_h + 2;
end;


if hrs = 1 then do;
	/*Create height*/
	if firstage = gage then height = R5HEIGHT;
	if firstage = hage then height = R6HEIGHT;
	if firstage = nage then height = R11HEIGHT;

	if height < 0 and R8height > 0 then height = R8height;
end;
run;

/*Impute years of education by linear regression model: raedyrs ~ ragender + rabyear + rameduc_m rafeduc_m*/
/*proc reg data = HRS_MHAS_PAPER6; model raedyrs = ragender rabyear rameduc_m rafeduc_m; run;

/*****************Get cohort specific sample mean/median for imputation************/
/*******height*******;
proc means data = HRS_MHAS_PAPER6 n nmiss mean median; vars height; class hrs; run;
*******Age at first smoking*******;
proc means data = HRS_MHAS_PAPER6 n nmiss mean median; vars agefstsmk; class hrs; run;

*******Age at first job*******;
*For individuals who have gender and education;
proc sort data = HRS_MHAS_PAPER6; by ragender raed_c;run;
proc means data = HRS_MHAS_PAPER6 n nmiss mean median; vars agefstjob; by ragender raed_c;class hrs; run;
*For individuals with missing education: use gender and birth year for imputation;
proc sort data = HRS_MHAS_PAPER6; by ragender rabyear;run;
proc means data = HRS_MHAS_PAPER6 n nmiss mean median; vars agefstjob; by ragender rabyear;class hrs; run;
proc freq data = HRS_MHAS_PAPER6; tables hhidpn*ragender*rabyear*hrs/list; where agefstjob =. and RAJJOBS = 1 and raed_c =.; run;
************************************************************************************************************************/
data HRS_MHAS_PAPER6;
set HRS_MHAS_PAPER6;
/*imputing years of education*/
if raedyrs < 0 then raedyrs = -209.94588 + (-1.13977)*ragender + 0.10897*rabyear + 1.62489*rameduc_m + 1.47226*rafeduc_m;
if raedyrs < 0 then raedyrs = .; * set raedyrs = -1 as missing;
if raedyrs = . then raedyrs = .M;
/*imputing height*/
if height < 0 and hrs = 0 then height = 1.6;
if height < 0 and hrs = 1 then height = 1.6256;
/*imputing age at first smoking*/
if agefstsmk =. and rasmokev = 0 then agefstsmk =.N; * Never smoked;
else if agefstsmk =. and rasmokev = 1 then agefstsmk = 18;
/*imputing age at first job*/
if hrs=0 and agefstjob =. and RAJJOBS = 1 then do;
	if ragender = 1 and raed_c = 1 then agefstjob = 12;
	if ragender = 1 and raed_c = 2 then agefstjob = 16;
	if ragender = 1 and raed_c = 3 then agefstjob = 16;
	if ragender = 1 and raed_c = 4 then agefstjob = 18;
	if ragender = 2 and raed_c = 1 then agefstjob = 15;
	if ragender = 2 and raed_c = 2 then agefstjob = 18;
	if ragender = 2 and raed_c = 3 then agefstjob = 19;
	if ragender = 2 and raed_c = 4 then agefstjob = 20;
	if hhidpn in (40710,265710) then agefstjob = 13;
	if hhidpn = 1062420 then agefstjob = 13.5;
	if hhidpn = 1055310 then agefstjob = 14;
	if hhidpn in (8110,525710) then agefstjob = 15;
	if hhidpn = 59010 then agefstjob = 16;
	if hhidpn = 584810 then agefstjob = 17;
end;
if hrs=1 and agefstjob =. and RAJJOBS = 1 then do;
	if ragender = 1 and raed_c = 1 then agefstjob = 23; 
	if ragender = 1 and raed_c = 2 then agefstjob = 21;
	if ragender = 1 and raed_c = 3 then agefstjob = 22;
	if ragender = 1 and raed_c = 4 then agefstjob = 20;
	if ragender = 2 and raed_c = 1 then agefstjob = 28;
	if ragender = 2 and raed_c = 2 then agefstjob = 26;
	if ragender = 2 and raed_c = 3 then agefstjob = 26;
	if ragender = 2 and raed_c = 4 then agefstjob = 23;     
	if hhidpn = 525520020 then agefstjob = 33;
	if hhidpn = 914308010 then agefstjob = 38.5;
end;
if agefstjob =. and RAJJOBS = 0 then agefstjob = .N; *Never worked;
if agefstjob =. and RAJJOBS = . then agefstjob = .M; *Real missing;
run;



data HRS_MHAS_PAPER6;
set HRS_MHAS_PAPER6;
format mortality mortality.
	   ragender gender.
	   rameduc_m parent_educ.
	   rafeduc_m parent_educ.
	   migration migration.
	   migration_bi migration_bi.
;
run; 


/*
data created.HRS_MHAS_PAPER1_firstage; set HRS_MHAS_PAPER6; run;

*/
