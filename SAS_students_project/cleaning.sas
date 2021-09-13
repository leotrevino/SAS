/****************************************************************************************************************************************
Luis Trevino
Dr. Michael Sanchez
Final Project - SAS - Cleaning (1)
December 11, 2020

NOTE: Comments are provided throughout code to outline the intention the code written under them. Please see seperate text document
for more detailed explanation of how the initial datasets were adjusted and edited and the reasoning behind those edits. 
*****************************************************************************************************************************************/

Libname Library "\\Client\C$\Users\Sudo\Desktop\Fall 2020 Courses\3 STAT 6033\SAS FINAL\(1) input";

%let mydir = \\Client\C$\Users\Sudo\Desktop\Fall 2020 Courses\3 STAT 6033\SAS FINAL\(1) input;


PROC IMPORT OUT= WORK.Demographics 
            DATAFILE= "\\Client\C$\Users\Sudo\Desktop\Fall 2020 Courses\
3 STAT 6033\SAS FINAL\(1) input\demographics.xls" 
            DBMS=EXCEL REPLACE;
     RANGE="demographics$"; 
     GETNAMES=YES;
     MIXED=NO;
     SCANTEXT=YES;
     USEDATE=YES;
     SCANTIME=YES;
RUN;


/* Conversion of Variables from VARCHAR TO NUM in Background Part1 and Part2 so they are able to be properly appended  */
DATA Background_New1;
Set library.background_part1;
NumBrothers = input(brothers, 8.);
Drop Brothers;
Rename Numbrothers = Brothers;
RUN; 

DATA Background_New2;
Set library.background_part2;
NumSelf_Reg = input(self_regulation, 8.);
Drop Self_Regulation;
Rename NumSelf_Reg = Self_Regulation;
RUN;


/* Appending of Part 1 and Part 2 into one : Background_full + Recoding of negative values to "missing" (.) */

DATA Background_Full;
Set Background_New1 Background_New2;
Rename CASEID = ID;


Array A1[18] _NUMERIC_;
Do i = 1 to 18;
IF A1[i] LT 0 THEN A1[i] = " ";
End;

RUN;

 /* Sorting of Common Variable between Background and Demographics Datasets */

PROC SORT DATA = Background_Full;
BY ID;
RUN;

PROC SORT DATA = Demographics;
BY ID;
RUN;

/* Merging of Background and Demographics Datasets by Common Variable */

DATA Merged_Demographics_Background;
Merge Demographics(IN = DemographicsID)
Background_Full(IN = BackgroundID);
BY ID;
IF DemographicsID AND BackgroundID;
RUN;

/* Proc Means and Proc Freq (check for inconsitent numeric entries) */

PROC MEANS data = Merged_Demographics_Background noprint;
RUN;

PROC FREQ data = Merged_Demographics_Background noprint;
RUN;

/* Defined Value Labels of Variables */

PROC FORMAT;
Value Ethnicity 1 = "White"
				2 = "Black"
				3 = "Hispanic"
				4 = "Other"
;
Value Gender 1 = "Male"
			2 = "Female"
			-8 = "Refused"
			-9 = "Do not know"
;
Value Runaway 1 = "Once"
			2 = "Two or Three times"
			3 = "More than 3 times"
;
Value Income 1 = "$7,500 or less per year"
			2 = "$7,501-$15,000"
			3 = "$15,001-$25,000"
			4 = "$25,001-$35,000"
			5 = "$35,001-$50,000"
			6 = "$50,001-$75,000"
			7 = "$75,001 or more"
;
Value Children 0 = "No"
			1 = "Yes"
;
Value Child_Support 0 = "No"
					1 = "Yes"
;
Value Grade_Level 1 = "6th grade or less"
				2 = "7th grade"
				3 = "8th grade"
				4 = "9th grade"
				5 = "10th grade"
				6 = "11th grade"
				7 = "High School Graduate"
;
Value Grades 1 = "Mostly A's"
			2 = "About half A's and half B's"
			3 = "Mostly B's"
			4 = "About half B's and half C's"
			5 = "Mostly C's"
			6 = "About half C's and half D's"
			7 = "Mostly D's"
			8 = "Mostly below D's"
;
Value ADHD 1 = "ADHD Combinded Type"
		2 = "ADHD Inattentive Type"
		3 = "ADHD Hyperactive-Impulsive Type"
		5 = "NO"
;
RUN;

/* "Cleaning" : Recoding of invalid entries to "missing" + Removal of Duplicate Entries */

DATA Cleaned_Merged;
Set Merged_Demographics_Background;

Array G[1] Gender;
Do i=1;
If G[i] = 3 then G[i] = " ";
End; 

Array Y[1] Survey_Year;
Do i=1;
If Y[i] = 7 then Y[i] = " ";
end;

Array E[1] Ethnicity;
Do i=1;
If E[i] = 0 then E[i] = " ";
End; 

Array C[1] Child_Support;
Do i=1;
If C[i] = 5 then C[i] = " ";
End; 

Array F[1] Friends;
Do i=1;
If F[i] = 1000 then F[i] = " ";
End; 

Array D[1] Detention_Jail;
Do i=1;
If D[i] = 101 then D[i] = " ";
End; 

If (ID = 54411 AND Gender = "") then DELETE;

DROP i;

FORMAT Ethnicity Ethnicity. Gender Gender. Runaway Runaway. Income Income. Children Children. 
Child_Support Child_Support. Grade_Level Grade_Level. Grades Grades. ADHD ADHD.;

RUN;


/* Finalized Dataset Print Out*/

PROC PRINT Data = Cleaned_Merged Label;
RUN;



