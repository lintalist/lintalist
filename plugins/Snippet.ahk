/* 
Plugin        : Snippet [Standard Lintalist]
Purpose       : Insert contents from another snippet (this way you can chain snippets together)
Version       : 1.0
*/

GetSnippetSnippet:
	 Loop ; daisy chaining snippets
		{
		 If (InStr(Clip, "[[Snippet=") = 0) or (A_Index > 100)
			Break

		 Loop, % Snippet[Paste1].MaxIndex()
			{
			 If (Snippet[Paste1,A_Index,4] = PluginOptions) ; shorthand
				{
				 PluginOptions:=Snippet[Paste1,A_Index,1] ; part 1
				 Break
				}
			}
		 StringReplace, clip, clip, %PluginText%, %PluginOptions%, All
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""
		}
Return