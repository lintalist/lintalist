/* 
Plugin        : C [Standard Lintalist]
Purpose       : Insert C[har(s)]
Version       : 1.0
*/

GetSnippetC:
Loop ; get user input with optional default response
	{
	 PluginSnippetCString:=""
	 If (InStr(Clip, "[[C=") = 0) or (A_Index > 100)
	 	Break
	 
	 PluginSnippetCChar:=StrSplit(PluginOptions,"|").1
	 PluginSnippetCRepeat:=StrSplit(PluginOptions,"|").2
	 If (PluginSnippetCRepeat = "")
		PluginSnippetCRepeat:=1
	 If (PluginSnippetCChar = "space") or (PluginSnippetCChar = "\s")
		PluginSnippetCChar:=" "
	 Else If (PluginSnippetCChar = "tab") or (PluginSnippetCChar = "\t")	
		PluginSnippetCChar:=A_Tab
	 Else If (PluginSnippetCChar = "enter") or (PluginSnippetCChar = "\n")
		PluginSnippetCChar:=Chr(13)
	 Loop, % PluginSnippetCRepeat
		PluginSnippetCString .= PluginSnippetCChar
	 StringReplace, clip, clip, %PluginText%, %PluginSnippetCString%, All

	 PluginSnippetCString:=""
	 PluginSnippetCChar:=""
	 PluginSnippetCRepeat:=""
	 PluginOptions:=""
	 PluginText:=""
	 ProcessTextString:=""

	} 
Return
