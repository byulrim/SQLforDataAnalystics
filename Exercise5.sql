use practice;

describe customer;

select 
	c.mem_no,
    c.gender,
    c.birthday,
    c.addr,
    c.join_date,
    sum(s.sales_qty * p.price) `sales_price`,
    count(s.order_no) `order times`,
    sum(s.sales_qty) `sales quantity`
from customer c 
left outer join sales s 
	on c.mem_no = s.mem_no 
left outer join product p 
	on p.product_code = s.product_code
group by
	c.mem_no,
    c.gender,
    c.birthday,
    c.addr,
    c.join_date
;

create temporary table if not exists customer_pur_info
as (
	select 
		c.mem_no,
		c.gender,
		c.birthday,
		c.addr,
		c.join_date,
		sum(s.sales_qty * p.price) `sales_price`,
		count(s.order_no) `order times`,
		sum(s.sales_qty) `sales quantity`
	from customer c 
	left outer join sales s 
		on c.mem_no = s.mem_no 
	left outer join product p 
		on p.product_code = s.product_code
	group by
		c.mem_no,
		c.gender,
		c.birthday,
		c.addr,
		c.join_date
)
;

describe customer_pur_info;

select 
	count(*)
from customer_pur_info
;

select 
	*,
    timestampdiff(year, birthday, curdate()) `age`
from customer
;

select 
	*,
    case when age < 10 then '10대 미만'
		 when age < 20 then '10대'
		 when age < 30 then '20대'
		 when age < 40 then '30대'
		 when age < 50 then '40대'
         when age < 60 then '50대'
		 else '60대 이상'
	end `age_band`
from (
	select 
		*,
		timestampdiff(year, birthday, curdate()) `age`
	from customer
) `age_band`
;

create temporary table if not exists customer_ageband 
as (
	select 
		*,
		case when age < 10 then '10대 미만'
			 when age < 20 then '10대'
			 when age < 30 then '20대'
			 when age < 40 then '30대'
			 when age < 50 then '40대'
			 when age < 60 then '50대'
			 else '60대 이상'
		end `age_band`
	from (
			select 
				*,
				timestampdiff(year, birthday, curdate()) `age`
			from customer
		) `age_band`
   )
;

describe customer_ageband;

select 
	count(*)
from customer_ageband
;

select 
	*
from customer_pur_info p 
inner join customer_ageband a 
	on p.mem_no = a.mem_no
;

create temporary table if not exists customer_pur_info_ageband
as (
	select 
		p.*,
        a.age_band
	from customer_pur_info p 
	inner join customer_ageband a 
		on p.mem_no = a.mem_no
   )
;

select 
	count(*)
from customer_pub_info_ageband
;


select 
	s.mem_no,
    p.category,
    count(s.order_no) `order times`,
    row_number() over (partition by s.mem_no order by count(s.order_no) desc) `rank`
from sales s 
inner join product p 
	on p.product_code = s.product_code
group by 
	s.mem_no,
    p.category
;

select 
	*
from (
	select 
		s.mem_no,
		p.category,
		count(s.order_no) `order times`,
		row_number() over (partition by s.mem_no order by count(s.order_no) desc) `rank`
	from sales s 
	inner join product p 
		on p.product_code = s.product_code
	group by 
		s.mem_no,
		p.category) a
where `rank` = 1
;

create temporary table if not exists customer_pre_category
as (
	select 
		*
	from (
		select 
			s.mem_no,
			p.category,
			count(s.order_no) `order times`,
			row_number() over (partition by s.mem_no order by count(s.order_no) desc) `rank`
		from sales s 
		inner join product p 
			on p.product_code = s.product_code
		group by 
			s.mem_no,
			p.category) a
	where `rank` = 1
)
;

describe customer_pre_category;

select 
	a.*,
    b.category `pre_category`
from customer_pur_info_ageband a 
left outer join customer_pre_category b 
	on a.mem_no = b.mem_no
;

create temporary table if not exists customer_pur_info_ageband_pre_category 
as (
	select 
		a.*,
		b.category `pre_category`
	from customer_pur_info_ageband a 
	left outer join customer_pre_category b 
		on a.mem_no = b.mem_no
)
;

select 
	*
from customer_pur_info_ageband_pre_category
;

create table if not exists customer_mart
as (
	select 
		*
	from customer_pur_info_ageband_pre_category
)
;

alter table customer_mart
	rename column `order times` to `order_times`;

alter table customer_mart
	rename column `sales quantity` to `sales_quantity`;

describe customer_mart;

select 
	*
from customer_mart
;

select 
	count(mem_no),
    count(distinct mem_no)
from customer_mart
;

select 
	*
from customer_mart
where mem_no = 1000005
;

/*
# mem_no, gender, birthday, addr, join_date, sales_price, order_times, sales_quantity, age_band, pre_category
'1000005', 'man', '1955-03-14', 'Daejeon', '2019-05-05', '408000', '3', '14', '60대 이상', 'home'
*/

/* sales_price, order_times, sales_quantity */
select 
	sum(s.sales_qty * p.price) `sales_price`,
    count(s.order_no) `order_times`,
    sum(s.sales_qty) `sales_quantity`
from customer c 
inner join sales s 
	on c.mem_no = s.mem_no
inner join product p 
	on p.product_code = s.product_code
where c.mem_no = 1000005
;

select 
	p.category,
    count(order_no) `order_times`,
    row_number() over (order by count(order_no) desc) `rank`
from product p 
inner join sales s 
	on p.product_code = s.product_code
where s.mem_no = 1000005
group by category
;

select distinct 
	s.mem_no
from sales s 
;

select 
	*
from customer c 
left outer join (
	select distinct 
		mem_no
	from sales) s 
	on c.mem_no = s.mem_no
;

select 
	*,
    case when s.mem_no is not null then 'Y'
		 else 'N'
	end `order_yn`
from customer c 
left outer join (
	select distinct 
		mem_no
	from sales) s 
	on c.mem_no = s.mem_no
;

select 
	order_yn,
    count(mem_no)
from (
	select 
		c.mem_no,
		case when s.mem_no is not null then 'Y'
			 else 'N'
		end `order_yn`
	from customer c 
	left outer join (
		select distinct 
			mem_no
		from sales) s 
		on c.mem_no = s.mem_no
	) a 
group by order_yn
;

select 
	count(mem_no)
from customer_mart
where sales_price is not null
;

