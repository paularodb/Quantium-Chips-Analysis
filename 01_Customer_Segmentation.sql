/* Based on transaction and customer data given, we would like to gain insights that will feed into the supermarket's strategic plan for their
chips category. In order to define the recommendations that will accomplish this, we must better understand the types of customers who purchase
chips and their purchasing behavior. The data spans from July 1, 2018 to June 30, 2019. */

-- Calculating total chip sales for each month.
select month(t.date) as month, year(t.date) as year, sum(t.tot_sales) as revenue
from quantium.tran_tbl_p as t
group by month(t.date), year(t.date)
order by year(t.date), month(t.date)

-- There seems to be an increase of purchases in December. Let's zoom in and take a look at the individual days.
select day(t.date) as day, sum(t.tot_sales) as revenue
from quantium.tran_tbl_p as t
where month(t.date)= 12
group by day(t.date)

/* We can see that there is an increase in sales leading up to Christmas and that there are no sales on Christmas day itself (due to stores
being closed. This indicates that there was a holiday spike in sales. Now, let's investigate whether there are similar spikes on other holidays,
like Halloween and Thanksgiving. */
select day(t.date) as day, sum(t.tot_sales) as revenue
from quantium.tran_tbl_p as t
where month(t.date)= 10
group by day(t.date)
order by revenue

-- There does not seem to be a holiday trend for Halloween. Now checking for Thanksgiving.
select day(t.date) as day, sum(t.tot_sales) as revenue
from quantium.tran_tbl_p as t
where month(t.date)= 11
group by day(t.date)
order by revenue

-- Interestingly, there seem to be less chip sales leading up to Thanksgiving Day. 

-- Moving on to average sales and quantity per transaction analysis. Calculating the minimum and maximum sales per transaction
select min(t.prod_qty) as minimum, max(t.prod_qty) as maximum
from quantium.tran_tbl_p as t

-- Minimum is 1 and maximum is 5. Results are to be expected/ no outliers. Now calculating average sales and quantity per transaction.
select AVG(t.prod_qty) as Quantity_Avg, avg(t.tot_sales) as Sales_Avg
from quantium.tran_tbl_p as t

-- The average quantity sold per transaction is 1.9 bags of chips, and the average sale made per transaction is $7.29.
-- Now calculating the daily average chip sales and daily average quantity sold.
select avg(daily.quantity) as daily_quantity, avg(daily.sales) as daily_sales
from (
	select t.date, sum(t.prod_qty) as quantity, sum(t.tot_sales) as sales
	from quantium.tran_tbl_p as t
	group by t.date) as daily

/* Average daily quantity sold is 1307 bags, and average daily sales is $4999.41. Using this information, we would like to analyze the
chips transaction distributions based on different variables (brand, packet size, customer type). */

-- Now analyzing transactions to see which chip brands are selling better and their % of revenue compared to other chips.
select t.prod_brand, sum(t.tot_sales) as revenue, 
round((sum(t.tot_sales)*100)/
	(select sum(t.tot_sales) from quantium.tran_tbl_p as t),0) as percentage
from quantium.tran_tbl_p as t
group by t.prod_brand
order by revenue desc

/* It seems like the most popular chips brand is Kettle at $390,239 total revenue, almost doubling the 2nd most popular chips brand. Kettle
accounts for 21% of the total chips revenue, making it the most important brand to restock. The top 4 chip brands make up a little more than
half of the total chips revenue. After Kettle chips, the next 3 popular brands are Doritos, Smiths, and Pringles. It should also be noted
that the brands "French Fries" and "Burger" are producing less than 1% of the chips revenue. */

-- Now analyzing transactions to see which packet sizes are selling the most and their % contribution to revenue.
select t.prod_size_grams, sum(t.tot_sales) as revenue, 
round((sum(t.tot_sales)*100)/
	(select sum(t.tot_sales) from quantium.tran_tbl_p as t),0) as percentage
from quantium.tran_tbl_p as t
group by t.prod_size_grams
order by revenue desc

/* The most popular packet size is 175g, contributing to 27% of the total chips revenue. The next most popular is 150g (17% of total revenue),
and the 3rd most popular size is 134g (10% of revenue). Could this be because most chip packages are in these 2 sizes? */

/* Now that we know what brand and packet size are most popular, let's investigate our customer types and see how recently each of them have 
made chip purchases. For the rest of our analysis, we would like to describe the customers by lifestage and how premium their general 
purchasing behavior is, which can help us understand which customer segment contributes most to chip sales.*/
with rec as(
	select lylty_card_nbr, datediff("2019-06-30", max(date)) as recency
	from quantium.tran_tbl_p
	group by lylty_card_nbr)
select p.premium_customer, p.lifestage, avg(rec.recency) as average_recency
from rec
join quantium.qvi_purchase_behaviour as p
on rec.lylty_card_nbr= p.lylty_card_nbr
group by p.premium_customer, p.lifestage
order by average_recency

/* It looks like older families from all purchasing behaviors have made purchases more recently than all other lifestages, followed by young
families, then older singles/ couples from all purchasing behaviors. Now, let's check out which customer types have made more frequent
purchases over the given period of time. */
with freq as(
	select lylty_card_nbr, count(txn_id) as frequency
	from quantium.tran_tbl_p
	group by lylty_card_nbr)
select p.premium_customer, p.lifestage, avg(freq.frequency) as avg_frequency
from freq
join quantium.qvi_purchase_behaviour as p
on freq.lylty_card_nbr= p.lylty_card_nbr
group by p.premium_customer, p.lifestage
order by avg_frequency desc

/* Older families, followed by young families and older singles/couples, of all purchasing behaviors have also made more frequent purchases.
So far, these groups seem to be more valuable for our target customer segments, since they are more likely to continue making purchases in the
future. */

/* Next, let's begin to analyze the total sales made based on each customer type. Let's begin with solely lifestage. */
select p.lifestage, sum(t.tot_sales) as revenue
from quantium.tran_tbl_p as t
left join quantium.qvi_purchase_behaviour as p
on t.lylty_card_nbr= p.lylty_card_nbr
group by p.lifestage
order by revenue desc

/* Top 3 revenues come from older single/couples, retirees, and older families. It seems that sales are mainly coming from older customers.
Let's investigate whether the higher sales are due to there being more customers in these lifestages. */
select new.lifestage, new.count, (new.revenue/new.count) as sales_per_person
from (
	select p.lifestage, count(p.lifestage) as count, sum(t.tot_sales) as revenue
	from quantium.tran_tbl_p as t
	left join quantium.qvi_purchase_behaviour as p
	on t.lylty_card_nbr= p.lylty_card_nbr
	group by p.lifestage) as new
order by count desc

/* It seems that the higher sales are due to there being more customers in the older lifestages. The column "sales per person" also shows us
that the average total sales per person is about the same for all lifestages. Let's investigate whether customer purchasing behavior contributes
to higher sales. */
select p.premium_customer, sum(t.tot_sales) as revenue
from quantium.tran_tbl_p as t
left join quantium.qvi_purchase_behaviour as p
on t.lylty_card_nbr= p.lylty_card_nbr
group by p.premium_customer
order by revenue desc

/* There are higher sales coming from mainstream customers, followed by budget customers and then premium customers. It seems that customers
with normal spending habits buy more chips. Let's investigate whether the higher sales are due to there being more customers with these
purchasing behaviors. */
select new.premium_customer, new.count, (new.revenue/new.count) as sales_per_person
from (
	select p.premium_customer, count(p.premium_customer) as count, sum(t.tot_sales) as revenue
	from quantium.tran_tbl_p as t
	left join quantium.qvi_purchase_behaviour as p
	on t.lylty_card_nbr= p.lylty_card_nbr
	group by p.premium_customer) as new

/* It seems that the higher sales are due to there being more customers in the mainstream purchasing behavior. The "sales per person" column 
also shows us that the average total sales per person is about the same for all customer behaviors. Now, let's see how much of each lifestage
and purchasing behavior type contribute to the proportion of sales. */
select p.premium_customer, p.lifestage, 
	(sum(t.tot_sales)*100)/(select sum(t.tot_sales) from quantium.tran_tbl_p as t) as proportion
from quantium.tran_tbl_p as t
left join quantium.qvi_purchase_behaviour as p
on t.lylty_card_nbr= p.lylty_card_nbr
group by p.lifestage, p.premium_customer
order by proportion desc

/* Sales are mainly coming from Budget- Older families, Mainstream- Young Singles/ Couples, Mainstream- Retirees, and Older Singles/ couples
from any customer type. */

-- Higher sales may also be driven by more units of chips per transaction being bought per customer. Let's analyze.
select p.lifestage, p.premium_customer, avg(t.prod_qty) as avg_quantity
from quantium.tran_tbl_p as t
left join quantium.qvi_purchase_behaviour as p
on t.lylty_card_nbr= p.lylty_card_nbr
group by p.lifestage, p.premium_customer
order by avg_quantity desc

/* It appears that older families and young families buy more chips per customer, regardless of their purchasing behavior. This could be due to
the fact that parents have to buy larger quantities of chips to feed their children and themselves. This can also explain why newer families 
rank lower on the list, since very young children do not consume chips. Now, let's examine which customer type tends to purchase more per 
transaction. */
select p.lifestage, p.premium_customer, avg(t.tot_sales) as avg_sale
from quantium.tran_tbl_p as t
left join quantium.qvi_purchase_behaviour as p
on t.lylty_card_nbr= p.lylty_card_nbr
group by p.lifestage, p.premium_customer
order by avg_sale desc

/* Interestingly, midage singles/couples and young singles/couples with mainstream purchasing behaviors (highest average sales) tend to pay
more per transaction than their premium and budget counterparts (who have the lowest average sale). This seems plausible, since earlier
we recognized that mainstream customers had higher overall sales than their counterparts. This could also be because there are more 
customers who identify with the mainstream purchase behavior. */

-- Now that we have all the information for our RFM analysis, let's compute the quintile values for each customer type.
with rfm as(
	select lylty_card_nbr, 
		datediff("2019-06-30", max(date)) as recency, 
        count(txn_id) as frequency, 
        round(sum(tot_sales)) as monetary
    from quantium.tran_tbl_p as t
    group by lylty_card_nbr)
select p.premium_customer, p.lifestage,
	ntile(5) over (order by rfm.recency) as recency_q,
    ntile(5) over (order by rfm.frequency) as frequency_q,
    ntile(5) over (order by rfm.monetary) as monetary_q
from rfm
join quantium.qvi_purchase_behaviour as p
on rfm.lylty_card_nbr= p.lylty_card_nbr
group by p.premium_customer, p.lifestage, rfm.recency, rfm.frequency, rfm.monetary

/* Now that we have determined the quintiles for each customer, let's use the RFM results to categorize our customers and create segmentation
groups. The segments will be defined as followed: Champion, Loyal, Promising, New, About to Lapse, Cannot Lose, At Risk, and Lost. */
create view quantium.numbers as
	select lylty_card_nbr, 
		datediff("2019-06-30", max(date)) as recency, 
        count(txn_id) as frequency, 
        round(sum(tot_sales)) as monetary
	from quantium.tran_tbl_p as t
	group by lylty_card_nbr
    
create view quantium.ntile as
	select lylty_card_nbr as lylty_nbr, recency, frequency, monetary,
		ntile(5) over (order by recency desc) as rec_quint,
		ntile(5) over (order by frequency) as freq_quint,
		ntile(5) over (order by monetary) as mon_quint
	from quantium.numbers
	group by lylty_card_nbr

create view quantium.rfm as 
	select *,
		case 
			when n.rec_quint = 5 and n.freq_quint >= 4 then 'Champions'
			when n.rec_quint >= 3 and n.freq_quint >= 4 then 'Loyal'
			when n.rec_quint >= 3 and n.freq_quint = 3 then 'Promising'
			when n.rec_quint >= 4 and n.freq_quint <= 2 then 'New'
			when n.rec_quint = 3 and n.freq_quint <= 2 then 'About to Lapse'
			when n.rec_quint <= 2 and n.freq_quint >= 4 then 'Cannot Lose'
			when n.rec_quint <= 2 and n.freq_quint >= 2 then 'At Risk'
			else 'Lost'
		end as segment
	from quantium.ntile as n
	join quantium.qvi_purchase_behaviour as p
	on n.lylty_nbr= p.lylty_card_nbr

select premium_customer, lifestage, count(*) as count
from quantium.rfm
where segment= 'Champions'
group by premium_customer, lifestage
order by count desc 

select premium_customer, lifestage, count(*)
from quantium.rfm
group by premium_customer, lifestage
order by premium_customer




      







