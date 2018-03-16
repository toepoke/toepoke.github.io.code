--
-- DbServer:  n/a - general purpose script
-- DbName:    n/a - general purpose script
--
-- Explanation:
--    Why "User Defined Functions" (UDF) can be bad.
-- 
--    *** MAKES MORE SENSE TO HIGHLIGHT EACH Arrange/Act/Assert SECTION AND RUN IN ISOLATION ***
-- 
-- References:
--  - https://sqlserverfast.com/blog/hugo/2012/05/t-sql-user-defined-functions-the-good-the-bad-and-the-ugly-part-1/
--

-- 1)  Illustration of the problem

-- ARRANGE
	CREATE TABLE #LargeTable
	(
		KeyVal int NOT NULL PRIMARY KEY,
		DataVal int NOT NULL 
			CHECK 
			(
				DataVal BETWEEN 1 AND 10
			)
	);

	WITH Digits
	AS 
	(
		SELECT d FROM (VALUES (0),(1),(2),(3),(4),(5),(6),(7),(8),(9)) AS d(d)
	)
	
	INSERT INTO #LargeTable (KeyVal, DataVal)
		SELECT 
			10000 * tt.d + 1000 * st.d + 100 * h.d + 10 * t.d + s.d + 1
			, 10 * RAND(CHECKSUM(NEWID())) + 1
		FROM   
			Digits AS s,  
			Digits AS t,  
			Digits AS h,
			Digits AS st, 
			Digits AS tt
	;
	go

	CREATE FUNCTION dbo.Triple(@Input int)
		RETURNS int
	AS
	BEGIN;
		DECLARE @Result int;
		SET @Result = @Input * 3;
		RETURN @Result;
	END;
	go


-- ACT
	Print '1: Using UDF'
	SET STATISTICS TIME ON;
		SELECT MAX(dbo.Triple(DataVal)) AS Triple
		FROM   #LargeTable;
	SET STATISTICS TIME OFF;

	Print '2: Using Inline'
	SET STATISTICS TIME ON;
		SELECT MAX(DataVal * 3) AS MaxTriple
		FROM   #LargeTable;
	SET STATISTICS TIME OFF;


-- 2)  Illustration of a solution (do the function inline rather than in a UDF)
go
CREATE FUNCTION dbo.Nonsense(@Input int)
RETURNS int
WITH SCHEMABINDING
AS
BEGIN;
	DECLARE @Result int,
		@BaseDate date,
		@YearsAdded date,
		@WeekDiff int;

	SET @BaseDate = '20000101';
	SET @YearsAdded = DATEADD(year, @Input, @BaseDate);
	IF @Input % 2 = 0
	BEGIN;
		SET @Result = DATEDIFF(day, @YearsAdded, @BaseDate) - DATEDIFF(month, @YearsAdded, @BaseDate);
	END;
	ELSE
	BEGIN;
		SET @WeekDiff = DATEDIFF(week, @BaseDate, @YearsAdded);
		SET @Result = (100 + @WeekDiff) * (@WeekDiff - 100);
	END;
	RETURN @Result;
END;
go

-- 1: Using UDF
SET STATISTICS TIME ON;
	SELECT 
		KeyVal, DataVal, dbo.Nonsense(DataVal)
	FROM   #LargeTable
	WHERE  KeyVal <= 100;
SET STATISTICS TIME OFF;


-- 2: Using liline
SET STATISTICS TIME ON;
	WITH MyCTE
	AS 
	(
		SELECT 
			KeyVal, DataVal,CAST('20000101' AS date) AS BaseDate,
			DATEADD(year, DataVal, CAST('20000101' AS date)) AS YearsAdded
		FROM
			#LargeTable
	)

	SELECT 
		KeyVal, DataVal,
		CASE 
			WHEN DataVal % 2 = 0 THEN DATEDIFF(day, YearsAdded, BaseDate) - DATEDIFF(month, YearsAdded, BaseDate)
			ELSE (100 + DATEDIFF(week, BaseDate, YearsAdded)) * (DATEDIFF(week, BaseDate, YearsAdded) - 100)
	END
	FROM   
		MyCTE
	WHERE  
		KeyVal <= 100;
SET STATISTICS TIME OFF;


-- TEARDOWN
DROP TABLE #LargeTable
DROP FUNCTION dbo.Triple
DROP FUNCTION dbo.Nonsense
go




