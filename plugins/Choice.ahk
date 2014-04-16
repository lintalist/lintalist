/* 
Plugin        : Choice [Standard Lintalist]
Purpose       : Make a selection from a list [part of code also place in lintalist.ahk and used to allow users to select a bundle]
Version       : 1.0
*/

GetSnippetChoice:
;;;;;;;;;;; warning: ugly hack/code
MakeChoice:
	  If (InStr(Clip, "[[Choice") > 0)
		{
		 RegExMatch(Clip, "iU)\[\[Choice=([^[]*)\]\]", ClipQ, 1)
		 MultipleHotkey=0
		 Gui, 10:Destroy
		 Gui, 10:+Owner +AlwaysOnTop
		 Gui, 10:Add, ListBox, w400 h200 x5 y5 vItem gChoiceMouseOK, %ClipQ1%
		 Gui, 10:Add, button, gCancelChoice, Cancel
		 Gui, 10:Add, button, default gChoiceOK hidden, OK
		 Gui, 10:Show, w410 h240, Select and press enter
		 ControlSend, ListBox1, {Down}, Select and press enter
		 Loop ; ugly hack: can't use return here because, well it returns and would thus skip the gui and proceed to paste
			{
			 If (MadeChoice = 1) or (InStr(Clip, "[[Choice") = 0)
				{
				 MadeChoice = 0
				 Break
				}
			 Sleep 20 ; needed for ahk_l, if no sleep CPU usages jumps to 50%, no responding to hotkeys and no tray menu, no longer remember the revision of AHK_L this happened with or if it still required
			}
		}	
If (InStr(Clip, "[[Choice") > 0)
		Goto, MakeChoice		  
;;;;;;;;;;; /end warning: ugly hack/code
Return

CancelChoice:
Gui, 10:Destroy	
Return
