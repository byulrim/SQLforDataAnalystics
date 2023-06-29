use practice;


/*
	product_code,category,type,brand,product_name,price
    1,electronic,camera,sony,sony new alpha,880000
*/
create table product (
	product_code 		int,
    category			varchar(50),
    type				varchar(50),
    brand				varchar(50),
    product_name		varchar(100),
    price				int,
    primary key(product_code)
);


load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Product.csv'
	into table product
    fields terminated by ','
    lines terminated by '\n'
    ignore 1 rows
;

describe product;

select 
	*
from product
limit 0, 100;

/*
	order_no,mem_no,order_date,product_code,sales_qty
	1,1000970,2019-05-02,505,2
*/
create table sales (
	order_no		int,
    mem_no			int,
    order_date		date,
    product_code	int,
    sales_qty		int,
    primary key(order_no)
);

-- create unique index ix_sales on sales(mem_no, product_code, order_date);

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\Sales.csv'
	into table sales
    fields terminated by ','
    lines terminated by '\n'
    ignore 1 rows
;

select 
	* 
from sales
limit 0, 100;

select 
	count(mem_no)
from customer;

select
	c.mem_no,
    s.order_date,
    count(c.mem_no)
from customer c 
inner join sales s
on c.mem_no = s.mem_no
group by c.mem_no, s.order_date
order by c.mem_no;

select 
	*
from sales
where mem_no = 1000005
	and order_date = '2019-10-04';
    
select 
	*
from sales s
inner join product p
on s.product_code = p.product_code
where s.mem_no = 1000005
	and s.order_date = '2019-10-04';
    
select 
	*
from customer as c
inner join sales as s
	on c.mem_no = s.mem_no
where c.mem_no = 1000005;

select 
	*
from customer c
left outer join sales s
	on c.mem_no = s.mem_no
where s.mem_no is null
limit 0, 1500
;

select 
	count(c.mem_no) as mem_no
from customer c
inner join sales s
	on c.mem_no = s.mem_no
;

select 
	*
from customer c
right outer join sales s 
	on c.mem_no = s.mem_no
where c.mem_no is null
;

select 
	*
from sales s
left outer join customer c
	on s.mem_no = c.mem_no
where c.mem_no is null
;

select 
	*
from customer c 
inner join sales s 
	on c.mem_no = s.mem_no
;

create temporary table customer_sales_inner_join
select
	c.*,
    s.order_date
from customer c 
inner join sales s 
	on c.mem_no = s.mem_no
;

select 
	*
from customer_sales_inner_join
;

select 
	*
from customer_sales_inner_join
where gender = 'man'
;

select 
	addr,
    count(mem_no) as `구매횟수`
from customer_sales_inner_join
where gender = 'man'
group by addr
;

select 
	addr,
    count(mem_no) as `구매횟수`
from customer_sales_inner_join
where gender = 'man'
group by addr
	having `구매횟수` < 100
;

select 
	addr,
    count(mem_no) as `구매횟수`
from customer_sales_inner_join
where gender = 'man'
group by addr
	having `구매횟수` < 100
order by `구매횟수` asc
;

select 
	*
from customer c 
left outer join sales s 
	on c.mem_no = s.mem_no
left outer join product p 
	on s.product_code = p.product_code
where p.product_code is null
;

select 
	*
from customer c 
inner join sales s 
	on c.mem_no = s.mem_no 
inner join product p 
	on s.product_code = p.product_code 
;

describe sales;

create index ix_sales
	on sales(mem_no, order_date, product_code);

/*    
alter table sales
	add constraint fk_customer_mem_no foreign key (mem_no) references customer(mem_no);
*/
    
alter table sales
	add constraint fk_sales_mem_no foreign key (product_code) references product(product_code);
    
