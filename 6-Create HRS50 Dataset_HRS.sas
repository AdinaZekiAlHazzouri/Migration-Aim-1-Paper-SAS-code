
libname created 'C:\Users\\\\\\\SAS datasets';
libname RAND 'C:\Users\\\\\\\RAND_Files';
libname Tracker 'C:\Users\\\\\\\Tracker_Files';
run;
options nofmterr;



/**********************************************************************************************************************************************/
/**************************************************************CALL IN DATASETS****************************************************************/
/**********************************************************************************************************************************************/
data tracker;
set tracker.trk2014TR_R;
run;

data rand1;
set rand.rndhrs_p;
keep
hhidpn
hhid
pn
rabyear rabmonth
radyear radmonth
;
run;

proc sort data = tracker; by hhid pn; run;
proc sort data = rand1; by hhid pn; run;

data hrs;
merge tracker (in = tracker) rand1 (in = rand1);
by hhid pn;
if tracker;
run;


/**********************************************************************************************************************************************/
/**************************************************************HRS EXCLUSIONS******************************************************************/
/**********************************************************************************************************************************************/

/******************Limiting Dataset to 2000, 2002, 2012, born in foreign country, hispanic mexicans****************/
data hrs;
set hrs; 
	if (GIWTYPE=1 OR HIWTYPE=1 OR NIWTYPE=1) and USBORN=5 and HISPANIC=1; 
run;


data hrs50; 
set hrs;
/************************Limit participants to individuals >= 50 at enrollment*****************************/
if GIWTYPE = 1 and 0 < GAGE < 50 then delete;
else if GIWTYPE ^= 1 and HIWTYPE = 1 and 0 < HAGE < 50 then delete;
else if GIWTYPE ^= 1 and HIWTYPE ^= 1 and NIWTYPE = 1 and 0 < NAGE < 50 then delete;  
/*Give specific code to missing age where R=age is missing because they didnt show up in that wave*/
array age_list[12] AAGE CAGE EAGE FAGE GAGE HAGE JAGE KAGE LAGE MAGE NAGE OAGE;
do i = 1 to 12;
	if age_list[i] = 999 then age_list[i] =.R;
end;
run;

/**********************************************************************************************************************************************/
/*************************************************************CREATE VARIABLES*****************************************************************/
/**********************************************************************************************************************************************/
data hrs50;
set hrs50;
/*First day of interview*/
if GIWTYPE=1 then do;
	firstIWWAVE=2000;
	firstIWYEAR=GIWYEAR;
	firstIWMONTH=GIWMONTH;
	firstAGE=GAGE;
end;
else if HIWTYPE=1 then do;
	firstIWWAVE=2002;
	firstIWYEAR=HIWYEAR;
	firstIWMONTH=HIWMONTH;
	firstAGE=HAGE;
end;
else if NIWTYPE=1 then do;
	firstIWWAVE=2012;
	firstIWYEAR=NIWYEAR;
	firstIWMONTH=NIWMONTH;
	firstAGE=NAGE;
end;
/*Last day of interview*/
if NIWTYPE=1 then do;
	lastIWWAVE=2012;
	lastIWYEAR=NIWYEAR;
	lastIWMONTH=NIWMONTH;
	lastAGE=NAGE;
end;
else if HIWTYPE=1 then do;
	lastIWWAVE=2002;
	lastIWYEAR=HIWYEAR;
	lastIWMONTH=HIWMONTH;
	lastAGE=HAGE;
end;
else if GIWTYPE=1 then do;
	lastIWWAVE=2000;
	lastIWYEAR=GIWYEAR;
	lastIWMONTH=GIWMONTH;
	lastAGE=GAGE;
end;

* set participants died after last interview as alive: last interview happened in 04/2013;
if (radyear ne .X and radyear > 2013) or (radyear ne .X and radyear = 2013 and radmonth > 4)then do;
	radyear =.X;
	radmonth =.X;
end;
/*Death age*/
if radyear ^=.X and radmonth not in (.X,.M) then agedeath = round((mdy(radmonth,1,radyear) - mdy(rabmonth,1,rabyear))/365);
else agedeath = radyear - rabyear;

/*Mortality*/
if radyear ^= .X then mortality=1;
if radyear = .X then mortality=0;
run;


/*data created.hrs50_harmonized; set hrs50; run;
