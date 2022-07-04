-- 1. Create a view named “view_product_order_[your_last_name]”, list all products and total ordered quantity for that product.
create view [view_product_order_tsoogii] as
select p.productname, sum(od.quantity) [total quantity ordered ever] from products as p
join [Order Details] as [od] on p.productid = od.ProductID
group by p.ProductName
go

-- 2. Create a stored procedure “sp_product_order_quantity_[your_last_name]” that accept product id as an input and total quantities of order as output parameter.

create PROCEDURE sp_product_order_quantity_tsoogii
    @productID int,
    @quantity_ordered int OUTPUT
AS
select @quantity_ordered = sum(quantity)
from [Order Details]
where productid = @productID

declare @outputvar int
exec sp_product_order_quantity_tsoogii @productID = 60, @quantity_ordered = @outputvar output
print(@outputvar)
go

-- 3. Create a stored procedure “sp_product_order_city_[your_last_name]” that accept product name as an input and top 5 cities that ordered most that product combined with the total quantity of that product ordered from that city as output.
create PROCEDURE sp_product_order_city_tsoogii
@pName NVARCHAR
as
begin
    select o.shipcity, p.ProductName, sum(od.quantity) [total quantity ordered] from orders as o
    join [Order Details] as od on o.OrderID = od.OrderID
    join products as p on od.ProductID = p.ProductID
    where p.ProductName = @pName
    group by o.shipcity, p.ProductName
    order by sum(od.Quantity)
end
declare @prname NVARCHAR = 'Chai'
exec sp_product_order_city_tsoogii @pName = @prname

drop PROCEDURE sp_product_order_city_tsoogii
go

-- 4. Create 2 new tables “people_your_last_name” “city_your_last_name”. City table has two records: {Id:1, City: Seattle}, {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city “Madison”. Create a view “Packers_your_name” lists all people from Green Bay. If any error occurred, no changes should be made to DB. (after test) Drop both tables and view.
create table people_your_tsoogii (
    id INT,
    Name VARCHAR(30),
    City INT
)

create table city_your_tsoogii (
    id int,
    city VARCHAR(30)
)

insert into people_your_tsoogii
values
(1, 'Aaron Rodgers', 2),
(2, 'Russell  Wilson', 1),
(3, 'Jody Nelson', 2)

insert into city_your_tsoogii
VALUES
(1, 'Seattle'),
(2, 'Green Bay')

delete from city_your_tsoogii where city = 'Seattle'
select * from city_your_tsoogii

insert into city_your_tsoogii
values
(1, 'Madison')
go
-- no need to update people_your_tsoogii given that madison has the same id as seattle

create view [packers_tsoogii] as
select name from people_your_tsoogii as p
join city_your_tsoogii as c on p.city = c.id
where c.city = 'Green Bay'
go
select * from packers_tsoogii

drop table people_your_tsoogii
drop table city_your_tsoogii
go

select * from packers_tsoogii
go
-- 5. Create a stored procedure “sp_birthday_employees_[you_last_name]” that creates a new table “birthday_employees_your_last_name” and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
create PROCEDURE sp_birthday_employees_tsoogii
AS
if (exists (select * from INFORMATION_SCHEMA.TABLES
where table_schema = 'dbo' and table_name = 'employees_born_in_feb'))
BEGIN
    drop table employees_born_in_feb
END
create table employees_born_in_feb(
    name varchar(30)
)
insert into employees_born_in_feb
select firstname + ' ' + lastname from Employees
where month(BirthDate) = 2

exec sp_birthday_employees_tsoogii

select * from employees_born_in_feb
go

-- 6. How do you make sure two tables have the same data?

-- use the checksum table function to ensure that the two tables have the same checksum value.