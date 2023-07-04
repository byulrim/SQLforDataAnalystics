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

alter table re_pur_cycle 
	modify column mem_no int comment '회원번호';
alter table re_pur_cycle
	modify column first_order_date date comment '최초주문일자';
alter table re_pur_cycle
	modify column latest_order_date date comment '최근주문일자';
alter table re_pur_cycle
	modify column number_of_order bigint not null comment '주문횟수';
alter table re_pur_cycle
	modify column reorder_yn varchar(1) not null comment '재구매여부';
alter table re_pur_cycle
	modify column order_interval int comment '구매간격';
alter table re_pur_cycle
	modify column order_period decimal(10, 1) comment '구매주기';

show full columns from `re_pur_cycle`;

select 
	*
from re_pur_cycle
;

select 
	*
from sales s 
where mem_no = 1000021
;

/*
# order_no, mem_no, order_date, product_code, sales_qty
'3', '1000021', '2019-05-07', '494', '2'
'44', '1000021', '2019-05-16', '30', '11'
'61', '1000021', '2019-05-21', '494', '16'
*/

select 
	*
from sales s 
where mem_no = 1000021
;

show tables;

select 
	*
from re_pur_cycle
where mem_no = 1000021
;

describe re_pur_cycle;

select 
	count(mem_no) `구매회원수`,
    count(
		case when reorder_yn = 'Y' then mem_no
        end) `재구매회원수`
from re_pur_cycle
;

select 
	count(mem_no)
from re_pur_cycle
where reorder_yn ='Y'
;

select 
	round(avg(order_period), 2) `평균 구매주기`
from re_pur_cycle
where order_period > 0
;

select 
	*,
    case when order_period <= 7	 then '1주 이내'
		 when order_period <= 14 then '2주 이내'
         when order_period <= 21 then '3주 이내'
         else '4주 이후'
	end `주간 구매주기`
from re_pur_cycle
where order_period > 0
;

select 
	`주간 구매주기`,
    count(mem_no) `회원수`
from (
	select 
		*,
		case when order_period <= 7	 then '1주 이내'
			 when order_period <= 14 then '2주 이내'
			 when order_period <= 21 then '3주 이내'
			 else '4주 이후'
		end `주간 구매주기`
	from re_pur_cycle
	where order_period > 0) a
group by 
	`주간 구매주기`
;


