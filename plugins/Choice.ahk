/* 
Plugin        : Choice [Standard Lintalist]
Purpose       : Make a selection from a list [part of code also place in lintalist.ahk and used to allow users to select a bundle]
Version       : 1.6

History:
- 1.6 You can now close/cancel it via the close button (x) in Gui
- 1.5 Added option to provide "question" by using ? in first item - @flyingaliens https://github.com/lintalist/lintalist/issues/68
- 1.4 Reverted back to Loop as it seems to works better for multiple choice plugins https://github.com/lintalist/lintalist/issues/68 - go figure
- 1.3 Added Random button (uses Random plugin)
- 1.2 Replaced loop with While and removed Goto
- 1.1 Modified for improvement of nested snippets in Lintalist v1.6
- 1.0 first version
*/

GetSnippetChoice:
;;;;;;;;;;; warning: ugly hack/code
MakeChoice:
	  ChoiceQuestion:=""
	  ChoiceHeight:=240
	  If (InStr(Clip, "[[Choice=") > 0) or (A_Index > 100)
		{
		 if RegExMatch(PluginOptions,"^\s*\?")
			{
			 ChoiceQuestion:=LTrim(StrSplit(PluginOptions,"|").1," ?`t")
			 PluginOptions:=StrReplace(PluginOptions,StrSplit(PluginOptions,"|").1 "|")
			}
		 MultipleHotkey=0
		 Gui, 10:Destroy
		 Gui, 10:+Owner +AlwaysOnTop
		 If (ChoiceQuestion = "")
			Gui, 10:Add, ListBox, w400 h200 x5 y5 vItem gChoiceMouseOK, %PluginOptions%
		 else
		 {
			Gui, 10:Add, Text, w400 h25 x5 y5, %ChoiceQuestion%
			Gui, 10:Add, ListBox, w400 h200 x5 y25 vItem gChoiceMouseOK, %PluginOptions%	
			ChoiceHeight+=25
		 }
		 Gui, 10:Add, button, gCancelChoice w100, Cancel
		 Gui, 10:Add, button, xp+110 yp w100 gChoiceRandom, &Random
		 Gui, 10:Add, button, default gChoiceOK hidden, OK
		 Gui, 10:Show, w410 h%ChoiceHeight%, Select and press enter
		 ControlSend, ListBox1, {Down}, Select and press enter
		 Loop ; ugly hack: can't use return here because, well it returns and would thus skip the gui and proceed to paste
			{
			 If (MadeChoice = 1) or (InStr(Clip, "[[Choice") = 0)
				{
				 MadeChoice = 0
				 Break
				}
			 Sleep 20 ; needed for ahk_l, if no sleep CPU usages jumps to 50%, no responding to hotkeys and no tray menu, no longer remember the revision of AHK_L this happened with or if it still 			 ToolTip % A_Index
			}
		}	
;;;;;;;;;;; /end warning: ugly hack/code
Return

ChoiceRandom:
StringReplace, clip, clip, %PluginText%, [[random=%PluginOptions%]],All
MadeChoice = 1
PluginText:=""
PluginOptions:=""
ChoiceQuestion:=""
ChoiceHeight:=""
Gui, 10:Destroy
Gosub, ProcessText ; We changed clip and cleared PluginText and PluginOptions so need to process Random first (ProcessText)
Return

CancelChoice:
MadeChoice = 1
PluginText:=""
PluginOptions:=""
ChoiceQuestion:=""
ChoiceHeight:=""
Gui, 10:Destroy
Gosub, CheckTypedLoop
Return
