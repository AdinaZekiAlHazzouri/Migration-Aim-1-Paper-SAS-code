
libname created 'C:\Users\\\\\\\SAS datasets';
libname RAND 'C:\Users\\\\\\\RAND_Files';
libname Tracker 'C:\Users\\\\\\\Tracker_Files';
run;
options nofmterr;



/**********************************************************************************************************************************************/
/**************************************************************CALL IN DATASET*****************************************************************/
/**********************************************************************************************************************************************/
data paper1; set created.HRS_MHAS_PAPER1_firstage; run;

proc format; value
mig 0="Non-Migrant (MHAS)"
	1="Return Migrant (MHAS)"
	2="US Migrant (HRS)";
run;
proc means data=paper1; var agefstjob; class migration; run;
proc univariate data=paper1; var agefstjob; histogram agefstjob; class migration; format migration mig.; run;


/**********************************************************************************************************************************************/
/*************************************SETUP DATASET FOR SURVIVAL ANALYSIS WITH TIME-DEPENDENT VARIABLES****************************************/
/**********************************************************************************************************************************************/

data paper1_long;
set paper1;
do agenow = 0 to 114 until (agenow = timetoev);
	start = agenow;
	stop = agenow + 1;
**********years of education***********************;
	if raedyrs < 0 then eductv =.M;
	else if agenow < 6 then eductv = 0;
	else if agenow >= 6 and agenow < 6+raedyrs then eductv = agenow-6;
	else if agenow >= 6 + raedyrs then eductv = raedyrs;

**********Migration***********************;
	if agefstmig =.N or (agefstmig ^=.N and agenow < agefstmig) then migration_bitv = 0;
	else if agefstmig ^=.N and agenow = agefstmig then migration_bitv = 1; 

**********Marital status***********************;

	/*MHAS: now that errors in marital status are fixed, we have 5 valid patterns and these were created in program 5*/
	if HRS = 0 and agelstd > 0 then do;
		if agenow < agefstm then mstattv = 0;
		else if agenow >= agefstm and agenow < agefstd then mstattv = 1;
		else if agenow >= agefstd and agenow < agelstm then mstattv = 0;
		else if agenow >= agelstm and agenow < agelstd then mstattv = 1;
		else if agenow >= agelstd then mstattv = 0;
	end;
	if HRS = 0 and agelstd =.L then do;
		if agenow < agefstm then mstattv = 0;
		else if agenow >= agefstm and agenow < agefstd then mstattv = 1;
		else if agenow >= agefstd and agenow < agelstm then mstattv = 0;
		else if agenow >= agelstm then mstattv = 1;
	end;
	if HRS = 0 and agelstd =.R then do;
		if agenow < agefstm then mstattv = 0;
		else if agenow >= agefstm and agenow < agefstd then mstattv = 1;
		else if agenow >= agefstd then mstattv = 0;
	end;
	if HRS = 0 and agelstd =.F then do;
		if agenow < agefstm then mstattv = 0;
		else if agenow >= agefstm then mstattv = 1;
	end;
	if HRS = 0 and agelstd =.N then mstattv = 0;
	if HRS = 0 and agelstd =. then mstattv =.; /*6 real missing in MHAS*/

	/*HRS*/
	if HRS = 1 and agetrdd > 0 then do;
		if agenow < agefstm then mstattv = 0;
		else if agenow >= agefstm and agenow < agefstd then mstattv = 1;
		else if agenow >= agefstd and agenow < agescdm then mstattv = 0;
		else if agenow >= agescdm and agenow < agescdd then mstattv = 1;
		else if agenow >= agescdd and agenow < agetrdm then mstattv = 0;
		else if agenow >= agetrdm and agenow < agetrdd then mstattv = 1;
		else if agenow >= agetrdd then mstattv = 0;
	end;
	if HRS = 1 and agetrdd =.T then do;
		if agenow < agefstm then mstattv = 0;
		else if agenow >= agefstm and agenow < agefstd then mstattv = 1;
		else if agenow >= agefstd and agenow < agescdm then mstattv = 0;
		else if agenow >= agescdm and agenow < agescdd then mstattv = 1;
		else if agenow >= agescdd and agenow < agetrdm then mstattv = 0;
		else if agenow >= agetrdm then mstattv = 1;
	end;
	if HRS = 1 and agetrdd =.D then do;
		if agenow < agefstm then mstattv = 0;
		else if agenow >= agefstm and agenow < agefstd then mstattv = 1;
		else if agenow >= agefstd and agenow < agescdm then mstattv = 0;
		else if agenow >= agescdm and agenow < agescdd then mstattv = 1;
		else if agenow >= agescdd then mstattv = 0;
	end;
	if HRS = 1 and agetrdd =.S then do;
		if agenow < agefstm then mstattv = 0;
		else if agenow >= agefstm and agenow < agefstd then mstattv = 1;
		else if agenow >= agefstd and agenow < agescdm then mstattv = 0;
		else if agenow >= agescdm then mstattv = 1;
	end;
	if HRS = 1 and agetrdd =.R then do;
		if agenow < agefstm then mstattv = 0;
		else if agenow >= agefstm and agenow < agefstd then mstattv = 1;
		else if agenow >= agefstd then mstattv = 0;
	end;
	if HRS = 1 and agetrdd =.F then do;
		if agenow < agefstm then mstattv = 0;
		else if agenow >= agefstm then mstattv = 1;
	end;
	if HRS = 1 and agetrdd =.N then mstattv = 0;

**********smoking status, working status,height***********************;
		/*height*/
		if agenow < 17 then heighttv = .S; /*structured missing*/
		if agenow >= 17 then heighttv = height;

		if agenow < firstage then do;
			notMeasured = 1;
			/*Smoking status*/
			if agefstsmk =.N and rasmokev = 0 then smktv= 0;
			else if agenow < agefstsmk then smktv = 0;
			else if agenow >= agefstsmk then smktv = 1;
			/*Working status*/
			if agefstjob =.M and RAJJOBS = . then jobtv = .M;
			else if agefstjob =.N and RAJJOBS = 0 then jobtv = 0;
			else if agenow < agefstjob then jobtv = 0;
			else if agenow >= agefstjob then jobtv = 1;
		end;

		else if hrs = 0 and agenow >= firstage then do;
			notMeasured = 0;
			array age_list[4] gage_h hage_h nage_h oage_h;
			array smkstat_list[3] R5SMOKEN R6SMOKEN R11SMOKEN;
			array jobstat_list[3] R5WORK R6WORK R11WORK;
			do i = 1 to 3;
				if agenow >= age_list[i] and agenow < age_list[i+1] then do;
					smktv = smkstat_list[i];
					jobtv = jobstat_list[i];
				end;
			end;
		end;

		else if hrs = 1 and agenow >= firstage then do; /*This will not be used as all the individuals in HRS migrated before first interview*/
			notMeasured = 0;
			array age_list2[14] aage_h bage_h cage_h dage_h eage_h fage_h gage_h hage_h jage_h kage_h lage_h mage_h nage_h oage_h;
			array smkstat_list2[13] R1SMOKEN R2SMOKEN R2SMOKEN R3SMOKEN R3SMOKEN R4SMOKEN R5SMOKEN R6SMOKEN R7SMOKEN R8SMOKEN R9SMOKEN R10SMOKEN R11SMOKEN;
			array jobstat_list2[13] R1WORK R2WORK R2WORK R3WORK R3WORK R4WORK R5WORK R6WORK R7WORK R8WORK R9WORK R10WORK R11WORK;
			do i = 1 to 13;
				if agenow >= age_list2[i] and agenow < age_list2[i+1] then do;
					smktv = smkstat_list2[i];
					jobtv = jobstat_list2[i];
				end;
			end;
		end; /*till here*/
output;
end;
run;

/*hhidpn = 1277710 doesn't have age at first interview, so I am setting up their smoking/working status and height seperately*/
data paper1_long;
set paper1_long;
if hhidpn = 1277710 then do;
	/*smoking status: agefstsmk = 17 and agefstmig = 16*/
	smktv = 0;
	/*working status*/
	if agenow < 16 then jobtv = 0;
	if agenow = 16 then jobtv = 1;
	/*height: agefstmig = 16*/
	heighttv = .S;
end;
run;




/**********************************************************************************************************************************************/
/*****************************************CREATE MISSING INDICATORS TO NOT DROP MEASURES FROM MODELS*******************************************/
/**********************************************************************************************************************************************/
/*Creating missing indicators to not drop height and education measures from the model*/
data paper1_long2;
set paper1_long;
/*own education*/
if eductv=.M then eductv_miss=1;
else eductv_miss=0;
if eductv=.M and ragender=1 then eductv=4.4455304;
else if eductv=.M and ragender=2 then eductv=3.6928832;
/*parental education*/
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
/*height*/
if agenow <17 then do;
	heighttv_c=0;
	height17miss=1;
end;
if agenow>=17 then do;
	heighttv_c= (heighttv*100)/5;/*height in cm and increments of 5*/
	height17miss=0;
end;
/*marital status*/
if mstattv=. then do;
	mstattv=0;
	mstattv_miss=1;
end;
else mstattv_miss=0;
/*smoking status*/
if smktv in (.D,.M,.R) then do;
	smktv=0;
	smktv_miss=1;
end;
else smktv_miss=0;
/*working status*/
if jobtv in (.,.D,.M,.R) then do;
	jobtv=1;
	jobtv_miss=1;
end;
else jobtv_miss=0;
run;

/* data created.paper1_long_firstage; set paper1_long2; run;
*/
