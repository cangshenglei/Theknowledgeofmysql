
show tables;
select * from stu;
create table stu(id int,name varchar(64));
insert into stu values (1,'王小二');

show tables;
create table t1(id int,name varchar(10));

insert into t1 values(1, 'A');
insert into t1 values(2, 'B');
insert into t1 values(2, 'b');
insert into t1 values(3, 'C');
insert into t1 values(4, 'D');
insert into t1 values(5,5);
insert into t1 values(5,6);
insert into t1 values(5);
insert into t1 values(5,"知乎");
insert into t1 values(5,'');
insert into t1 values(6,'');
insert into t1 (id) values(7);
insert into t1 (id) values(7);
insert into t1 (id) values(8);

create table t2(id int,name varchar(10));

insert into t2 values(1, 'A'),(2, 'B'),(3, 'C'),(4, 'D'),(4,'d');
insert into t2 values(5,'');
insert into t2(id) values(6);
insert into t2(name)values('b');
insert into t2(id) values(7);

select * from t1;

select * from t2;

select id ,now() from t1;

select t1.id ,t2.id from t1 inner join t2 on t1.id=t2.id;

select * from t1 inner join t2 on t1.id=t2.id;

#mysql的varchar的值中不区分大小写
#null值也不是空值
select * from t1 inner join t2 on t1.name=t2.name;
#join on的条件中可以看出,对于空字符串我们是当作值来出处理,但是对于null则当作未知,不予处理

select * from t2;
select id from t2;
select id ,name ,count(*) from t2;
select id ,name,count(id) from t2;
select id ,name ,count(name) from t2;
select distinct id,name from t2;

select * from t1;
select distinct id,name from t1;
#distinct关键字对于空字符串与null值都会起作用,要是单独使用不能直接放中间得放在首部
select distinct(name) from t1;
select distinct(id) from t2;

select id ,count(id) from t1;
select id ,count(name) from t1; #返回10,证明了count关键字处理单独的列的时候,过滤null
select id ,count(*) from t1;
select id ,count(1) from t1;#1,*返回的值都是13,整体的时候不考虑过滤null

select id,name,count(distinct(name)) from t1;

select id,count(distinct(name)) from t1;

#这样可以看到每个分组中有多少条数据
select id,name,count(*) from t2 group by (id);

select id,name,count(*) from t1 group by (id);

select id,name,count(*) from t1 group by (name);

#看来hive中的group by与mysql中的groupby的具体使用不一样
select id,name,count(1) as num from t1 group by id;

#引入ifnull函数,UUID的概念来,对于groupby时候出现的null值不做并组的处理
select id,name,count(*) from t1 group by ifnull(name,UUID());



select * from t1 inner join t2 on t1.id=t2.id and t1.name=t2.name


#   select * from t1 minus select * from t2;  minus函数可能不在mysql中存在

#join的时候,null值的时候,关联不上,所以在这条语句的情况下,exist下的底表关联不到null的数据
select * from t1 where not exists(
        select *
        from t2
        where t1.id = t2.id
          and t1.name = t2.name
    );

create table t3 (id int,num int);

select * from t3;

#填充进表的数据证明了,在mysql中的查询出来的中间表就是一行,然后插入数据进去表
insert into t3(select id ,count(id) from t1);

create table tmp1 (id int ,name varchar(10));
select * from t1 limit 5;
#limit限制了展示的数量,然后成为了中间表,数据的数量就是limit后展示出的数据量,填入表
insert into tmp1(select * from t1 limit 5 );
select * from tmp1;

select t1.name from t1;

create table t5(id int,name varchar(10),time timestamp);
create table t6(id int,name varchar(10),time time);
create table t7(id int,name varchar(10),time date);
insert into t5(select id,name,now() from t1);
insert into t6(select id,name,now() from t1);
insert into t7(select id,name,now() from t1);
select * from t5;
select * from t6;
select * from t7;

#not null将填充字段的默认值
alter table t5 add context_time int not null ;
alter table t5 modify context_time int not null ;
select now(),unix_timestamp();
#报错data truncation ,incorrect,判断为转化的时候字段的属性冲突
update t5 set t5.context_time=unix_timestamp(t5.time);

alter table t5  add store int;

select * from tmp2;
create table tmp2(store int);
insert into tmp2 values(1),(2),(3),(4),(5);
#inner join关联表,将匹配到的字段的值,然后使用set将值更新
update t5 inner join(select id,name from t1)tmp on t5.name=tmp.name  set t5.store=tmp.id;

select * from t5;

#insert数据的时候,没有确定别的字段的值,就不会自动匹配添加,只会在原有的表的数据下添加新的行,原来的字段的值为默认值

select * from t1;
#concat合并字段值,null值与别的值合并将会成为null
select concat(id,name) from t1;

#group_concat函数,多行转一列
select id ,name ,  group_concat(id) from t1;

select group_concat(
    distinct name
    order by name
           )as ziduan from t1;

select group_concat( name
           )as zidaun from t1;

select group_concat( distinct name
           )as zidaun from t1;

select group_concat( distinct name
    order by name
    separator '~'
           )as ziduan from t1;

select group_concat(name
    separator '_'
           )as ziduan from t1;

 select distinct(name) from t1;
#order by排序,第一个是null的值,第二个是空字符串,大写在小写的前面
select name from t1 order by name;
select name ,group_concat(name )as pingjie from t1 ;
#group_concat,还有count的函数,都仅返回一行,那么别的字段的查询也是一行
select group_concat(name,'~' )as pingjie from t1 ;
#默认值是,separator的默认分隔符是 [,]  ,要是在后面的参数添加上分隔符,如果是直接'[参数]'是在原来的基础上添加上分隔符,添加上separator,然后再选择'[参数]'
#要是在group_concat后面的参数可选的有distinct,order by,separator
select name ,group_concat(name )as pingjie from t1 group by name;
#group by分组,去重
select name ,group_concat(name )as pingjie from t1 group by name;

select name ,group_concat(name ,separator '|')as pingjie from t1;

select name,group_concat(name,'-') from t1 group by name;

#select id ,name from t1 where id in group_concat(name);

create table tmp_id(
    id int comment '扩容n'
);
select * from tmp_id;

create procedure insertValue()
begin
    declare i int default 1;
    while (i<=100) DO
        insert into tmp_id(id) values (i);
        set i=i+1;
        end while;
end;
call insertValue();

#mysql中没有split函数
create table tmp_id_arr as
    select id,split('1,2,3,4,5,6,7,8,9,10',',')as num_arr
from tmp_id;

select id ,name ,char_length(name),char_length(id)from t1;
select id ,name ,char_length(name) as length,char_length(id)from t1 order by length asc;
select id ,name ,char_length(name) as length,char_length(id)from t1 order by length desc;

select * from t1;
#定位的函数
select id ,locate('乎',name) from t1;
select id,instr(name,'乎') from t1;
select position('乎' in name) from t1;

#mysql中的是否区分大小写是可以选择的
update t1 set name=replace(name,'A','b') where id =1;
#replace函数也能去除空格

#group by也对空字符串与null生效,分组
select id,name,count(1) from t1 group by name;

select now(3) ;

select null;

#与唯一索引的情况搭配使用
insert ignore into t1
values (1,'b');

#select ... for update
#on duplicate key update

desc t1;
show index from `t1`;
show create table t1;

show processlist;

insert into t1(id,name)values(1,'A') on duplicate key update name='A',id=1;

select * from t1;

#mysqldump工具

#今日的综合知识点,dinstinct



explain select * from t1 where id =1 ;

show tables;

desc t2;

select * from t1;
select * from t2;

#这个逻辑有点绕,主要是表现在谁作为源表,count出的id的数目为零的那条数目就证明了该数据是本表独有的,其实这个子查询里面应该偷偷分组了
 select * from t2 where(select count(1) from t1 where t1.id = t2.id) =4;

select * from t1 where (select count(1) from t2 where t2.id=t1.id)=0;

select * from t1 where not exists(select 1 from t2 where t1.id=t2.id);

select 1 from t1;


#当我们对string类型的数据不加引号的时候将会遍历整张表,当然前提是这个字段是索引

select * from t1;
insert into t1(id,name)values(9,1);
insert into t1(id,name)values(9,1);
insert into t2(id,name)values(1,'A');
desc t1;
explain select * from t1 where name="知乎";
explain select * from t1 where name= 1;
explain select * from t1 where name= "1";

select distinct id,name from t2;
#在union去重的时候,参与union的表中的数据也会被去重,然后这个时候string类型的数据大小写不区分
select id ,name from t1
union select id ,name from t2
order by id;

#desc一次对一个字段生效
select id ,name from  t1
order by id ,name desc;

select id ,name from  t1
order by id desc,name desc;

select id ,name from  t1
order by id desc,name ;

#在mysql中varcahr类型的字段不区分大小写,处理的时候当作一样的
select distinct id,name from t1;
select id,name from t1 group by name;


select year(now());
select month(now());



