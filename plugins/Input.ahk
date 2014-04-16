/* 
Plugin        : Input [Standard Lintalist]
Purpose       : Ask for user Input using a simple InputBox
Version       : 1.0
*/

GetSnippetInput:
Loop ; get user input with optional default response
	{
	 If (InStr(Clip, "[[Input") = 0)
	 	Break
	 ; RegExMatch(Clip, "iU)\[\[Input=(.*)\]\]", ClipQ, 1)
	 RegExMatch(Clip, "iU)\[\[Input=([^\[\]]+)\]\]", ClipQ, 1) ; better for nested inputs?
 	 OrgClipQ1:=ClipQ1
	 If (InStr(ClipQ1,"|"))
		{
		 StringSplit, ClipQ1, ClipQ1, |
		 ClipQ1:=ClipQ11
		}
	 InputBox, ClipQ2, %ClipQ1%, %ClipQ1%, , 400, 150, , , , , %ClipQ12%
	 StringReplace, clip, clip, [[Input=%OrgClipQ1%]], %ClipQ2%, All
	 OrgClipQ1=
	 ClipQ1=
	 ClipQ11=
	 ClipQ12=
	 ClipQ2=
	} 
Return
