#Telecom Customer Churn Analysis Using SQL

##Project Overview

This project analyzes customer churn for a telecommunications company using SQL and MySQL. The objective is to identify customer churn patterns, revenue loss, customer segments, and factors associated with customer churn.

##Business Problem

A telecom company is experiencing customer churn, resulting in potential revenue loss. This analysis explores customer and service data to understand churn patterns and identify high-risk customer segments.

##Objectives

* Calculate the overall customer churn rate
* Analyze churn by contract type
* Analyze churn by internet service
* Analyze churn by payment method
* Analyze gender-wise churn
* Analyze customer tenure and churn
* Calculate revenue lost due to churn
* Perform customer segmentation
* Identify high-risk customers
* Rank contract types based on churn rate

##Database and Tools

* Database: MySQL
* Tool: MySQL Workbench
* Language: SQL

##SQL Skills Used

* SELECT
* Aggregate Functions
* GROUP BY
* HAVING
* CASE WHEN
* JOINs
* Subqueries
* CTEs
* RANK()
* Window Functions
* PARTITION BY
* Business KPI calculations

##Tables Used

The project uses three tables:

* Billing
* Services
* Telecoms churn

These tables are connected using customerID for the required analyses.

##Project Analysis

The analysis covers:

1. Overall customer churn
2. Contract-wise churn
3. Internet service-wise churn
4. Payment method-wise churn
5. Revenue lost due to churn
6. Tenure-based churn
7. Customer segmentation
8. High-risk customer identification
9. Contract churn ranking using CTE and RANK()

##Project Files

* telecom_churn_analysis.sql — SQL queries used for the analysis
* 01_overall_churn.png — Overall churn analysis
* 02_contract_churn.png — Contract-wise churn
* 03_internet_service.png — Internet service analysis
* 04_high_risk_customers.png — High-risk customer analysis
* 05_churn_ranking.png — Contract churn ranking

##Note

The original dataset contained 7,043 records. Due to import issues, 7,032 records were successfully imported into MySQL for this project.

##Learning Outcome

This project helped strengthen my SQL skills and provided practical experience in using SQL to analyze customer behavior and solve business-related analytical problems.
