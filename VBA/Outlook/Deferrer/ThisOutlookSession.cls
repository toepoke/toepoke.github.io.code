VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "ThisOutlookSession"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = True

Public WithEvents myOlApp As Outlook.Application
Attribute myOlApp.VB_VarHelpID = -1
Private mError As String

Const ILLEGAL_DATE As Date = "01-JAN-1900"

Private Sub Application_Startup()
    Initialize_handler
End Sub

Public Sub Initialize_handler()
    Set myOlApp = Outlook.Application
End Sub
 
 
''' <summary>
''' Event handler for when Outlook sends an e-mail.
''' Here we detect if there is a deferment time set and apply as appropriate
Private Sub myOlApp_ItemSend(ByVal Item As Object, Cancel As Boolean)
  On Error GoTo ErrorHandler
  
  Dim fromDate As Date
  Dim subject As String
  Dim sendDate As Date
  
  fromDate = Now
  subject = Item.subject
  
  sendDate = Deferrer.GetDeferredDate(subject, fromDate)
  
  If sendDate = fromDate Then
    ' No future send, so just go
    Exit Sub
  End If
  
  If sendDate = ILLEGAL_DATE Then
    ' Error
    MsgBox "Illegal future date/time expressed in '" & subject & "'"
    ' Let user modify
    Cancel = True
    Exit Sub
  End If
  
  ' Must have a deferred date/time so set-up
  Item.DeferredDeliveryTime = sendDate
  
  ' And remove the :: code from the subject line
  Dim delimPos As Integer
  delimPos = InStr(Item.subject, Deferrer.DEFER_DELIM)
  If delimPos > 0 Then
    Item.subject = Left(Item.subject, delimPos - 1)
  End If
        
Exit Sub
   
ErrorHandler:
  MsgBox Err.Description, vbOK, "Error when sending:"
End Sub



