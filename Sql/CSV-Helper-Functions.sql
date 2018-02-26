--
-- DbServer:  n/a - general purpose script
-- DbName:    n/a - general purpose script
--
-- Explanation:
--	Set of functions for delimiting strings into something useful
--	Yes this should probably use tSQLt but I want to keep helpers isolated :-)
--
--  Whilst these are helpful, I wouldn't use them in a query, it won't be very efficient.  Fine for SP use though.
--
-- References:
--  - None

Print 'GetCsvStringAsTable'
if not exists(select 1 from sysobjects where name = N'GetCsvStringAsTable' and type = 'TF')
begin
	exec('create function dbo.GetCsvStringAsTable() returns @values table(ndx int) begin /*add code here*/ return end')
end
go
	alter function dbo.GetCsvStringAsTable
	(
		-- Path to the file to create a table name from 
		@csv nvarchar(max)
		, @delimiter VARCHAR(8000) = ','
	)
	returns @values table 
	(
		ndx int
		, item varchar(8000)
	)
	begin	
			declare @currItem varchar(8000)
			declare @itemNdx int

			select @itemNdx = 1
			while CHARINDEX(@delimiter,@csv,0) <> 0
			begin

				select
					@currItem=rtrim(ltrim(substring(@csv,1,charindex(@delimiter,@csv,0)-1))),
					@csv=rtrim(ltrim(substring(@csv,charindex(@delimiter,@csv,0)+len(@delimiter),len(@csv))))
 
				if len(@currItem) > 0 
				begin
					insert into @values 
						select @itemNdx, @currItem
				end

				set @itemNdx = @itemNdx + 1
			end -- while

			if len(@csv) > 0 
			begin
				insert into @values 
					select @itemNdx, @csv -- Put the last item in
			end

			return 
	end
	go
	select 'GetCsvStringAsTable', * from [dbo].GetCsvStringAsTable('a,b,c', ',')
	go


Print 'GetCsvStringCount'
if not exists(select 1 from sysobjects where name = N'GetCsvStringCount' and type = 'FN')
begin
	exec('create function dbo.GetCsvStringCount() returns int begin /* add code here */ return -1 end')
end
go
	alter function dbo.GetCsvStringCount
	(
		-- Path to the file to create a table name from 
		@csv nvarchar(max)
	)
	returns int
	begin	
		declare @count int

		select @count = count(1) from [dbo].[GetCsvStringAsTable](@csv, ',')

		return @count
	end
	go
	select 'GetCsvStringCount', [dbo].GetCsvStringCount('a,b,c') NumberOfItemsInCSVString
	go



Print 'GetCsvStringItemAt'
if not exists(select 1 from sysobjects where name = N'GetCsvStringItemAt' and type = 'FN')
begin
	exec('create function dbo.GetCsvStringItemAt() returns nvarchar(4000) begin /*add code here*/ return '''' end')
end
go
	alter function dbo.GetCsvStringItemAt
	(
		-- Path to the file to create a table name from 
		@csv nvarchar(max)
		, @itemAt int
	)
	returns nvarchar(4000)
	begin
		declare @foundItem nvarchar(4000)

		select @foundItem = item 
		from [dbo].[GetCsvStringAsTable](@csv, ',')
		where ndx = @itemAt

		return @foundItem
	end
	go
	select 'GetCsvStringItemAt', [dbo].GetCsvStringItemAt('a,b,c', 2) ItemAtPosition2
	go

-- And tidy up
drop function dbo.GetCsvStringAsTable
drop function dbo.GetCsvStringCount
drop function dbo.GetCsvStringItemAt
go
