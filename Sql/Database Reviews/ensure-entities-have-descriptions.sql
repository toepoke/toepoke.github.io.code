select cols.TABLE_SCHEMA, cols.TABLE_NAME, cols.COLUMN_NAME, props.*
from 
	information_schema.columns cols
left join INFORMATION_SCHEMA.VIEWS views on cols.TABLE_SCHEMA = views.TABLE_SCHEMA and cols.TABLE_NAME = views.TABLE_NAME
left join 
(
	SELECT S.name as [SchemaName], O.name AS [ObjectName], c.Name as [ColumnName], ep.name, ep.value AS [Extended property]
	FROM sys.extended_properties EP
	LEFT JOIN sys.all_objects O ON ep.major_id = O.object_id 
	LEFT JOIN sys.schemas S on O.schema_id = S.schema_id
	LEFT JOIN sys.columns AS c ON ep.major_id = c.object_id AND ep.minor_id = c.column_id
) props
	on cols.TABLE_SCHEMA = props.SchemaName and cols.COLUMN_NAME = props.ColumnName

where
	-- no intererested in views
	views.TABLE_NAME is null
	-- outside our control
	and cols.TABLE_SCHEMA not in ('Hangfire', 'tSQLt') 

	-- show items without a description
	and props.[Extended Property] is null
order by 1, 2, 3
