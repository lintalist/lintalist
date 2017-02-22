/* 
Plugin        : Underline [Standard in Lintalist for math]
Purpose       : Underline text in Maple (but not in other programs)
Version       : 1.0
*/

GetSnippetUnderline:
Loop
	{
	 If (InStr(Clip, "[[Underline=") = 0) or (A_Index > 100) or (PluginOptions = "")
	 	Break
	 StringReplace, clip, clip, %PluginText%, %PluginOptions%, All
	 PluginSnippetInput:=""
	 PluginOptions:=""
	 PluginText:=""
	 ProcessTextString:=""
	} 
Return
