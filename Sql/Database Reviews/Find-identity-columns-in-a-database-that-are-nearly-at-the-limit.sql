-- 
-- Finds identity columns in a database that are nearly at the limit.
-- 
-- Taken from:
-- https://michaeljswart.com/2020/07/monitoring-identity-columns-for-room-to-grow/

select * from (
select @@servername as server, db_name() as db, s.name as [schema], o.name as [object], ic.name as [column], t.name as [type], ic.seed_value, ic.increment_value, ic.last_value,
case t.name
when 'bigint' then convert(decimal(4,3),convert(bigint,ic.last_value) / 9223372036854775807.0)
when 'int' then convert(decimal(4,3),convert(int,ic.last_value) / 2147483647.0)
when 'smallint' then convert(decimal(4,3),convert(smallint,ic.last_value) / 32767.0)
when 'tinyint' then convert(decimal(4,3),convert(tinyint,ic.last_value) / 255.0)
end
as pct
from sys.identity_columns ic
inner join sys.objects o
on ic.object_id = o.object_id
inner join sys.schemas s
on s.schema_id = o.schema_id
inner join sys.types t
on ic.system_type_id = t.system_type_id
where o.type_desc = 'user_table'
) bob
where pct > .9
