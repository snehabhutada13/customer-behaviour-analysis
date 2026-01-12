select * from customer limit 20

--Q1: what is the toal revenue generates by male vs female customer ?
select gender , sum(purchase_amount) as revenue 
from customer
group by gender;

--Q2:Which customer used discount but still spent more than the avg purchase amount?
select customer_id, purchase_amount
from customer 
where discount_applied ='Yes' and purchase_amount >= (select avg(purchase_amount) from customer);

--Q3:Which are the top 5 products with the highest average rating ?
 select item_purchased, round(avg(review_rating::numeric),2) as "Average Product Rating"
 from customer
 group by item_purchased
 order by avg(review_rating)desc
 limit 5;
 
--Q4:Compare the average purchase amounts between standard and express shipping.
select  shipping_type ,round(avg(purchase_amount),2)
from customer
where shipping_type in ('Standard','Express')
group by shipping_type;

--Q5:Do subscribed customers spend more? compare average spend and total revenue between subscribers and non subscribers 
SELECT 
    subscription_status,
    count(customer_id) AS total_customers,
    round(avg(purchase_amount), 2) AS avg_spend,
    round(sum(purchase_amount), 2) AS total_revenue 
GROUP BY subscription_status 
ORDER BY total_revenue DESC, avg_spend DESC; \

--Q6:Which 5 products have the highest percentage of purchases with discounts applied 
SELECT 
    item_purchased, 
    ROUND(
        100.0 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*), 
        2
    ) AS discount_rate
FROM customer
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

--Q7:segment customers into new returning , loyal based on their total number of previous purchases 
--and show the count of each segment?
 with customer_type as 
 (SELECT customer_id, previous_purchases,
 CASE 
   WHEN previous_purchases = 1 THEN 'New'
   WHEN previous_purchases between 2 and 10 then 'Returning'
   ELSE 'Loyal'
   END AS customer_segment
   FROM customer)

 SELECT customer_segment, count(*) AS "Number Of customers"
 FROM customer_type
 group by customer_segment
 
--Q8:What are the top 3 most purchased products within each category?
WITH item_counts as ( 
select category , 
     item_purchased , 
count(customer_id) as total_orders,
ROW_NUMBER() OVER(partition by category order by count(customer_id)Desc) AS item_rank
FROM customer
GROUP BY category, item_purchased )

SELECT item_rank , category , item_purchased, total_orders 
from item_counts 
where item_rank <= 3;

--Q9:Are customers who are repeat buyers (more than 5 previous purchases) also liekly to subscribe?
SELECT  subscription_status , 
 COUNT (customer_id) as repeat_buyers
 from customer
 where previous_purchases > 5 
 group by subscription_status;

--Q10 What is the revenue contribution of each age group ?
select age_group , sum(purchase_amount) as revenue_contribution
from customer
group by age_group
order by revenue_contribution desc;




















=











