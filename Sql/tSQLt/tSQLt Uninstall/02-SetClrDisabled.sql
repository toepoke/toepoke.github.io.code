-- FJ: Basically the inverse of "01-SetClrEnabled.sql"

EXEC sp_configure 'clr enabled', 0;
RECONFIGURE;
GO

DECLARE @cmd NVARCHAR(MAX);
SET @cmd='ALTER DATABASE ' + QUOTENAME(DB_NAME()) + ' SET TRUSTWORTHY ON;';
EXEC(@cmd);
GO
