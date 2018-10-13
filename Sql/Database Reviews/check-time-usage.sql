--
-- DbServer:  n/a - general purpose script
-- DbName:    n/a - general purpose script
--
-- Explanation:
-- 
--    Looks in stored procs, functions and default column definitions for "CURRENT_TIMESTAMP" or "GetDate"
-- 
--    I consider this a warning as in lot of cirumstances you want GetUTCDate otherwise you'll hit issues
-- with daylight saving and events will appear to arrive out of order!
-- 
--    Recommend using this to review and ensuring usage is correct.
--

SELECT DISTINCT
       o.name AS Object_Name,
       o.type_desc
			 , m.definition
  FROM sys.sql_modules m
       INNER JOIN
       sys.objects o
         ON m.object_id = o.object_id
 WHERE m.definition Like '%CURRENT_TIMESTAMP%' or m.definition like '%GetDate%'

SELECT 
    DefaultConstraintName = df.name,
    df.definition
FROM 
    sys.default_constraints df
INNER JOIN 
    sys.tables t ON df.parent_object_id = t.object_id
INNER JOIN 
    sys.columns c ON c.object_id = df.parent_object_id AND df.parent_column_id = c.column_id
 WHERE df.definition Like '%CURRENT_TIMESTAMP%' or df.definition like '%GetDate%'
		 

