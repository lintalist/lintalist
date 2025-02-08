; LintaList Include
; Purpose: Bundle Properties Editor
; Version: 1.6
; Date:    20240713
;
; Hotkeys used in Search GUI to start Bundle Editor
; F10 = Bundle properties

BundlePropertiesEditor:

Gosub, GuiOnTopCheck

InEditMode = 1

; clear editor vars just to be sure
 Text1=
 Text2=
 HKey=
 OldKey=
 Shorthand=
 OldShorthand=
 Script=
 Checked=
 Name=
 Author=
 Description=
 TitleMatch=

If (EditMode = "")
	Return

Gui, 81:Font,s10
Gui, 81:Add, Text, x20 y10, Note: New and modified Bundle properties are only stored when you press SAVE.
Gui, 81:Add, GroupBox, x260 y40 w420 h390, Properties:
Gui, 81:Add, Text, x270  y62         , Name:
Gui, 81:Add, Edit, xp+80 y60 w300 h20 vName hwndhEditName, %Name%
Gui, 81:Add, Text, xp    y85 , Name used in Lintalist for Menu and Statusbar`n(mandatory)

Gui, 81:Add, Text, x270  y142     , Description:
Gui, 81:Add, Edit, xp+80 y140 w300 h20 vDescription, %Description%
Gui, 81:Add, Text, xp    y165 , Can be used for extra information (not mandatory)

Gui, 81:Add, Text, x270  y212     , Author:
Gui, 81:Add, Edit, xp+80 y210 w300 h20 vAuthor, %Author%
Gui, 81:Add, Text, xp    y235 , Author of Bundle (not mandatory)

Gui, 81:Add, Text, x270  y272     , TitleMatch:
Gui, 81:Add, Edit, xp+80 y270 w300 h20 vTitleMatch, %TitleMatch%
Gui, 81:Add, Text, xp    y295 , Comma separated list of partial window title matches.`n(not mandatory)`n`nDo not use Wildcards.`nExample: .txt,.doc is OK, *.txt,*.doc is not.`n`nSee documentation for more information`n(also about ahk_exe).
;Gui, 81:Add, Text, x270  y380 ,
MenuName_HitListClean:="||"
Loop, parse, MenuName_HitList, |
	{
	 StringSplit, Mhelper, A_LoopField, % Chr(5)
	 MenuName_HitListClean .= Mhelper1 ", " Filename_%Mhelper2% "`t`t`t`t`t`t`t`t`t`t`t`t " Mhelper2 "|"
	 Mhelper1:="", Mhelper2:=""
	}
Gui, 81:Add, Text,    x20     y40, Bundles:
Gui, 81:Add, Listbox, x20     y60 h375 w220 vSelectedListboxBundle gUpdateBundleProperties, %MenuName_HitListClean%
Gui, 81:Add, Button,  x20    y450 h30  w105 gNewBundle, New Bundle
Gui, 81:Add, Button,  xp+115 yp   h30  w105 gDeleteBundle, Delete Bundle

Gui, 81:Add, Button, x260   y450 h30 w130 g81Save, &Save
Gui, 81:Add, Button, xp+145 y450 h30 w130 g81GuiClose, &Cancel
Gui, 81:Add, Button, xp+145 y450 h30 w130 g81Help, Help
Gui, 81:Font,
Gui, 81:Show, w700 h500, Lintalist bundle editor
EM_SetCueBanner(hEditName, "Enter name of new bundle")
WinActivate, Lintalist bundle editor
Return

DeleteBundle:
Gui, 81:Submit, NoHide
SelectedListboxBundle:=RegExReplace(SelectedListboxBundle,"iU).*(\d+)$","$1")
MsgBox, 52, Delete?, % "Do you really want to delete:`n" MenuName_%SelectedListboxBundle% "`n(file: " Filename_%SelectedListboxBundle% ")`n`nLintalist will restart..."
IfMsgBox, No
	Return
Gui, 81:Destroy
; erase everything before FileDelete
Snippet[SelectedListboxBundle,"Save"] := 0
MenuName_%SelectedListboxBundle%:=""
Description_%SelectedListboxBundle%:=""
Author_%SelectedListboxBundle%:=""
TitleMatchList_%SelectedListboxBundle%:=""
Loop, % Snippet[SelectedListboxBundle].MaxIndex()
	{
	 Snippet[Bundle,A_Index,1]:=""
	 Snippet[Bundle,A_Index,"1v"]:=""
	 Snippet[Bundle,A_Index,2]:=""
	 Snippet[Bundle,A_Index,"2v"]:=""
	 Snippet[Bundle,A_Index,3]:=""
	 Snippet[Bundle,A_Index,4]:=""
	 Snippet[Bundle,A_Index,5]:=""
	}
FileDelete, % A_ScriptDir "\bundles\" Filename_%SelectedListboxBundle%
Sleep 500
Reload
Return

NewBundle:
Name:="",Description:="",Author:="",TitleMatch:=""
GuiControl, , Name        , %Name%
GuiControl, , Description , %Description%
GuiControl, , Author      , %Author%
GuiControl, , TitleMatch  , %TitleMatch%
GuiControl, Choose, SelectedListboxBundle, 1
ControlFocus, Edit1, A
Return

UpdateBundleProperties:
Gui, 81:Submit, NoHide
SelectedListboxBundle:=RegExReplace(SelectedListboxBundle,"iU).*(\d+)$","$1")
Name:=MenuName_%SelectedListboxBundle%
OldName:=Name
Description:=Description_%SelectedListboxBundle%
Author:=Author_%SelectedListboxBundle%
TitleMatch:=TitleMatchList_%SelectedListboxBundle%

If (SelectedListboxBundle = 0)
	Name:="",Description:="",Author:="",TitleMatch:=""

GuiControl, , Name        , %Name%
GuiControl, , Description , %Description%
GuiControl, , Author      , %Author%
GuiControl, , TitleMatch  , %TitleMatch%

Return

81Help:
Run, docs\index.html
Return

81Save:
Gui, 81:Submit, NoHide

If (SelectedListboxBundle = "")
	{
	 if (Trim(Name," ") = "")
		{
		 MsgBox, Please enter Name
		 ControlFocus, Edit1, A
		 Return
		}
	 InputBox, NewBundleFileName, Save as, File name of new bundle, , 400, 150, , , , , %Name% ; adding name as suggestion (v1.6)
	 If (NewBundleFileName = "")
		{
		 MsgBox, Please enter filename
		 Return
		}
	 NewBundleFileName .= ".txt" ; make sure *.txt was added otherwise it won't load at next startup
	 StringReplace, NewBundleFileName, NewBundleFileName, .txt.txt, .txt, all
	 File := A_ScriptDir "\bundles\" NewBundleFileName
	 IfExist, %File%
		{
		 MsgBox, Warning:`n%File%`n`nis already present in the bundle folder.`nEnter a new name.
		 Return
		}

FileAppend,
(
BundleFormat: 1
Name: %Name%
Description: %Description%
Author: %Author%
TitleMatch: %TitleMatch%
Patterns:
- LLPart1: %Name%
  LLPart2: 
  LLKey: 
  LLShorthand: 
  LLScript: 

), %file%, UTF-8

	 Gui, 1:-Disabled
	 Gui, 81:Destroy
	 Gui, 1:Destroy
	 ;Menu, File, DeleteAll
	 Reload ; lazy solution - it is just easier for now
	}

; changing properties

;Gosub, UpdateBundleProperties

	 SelectedListboxBundle:=RegExReplace(SelectedListboxBundle,"iU).*(\d+)$","$1")
	 MenuName_%SelectedListboxBundle%:=Name
	 If (OldName <> "") and (OldName <> Name)
		Menu, File, Rename, &%OldName%, &%Name%
	 Description_%SelectedListboxBundle%:=Description
	 Author_%SelectedListboxBundle%:=Author
	 TitleMatchList_%SelectedListboxBundle%:=TitleMatch
	 MenuName_HitList=
	 Loop, Parse, Group, CSV
		{
		 MenuName_HitList .= MenuName_%A_LoopField% Chr(5) A_Index "|"
		}
	 StringTrimRight, MenuName_HitList, MenuName_HitList, 1 ; remove trailing |
	 Sort, MenuName_HitList, D|
 	 ; 1) detach the menu bar via Gui Menu (that is, omit MenuName)
 	 ; 2) make the changes
 	 ; 3) reattach the menu bar via Gui, Menu, MyMenuBar.
 	 ;Menu, File, DeleteAll
	 Gui, 1:Menu
	 Gosub, BuildFileMenu
	 Gosub, BuildEditMenu
	 Gui, 1:Menu, MenuBar
	 Snippet[SelectedListboxBundle,"Save"]:=1

Gui, 1:-Disabled
Gui, 81:Destroy
WinActivate, %AppWindow%
InEditMode = 0
If OnTopStateSaved
	Gosub, GuiOnTopCheck
Return

81GuiEscape:
81GuiClose:

Gui, 1:-Disabled
Gui, 81:Destroy
WinActivate, %AppWindow%
InEditMode = 0
If OnTopStateSaved
	Gosub, GuiOnTopCheck
Return

; https://github.com/Visionary1/AHK-Academy/blob/master/EM_SetCueBanner.ahk
EM_SetCueBanner(hWnd, Cue)
	{
	 static EM_SETCUEBANNER := 0x1501
	 return DllCall("User32.dll\SendMessage", "Ptr", hWnd, "UInt", EM_SETCUEBANNER, "Ptr", True, "WStr", Cue)
	}
