/*
Plugin        : Choice [Standard Lintalist]
Purpose       : Make a selection from a list [part of code also placed in lintalist.ahk and used to allow users to select a bundle]
Version       : 2.2

History:
- 2.2 Image Preview window with filelist - https://github.com/lintalist/lintalist/issues/239 (only works with fullpath option, P).
- 2.1 Check if PluginOptionsResults is empty, if so, set the font to bold and update the listbox -- https://github.com/lintalist/lintalist/pull/258/files
      Addition: ChoiceInput checkbox so it can be user choice?
      and adding -SysMenu https://github.com/lintalist/lintalist/discussions/260
- 2.0 Automatically remove empty entries in Listbox (||* -> |) - to include an empty entry make it the first option/entry
- 1.9 Adding x/y position for listbox results to prevent possibly incorrect position of listbox.
- 1.8 Fix for Cancel/Esc not storing position properly, and try to prevent incorrect Listbox heights using Gui10ListboxCheckPosition()
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

doc := ComObjCreate("htmlfile")
FileRead, htmltemplate, %A_ScriptDir%\docs\previewtemplate.htm
htmdoc:=StrReplace(htmltemplate,"--content--","Hello")
; just make sure we set it to prevent the listbox overlapping the cancel/random/autocenter options
If (ChoiceAutoCenter = "")
	{
	 ChoiceAutoCenter:=1
	 Gosub, ChoiceAutoCenterWrite
	}


Gosub, PreviewWindowPosition

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
		 PluginOptions:=RegExReplace(PluginOptions,"\|\|*","|",,,2)
		 MultipleHotkey=0
		 if (ChoiceQuestion = "")
			ChoiceQuestion:="Select and press enter"
		 Gui, 10:Destroy
		 Gui, 10:+Owner +AlwaysOnTop +Resize +MinSize -SysMenu
		 Gui, 10:Default
		 Gui, 10:font, s%FontSize%
		 Gui, 10:Add, Edit,     x5 y5 w400 vChoiceFilterText gChoiceFilterText hwndHED1,
		 Gui, 10:Add, ListBox,  xp yp+30 w400 R10 vItem gChoiceMouseOK, %PluginOptions%
		 Gui, 10:Add, button,   w70       vChoiceCancel gCancelChoice, &Cancel
		 Gui, 10:Add, button,   xp+75 w80 vChoiceRandom gChoiceRandom, &Random
		 Gui, 10:Add, Checkbox, xp+90  yp-5 w106 vChoiceAutoCenter gChoiceAutoCenter, &Auto Center
		 Gui, 10:Add, Checkbox, xp+110 yp   w130 vChoiceInput gChoiceInput, &Use as [[Input]]
		 ;Gui, 10:Add, button  , xp+130 yp   w130 vPreview gTogglePreview, 👁 View
		 Gui, 10:Add, button,   xp yp default vChoiceOK gChoiceOK hidden, OK

		 Gui, PreviewChoice:Destroy
		 Gui, PreviewChoice:Default
		 Gui, PreviewChoice:+ToolWindow +Border -Sysmenu +AlwaysOnTop
;		 Gui, PreviewChoice:Add, Picture,     x5 y5 w400 h400 vPreviewChoiceText
		 Gui, PreviewChoice:Add, ActiveX, w450 h405 x5 y5 vdoc, HTMLFile
		 If RegExMatch(PluginOptions,"i)[a-z]:\\") ; there seems to be a file path in the options
			Gosub, PreviewChoiceShow
			
		 If ChoiceAutoCenter
			GuiControl,10:,ChoiceAutoCenter, 1
		 If ChoiceInput
			GuiControl,10:,ChoiceInput, 1
		 DetectHiddenWindows, On
		 If !ChoiceFilter
			{
			 GuiControl, Disable, Edit1
			 GuiControl, Hide, Edit1
			 Gui, 10:Add, Text, x5 y10 w400, %ChoiceQuestion%
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
				Gui, 10:Show, w410 Center, Select and press enter - Lintalist (choice plugin)
			}
		 else
			Gui, 10:Show, w410 Center, Select and press enter - Lintalist (choice plugin)
		 ControlGet, item, List, Focused, ListBox1,  Select and press enter
		 If InStr(item,"`n") ; we may get all the results of the "typing to filter" so assume we want first result
			item:=Trim(StrSplit(item,"`n").1,"`n`r")
		 Gosub, UpdatePreview

		 Gui10ListboxCheckPosition("Select and press enter")
		 SetEditCueBanner(HED1, "Filter: " ChoiceQuestion " (Ctrl+f)")
		 DetectHiddenWindows, Off
		 ControlSend, ListBox1, {Down}, Select and press enter
		 WinWaitClose, Select and press enter
		 MadeChoice = 1
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
AutoXYWH("y"   , "ChoiceInput")
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

; https://github.com/lintalist/lintalist/pull/258/files
; Check if PluginOptionsResults is empty, if so, set the font to bold and update the listbox
; Addition: ChoiceInput checkbox so it can be user choice
if (PluginOptionsResults = "") and (ChoiceInput)
{
	Gui, 10:Font, Bold
	GuiControl, Font, Item
	PluginOptionsResults := PluginsFilterText
}
else
{
	Gui, 10:Font, s%FontSize% Normal  ; Reset to normal font if there are matches
	GuiControl, Font, Item
}

GuiControl, 10:, ListBox1, |%PluginOptionsResults%
PluginsFilterText:=""
PluginOptionsResults:=""
Gui, 10:Submit,NoHide
If (item = "") ; if we didn't focus on results list while "typing to filter" in Choice it may return empty
	{
	 ControlGet, item, List, Focused, ListBox1,  Select and press enter
	 If InStr(item,"`n") ; we may get all the results of the "typing to filter" so assume we want first result
		item:=Trim(StrSplit(item,"`n").1,"`n`r")
	}
Gosub, UpdatePreview
Return

UpdatePreview:
Gui, PreviewChoice:Default
SplitPath, item, , , OutExtension
if OutExtension in bmp,gif,ico,jpg,jpeg,png
	htmdoc:=StrReplace(htmltemplate,"--content--","<img src=file:///" StrReplace(StrReplace(item," ","%20"),"\","/") "  >")
else if OutExtension in txt,md,htm,html,shtm,shtml,css,ahk,cmd
	{
	 FileRead, htmltextdata, %item%
	 htmdoc:=StrReplace(htmltemplate,"--content--","<pre><code>" htmltextdata "</code></pre>")
	}
else
	htmdoc:=StrReplace(htmltemplate,"--content--","no preview possible")
doc.write(htmdoc)
doc.close()
Gui, 10:Default
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
Gosub, PreviewChoiceGuiClose
Gosub, 10GuiSavePos
Gui, 10:Default
Gui, 10:Destroy
Gui, PreviewChoice:Destroy
Sleep 50
clip:=""
CancelPlugin:=1
; Gosub, CheckTypedLoop ; revert https://github.com/lintalist/lintalist/issues/52 no longer needed?
Return

PreviewChoiceGuiClose:
IfWinNotExist, preview ahk_class AutoHotkeyGUI
	Return
WinGetPos, PreviewX, PreviewY, , , preview ahk_class AutoHotkeyGUI
IniWrite, %PreviewX%      , %A_ScriptDir%\session.ini, choice, PreviewX
IniWrite, %PreviewY%      , %A_ScriptDir%\session.ini, choice, PreviewY
Return

PreviewWindowPosition:
IniRead, PreviewX         , %A_ScriptDir%\session.ini, choice, PreviewX, 10
IniRead, PreviewY         , %A_ScriptDir%\session.ini, choice, PreviewY, 10
Return

10GuiSavePos:
IfWinExist, Select and press enter
	WinGetPos, ChoiceX, ChoiceY, ChoiceWidth, ChoiceHeight, Select and press enter
Return

ChoiceWindowPosition:
IniRead, ChoiceAutoCenter, %A_ScriptDir%\session.ini, choice, ChoiceAutoCenter, 1
IniRead, ChoiceInput     , %A_ScriptDir%\session.ini, choice, ChoiceInput, 1
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
ChoiceAutoCenterWrite:
IniWrite, %ChoiceAutoCenter%, %A_ScriptDir%\session.ini, choice, ChoiceAutoCenter
ControlFocus, Edit1, Select and press enter
ControlSend, Edit1, {End}, Select and press enter
Return

ChoiceInput:
ChoiceInput:=!ChoiceInput
ChoiceInputWrite:
IniWrite, %ChoiceInput%, %A_ScriptDir%\session.ini, choice, ChoiceInput
ControlFocus, Edit1, Select and press enter
ControlSend, Edit1, {End}, Select and press enter
Gosub, ChoiceFilterText
Return

; just me @ https://autohotkey.com/board/topic/76540-function-seteditcuebanner-ahk-l/
SetEditCueBanner(HWND, Cue) {  ; requires AHL_L
   Static EM_SETCUEBANNER := (0x1500 + 1)
   Return DllCall("User32.dll\SendMessageW", "Ptr", HWND, "Uint", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)
}

; Under some circumstances it would (still) be possible that the listbox in Gui, 10 could be
; - too short (height < 10px) in the Add snippet/select Bundle gui
; - too high so that it overlaps the cancel/random/Checkbox
; we there use this functions to check the height and reset it using ControlMove if needed
; TODO: This should probably better be solved by not re-using Gui, 10: all the time and only use
; it for Choice vs various other listbox GUIs
Gui10ListboxCheckPosition(gui10title)
	{
	 ControlGetPos, Gui10ListboxX, Gui10ListboxY, Gui10ListboxWidth, Gui10ListboxHeight, Listbox1, %gui10title%
	 ControlGetPos, Gui10CancelX, Gui10CancelY, , , Button1, %gui10title%
	; MsgBox % Gui10CancelY ">" Gui10ListboxY+Gui10ListboxHeight "`n" Gui10ListboxX ":" Gui10ListboxY ":" Gui10ListboxWidth ":" Gui10ListboxHeight ; debug
	 If (Gui10CancelY = "")
		Gui10CancelY:=0
	 If (Gui10ListboxY+Gui10ListboxHeight > Gui10CancelY)
		ControlMove, Listbox1, Gui10ListboxX, Gui10ListboxX, Gui10ListboxWidth, % Gui10CancelY-Gui10ListboxY-10, %gui10title%
	 If (Gui10ListboxHeight < 20)
		ControlMove, Listbox1, Gui10ListboxX, Gui10ListboxX, Gui10ListboxWidth, 110, %gui10title%
	}

#IfWinActive, Select and press enter ahk_class AutoHotkeyGUI
F3::
TogglePreview:
if WinExist("preview ahk_class AutoHotkeyGUI")
	{
	 Gosub, PreviewChoiceGuiClose
	 Gui, PreviewChoice:Hide
	}
else
	Gosub, PreviewChoiceShow
Return
#IfWinActive

#IfWinActive, preview ahk_class AutoHotkeyGUI
Esc::
F3::
Gosub, TogglePreview
Return
#IfWinActive

PreviewChoiceShow:
Gui, PreviewChoice:Show, w465 h410 x%PreviewX% y%PreviewY% NA, preview
;WinActivate, preview ahk_class AutoHotkeyGUI
WinActivate, Select and press enter ahk_class AutoHotkeyGUI
Return
