#primary key 一列或者一组列用来唯一区分表中的每一行  ,主键列不允许null值,
#注意是主键中的所有的列都不能为null,All parts of a PRIMARY KEY must be NOT NULL; if you need NULL in a key, use UNIQUE instead

desc orders;
drop table test;
create table test(
    id int not null auto_increment,
    name char(50) not null,
    city char(50),
    email char(50) null unique ,
    primary key(id ,email)
)engine =innodb;

desc test;

#SQL > structured query language,mysql是dbms的一种,客户机与服务机,
#mysql的默认端口是3306,连接msyql的参数信息,主机名,端口号,用户名

#auto_increment
show columns from customers;
desc customers;
show status ;
show grants;
show errors;
select prod_name from products;
select * from products;

#distinct关键字应用于所有的列,必须在开头出现
select  prod_id, prod_name from products;

#limit后面的两个参数,第一个是从第几行后开始的意思,第二个是需要的行数,offset偏移量的意思
select prod_name from products limit 1,1;
select prod_name from products limit 5 ,5;
select prod_name from products limit 5 offset 5;

#完全限定的意思是,在表名的前面添加上库名,在列名的前面添加上表名, .

#order by默认是升序asc排序,desc只作用于它前面的列名

#mysql在执行匹配的时候默认是不区分大小写的

#where between a and b    is null  is not null

#and 优先级高于 or
#通配符是用来匹配值的一部分的特殊字符
#常见的通配符有:like, % , _ (单个)  通配符的效率很低
#在mysql中仅支持正则表达式的部分,常用的有:regexp,regexp后面的参数可选择的有 . [] | ^  -  \\(仅匹配特殊字符),* + ?  {n}  {n,}  {n,m},^(做文本开头使用),$,[[: [[:>:]]
#存在预定义好的字符集称为字符类

#mysql中常见的函数:concat函数,trim,ltrim,rtrim函数

SELECT prod_name
 FROM products
 WHERE prod_name REGEXP '1000'
 ORDER BY prod_name;

SELECT prod_name
FROM products
WHERE prod_name REGEXP '[[:digit:]]'
ORDER BY prod_name;


select * from products;

select  prod_name,prod_desc,prod_price
from products
where prod_price between 1 and 5
group by vend_id;


select * from vendors;

select concat_ws('0',vend_id,vend_name) as vend_title from vendors;
select concat(trim(vend_id),'0',trim(vend_name)) from vendors;

#mysql中的日期函数,date,datediff,date_add,date_format,day,

explain select cust_id,order_num
from orders
where order_date='20050901';

explain select cust_id,order_num
from orders
where order_date='2005-09-01';

explain select cust_id,order_num
from orders
where order_date=20050901;

select abs(-389);
select cos(34);
select exp();
select pi();
select rand();
select tan(65);
select sin(65);

select * from customers;

select  count(cust_id) ,count(cust_email)from customers
group by cust_id;

#mysql提供的常见的聚合函数avg,count,sum,min,max

#count函数对于具体的字段处理的时候,将过滤null值

#mysql中的max,min函数可以用于任何一列,min函数也会忽略null值
select * from products;

#group by函数后分组的字段不能是聚合函数,不知道现在的mysql的版本能不能支持定义的别名,groupby函数再where之后order by之前


SELECT vend_id, COUNT(*) AS num_prods,prod_name,prod_desc
 FROM products
 GROUP BY  vend_id WITH ROLLUP
order by num_prods desc;
#使用with rollup函数将会统计每个组的值数量
#对于null值的处理函数常见的有 ifnull,coalesce

#where过滤的是行,having过滤的是组
SELECT cust_id, COUNT(*) AS orders
FROM orders
GROUP BY cust_id
HAVING orders >= 2;

select * from orders;
select unix_timestamp(order_date) from orders;

select order_num,unix_timestamp(order_date) as time ,cust_id
from orders
where unix_timestamp(order_date) > 1126454400;

#关于别名,在having中可以使用,但是在where中不能被使用

show tables;
select cust_name,cust_state,(
    select count(*) from orders where orders.cust_id=customers.cust_id
    )
from customers order by cust_name;


#其实join on  与form a,b where 条件   起到的作用是一样的,但是join更推荐使用

#等值连接也被称为内连接

select p1.prod_id,p1.prod_name
from products as p1 ,products as p2
where p1.vend_id=p2.vend_id
and p2.prod_id='Dtntr';

#等值连接,自连接,自然连接,外部连接

SELECT c.*, o.order_num, o.order_date,
 oi.prod_id, oi.quantity, OI.item_price
FROM customers AS c, orders AS o, orderitems AS oi
WHERE c.cust_id = o.cust_id
 AND oi.order_num = o.order_num
 AND prod_id = 'FB';

select c.*, o.order_num, o.order_date,
 oi.prod_id, oi.quantity, OI.item_price
FROM customers AS c
join orders as o on c.cust_id=o.cust_id
join orderitems oi on o.order_num=oi.order_num
where prod_id='FB';

#left join   right join
#其实我们可以将笛卡尔积视为不加where过滤条件的情况,然后出现了全表的连接
#union的注意事项,注意union的的查询字段的个数,类型(可以隐式转化的那种也行)兼容,相同的表达书与聚合函数
#union的去重是从结果集中去重,所以就算是本来的表中有重复的数据也会被它去重,union的作用有点类似于多个where语句(在作用于单表的时候)
#多个union的作用的多个表返回的是一个结果集,所以不会允许多个order by

#关于全文本索引的部分,myisam引擎是支持的,在创建表的时候使用fulltext(字段名,字段名)来实现对于需要被全文本搜索的字段的自动索引
#全文本搜索中常用红的函数有match(字段)--不区分大小写 与against(表达式)

SELECT note_text
FROM productnotes
WHERE match(note_text) Against('load');

SELECT note_text,
 Match(note_text) Against('rabbit')
FROM productnotes;

SELECT note_text
FROM productnotes
WHERE Match(note_text) Against('anvils' WITH QUERY EXPANSION);

SELECT note_text
FROM productnotes
where Match(note_text) against('heavy' in boolean mode);




select * from customers;

INSERT INTO Customers
VALUES(100,
 'Pep E. LaPew',
 '100 Main Street',
 'Los Angeles',
 'CA',
 '90046',
 'USA',
 NULL,
 NULL);

#插入数据的格式有 insert into tablename values(,,,,,,)被填入的字段必须与表中的字段完全一致
#insert into tablename(,,,,,,)values(,,,,,,)可以自己指定相关的字段,在这里被忽视的列必须满足(该列有默认值或者该列可以为null)
#对于插入的values的格式有两种选择,一种是多个values,中间使用;   第二种是一个values多个组值中间使用,
#insert into tablename() select (,,,)from tablename1 无所谓列名,是列的位置对应

#update tablename set column=value  where
#update ignore 将会无视出现的错误,继续操作,不让它回滚

#delete是删除表的内容的,而不是表的结构和字段 , truncate table

#创建表的时候,对于列值给出的默认值是null,要是不能为null得手动设置为no null

show tables;

create table testone(
    id int not null auto_increment,
    name char(60) not null,
    city char(50) null,
    primary key(id)
);
#一般定义为主键的字段是不能为null的,会不会是为null的字段后续插入的值可能与已有的值重复破坏了唯一性
#对于auto_increment的字段必须被指定为索引

select last_insert_id()

#常见的引擎有 innodb,myisam(不支持事务),meomory(基于内存,常用于临时表)     注意:外键不能跨引擎

#alter table  tablename drop | add column xxxx;

alter table orderitems
add constraint fk_orderitems_orders
foreign key (order_num) references orders(order_num);

rename table orderitems to orderitem;

#视图是一个虚拟的表,包含的是一个sql查询出来的结果
#视图与临时表的区别有:视图是不存数据的,是一个sql查询.每次被使用的时候,按照sql去表中查询,所以视图的数据是会变动的,视图用来隐瞒表之间的结构与处理逻辑,视图没索引也没有触发器与默认值
#临时表:确实是一张表,不过是当前会话断开连接之后会被删除

#create view, show create view name, drop view name,create or replace view

create view productcustomers as
    SELECT cust_name, cust_contact, prod_id
FROM customers, orders, orderitem
WHERE customers.cust_id = orders.cust_id
 AND orderitem.order_num = orders.order_num;
select * from productcustomers;
show create view productcustomers;

CREATE VIEW customeremaillistc AS
SELECT cust_id, cust_name, cust_email
FROM customers
WHERE cust_email IS   NULL;
select * from customeremaillistc;
select * from customeremaillistc where cust_email is not null;
#对于视图的where是在视图的基础上的

#视图可以用来更行,但是视图的更新是对基表的更行,限制很多,一般不使用视图进行更新


#存储过程的相关概念,用来依据结果有条件的筛选处理,保存在服务器上

create procedure productpricing()
begin
    select avg(prod_price) as priceaverage
    from products;
end;
call productpricing();

#()内的关键有 in out  into   inout   存储过程在 begin 与 end 之间
create procedure productpricing1(
    out p1 decimal(8,2),
    out p2 decimal(8,2),
    out p3 decimal(8,2)
)
begin
    select min(prod_price)
        into p1
    from products;
    select max(prod_price)
        into p2
    from products;
    select avg(prod_price)
        into p3
    from products;
end;

#使用@来定义变量,然后作为存储过程的返回值

call productpricing1(@low ,@high,@avg);
select @low,@high,@avg;


create procedure ordertotal(
    in onumber int,
    out ototal decimal(8,2)
)begin
    select sum(item_price*quantity)
        from orderitem
            where order_num=onumber
    into ototal;
end;

call ordertotal(20005,@num);
select @num;

#cursor游标 ,执行游标需要先打开再关闭,在mysql中只能用于存储过程和函数中,游标的逐行读取函数fetch()
create procedure processorders()
begin
    declare ordernumbers cursor for
    select order_num from orders;
    open ordernumbers;
    close ordernumbers;
end;
#如果游标读取的数据行有多个列名，则在 INTO 关键字后面赋值给多个变量名即可
#游标的循环取值  repeat  until XXXX end repeat

#在存储过程中定义的顺序得注意,先是定义的变量,然后是游标,然后才是句柄(continue handler)

#mysql中触发器的激活语句有 delete insert  update
#创建触发器相关的内容,触发器名,表名,对应的活动,执行的时机,只有表才支持触发器trigger,临时表不支持

create trigger newproduct after insert on products
for each row select 'you';

#对于触发器的before与after 要根据需求来判断,有的无法实现,例如对于自增的变量使用defore取最新的值
#触发器的选择中insert中有表new(可改动),delete有表OLD(只读),可以视为缓冲区的概念,before触发器执行不成功将直接放弃after
#update的触发器可以读两张表,new与old,可以视为两张表的结合

#事务的相关概念,commit rollback,savepoint,事务将保证成批的mysql要么执行要么不执行
#

select * from orderitem;
start transaction;
delete from orderitem;
select * from orderitem;
rollback ;
select * from orderitem;
#rollback可以生效的是insert,update,delete  不能退回drop create

#在mysql中我们的语句其实都是需要执行提交的流程,但是是自动进行了,这就是隐式提交.但是在事务中需要自己进行提交

#因为数据表的范式理论,在删除记录的时候会要求删除多张表中的相关记录,这种时候设定事务,防止出现删除了一半的情况
start transaction;
delete from orderitem where order_num=20010;
delete from orders where order_num=20010;
commit;
#在这里commit的原理是,有一条失败,直接撤销commit,命令没有向数据服务器提交

#为了支持部分事务的回退,引入占位符的概念,也就是savepoint    rollback to savepointname
#自动隐式提交的命令为autocommit 可以设置为0来关闭


#mysql中的字符集的相关概念有:字符集,编码,校队

show collation;
show character set;

SHOW VARIABLES LIKE 'character%';
SHOW VARIABLES LIKE 'collation%';

#对于字符集的设置可以到列的级别
#default character set 字符集      collate 校队                 order by xxxx collate 校队的格式;

#mysql数据库是基于磁盘的数据库,常见的方式有:mysqldump,mysqlhotcopy,flushtable后backup table,select into outfile
analyze table orders;
check table orders;
show variables;
show status;
show processlist ;

#mysql对于字符串类型的有:varchar,char,enum,longtext,mediumtext,set,text,tinytext
#对于通常的类型 有unsigned可选,会比使用正负号的多出一倍的存储范围  decimal(8,2)
#对于日期类型的有:date,datetime,timestamp,time,year
#mysql中不允许对一个可变的部分进行索引,
select date(now());
select timestamp(now());
select timestamp(now());
select time(now());
select time_format(now(),'%H');
select date_format(now(),'%j');
select date_format(now(),'%X^%c');
select current_time;



