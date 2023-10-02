create database bank_project;
use bank_project;

create table Finance_one(
id int,
member_id int,
loan_amnt int,
funded_amnt int,
funded_amnt_inv double,
term text,
int_rate text,
installment double,
grade text,
sub_grade text,
emp_title text,
emp_length text,
home_ownership	text,
annual_inc int,
verification_status text,
issue_d text,
loan_status text,
pymnt_plan text,
desc1 text,
purpose text,	
title text,
zip_code text,
addr_state text,
dti text);
/*

*/
drop table Finance_one;
select * from Finance_one;

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Finance_one.csv' 
into table Finance_one 
fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 rows;

create table Finance_two(
id int,
delinq_2yrs int,
earliest_cr_line text,
inq_last_6mths int,
mths_since_last_delinq text,
mths_since_last_record text,
open_acc int,
pub_rec	int,
revol_bal int,
revol_util text,
total_acc int,
initial_list_status text,
out_prncp int,
out_prncp_inv int,
total_pymnt double,
total_pymnt_inv double,
total_rec_prncp double,
total_rec_int double,
total_rec_late_fee int,
recoveries int,
collection_recovery_fee int,
last_pymnt_d text,
last_pymnt_amnt double,
next_pymnt_d text,
last_credit_pull_d text
);

drop table Finance_two;
select * from Finance_two;

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Finance_two.csv' 
into table Finance_two 
fields terminated by ',' enclosed by '"' lines terminated by '\n' ignore 1 rows;

-- KPI-1 : Year wise loan amount Stats ---
SELECT YEAR(ISSUE_D) AS ISSUED_YEAR, SUM(loan_amnt) AS TOTAL_LOAN_AMT
FROM Finance_one
GROUP BY YEAR(ISSUE_D)
ORDER BY ISSUED_YEAR;

-- KPI-2 : Grade and sub grade wise revol_bal ---
SELECT F1.GRADE, F1.SUB_GRADE, SUM(F2.REVOL_BAL) AS TOTAL_REVOL_BALANCE
FROM Finance_one F1
INNER JOIN Finance_two F2
ON F1.ID=F2.ID
GROUP BY F1.GRADE, F1.SUB_GRADE
ORDER BY F1.GRADE;

-- KPI-3 : Total Payment for Verified Status Vs Total Payment for Non Verified Status --
SELECT F1.VERIFICATION_STATUS,SUM(F2.total_pymnt)
FROM Finance_one F1
INNER JOIN Finance_two F2
ON F1.ID=F2.ID
WHERE F1.VERIFICATION_STATUS IN ('Verified' , 'Not Verified')
GROUP BY VERIFICATION_STATUS;

-- KPI-4 : State wise and last_credit_pull_d wise loan status --
SELECT F1.ADDR_STATE,F2.last_credit_pull_d,F1.LOAN_STATUS
FROM Finance_one F1
INNER JOIN Finance_two F2
ON F1.ID=F2.ID
ORDER BY ADDR_STATE;

-- KPI-5 : Home ownership Vs last payment date stats --
SELECT F1.HOME_OWNERSHIP,F2.LAST_PYMNT_D,F1.LOAN_AMNT
FROM Finance_one F1
INNER JOIN Finance_two F2
ON F1.ID=F2.ID; 

-- EXTRA-KPIs --
SELECT MAX(LOAN_AMNT) FROM Finance_one;

SELECT MIN(LOAN_AMNT) FROM Finance_one;

SELECT SUM(LOAN_AMNT) as Total_Loan_Amnt FROM Finance_one;

SELECT AVG(LOAN_AMNT) FROM Finance_one;

SELECT COUNT(DISTINCT ADDR_STATE) as Total_States FROM Finance_one;

SELECT COUNT(MEMBER_ID) as Total_Member_IDs FROM Finance_one;

SELECT AVG(INT_RATE)*100 as Avg_Int_Rate FROM Finance_one;

SELECT AVG(ANNUAL_INC) FROM Finance_one;

