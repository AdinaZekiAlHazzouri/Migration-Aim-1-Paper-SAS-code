
libname created 'C:\Users\\\\\\\SAS datasets';
run;
options nofmterr;


data paper1_long; set created.paper1_long_firstage; run;

data paper1_long; 
set paper1_long; 


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

age14gn=age14_18*ragender;
age19gn=age19_23*ragender;
age24gn=age24_51*ragender;
age52gn=age_52p*ragender;

ed5gn=ragender*edu5; 
ed6gn=ragender*edu6_11;
ed12gn=ragender*edu12;  

age14ed5=age14_18*edu5;
age19ed5=age19_23*edu5;
age24ed5=age24_51*edu5; 
age52ed5=age_52p*edu5;

age14ed6=age14_18*edu6_11;
age19ed6=age19_23*edu6_11; 
age24ed6=age24_51*edu6_11; 
age52ed6=age_52p*edu6_11;

age14ed12=age14_18*edu12;
age19ed12=age19_23*edu12;
age24ed12=age24_51*edu12; 
age52ed12=age_52p*edu12;

run;


/*Running Backward selection macro to decide on the final variables in the propensity score model*/
options symbolgen mprint;
%inc "C:\Users\\\\\\\SAS programs\SurveySelect_Macro_AM.sas";

options symbolgen mprint;
%inc "C:\Users\az2567\Dropbox\R01 grant- Maria and Adina\Lanyu\SAS programs\SurveySelect_Macro_AM.sas";

/*Forced variables have already been added to the model in the macro and will be included each time it runs*/
/*variables to evaluate for selection*/
%let ind=
ed5gn ed6gn ed12gn  
age14ed5 age19ed5 age24ed5 age52ed5
age14ed6 age19ed6 age24ed6 age52ed6
age14ed12 age19ed12 age24ed12 age52ed12;
/*categorial variables*/
%let class= ;
/*weight to apply*/
%let weight=samp_wt;
/*outcome of model*/
%let dep=migration_bitv;
/*dataset*/
%let input=paper1_long;

/*main effects only*/
%StepSvylog(&dep.,&ind.,,&input.,0.10,0.10,&weight., , ,2);
/*Interactions selected for alpha 0.10: 
age24ed5 .00259 
ed6gn .00543 
age24ed6 .00952
ed5gn .03997 

Interactions selected for alpha 0.05: 
age24ed5 .00259 
ed6gn .00543 
age24ed6 .00952 
ed5gn .03997 
*/

*denominator of the weight - using backward selected model;
proc surveylogistic data = paper1_long ;
	class  ragender rameduc_m(ref = "1") rafeduc_m(ref = "1") mstattv mstattv_miss(ref = "0") smktv smktv_miss(ref = "0") jobtv jobtv_miss(ref = "0") rameduc_miss(ref = "0") rafeduc_miss(ref = "0") height17miss;
	model migration_bitv (event='0') = 
age14_18 age19_23 age24_51 age_52p ragender edu5 edu6_11 edu12 eductv_miss 
age14_18*ragender age19_23*ragender age24_51*ragender age_52p*ragender
rameduc_m rameduc_miss rafeduc_m rafeduc_miss heighttv_c height17miss mstattv mstattv_miss smktv smktv_miss jobtv jobtv_miss
age24_51*edu5 ragender*edu5 ragender*edu6_11 age24_51*edu6_11 
/  link = logit; 
weight samp_wt; 
output out = den_model (keep = hhidpn agenow den_mig) p = den_mig; 
run;
proc sort data = den_model; by hhidpn agenow ; run;


*numerator of the weight;
proc surveylogistic data = paper1_long;
	model migration_bitv (event='0') = / link = logit; 
	output out = num_model (keep = hhidpn agenow num_mig) p = num_mig; 
	weight samp_wt;
run;
proc sort data = num_model; by hhidpn agenow ; run;


proc sort data = paper1_long; by hhidpn agenow ; run;

data st_iptw;
	merge paper1_long den_model num_model;
	by hhidpn agenow; run;

data st_iptwa; 
set st_iptw;
if den_mig ne .;
run;

proc sort data=st_iptwa; by hhidpn agenow; run;

data st_iptwa2full;
set st_iptwa;
by hhidpn;
	if first.hhidpn then do;
		StillMex=1;
		CumPr_Mex=1;
		NumCumPr_Mex=1;
                NumWt=1;
		DenWt=1;
		already_moved=0; /*this var has been created but is not being used*/
	end;
		
	retain StillMex CumPr_Mex NumCumPr_Mex NumWt DenWt already_moved; /*tells sas to not overwrite variables*/
	
	if StillMex=1 and migration_bitv=0 then do;
		stillMex=1;
		CumPr_Mex=CumPr_Mex*den_mig; /*probstay > output of denom conditional logit model*/
		NumCumPr_Mex=NumCumPr_Mex*num_mig;
		NumWt=NumCumPr_Mex;
		DenWt=CumPr_Mex;
		end;

	if stillmex=1 and migration_bitv=1 then do;
		stillmex=0;
		DenWt=CumPr_Mex*(1-den_mig); *this is now the cumulative probability of your transition path: that you migrated when you did;
		NumWt=NumCumPr_Mex*(1-num_mig);
                CumPr_Mex=CumPr_Mex*den_mig; /*probstay > output of denom conditional logit model*/
		NumCumPr_Mex=NumCumPr_Mex*num_mig;
		end;

	if stillmex=0 then CumPr_Mex=CumPr_Mex; /*this will not actually be used ...but helps with thinking through the process/calculation; this needs to be included in datasets that continue to have participants 
												after they have migrated initially*/

	weight=(1/DenWt);
	
	s_weight=(NumWt/DenWt);
		
	run;
	/*think more about the fact that this may be calculating 1/cumulative prob. of migration at the age you did*/


data weight_final;
set st_iptwa2full;
by hhidpn;
if last.hhidpn then output;
run; 


data weight_final;
set weight_final;
weight_trm = weight;
if weight > 1.3049164 then weight_trm=1.3049164;
else if weight < 1.0318642 then weight_trm=1.0318642;

s_weight_trm = s_weight;
if s_weight > 2.8143710 then s_weight_trm=2.8143710;
else if s_weight < 0.1923720 then s_weight_trm=0.1923720;
run;

data created.weight_full122019; 
set st_iptwa2full;
keep hhidpn weight s_weight; 
run; 
data created.weight_final122019; 
set weight_final;
keep hhidpn weight weight_trm s_weight_trm s_weight; 
run; 

/*merge the weights dataset with the wide mhas_hrs dataset*/
proc sort data=weight_final; by hhidpn; run;

data hrs_mhas; set created.hrs_mhas_paper1_firstage;run; 
	proc sort data=hrs_mhas; by hhidpn; run;

data hrs_mhas_paper1_wts;
merge weight_final (in=A) hrs_mhas (in=B); 
by hhidpn;
if B;
run;

data created.hrs_mhas_paper1_wts122019;
set hrs_mhas_paper1_wts;
run; 			
