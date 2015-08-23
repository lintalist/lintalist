/* 
Plugin        : Counter [Standard Lintalist]
Purpose       : Increment and insert value of specific counter. See include\readini.ahk + SaveSettings label in lintatlist.ahk for read/write in settings.ini - manager counters via tray menu (starts include\CounterEditor.ahk)
Version       : 1.0
*/

GetSnippetCounter:
	Loop ; get counters
		{
		 If (InStr(Clip, "[[Counter=") = 0) or (A_Index > 100)
			Break
			
		 If (InStr(PluginOptions,"|"))
			{
			 CounterName:=CheckforNewCounter(StrSplit(PluginOptions,"|").1)
			 CounterMath:=StrSplit(PluginOptions,"|").2
			 LocalCounter_%CounterName% := LocalCounter_%CounterName% + CounterMath
			 If (CounterMath = 0)
			 	{
	 	 	 	 StringReplace, clip, clip, %PluginText%, % LocalCounter_%CounterName%, All
				 StringReplace, PluginText, PluginText, |0
	 	 	 	 StringReplace, clip, clip, %PluginText%, % LocalCounter_%CounterName%, All
	 	 	 	} 
	 	 	 else
	 	 	 	{
		 	 	 StringReplace, clip, clip, %PluginText%, % LocalCounter_%CounterName%
	 	 	 	}
			}
		 Else
			{
			 CounterName:=CheckforNewCounter(PluginOptions)
			 LocalCounter_%CounterName%++
			 StringReplace, clip, clip, %PluginText%, % LocalCounter_%CounterName%
			} 

		 CounterName:=""
		 CounterMath:=""
 		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""

	  }
Return

CheckforNewCounter(in)
	{
	 global
	 If InStr("," LocalCounter_0 ",", in)
	 	Return in
	 LocalCounter_0 .= in ","
	 LocalCounter_%in% = 0
	 Return in
	}
