/* 
Plugin     : Calendar [Standard Lintalist]
Purpose    : Select a date from a Calendar
Version    : 1.2

History:
- 1.2 Removed Goto
- 1.1 Calendar now uses Multi-select (shows two months side by side) - Lintalist v1.6
- 1.0 first version
*/

GetSnippetCalendar:
MakeCalendar:
Gui, 10:Destroy
Gui, 10:+Owner +AlwaysOnTop
Gui, 10:Add, MonthCal, vMyCalendar Multi W-2 4
Gui, 10:Add, Button, default gCalendarOK, Select Date
Gui, 10:Add, Button, xp+100 yp gCalendarCancel, Cancel
Gui, 10:Add, Text, xp+100 yp+5, (hold shift to select start-end date)
Gui, 10:Show, , Calendar
		 Loop
			{
			 If (MadeChoice = 1) or (InStr(Clip, "[[Calendar") = 0)
				{
				 MadeChoice = 0
				 Break
				}
			 Sleep, 20
			}
Return

CalendarOK: ; selected via Enter
Gui, 10:Submit
Gui, 10:Destroy
MadeChoice=1
If !InStr(MyCalendar,"-") ; just in case we remove MULTI option 
	FormatTime, PluginGetCalendar, %MyCalendar%, %PluginOptions%
Else
	{
	 FormatTime, PluginGetCalendarM1, % StrSplit(MyCalendar,"-").1, %PluginOptions%
	 FormatTime, PluginGetCalendarM2, % StrSplit(MyCalendar,"-").2, %PluginOptions%
	 If (PluginGetCalendarM1 = PluginGetCalendarM2)
		PluginGetCalendar := PluginGetCalendarM1
	 else
	 	PluginGetCalendar := PluginGetCalendarM1 " to " PluginGetCalendarM2
	 PluginGetCalendarM1:="", PluginGetCalendarM2:=""
	}	
	
StringReplace, clip, clip, %PluginText%, %PluginGetCalendar%

		 PluginGetCalendar:=""
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""

Return

CalendarCancel:
MadeChoice = 0
Sleep 50
Gui, 10:Destroy
clip:=""
Return
