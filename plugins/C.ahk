/* 
Plugin        : C [Standard Lintalist]
Purpose       : Insert C[har(s)]
Version       : 1.1

History:
- 1.1 Modified for improvement of nested snippets in Lintalist v1.6
- 1.0 first version

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
	 ; JJ EDIT START
	  {
			If isMaple
				PluginSnippetCChar:="    "
			Else
				PluginSnippetCChar:=A_Tab
		}
	 ; JJ EDIT END
	 Else If (PluginSnippetCChar = "enter") or (PluginSnippetCChar = "\n")
	 ; JJ EDIT START
	  {
			If isMaple
				PluginSnippetCChar:="^+j^m"
			Else
				PluginSnippetCChar:=Chr(13)
		}
	 ; JJ EDIT END
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
