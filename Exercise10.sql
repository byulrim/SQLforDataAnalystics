use practice;

show full columns from `sales`;

show full columns from `product`;

select 
	s.mem_no,
    p.category, 
    p.brand, 
    (s.sales_qty * p.price) `sales_price`, -- 구매금액
    case when date_format(order_date, '%Y-%m') between '2020-01' and '2020-03' then '2020_1분기'
		 when date_format(order_date, '%Y-%m') between '2020-04' and '2020-06' then '2020_2분기'
	end `quarter` -- 분기
from sales s 
inner join product p 
	on s.product_code = p.product_code
where date_format(order_date, '%Y-%m') between '2020-01' and '2020-06'
order by mem_no
;

create table if not exists product_growth
as (
	select 
		s.mem_no,
		p.category, 
		p.brand, 
		(s.sales_qty * p.price) `sales_price`, -- 구매금액
		case when date_format(order_date, '%Y-%m') between '2020-01' and '2020-03' then '2020_1분기'
			 when date_format(order_date, '%Y-%m') between '2020-04' and '2020-06' then '2020_2분기'
		end `quarter` -- 분기
	from sales s 
	inner join product p 
		on s.product_code = p.product_code
	where date_format(order_date, '%Y-%m') between '2020-01' and '2020-06'
	order by mem_no
)
;

describe product_growth;

alter table product_growth
	modify column sales_price bigint comment '구매금액';
    
alter table product_growth
	modify column quarter varchar(8) comment '분기';
    
show full columns from `product_growth`;

select 
	*
from product_growth
;

select 
	category,
    `quarter`,
    sum(sales_price)
from product_growth
group by 
	category,
    `quarter`
with rollup
;

select 
	category,
    sum(case when quarter = '2020_1분기' then sales_price end) `2020_1분기_구매금액`,
    sum(case when quarter = '2020_2분기' then sales_price end) `2020_2분기_구매금액`
from product_growth
group by 
	category
;

select 
	*,
    round(((`2020_2Q_sales_price` * 1) / `2020_1Q_sales_price`) - 1, 2) `growth_rate`		-- 1Q 대비 2Q 성장률
from (
	select 
		category,
		sum(case when quarter = '2020_1분기' then sales_price end) `2020_1Q_sales_price`,	-- 2020_1분기_구매금액
		sum(case when quarter = '2020_2분기' then sales_price end) `2020_2Q_sales_price`	-- 2020_2분기_구매금액
	from product_growth
	group by 
		category) a
;

select 
	brand,
    count(distinct mem_no),
    sum(sales_price),
    avg(sales_price),
    sum(sales_price) / count(distinct mem_no)
from product_growth
where category = 'beauty'
group by 
	brand
order by 4 desc
;
