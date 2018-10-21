
exec tSQLt.NewTestClass 'tSQLt_Helpers';
go


create procedure [tSQLt_Helpers].Run 
	@testSchema nvarchar(222) = null
	, @testNum int = null
as
begin
	-- Description
	-- ===========
	--
	--    Helper method to allow us to run a specific test number (@testNum = 99) or all
	--    tests in a given schema.
	--
	--    If you have a file with 50+ tests in it, but you're debugging one particular scenario, it's 
	--    useful to be able to just concerntrate on the scenario you're interested in.
	--
	-- WARNING:
	-- ========
	--
	--    If you check in a file with a specific test number at the bottom of the file, any automation
	--    testing you run won't be running all your scenarios.
	--  
	--    To counter this it is recommended your CI environment searches for a hard-coded test number
	--    (personally I tend to copy all my tests into the one file to run my CI tests and in the batch file
	--    that calls "sqlcmd" looks for the scenario and exits with an error into the CI pipeline when it's detected).
	--
	declare @DEBUG bit = 0;

	if @testSchema is null and @testNum is null
	begin
		if @DEBUG = 1 Print 'TEST RUNNER: RunAll ';
		exec tSQLt.RunAll
		return 0;
	end
	if @testSchema is not null and @testNum is null
	begin
		if @DEBUG = 1 Print 'TEST RUNNER: RunSchema ' + @testSchema
		exec tSQLt.Run @testSchema
		return 0;
	end

	declare @foundTestName nvarchar(512) = null;
	declare @testNumString nvarchar(512) = convert(nvarchar(10), @testNum);
	declare @numTestsFound int = null;

	-- Are there multiple tests with the same test number?
	select @numTestsFound = count(1)
	from   INFORMATION_SCHEMA.ROUTINES procs
	where  procs.ROUTINE_SCHEMA = @testSchema
	and
	(
	     ROUTINE_NAME like 'Test #' + @testNumString + ')%'
		or ROUTINE_NAME like 'Test #%0' + @testNumString + ')%'
		or ROUTINE_NAME like 'Test #%00' + @testNumString + ')%'
		or ROUTINE_NAME like 'Test #%000' + @testNumString + ')%'
	)

	if @numTestsFound > 1
	begin
		raiserror('Multiple tests with id "%d" were found.', 16, 1, @testNum)
		return 1;
	end
	if @numTestsFound = 0
	begin
		raiserror ('Could not find test number %d.', 16, 1, @testNum);
		return 2;
	end

	-- Look for an exact match
	select top 1 @foundTestName = ROUTINE_NAME
	from   INFORMATION_SCHEMA.ROUTINES procs
	where  procs.ROUTINE_SCHEMA = @testSchema
	and    ROUTINE_NAME like 'Test #' + @testNumString + ')%';

	if @foundTestName is null
	begin
		-- No exact match, so find any tests with a zero prefix
		select top 1 @foundTestName = ROUTINE_NAME
		from   INFORMATION_SCHEMA.ROUTINES procs
		where  procs.ROUTINE_SCHEMA = @testSchema
		and 
		(
				 ROUTINE_NAME like 'Test #%0' + @testNumString + ')%'
			or ROUTINE_NAME like 'Test #%00' + @testNumString + ')%'
			or ROUTINE_NAME like 'Test #%000' + @testNumString + ')%'
		)
	end

	-- Execute the found test
	declare @testRunner nvarchar(512) = QuoteName(@testSchema) + '.' + QuoteName(@foundTestName);
	if @DEBUG = 1 Print 'TEST RUNNER:' +  @testRunner
	exec tSQLt.Run @testRunner
end
go


-- Unit tests used for testing the runner
exec tSQLt.NewTestClass 'Numerical_Runner_Tests';
go

create procedure [Numerical_Runner_Tests].[Test #01) - test 01]
as
begin
	Print 'Test #01';
end
go

create procedure [Numerical_Runner_Tests].[Test #011) - test 011]
as
begin
	Print 'Test #011';	
end
go


create procedure [Numerical_Runner_Tests].[Test #2) - test 2]
as
begin
	Print 'Test #2';	
end
go

create procedure [Numerical_Runner_Tests].[Test #02) - test 02]
as
begin
	Print 'Test #02';	
end
go

create procedure [Numerical_Runner_Tests].[Test #111) - test 111]
as
begin
	Print 'Test #111';	
end
go


-- Unit tests for the runner
exec tSQLt.NewTestClass 'tSQLt_Helpers_Tests_Run_Tests';
go

create procedure [tSQLt_Helpers_Tests_Run_Tests].[Test - When tSQLt_Helpers.Run is called with no parameters RunAll is also called with no parameters]
as
begin
	exec tSQLt.SpyProcedure 'tSQLt.RunAll';
	
	exec tSQLt_Helpers.Run null, null;

	if not exists(select 1 from tSQLt.RunAll_SpyProcedureLog)
	begin
		exec tSQLt.Fail 'RunAll log was empty';
	end
end
go

create procedure [tSQLt_Helpers_Tests_Run_Tests].[Test - When tSQLt_Helpers.Run is called with schema parameters RunAll is also called schema parameters]
as
begin
	exec tSQLt.SpyProcedure 'tSQLt.Run';
	
	exec tSQLt_Helpers.Run 'Numerical_Runner_Tests', null;

	if not exists(select 1 from tSQLt.Run_SpyProcedureLog where TestName = 'Numerical_Runner_Tests')
	begin
		exec tSQLt.Fail 'RunAll log was empty';
	end
end
go

create procedure [tSQLt_Helpers_Tests_Run_Tests].[Test - When tSQLt_Helpers.Run is called with "1", test "#01" is executed]
as
begin
	exec tSQLt.SpyProcedure 'tSQLt.Run';
	exec tSQLt.SpyProcedure 'tSQLt.RunAll';
	
	exec tSQLt_Helpers.Run 'Numerical_Runner_Tests', 1;

	if not exists(select 1 from tSQLt.Run_SpyProcedureLog where TestName = '[Numerical_Runner_Tests].[Test #01) - test 01]')
	begin
		exec tSQLt.Fail 'RunAll log was empty';
	end
end
go

create procedure [tSQLt_Helpers_Tests_Run_Tests].[Test - When tSQLt_Helpers.Run is called with "11", test "11" is executed]
as
begin
	exec tSQLt.SpyProcedure 'tSQLt.Run';
	exec tSQLt.SpyProcedure 'tSQLt.RunAll';
	
	exec tSQLt_Helpers.Run 'Numerical_Runner_Tests', 11;

	if not exists(select 1 from tSQLt.Run_SpyProcedureLog where TestName = '[Numerical_Runner_Tests].[Test #011) - test 011]')
	begin
		exec tSQLt.Fail 'RunAll log was empty';
	end
end
go

create procedure [tSQLt_Helpers_Tests_Run_Tests].[Test - When tSQLt_Helpers.Run is called with "2", multiple tests error is raised]
as
begin
	exec tSQLt.SpyProcedure 'tSQLt.Run';
	exec tSQLt.SpyProcedure 'tSQLt.RunAll';

	exec tSQLt.ExpectException 'Multiple tests with id "2" were found.';
	
	exec tSQLt_Helpers.Run 'Numerical_Runner_Tests', 2;
end
go

create procedure [tSQLt_Helpers_Tests_Run_Tests].[Test - When tSQLt_Helpers.Run is called with a non-existent test number, an error is generated]
as
begin
	exec tSQLt.SpyProcedure 'tSQLt.Run';
	exec tSQLt.SpyProcedure 'tSQLt.RunAll';

	exec tSQLt.ExpectException 'Could not find test number 1234567890.';
	
	exec tSQLt_Helpers.Run 'Numerical_Runner_Tests', 1234567890;
end
go


exec tSQLt.Run '[tSQLt_Helpers_Tests_Run_Tests]';
go


exec tSQLt.DropClass 'Numerical_Runner_Tests';
go

exec tSQLt.DropClass 'tSQLt_Helpers_Tests_Run_Tests';
go

