/* 
Plugin        : Counter [Standard Lintalist]
Purpose       : Increment and insert value of specific counter. See include\readini.ahk + SaveSettings label in lintalist.ahk for read/write in settings.ini - manager counters via tray menu (starts include\CounterEditor.ahk)
Version       : 1.2

History:
- 1.2 add Counter reset option [[counter=name|value|resetvalue]]
- 1.1 create counters "on the fly" - Lintalist v1.6
- 1.0 first version

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
			 CounterReset:=StrSplit(PluginOptions,"|").3
			 If (CounterReset <> "")
				{
				 LocalCounter_%CounterName% := CounterReset
				 If (CounterMath <> "")
					{
					 StringReplace, clip, clip, %PluginText%, [[counter=%CounterName%|%CounterMath%]], All ; remove reset from snippet
					 PluginText=[[counter=%CounterName%|%CounterMath%]]
					}
				 else
					{
					 StringReplace, clip, clip, %PluginText%, [[counter=%CounterName%]], All ; remove reset from snippet
					 PluginText=[[counter=%CounterName%]]
					}
				}
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
		 CounterReset:=""
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""

		}
Return

/*
GetSnippetCounterReset:
	Loop ; get counters
		{
		 If (InStr(Clip, "[[CounterReset=") = 0) or (A_Index > 100)
			Break

		 CounterName:=CheckforNewCounter(StrSplit(PluginOptions,"|").1)
		 CounterMath:=StrSplit(PluginOptions,"|").2
		 If (CounterMath = "")
		 	CounterMath:=0
		 LocalCounter_%CounterName% := CounterMath
		 StringReplace, clip, clip, %PluginText%, , All ; remove reset from snippet

		 CounterName:=""
		 CounterMath:=""
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""
		}
Return
*/

CheckforNewCounter(in)
	{
	 global
	 If InStr("," LocalCounter_0 ",", in)
	 	Return in
	 LocalCounter_0 .= in ","
	 LocalCounter_%in% = 0
	 Return in
	}
