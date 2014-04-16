/* 
Plugin        : Snippet [Standard Lintalist]
Purpose       : Insert contents from another snippet (this way you can chain snippets together)
Version       : 1.0
*/

GetSnippetSnippet:
	 Loop ; daisy chaining snippets
		{
		 ClipQ2=
		 If (InStr(Clip, "[[Snippet") = 0)
			Break
		 RegExMatch(Clip, "iU)\[\[Snippet=([^[]*)\]\]", ClipQ, 1)
		 Loop, % Snippet[Paste1].MaxIndex()
			{
			 ; SearchThis3:=List_%Paste1%_%A_Index%_4
			 If (Snippet[Paste1,A_Index,4] = ClipQ1) ; shorthand
				{
				 ClipQ2:=Snippet[Paste1,A_Index,1] ; part 1
				 Break
				}
			}
		 StringReplace, clip, clip, [[Snippet=%ClipQ1%]], %ClipQ2%
		 ClipQ1=
		 ClipQ2=
		}
Return