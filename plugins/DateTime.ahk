/* 
Plugin        : DateTime [Standard Lintalist]
Purpose       : Insert date and or time, including options for date & time calculations e.g. tomorrows date
Version       : 1.3

History:
- 1.3 Added Date/Time rollovers
- 1.2 Added date Locale Identifiers (LCID) v1.8 ht dbielz https://github.com/lintalist/lintalist/issues/58 
- 1.1 Modified for improvement of nested snippets in Lintalist v1.6
- 1.0 first version
*/


GetSnippetDateTime:
	Loop ; get Date & Time [[DateTime=dddd, MMMM d, yyyy|1|Days|LCID|mon-thu]]
	{
		If (InStr(Clip, "[[DateTime=") = 0) or (A_Index > 100)
			Break

		If (InStr(PluginOptions,"|"))
		{
			FormatTime, DT,, yyyyMMddHHmmss
			EnvAdd, DT, % StrSplit(PluginOptions,"|").2, % StrSplit(PluginOptions,"|").3
			DTLocale := StrSplit(PluginOptions,"|").4

			; Extract day range (e.g. mon-thu (2-5), mon-fri (2-6), etc.) from PluginOptions
			DayRange := StrSplit(PluginOptions, "|").5

			; Check the range specified by the user
			DayOfWeek := A_WDay
			FormatTime, DayOfWeek, %DT%, WDay

			If (DayRange != "")
			{
				; Define day mapping for ranges; allow for 1-7 and sun-sat
				DayMapping := {"sun": 1, "mon": 2, "tue": 3, "wed": 4, "thu": 5, "fri": 6, "sat": 7
				, 1: "sun", 2: "mon", 3: "tue", 4: "wed", 5: "thu", 6: "fri", 7: "sat"}

				; Parse the range (e.g., "m-th" -> start=m, end=th)
				DayStart := SubStr(DayRange, 1, InStr(DayRange, "-") - 1)
				DayEnd := SubStr(DayRange, InStr(DayRange, "-") + 1)

				; Transform the number to "day" to allow for 7-1 to be used for sat-sun for example
				If DayStart in 1,2,3,4,5,6,7
					DayStart:=DayMapping[DayStart]

				If DayEnd in 1,2,3,4,5,6,7
					DayEnd:=DayMapping[DayEnd]
				
				; Get the day numbers from the abbreviations
				StartDayNum := DayMapping[DayStart]
				EndDayNum := DayMapping[DayEnd]

				; Adjust if the calculated day falls outside the range
				If (DayOfWeek < StartDayNum)
				{
					; If day is before the range, move to the start of the range
					EnvAdd, DT, % StartDayNum - DayOfWeek, Days
				}
				Else If (DayOfWeek > EndDayNum)
				{
					; If day is after the range, move to the start of the next week (adjust by 7 days)
					EnvAdd, DT, % 7 - (DayOfWeek - StartDayNum), Days
				}
			DayRange := ""
			DayOfWeek := ""
			DayMapping := ""
			DayStart := ""
			DayEnd := ""
			StartDayNum := ""
			EndDayNum := ""
			}

			FormatTime, DT, %DT% %DTLocale%, % StrSplit(PluginOptions,"|").1
		}
		Else
			FormatTime, DT,, %PluginOptions%

		StringReplace, clip, clip, %PluginText%, %DT%, All
		DT := ""
		DTLocale := ""
		PluginOptions := ""
		PluginText := ""
		ProcessTextString := ""
	}
Return
