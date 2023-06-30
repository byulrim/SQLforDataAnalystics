use practice;

describe sales;

select 
	*
from sales
where mem_no <> 9999999
order by
	mem_no
;

select 
	mem_no,
	min(order_date) `first_order_date`,
    max(order_date) `latest_order_date`,
    count(order_no) `number_of_order`
from sales
where mem_no <> 9999999
group by 
	mem_no
;

select 
	*,
	case when date_add(first_order_date, interval 1 day) <= latest_order_date then 'Y'
		 else 'N'
	end `reorder_yn`,
	datediff(latest_order_date, first_order_date) `order_interval`,
	case when number_of_order - 1 = 0 or datediff(latest_order_date, first_order_date) = 0 then 0
		 else round(datediff(latest_order_date, first_order_date) / (number_of_order - 1), 1) 
	end `order_period`
from (
	select 
		mem_no,
		min(order_date) `first_order_date`,
		max(order_date) `latest_order_date`,
		count(order_no) `number_of_order`
	from sales
	where mem_no <> 9999999
	group by 
		mem_no
) a
;

drop table if exists re_pur_cycle;

create table if not exists re_pur_cycle
as (
	select 
		*,
		case when date_add(first_order_date, interval 1 day) <= latest_order_date then 'Y'
			 else 'N'
		end `reorder_yn`,
		datediff(latest_order_date, first_order_date) `order_interval`,
		case when number_of_order - 1 = 0 or datediff(latest_order_date, first_order_date) = 0 then 0
			 else round(datediff(latest_order_date, first_order_date) / (number_of_order - 1), 1)
		end `order_period`
	from (
		select 
			mem_no,
			min(order_date) `first_order_date`,
			max(order_date) `latest_order_date`,
			count(order_no) `number_of_order`
		from sales
		where mem_no <> 9999999
		group by 
			mem_no
	) a
)
;

select 
	*
from re_pur_cycle
;