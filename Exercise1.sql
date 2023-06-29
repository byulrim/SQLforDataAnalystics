use practice;

/*
	mem_no,gender,birthday,addr,join_date
*/
create table if not exists customer (
	mem_no			int,
    gender			varchar(10),
    birthday		date,
    addr			varchar(100),
    join_date		date,
    primary key(mem_no)
);

-- describe customer;

load data infile 'C://ProgramData//MySQL//MySQL Server 8.0//Uploads//Customer.csv'
	into table practice.customer
    fields terminated by ','
    lines terminated by '\n'
    ignore 1 rows;
    
show global variables like '%secure%';

select 
	count(mem_no)
from customer;

select 
	*
from customer
limit 0, 100;

select 
	count(*)
from customer
where mem_no is not null
	and gender is not null
    and birthday is not null
    and addr is not null
    and join_date is not null;
    
show warnings limit 10;

-- drop table if exists customer;

select 
	*
from customer;

select 
	*
from customer
where gender = 'man';

select 
	addr,
    count(mem_no) as '회원수'
from customer
where gender = 'man'
group by addr;

select
	addr,
	count(mem_no) as '회원수'
from customer
where gender = 'man'
group by addr
having count(mem_no) < 100;

select
	addr,
    count(mem_no) as '회원수'
from customer
where gender = 'man'
group by addr
	having 회원수 < 100
order by 회원수 desc;

select
	addr,
    count(mem_no) as `회원수`
from customer
-- where gender = 'man'
group by addr;

select 
	addr,
    gender,
    count(mem_no) as `회원수`
from customer
where addr in ('seoul', 'incheon')
group by addr, gender
order by addr, gender asc;
