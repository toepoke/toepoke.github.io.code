
-- https://blog.sqlauthority.com/2007/08/07/sql-server-2005-list-tables-in-database-without-primary-key/

SELECT SCHEMA_NAME(schema_id) AS SchemaName,name AS TableName
FROM sys.tables
WHERE OBJECTPROPERTY(OBJECT_ID,'TableHasPrimaryKey') = 0
ORDER BY SchemaName, TableName;
GO

