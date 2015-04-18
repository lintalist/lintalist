/* 
Plugin        : Calendar [Standard Lintalist]
Purpose       : Select a date from a Calendar
Version       : 1.0
*/

GetSnippetCalendar:
MakeCalendar:
RegExMatch(Clip, "iU)\[\[Calendar=([^[]*)\]\]", ClipQ, 1)

Gui, 10:Destroy
Gui, 10:+Owner +AlwaysOnTop
Gui, 10:Add, MonthCal, vMyCalendar 4
Gui, 10:Add, Button, default gCalendarOK, Select Date
Gui, 10:Add, Button, xp+100 yp gCalendarCancel, Cancel
Gui, 10:Show, , Calendar
		 Loop ; ugly hack: can't use return here because, well it returns and would thus skip the gui and proceed to paste
			{
			 If (MadeChoice = 1) or (InStr(Clip, "[[Calendar") = 0)
				{
				 MadeChoice = 0
				 Break
				}
			 Sleep 20 ; needed for ahk_l, if no sleep CPU usages jumps to 50%, no responding to hotkeys and no tray menu, no longer remember the revision of AHK_L this happened with or if it still required
			}
If (InStr(Clip, "[[Calendar") > 0)
		Goto, MakeCalendar
Return

CalendarOK: ; selected via Enter
Gui, 10:Submit
Gui, 10:Destroy
MadeChoice=1
FormatTime, ClipQ2, %MyCalendar%, %ClipQ1%
StringReplace, clip, clip, [[Calendar=%ClipQ1%]], %ClipQ2%
ClipQ1=
ClipQ2=
Return

CalendarCancel:
MadeChoice = 0
Sleep 50
Gui, 10:Destroy
clip:=""
ClipQ1=
ClipQ2=
Return
