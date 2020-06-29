
libname created 'C:\Users\\\\\\\SAS datasets';
run;
options nofmterr;


/**********************************************************************************************************************************************

				TABLE 1 


**********************************************************************************************************************************************/

data paper1_long; set created.paper1_long_firstage; 
 
if ragender = 1 then male = 1;
else if ragender = 2 then male = 0;

*create a continuous linear term for education;
if eductv=. then edu5=.;
else if eductv >=5 then edu5=5;
else edu5=eductv;

if eductv=. then edu6_11=.;
else if eductv =< 5 then edu6_11=0;
else if eductv >=11 then edu6_11=6;
else edu6_11=eductv-5;

if eductv=. then edu12=.;
else if eductv =< 11 then edu12=0;
else edu12 = eductv - 11;

/*creating new age terms*/
if agenow ne . then do;
	age0_13=(agenow<=13);
	if 13<agenow<=18 then age14_18=agenow-13;
	else if agenow>18 then age14_18=5;
	else if agenow<=13 then age14_18=0;
	age19_23=(18<agenow);
	if 23<agenow<=51 then age24_51=agenow-23;
	else if agenow>51 then age24_51=28;
	else if agenow<=23 then age24_51=0;
	age_52p=(agenow>=52);
	end;

if firstIWWAVE=2000 then samp_wt=GWGTR;
else if firstIWWAVE=2001 then samp_wt=RWTRESP01;
else if firstIWWAVE=2002 then samp_wt=HWGTR;
else if firstIWWAVE=2003 then samp_wt=RWTRESP03;
else if firstIWWAVE=2012 and HRS=1 then samp_wt=NWGTR;
else if firstIWWAVE=2012 and HRS=0 then samp_wt=RWTRESP12;
run;



proc surveylogistic data = paper1_long ;
	class  ragender rameduc_m(ref = "1") rafeduc_m(ref = "1") mstattv mstattv_miss(ref = "0") smktv smktv_miss(ref = "0") jobtv jobtv_miss(ref = "0") rameduc_miss(ref = "0") rafeduc_miss(ref = "0") height17miss;
	model migration_bitv (event='1') = 
age14_18 age19_23 age24_51 age_52p ragender edu5 edu6_11 edu12 eductv_miss 
age14_18*ragender age19_23*ragender age24_51*ragender age_52p*ragender
rameduc_m rameduc_miss rafeduc_m rafeduc_miss heighttv_c height17miss mstattv mstattv_miss smktv smktv_miss jobtv jobtv_miss
age24_51*edu5 ragender*edu5 ragender*edu6_11 age24_51*edu6_11 
/ link = logit CLPARM; 
weight samp_wt; 
output out = den_model (keep = hhidpn agenow den_mig) p = den_mig; 
run;


/**********************************************************************************************************************************************/
/***************************************************CALL IN DATASET AND DATA MANAGEMENT FOR TABLES 2 AND 3*****************************************************************/
/**********************************************************************************************************************************************/

data temp1; set created.hrs_mhas_paper1_wts122019;
heightcm = height*100;
/*1-Re-categorize gender*/
if ragender = 1 then male = 1;
else if ragender = 2 then male = 0;

/*2-Mortality*/
/*sensitivity analysis*/
	*if mortality = 2 then mortality_bi = .;
	*else mortality_bi = mortality;

	if mortality = 2 then mortality_bi = 0;
	else mortality_bi = mortality;

/*3-Days to follow up*/
	if hrs = 0 then do;
		if mortality_bi = 1 then dayfl = MDY(radmonth,1,radyear)-MDY(firstIWMONTH,1,firstIWYEAR);
		if mortality_bi = 0 then dayfl = MDY(2,28,2013)-MDY(firstIWMONTH,1,firstIWYEAR);
	end;
	if hrs = 1 then do;
		if mortality_bi = 1 then dayfl = MDY(radmonth,1,radyear)-MDY(firstIWMONTH,1,firstIWYEAR);
		if mortality_bi = 0 then dayfl = MDY(4,30,2013)-MDY(firstIWMONTH,1,firstIWYEAR);
	end;
	if dayfl < 0 then dayfl = .;

/*Create missing indicator to not drop vars in the models*/
if rameduc_m in (.D, .M, .P, .R) then do;
	rameduc_m=0; 
	rameduc_miss=1;
end;
else rameduc_miss=0;

if rafeduc_m in (.D, .M, .P, .R) then do;
	rafeduc_m=0;
	rafeduc_miss=1;
end;
else rafeduc_miss=0;

/*own education*/
if raedyrs=.M then raedyrs_miss=1;
else raedyrs_miss=0;

/*marital status*/
if agefstm in (., .N) then do;
   agefstm_miss=1;
end;
else agefstm_miss=0;
/*smoking status*/
if agefstsmk = .N then do;
	agefstsmk_miss=1;
end;
else agefstsmk_miss=0;
/*working status*/
if agefstjob in (.N, .M) then do;
	agefstjob_miss=1;
end;
else agefstjob_miss=0;
  
	mig_lt18=0;
	mig18_34=0;
	mig_gt34=0;
if agefstmig ne .N and agefstmig<18 then mig_lt18=1;
if agefstmig ne .N and 18<=agefstmig<=34 then mig18_34=1;
if agefstmig ne .N and agefstmig>34 then mig_gt34=1;

run;


data temp1m; set temp1;
where male=1; run;
data temp1f; set temp1;
where male=0; run;

/*
proc export data=temp1 outfile= "C:\Users\\\\\\\temp1.dta";
run;
*/



/**********************************************************************************************************************************************

				TABLE 2 COMPARING MIGRANTS (RETURN MIGRANTS AND HRS MIGRANTS) TO NEVER MIGRANTS


**********************************************************************************************************************************************/

/*Male*/
proc freq data = temp1m;
tables migration_bi rameduc_m*migration_bi rafeduc_m*migration_bi mortality_bi*migration_bi;
run;
proc means data = temp1m n nmiss mean std min max;
vars firstage raedyrs heightcm agefstm agefstsmk agefstjob;
class migration_bi;
run;

/*Female*/
proc freq data = temp1f;
tables migration_bi rameduc_m*migration_bi rafeduc_m*migration_bi mortality_bi*migration_bi;
run;
proc means data = temp1f n nmiss mean std min max;
vars firstage raedyrs heightcm agefstm agefstsmk agefstjob;
class migration_bi;
run;



/**********************************************************************************************************************************************

				TABLE 3 


**********************************************************************************************************************************************/

/*Test the propotional hazard assumption*/
proc lifetest data = temp1 plot=(s, lls);
time dayfl*mortality_bi(0);
strata migration_bi;
run;

*OVERALL MODELS (non startified);

/*model 1 - adjusted for age gender and byear*/
proc phreg data=temp1 covs(aggregate);
class hhid; 
model dayfl*mortality_bi(0)= migration_bi male firstage rabyear/risklimits;
id hhid;
run; 
/*model 2 - additionally adjusted for parental education*/
proc phreg data=temp1 covs(aggregate);
class hhid rameduc_m rafeduc_m;
model dayfl*mortality_bi(0)= migration_bi male firstage rabyear rameduc_m rameduc_miss rafeduc_m rafeduc_miss/risklimits; 
id hhid;
run;
/*model 3 - additionally adjusted for baseline covariates*/
proc phreg data=temp1 covs(aggregate);
class hhid rameduc_m rafeduc_m;
model dayfl*mortality_bi(0)= migration_bi male firstage rabyear rameduc_m rameduc_miss rafeduc_m rafeduc_miss 
raedyrs raedyrs_miss heightcm agefstm agefstm_miss agefstsmk agefstsmk_miss agefstjob agefstjob_miss/risklimits; 
id hhid;
run;
/*model 4 - model 2 + IPTW*/
proc phreg data=temp1 covs(aggregate);
class hhid rameduc_m rafeduc_m;
model dayfl*mortality_bi(0)= migration_bi male firstage rabyear rameduc_m rameduc_miss rafeduc_m rafeduc_miss/risklimits; 
weight s_weight_trm;
id hhid;
run;


*AMONG MALES;
/*model 1 - adjusted for age gender and byear*/
proc phreg data=temp1m covs(aggregate);
class hhid; 
model dayfl*mortality_bi(0)= migration_bi firstage rabyear/risklimits; 
id hhid;
run;
/*model 2 - additionally adjusted for parental education*/
proc phreg data=temp1m covs(aggregate);
class hhid rameduc_m rafeduc_m; 
model dayfl*mortality_bi(0)= migration_bi firstage rabyear rameduc_m rameduc_miss rafeduc_m rafeduc_miss/risklimits; 
id hhid;
run;
/*model 3 - additionally adjusted for baseline covariates*/
proc phreg data=temp1m covs(aggregate);
class hhid rameduc_m rafeduc_m;
model dayfl*mortality_bi(0)= migration_bi firstage rabyear rameduc_m rameduc_miss rafeduc_m rafeduc_miss 
raedyrs raedyrs_miss heightcm agefstm agefstm_miss agefstsmk agefstsmk_miss agefstjob agefstjob_miss/risklimits; 
id hhid;
run;
/*model 4 - model 2 + IPTW*/
proc phreg data=temp1m covs(aggregate);
class hhid rameduc_m rafeduc_m; 
model dayfl*mortality_bi(0)= migration_bi firstage rabyear rameduc_m rameduc_miss rafeduc_m rafeduc_miss/risklimits; 
weight s_weight_trm;
id hhid;
run;


*AMONG FEMALES;
/*model 1 - adjusted for age gender and byear*/
proc phreg data=temp1f covs(aggregate);
class hhid; 
model dayfl*mortality_bi(0)= migration_bi firstage rabyear/risklimits; 
id hhid;
run;
/*model 2 - additionally adjusted for parental education*/
proc phreg data=temp1f covs(aggregate);
class hhid rameduc_m rafeduc_m; 
model dayfl*mortality_bi(0)= migration_bi firstage rabyear rameduc_m rameduc_miss rafeduc_m rafeduc_miss/risklimits; 
id hhid;
run;
/*model 3 - additionally adjusted for baseline covariates*/
proc phreg data=temp1f covs(aggregate);
class hhid rameduc_m rafeduc_m;
model dayfl*mortality_bi(0)= migration_bi  firstage rabyear rameduc_m rameduc_miss rafeduc_m rafeduc_miss 
raedyrs raedyrs_miss heightcm agefstm agefstm_miss agefstsmk agefstsmk_miss agefstjob agefstjob_miss/risklimits; 
id hhid;
run;
/*model 4 - model 2 + IPTW*/
proc phreg data=temp1f covs(aggregate);
class hhid rameduc_m rafeduc_m; 
model dayfl*mortality_bi(0)= migration_bi firstage rabyear rameduc_m rameduc_miss rafeduc_m rafeduc_miss/risklimits; 
weight s_weight_trm;
id hhid;
run;



/*****************************************************************************************************************/
/**************************************************************TPROPENSITY PLOT*********************************/
/*****************************************************************************************************************/

data plot; set created.hrs_mhas_paper1_wts122019; run;

data plot; set plot;
CumPr_tous = 1 - CumPr_Mex; run;

/* plotting the estimated propensity score  */
data tmp1 tmp2 ;
	set plot (keep = migration_bi CumPr_tous) ;
	CumPr_tous = round(CumPr_tous,0.05);
	if migration_bi = 0 then output tmp1 ;
	if migration_bi = 1 then output tmp2 ;
run;

proc freq data = tmp1 noprint  ;
	table CumPr_tous / out = migration_bi0 (keep = CumPr_tous count ) ;
run;

proc freq data = tmp2 noprint ;
	table CumPr_tous / out = migration_bi1 (keep = CumPr_tous count );
run;

data tmp3 ; 
	merge migration_bi0 (in = a rename = (count = count0) ) migration_bi1  (in = b rename = (count = count1));
	by CumPr_tous ;
	label CumPr_tous="Probability of migrating to the U.S."
    	  count0="No. Subjects"
    	  count1="No. Subjects" 
      	;
	if count0 = . then count0 = 0 ;
	if count1 = . then count1 = 0 ;
	count1 = -1 * count1 ;
	count2 = -1 *count1 ;
run;
 
proc format;
   picture positive 
     low-<0='000,000'
     0<-high='000,000';
run; 
ods graphics / reset border=off width=600px height=400px imagefmt=pdf  ;
title ;	footnote ;

data sganno;
	function ="text" ; label ="Non-migrant" ; textcolor ="black" ; position = "left" ; x1 = 95 ; y1 = 95 ; size=6 ; 
	x1space="wallpercent" ; y1space = "wallpercent" ; output ;
	function ="text" ; label ="Migrant" ; textcolor ="black" ;  position = "left" ; x1 = 95 ; y1 = 3  ; size=6 ; 
	x1space="wallpercent" ; y1space = "wallpercent" ; output ;
run ;
 
proc sgplot data=tmp3 sganno=sganno noautolegend ;
    format count0 count1  positive.  ;
    vbar CumPr_tous / response=count0   legendlabel=" "   datalabel datalabelattrs=(size=8)   name='a0' nofill ;
    vbar CumPr_tous / response=count1   legendlabel=" "   datalabel datalabelattrs=(size=8)   name='a1'   fill fillattrs=(color=gray) ;
    xaxis labelattrs=(size=10) valueattrs=(size = 10) min = 0 max = 1.0;
    yaxis labelattrs=(size=10) valueattrs=(size = 10) values=(-1000 to 4500 by 500);
run;
