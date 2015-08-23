/* 
Plugin        : Input [Standard Lintalist]
Purpose       : Ask for user Input using a simple InputBox
Version       : 1.0
*/

GetSnippetInput:
Loop ; get user input with optional default response
	{
	 If (InStr(Clip, "[[Input=") = 0) or (A_Index > 100) or (PluginOptions = "")
	 	Break
	 InputBox, PluginSnippetInput, % StrSplit(PluginOptions,"|").1, % StrSplit(PluginOptions,"|").1, , 400, 150, , , , , % StrSplit(PluginOptions,"|").2
	 StringReplace, clip, clip, %PluginText%, %PluginSnippetInput%, All
	 PluginSnippetInput:=""
	 PluginOptions:=""
	 PluginText:=""
	 ProcessTextString:=""
	} 
Return
