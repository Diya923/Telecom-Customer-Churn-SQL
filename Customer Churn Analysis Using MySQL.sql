-- Telecom Customer Churn Analysis
-- Dataset: Telco Customer Churn 


create database churn_analysis;
use churn_analysis;
show tables;

create table services AS
select
    customerID,
    PhoneService,
    MultipleLines,
    InternetService,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies
from `wa_fn-usec_-telco-customer-churn`;

create table billing as
select
    customerID,
    tenure,
    Contract,
    PaperlessBilling,
    PaymentMethod,
    MonthlyCharges,
    TotalCharges,
    Churn
from `wa_fn-usec_-telco-customer-churn`;
show tables;

select * from `wa_fn-usec_-telco-customer-churn` limit 5;
select * from services limit 5;
select * from billing limit 5;
describe `wa_fn-usec_-telco-customer-churn`;
describe services;
describe billing;

select
    c.customerID,
    c.gender,
    s.InternetService,
    b.Contract,
    b.MonthlyCharges,
    b.Churn
from `wa_fn-usec_-telco-customer-churn` c
join Services s
on c.customerID = s.customerID
join Billing b
on c.customerID = b.customerID;
    
-- what is the total number of customers
select count(*) as total_customers from `wa_fn-usec_-telco-customer-churn`;

-- how many customers churned and how many stayed
select churn,count(*) as customer_count from billing group by churn;

-- what is the overall churn rate 
select round(sum(case when churn='yes' then 1 else 0 end)*100.0/count(*),2) as churn_rate from billing;

-- what is the average monthly charge
select round(avg(monthlycharges),2) as average_monthly_charge from billing;

-- what is the total revenue generated
select round(sum(totalcharges),2) as total_revenue from billing;

-- what is the churn rate by contract type
select contract,count(*) as total_customers,sum(case when churn='yes' then 1 else 0 end) as churned_customers,
round(sum(case when churn ='yes' then 1 else 0 end)*100.0/count(*),2) as churn_rate 
from billing group by Contract;

-- which contract type has the highest no.of churned customers
select contract,sum(case when churn='yes' then 1 else 0 end) as churned_customers
from billing group by contract order by churned_customers desc limit 1;

-- what is the churn rate by internet service
select s.internetservice,count(*) as total_customers,sum(case when b.churn='yes' then 1 else 0 end ) as churned_customers,
round(sum(case when b.churn='yes' then 1 else 0 end)*100.0/count(*),2) as churn_rate from services s join billing b 
on s.customerID=b.customerID group by s.InternetService;

-- what is the churn rate by payment method
select paymentmethod,count(*) as total_customers,sum(case when churn='yes' then 1 else 0 end) as churned_customers,
round(sum(case when churn='yes' then 1 else 0 end)*100.0/count(*),2) as churn_rate from billing group by PaymentMethod;

-- what is the gender wise churn rate
select c.gender,count(*) as total_customers,sum(case when b.churn='yes' then 1 else 0 end)as churned_customers,
round(sum(case when b.churn='yes' then 1 else 0 end)*100.0/count(*),2) as churn_rate from `wa_fn-usec_-telco-customer-churn` c join billing  b
on c.customerID=b.customerID group by c.gender;

-- how much revenue was lost due to churn
select round(sum(totalcharges),2) as revenue_lost from billing where churn='yes';

-- what is the average monthly charge of churned vs non churned customers
select churn,round(avg(monthlycharges),2) as average_monthly_charge from billing group by churn;

-- what is the average total charge of churned vs non churned customers
select churn,round(avg(totalcharges),2) as average_total_charge from billing group by churn;


-- which contract type generates highest revenue
select contract,round(sum(totalcharges),2) as total_revenue from billing group by contract
order by total_revenue desc;

-- which payment method generates highest revenue
select paymentmethod,round(sum(totalcharges),2) as total_revenue from billing group by paymentmethod order by total_revenue desc;

-- how many customers are there in each tenure group
select 
   case 
   when tenure<=12 then '0-12 months'
   when tenure<=24 then '13-24 months'
   when tenure<=48 then '25-48 months'
   else '49+ months'
   end as tenure_group,
count(*) as customer_count
from billing
group by tenure_group
order by min(tenure);

-- what is the churn rate for each tenure group
select
    case
	when tenure <= 12 THEN '0-12 Months'
	when tenure <= 24 THEN '13-24 Months'
    when tenure <= 48 THEN '25-48 Months'
	else '49+ Months'
    end as tenure_group,
    count(*) AS total_customers,
    sum(case when Churn = 'Yes' then 1 else 0 end) as churned_customers,
    round(sum(case when Churn = 'Yes' then 1 else 0 end) * 100.0/count(*), 2) as churn_rate
from Billing
group by tenure_group
order by min(tenure);

-- creates customer segments based on monthly charges
select 
  case 
   when monthlycharges<30 then 'low value'
   when monthlycharges<=70 then 'medium value'
   else 'high value'
   end as customer_segment,count(*) as customer_count
   from billing group by customer_segment;
   
-- identify high risk customers
select customerid,tenure,contract,monthlycharges,churn,
case 
  when contract='month-to-month' and tenure<=12 and monthlycharges>=70 then 'high risk'
  when contract='month-to-month' or tenure<=12 then 'medium risk'
  else 'low risk'
  end as risk_level from billing;
  
-- find customers whose monthly charges are above average
select customerid,monthlycharges from billing where MonthlyCharges>(select avg(monthlycharges) from billing);

-- find customers whose total charges are above average
select customerid,totalcharges from billing where TotalCharges>(select avg(totalcharges) from billing);

-- which internet service has the highest average monthly charge among churned customers
select s.internetservice,round(avg(b.monthlycharges),2) as average_monthly_charge from services s join billing b on 
s.customerID=b.customerID where b.churn='yes' group by s.InternetService having count(*)>0 order by average_monthly_charge desc;

-- rank contract types based on churn rate
with contract_churn as (select contract,round(sum(case when churn='yes' then 1 else 0 end)*100.0/count(*),2) as churn_rate
from billing group by Contract) select contract,churn_rate,rank() over (order by churn_rate desc) as churn_rank from contract_churn;
 
-- rank payment methods based on revenue
select paymentmethod,round(sum(totalcharges),2) as total_revenue, rank() over (order by sum(totalcharges) desc) as revenue_rank from billing 
group by paymentmethod;

-- rank customers within each contract type by monthly charges
select customerid,contract,monthlycharges,rank() over (partition by contract order by monthlycharges desc) as charge_rank from billing;

-- create a final customer risk classification
select c.customerid,c.gender,s.internetservice,b.contract,b.tenure,b.monthlycharges,b.churn,
case 
  when b.contract='month-to-month' and b.tenure<=12 and b.monthlycharges>=70 and b.churn='yes' then 'high risk'
  when b.contract='month-to-month' and b.tenure<=24 then 'medium risk'
  else 'low risk'
end as risk_level
from `wa_fn-usec_-telco-customer-churn` c join services s on c.customerid=s.customerid join billing b on c.customerid=b.customerid;

