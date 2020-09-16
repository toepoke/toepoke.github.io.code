
if exists(select name from sysobjects where name = N'Private_AssertDateEquals' and type = 'P')
begin
	drop procedure tSQLt.Private_AssertDateEquals;
end
go

create procedure tSQLt.Private_AssertDateEquals
	@expectedDateTime datetime2
	, @actualDateTime datetime2
	, @failureMessage varchar(255) = ''
	, @gracePeriodMs int = 300
	, @failMessage varchar(255) output
as
begin
	-- Description
	-- ===========
	--
	--   Time is a difficult beast to test.  If you execute an SP that depends on recording the time part you can guarantee
	--   the time element won't be the same, certainly at millisecond granularity.
	-- 
	--   "AssertDateEquals" provides "grace period" when comparing the "expected" and "actual" DateTime data types.  
	--   This allows the "expected" and "actual" DateTime data types to be a _little_ bit different.
	--
	--   By default the "grace period" is "100" milliseconds, but can be overriden to be shorter or longer.
	--   
	declare @areEqual bit = 0;
	declare @under datetime2 = null;
	declare @over datetime2 = null;
	set @areEqual = 0;
	set @failMessage = null;
	set @under = DateAdd(MILLISECOND, -@gracePeriodMs, @expectedDateTime);
	set @over  = DateAdd(MILLISECOND, +@gracePeriodMs, @expectedDateTime);

	-- Give a few milliseconds grace when checking datetime
	if @actualDateTime between @under and @over
	begin
		set @areEqual = 1;
	end

	-- Can't use FormatMessage #sql2008
	set @failMessage = coalesce(@failureMessage, '') 
		+ '\nExpected: <' 
		+ coalesce(CONVERT(varchar(255), @under, 113), 'NULL') 
		+ '> - <' 
		+ coalesce(CONVERT(varchar(255), @over, 113), 'NULL')
		+ '>\nbut was : <' 
		+ coalesce(CONVERT(varchar(255), @actualDateTime, 113), 'NULL')
		+ '>';
	set @failMessage = Replace(@failMessage, '\n', CHAR(13));

	return @areEqual;
end
go


if exists(select name from sysobjects where name = N'AssertDateEquals' and type = 'P')
begin
	drop procedure tSQLt.AssertDateEquals;
end
go

create procedure tSQLt.AssertDateEquals
	@expectedDateTime datetime2
	, @actualDateTime datetime2
	, @failureMessage varchar(255) = ''
	, @gracePeriodMs int = 100
as
begin
	-- Description
	-- ===========
	--
	--    Tests that the "expected" DateTIme and "actual" DateTime are within the "grace period" of each 
	--    other (and are, in essence, equal).
	--
	declare @areEqual bit = 0;
	declare @failMessage varchar(255) = null;

	exec @areEqual = tSQLt.Private_AssertDateEquals 
		  @expectedDateTime
		, @actualDateTime
		, @failureMessage
		, @gracePeriodMs
		, @failMessage output
	;
	
	if @areEqual = 0
	begin
		exec tSQLt.Fail @failMessage;
	end
end
go


if exists(select name from sysobjects where name = N'AssertDateNotEquals' and type = 'P')
begin
	drop procedure tSQLt.AssertDateNotEquals;
end
go
create procedure tSQLt.AssertDateNotEquals
	@expectedDateTime datetime2
	, @actualDateTime datetime2
	, @failureMessage varchar(255) = ''
	, @gracePeriodMs int = 100
as
begin
	-- Description
	-- ===========
	--
	--    Tests that the "expected" DateTIme and "actual" DateTime are NOT within the "grace period" of each
	--    other.
	--
	declare @areEqual bit = 0;
	declare @failMessage varchar(255) = null;

	exec @areEqual = tSQLt.Private_AssertDateEquals 
		  @expectedDateTime
		, @actualDateTime
		, @failureMessage
		, @gracePeriodMs
		, @failMessage output
	;

	if @areEqual = 1
	begin
		exec tSQLt.Fail @failMessage;
	end
end
go


if exists(select name from sysobjects where name = N'Pass' and type = 'P')
begin
	drop procedure tSQLt.Pass;
end
go

create procedure tSQLt.Pass
	@failureMessage varchar(255) = ''
as
begin
	-- Description
	-- ===========
	--
	--    Provides a convenient way to have a passing test to illustrate coverage of a scenario
	--    that doesn't need test coverage (so you don't come across it in the future and think a test needs adding)
	--
	declare @nop bit = 1;
end
go


-- UNIT TESTS

exec tSQLt.NewTestClass 'tSQLt_Extensions_Tests';
go

create procedure [tSQLt_Extensions_Tests].[Test #01) - AssertDate - should fail when actual date is just outside threshold lower boundary]
as
begin
	declare @actual datetime2 = null;
	declare @expected datetime2 = null;
	
	-- Arrange
	set @actual = CURRENT_TIMESTAMP;
	set @expected = DateAdd(MILLISECOND, -101, @actual);
	
	-- Act
	exec tSQLt.AssertDateNotEquals @expected, @actual, 'Given date was below the threshold';
	
	-- Assert
end
go


create procedure [tSQLt_Extensions_Tests].[Test #02) - AssertDateEquals - should pass when actual date is on threshold lower boundary]
as
begin
	declare @actual datetime2 = null;
	declare @expected datetime2 = null;
	
	-- Arrange
	set @actual = CURRENT_TIMESTAMP;
	set @expected = DateAdd(MILLISECOND, -100, @actual);
	
	-- Act
	exec tSQLt.AssertDateEquals @expected, @actual, 'Given date was below the threshold';
	
	-- Assert
end
go


create procedure [tSQLt_Extensions_Tests].[Test #03) - AssertDateEquals - should pass when actual date is just inside threshold lower boundary]
as
begin
	declare @actual datetime2 = null;
	declare @expected datetime2 = null;
	
	-- Arrange
	set @actual = CURRENT_TIMESTAMP;
	set @expected = DateAdd(MILLISECOND, -99, @actual);
	
	-- Act
	exec tSQLt.AssertDateEquals @expected, @actual;
	
	-- Assert
end
go


create procedure [tSQLt_Extensions_Tests].[Test #04) - AssertDateEquals - should pass when dates are the same]
as
begin
	declare @actual datetime = null;
	declare @expected datetime = null;
	
	-- Arrange
	set @expected = CURRENT_TIMESTAMP;
	set @actual = @expected;
	
	-- Act
	exec tSQLt.AssertDateEquals @expected, @actual;

	-- Assert
end
go


create procedure [tSQLt_Extensions_Tests].[Test #05) - AssertDateEquals - should pass when actual date is just inside threshold upper boundary]
as
begin
	declare @actual datetime2 = null;
	declare @expected datetime2 = null;
	
	-- Arrange
	set @actual = CURRENT_TIMESTAMP;
	set @expected = DateAdd(MILLISECOND, +99, @actual);
	
	-- Act
	exec tSQLt.AssertDateEquals @expected, @actual;
	
	-- Assert
end
go


create procedure [tSQLt_Extensions_Tests].[Test #06) - AssertDateEquals - should pass when actual date is on threshold upper boundary]
as
begin
	declare @actual datetime2 = null;
	declare @expected datetime2 = null;
	
	-- Arrange
	set @actual = CURRENT_TIMESTAMP;
	set @expected = DateAdd(MILLISECOND, +100, @actual);
	
	-- Act
	exec tSQLt.AssertDateEquals @expected, @actual, 'Given date was above the threshold';
	
	-- Assert
end
go


create procedure [tSQLt_Extensions_Tests].[Test #07) - AssertDateEquals - should fail when actual date is on just ouside threshold upper boundary]
as
begin
	declare @actual datetime2 = null;
	declare @expected datetime2 = null;
	
	-- Arrange
	set @actual = CURRENT_TIMESTAMP;
	set @expected = DateAdd(MILLISECOND, +101, @actual);
	
	-- Act
	exec tSQLt.AssertDateNotEquals @expected, @actual, 'Given date was above the threshold';
	
	-- Assert
end
go


create procedure [tSQLt_Extensions_Tests].[Test #08) - AssertDate - should pass when custom grace period is used (under)]
as
begin
	declare @actual datetime2 = null;
	declare @expected datetime2 = null;
	declare @oneSecondGracePeriod smallint = null;
	
	-- Arrange
	set @oneSecondGracePeriod = -1000;
	set @actual = CURRENT_TIMESTAMP;
	set @expected = DateAdd(MILLISECOND, @oneSecondGracePeriod, @actual);
	
	-- Act
	exec tSQLt.AssertDateNotEquals @expected, @actual
		, 'Given date was below the threshold'
	;
	
	-- Assert
end
go


create procedure [tSQLt_Extensions_Tests].[Test #09) - AssertDate - should pass when custom grace period is used (over)]
as
begin
	declare @actual datetime2 = null;
	declare @expected datetime2 = null;
	declare @oneSecondGracePeriod smallint = null;
	
	-- Arrange
	set @oneSecondGracePeriod = 1000;
	set @actual = CURRENT_TIMESTAMP;
	set @expected = DateAdd(MILLISECOND, @oneSecondGracePeriod, @actual);
	
	-- Act
	exec tSQLt.AssertDateNotEquals @expected, @actual
		, 'Given date was below the threshold'
	;
	
	-- Assert
end
go


create procedure [tSQLt_Extensions_Tests].[Test #10) - Pass - should not fail]
as
begin
	-- Arrange

	-- Act
	exec tSQLt.Pass 'No error should be raised.';
	
	-- Assert
end
go


exec tSQLt.Run 'tSQLt_Extensions_Tests';
go

exec tSQLt.DropClass 'tSQLt_Extensions_Tests';
go

