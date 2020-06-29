
/******************************************** * Programmer: Fang Wang wang-fang@norc.org * * Sep 2011 * *********************************************/ 
%macro ScanVar (c,class);
%if &class = %then %do;
%put No class covariates given. ;
%end;
%global nclass; %global classnames;
%global n; %global covnames;
%let classcnt=1; %let classnames=;
%do %while (%scan(&class,&classcnt,%STR( )) ne );
%let class&classcnt="%scan(&class,&classcnt,%STR( ))"; %if &classcnt=1 %then %let classnames=%upcase(&&class&classcnt); %else %let classnames=&classnames %upcase(&&class&classcnt); %let classcnt=%eval(&classcnt+1);
%end;
%GLOBAL nclass; %let nclass=%eval(&classcnt-1);
%put Number of class covariates = &nclass ;
data classv; length covname $40; keep covname; array word $40 w1-w&nclass (&classnames); do i=1 to &nclass ; covname = compress(word(i)); output ; end; run;
%if &c = %then %do;
%put ERROR: No covariates given. Expecting at least one covariate;
%end;
%let covcnt=1; %let covnames=;
%do %while (%scan(&c,&covcnt,%STR( )) ne );
%let c&covcnt="%scan(&c,&covcnt,%STR( ))"; %if &covcnt=1 %then %let covnames=%upcase(&&c&covcnt); %else %let covnames=&covnames %upcase(&&c&covcnt); %let covcnt=%eval(&covcnt+1);
%end;
%let n=%eval(&covcnt-1);
%put Number of covariates = &n ;
data indv; length covname $ 40; keep covname; array word $40 w1-w&n (&covnames); do i=1 to &n ; covname = compress(word(i)); output ; end; run;
proc sql; create table covariates as select indv.covname as covname, classv.covname as classname from indv left join classv on indv.covname=classv.covname; quit;
%mend ScanVar;

/********* surveyreg **************/
%macro svyreg(dep,ind,class,input,out,weight,strata,cluster);
PROC surveyreg DATA=&input; ods output Effects=&out(rename=EFFECT=parm); STRATA &STRATA; CLUSTER &CLUSTER; WEIGHT &WEIGHT; CLASS &CLASS; MODEL &DEP = &IND; RUN;
data &out; set &out; length parm $ 40; if _N_ in (1 2) then delete; keep parm probf fvalue; run;
%mend svyreg;

%macro Forwardreg (SLENTRY);
%global new; %global new_class; %global old; %global old_class; %global c; %global class; %global nold; %global ntotal;
data covariates ; set covariates nobs=numobs ; order = _N_; call symput ('startn', left(put(numobs,8.))) ; run ;
%if &startn < &n %then %do; %put ERROR: NO VARIABLES ; %end ;
%if &startn >= &n %then %do;
data covariates ; set covariates ; temp = compress('c'||order) ; temp_class = compress('class'||order) ; call symput (temp , covname) ; call symput (temp_class , classname) ; drop temp temp_class; run ;
%put MODEL VARIABLES: ;
%do i = 1 %to &startn ;
%put %upcase(&&c&i);
%end;
%do i=1 %to %eval(&&startn) ; title "Forward round=&round"; %svyreg(dep=&DEP,ind=&old &&c&i,CLASS=&old_class &&class&i,input=&regdata,out=uf&i,weight=&weight,strata=&strata,cluster=&cluster); data uf&i; set uf&i end=last; if last then output; run; %end;
%end ;
data candidates_temp; length parm $40; set uf1; run;
%do i=2 %to %eval(&&startn) ; proc datasets nolist force; append base=candidates_temp data=uf&i; run; %end;
%do i=1 %to %eval(&&startn); proc datasets nolist; delete uf&i; run; %end;
proc sql; create table candidates as select candidates_temp.*, classv.covname as class from candidates_temp left join classv on classv.covname=upcase(candidates_temp.parm) order by fvalue desc; quit;
data candidates; set candidates; format probf 30.29; tn=_n_; run;
%let new=; %let new_class=; %let class=; %let c=;
proc sql /*noprint*/; select Probf into :pmin from candidates having tn=1;
select distinct parm into :new separated by ' ' from candidates having probf<=&SLENTRY and tn=1;
select distinct class into :new_class separated by ' ' from candidates having parm="&new.";
select distinct parm into :c separated by ' ' from candidates having parm^="&new.";
select distinct class into :class separated by ' ' from candidates having parm^="&new_class." and class^='';
quit;
%let old=&old &new; %let old_class=&old_class &new_class;
title "Summary model forward round&round"; %svyreg(dep=&DEP,ind=&old,CLASS=&old_class,input=&regdata,out=step_&METHOD,weight=&weight,strata=&strata,cluster=&cluster);
proc sort data=step_&METHOD; by probf; run;
%mend Forwardreg;

%macro Backwardreg(SLSTAY); %local i;
%let DEP=%upcase(&DEP); %let old=%upcase(&old); %let dataset=%upcase(&dataset);
data step_&METHOD; length parm $ 40; if parm='' then delete; run;
title "Backward"; %let i=1; %do %until (&pmax<=&slstay or &varlist=''); %if &i = 1 %then %svyreg(DEP=&DEP ,IND=&old, CLASS=&old_class, input=&regdata,out=pval,weight=&weight,strata=&strata,cluster=&cluster); %*initial model; %else %do; %svyreg(DEP=&DEP ,IND=&varlist,CLASS=&old_class,input=&regdata,out=pval,weight=&weight,strata=&strata,cluster=&cluster); %*reduced model; %end;
proc sort data=step_&METHOD; by parm;
proc sort data=pval; by parm; data step_&METHOD; format p&i 30.29; merge step_&METHOD pval; by parm; p&i=probf; drop probf; run;
%let varlist=''; proc sql noprint; select round(max(probf),0.001) into :pmax from pval;
select distinct parm into :varlist separated by ' ' from pval having probf^=max(probf); quit; %let j=%eval(&i); %let i=%eval(&i+1);
%end;
proc sort data=step_&METHOD; by p&j; run;
%let removed=;
proc sql /*noprint*/;
select distinct parm into :removed separated by ' ' from step_&METHOD having p&j=. ;
select distinct parm into :old separated by ' ' from step_&METHOD having p&j^=.;
quit;
data step_&METHOD; retain parm p&j; set step_&METHOD; rename p&j=ProbF; keep parm p&j; if p&j^=.; run;
%let c=&c &removed;
%mend Backwardreg;

%macro StepSvyreg( /******************************************** * Programmer: Fang Wang wang-fang@norc.org * * Sep 2011 * *********************************************/ DEP /*dependent variable*/ ,INTVAR /*all the candidate independent variavles */
,INTCLASS /*candidate categorical independent varaibels*/ ,DATASET/*input dataset*/ ,SLENTRY/*entry p value*/ ,SLSTAY/*stay p value*/ ,WEIGHT/*weight for wegihted regression models*/ ,STRATA/*complex survye strata variable*/ ,CLUSTER/*complex survey cluster variable*/ ,METHOD/*selection method: forward, backward or stepwise*/ );
%let round=1; %let old=; %let old_class=; %let pmin=0;
%let method=%upcase(&method);
%if &method=1 %then %do; %do %until (&new= or &pmin>&SLENTRY or (&n=1)); %if &round = 1 %then %do; %ScanVar (&intvar,&intclass); %let regdata=&dataset; %Forwardreg(&SLENTRY); %let round=%eval(&round+1); %end; %else %do; %ScanVar (&c,&class); %Forwardreg(&SLENTRY); %let round=%eval(&round+1); %end; %end; %end;
%if &method=2 %then %do; %ScanVar (&intvar,&intclass); %let old=&intvar; %let old_class=&intclass; %let regdata=&dataset; %Backwardreg(&SLSTAY); %end;
%if &method=3 %then %do; %do %until (&new= or &pmin>&SLENTRY or (&n=1)); %if &round = 1 %then %do; %ScanVar (&intvar,&intclass); %let regdata=&dataset; %Forwardreg(&SLENTRY); %Backwardreg(&SLSTAY); %let round=%eval(&round+1); %end; %else %do; %ScanVar (&c,&class); %Forwardreg(&SLENTRY); %Backwardreg(&SLSTAY); %let round=%eval(&round+1); %end;
%end; %end;
proc print data=step_&METHOD; format ProbF 7.6; title "&DEP"; run;
%mend StepSvyreg;

/************** surveylogistic ******************/
%macro Svylog(dep,ind,class,input,out,weight,strata,cluster);
%if &weight^= %then %do; PROC surveylogistic DATA=&input; ods output Type3=type3(rename=EFFECT=parm) ParameterEstimates=parameter(rename=Variable=parm); STRATA &STRATA; CLUSTER &CLUSTER; WEIGHT &WEIGHT; CLASS &CLASS ragender rameduc_m rafeduc_m mstattv mstattv_miss smktv smktv_miss jobtv jobtv_miss rameduc_miss rafeduc_miss height17miss; MODEL &DEP(EVENT='0')= &IND age14_18 age19_23 age24_51 age_52p ragender edu5 edu6_11 edu12 eductv_miss 
age14gn age19gn age24gn age52gn
rameduc_m rameduc_miss rafeduc_m rafeduc_miss heighttv_c height17miss mstattv mstattv_miss smktv smktv_miss jobtv jobtv_miss; RUN; %end;
%else %do; PROC surveylogistic DATA=&input; ods output Type3=type3(rename=EFFECT=parm) ParameterEstimates=parameter(rename=Variable=parm); STRATA &STRATA; CLUSTER &CLUSTER; CLASS &CLASS ragender rameduc_m rafeduc_m mstattv mstattv_miss smktv smktv_miss jobtv jobtv_miss rameduc_miss rafeduc_miss height17miss; MODEL &DEP(EVENT='0')= &IND age14_18 age19_23 age24_51 age_52p ragender edu5 edu6_11 edu12 eductv_miss 
age14gn age19gn age24gn age52gn
rameduc_m rameduc_miss rafeduc_m rafeduc_miss heighttv_c height17miss mstattv mstattv_miss smktv smktv_miss jobtv jobtv_miss; RUN; %end;
%if &class= %then %do; data &out; length parm $20.; set parameter; if parm='' or parm='Intercept' or parm in ('age14_18', 'age19_23', 'age24_51', 'age_52p', 'ragender', 'RAGENDER','edu5', 'edu6_11', 'edu12', 'eductv_miss', 
'age14gn', 'age19gn', 'age24gn', 'age52gn',
'rameduc_m', 'rameduc_miss', 'rafeduc_m', 'rafeduc_miss', 'heighttv_c', 'height17miss', 'mstattv', 'mstattv_miss', 'smktv', 'smktv_miss', 'jobtv', 'jobtv_miss') then delete; keep parm waldchisq probchisq; run; %end;
%else %do; data &out; length parm $20.; set type3; if parm='' or parm='Intercept' parm in ('age14_18', 'age19_23', 'age24_51', 'age_52p', 'ragender', 'RAGENDER', 'edu5', 'edu6_11', 'edu12', 'eductv_miss', 
'age14gn', 'age19gn', 'age24gn', 'age52gn',
'rameduc_m', 'rameduc_miss', 'rafeduc_m', 'rafeduc_miss', 'heighttv_c', 'height17miss', 'mstattv', 'mstattv_miss', 'smktv', 'smktv_miss', 'jobtv', 'jobtv_miss') then delete; keep parm waldchisq probchisq; run; %end;
%mend Svylog;

%macro Forwardlog (SLENTRY);
%global new; %global new_class; %global c; %global class; %global nold; %global ntotal;
data covariates ; set covariates nobs=numobs ; order = _N_; call symput ('startn', left(put(numobs,8.))) ; run ;
%if &startn < &n %then %do; %put ERROR: NO VARIABLES ; %end ;
%if &startn >= &n %then %do;
data covariates ; set covariates ; temp = compress('c'||order) ; temp_class = compress('class'||order) ; call symput (temp , covname) ; call symput (temp_class , classname) ; drop temp temp_class; run ;
%put MODEL VARIABLES: ;
%do i = 1 %to &startn ;
%put %upcase(&&c&i); %put %upcase(&&class&i);
%end;
%do i=1 %to %eval(&&startn) ; title "Forward round=&round"; %Svylog(dep=&DEP,ind=&old &&c&i,CLASS=&old_class &&class&i,input=&regdata,out=uf&i,weight=&weight,strata=&strata,cluster=&cluster); data uf&i; set uf&i end=last; if last then output; run; %end;
%end ; /* END LOOP */
data candidates_temp;set uf1; run;
%do i=2 %to %eval(&&startn) ; proc datasets nolist force;
append base=candidates_temp data=uf&i; run; %end;
%do i=1 %to %eval(&&startn); proc datasets nolist; delete uf&i; run; %end;
proc sql; create table candidates as select candidates_temp.*, classv.covname as class from candidates_temp left join classv on classv.covname=upcase(candidates_temp.parm) order by ProbChiSq; quit;
data candidates; set candidates; format ProbChiSq 30.29; tn=_n_; run;
%let new=; %let new_class=; %let class=; %let c=;
proc sql /*noprint*/; select ProbChiSq into :pmin from candidates having tn=1;
select distinct parm into :new from candidates having tn=1 and ProbChiSq<=&SLENTRY;
select distinct class into :new_class from candidates having parm="&new.";
select distinct parm into :c separated by ' ' from candidates having parm^="&new.";
select distinct class into :class separated by ' ' from candidates having parm^="&new_class." and class^='';
quit;
%let old=&old &new; %let old_class=&old_class &new_class;
title "Summary model forward round&round"; %Svylog(dep=&DEP,ind=&old,CLASS=&old_class,input=&regdata,out=STEP_&METHOD,weight=&weight,strata=&strata,cluster=&cluster);
proc sort data=STEP_&METHOD; by ProbChiSq; run;
%mend Forwardlog;

%macro Backwardlog(SLSTAY); %local i;
%let DEP=%upcase(&DEP); %let old=%upcase(&old); %let dataset=%upcase(&dataset);
data STEP_&METHOD; length parm $ 20; if parm='' then delete; run;
title "Backward"; %let i=1; %do %until (&pmax<=&slstay or &varlist=''); %if &i = 1 %then %Svylog(DEP=&DEP ,IND=&old, CLASS=&old_class, input=&regdata,out=pval,weight=&weight,strata=&strata,cluster=&cluster); %*initial model; %else %do; %Svylog(DEP=&DEP ,IND=&varlist,CLASS=&old_class,input=&regdata,out=pval,weight=&weight,strata=&strata,cluster=&cluster); %*reduced model; %end; proc sort data=STEP_&METHOD; by parm; proc sort data=pval; by parm; data STEP_&METHOD; merge STEP_&METHOD pval; by parm; p&i=ProbChiSq; format p&i 6.5; drop ProbChiSq; run; %let varlist=''; proc sql noprint; select round(max(ProbChiSq),0.001) into :pmax from pval; select distinct parm into :varlist separated by ' ' from pval having ProbChiSq^=max(ProbChiSq); quit; %let j=%eval(&i); %let i=%eval(&i+1); %end;
proc sort data=STEP_&METHOD; by p&j; run;
%let removed=;
proc sql noprint;
select distinct parm into :removed separated by ' ' from STEP_&METHOD having p&j=. ;
select distinct parm into :old separated by ' ' from STEP_&METHOD having p&j^=. order by p&j;
quit;
data step_&METHOD; set step_&METHOD; rename p&j=ProbChiSq; keep parm p&j; if p&j^=.; run;
%let c=&c &removed;
%mend Backwardlog;

%macro StepSvylog( 
/******************************************** * Programmer: Fang Wang wang-fang@norc.org * * Sep 2011 * *********************************************/ DEP /*dependent variable*/ ,INTVAR /*all the candidate independent variavles */ ,INTCLASS /*candidate categorical independent varaibels*/ ,DATASET/*input dataset*/ ,SLENTRY/*entry p value*/ ,SLSTAY/*stay p value*/ ,WEIGHT/*weight for wegihted regression models*/ ,STRATA/*complex survye strata variable*/ ,CLUSTER/*complex survey cluster variable*/ ,METHOD/*selection method: forward, backward or stepwise*/ ); %let round=1; %global old; %global old_class; %let old=; %let old_class=; %let pmin=0;
%let method=%upcase(&method);
%if &method=1 %then %do; %do %until (&new= or &pmin>&SLENTRY or (&n=1)); %if &round = 1 %then %do; %ScanVar (&intvar,&intclass); %let regdata=&dataset; %Forwardlog(&SLENTRY); %let round=%eval(&round+1); %end; %else %do; %ScanVar (&c,&class); %Forwardlog(&SLENTRY); %let round=%eval(&round+1); %end; %end; %end;
%if &method=2 %then %do; %let old=&intvar; %let old_class=&intclass; %let regdata=&dataset; %Backwardlog(&SLSTAY); %end;
%if &method=3 %then %do; %do %until (&new= or &pmin>&SLENTRY or (&n=1)); %if &round = 1 %then %do; %ScanVar (&intvar,&intclass); %let regdata=&dataset; %Forwardlog(&SLENTRY); %Backwardlog(&SLSTAY); %let round=%eval(&round+1); %end; %else %do; %ScanVar (&c,&class); %Forwardlog(&SLENTRY); %Backwardlog(&SLSTAY); %let round=%eval(&round+1); %end; %end; %end;
proc print data=STEP_&METHOD; title "&DEP: backward deletion"; run;
%mend StepSvylog;
