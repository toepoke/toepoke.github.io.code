Attribute VB_Name = "Deferrer_Tests"
Option Explicit

Public Const DEFER_DELIM As String = "::"
' Set as "-1" to run all tests
Private Const mRunOnly As Integer = -1
Private mFromDate As Date


''' <summary>
''' Some test scenarios to ensure the deferment works as expected.
''' </summary>
Public Sub RunTests()
  
  mFromDate = "12-MAR-2015 14:20"
  
  ' No delim => send immediately
  RunTest 0, mFromDate, ""
  
  ' "::in X Y"
  RunTest 1, "12-MAR-2015 14:40", "::in 20 minutes"
  RunTest 2, "12-MAR-2015 16:20", "::in 120 minutes"
  RunTest 3, "12-MAR-2015 16:20", "::in 2 hours"
  RunTest 4, "14-MAR-2015 14:20", "::in 2 days"
  RunTest 5, "26-MAR-2015 14:20", "::in 2 weeks"
  RunTest 6, "12-MAY-2015 14:20", "::in 2 months"
  
  ' ":: at X"
  RunTest 7, "12-MAR-2015 22:30", "::at 22:30"
  RunTest 8, "12-MAR-2015 22:30", "::at 10:30pm"
  RunTest 9, "13-MAR-2015 10:00", "::at 10:00", "10am has passed today, should fall over to tomorrow"
  RunTest 10, "13-MAR-2015 10:00", "::at 10am", "10am has passed today, should fall over to tomorrow"
  
  ' "::on 23/3/15 at 14:00"
  RunTest 11, "19-MAR-2015 15:15", "::on 19-MAR-2015 at 15:15"
  RunTest 12, "19-MAR-2015 15:15", "::on 19-MAR-2015 at 3:15pm"
  RunTest 13, "01-JAN-1900", "::on 19-MAR-2000 at 3:15pm", "Should raise error as 'on' date is in the past"
  
  ' ":: on X-day at 2pm"
  RunTest 14, "12-MAR-2015 14:00", "::on Today at 2pm", "Should be today as we asked for today"
  RunTest 15, "13-MAR-2015 14:00", "::on Tomorrow at 2pm", "Should be the Friday, as Tomorrow is Friday"
  RunTest 16, "13-MAR-2015 14:00", "::on Friday at 2pm", "Should be Friday as well as Tomorrow"
  RunTest 17, "19-MAR-2015 14:00", "::on Thursday at 2pm", "Should be next week as we start from today, but ask for Thursday"
  
  ' LONG VERSION: Full week check (we've done Friday above, we only do one week ahead)
  RunTest 18, "14-MAR-2015 14:00", "::on Sat at 2pm"
  RunTest 19, "15-MAR-2015 14:00", "::on Sun at 2pm"
  RunTest 20, "16-MAR-2015 14:00", "::on Mon at 2pm"
  RunTest 21, "17-MAR-2015 14:00", "::on Tue at 2pm"
  RunTest 22, "18-MAR-2015 14:00", "::on Wed at 2pm"
  RunTest 23, "19-MAR-2015 14:00", "::on Thu at 2pm"
  
  ' SHORT VERSION: Full week check (we've done Friday above, we only do one week ahead)
  RunTest 24, "14-MAR-2015 14:00", "::Sat at 2pm"
  RunTest 25, "15-MAR-2015 14:00", "::Sun at 2pm"
  RunTest 26, "16-MAR-2015 14:00", "::Mon at 2pm"
  RunTest 27, "17-MAR-2015 14:00", "::Tue at 2pm"
  RunTest 28, "18-MAR-2015 14:00", "::Wed at 2pm"
  RunTest 29, "19-MAR-2015 14:00", "::Thu at 2pm"
  
  ' Today/Tomorrow but without "on" prefix
  RunTest 30, "12-MAR-2015 14:00", "::Today at 2pm"
  RunTest 31, "13-MAR-2015 14:30", "::Tomorrow at 2:30pm"
  ' Test short version
  RunTest 32, "12-MAR-2015 14:00", "::Tod at 2pm"
  RunTest 33, "13-MAR-2015 14:30", "::Tom at 2:30pm"
  
End Sub


''' <summary>
''' Helper method for running our tests (see RunTests) to ensure the deferment code works as expected.
''' </summary>
Private Function RunTest(scenarioNum As Integer, expected As Date, scenario As String, Optional message As String = "") As Boolean
  If mRunOnly > -1 And mRunOnly <> scenarioNum Then
    ' Only running a single test and it isn't this one
    Exit Function
  End If
  Dim actual As Date
  Dim pass As Boolean
  Dim testNum As String
  Const DATE_COMPARE_LENGTH As Integer = 15
  actual = GetDeferredDate(scenario, mFromDate)
  
  ' Only compare the year, month, day, hour and minute
  pass = (Left(expected, DATE_COMPARE_LENGTH) = Left(actual, DATE_COMPARE_LENGTH))
  
  ' Zero prefix
  testNum = Right("000" & scenarioNum, 3)
  
  Debug.Print "TEST " & testNum & " : " & scenario & " GAVE " & actual & " - " & IIf(pass, "PASSED", "FAILED")
  If Not pass Then
    Debug.Print "---------------------------------------"
    Debug.Print vbTab & "**** FAILED ****"
    If Len(message) > 0 Then
      Debug.Print vbTab & "* MESSAGE  : " & message
    End If
    Debug.Print vbTab & "* EXPECTED : " & expected
    Debug.Print vbTab & "* ACTUAL   : " & actual
    Debug.Print "---------------------------------------"
  End If
End Function


