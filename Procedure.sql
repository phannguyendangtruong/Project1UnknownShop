-- _______________________________Users_______________________________
-- Procedure lấy danh sách tài khoản
--create proc sp_selectUsers
--as begin  
--    select * from users where isDeleted = 0
--end 
--go
-- Procedure đăng kí/ tạo tài khoản
create proc sp_signUp(
	@username varchar(50), @fullname nvarchar(50), 
	@password varchar(50), @email varchar(100), 
	@imgUrl image, @role nvarchar(15))
as begin
	begin try
		if not exists(select * from users where username = @username)
			begin
				insert into users(username,fullname,password,email,imgUrl,roles) 
				values(@username,@fullname,@password,@email,@imgUrl,@role);
				select 1; -- Thêm thành công
			end;
		else select 0; -- Trùng tài khoản
	end try
	begin catch
		select -1; -- Trùng email
	end catch
end;
go
-- Procedure chỉnh sửa tài khoản
create proc sp_updateUser(
	@fullname nvarchar(50), @password varchar(50), 
	@email varchar(100), @imgUrl image, 
	@role nvarchar(15), @username varchar(50))
as begin
	begin try
		update users set fullname = @fullname, password = @password, email = @email, 
						imgUrl = @imgUrl, roles = @role
		where username = @username;
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end;
go
-- Procedure xóa tài khoản logical
create proc sp_deleteUser(@username varchar(50))
as begin
	begin try
		update users set isDeleted = 1 where username = @username;
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end;
go
-- Procedure đăng nhập
create proc sp_signIn(@username varchar(50), @password nvarchar(50))
as begin
	if exists(select * from users where username = @username and password = @password and isDeleted = 0)
		select * from users where username = @username and password = @password;
	else if exists(select * from users where username = @username)
		select 0; -- Sai mật khẩu
	else select -1; -- Không có tài khoản
end;
go
-- Procedure lấy user tên tài khoản(username)
create proc sp_selectByUserName(@username varchar(50))
as begin
	if exists(select * from users where username = @username)
		select * from users where username = @username
	else select 0;
end
go
-- Procedure lấy danh sách theo vai trò(role)
create proc sp_selectByRole
as begin
	select roles from users group by roles
end
go
-- Procedure phục hồi tài khoản đã bị xóa
create proc sp_restoreUser(@username varchar(50))
as begin
	begin try
		update users set isDeleted = 0 where username = @username;
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end
go
-- Procedure lấy danh sách tài khoàn chưa bị xóa
create proc sp_selectUsers (@roles nvarchar(15) = null)
as begin
	if(@roles is null) select * from users where isDeleted = 0;
	else select * from users where roles = @roles and isDeleted = 0;
end
go
-- Procedure lấy danh sách tài khoàn đã bị xóa
create proc sp_selectUsersDeleted (@roles nvarchar(15) = null)
as begin
	if(@roles is null) select * from users where isDeleted = 1;
	else select * from users where roles = @roles and isDeleted = 1;
end
go
-- _______________________________Product Types_______________________________
-- Procedure lấy danh sách loại sản phẩm
create proc sp_selectProductTypes
as begin  
    select * from productTypes where isDeleted = 0;
end; 
go
-- Procedure lấy danh sách loại sản phẩm đã xóa
create proc sp_selectProductTypesDeleted
as begin  
    select * from productTypes where isDeleted = 1;
end; 
go
-- Procedure thêm loại sản phẩm
create proc sp_insertProductTypes( @description nvarchar(255), @unit nvarchar(20) null)  
as begin 
	begin try 
		insert into productTypes(description,unit) 
		values(@description,@unit);  
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end; 

go
-- Procedure cập nhật thông tin loại sản phẩm
create proc sp_updateProductTypes(  
	@description nvarchar(20), @unit nvarchar(20),
	@id int
)  
as begin  
	begin try
		update productTypes set description = @description, unit = @unit where id =@id;
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end;
go
-- Procedure xóa(logical) loại sản phẩm
create proc sp_deleteProductTypes(@id int)
as begin  
	begin try
		update productTypes set isDeleted =1 where id = @id;
	 	select 1;
	end try
	begin catch
		select 0;
	end catch;
end; 
go
-- _______________________________Product_______________________________
-- Procedure lấy danh sách sản sản phẩm
create proc sp_selectProducts
as begin  
    select * From products where isDeleted = 0;
end; 
go
-- Procedure lấy danh sách sản sản phẩm đã xóa
create proc sp_selectProductsDeleted(@typeId int)
as begin  
	if(@typeId = 0) select * from products where isDeleted = 1;
    select * from products where isDeleted = 1 and typeId = @typeId;
end; 
go
--Procedure lấy danh sách sản phẩm theo typeId
create proc sp_selectProductByTypeId(@typeId int )
as begin  
	if(@typeId =0) select * From products where isDeleted=0;
	else select * From products where isDeleted = 0 and typeId = @typeId;
end;
go
-- Procedure thêm sản phẩm
create proc sp_insertProduct(  
	@name nvarchar(50), @price float ,
	@quantity int, @imgUrl image null,
	@typeId int
)  
as begin  
	begin try
		insert into products(name,price,quantity,imgUrl,typeId) 
		values(@name, @price,@quantity,@imgUrl,@typeId);  
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end;
go
-- Procedure cập nhật sản phẩm
create proc sp_updateProduct(  
	@name nvarchar(50), @price float ,
	@quantity int, @imgUrl image ,
	@typeId int, @id int
)  
as begin 
	begin try 
		update products 
		set name = @name, price = @price, quantity = @quantity, imgUrl =@imgUrl, typeId =@typeId 
		where id = @id;
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end; 
go
-- Procedure xóa(logical) sản phẩm
create proc sp_deleteProduct(@id int)
as begin  
	begin try
		update products set isDeleted =1 where id = @id;
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end; 
go
-- Procedure khôi phục sản phẩm
create proc sp_restoreProducts(@id int)
as begin  
	begin try
		update products set isDeleted = 0 where id =@id;
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end; 
go
-- _______________________________Orders_______________________________
-- Procedure lấy danh sách hóa đơn đã xác nhận
create proc sp_selectOrders
as begin  
    select * from orders where confirm = 1;
end;
go
-- Procedure lấy danh sách hóa đơn đã xác nhận
create proc sp_selectConfirmedOrders
as begin  
    select	od.id, us.fullname, od.phone, od.address, 
			sum(odt.quantity) totalQuantity, od.totalPrice totalPrice
	from orders od
	inner join orderDetails odt on od.id = odt.orderId
	inner join users us on us.id = od.userId
	where od.confirm = 1
	group by od.id, fullname, phone, address, totalPrice 	 
end;
go
-- Procedure lấy danh sách hóa đơn chưa xác nhận
create proc sp_unconfirmedOrders
as begin  
    select	od.id, us.username, od.phone, od.address, 
			sum(odt.quantity) totalQuantity, od.totalPrice totalPrice
	from orders od
	inner join orderDetails odt on od.id = odt.orderId
	inner join users us on us.id = od.userId
	where od.confirm = 0
	group by od.id, username, phone, address, totalPrice 	 
end; 
go
-- Procedure lấy danh sách hóa đơn đã xác nhận tháng nay
create proc sp_confirmedOrdersThisMonth
as
begin
select count(*) as sl from orders where confirm = 1 and month(createdDate) = month(getdate())
end;
go
-- Procedure lấy danh sách hóa đơn chưa xác nhận tháng này
create proc sp_unconfirmedOrdersThisMonth
as
begin
	select count(*) as sl from orders where confirm = 0 and month(createdDate) = month(getdate())
end
go
-- Procedure thêm hóa đơn
create proc sp_insertOrders(  
	@Address nvarchar(255), @Phone varchar(15) ,
	@CreatedDate dateTime, @TotalPrice float,
	@userId int 
)  
as begin
	begin try
		insert into orders(address,phone,createdDate,totalPrice,userId) 
		values(@Address, @Phone,@CreatedDate,@TotalPrice,@userId);
		declare @orderId int = @@identity;
		select @orderId orderId;
	end try
	begin catch
		select 0;
	end catch;
end;
go
-- Procedure xác nhận hóa đơn
create proc sp_confirmOrder(@orderId int)
as begin begin transaction
declare @table table (productId int, name nvarchar(50), quanOrderDetails int, quantityProducts int)
insert into @table
select odt.productId,prt.name, odt.quantity quantityOrderDetails,prt.quantity quantityProducts from orderDetails odt
inner join products prt on prt.id = odt.productId
 where orderId = @orderId;
declare @table1 table ( id int, name nvarchar(50), quantityOrderDetails int, quantityProduct int);
while exists(select * from @table)
	begin
		declare  @name nvarchar(50), @id int ,@quantityOrderDetails int, @quantityProduct int;
		select top 1 @id = productId,@name = name, @quantityOrderDetails = quanOrderDetails,@quantityProduct = quantityProducts from @table;
		if exists(select * from products where quantity !< @quantityOrderDetails and id = @id)
			update products set quantity = quantity - @quantityOrderDetails where id = @id;
		else insert into @table1 values(@id,@name,@quantityOrderDetails,@quantityProduct);
		delete from @table where productId = @id;
	end
	select * from @table1
	if exists(select * from @table1) rollback
	else begin
		update orders set confirm = 1 where id = @orderId
		commit
	end;
end;
go
-- Procedure xác nhận tất cả hóa đơn
create proc sp_confirmAllOrders
as begin
	declare @table table(id int);
	insert into @table select id from orders where confirm = 0;
	while exists(select * from @table)
		begin
			declare @orderId int;
			select top 1 @orderId = id from @table;
			exec sp_confirmOrder @orderId;
			delete from @table where id = @orderId;
		end;
end
go
-- Procedure xóa hóa đơn
create proc sp_deleteOrders(@id int)
as begin  
	begin try
		delete from orderDetails where orderId = @id;
		delete from orders where id = @id;
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end;
go
-- Procedure xóa tất cả hóa đơn
create proc sp_deleteAllUnconfirmOrders
as begin  
	begin try
		delete from orders where confirm = 0;
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end;
go
-- _______________________________OrderDetails_______________________________
-- Procedure danh sách hóa đơn chi tiết
create proc sp_selectOrderDetail
as begin  
    select * from orderDetails;
end;
go
-- Procedure thêm hóa đơn chi tiết
create proc sp_insertOrderDetails(
	@OrderId int, @ProductId int, 
	@Price float, @Quantity int)
as begin
	begin try
		insert into orderDetails
		values(@OrderId, @ProductId, @Price, @Quantity);
		select 1;
	end try
	begin catch
		select 0;
	end catch;
end;
go
create proc sp_selectOrderDetailsByOrderId(@id int)
as begin  
    select p.imgUrl, p.name, o.quantity, o.price from orderDetails o inner join products p on o.productId = p.id
	where orderId = @id;
end; 
go
-- _______________________________Thống Kê_______________________________
-- Procedure thống kê doanh thu
create proc sp_productRevenue(@year int , @month int , @typelId int)
as
begin
	declare @table table(name nvarchar(50), totalprice float, quantity int)
	if (@typelId like 0)
		if(@month like 0 and @year like 0)
			insert into @table 
			select p.name, sum(totalprice)as Revenue, sum(od.quantity)as SL from orders o 
			inner join orderDetails od on od.orderId = o.id
			inner join products p on p.id = od.productId
			group by  name, p.id, createdDate
			order by SL desc
		else if(@month like 0 and @year not like 0)
			insert into @table 
			select p.name, sum(totalprice)as Revenue, sum(od.quantity)as SL from orders o 
			inner join orderDetails od on od.orderId = o.id
			inner join products p on p.id = od.productId
			where year(o.createdDate) = @year
			group by  name, p.id, createdDate
			order by SL desc
		else 
			insert into @table 
			select p.name, sum(totalprice)as Revenue, sum(od.quantity)as SL from orders o 
			inner join orderDetails od on od.orderId = o.id
			inner join products p on p.id = od.productId
			where year(o.createdDate) = @year and month(o.createdDate) = @month
			group by  name, p.id, createdDate
			order by SL desc
	else
		if(@month like 0 and @year like 0)
			insert into @table 
			select p.name, sum(totalprice)as Revenue, sum(od.quantity)as SL from orders o 
			inner join orderDetails od on od.orderId = o.id
			inner join products p on p.id = od.productId
			where p.typeId = @typelId
			group by  name, p.id, createdDate
			order by SL desc
		else if(@month like 0 and @year not like 0)
			insert into @table 
			select p.name, sum(totalprice)as Revenue, sum(od.quantity)as SL from orders o 
			inner join orderDetails od on od.orderId = o.id
			inner join products p on p.id = od.productId
			where year(o.createdDate) = @year and p.typeId = @typelId
			group by  name, p.id, createdDate
			order by SL desc
		else 
			insert into @table 
			select p.name, sum(totalprice)as Revenue, sum(od.quantity)as SL from orders o 
			inner join orderDetails od on od.orderId = o.id
			inner join products p on p.id = od.productId
			where year(o.createdDate) = @year and month(o.createdDate) = @month and p.typeId = @typelId
			group by  name, p.id, createdDate
			order by SL desc
	select name , sum(totalprice) as totalprice, sum(quantity) as quantity from @table group by name
end;
go
-- Procedure thống kê khách hàng thân thiết
create proc sp_loyalCustomers
as
begin
	select fullname ,username ,count(o.id) as purchases 
	from orders o inner join users u on u.id = o.userId
	group by fullname , username 
	order by purchases desc 
end;
go
-- Procedure lấy danh sách sản phẩm bán được
create proc sp_productsSold
as
begin
select count(quantity) as SL from orderdetails od inner join orders o on o.id = od.orderId
where confirm = 1 and month(o.createdDate) = month(getDate())
end;

exec sp_productsSold
go
-- Procedure lấy danh sách sản phẩm bán được
create proc sp_revenueByYear(@year int)
as
begin
	if(@year like 0)
		select  pt.description ,count(p.typeId) as quantity, sum(ord.totalPrice)as Total 
		from orderDetails o inner join products p on o.productId = p.id 
		inner join productTypes pt on pt.id = p.typeId
		inner join orders ord on ord.id = o.orderId
		group by pt.description
	else
		select  pt.description ,count(p.typeId) as quantity, sum(ord.totalPrice)as Total 
		from orderDetails o inner join products p on o.productId = p.id 
		inner join productTypes pt on pt.id = p.typeId
		inner join orders ord on ord.id = o.orderId
		where year(ord.createdDate) = @year
		group by pt.description
end;
go

-- Procedure lấy danh sách sản phẩm bán được
create proc sp_revenueOneMonth(@month int, @year int)
as begin
	declare @result varchar(15);
	set @result = (select sum(o2.price) from orders o1 inner join orderDetails o2 on o1.id = o2.orderId
					where month(o1.createdDate) = @month and year(o1.createdDate) = @year and o1.confirm = 1)
	if(@result is null) set @result = 0;
	select @result result
end;

exec sp_revenue6Month 5, 10


