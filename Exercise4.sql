use practice;

select 
	s.*,
    p.price,
    s.sales_qty * p.price `total_price`
from product p 
left outer join sales s 
	on p.product_code = s.product_code
;


create or replace view sales_product as
	select 
		s.*,
		p.price,
		s.sales_qty * p.price `total_price`
	from product p 
	left outer join sales s 
		on p.product_code = s.product_code
;

select 
	*
from sales_product
;

create or replace view sales_product as 
	select 
		s.*,
		p.price,
		s.sales_qty * p.price * 1.1 `total_price_include_vat`
	from product p 
	left outer join sales s 
		on p.product_code = s.product_code
;

drop view sales_product;

delimiter //
create procedure cst_gen_addr_in(in input_a  varchar(20), input_b varchar(20))
begin
	select 
		*
	from customer
    where gender = input_a
		and addr = input_b;
end
//
delimiter ;

call cst_gen_addr_in('man', 'seoul');

call cst_gen_addr_in('women', 'incheon');

show create procedure cst_gen_addr_in;

select
	*
from information_schema.routines
where routine_type = 'PROCEDURE'
;

drop procedure cst_gen_addr_in;

delimiter //
create procedure cst_gen_addr_in_cnt_mem_out(in input_a varchar(20), input_b varchar(20), out cnt_mem int)
begin
	select 
		count(mem_no) into cnt_mem
	from customer
    where gender = input_a
		and addr = input_b
    ;
end//
delimiter ;

call cst_gen_addr_in_cnt_mem_out('women', 'incheon', @cnt_mem);

select @cnt_mem;

delimiter //
create procedure csp_in_out_parameter(inout count int)
begin
	set count = count + 10;
end//
delimiter ;

drop procedure csp_in_out_parameter;

set @counter = 1;

call csp_in_out_parameter(@counter);

select @counter;

