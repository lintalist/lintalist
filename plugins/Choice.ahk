/* 
Plugin        : Choice [Standard Lintalist]
Purpose       : Make a selection from a list [part of code also place in lintalist.ahk and used to allow users to select a bundle]
Version       : 1.3

History:
- 1.3 Added Random button (uses Random plugin)
- 1.2 Replaced loop with While and removed Goto
- 1.1 Modified for improvement of nested snippets in Lintalist v1.6
- 1.0 first version
*/

GetSnippetChoice:
MakeChoice:
	  If (InStr(Clip, "[[Choice=") > 0) or (A_Index > 100)
		{
		 MultipleHotkey=0
		 Gui, 10:Destroy
		 Gui, 10:+Owner +AlwaysOnTop
		 Gui, 10:Add, ListBox, w400 h200 x5 y5 vItem gChoiceMouseOK, %PluginOptions%
		 Gui, 10:Add, button, gCancelChoice w100, &Cancel
		 Gui, 10:Add, button, xp+110 yp w100 gChoiceRandom, &Random
		 Gui, 10:Add, button, default gChoiceOK hidden, OK
		 Gui, 10:Show, w410 h240, Select and press enter
		 ControlSend, ListBox1, {Down}, Select and press enter
		 While (MadeChoice <> 1) or (InStr(Clip, "[[Choice") <> 0)
			Sleep 20
		 MadeChoice = 0
		}
Return

ChoiceRandom:
StringReplace, clip, clip, %PluginText%, [[random=%PluginOptions%]],All
Gui, 10:Destroy
MadeChoice = 1
PluginText:=""
PluginOptions:=""
Gosub, CheckTypedLoop
Return

CancelChoice:
PluginText:=""
PluginOptions:=""
Gui, 10:Destroy
Gosub, CheckTypedLoop
Return
