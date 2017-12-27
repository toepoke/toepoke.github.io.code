Attribute VB_Name = "Deferrer"
Option Explicit

Public Const DEFER_DELIM As String = "::"
Public Const ILLEGAL_DATE As Date = "01-JAN-1900 00:00"
Private mError As String

''' <summary>
''' Establishes if a deferring instruction is present in the given (scenario) parameter, and if
''' so returns the date/time when the deferment should take place.
''' For instance if "scenario" is "My Test e-mail ::in 10 minutes" then NOW+10 minutes will
''' be returned (and used to defer the sending of an e-mail.
''' Various deferment types are supported, including:
'''
''' IN - For instance "Make coffee :: in 10 minutes" or "Person of interest, series 5 starts :: in 2 weeks"
''' ON - For instance "It's Christmas! :: on 31-Dec-15 at 12:01"
''' AT - For instance "Home time! :: at 16:00"
'''
''' scenario - String to test for a deferment (e.g. ":: in 10 minutes")
''' fromDate - Base date to use for a deferment
'''            (normally this is NOW, but if we're testing it's useful to start from a constant time)
''' </summary>
''' <returns>
''' If a deferment (anything with ::) is present, the deferment time is returned
''' If an error is present (deferment can't be decoded for instance) then "01-JAN-1900" is returned
''' </returns>
Public Function GetDeferredDate(inScenario As String, fromDate As Date) As Date
  Dim delimPos As Integer
  Dim arr() As String
  Dim d As Date
  Dim scenario As String
  
  ' Delims:
  '   ":: in 20 minutes"
  '   ":: on 23/3/15 at 14:00"
  '   ":: at 14:00"
  
  delimPos = InStr(inScenario, DEFER_DELIM)
  If delimPos <= 0 Then
    ' No special rules, so send straight away
    GetDeferredDate = fromDate
    Exit Function
  End If
  
  ' Extract whatever is after the "::" delimiter
  scenario = Trim(Mid(inScenario, delimPos + Len(DEFER_DELIM)))
  
  ' Ensure we only have a single whitespace betweek tokens
  scenario = Utils.ReplaceMultiples(scenario, " ")
  
  ' Convert into elements for processing
  arr = Split(scenario, " ")
  
  If IsToday(arr(0)) Or IsTomorrow(arr(0)) Or GetDayOfWeekNumber(arr(0)) > -1 Then
    ' TODAY or TOMORROW, either way just re-use what we already have:
    scenario = ":: on " & scenario
    d = GetDeferredDate(scenario, fromDate)
  
  Else
    ' Use the appropriate method given the type of deferment found
    Select Case UCase(arr(0))
      Case "IN": d = GetIn(scenario, arr, fromDate)
      Case "ON": d = GetOnAt(scenario, arr, fromDate)
      Case "AT": d = GetAt(scenario, arr, fromDate)
    End Select
  End If
  
  GetDeferredDate = d
End Function


''' <summary>
''' Establishes the offset for the "IN" scenario (e.g. "Make coffee :: in 10 minutes")
''' </summary>
''' <returns>
''' On success returns the calculated offset
''' </returns>
Private Function GetIn(scenario As String, options() As String, fromDate As Date) As Date
  '   "in 20 minutes"
  Dim amount As Integer
  Dim granularity As String
  Dim answer As Date
  
  amount = CInt(options(1))
  granularity = GetDateGranularity(options(2))
  answer = DateAdd(granularity, amount, fromDate)
    
  GetIn = answer
End Function


''' <summary>
''' Establishes the offset for the "ON" scenario (e.g. "It's Christmas! :: on 31-Dec-15 at 12:01")
''' </summary>
''' <returns>
''' On success returns the calculated offset
''' </returns>
Private Function GetAt(scenario As String, options() As String, fromDate As Date) As Date
  '   "at 14:00"
  Dim tmStr As String
  Dim answer As Date
  
  tmStr = options(1)
  
  answer = GetDateSerial(CStr(fromDate)) + GetTimeSerial(tmStr)
  
  If answer < fromDate Then
    ' Too late in the day for this date ... assuming tomorrow
    answer = DateAdd("d", 1, answer)
  End If
  
  GetAt = answer
End Function


''' <summary>
''' Establishes the offset for the "AT" scenario (e.g. "Home time! :: at 16:00")
''' </summary>
''' <returns>
''' On success returns the calculated offset
''' </returns>
Private Function GetOnAt(scenario As String, options() As String, fromDate As Date) As Date
  '   "on 23/3/15 at 14:00"    OR
  '   "on Friday at 14:00"
  Dim onDateStr As String
  Dim targetDate As Date
  
  onDateStr = UCase(options(1))
  
  If GetDayOfWeekNumber(onDateStr) > -1 Or IsToday(onDateStr) Or IsTomorrow(onDateStr) Then
    targetDate = GetOnDayAt(scenario, options, fromDate)
  Else
    targetDate = GetOnDateAt(scenario, options, fromDate)
  End If
    
  GetOnAt = targetDate
End Function


''' <summary>
''' Establishes the offset for the "AT" scenario (e.g. "Home time! :: at 16:00")
''' </summary>
''' <returns>
''' On success returns the calculated offset
''' </returns>
Private Function GetOnDateAt(scenario, options() As String, fromDate As Date) As Date
  '   "on 23/3/15 at 14:00"
  Dim tmStr As String
  Dim answer As Date
  Dim dateStr As String
  Dim d As Date
  
  dateStr = options(1)
  tmStr = options(3)
  
  d = CDate(dateStr)
  answer = GetDateSerial(CStr(d)) + GetTimeSerial(tmStr)
  
  If answer < fromDate Then
    mError = """" & scenario & """" & " is in the past ... move to tomorrow?"
    answer = ILLEGAL_DATE
  End If
  
  GetOnDateAt = answer
End Function


''' <summary>
'''
''' </summary>
''' <returns>
''' On success returns the calculated offset
''' </returns>
Private Function GetOnDayAt(scenario, options() As String, fromDate As Date) As Date
  '   "on Friday at 14:00"
  Dim answer As Date
  Dim dowNdx As Integer
  Dim dayStr As String
  Dim timeStr As String
  Dim currDate As Date
  
  dayStr = options(1)
  If UBound(options) = 1 Then
    ' No time component present, use current time (dervied from the fromDate - testing)
    timeStr = GetTimeSerial(Right(CStr(fromDate), 8))
  Else
    ' Take time component as defined
    timeStr = options(3)
  End If
  
  
  ' Start from our offset
  currDate = fromDate
  
  If IsToday(dayStr) Then
    GetOnDayAt = GetDateSerial(CStr(fromDate)) + GetTimeSerial(timeStr)
    Exit Function
  End If
  
  
  If IsTomorrow(dayStr) Then
    ' Change to force "Tomorrow" as a result
    currDate = DateAdd("d", 1, currDate)
    dayStr = WeekdayName(Weekday(currDate, vbMonday), True, vbMonday)
    
  ElseIf Year(currDate) = Year(fromDate) And Month(currDate) = Month(fromDate) And Day(currDate) = Day(fromDate) Then
    ' Assume they mean "next Thursday"
    ' ... so move on a day
    currDate = DateAdd("d", 1, currDate)
  End If
  
  ' Loop around until we get a match on the DayName
  dowNdx = GetDayOfWeekNumber(dayStr)
  While Weekday(currDate, vbMonday) <> dowNdx
    currDate = DateAdd("d", 1, currDate)
  Wend
  
  answer = GetDateSerial(CStr(currDate)) + GetTimeSerial(timeStr)

  GetOnDayAt = answer
End Function


''' <summary>
''' Helper method which converts the given string into the time component of
''' a date - this one however respects AM/PM settings
''' </summary>
''' <returns>
''' On success returns time portion of a date object
''' </returns>
Private Function GetTimeSerial(timeInput As String) As Date
  Dim args() As String
  Dim hh As Integer, mm As Integer
  Dim t As Date
  Dim hasAm As Boolean, hasPm As Boolean
  Dim timeStr As String
  
  timeStr = UCase(timeInput)
    
  ' AM/PM specified?
  hasAm = InStr(timeStr, "AM") > 0
  hasPm = InStr(timeStr, "PM") > 0
  
  ' Remove the AM/PM to remove confusion later
  timeStr = Replace(Replace(timeStr, "AM", ""), "PM", "")
  
  args = Split(timeStr, ":")
  hh = CInt(args(0))
  If UBound(args) >= 1 Then
    ' Have minutes
    mm = CInt(args(1))
  End If
  
  If hasPm And hh < 12 Then
    hh = hh + 12
  End If
  
  GetTimeSerial = TimeSerial(hh, mm, 0)
End Function

''' Returns only the date portion
Private Function GetDateSerial(dateStr As String) As Date
  Dim d As Date
  
  d = CDate(dateStr)
  
  GetDateSerial = DateSerial(Year(d), Month(d), Day(d))
End Function


''' <summary>
''' Helper method to convert an English date component (e.g. "year") into an "interval" that
''' can be used by the VB date methods (e.g. "yyyy" in "DateAdd" for year)
''' </summary>
''' <returns>
''' On success returns VB Date method equivalent of an English duration
''' </returns>
Public Function GetDateGranularity(dateAddStr As String) As String
  Dim outStr As String
  dateAddStr = UCase(dateAddStr)

  If Left(dateAddStr, 4) = "YEAR" Then
    outStr = "yyyy"
  ElseIf Left(dateAddStr, 3) = "MIN" Then
    outStr = "n"
  ElseIf Left(dateAddStr, 4) = "WEEK" Then
    outStr = "ww"
  Else
    outStr = Left(dateAddStr, 1)
  End If

  GetDateGranularity = outStr
End Function


Private Function GetDayOfWeekNumber(dayName As String) As Integer
  Dim currDayName As String
  Dim n As Integer
  
  dayName = UCase(dayName)
  For n = 1 To 7
    currDayName = UCase(WeekdayName(n, True, vbMonday))
    If currDayName = Left(dayName, 3) Then
      GetDayOfWeekNumber = n
      Exit Function
    End If
  Next n

  ' No match
  GetDayOfWeekNumber = -1
End Function


Private Function IsToday(dayStr As String) As Boolean
  IsToday = Left(UCase(dayStr), 3) = "TOD"
End Function

Private Function IsTomorrow(dayStr As String) As Boolean
  IsTomorrow = Left(UCase(dayStr), 3) = "TOM"
End Function



