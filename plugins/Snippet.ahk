/*
Plugin        : Snippet [Standard Lintalist]
Purpose       : Insert contents from another snippet (this way you can chain snippets together)
Version       : 1.2

History:
- 1.2 select part1, part2, script or shorthand - https://github.com/lintalist/lintalist/issues/304
- 1.1 Modified for improvement of nested snippets in Lintalist v1.6
- 1.0 first version
*/

GetSnippetSnippet:
	 Loop ; daisy chaining snippets
		{
		 If (InStr(Clip, "[[Snippet=") = 0) or (A_Index > 100)
			Break

		 ; default or 1 = part1
		 ; 2 = part2
		 ; 3 = script
		 ; 4 = shorthand

		 If InStr(PluginOptions,"|")
			{
			 PluginOptionsSection:=StrSplit(PluginOptions,"|").2
			 PluginOptions:=StrSplit(PluginOptions,"|").1
			}

		 If (PluginOptionsSection = "") OR !RegExMatch(PluginOptionsSection,"[1234]")
			PluginOptionsSection:=1

		 Loop, % Snippet[Paste1].MaxIndex()
			{
			 If (Snippet[Paste1,A_Index,4] = PluginOptions) ; shorthand
				{
				 PluginOptions:=Snippet[Paste1,A_Index,PluginOptionsSection]
				 If (PluginOptionsSection = 3)
					Script:=Snippet[Paste1,A_Index,5]
				 Break
				}
			}

		 StringReplace, clip, clip, %PluginText%, %PluginOptions%, All
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""
		 PluginOptionsSection:=""
		}
Return