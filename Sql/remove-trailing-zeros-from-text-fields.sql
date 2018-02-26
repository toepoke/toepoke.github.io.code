--
-- DbServer:  n/a - general purpose script
-- DbName:    n/a - general purpose script
--
-- Explanation:
--    An approach for finding duplicate items in a query.
--    Whilst one would ordinarily cheat with a "DISTINCT", sometimes you want to know what the duplicates are
-- 
-- References:
--  - https://www.databasejournal.com/features/mssql/article.php/10894_2222111_2/Padding-Rounding-Truncating-and-Removing-Trailing-Zeroes.htm
--

begin transaction

	create table #test (data nvarchar(255))

	insert into #test (data)
						select '123.4500' 
	union all select '123.0000'
	union all select '321.4500'
	union all select '999.4000'
	union all select '87.0000'
	union all select '100.000000000000000000000000'
	union all select '123.4599'

	-- In essence the funky replace statement does this:
	-- 1) Convert _all_ zeroes to spaces
	-- 2) Trim off any trailing spaces (i.e. remove trailing zeroes)
	-- 3) Convert spaces back to zeroes to get back to a number
	-- 4) Convert "." to a space
	-- 5) Trim the "." (now space) off 
	-- 6) Convert spaces back to "." (i.e. if "." is at the end, it can be removed)

	select replace(rtrim(replace(replace(rtrim(replace(data,'0',' '))
					,' ','0'),'.',' ')),' ','.')
			from #test

rollback