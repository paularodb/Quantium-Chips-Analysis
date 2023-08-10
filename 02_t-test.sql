/* The client has selected store numbers 77, 86, and 88 as trial stores to test the impact and performance of the new trial layouts.
Our goal is to create a control group comprised of established stores that have similar metrics to the trial stores prior to the trial period,
which is from February 2019 to April 2019. We would like to choose our control stores based on the following metrics for each month: total sales
revenue, total number of customers, and average number of transactions per customer. */

-- Creating new view for data, filtering only for transactions made prior to the trial period.
create view quantium.prior as
	select *
    from quantium.tran_tbl_p as t
    where t.date < '2019-02-01'

-- Calcualting each metric for our trial stores per month.
select p.store_nbr, month(p.date) as month, year(p.date) as year,
	round(sum(p.tot_sales)) as revenue, 
	count(distinct(p.lylty_card_nbr)) as total_customers,
    count(p.txn_id)/count(distinct(p.lylty_card_nbr)) as avg_txn_count
from quantium.prior as p
where p.store_nbr in (77, 86, 88)
group by p.store_nbr, month(p.date), year(p.date)
order by p.store_nbr, year(p.date), month(p.date)

-- Calculating each metric for non-trial stores per month.
select p.store_nbr, month(p.date) as month, year(p.date) as year,
	round(sum(p.tot_sales)) as revenue, 
	count(distinct(p.lylty_card_nbr)) as total_customers,
    count(p.txn_id)/count(distinct(p.lylty_card_nbr)) as avg_txn_count
from quantium.prior as p
where p.store_nbr not in (77, 86, 88)
group by p.store_nbr, month(p.date), year(p.date)
order by p.store_nbr, year(p.date), month(p.date)

-- Moving to Excel for correlation analysis.


-- Correlation analysis and A/B testing complete. Now retrieving metrics for our trial stores for every month in our data.
select p.store_nbr, month(p.date) as month, year(p.date) as year,
    round(sum(p.tot_sales)) as revenue,
    count(distinct(p.lylty_card_nbr)) as total_customers,
    count(p.txn_id)/count(distinct(p.lylty_card_nbr)) as avg_txn_count
from quantium.tran_tbl_p as p
where p.store_nbr in (77, 86, 88)
group by p.store_nbr, month(p.date), year(p.date)
order by p.store_nbr, year(p.date), month(p.date)

-- Calculating metrics for non-trial stores for every month in our data.
select p.store_nbr, month(p.date) as month, year(p.date) as year,
    round(sum(p.tot_sales)) as revenue,
    count(distinct(p.lylty_card_nbr)) as total_customers,
    count(p.txn_id)/count(distinct(p.lylty_card_nbr)) as avg_txn_count
from quantium.tran_tbl_p as p
where p.store_nbr not in (77, 86, 88)
group by p.store_nbr, month(p.date), year(p.date)
order by p.store_nbr, year(p.date), month(p.date)

-- Moving to Excel for t-test analysis.






