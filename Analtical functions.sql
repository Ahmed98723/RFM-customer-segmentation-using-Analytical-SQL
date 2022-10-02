select country,count(stockcode),rank()over(order by count(stockcode)desc )from online_retail
group by 1

--we find united kingdom have The largest number of goods of various kinds which led to an increase in the number of customers coming here.

---------------------------------------------------------------------------------------------------

--Query (2)
select  distinct description, country,sum(Quantity*unitprice) 
over(partition by description,country rows between unbounded preceding and
    unbounded following ) as sales
 from online_retail
 order by 3 desc;
 
--during analysis , we find the product that achieve high sales rate , we find united kingdom
--occupies the first position for products may be in united kingdom There are many branches / stores.


--Query (3)
select *,rank()over(order by sales desc)
 from(select distinct country,sum(quantity*unitprice)over(partition by country
rows between unbounded preceding and unbounded following) as sales
from online_retail
 order by 2 desc
   )as base  

--during analysis this data , I find the most sales in total happens in 
--united kingdom , and the sales in this country is very high than other countries.
----------------------------------------------------------------------------------------------------
--Query (4)
select  country ,extract ( month from cast(invoicedate as date))as month,max(quantity*unitprice)
over(partition by cast(invoicedate as date),country) as sales
from online_retail
where country='United Kingdom'
order by 3 desc

--relation between months and sales .. we find the sales is very high ,in December comparing with the other months ,
--It may be according to the type of product that the customer buys, it may be related to the seasons of the year.

----------------------------------------------------------------------------------------------------

--Query (5) 
select *
from (select distinct description, unitprice, count(*)over (partition by description)
     from online_retail
      where country='United Kingdom'
      order by 3 desc)as base
 
--we find unit price of the most sale product changes many times..
--may be this discount happen so this attractive.. we can prepare more offers which lead to improve the business.

---------------------------------------------------------------------------

--Query (6)
with invoice_cust_sales as
(
    select distinct customerid,invoiceno 
          from online_retail
    where country='United Kingdom'
    order by customerid)
select * ,percent_rank()over(order by no_of_item)*100 as percentrank
from(
 select distinct customerid,count(*)over(partition by customerid)as no_of_item
    from invoice_cust_sales)as base

--we find top customers , who makes a lot of invoices , so it improve business and profit
--can suggest make a lot of offers for this kind of customer.
