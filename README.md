# Modelling-Techniques-Final-Project

**EE3211 Project Report – Diabetes Mellitus**


**Background**

Diabetes is a chronic health condition characterized by high blood sugar levels. It is caused by a variety of 
factors, including genetics, lifestyle habits, and health factors. This analysis aims to explore the 
relationship between diabetes and physical attributes and blood pressure. The data for this analysis was 
obtained from the National Health and Nutrition Examination Survey (NHANES), which is conducted by 
the National Center for Health Statistics. NHANES assesses the health and nutrition of adults and 
children in the U.S.

**Objectives**
Diabetes is an increasingly prevalent and serious disease, so understanding the relationship between 
these potential risk factors and diabetes is important for public health. For this analysis, questionnaire 
data on diabetes, physical measurements, blood pressure and alcohol use were analyzed. The goal was 
to determine whether and how these factors may be related to the risk and prevalence of diabetes. 
Lastly, it is aimed to employ appropriate statistical methods like chi-square and logistic regression to 
analyze the correlations.

**Methods**
• Identifying target disease and risk factors: The target disease was selected to be diabetes and 
the risk factors were BMI, weight, and blood pressure.
• Data cleaning: To start with, the data collected from the NHANES was loaded in a table called 
‘Merged’ and later into ‘Results’. The data initially had lots of NA values which were coded in 
response to answers like ‘prefer not to say’ or ‘could not obtain’. These values were cleaned from 
all the columns.
• Data preprocessing: A few more changes were made like borderline diabetes was treated as 
diabetes so changed to value 1.
• Pearson correlation method: This method was used to assess the relationship between two 
numerical variables (BMI and weight).
• Chi-square method: This method was used to assess the relationship between two categorical 
variables (Blood pressure and diabetes).
• Logistic regression model: This method was used to assess the relationship between a 
categorical and numerical variable (e.g., BMI and diabetes).
• Graphs for correlation and logistic regression models were plotted.

**Conclusion:**
Using the RStudio program, several successful statistical tests were conducted on the datasets and 
insights into the various factors were gained that contribute to the development of diabetes, like BMI 
and blood pressure. Our analysis revealed that diabetes is significantly linked to body weight, blood 
pressure, and BMI. While BMI is significantly related to weight, it should be noted that both the variables 
are highly associated with an increased risk of developing diabetes, as determined through the use of 
logistic regression. Our findings suggest that individuals who adopt healthier lifestyles may be less 
susceptible to developing diabetes
