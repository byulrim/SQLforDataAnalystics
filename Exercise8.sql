use practice;

select 
	c.mem_no,
    c.gender,
    c.birthday,
    c.addr,
    c.join_date,
    sum(s.sales_qty * p.price) `order_price`,
    count(s.order_no) `number_of_order`
from customer c 
left outer join sales s 
	on c.mem_no = s.mem_no
left outer join product p 
	on s.product_code = p.product_code
where 
	2020 = year(s.order_date)
group by
	c.mem_no,
    c.gender,
    c.birthday,
    c.addr,
    c.join_date	
;

create table if not exists rfm
as (
	select 
		c.*,
		dirived_s.sales_price,
		dirived_s.number_of_order
	from customer c 
	left outer join (
		select 
			s.mem_no,
			sum(p.price * s.sales_qty) `sales_price`,
			count(s.order_no) `number_of_order`
		from product p 
		inner join sales s 
			on p.product_code = s.product_code
		group by 
			s.mem_no
		) dirived_s
		on c.mem_no = dirived_s.mem_no
)
;

select 
	*
from rfm
;

select 
	*,
    case when sales_price > 5000000 then 'VIP'
		 when sales_price > 1000000 or number_of_order > 3 then '우수회원'
         when sales_price > 0 then '일반회원'
         else '잠재회원'
	end `class_member`
from rfm
;

select 
	class_member,
    count(mem_no) `number_of_member`
from (
	select 
		*,
		case when sales_price > 5000000 then 'VIP'
			 when sales_price > 1000000 or number_of_order > 3 then '우수회원'
			 when sales_price > 0 then '일반회원'
			 else '잠재회원'
		end `class_member`
	from rfm) a
group by 
	class_member
order by 
	`number_of_member` asc
;

select 
	class_member,
    sum(sales_price) `sales_price`
from (
	select 
		*,
		case when sales_price > 5000000 then 'VIP'
			 when sales_price > 1000000 or number_of_order > 3 then '우수회원'
			 when sales_price > 0 then '일반회원'
			 else '잠재회원'
		end `class_member`
	from rfm) a
group by 
	class_member
order by 
	`sales_price` desc
;

select 
	class_member,
    sum(sales_price) / count(mem_no) `sales_price_per_member`,
    avg(sales_price)
from (
	select 
		*,
		case when sales_price > 5000000 then 'VIP'
			 when sales_price > 1000000 or number_of_order > 3 then '우수회원'
			 when sales_price > 0 then '일반회원'
			 else '잠재회원'
		end `class_member`
	from rfm) a
group by 
	class_member
order by 
	`sales_price_per_member` desc
;
