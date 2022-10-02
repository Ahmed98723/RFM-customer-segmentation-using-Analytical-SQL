with RFM as (
select customerid,
    (SELECT MAX(TO_DATE(invoicedate,'DD Mm YYYY') ) FROM online_retail)-
    MAX(TO_DATE(invoicedate,'DD Mm YYYY') )as recency,
    
    count(*)as frequency,
    sum(quantity*unitprice)as monetary
    from online_retail
    group by customerid order by customerid
    ),calc_rfm as (
    select cal_rfm.*,ntile(5) over(order by recency desc)as R_score,
                     ntile(5) over(order by frequency )as F_score,
                     ntile(5) over(order by monetary )as M_score
 from RFM cal_rfm)
select r.*, 
(case when R_score=5 and (F_score+M_score)/2=5 then 'Champion'
 when R_score=5 and (F_score+M_score)/2=4 then 'Champion'
 when R_score=4 and (F_score+M_score)/2=5 then 'Champion'
 when R_score=5 and (F_score+M_score)/2=2 then 'Potential Loyalists'
 when R_score=4 and (F_score+M_score)/2=2 then 'Potential Loyalists'
 when R_score=3 and (F_score+M_score)/2=3 then 'Potential Loyalists'
 when R_score=4 and (F_score+M_score)/2=3 then 'Potential Loyalists'
 when R_score=5 and (F_score+M_score)/2=3 then 'Loyal Customers'
 when R_score=4 and (F_score+M_score)/2=4 then 'Loyal Customers'
 when R_score=3 and (F_score+M_score)/2=5 then 'Loyal Customers'
 when R_score=3 and (F_score+M_score)/2=4 then 'Loyal Customers'
 when R_score=5 and (F_score+M_score)/2=1 then 'Recent Customers'
 when R_score=4 and (F_score+M_score)/2=1 then 'Promising'
 when R_score=3 and (F_score+M_score)/2=1 then 'Promising'
 when R_score=3 and (F_score+M_score)/2=2 then 'Customers Needing Attention'
 when R_score=2 and (F_score+M_score)/2=3 then 'Customers Needing Attention'
 when R_score=2 and (F_score+M_score)/2=2 then 'Customers Needing Attention'
 when R_score=2 and (F_score+M_score)/2=5 then 'At Risk'
 when R_score=2 and (F_score+M_score)/2=4 then 'At Risk'
 when R_score=1 and (F_score+M_score)/2=3 then 'At Risk'
 when R_score=1 and (F_score+M_score)/2=5 then 'Cant Lose Them '
 when R_score=1 and (F_score+M_score)/2=4 then 'Cant Lose Them '
 when R_score=1 and (F_score+M_score)/2=2 then 'Hibernating '
 when R_score=1 and (F_score+M_score)/2=1 then 'Lost'
end )as cust_segment
from calc_rfm r
order by customerid
