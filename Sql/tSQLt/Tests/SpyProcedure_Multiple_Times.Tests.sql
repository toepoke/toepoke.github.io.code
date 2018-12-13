exec tSQLt.NewTestClass 'SpyProcedure_Multiple_Times_Tests';
go

create procedure SpyProcedure_Multiple_Times_Tests.CheckStatus
as
begin
	-- It doesn't really matter what this returns as we want to mock it out
	return -1;
end
go

create procedure SpyProcedure_Multiple_Times_Tests.ProcedureUnderTest
as
begin
	declare @retVal int = null;

	-- #1 - First call we want to pass as it tests something else
	exec @retVal = SpyProcedure_Multiple_Times_Tests.CheckStatus
	if @retVal > 0
	begin
		throw 50000, 'Error: #1', 1;
	end
	
	-- #2 - Second call we want to fail
	exec @retVal = SpyProcedure_Multiple_Times_Tests.CheckStatus
	if @retVal > 0
	begin
		throw 50001, 'Error: #2', 1;
	end
	
end
go

create procedure [SpyProcedure_Multiple_Times_Tests].[Test #01) - 2 + 2 does indeed equal 4]
as
begin
	-- Arrange
	create table #hack (Col1 bit);
	exec tSQLt.SpyProcedure 'SpyProcedure_Multiple_Times_Tests.CheckStatus', '
		if not exists(select 1 from #hack)
		begin
			insert into #hack (Col1) select 1;
			-- Force first call to CheckStatus to pass
			return -1;
		end
		else
		begin
			-- Force second call to CheckStatus to fail :-)
			return 1;
		end
';


	-- Act
	exec tSQLt.ExpectException 'Error: #2';
	exec SpyProcedure_Multiple_Times_Tests.ProcedureUnderTest

	-- Assert
	-- ExpectException
end
go

exec tSQLt_Helpers.Run 'SpyProcedure_Multiple_Times_Tests', 1;
go

exec tSQLt.DropClass 'SpyProcedure_Multiple_Times_Tests';
go

