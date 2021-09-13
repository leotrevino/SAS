/****************************************************************************************************************************************
Luis Trevino
Dr. Michael Sanchez
Final Project - SAS - Reports (2)
December 11, 2020

*****************************************************************************************************************************************/

%let mydir = \\Client\C$\Users\Sudo\Desktop\Fall 2020 Courses\3 STAT 6033\SAS FINAL\(1) input;
%let in = &mydir\(1) input; 
%let out = &mydir\(3) output; 

/************************************ REPORT 1 - Grades and Emotionality *************************************************/
ods html close;
ods escapechar='^';
ods trace on;
ods rtf file = "&mydir\MyReport1.rtf" 

/*Meda Data in Word Document*/ 
author = "Luis Trevino" operator = "Luis Trevino" title = "My Report 1"
bodytitle_aux
columns = 1
startpage = yes;
title1 bold "Summary Statistics of Emotionality across Grades";
ods noproctitle;

ods rtf text = "A one-way ANOVA comparing the effects of Grades on Emotionality was performed. 
There was not a significant effect of Grades on Emotionality for the 8 levels ^\b [F(7,264) = 1.31, p= 0.2453]. ^\b0
A graph of results can be seen below.";


proc means data = cleaned_merged maxdec=2;
Var emotionality;
class grades;
output out = summary
n(grades) = count
mean(grades) = average 
std(grades) = std
min 
max;
run;


proc anova data = cleaned_merged;
ODS select boxplot;
Class Grades;
model Emotionality = Grades ;
run;

ods rtf close;
ODS PREFERENCES;
ods trace off;
quit;
ods html;



/************************************************ REPORT 2 - Income and Emotionality  *********************************************/
ods html close;
ods escapechar='^';


ods rtf file = "&mydir\MyReport2.rtf" 
/*Meda Data in Word Document*/ 
author = "Luis Trevino" operator = "Luis Trevino" title = "My Report 2"
bodytitle_aux
columns = 1
startpage = yes;

title1 bold "Summary Statistics of Emotionality across Income";
ods noproctitle;


ods rtf text = "A one-way ANOVA comparing the effects of Income on Emotionality was performed. 
There was not a significant effect of Grades on Emotionality for the 8 levels ^\b [F(7,264) = 1.31, p= 0.2453]. ^\b0
A graph of results can be seen below.";


proc means data = cleaned_merged maxdec=2;
Var emotionality;
class income;
output out = summary 
n(income) = count
mean(income) = average 
std(income) = std
min 
max;
run;



proc anova data = cleaned_merged;
ODS select boxplot;
Class Income;
model Emotionality = Income ;
run;


ods rtf close;
ODS PREFERENCES;
ods trace of;
quit;
ods html;


/**************************************************** REPORT 3 - Friends and Emotionality  *************************************************/


ods html close;
ods escapechar='^';


ods rtf file = "&mydir\MyReport3.rtf" 
/*Meda Data in Word Document*/ 
author = "Luis Trevino" operator = "Luis Trevino" title = "My Report 3"
bodytitle_aux
columns = 1
startpage = yes;

title1 bold "Summary Statistics of Emotionality across Friends";
ods noproctitle;


ods rtf text = "A one-way ANOVA comparing the effects of Friends on Emotionality was performed. 
There was not a significant effect of Grades on Emotionality for the 8 levels ^\b [F(7,264) = 1.31, p= 0.2453]. ^\b0
A graph of results can be seen below.";



proc means data = cleaned_merged maxdec=2;
Var emotionality;
class friends;
output out = summary 
n(friends) = count
mean(friends) = average 
std(friends) = std
min 
max;
run;

proc anova data = cleaned_merged;
ODS select boxplot;
Class Friends;
model Emotionality = Friends ;
run;
ods rtf close;
ODS PREFERENCES;
ods trace of;
quit;
ods html;
