--
-- DbServer:  n/a - general purpose script
-- DbName:    n/a - general purpose script
--
-- Explanation:
--    The purpose of this script is to list any foreign keys that do not have an associated
-- index (generally it's a good idea to have indexes on FKs - _not_always_ but generally)
--
--    The output is in the form of a script that will create the indexes for you.  Just remove the ones
-- you don't want to create an index for (e.g. the table has a low number of rows).
--
--    Any FKs you don't want as an index, as to the exclusions where clause so they don't always appear :-)
-- 
-- References:
--  - https://stackoverflow.com/questions/10735407/sql-server-create-indexes-on-foreign-keys-where-necessary

declare @CrLf varchar(2) = char(13) + char(10)

SELECT
	* 
FROM 
(
	SELECT TOP 99.99999999 PERCENT
			f.name AS ForeignKeyName

		, s.name ParentSchema

		, s.name 
				+ '.'
				+ OBJECT_NAME(f.parent_object_id) 
				+ '.'
				+ COL_NAME(fc.parent_object_id, fc.parent_column_id) 
			ParentTable
						
		, referencedSchema.name
				+ '.'
				+ OBJECT_NAME (f.referenced_object_id)
				+ '.'
				+ COL_NAME(fc.referenced_object_id, fc.referenced_column_id)
			ReferencedTable

		, 
			'create nonclustered index [IX_' + replace(f.name,'FK_','') + ']'
				+ ' on ' 
				+ '[' + s.name + ']'
				+ '.'
				+ '[' + OBJECT_NAME(f.parent_object_id) + ']'
				+ '(' 
					+ COL_NAME(fc.parent_object_id, fc.parent_column_id)
				+ ');' + @CrLf
				+ 'go' + @CrLf
			CreateIndexSql

		, 
			'drop index [IX_' + replace(f.name,'FK_','') + ']' 
				+ ' on ' 
				+ '[' + s.name + ']'
				+ '.'
				+ '[' + OBJECT_NAME(f.parent_object_id) + ']'
				+ ';' + @CrLf
				+ 'go' + @CrLf 
			DropIndexSql
			
	FROM 
		sys.foreign_keys AS f 
		inner join sys.foreign_key_columns AS fc ON f.OBJECT_ID = fc.constraint_object_id
		inner join sys.schemas s on f.schema_id = s.schema_id

		inner join sys.tables referencedTable on f.referenced_object_id = referencedTable.object_id
		inner join sys.schemas referencedSchema on referencedTable.schema_id = referencedSchema.schema_id

	ORDER BY
		2, 3, 1	
) a
where 
	a.ParentTable not in 
	(
		-- Add any exclusions here so you can forget about them
		  ''
	) 
	and a.ParentSchema not in 
	(
		-- Add any exclusions here so you can forget about them
		-- ... (you may want to exclude any schema that holds your static data as the tables will be small)
		  ''
	)


