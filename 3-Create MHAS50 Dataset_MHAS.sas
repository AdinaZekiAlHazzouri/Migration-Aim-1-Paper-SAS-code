
libname library 'C:\Users\\\\\\\harmonized dataset';
options fmtsearch = (library);
libname Raw 'C:\Users\\\\\\\raw datasets';
libname Harmo 'C:\Users\\\\\\\harmonized dataset';
libname Next 'C:\Users\\\\\\\next-of-kin raw datasets';
libname created 'C:\Users\\\\\\\SAS datasets';
run;
options nofmterr;




/**********************************************************************************************************************************************/
/**************************************************************CALL IN DATASETS****************************************************************/
/**********************************************************************************************************************************************/
data mhas; set created.mhas;
run;

data mig; set created.mhas_raw;
keep
unhhidnp
migration
;
run;

proc sort data = mhas; by unhhidnp; run;
proc sort data = mig; by unhhidnp; run;

data mhas50;
merge mhas(in=mhas) mig(in=mig);
by unhhidnp;
if mhas;
run;

/**********************************************************************************************************************************************/
/**************************************************************CREATE VARIABLES****************************************************************/
/**********************************************************************************************************************************************/

/************Limit participants to individuals with migration categories*************/
data mhas50;
set mhas50;
where migration ne . ;                     * delete 120 individuals;
/*interview date*/
inwdate01 = mdy (riwm01,1,riwy01);
inwdate03 = mdy (riwm03,1,riwy03);
inwdate12 = mdy (riwm12,1,riwy12);
/*birth date*/
birthdate = mdy (rabmonth,1,rabyear);
/*interview age*/
if rinw01 = 1 and ragey01 < 0 then do;
	ragey01 = round((inwdate01 - birthdate)/365);
	if ragey01 < 0 and riwy01 > 0 then ragey01 = riwy01 - rabyear;
	else if ragey01 < 0 and riwy01 < 0 then ragey01 = 2001 - rabyear;
end;

if rinw03 = 1 and ragey03 < 0 then do;
	ragey03 = round((inwdate03 - birthdate)/365);
	if ragey03 < 0 and riwy03 > 0 then ragey03 = riwy03 - rabyear;
	else if ragey03 < 0 and riwy03 < 0 then ragey03 = 2003 - rabyear;
end;

if rinw12 = 1 and ragey12 < 0 then do;
	ragey12 = round((inwdate12 - birthdate)/365);
	if ragey12 < 0 and riwy12 > 0 then ragey12 = riwy12 - rabyear;
	else if ragey12 < 0 and riwy12 < 0 then ragey12 = 2012 - rabyear;
end;
run;

/********************Limit participants to individuals >= 50 at enrollment*************************/
data mhas50; 
set mhas50;
if rinw01 = 1 and 0 < ragey01 < 50 then delete;
else if rinw01 ^= 1 and rinw03 = 1 and 0 < ragey03 < 50 then delete;
else if rinw01 ^= 1 and rinw03 ^= 1 and rinw12 = 1 and 0 < ragey12 < 50 then delete;
run;                                        

/*Fix age errors*/
*age< 50;
data mhas50;
set mhas50;
if 0 < ragey12 < 50 and ragey03 > 0 then ragey12 = ragey03 + 9;
if 0 < ragey12 < 50 and ragey03 < 0 then ragey12 = ragey01 + 11;
run;

*missing age;
data mhas50;
set mhas50;
if rinw12 = 1 and ragey12 < 0 then ragey12 = ragey03 + 9;
run;

*Give specific code to missing age: 
.R= missing because they didnt show up in that particular wave 
.M= showed up but age is missing and could not retrieve from other visits;
data mhas50;
set mhas50;
/*2001*/
if rinw01 ^= 1 then ragey01 = .R;
/*2003*/
if rinw03 ^= 1 then ragey03 = .R; 
else if rinw03 = 1 and ragey03 < 0 then ragey03 = .M; 
/*2012*/
if rinw12 ^= 1 then ragey12 = .R;
else if rinw12 = 1 and ragey12 < 0 then ragey12 = .M;
run;

data mhas50;
set mhas50;
/*First day of interview*/
if rinw01 = 1 then do;
	firstiwwave = 2001;
	firstiwyear=riwy01;
	firstiwmonth=riwm01;
	firstage = ragey01;
end;
else if rinw03 = 1 then do;
	firstiwwave = 2003;
	firstiwyear=riwy03;
	firstiwmonth=riwm03;
	firstage = ragey03;
end;
else if rinw12 = 1 then do;
	firstiwwave = 2012;
	firstiwyear=riwy12;
	firstiwmonth=riwm12;
	firstage = ragey12;
end;
/*Last day of interview*/
if rinw12 = 1 then do;
	lastiwwave = 2012;
	lastiwyear=riwy12;
	lastiwmonth=riwm12;
	lastage = ragey12;
end;
else if rinw03 = 1 then do;
	lastiwwave = 2003;
	lastiwyear=riwy03;
	lastiwmonth=riwm03;
	lastage = ragey03;
end;
else if rinw01 = 1 then do;
	lastiwwave = 2001;
	lastiwyear=riwy01;
	lastiwmonth=riwm01;
	lastage = ragey01;
end;

/*Mortality 2001*/
if riwstat01 in (1,4) then mortality01 = 0;
else if riwstat01 in  (5,6) then mortality01 = 1;
else if riwstat01 = 0 then mortality01 = 2;
else if riwstat01 = 9 then mortality01 = 3;
/*Mortality 2003*/
if riwstat03 in (1,4) then mortality03 = 0;
else if riwstat03 in  (5,6) then mortality03 = 1;
else if riwstat03 = 0 then mortality03 = 2;
else if riwstat03 = 9 then mortality03 = 3;
/*Mortality 2012*/
if riwstat12 in (1,4) then mortality12 = 0;
else if riwstat12 in  (5,6) then mortality12 = 1;
else if riwstat12 = 0 then mortality12 = 2;
else if riwstat12 = 9 then mortality12 = 3;

/*Mortality*/ *last interview was in 02/2013, and all the death date are before this date;
if mortality01 = 1 or mortality03 = 1 or mortality12 = 1 then mortality = 1;
else if mortality01 in (0,2) and mortality03 in (0,2) and mortality12 in (0,2) then mortality = 0;
else if mortality01 =. and mortality03 =. and mortality12 =. then mortality =.;
else mortality = 2;

*Give specific code to missing death date based on mortality status: 
.X= alive
.M= died with missing death date;
if mortality = 0 then do;
	radyear = .X;
	radmonth = .X;
end;
if mortality = 1 then do;
	if radyear < 0 then radyear = .M;
	if radmonth < 0 then radmonth = .M; 
end;
if mortality = 2 then do; 
	radyear = .X;
	radmonth = .X; 
end;

/*Death age*/
if radyear in (.X,.M) then agedeath = radyear;
else if radyear not in (.X,.M) and radmonth not in (.X,.M) then agedeath = round((mdy(radmonth,1,radyear) - mdy(rabmonth,1,rabyear))/365);
else agedeath = radyear - rabyear;

if agedeath =. then agedeath =.M;
run;

/*data created.mhas50_harmonized; set mhas50; run; 


/**********************************************************************************************************************************************/
/**************************************************************CREATE CODEBOOK*****************************************************************/
/**********************************************************************************************************************************************/
data mhas50_harmonized; set created.mhas50_harmonized;
run;

proc means data = mhas50_harmonized n nmiss mean std median min max maxdec = 0;
vars
ragey01
ragey03
ragey12
agefstinw
agelstinw
agedeath
timetodeath
;
run;

proc freq data = mhas50_harmonized;
tables 
mortality01
mortality03
mortality12
mortality
/missing;
run;
