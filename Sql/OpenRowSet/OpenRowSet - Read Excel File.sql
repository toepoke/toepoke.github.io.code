--
-- Explanation:
--    Simple example of importing data from Excel
--
--    We use the "IMEX=1" setting to tell Excel "I don't care value you _think_ is there, convert it as a string"
--    Sadly all "IMEX=1" does is sample the first 8 rows and all 8 are numbers _it_will_still_convert_to_a_float!!!!
--
--    Thankfully you can change the "8" row rule ... through the registry (seriously!??!! - why not another property?)
--       - https://www.concentra.co.uk/blog/why-ssis-always-gets-excel-data-types-wrong-and-how-to-fix-it
--    The above article says to change the registry entry "TypeGuessRows" to zero
--      o You'd think that zero meant all rows, but oh no, see the comment from "justdaven" - it's just the first "16,384" - throw back to 16-bit Excel per chance :)
--      o However you can change it "1,048,600" which is the current row limit of Excel (ish) - 2010 version anyways 
--
-- Research Outcome:
--   o If you can avoid using OpenRowSet, do so - use an SSIS package if practical.
--   o You don't need Office installed on the server, but you do need the ACE drivers
--   o There's lots of little niggles you wouldn't necessarily think about initially.  For example really big numbers become
--     exponential numbers which are difficult to then convert back to a number.
--   o If you really need to use this method, try:
--     a) Use two temp tables:
--          1) For the data (treating the header as a row - this ensures everything comes in as varchar correctly
--          2) For the headers, just bring in "TOP 1" and bring in the headers separately
--          3) Renamed the column names from 1) using the "actual" headers from 2)
--             - This way you bring in data as varchar (without any conversions) and get the correct heading names
--             - Also means you don't need the registry hack above (which may be problematic on a production server
-- 
-- References:
--  - https://social.technet.microsoft.com/wiki/contents/articles/24236.importing-an-excel-spreadsheet-into-a-sql-server-database.aspx
--  - https://www.concentra.co.uk/blog/why-ssis-always-gets-excel-data-types-wrong-and-how-to-fix-it

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
		into MyShoppingList
		from OpenRowSet(
			'Microsoft.ACE.OLEDB.12.0', 
			'Excel 12.0; HDR=YES; IMEX=1;
				Database={EXCEL_FILE_PATH}\My-Shopping-List.xlsx', 
			'SELECT * FROM [Sheet1$]'
		)

		select * from MyShoppingList

		select 
			cols.COLUMN_NAME, cols.DATA_TYPE
		from 
			information_schema.columns cols
		where
			cols.table_name = 'MyShoppingList'
				
		drop table MyShoppingList
	end try
	begin catch
		Print 'Ensure you''ve changed the {DIRECTORY} in the path, and you don''t have the file already open in Excel'
	end catch

rollback

