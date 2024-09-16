﻿/* 
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
	Loop ; get Date & Time [[DateTime=dddd, MMMM d, yyyy|1|Days|m-th]]
	{
		If (InStr(Clip, "[[DateTime=") = 0) or (A_Index > 100)
			Break

		If (InStr(PluginOptions,"|"))
		{
			FormatTime, DT,, yyyyMMddHHmmss
			EnvAdd, DT, % StrSplit(PluginOptions,"|").2, % StrSplit(PluginOptions,"|").3
			DTLocale := StrSplit(PluginOptions,"|").4

			; Extract day range (e.g. m-th, m-f, etc.) from PluginOptions
			DayRange := StrSplit(PluginOptions, "|").5

			; Check the range specified by the user
			DayOfWeek := A_WDay
			FormatTime, DayOfWeek, %DT%, WDay

			If (DayRange != "")
			{
				; Define day mapping for ranges
				DayMapping := {"su": 1, "m": 2, "tu": 3, "w": 4, "th": 5, "f": 6, "sa": 7}

				; Parse the range (e.g., "m-th" -> start=m, end=th)
				DayStart := SubStr(DayRange, 1, InStr(DayRange, "-") - 1)
				DayEnd := SubStr(DayRange, InStr(DayRange, "-") + 1)

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
