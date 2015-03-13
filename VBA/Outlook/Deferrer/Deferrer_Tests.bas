Attribute VB_Name = "Deferrer_Tests"
Option Explicit

Public Const DEFER_DELIM As String = "::"
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
  
End Sub


''' <summary>
''' Helper method for running our tests (see RunTests) to ensure the deferment code works as expected.
''' </summary>
Private Function RunTest(scenarioNum As Integer, expected As Date, scenario As String, Optional message As String = "") As Boolean
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


