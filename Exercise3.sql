use practice;

select 
	*,
    (select
		gender 
	from customer
    where mem_no = sales.mem_no) as gender
from sales
;

select 
	*
from customer 
where mem_no = 1000970
;

select 
	*
from customer c 
inner join sales s 
	on c.mem_no = s.mem_no
;

select 
	*
from (
		select 
			mem_no,
            count(order_no) as `주문횟수`
		from sales
        group by mem_no) s
;

select 
	mem_no,
    count(order_no) as `주문횟수`
from sales
group by mem_no
;

select 
	count(mem_no) as `주문횟수`
from sales
where mem_no in (
	select 
		mem_no
	from customer
    where 2019 = year(join_date))
;

select 
	count(c.mem_no) as `주문횟수`
from customer c 
inner join sales s 
	on c.mem_no = s.mem_no
where 2019 = year(c.join_date)
;

select 
	count(mem_no)
from customer
where 2019 = year(join_date)
;

select 
	*,
    year(join_date)
from customer
;

select 
	mem_no
from customer
where 2019 = year(join_date)
;

select 
	count(order_no) as `주문횟수`
from sales
where mem_no in (
	select
		mem_no
	from customer
    where year(join_date) = 2019
	)
;

create temporary table sales_sub_query
	select 
		s.구매횟수,
		c.*
	from (
		select 
			mem_no,
			count(order_no) as `구매횟수`
		from sales
		group by mem_no) s 
	inner join customer c 
		on c.mem_no = s.mem_no
;

select 
	*
from sales_sub_query;

describe sales_sub_query;

select 
	*
from sales_sub_query
where gender = 'man'
;

select 
	addr,
    sum(`구매횟수`) `구매횟수`
from sales_sub_query
where gender = 'man'
group by addr
;

select 
	addr,
    sum(`구매횟수`) `구매횟수`
from sales_sub_query
where gender = 'man'
group by addr
having `구매횟수` < 100
;

select 
	addr,
    sum(`구매횟수`) `구매횟수`
from sales_sub_query
where gender = 'man'
group by addr
having `구매횟수` < 100
order by `구매횟수` asc
;