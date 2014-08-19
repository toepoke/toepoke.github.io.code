Attribute VB_Name = "FolderHelper"

''' Displays a message box with the location of the currently open
''' e-mail item
Public Sub WhereAmI()
  Dim folder As MAPIFolder
  
  Set folder = GetItemFolder()
  If folder Is Nothing Then
    MsgBox "Sorry, couldn't find the folder you're in.  Are you in the Preview Pane or have a non e-mail item selected?"
  Else
    InputBox folder, "Your folder location", folder.FolderPath
  End If
  
End Sub


''' Sets the selected folder in the Outlook view to the
''' folder of the currently open e-mail item
'TODO: Public
Public Sub SyncOutlookToMailItemLocation()
  Dim folder As MAPIFolder
  Dim ns As Outlook.NameSpace, exp As Outlook.Explorer, inbox As folder
  
  
  Set folder = GetItemFolder()
  If folder Is Nothing Then
    MsgBox "Sorry, couldn't find the folder you're in.  Are you in the Preview Pane or have a non e-mail item selected?"
    Exit Sub
  End If
  
  Set ns = Application.GetNamespace("MAPI")
  Set exp = Application.ActiveExplorer
  
  Set exp.CurrentFolder = folder
  
End Sub


''' Attempts to identify the folder where the currently
''' open email item lives in your folder structure
Private Function GetItemFolder()
  Dim inspector As inspector
  Dim foundFolder As MAPIFolder
  
  If Application.ActiveInspector Is Nothing Then
    ' Prob still in Preview Pane
    Set GetItemFolder = Nothing
    Exit Function
  End If
  
  Set inspector = Application.ActiveInspector
  If Not inspector Is Nothing Then
    Dim email As mailItem
    
    If TypeName(inspector.CurrentItem) = "MailItem" Then
      Set email = inspector.CurrentItem
      Set foundFolder = email.Parent
    End If
    
  End If

  Set GetItemFolder = foundFolder
End Function

