use practice;



create table if not exists customer_profile
as (
	select 
		a.mem_no,
		a.gender,
		a.birthday,
		a.addr,
		a.join_date,
		a.join_ym,
		a.age,
		a.ageband,
		a.order_yn
	from (
		select 
			c.mem_no,
			c.gender,
			c.birthday,
			c.addr,
			c.join_date,
			date_format(join_date, '%Y-%m') `join_ym`,
			timestampdiff(year, birthday, curdate()) `age`,
			case when timestampdiff(year, birthday, curdate()) < 10 then '10대 미만'
				 when timestampdiff(year, birthday, curdate()) < 20 then '10대'
				 when timestampdiff(year, birthday, curdate()) < 30 then '20대'
				 when timestampdiff(year, birthday, curdate()) < 40 then '30대'
				 when timestampdiff(year, birthday, curdate()) < 50 then '40대'
				 when timestampdiff(year, birthday, curdate()) < 60 then '50대'
				 else '60대 이상' 
			end `ageband`,
			case when s.mem_no is null then 'N'
				 else 'Y'
			end `order_yn`,
			row_number() over (partition by c.mem_no order by c.mem_no asc) `rank`
		from customer c 
		left outer join sales s 
			on c.mem_no = s.mem_no) a
	where `rank` = 1
)
;

select 
	*
from customer_profile
limit 0, 100
;

/* 1. 가입년월별 회원수 */
select 
	join_ym,
    count(mem_no) `number of members`
from customer_profile
group by join_ym
;

/* 2. 성별 평균 연령 / 성별 및 연령대별 회원수 */
describe customer_profile;

select 
	gender,
    round(avg(age), 0) `avg_age`
from customer_profile
group by gender
;

select 
	gender,
    ageband,
    count(mem_no) `number_of_member`
from customer_profile
group by
	gender,
    ageband
order by 
	ageband,
    gender
;
    
/* 3. 성별 및 연령대별 회원수(+구매여부) */
select
	gender,
    ageband,
    order_yn,
    count(mem_no) `number_of_member`
from customer_profile
group by
	gender,
    ageband,
    order_yn
order by
	ageband,
    gender,
    order_yn
;
    