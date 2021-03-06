######################################################################
###
### R syntax to produce New Hampshire long data file for 2018-2019
###
######################################################################

### Load data.table package

require(data.table)


### Load base data file

New_Hampshire_Data_LONG_2018_2019 <- fread("Data/Base_Files/New_Hampshire_Data_LONG_2018_2019.txt", colClasses=rep("character", 31))

my.iep.labels <- c("Students with Disabilities (SWD/IEP)", "Students without Disabilities (Non-SWD/IEP)")

setnames(New_Hampshire_Data_LONG_2018_2019, c("DISNUMBER", "ETHNIC"), c("DISTRICT_NUMBER", "ETHNICITY"))

New_Hampshire_Data_LONG_2018_2019[,CONTENT_AREA:=as.factor(CONTENT_AREA)]
levels(New_Hampshire_Data_LONG_2018_2019$CONTENT_AREA) <- c("MATHEMATICS", "READING", "SCIENCE")
New_Hampshire_Data_LONG_2018_2019[,CONTENT_AREA:=as.character(CONTENT_AREA)]

New_Hampshire_Data_LONG_2018_2019[YEAR=="2019",YEAR:="2018_2019"]

New_Hampshire_Data_LONG_2018_2019[,DISTRICT_NUMBER_TESTING_YEAR:=NULL]
New_Hampshire_Data_LONG_2018_2019[,DISTRICT_NAME_TESTING_YEAR:=NULL]

New_Hampshire_Data_LONG_2018_2019[,SCHOOL_NUMBER_TESTING_YEAR:=NULL]
New_Hampshire_Data_LONG_2018_2019[,SCHOOL_NAME_TESTING_YEAR:=NULL]

New_Hampshire_Data_LONG_2018_2019[,ETHNICITY:=factor(ETHNICITY)]

New_Hampshire_Data_LONG_2018_2019[ELL_STATUS=="NULL",ELL_STATUS:=as.character(NA)]
New_Hampshire_Data_LONG_2018_2019[,ELL_STATUS:=factor(ELL_STATUS)]

New_Hampshire_Data_LONG_2018_2019[,ELL_MULTI_CATEGORY_STATUS:=ELL_STATUS]

New_Hampshire_Data_LONG_2018_2019[,ELL_STATUS:=NULL]

New_Hampshire_Data_LONG_2018_2019[,ELL_STATUS:=factor(1, levels=1:2, labels=c("Non-English Language Learners (Non-EL)", "English Language Learners (EL) with Composite >= 4.0"))]
New_Hampshire_Data_LONG_2018_2019[,ELL_STATUS:=as.character(ELL_STATUS)]
New_Hampshire_Data_LONG_2018_2019[ELL_MULTI_CATEGORY_STATUS != "Not ELL", ELL_STATUS:="English Language Learners (EL) with Composite >= 4.0"]
New_Hampshire_Data_LONG_2018_2019[,ELL_MULTI_CATEGORY_STATUS:=as.character(ELL_MULTI_CATEGORY_STATUS)]

New_Hampshire_Data_LONG_2018_2019[,IEP_STATUS:=factor(IEP_STATUS)]
setattr(New_Hampshire_Data_LONG_2018_2019$IEP_STATUS, "levels", my.iep.labels)

New_Hampshire_Data_LONG_2018_2019[,FREE_REDUCED_LUNCH_STATUS:=factor(FREE_REDUCED_LUNCH_STATUS)]
setattr(New_Hampshire_Data_LONG_2018_2019$FREE_REDUCED_LUNCH_STATUS, "levels", c("Economically Disadvantaged (SES)", "Not Economically Disadvantaged (Non-SES)"))

New_Hampshire_Data_LONG_2018_2019[,SCALE_SCORE:=as.numeric(SCALE_SCORE)]

New_Hampshire_Data_LONG_2018_2019[,ACHIEVEMENT_LEVEL:=paste("Level", ACHIEVEMENT_LEVEL)]

New_Hampshire_Data_LONG_2018_2019[,TEST_STATUS:=NULL]

New_Hampshire_Data_LONG_2018_2019[,STATE_ENROLLMENT_STATUS:=factor(STATE_ENROLLMENT_STATUS, levels=0:1, labels=c("Enrolled State: No", "Enrolled State: Yes"))]

New_Hampshire_Data_LONG_2018_2019[,DISTRICT_ENROLLMENT_STATUS:=factor(DISTRICT_ENROLLMENT_STATUS)]
setattr(New_Hampshire_Data_LONG_2018_2019$DISTRICT_ENROLLMENT_STATUS, "levels", c("Enrolled District: No", "Enrolled District: Yes"))

New_Hampshire_Data_LONG_2018_2019[,SCHOOL_ENROLLMENT_STATUS:=factor(SCHOOL_ENROLLMENT_STATUS)]
setattr(New_Hampshire_Data_LONG_2018_2019$SCHOOL_ENROLLMENT_STATUS, "levels", c("Enrolled School: No", "Enrolled School: Yes"))

New_Hampshire_Data_LONG_2018_2019[EMH_LEVEL=="NULL",EMH_LEVEL:=as.character(NA)]

New_Hampshire_Data_LONG_2018_2019[,GENDER:=factor(GENDER)]

New_Hampshire_Data_LONG_2018_2019[,STUDENT_GROUP:=
	factor(4, levels=1:4, c("English Language Learners (EL) Group with Composite >= 4.0",  "Students with Disabilities (SWD/IEP) Group (not EL)", "Economically Disadvantaged (SES) Group (not EL or SWD)", "All Other Students Group (Not EL, Not SWD, Not SES)"))]
New_Hampshire_Data_LONG_2018_2019[ELL_STATUS=="English Language Learners (EL) with Composite >= 4.0", STUDENT_GROUP:="English Language Learners (EL) Group with Composite >= 4.0"]
New_Hampshire_Data_LONG_2018_2019[ELL_STATUS=="Non-English Language Learners (Non-EL)" & IEP_STATUS=="Students with Disabilities (SWD/IEP)", STUDENT_GROUP:="Students with Disabilities (SWD/IEP) Group (not EL)"]
New_Hampshire_Data_LONG_2018_2019[ELL_STATUS=="Non-English Language Learners (Non-EL)" & IEP_STATUS=="Students without Disabilities (Non-SWD/IEP)" & FREE_REDUCED_LUNCH_STATUS=="Economically Disadvantaged (SES)", STUDENT_GROUP:="Economically Disadvantaged (SES) Group (not EL or SWD)"]
New_Hampshire_Data_LONG_2018_2019[,STUDENT_GROUP:=as.character(STUDENT_GROUP)]

New_Hampshire_Data_LONG_2018_2019[,c("InvalidSessions", "SAUName", "AlternateStudentID", "Typeofdata", "DateGenerated"):=NULL]


### Identify VALID_CASES and INVALID_CASES

New_Hampshire_Data_LONG_2018_2019[,VALID_CASE:="VALID_CASE"]
New_Hampshire_Data_LONG_2018_2019[GRADE==11|CONTENT_AREA=="SCIENCE", VALID_CASE:="INVALID_CASE"]


### Setkey

setkey(New_Hampshire_Data_LONG_2018_2019, VALID_CASE, CONTENT_AREA, YEAR, GRADE, ID)


### Save output

save(New_Hampshire_Data_LONG_2018_2019, file="Data/New_Hampshire_Data_LONG_2018_2019.Rdata")
