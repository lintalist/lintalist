; LintaList Include
; Purpose: Bundle & Snippet Editor
; Version: 1.0.2
; Date:    20140421
;
; Hotkeys used in Search GUI to start Bundle & Snippet Editor
; F4  = Edit snippet 		
; F5  = Copy and Edit snippet 		
; F6  = Move snippet (from one bundle to another)
; F7  = Add new snippet		
; F8  = Delete snippet		
; F10 = New bundle			

BundleEditor:
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

If (EditMode = "AppendSnippet") 
	{
	 AppendToBundle:=Load ; tmp var
	 IfInString, Load, `, ; Append to which Bundle?
		{
		 MadeChoice=0
		 ClipQ1=
		 Loop, Parse, Load, CSV
			{
			 HkHm%A_Index%:=A_LoopField
			 StringSplit, MenuN, A_LoopField, _
			 ClipQ1 .= MenuName_%MenuN1% "|"
			} 
		 Gui, 10:Destroy
		 Gui, 10:+Owner +AlwaysOnTop
		 Gui, 10:Add, ListBox, w400 h100 x5 y5 vItem gChoiceMouseOK AltSubmit, 
		 Gui, 10:Add, button, default gChoiceOK hidden, OK
		 GuiControl, 10: , ListBox1, |
		 GuiControl, 10: , ListBox1, %ClipQ1%
		 Gui, 10:Show, w410 h110, Append snippet to bundle:
		 ControlSend, ListBox1, {Down}, Append snippet to bundle:
		 Loop ; ugly hack: can't use return here because, well it returns and would thus skip the gui and proceed to paste
			{
			 If (MadeChoice = 1)
				{
				 MadeChoice = 0
				 Break
				}
			 Sleep 20 ; needed for a specific (old) ahk_l version, if no sleep CPU usages jumps to 50%, no responding to hotkeys and no tray menu
			}
		}
	 paste:=AppendToBundle
	}

If (EditMode = "MoveSnippet") 
	{ 
	 MultipleHotkey=
	 StringSplit, paste, paste, _
	 ClipQ1=
	 Loop, parse, MenuName_HitList, |
			{ 
			 StringSplit, MenuN, A_LoopField, % Chr(5) ; %
			 If (MenuN2 <> Paste1)
				ClipQ1 .= MenuName_%MenuN2% "|"
			} 
	 Loop {
		If (Substr(ClipQ1, 1, 1) = "|")
			StringTrimLeft, ClipQ1, ClipQ1, 1
		Else
			Break
		}		
	 StringSplit, HkHm, ClipQ1, |	
	 Gui, 10:Destroy
	 Gui, 10:+Owner +AlwaysOnTop
	 Gui, 10:Add, ListBox, w400 h100 x5 y5 vItem gChoiceMouseOK AltSubmit, 
	 Gui, 10:Add, button, default gChoiceOK hidden, OK
	 GuiControl, 10: , ListBox1, |
	 GuiControl, 10: , ListBox1, %ClipQ1%
	 Gui, 10:Show, w410 h110, Move snippet to bundle:
	 ControlSend, ListBox1, {Down}, Move snippet to bundle:
	 Loop ; ugly hack: can't use return here because, well it returns and would thus skip the gui and proceed to paste
		{
		 If (MadeChoice = 1)
			{
			 MadeChoice = 0
			 Break
			}
		 Sleep 20 ; needed for (old) ahk_l, if no sleep CPU usages jumps to 50%, no responding to hotkeys and no tray menu
		}	 
	 If (EditMode = "")
		Return
	 Text1:=     Snippet[Paste1,Paste2,1] ; part 1 (enter, or shortcut, or shorthand)
	 Text2:=     Snippet[Paste1,Paste2,2] ; part 2 (shift-enter)
	 HKey:=      Snippet[Paste1,Paste2,3] ; Hotkey
	 ShortHand:= Snippet[Paste1,Paste2,4] ; Shorthand
	 Script:=    Snippet[Paste1,Paste2,5] ; Script (if there is a script run script instead)
	 ; delete
	 Snippet[Paste1].Remove(Paste2)
	 List_%Paste1%_Deleted++     ; Keep track of No deleted snippets so we can update the statusbar correctly
	 
	 List_ToSave_%Paste1%=1
	 Snippet[Paste1,"Save"] := 1 ; (List_ToSave_%Bundle% = 1)
	 Loop, parse, MenuName_HitList, |
		{
		 StringSplit, MenuText, A_LoopField, % Chr(5) ; %
		 If (MenuText1 = AppendToBundle)
			{
			 AppendToBundle:=MenuText2
			 Break
			}
		}
	 Goto, 71Save
	}
	
If (EditMode = "")
	Return
	
If (EditMode = "EditSnippet") or (EditMode = "AppendSnippet") or (EditMode = "CopySnippet")
	{
	 StringSplit, paste, paste, _           ; split to bundle / index number
	 Name:=MenuName_%Paste1%
	 OldName:=Name
	 Description:=Description_%Paste1%
	 Author:=Author_%Paste1%
	 TitleMatch:=TitleMatchList_%Paste1%
	}

If (EditMode = "EditSnippet") or (EditMode = "CopySnippet") ; get snippet vars for editor
	{
	 Text1     := Snippet[Paste1,Paste2,1] ; part 1 (enter, or shortcut, or shorthand)
	 Text2     := Snippet[Paste1,Paste2,2] ; part 2 (shift-enter)
	 HKey      := Snippet[Paste1,Paste2,3] ; Hotkey
	 OldKey:=HKey
	 If (InStr(HKey, "#") > 0)
		{
		 Checked=Checked
		 StringReplace, HKey, HKey, #, , all
		} 
		
	 Shorthand := Snippet[Paste1,Paste2,4] ; Shorthand
	 OldShorthand:=Shorthand
	 Script    := Snippet[Paste1,Paste2,5] ; Script (if there is a script run script instead)
	 AppendToBundle:=Paste1
	}

Filename:=Filename_%paste1%

Gui, 71:+Owner	
If (EditMode = "NewBundle")
	Gui, 71:Add, Tab2, x5 y5 w730 h495 gTabClick, %A_Space%%A_Space%Snippet Text and Code%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%|%A_Space%%A_Space%%A_Space%%A_Space%Bundle Properties%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%||
Else
	Gui, 71:Add, Tab2, x5 y5 w730 h495 gTabClick, %A_Space%%A_Space%Snippet Text and Code%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%|%A_Space%%A_Space%%A_Space%%A_Space%Bundle Properties%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%%A_Space%|

Gui, 71:Tab, 1 ; Snippet ------------------------------------------------------------------------

Gui, 71:Add, Picture , x20    y40 w16 h16, %A_ScriptDir%\icons\lintalist_bundle.png
Gui, 71:Add, Text    , x40    y40               , Bundle:`t%A_Space%%A_Space%%A_Space%%Name%
Gui, 71:Add, Text    , x423   y40               , File:`t%Filename%

Gui, 71:Add, Picture , x20    y70 w16 h16, %A_ScriptDir%\icons\keyboard.png
Gui, 71:Add, Text    , x40    y70                  , Hotkey: 
Gui, 71:Add, Hotkey  , xp+50  y70  w140 h20 vHKey  , %HKey%
Gui, 71:Add, Checkbox, xp+150 y70  w70  h20 vWinKey %checked%, Win

Gui, 71:Add, Text    , xp+150 y70  w150 h20           , Shorthand: 
Gui, 71:Add, Edit    , xp+70  y70  w150 h20 vShorthand, %Shorthand%

Gui, 71:Add, Picture , x20    y100 w16 h16, %A_ScriptDir%\icons\text_dropcaps.png
Gui, 71:Add, Text    , x40    y100                    , Part 1 (Enter)
Gui, 71:Add, Edit    , x20    y120  h100 w700 vText1  , %Text1%

Gui, 71:Add, Picture , x20    yp+110 w16 h16, %A_ScriptDir%\icons\text_dropcaps.png
Gui, 71:Add, Text    , x40    yp                  , Part 2 (Shift-Enter)
Gui, 71:Add, Edit    , x20    yp+20 h100 w700 vText2  , %Text2%

Gui, 71:Add, Picture , x20    yp+110 w16 h16, %A_ScriptDir%\icons\script_code.png
Gui, 71:Add, Text    , x40    yp                  , Script
Gui, 71:Add, Edit    , x20    yp+20 h100 w700 vScript , %Script%

Gui, 71:font, s7, arial
Gui, 71:Add, Button, x610  y98 h20 w110 0x8000 g71EditPart1 , 1 - Edit in Editor ; part1
Gui, 71:Add, Button, x610 y228 h20 w110 0x8000 g71EditPart2 , 2 - Edit in Editor ; part2
Gui, 71:Add, Button, x610 y358 h20 w110 0x8000 g71EditScript, 3 - Edit in Editor ; script
Gui, 71:font, 

Gui, 71:Tab, 2 ; Bundle ------------------------------------------------------------------------

Gui, 71:Add, Text, x20   y40         , Name:
Gui, 71:Add, Edit, xp+80 y40 w400 h20 vName, %Name%
Gui, 71:Add, Text, xp    y65 , Name used in Lintalist for Menu and Statusbar

Gui, 71:Add, Text, x20   y100     , Description:
Gui, 71:Add, Edit, xp+80 y100 w400 h20 vDescription, %Description%
Gui, 71:Add, Text, xp    y125 , Can be used extra information

Gui, 71:Add, Text, x20   y160     , Author:
Gui, 71:Add, Edit, xp+80 y160 w400 h20 vAuthor, %Author%
Gui, 71:Add, Text, xp    y185 , Author of Bundle

Gui, 71:Add, Text, x20   y240     , TitleMatch:
Gui, 71:Add, Edit, xp+80 y240 w400 h20 vTitleMatch, %TitleMatch%
Gui, 71:Add, Text, xp    y265 , Comma separated list of partial window title matches. Do not use Wildcards.
Gui, 71:Add, Text, xp    y285 , Example: .txt,.doc is OK, *.txt,*.doc is not. 
Gui, 71:Add, Text, xp    y305 , See documentation for more information.

Gui, 71:Tab, 

Gui, 71:Add, Button, x20    y510 h25 w210 g71Save, &Save
Gui, 71:Add, Button, xp+245 y510 h25 w210 g71GuiClose, &Cancel
Gui, 71:Add, Button, xp+245 y510 h25 w210 g71Help, Help


Gui, 71:Show, w740 h545, Lintalist bundle editor
WinActivate, Lintalist bundle editor
If (EditMode = "EditSnippet") or (EditMode = "AppendSnippet")
	ControlFocus, Edit2, Lintalist bundle editor
Else If (EditMode = "NewBundle")
	{
	 GuiControl, Choose, SysTabControl321, |2
	 ControlFocus, Edit5, Lintalist bundle editor
	}
Return

TabClick:
If (EditMode = "NewBundle")
	{
	 GuiControl, Choose, SysTabControl321, |2
	 MsgBox, 48, Save first, Save the bundle first before adding new snippets
	 ControlFocus, Edit5, Lintalist bundle editor
	}
Return
	
71Help:
Run, docs\index.html
Return

71Save:
If (EditMode <> "MoveSnippet")
	Gui, 71:Submit, NoHide
If (HKey = "vk00") ; temp fix for ahk 1.1.02.1-1.1.02.3
	HKey=	
If (Winkey = 1)
	HKey = #%HKey% ; add Win modifier key
StringLower, HKey, HKey
If (EditMode = "EditSnippet")
	Check:=Paste1
Else If (EditMode = "AppendSnippet") or (EditMode = "CopySnippet") or (EditMode = "MoveSnippet") 
	Check:=AppendToBundle

If (Shorthand <> OldShorthand) ; if new shorthand check for duplicate
	{
	 HitKeyHistory=
	 HitKeyHistory:=CheckHitList("Shorthand", Shorthand, Check)
	 If (HitKeyHistory <> "")
		{
		 MsgBox,48,Warning, Shorthand collision`nThis abbreviation is already in use in this Bundle.`nBundleName added to Shorthand, so be sure to edit.
		 If (EditMode <> "MoveSnippet")
		 	Return
		 Shorthand:= MenuText1 ":" Shorthand
		}
	}

If (HKey <> OldKey) ; if new hotkey check for duplicate
	{
ThisHotkey=
StringReplace, ThisHotkey, HKey,+,\+,All
StringReplace, ThisHotkey, ThisHotkey,!,\!,All
StringReplace, ThisHotkey, ThisHotkey,^,\^,All
StringReplace, ThisHotkey, ThisHotkey,#,\#,All
;MsgBox % ThisHotkey
ThisHotkey:=RegExReplace(ThisHotkey, "i)^([!#^+\\]*)", "[$1]{_}")
Stringreplace, ThisHotkey, ThisHotkey, \,\, useerrorlevel
Length:=ErrorLevel
Stringreplace, ThisHotkey, ThisHotkey, {_},{%Length%}, All
;MsgBox % "Check Hotkey: " ThisHotkey
HitKeyHistory=
HitKeyHistory:=CheckHitList("Hotkey", ThisHotkey, Check, 1)
If (HitKeyHistory <> "")
	{
	 MsgBox,48,Warning, Hotkey collision.`nThis keyboard shortcut is already in use in this Bundle.`nHotkey disabled for this snippet.
	 If (EditMode <> "MoveSnippet")
		 	Return
	 HKey=
	}
}

If (EditMode = "EditSnippet")
	{
	 Snippet[Paste1,Paste2,1] := Text1      ; part 1 (enter)
	 Snippet[Paste1,Paste2,2] := Text2      ; part 2 (shift-enter)
	 Snippet[Paste1,Paste2,3] := HKey       ; Hotkey
	 Snippet[Paste1,Paste2,4] := Shorthand  ; Shorthand
	 Snippet[Paste1,Paste2,5] := Script     ; Script (if there is a script run script instead)

     ;fix preview 
	 fix1 := Snippet[Paste1,Paste2,1]
	 fix2 := Snippet[Paste1,Paste2,2]
	 StringReplace, fix1, fix1, `r, ,all
	 StringReplace, fix1, fix1, `n, \n,all
	 StringReplace, fix1, fix1, %A_Tab%, \t,all
	 StringReplace, fix2, fix2, `r, ,all
	 StringReplace, fix2, fix2, `n, \n,all
	 StringReplace, fix2, fix2, %A_Tab%, %A_Space%,all
	 ;/fix preview
	 Snippet[Paste1,Paste2,"1v"]:=fix1
	 Snippet[Paste1,Paste2,"2v"]:=fix2
	 
	 List_ToSave_%Paste1%=1
	 Snippet[Paste1,"Save"] := 1
     Counter:=Paste1
	}	 
Else If (EditMode = "AppendSnippet") or (EditMode = "CopySnippet") or (EditMode = "MoveSnippet") 
	{
	 If (Text1 = "") and (Text2 = "") and (HKey = "") and (Shorthand = "") and (Script = "")
		Return ; nothing to do
	 Snippet[AppendToBundle,"Save"]:="1"	
	 listcounter:= Snippet[AppendToBundle].MaxIndex() + 1
	 Snippet[AppendToBundle,listcounter,1]:=Text1
	 Snippet[AppendToBundle,listcounter,2]:=Text2
	 Snippet[AppendToBundle,listcounter,3]:=HKey
	 Snippet[AppendToBundle,listcounter,4]:=Shorthand
	 Snippet[AppendToBundle,listcounter,5]:=Script

	 ;fix preview 
	 fix1 := Snippet[AppendToBundle,listcounter,1]
	 fix2 := Snippet[AppendToBundle,listcounter,2]
	 StringReplace, fix1, fix1, `r, ,all
	 StringReplace, fix1, fix1, `n, \n,all
	 StringReplace, fix1, fix1, %A_Tab%, \t,all
	 StringReplace, fix2, fix2, `r, ,all
	 StringReplace, fix2, fix2, `n, \n,all
	 StringReplace, fix2, fix2, %A_Tab%, %A_Space%,all
	 ;/fix preview
	 
	 Snippet[AppendToBundle,listcounter,"1v"]:=fix1
	 Snippet[AppendToBundle,listcounter,"2v"]:=fix2
	 
	 Append=
(

- LLPart1: %Text1%
  LLPart2: %Text2%
  LLKey: %HKey%
  LLShorthand: %Shorthand%
  LLScript: %Script%
)
	File=
	File .= A_ScriptDir "\bundles\" FileName_%AppendToBundle%
	IfNotInString, File, .txt
		{
		 MsgBox, 48, Error, ERROR: Can not append snippet to Bundle (No file name available)`nBundle: %File%`n`nDo you wish to Reload?
		 IfMsgBox, Yes
		 	Reload
		}
	Else
		{	
		 FileAppend, %Append%, %file%
		 If (ErrorLevel = 0)
			MsgBox, 64, Snippet succesfully added to bundle, % File "`n" Append
		 Else
		 	MsgBox, 48, Error, % "ERROR: Could not append snippet to Bundle`n`n" File "`n" Append
		} 
		Counter:=AppendToBundle
	}
Else If (EditMode = "NewBundle")
	{
	 ;MsgBox %Name% - %Description%
	 InputBox, NewBundleFileName, Save as, File name of new bundle, , 400, 150
	 If (NewBundleFileName = "")
		{
	 	 Return
		}
	 NewBundleFileName .= ".txt" ; make sure *.txt was added otherwise it won't load at next startup
	 StringReplace, NewBundleFileName, NewBundleFileName, .txt.txt, .txt, all
	 File .= A_ScriptDir "\bundles\" NewBundleFileName
	 If (Text1 = "") and (Text2 = "") and (HKey = "") and (Shorthand = "") and (Script = "")
		Append= ; no snippet defined
	 Else {
Append=
(

- LLPart1: %Text1%
  LLPart2: %Text2%
  LLKey: %HKey%
  LLShorthand: %Shorthand%
  LLScript: %Script%
)	 
}
FileAppend, 
(
BundleFormat: 1
Name: %Name%
Description: %Description%
Author: %Author%
TitleMatch: %TitleMatch%
Patterns:
%append%

), %file%

	 Gui, 1:-Disabled
	 Gui, 71:Destroy
	 Gui, 1:Destroy
	 ;Menu, File, DeleteAll
	 Reload ; lazy solution - it is just easier for now
	}
	 
; Update shortcutlist and shorthandlist here
ArrayName=List_
HotKeyHitList_%Counter%:=Chr(5)    ; clear
ShortHandHitList_%Counter%:=Chr(5) ; clear
; MsgBox % Counter
If (OldKey <> "") ; and (OldKey <> HKey)
	Hotkey, % "$" . OldKey, Off ; set old hotkey off ...
Loop, % Snippet[Counter].MaxIndex() ; LoopIt
	{ 
	 If (Snippet[Counter,A_Index,3] <> "") ; if no hotkey defined: skip
		{
		 Hotkey, % "$" . Snippet[Counter,A_Index,3], ShortCut ; set hotkeys
		 If (ShortcutPaused = 1)
			Hotkey, % "$" . Snippet[Counter,A_Index,3], Off ; set hotkeys off ...
		 HotKeyHitList_%Counter% .= Snippet[Counter,A_Index,3] Chr(5)
		}
			
	 If (Snippet[Counter,A_Index,4] <> "") ; if no shorthand defined: skip
		{
		 ShortHandHitList_%Counter% .= Snippet[Counter,A_Index,4] Chr(5)
		} 
	}

; MsgBox % ShortHandHitList_%Counter%	
	
; store any updated properties	
If (EditMode <> "MoveSnippet")
	{
	 MenuName_%Counter%:=Name
	 If (OldName <> "") and (OldName <> Name)
		Menu, File, Rename, &%OldName%, &%Name%
	 Description_%Counter%:=Description
	 Author_%Counter%:=Author
	 TitleMatchList_%Counter%:=TitleMatch
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
	}

Gui, 1:-Disabled
Gui, 71:Destroy
if (AlwaysUpdateBundles = 1)
	SaveUpdatedBundles(AppendToBundle)
WinActivate, %AppWindow%
WinWaitActive, %AppWindow%
LoadBundle(Load)
UpdateLVColWidth()
ControlFocus, Edit1, %AppWindow%
Gosub, SetStatusBar	
lasttext = fadsfSDFDFasdFdfsadfsadFDSFDf
Gosub, GetText
ShowPreview(PreviewSection)
InEditMode = 0
Return

71EditPart1:
EditControlInEditor("Edit2")
Return

71EditPart2:
EditControlInEditor("Edit3")
Return

71EditScript:
EditControlInEditor("Edit4")
Return

EditControlInEditor(ControlID)
	{
	 Global WhichControl
	 WhichControl:=ControlID
	 GuiControlGet, ToFile, , %ControlID%
	 FileDelete, __tmplintalistedit.txt
	 FileAppend, %ToFile%, __tmplintalistedit.txt
	 Run, __tmplintalistedit.txt
	 winwait, __tmplintalistedit.txt
	 SetTimer, CheckEdit, 500, On
	 Return
	}

CheckEdit:
IfWinExist, __tmplintalistedit.txt
	Return
SetTimer, CheckEdit, Off
FileRead, NewText, __tmplintalistedit.txt
FileDelete, __tmplintalistedit.txt
WinActivate, Lintalist bundle editor
Gui, 71:Default
GuiControl, ,%WhichControl%, %NewText%
ControlFocus, %WhichControl%, Lintalist bundle editor
NewText=
WhichControl=
Return

71GuiEscape:
71GuiClose:

Gui, 1:-Disabled
Gui, 71:Destroy
WinActivate, %AppWindow%
InEditMode = 0
Return
