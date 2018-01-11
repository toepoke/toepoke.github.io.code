--
-- Simple example of importing data from Excel
-- See also: https://social.technet.microsoft.com/wiki/contents/articles/24236.importing-an-excel-spreadsheet-into-a-sql-server-database.aspx

-- We use the "IMEX=1" setting to tell Excel "I don't care value you _think_ is there, convert it as a string"
-- Sadly all "IMEX=1" does is sample the first 8 rows and all 8 are numbers _it_will_still_convert_to_a_float!!!!
-- Thankfully you can change the "8" row rule ... through the registry (seriously!??!! - why not another property?)
--   https://www.concentra.co.uk/blog/why-ssis-always-gets-excel-data-types-wrong-and-how-to-fix-it
-- The above article says to change the registry entry "TypeGuessRows" to zero
--  o You'd think that zero meant all rows, but oh no, see the comment from "justdaven" - it's just the first "16,384" - throw back to 16-bit Excel per chance :)
--  o However you can change it "1,048,600" which is the current row limit of Excel (ish) - 2010 version anyways 

EXEC sp_configure 'Show Advanced Options', 1;
go
RECONFIGURE;
go
EXEC sp_configure 'Ad Hoc Distributed Queries', 1;
go
RECONFIGURE;
go
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1   
EXEC sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1
go

begin transaction

	-- HDR=YES	First row is treated as headers (these are carried over as your column names)
	-- IMEX=1   Tells the driver to treat everything as text, however see notes above on this.

	begin try
		select *
		into ExcelFileContents
		from OpenRowSet(
			'Microsoft.ACE.OLEDB.12.0', 
			'Excel 12.0; HDR=YES; IMEX=1;
				Database={DIRECTORY}\Read Excel with OpenRowSet.xlsx', 
			'SELECT * FROM [Sheet1$]'
		)
	
		select * from ExcelFileContents

		select 
			cols.COLUMN_NAME, cols.DATA_TYPE
		from 
			information_schema.columns cols
		where
			cols.table_name = 'ExcelFileContents'
				
		drop table ExcelFileContents
	end try
	begin catch
		Print 'Ensure you''ve changed the {DIRECTORY} in the path, and you don''t have the file already open in Excel'
	end catch

rollback

