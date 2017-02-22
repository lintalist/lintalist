/* 
Plugin        : Math [Standard in Lintalist for math]
Purpose       : Display text in math-mode in Maple (but not in other programs)
Version       : 1.0
*/

GetSnippetMath:
Loop
	{
	 If (InStr(Clip, "[[Math=") = 0) or (A_Index > 100) or (PluginOptions = "")
	 	Break
	 StringReplace, PluginOptions, PluginOptions, `{right`}, , All
	 StringReplace, PluginOptions, PluginOptions, `^`^, `^, All
	 StringReplace, clip, clip, %PluginText%, %PluginOptions%, All
	 PluginSnippetInput:=""
	 PluginOptions:=""
	 PluginText:=""
	 ProcessTextString:=""
	} 
Return
