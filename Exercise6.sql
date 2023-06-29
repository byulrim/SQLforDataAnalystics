use practice;

describe customer;

/* 1. CUSTOMER 테이블을 활용하여, 가입일자가 2019년이며 생일이 4~6월생인 회원수를 조회하시오.*/
select 
	*
from customer 
where year(join_date) = 2019
	and month(birthday) between 4 and 6
order by month(birthday) asc
;

/* 2. SALES 및 PRODUCT 테이블을 활용하여, 1회 주문시 평균 구매금액를 구하시오.(비회원 9999999 제외)*/
select 
	avg(s.sales_qty * p.price) `avg`,
    sum(s.sales_qty * p.price) / count(order_no) `avg_per_order`
from sales s 
inner join product p
	on p.product_code = s.product_code
where mem_no <> 9999999
;

/* 3. SALES 테이블을 활용하여, 구매수량이 높은 상위 10명을 조회하시오.(비회원 9999999 제외)*/
select 
	*
from (
	select 
		mem_no,
		sum(sales_qty) `sales quantity`,
		rank() over (order by sum(sales_qty) desc) `rank`
	from sales
	where mem_no <> 9999999
	group by mem_no) a 
where `rank` <= 10
;

/* 1. View를 활용하여, Sales 테이블 기준으로 CUSTOMER 및 PRODUCT 테이블을 LEFT JOIN 결합한 가상 테이블을 생성하시오.*/
/* 열은 SALES 테이블의 모든 열 + CUSTOMER 테이블의 GENDER + PRODUCT 테이블의 BRAND*/
create or replace view sales_gender_brand
as (
	select 
		s.*,
		c.gender,
		p.brand
	from sales s 
	left outer join customer c 
		on s.mem_no = c.mem_no
	left outer join product p 
		on s.product_code = p.product_code
	)
;

select 
	*
from sales_gender_brand
;

/* 2. Procedure를 활용하여, CUSTOMER의 몇월부터 몇월까지의 생일인 회원을 조회하는 작업을 저장하시오.*/
drop procedure if exists csp_birth_month_in;

delimiter //
create procedure csp_birth_month_in(in start_month int, end_month int)
begin
	select 
		*
	from customer
    where month(birthday) between start_month and end_month
    order by month(birthday);
end//

delimiter ;

call csp_birth_month_in(3, 6);

/* 1. SALES 및 PRODUCT 테이블을 활용하여, SALES 테이블 기준으로 PRODUCT 테이블을 LEFT JOIN 결합한 테이블을 생성하시오.*/
/* 열은 SALES 테이블의 모든 열 + PRODUCT 테이블의 CATEGORY, TYPE + SALES_QTY * PRICE 구매금액 */

create table if not exists sales_mart
as (
	select 
		s.*,
		p.category,
		p.`type`,
		(s.sales_qty * p.price) `sales_price`
	from sales s 
	left outer join product p 
		on s.product_code = p.product_code
    )
;

describe sales_mart;

select 
	*
from sales_mart
;

/* 2. (1)에서 생성한 데이터 마트를 활용하여, CATEGORY 및 TYPE별 구매금액 합계를 구하시오*/
select 
	category,
    `type`,
    sum(sales_price) `total_sales_price`
from sales_mart
group by 
	category,
    `type`
order by
	category,
    `type`
