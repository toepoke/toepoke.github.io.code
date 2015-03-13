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
Public Function GetDeferredDate(scenario As String, fromDate As Date) As Date
  Dim delimPos As Integer
  Dim arr() As String
  Dim d As Date
  
  ' Delims:
  '   ":: in 20 minutes"
  '   ":: on 23/3/15 at 14:00"
  '   ":: at 14:00"
  
  delimPos = InStr(scenario, DEFER_DELIM)
  If delimPos <= 0 Then
    ' No special rules, so send straight away
    GetDeferredDate = fromDate
    Exit Function
  End If
  
  ' Extract whatever is after the "::" delimiter
  scenario = Trim(Mid(scenario, delimPos + Len(DEFER_DELIM)))
  
  ' Convert into elements for processing
  arr = Split(scenario, " ")
  
  ' Use the appropriate method given the type of deferment found
  Select Case UCase(arr(0))
    Case "IN": d = GetIn(scenario, arr, fromDate)
    Case "ON": d = GetOnAt(scenario, arr)
    Case "AT": d = GetAt(scenario, arr, fromDate)
  End Select
  
  GetDeferredDate = d
End Function


''' <summary>
''' Establishes the offset for the "IN" scenario (e.g. "Make coffee :: in 10 minutes")
''' </summary>
''' <returns>
''' On success returns the calculated offset
''' </returns>
Private Function GetIn(scenario As String, options() As String, fromDate As Date)
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
Private Function GetAt(scenario As String, options() As String, fromDate As Date)
  '   "at 14:00"
  Dim tmStr As String
  Dim answer As Date
  
  tmStr = options(1)
  
  answer = DateSerial(Year(fromDate), Month(fromDate), Day(fromDate)) + GetTimeSerial(tmStr)
  
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
Private Function GetOnAt(scenario As String, options() As String)
  '   "on 23/3/15 at 14:00"
  Dim tmStr As String
  Dim answer As Date
  Dim dateStr As String
  Dim d As Date
  
  dateStr = options(1)
  tmStr = options(3)
  
  d = CDate(dateStr)
  answer = DateSerial(Year(d), Month(d), Day(d)) + GetTimeSerial(tmStr)
  
  If answer < Now Then
    mError = """" & scenario & """" & " is in the past ... move to tomorrow?"
    answer = ILLEGAL_DATE
  End If
  
  GetOnAt = answer
End Function


''' <summary>
''' Helper method which converts the given string into the time component of
''' a date - this one however respects AM/PM settings
''' </summary>
''' <returns>
''' On success returns time portion of a date object
''' </returns>
Private Function GetTimeSerial(timeStr As String) As Date
  Dim args() As String
  Dim hh As Integer, mm As Integer
  Dim t As Date
  Dim hasAm As Boolean, hasPm As Boolean
  
  timeStr = UCase(timeStr)
    
  ' AM/PM specified?
  hasAm = InStr(timeStr, "AM") > 0
  hasPm = InStr(timeStr, "PM") > 0
  
  ' Remove the AM/PM to remove confusion later
  timeStr = Replace(Replace(timeStr, "AM", ""), "PM", "")
  
  args = Split(timeStr, ":")
  hh = CInt(args(0))
  If UBound(args) = 1 Then
    ' Have minutes
    mm = CInt(args(1))
  End If
  
  If hasPm And hh < 12 Then
    hh = hh + 12
  End If
  
  GetTimeSerial = TimeSerial(hh, mm, 0)
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


