

CREATE TABLE #TestTable (ID INT, Col VARCHAR(4))
GO
INSERT INTO #TestTable 
	       ( ID, Col )
	VALUES ( 1, 'A' )
	     , ( 1, 'B' )
	     , ( 1, 'C' )
	     , ( 2, 'A' )
	     , ( 2, 'B' )
	     , ( 2, 'C' )
	     , ( 2, 'D' )
	     , ( 2, 'E' )
GO

--SELECT *
--FROM #TestTable
--GO

-- Get CSV values as a record set
-- Inspired from https://blog.sqlauthority.com/2012/09/14/sql-server-grouping-by-multiple-columns-to-single-column-as-a-string/
	SELECT 
		t.ID, 
		STUFF
		(
			(
				SELECT ',' + s.Col
				FROM #TestTable s
				WHERE s.ID = t.ID
				FOR XML PATH('')
			),1,1,''
		) AS CSV
	FROM #TestTable AS t
	GROUP BY t.ID
	GO


-- Get CSV values as a variable
-- Inspired from http://www.sqlteam.com/article/using-coalesce-to-build-comma-delimited-string
declare @csv varchar(100)

-- Initialisation to null _is_ relevant (though if you leave @csv undeclared it will [should] be NULL)
set @csv = null	

select 
	@csv = coalesce(@csv + ',', '') + 
	t.Col
from
	#TestTable t

select 'CSV = ' + @csv


-- Clean up
DROP TABLE #TestTable
GO
