-- Originally from http://shanecooper.net/cooldatefunctions.htm
-- Website no longer available

-- First Day of Month
select DATEADD(mm, DATEDIFF(mm,0,getdate()), 0) 'First Day of Month'
 
-- First Day of Last Month
select DATEADD(mm, DATEDIFF(mm,0,DATEADD(mm,-1,getdate())), 0) 'First Day of Last Month'
 
-- Monday of the Current Week
select DATEADD(wk, DATEDIFF(wk,0,getdate()), 0) 'Monday of the Current Week'
 
-- Sunday of the Current Week
set DATEFIRST 1
select DATEADD(dd, 1 - DATEPART(dw, getdate()), getdate()) 'Sunday of the Current Week'
 
-- First Day of the Year
select DATEADD(yy, DATEDIFF(yy,0,getdate()), 0) 'First Day of the Year'
 
-- First Day of the Quarter
select DATEADD(qq, DATEDIFF(qq,0,getdate()), 0) 'First Day of the Quarter'
 
-- Midnight for the Current Day
select DATEADD(dd, DATEDIFF(dd,0,getdate()), 0) 'Midnight for the Current Day'
 
-- Last Day of Prior Month
select dateadd(ms,-3,DATEADD(mm, DATEDIFF(mm,0,getdate()  ), 0)) 'Last Day of Prior Month'
 
-- Last Day of Prior Year
select dateadd(ms,-3,DATEADD(yy, DATEDIFF(yy,0,getdate()  ), 0)) 'Last Day of Prior Year'
 
-- Last Day of Current Month
select dateadd(ms,-3,DATEADD(mm, DATEDIFF(m,0,getdate()  )+1, 0)) 'Last Day of Current Month'
 
-- Last Day of Current Year
select dateadd(ms,-3,DATEADD(yy, DATEDIFF(yy,0,getdate()  )+1, 0)) 'Last Day of Current Year'
 
-- First Monday of the Month
select DATEADD(wk, DATEDIFF(wk,0, dateadd(dd,6-datepart(day,getdate()),getdate()) ), 0)  'First Monday of the Month'
