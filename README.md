# Quantium Chips Analysis README

## 1- Business Goals Overview
Quantium’s supermarket client is looking to gain data driven insights that would feed into their strategic plan for their chips sales. The client currently does not have an in-depth analysis to understand customer behavior, which creates a challenge to design targeted marketing campaigns to increase chip sales revenue. Our goal is to conduct a comprehensive analysis that would help the client understand their **customers’ purchasing behaviors** which will help define the recommendations needed to **boost transactions and sales**. This will be accomplished by generating customer **RFM segmentations** and by developing an **A/B testing plan** to select trial and control stores for a new trial layout.

## 2- Technical Highlights
**SQL** was utilized to pull and aggregate the dataset down to a more manageable size that only included necessary data for further analysis, which was accomplished using **subqueries, WITH clauses, and VIEWS**. Additional queries were then run for computational purposes, allowing us to spot the patterns and trends in the data that provided applicable solutions for the supermarket client.

<img width="450" alt="image" src="https://github.com/paularodb/Quantium-Chips-Analysis/assets/139396583/70a0e744-8f6b-4f0a-97a5-5661bc501ebf">

The **RFM segmentation** was also completed through SQL by creating quintiles based on each customer’s transaction dates and sales. These **quintiles** were then used to create eight segmentations that summarized each customer’s purchasing history and patterns. SQL was also used to sort and filter only the necessary data that was needed to complete a **correlation analysis and t-test** on Excel. The correlation analysis and t-tests were completed using **pivot tables, functions, and data analysis tools**, such as the CORREL and T-INV functions. 

<img width="450" alt="image" src="https://github.com/paularodb/Quantium-Chips-Analysis/assets/139396583/9a05ad1b-8b24-47f9-afb0-5624d529a5ab">

## 3- RFM Customer Segmentation
According to our RFM analysis, 34% of the supermarket’s customers are considered **“Champions” or “Loyalists”** for the chips category. This is a great proportion of customers who seem to be satisfied with the chip selections. To retain these customers, we recommend engaging with them by asking for rewards or referrals that contain rewards upon completion.

On the other end, 27% of the customers are categorized as **“Cannot Lose” or “At Risk”**. Since this also represents a high percentage of customers, it is crucial that we implement a marketing strategy aimed to win these groups back so they are not lost to competitors. This can be accomplished through special offers, such as sending personal emails to reconnect, higher coupons for incentive, or recommending new products based on their previous purchasing history.

As seen on the bubble chart below, a customer’s higher **recency and frequency** score corresponds with a higher **average total spent** (average monetary value, AMV), meaning the supermarket should create targeted strategies for each group to increase customer transactions.

<img width="450" alt="image" src="https://github.com/paularodb/Quantium-Chips-Analysis/assets/139396583/20c585b9-bc14-4d67-8204-096c2161a4fe">

## 4- Trial Stores Revenue and Customer Performance
After selecting the three paired control stores that match their respective test stores’ pre-trial performance, we can see that there was a positive response from the new trial layouts from each test store. 

The stores outperformed their assigned control stores’ revenue throughout the entire trial period, even earning an impressive 26% revenue increase in March and 15% revenue increase in April. The test stores also outperformed the control stores in customer count throughout February to May, showing an 18% customer increase in March and 11% customer increase in April. Since the trial layouts were successful, we can conclude that the application of this design to remaining stores will have a positive impact for their revenues and total customers. 

The charts below illustrate the **lift** in revenue and customer visits between **test and control groups**. The months with red circles indicate months that had shown a **statistical significance in their increase**.

<img width="450" alt="image" src="https://github.com/paularodb/Quantium-Chips-Analysis/assets/139396583/fa4104a1-0596-4445-b75b-15eab4c3771e">

<img width="450" alt="image" src="https://github.com/paularodb/Quantium-Chips-Analysis/assets/139396583/b1e22648-1c06-4cbd-bd76-5d6111de6ea4">
