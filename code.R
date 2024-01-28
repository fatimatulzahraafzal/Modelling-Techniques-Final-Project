
library("SASxport")
library(dplyr)
library(ggplot2)
library(foreign)
library(ggpubr)


#Step 1:

#Part 1:
#Load Blood Pressure & Cholesterol Questionnaire Data, extract the column “Ever told you had high blood pressure”
BPCQ <- read.xport("BPQ_J.XPT")
BPCQ_extract <- BPCQ[, c("SEQN","BPQ020")]

#Part 2: 
#Load Body Measures Data, extract Weight, Standing Height (cm), Arm Circumference(cm), Hip Circumference(cm), and BMI; 
BMDX <- read.xport("BMX_J.XPT")
BMDX_extract <- BMDX[, c("SEQN","BMXWT","BMXHT","BMXARMC","BMXHIP","BMXBMI")]
#Load Diet Behavior & Nutrition Questionnaire Data, extract “How healthy is the diet”, “How often drank milk age 18-35?”
DBNQ <- read.xport("DBQ_J.XPT")
DBNQ_extract <- DBNQ[, c("SEQN","DBQ700","DBQ235C")]

#Part 3:
#Load Alcohol Use Questionnaire Data, “Past 12 mo how often have alcohol drink”, and “days have 4 or 5 drinks/past 12 mos”
ALCQ <- read.xport("ALQ_J.XPT")
ALCQ_extract <- ALCQ[, c("SEQN","ALQ121","ALQ142")]

#Merge:
merged<- inner_join(DBNQ_extract,BMDX_extract,by='SEQN')%>%inner_join(.,BPCQ_extract,by='SEQN')%>%inner_join(.,ALCQ_extract,by='SEQN')

#in the column DBQ700, the missing value is removed itself(coded='.'),
#   refused (coded=7), don't know (coded=9) need to be omitted
merged<-within(merged,DBQ700[DBQ700==7|DBQ700==9]<-NA)

#in the column DBQ235c, the missing value is removed itself(coded='.'),
#   varied (coded=4), refused (coded=7), don't know (coded=9) need to be omitted
merged<-within(merged,DBQ235C[DBQ235C==4|DBQ235C==7|DBQ235C==9]<-NA)

#in the column BMXWT, BMXHT, BMXARMC, BMXHIP and BMXBMI the missing value coded as '.' is treated NA already
#in the column BMXHT, the missing value coded as '.' is treated NA already
#in the column BMXARMC, the missing value coded as '.' is treated NA already
#in the column BMXHIP, the missing value coded as '.' is treated NA already
#in the column BMXBMI, the missing value coded as '.' is treated NA already

#in the column BPQ020, the missing value is removed itself(coded='.'),
#   refused (coded=7), don't know (coded=9) need to be omitted
merged<-within(merged,BPQ020[BPQ020==7|BPQ020==9]<-NA)
#in the column BPQ020, 2 has to be replaced with 0, as 2 indicates no blood pressure
merged<-within(merged,BPQ020[BPQ020==2]<-0)

#in the column ALQ121, the missing value is removed itself(coded='.'),
#   refused (coded=77), don't know (coded=99) need to be omitted
merged<-within(merged,ALQ121[ALQ121==77|ALQ121==99]<-NA)

#in the column ALQ142, the missing value is removed itself(coded='.'),
#   refused (coded=77), don't know (coded=99) need to be omitted
merged<-within(merged,ALQ142[ALQ142==77|ALQ142==99]<-NA)

merged<-na.omit(merged)

summary(merged)


#Step 1:

#Part 1:
#target disease: diabetes
#related risk factors: 
#blood pressure (categorical: 0/1)
#BMI (numerical: range)
#how healthy is your diet (categorical: 1-5)



#Part 2:
#first we will load the diabetes table.
Diabetes <- read.xport("DIQ_J.XPT")
Diabetes_extract <- Diabetes[, c("SEQN","DIQ010")]


#Part 3: Data pre-processing: any methods that may advance the analysis

#changing the value '3' by '1' assuming borderline cases have diabetes
#changing the value '2' by '0', those without diabetes
#coding: with diabetes(1) without diabetes(0)
Diabetes_extract<-within(Diabetes_extract,DIQ010[DIQ010==2]<-0)
Diabetes_extract<-within(Diabetes_extract,DIQ010[DIQ010==3]<-1)
#remove the values NA and code=7(refused) and code=9(don't know)
Diabetes_extract<-within(Diabetes_extract,DIQ010[DIQ010==7|DIQ010==9]<-NA)
Diabetes_extract<-na.omit(Diabetes_extract)

Results<- inner_join(merged,Diabetes_extract,by='SEQN')

#Part 4: Find the relations between each pairs of risk factors, 


#relation between 'BMI' and 'weight'
cor.test(Results$BMXBMI,Results$BMXWT)
plot(Results$BMXBMI,Results$BMXWT)


#relation between 'blood pressure' and 'BMI'
logistic_model_1<-glm(BPQ020~BMXBMI,data=Results,family=binomial)
summary(logistic_model_1)

#relation between 'blood pressure' and 'weight'
logistic_model_2<-glm(BPQ020~BMXWT,data=Results,family=binomial)
summary(logistic_model_2)


#Part 5: Find the relations between risk factors and target disease

#relation between diabetes and Blood pressure
table(Results$DIQ010,Results$BPQ020)
chisq.test(Results$DIQ010,Results$BPQ020,correct = FALSE)


#relation between diabetes and BMI
logistic_model_3<-glm(DIQ010~BMXBMI,data=Results,family=binomial)
summary(logistic_model_3)
log.df<- data.frame(BMXBMI = seq(0,180, 1))
log.df$DIQ010<- predict(logistic_model_3,newdata=log.df, type="response")
ggplot(log.df, aes(x=BMXBMI, y=DIQ010)) + geom_line() + labs(title = 'Diabetes vs BMI', x = 'Body Mass Index', y = 'Diabetes') 


#relation between diabetes and weight
logistic_model_4<-glm(DIQ010~BMXWT,data=Results,family=binomial) 
summary(logistic_model_4)
log.df2<- data.frame(BMXWT = seq(0,500, 1))
log.df2$DIQ010<- predict(logistic_model_4,newdata=log.df2, type="response")
ggplot(log.df2, aes(x=BMXWT, y=DIQ010)) + geom_line() + labs(title = 'Diabetes vs Weight', x = 'Weight (lbs)', y = 'Diabetes') 

