/* 
Plugin        : File [Standard Lintalist]
Purpose       : Insert the contents of a file
Version       : 1.0
*/

GetSnippetFile:
 	 Loop ; get Text from File
		{
		 If (InStr(Clip, "[[File=") = 0)
			Break
		 RegExMatch(Clip, "iU)\[\[File=([^[]*)\]\]", ClipQ, 1)
		 FileRead, ClipQ2, %ClipQ1%
		 StringReplace, clip, clip, [[File=%ClipQ1%]], %ClipQ2%
		 ClipQ1=
		 ClipQ2=
		}
Return