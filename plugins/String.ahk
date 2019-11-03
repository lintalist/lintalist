/* 
Plugin        : String [Standard Lintalist]
Purpose       : Transform text to upper, lower, sentence, title case, trim (basically a wrapper for ClipSelExFunc)
Version       : 1.0

History:
- 1.0 first version
*/

GetSnippetString:
	 Loop
		{
		 If (InStr(Clip, "[[String=") = 0) or (A_Index > 100)
			Break
		 PluginText:=StrSplit(PluginOptions,"|").1
		 PluginOptions:=StrSplit(PluginOptions,"|").2
		 PluginSnippetString:=ClipSelEx(PluginText,PluginOptions)
		 StringReplace, clip, clip, %ProcessTextString%, %PluginSnippetString%, All
		}
	 PluginSnippetString:=""
	 PluginText:=""
	 PluginOptions:=""
	 ProcessTextString:=""
Return
