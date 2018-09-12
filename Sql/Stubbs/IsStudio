Print 'dbo.IsStudio'
if not exists(select * from sysobjects where name = N'IsStudio' and type = 'FN')
begin
	exec('create function dbo.IsStudio() returns int begin /* add code here */ return -1 end')
end
go

alter function dbo.IsStudio()
returns bit
begin	
  -- Description:
  -- Simple function to determine a script is being executed in Management Studio
  -- Useful if you want to test something whilst you're developing a script, but want to be sure you don't 
  -- deploy it (of course, this assumes you don't deploy via Management Studio!)
	declare @isStudio bit = 0;

	if (CharIndex('Microsoft SQL Server Management Studio', APP_NAME()) > 0)
	begin
		set @isStudio = 1;
	end

	return @isStudio;
end
go
