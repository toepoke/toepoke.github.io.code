Attribute VB_Name = "Utils"
Public Function ReplaceMultiples(inp As String, ch As String) As String
    Dim out As String
    
    out = inp
    While InStr(1, out, ch & ch) > 0
        out = Replace(out, ch & ch, ch)
    Wend

    ReplaceMultiples = out
End Function

