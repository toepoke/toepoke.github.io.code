--
-- DbServer:  n/a - general purpose script
-- DbName:    n/a - general purpose script
--
-- Explanation:
--    A method of creating enums in SQL server without look-ups tables.  Not saying this is the best way of doing it!
--
--    I'd argue if you're thinking this is useful, you should probably be using a lookup table instead :-)
--    BUT; It is an option.
--
--    Thinking further this technique may be useful for stored procs where the enum is used across the system
--    and/or where the value of the enumerations aren't saved (i.e. you can alter the index without impact on the db)
--    (though I'd still be tempted to say it's a lookup table)
-- 
-- References:
--  - None

create view Enumerations AS
	select Enum, Value, ShortDesc
	from 
	(
		--     Enum            Value    ShortDesc
    select 'Animals' Enum, 1 Value, 'Cat'  ShortDesc union all
    select 'Animals'     , 2      , 'Dog'            union all
    select 'Animals'     , 3      , 'Bird' 

		union all

		--     Enum        Value   ShortDesc
    select 'Vehicles', 1,      'Car'        union all
    select 'Vehicles', 2,      'Bike'       union all
    select 'Vehicles', 3,      'Lorry' 

	) animals
go

select * from Enumerations
go

drop view Enumerations
go

