/* 
Plugin        : Counter [Standard Lintalist]
Purpose       : Increment and insert value of specific counter. See include\readini.ahk + SaveSettings label in lintatlist.ahk for read/write in settings.ini - manager counters via tray menu (starts include\CounterEditor.ahk)
Version       : 1.0
*/

GetSnippetCounter:
	Loop ; get Data & Time [[DateTime=yy mm dd|2|days]]
		{
		 If (InStr(Clip, "[[Counter=") = 0)
			Break
		 RegExMatch(Clip, "iU)\[\[Counter=([^[]*)\]\]", ClipQ, 1)
		 If (InStr(ClipQ1,"|"))
			{
			 StringSplit, ClipQ1, ClipQ1, |
			 LocalCounter_%ClipQ11% := LocalCounter_%ClipQ11% + ClipQ12
			 ClipQ2:=% LocalCounter_%ClipQ11%
			}
		 Else
			{
			 LocalCounter_%ClipQ1%++
			 ClipQ2:=% LocalCounter_%ClipQ1%
			} 
		 StringReplace, clip, clip, [[Counter=%ClipQ1%]], %ClipQ2%
		 ClipQ1=
		 ClipQ2=
		 ClipQ11=
		 ClipQ12=
	  }
Return