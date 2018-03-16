--
-- DbServer:  n/a - general purpose script
-- DbName:    n/a - general purpose script
--
-- Explanation:
--    Script for removing trailing zeroes from a decimal number (i.e. for assessing a text field as a decimal)
-- 
-- References:
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
	union all select '1023.98700'
	union all select '1023.'

	-- In essence the funky replace statement does this:
	-- 1) Convert _all_ zeroes to spaces
	-- 2) Trim off any trailing spaces (i.e. remove trailing zeroes)
	-- 3) Convert spaces back to zeroes to get back to a number
	-- 4) Convert "." to a space
	-- 5) Trim the "." (now space) off 
	-- 6) Convert spaces back to "." (i.e. if "." is at the end, it can be removed)

	select 
		replace
		(
			rtrim
			(
				replace
				(
					replace
					(
						rtrim
						(
							replace(data, '0', ' ')     -- [1] '1023.98700'  =>  '1 23.987  '
						)                             -- [2] '1 23.987  '  =>  '1 23.987'
						, ' ', '0'                    -- [3] '1 23.987'    =>  '1023.987'
					)
					, '.' ,' '                      -- [3] '1023.'  =>  '1023 '
				)                                 -- [4] '1023.'  =>  '1023 '
			)                                   -- [5] '1023 '  =>  '1023'
			, ' ', '.'                          -- [6] '1023'   =>  '1023'
		)
	from #test

rollback