-- Originally from http://shanecooper.net/cooldatefunctions.htm
-- Website no longer available

-- First Day of Month
select 'First Day of Month' Description, DATEADD(mm, DATEDIFF(mm,0,getdate()), 0) union all
 
-- First Day of Last Month
select 'First Day of Last Month' Description, DATEADD(mm, DATEDIFF(mm,0,DATEADD(mm,-1,getdate())), 0) union all
 
-- Monday of the Current Week
select 'Monday of the Current Week' Description, DATEADD(wk, DATEDIFF(wk,0,getdate()), 0) union all
 
-- First Day of the Year
select 'First Day of the Year' Description, DATEADD(yy, DATEDIFF(yy,0,getdate()), 0) union all
 
-- First Day of the Quarter
select 'First Day of the Quarter' Description, DATEADD(qq, DATEDIFF(qq,0,getdate()), 0) union all
 
-- Midnight for the Current Day
select 'Midnight for the Current Day' Description, DATEADD(dd, DATEDIFF(dd,0,getdate()), 0) union all
 
-- Last Day of Prior Month
select 'Last Day of Prior Month' Description, dateadd(ms,-3,DATEADD(mm, DATEDIFF(mm,0,getdate()  ), 0)) union all
 
-- Last Day of Prior Year
select 'Last Day of Prior Year' Description, dateadd(ms,-3,DATEADD(yy, DATEDIFF(yy,0,getdate()  ), 0)) union all
 
-- Last Day of Current Month
select 'Last Day of Current Month' Description, dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,getdate()  )+1, 0)) union all
 
-- Last Day of Current Year
select 'Last Day of Current Year' Description, dateadd(ms,-3,DATEADD(yy, DATEDIFF(yy,0,getdate()  )+1, 0)) union all
 
-- First Monday of the Month
select 'First Monday of the Month' Description, DATEADD(wk, DATEDIFF(wk,0, dateadd(dd,6-datepart(day,getdate()),getdate()) ), 0) 

-- Sunday of the Current Week
set DATEFIRST 1
select 'Sunday of the Current Week' Description, DATEADD(dd, 1 - DATEPART(dw, getdate()), getdate())
 
