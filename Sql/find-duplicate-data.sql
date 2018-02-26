--
-- DbServer:  n/a - general purpose script
-- DbName:    n/a - general purpose script
--
-- Explanation:
--    An approach for finding duplicate items in a query.
--    Whilst one would ordinarily cheat with a "DISTINCT", sometimes you want to know what the duplicates are
-- 
-- References:
--  - None

select 
	*
into #shoppingList
from
(
	--     Id      BasketItem
	select 1 Id,   'Milk'  BasketItem   union all
	select 2,      'Beans'              union all
	select 3,      'Beans'              union all
	select 4,      'Bread'
) a

select * from #shoppingList

select
	BasketItem, count(BasketItem) TimesDuplicated
from
	#shoppingList
group by
	BasketItem
having
	(count(BasketItem) > 1)

drop table #shoppingList
