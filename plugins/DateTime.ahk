/* 
Plugin        : DateTime [Standard Lintalist]
Purpose       : Insert date and or time, including options for date & time calculations e.g. tomorrows date
Version       : 1.0
*/


GetSnippetDateTime:
 	 Loop ; get Data & Time [[DateTime=yy mm dd|2|days]]
		{
		 If (InStr(Clip, "[[DateTime=") = 0)
			Break
		 RegExMatch(Clip, "iU)\[\[DateTime=([^[]*)\]\]", ClipQ, 1)
		 If (InStr(ClipQ1,"|"))
			{
			 StringSplit, ClipQ1, ClipQ1, |
			 FormatTime, DT,, yyyyMMddHHmmss
			 EnvAdd, DT, %ClipQ12%, %ClipQ13%
			 FormatTime, DT,%DT%, %ClipQ11%
			}
		 Else
			FormatTime, DT,, %ClipQ1%
		 StringReplace, clip, clip, [[DateTime=%ClipQ1%]], %DT%
		 DT=
		 ClipQ1=
		 ClipQ11=
		 ClipQ12=
		 ClipQ13=
	  } 
Return