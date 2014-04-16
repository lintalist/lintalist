/* 
Plugin        : C [Standard Lintalist]
Purpose       : Insert C[har(s)]
Version       : 1.0
*/

GetSnippetC:
Loop ; get user input with optional default response
	{
	 If (InStr(Clip, "[[C=") = 0)
	 	Break
	 RegExMatch(Clip, "isU)\[\[C=(.*)\]\]", ClipQ, 1)
 	 OrgClipQ1:=ClipQ1
	 If (InStr(ClipQ1,"|"))
		{
		 StringSplit, ClipQ1, ClipQ1, |
		 ClipQ1:=ClipQ11  ; clipq11 and clip12
		}

	 CRepeat:=1	
	 If ClipQ12
		CRepeat:=ClipQ12
	 If (ClipQ1 = "space") or (ClipQ1 = "\s")
		ClipQ1:=" "
	 Else If (ClipQ1 = "tab") or (ClipQ1 = "\t")	
		ClipQ1:=A_Tab
	 Else If (ClipQ1 = "enter") or (ClipQ1 = "\n")
		ClipQ1:=Chr(13)
	 Loop, % CRepeat
		ClipQ2 .= ClipQ1
	 StringReplace, clip, clip, [[C=%OrgClipQ1%]], %ClipQ2%, All
	 OrgClipQ1=
	 ClipQ1=
	 ClipQ10=
	 ClipQ11=
	 ClipQ12=
	 ClipQ2=
	 CRepeat=
	} 
Return
