/* 
Plugin        : Choice [Standard Lintalist]
Purpose       : Make a selection from a list [part of code also placed in lintalist.ahk and used to allow users to select a bundle]
Version       : 1.7

History:
- 1.7 Added option to "filter as you type" by using ! in first item (similar to question using ?) - uses SetEditCueBanner()
      Incorporate CancelPlugin (avoids SoundPlay and return nicely)
- 1.6 You can now close/cancel it via the close button (x) in Gui
- 1.5 Added option to provide "question" by using ? in first item - @flyingaliens https://github.com/lintalist/lintalist/issues/68
- 1.4 Reverted back to Loop as it seems to works better for multiple choice plugins https://github.com/lintalist/lintalist/issues/68 - go figure
- 1.3 Added Random button (uses Random plugin)
- 1.2 Replaced loop with While and removed Goto
- 1.1 Modified for improvement of nested snippets in Lintalist v1.6
- 1.0 first version
*/

GetSnippetChoice:


MakeChoice:
	  ChoiceQuestion:=""
	  ChoiceFilter:=""
	  If (InStr(Clip, "[[Choice=") > 0) ; or (A_Index > 100)
		{
		 if RegExMatch(PluginOptions,"^\s*[\?\!]")
			{
			 ChoiceQuestion:=LTrim(StrSplit(PluginOptions,"|").1," ?`t")
			 If (RegExMatch(ChoiceQuestion,"^\s*[\!]") or RegExMatch(StrSplit(PluginOptions,"|").1,"^\s*[\!]"))
				{
				 ChoiceFilter:=1
				 ChoiceQuestion:=LTrim(ChoiceQuestion,"!")
				}
			 PluginOptions:=StrReplace(PluginOptions,StrSplit(PluginOptions,"|").1 "|")
			}
		 MultipleHotkey=0
		 if (ChoiceQuestion = "")
			ChoiceQuestion:="Select and press enter"
		 Gui, 10:Destroy
		 Gui, 10:+Owner +AlwaysOnTop +Resize +MinSize
		 Gui, 10:Default
		 Gui, 10:font, s%FontSize%
		 Gui, 10:Add, Edit,  x5 y5 w400 vChoiceFilterText gChoiceFilterText hwndHED1, 
		 Gui, 10:Add, ListBox,     w400 R10 vItem gChoiceMouseOK, %PluginOptions%
		 Gui, 10:Add, button,   vChoiceCancel gCancelChoice, &Cancel
		 Gui, 10:Add, button,   xp+90 w80 vChoiceRandom gChoiceRandom, &Random
		 Gui, 10:Add, Checkbox, xp+90 yp+10 w120 vChoiceAutoCenter gChoiceAutoCenter, Auto Center
		 Gui, 10:Add, button,   xp yp default vChoiceOK gChoiceOK hidden, OK

		 If ChoiceAutoCenter
			GuiControl,,ChoiceAutoCenter, 1
		 DetectHiddenWindows, On
		 If !ChoiceFilter
			{
			 GuiControl, Disable, Edit1
			 GuiControl, Hide, Edit1
			 Gui, 10:Add, Text,  x5 y10 w400, %ChoiceQuestion%
			}
		 Gui, 10:Font,
		 GuiCheckXYPos()
		 If !ChoiceAutoCenter
			{
			 Try
				{
				 Gui, 10:Show, hide w410 x%ChoiceX% y%ChoiceY%, Select and press enter
				 WinMove, Select and press enter, , %ChoiceX%, %ChoiceY%, %ChoiceWidth%, %ChoiceHeight%
				 Gui, 10:Show
				}
			 Catch
				Gui, 10:Show, w410 Center, Select and press enter
			}
		 else
			Gui, 10:Show, w410 Center, Select and press enter	
		 SetEditCueBanner(HED1, "Filter: " ChoiceQuestion)
		 DetectHiddenWindows, Off
		 ControlSend, ListBox1, {Down}, Select and press enter
		 WinWaitClose, Select and press enter
		 MadeChoice = 1
/*
		 Loop ; ugly hack: can't use return here because, well it returns and would thus skip the gui and proceed to paste
			{
			 If (MadeChoice = 1) or (InStr(Clip, "[[Choice") = 0)
				{
				 MadeChoice = 0
				 Break
				}
			 Sleep 20 ; needed for ahk_l, if no sleep CPU usages jumps to 50%, no responding to hotkeys and no tray menu, no longer remember the revision of AHK_L this happened with or if it still 			 ToolTip % A_Index
			}
*/
		}

Return

10GuiSize:
If Gui10NoResize
	return

Gui, 10:Default
AutoXYWH("w"   , "ChoiceFilterText")
AutoXYWH("w h" , "Item")
AutoXYWH("y"   , "ChoiceCancel")
AutoXYWH("y"   , "ChoiceRandom")
AutoXYWH("y"   , "ChoiceAutoCenter")
Return

ChoiceFilterText:
ControlGetText, PluginsFilterText, Edit1, Select and press enter
Loop, Parse, PluginOptions, |
	{
	 re:="iUms)" PluginsFilterText
	 if InStr(PluginsFilterText,A_Space) ; prepare regular expression to ensure search is done independent on the position of the words
		re:="iUms)(?=.*" RegExReplace(PluginsFilterText,"iUms)(.*)\s","$1)(?=.*") ")"
	 if RegExMatch(A_LoopField,re) 
		PluginOptionsResults .= A_LoopField "|"
	}
GuiControl, 10:, ListBox1, |%PluginOptionsResults%
PluginsFilterText:=""
PluginOptionsResults:=""
Return

ChoiceRandom:
If ChoiceFilter
	{
	 ControlGet, PluginOptions, List, Focused, ListBox1,  Select and press enter
	 PluginOptions:=StrReplace(PluginOptions,"`n","|")
	}
StringReplace, clip, clip, %PluginText%, [[random=%PluginOptions%]],All
MadeChoice = 1
PluginText:=""
PluginOptions:=""
ChoiceQuestion:=""
PluginsFilterText:=""
PluginOptionsResults:=""
Gosub, 10GuiSavePos
Gui, 10:Destroy
Return

CancelChoice:
MadeChoice = 1
PluginText:=""
PluginOptions:=""
ChoiceQuestion:=""
PluginsFilterText:=""
PluginOptionsResults:=""
Gosub, 10GuiSavePos
Gui, 10:Default
Gui, 10:Destroy
Sleep 50
clip:=""
CancelPlugin:=1
; Gosub, CheckTypedLoop ; revert https://github.com/lintalist/lintalist/issues/52 no longer needed?
Return

10GuiSavePos:
WinGetPos, ChoiceX, ChoiceY, ChoiceWidth, ChoiceHeight, Select and press enter
Return

ChoiceWindowPosition:
IniRead, ChoiceAutoCenter, %A_ScriptDir%\session.ini, choice, ChoiceAutoCenter, 1
IniRead, ChoiceX         , %A_ScriptDir%\session.ini, choice, ChoiceX, 300
IniRead, ChoiceY         , %A_ScriptDir%\session.ini, choice, ChoiceY, 300
IniRead, ChoiceWidth     , %A_ScriptDir%\session.ini, choice, ChoiceWidth, 410
IniRead, ChoiceHeight    , %A_ScriptDir%\session.ini, choice, ChoiceHeight, 300
Return

ChoiceWindowPositionSave:
IniWrite, %ChoiceX%      , %A_ScriptDir%\session.ini, choice, ChoiceX
IniWrite, %ChoiceY%      , %A_ScriptDir%\session.ini, choice, ChoiceY
IniWrite, %ChoiceWidth%  , %A_ScriptDir%\session.ini, choice, ChoiceWidth
IniWrite, %ChoiceHeight% , %A_ScriptDir%\session.ini, choice, ChoiceHeight
Return

ChoiceAutoCenter:
ChoiceAutoCenter:=!ChoiceAutoCenter
IniWrite, %ChoiceAutoCenter%, %A_ScriptDir%\session.ini, choice, ChoiceAutoCenter
return

; just me @ https://autohotkey.com/board/topic/76540-function-seteditcuebanner-ahk-l/
SetEditCueBanner(HWND, Cue) {  ; requires AHL_L
   Static EM_SETCUEBANNER := (0x1500 + 1)
   Return DllCall("User32.dll\SendMessageW", "Ptr", HWND, "Uint", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)
}
