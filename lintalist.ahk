/*

Name            : Lintalist
Author          : Lintalist
Purpose         : Searchable interactive lists to copy & paste text, run scripts,
                  using easily exchangeable bundles
Version         : 1.1
Code            : https://github.com/lintalist/
Website         : http://lintalist.github.io/
AHKscript Forum : http://ahkscript.org/boards/viewtopic.php?f=6&t=3378
License         : Copyright (c) 2009-2015 Lintalist

This program is free software; you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

See license.txt for further details.

*/

; Default settings
#NoEnv
#SingleInstance, force
SetBatchLines, -1
SetTitleMatchMode, 2
ListLines, off
TmpDir:= A_ScriptDir "\tmpscrpts"
CoordMode, ToolTip, Screen
SendMode, Input
SetWorkingDir, %A_ScriptDir%
FileEncoding, UTF-8

; Title + Version are included in Title and used in #IfWinActive hotkeys and WinActivate
Title=Lintalist
Version=1.1

; ClipCommands are used in ProcessText and allow user input and other variable input into text snippets
; ClipCommands=[[Input,[[DateTime,[[Choice,[[Selected,[[Var,[[File,[[Snippet=
Gosub, ReadPluginSettings

AppWindow=%title% - %version%   ; Name of Gui
GroupAdd, AppTitle, %AppWindow% ; we can now use #IfWinActive with the INI value (main scripts hotkeys)

OnExit, SaveSettings ; store settings (locked state, search mode, gui size etc in INI + Make sure changes to Bundles are saved)

; /Default settings

; Tray Menu
Menu, Tray, NoStandard
Menu, Tray, Icon, icons\lintalist_suspended.ico ; while loading show suspended icon
Menu, Tray, Add, &Help,          	 TrayMenuHandler
Menu, Tray, Add, Quick Start Guide,  TrayMenuHandler
Menu, Tray, Add, &Configuration,     TrayMenuHandler
Menu, Tray, Add,
Menu, Tray, Add, &Edit Local Bundle, TrayMenuHandler
Menu, Tray, Add, &Manage counters,   TrayMenuHandler
Menu, Tray, Add,
Menu, Tray, Add, &Load All Bundles,  MenuHandler
Menu, Tray, Add, &Reload Bundles,    TrayMenuHandler
Menu, Tray, Add,
Menu, Tray, Add, &Pause Lintalist,   TrayMenuHandler
Menu, Tray, Add, Pause &Shortcut,    TrayMenuHandler
Menu, Tray, Add, Pause &Shorthand,   TrayMenuHandler
Menu, Tray, Add, Pause &Scripts,     TrayMenuHandler
Menu, Tray, Add,
Menu, Tray, Add, E&xit,              TrayMenuHandler
Menu, Tray, Check, &Pause Lintalist ; indicate program is still loading
Menu, Tray, Tip, %AppWindow% - inactive
; Tray Menu continue below

; Includes
; [Note: bundle editor + plugins + GuiSettings included at the end of the script]

#Include %A_ScriptDir%\include\ObjectBundles.ahk
#Include %A_ScriptDir%\include\StayOnMonitor.ahk
#Include %A_ScriptDir%\include\ReadINI.ahk
#Include %A_ScriptDir%\include\Default.ahk
#Include %A_ScriptDir%\include\Func_IniSettingsEditor_v6.ahk
; /Includes

; INI ---------------------------------------
ReadIni()
Gosub, CheckShortcuts

; Tray Menu settings
If (LoadAll = 1)
	Menu, tray, Check, &Load All Bundles
Else If (LoadAll = 0)
	Menu, tray, UnCheck, &Load All Bundles
If (ShorthandPaused = 1)
	Menu, tray, Check, Pause &Shorthand
If (ShortcutPaused = 1)
	Menu, tray, Check, Pause &Shortcut
If (ScriptPaused = 1)
	Menu, tray, Check, Pause &Scripts
; /Tray Menu

; Dynamic Gui elements, postions etc.
Gosub, GuiStartupSettings
; /Dynamic Gui settings

PastText1=1
LoadAllBundles()
LoadPersonalBundle()
Menu, Tray, Icon, icons\lintalist.ico ; loading is done so show active Icon
Menu, tray, UnCheck, &Pause Lintalist
Menu, tray, Tip, %AppWindow% - active`nPress %StartSearchHotkey% to start search...
if (MinLen > 1)
	MinLen--

Gosub, BuildFileMenu
Gosub, BuildEditMenu
Gosub, BuildEditorMenu
Gosub, QuickStartGuide

; setup hotkey

Hotkey, %StartSearchHotkey%, GUIStart
Hotkey, %QuickSearchHotkey%, ShortText
Hotkey, %ExitProgramHotKey%, SaveSettings

ViaShorthand=0

; /INI --------------------------------------

SendKeysToFix=Enter,Space,Esc,Tab,Home,End,PgUp,PgDn,Up,Down,Left,Right,F1,F2,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,AppsKey
;TerminatingCharacters={Alt}{LWin}{RWin}{Shift}{enter}{space}{esc}{tab}{Home}{End}{PgUp}{PgDn}{Up}{Down}{Left}{Right}{F1}{F2}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}.,¿?¡!'"()[]{}{}}{{}~$&*-+=\/><^|@#:`%;  ; "%
TerminatingCharacters={Alt}{LWin}{RWin}{enter}{space}{esc}{tab}{Home}{End}{PgUp}{PgDn}{Up}{Down}{Left}{Right}{F1}{F2}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}  ; "%
Loop
	{
	 ;Get one key at a time
	 Input, TypedChar, L1 V I, {BS}%TerminatingCharacters%
	 CheckTyped(TypedChar,ErrorLevel)
	}

; fix 201102 for switching windows with mouse, clear typed stack
~*Lbutton::
Typed=
Return

~*MButton::
Typed=
Return

~*RButton::
Typed=
Return


; Here we build the Search Gui and fill it with content from the bundles and apply settings

GuiStart: ; build GUI
If WinActive("Select bundle") or WinActive("Append snippet to bundle") ; TODO replace by HOTKEY On,Off command
		Return
If (ActiveWindowTitle = "Lintalist bundle editor")                     ; TODO replace by HOTKEY On,Off command
		Return
LastText = fadsfSDFDFasdFdfsadfsadFDSFDf
If !WinActive(AppWindow)
	GetActiveWindowStats()
Else
	Gosub, ToggleView

Gui, 1:Destroy ; just to be sure
Gui, 1:+Border ;
Gui, 1:Menu, MenuBar
Gui, 1:Add, Picture, x4 y4 w16 h16, icons\search.png
Gui, 1:Add, Edit, 0x8000 x25 y2 w%SearchBoxWidth% h20 gGetText vCurrText, %CurrText%
Gui, 1:Add, Button, x300 y2 w30 h20 0x8000 Default hidden gPaste, OK
Gui, 1:Font, s8, Arial
Gui, 1:Add, CheckBox, 0x8000 gCase vCase x%cax% y%Yctrl%, &Case
Gui, 1:Add, CheckBox, 0x8000 gLock vLock x%lox% y%Yctrl%, &Lock
Gui, 1:Add, Radio,    0x8000 gSetSearchMethod vSMNorm x%nox% y%Yctrl% w50, &Rglr ; Regular Search method
Gui, 1:Add, Radio,    0x8000 gSetSearchMethod vSMFuzz x%fzx% y%Yctrl% w50, F&zzy ; Fuzzy
Gui, 1:Add, Radio,    0x8000 gSetSearchMethod vSMRegx x%rex% y%Yctrl% w50, RgE&x ; Regular Expression
Gui, 1:Add, Radio,    0x8000 gSetSearchMethod vSMMagc x%mgx% y%Yctrl% w50, &Magc ; Magic (regex)

If (SearchMethod = 1)        ; Set radio button based on last used searchmethod (stored in ini on exit)
	GuiControl, , SMNorm, 1
Else If (SearchMethod = 2)
	GuiControl, , SMFuzz, 1
Else If (SearchMethod = 3)
	GuiControl, , SMRegx, 1
Else If (SearchMethod = 4)
	GuiControl, , SMMagc, 1

If (Lock = 1) or (LoadAll=1) ; lock state also stored in ini
	GuiControl, , Lock, 1
If (Case = 1)                ; case state also stored in ini
	GuiControl, , Case, 1

Gui, 1:Font,,

Gui, 1:Add, Listview, %ShowGrid% count1000 x2 y%YLView% xLV0x100 vSelItem AltSubmit gClicked h%LVHeight% w%LVWidth% , Paste (Enter)|Paste (Shift+Enter)|Key|Short|Index

Gui, 1:Font, s8, Arial
Gui, 1:Add, edit, x0 y%YPosPreview% -VScroll w%LVWidth% h%PreviewHeight%, preview
Gui, 1:Add, StatusBar,,
SB1:=Round(.8*Width)
SB_SetParts(SB1)
Gosub, GetText
XY:=StayOnMonXY(Width, Height, Mouse, MouseAlternative, Center) ; was XY:=StayOnMonXY(Width, Height, 0, 1, 0)
StringSplit, Pos, XY, |
If (x="") or (y="")
	x:=100, y:=100
Gui, Show, w%Width% h%Height% x%Pos1% y%Pos2%, %AppWindow%
GuiJustShown:=1
If (JumpSearch=1) ; Send clipboard text to search control
	{
	 JumpSearch=0
	 GuiControl, 1:, Edit1, %clipboard%
	 ControlSend, Edit1, {End}, %AppWindow%
	 Sleep 100     ; added as a fix to avoid duplicate search results, not sure if it helps
	 Gosub, GetText
	}
ShowPreview(PreviewSection)
ControlSend, Edit1, {End}, %AppWindow%  ; 20110623
Gosub, GetText                          ; 20110623
Return

; Incremental Search, here is where the magic starts, based on 320mph version by Fures, if you know of an even FASTER way let me know ;-)

GetText:
;MsgBox % "y1-----" Snippet[1,1,1] ; debug
StartTime := A_TickCount
ControlGetText, CurrText, Edit1, %AppWindow%
If (CurrText = LastText)
	Return
CurrLen:=StrLen(CurrText)
; LoadBundle() ; 20121209
If (CurrLen = 0) or (CurrLen =< MinLen)
	{
	 LoadBundle()
	 UpdateLVColWidth()
	 LastText = fadsfSDFDFasdFdfsadfsadFDSFDf
	 Gosub, SetStatusBar
	 Return
	}
Gui, 1:Default
LV_Delete()
GuiControl,1: , Edit2, %A_Space% ; fix preview if no more snippets e.g. ghosting of last snippet

; setup imagelist and define icons
#Include %A_ScriptDir%\include\ImageList.ahk

LastText := CurrText
GuiControlGet, Case, , Button2
ShowPreviewToggle=1
GuiControl, 1:-Redraw, MyListView
Loop, parse, Load, CSV
	{
	 If (A_TickCount - StartTime > 250)
		ControlGetText, CurrText, Edit1, %AppWindow%
	 If (CurrText <> LastText)
		 Goto GetText
	 Bundle:=A_LoopField

	 Max:=Snippet[Bundle].MaxIndex()
	 Loop,% Max ; %
		{
		 match=0
		 SearchThis1:=Snippet[Bundle,A_Index,1] ; part '1' (enter)
		 SearchThis2:=Snippet[Bundle,A_Index,2] ; part '2' (shift-enter)
		 SearchThis3:=Snippet[Bundle,A_Index,4] ; shorthand
		 If (SearchMethod = 1) ; normal
			{
			 If (InStr(SearchThis1,CurrText,Case) > 0) or (InStr(SearchThis2,CurrText,Case) > 0) or (InStr(SearchThis3,CurrText,Case) > 0)
				{
				 Match++
				}
			}

		 If (SearchMethod = 2) ; fuzzy
			{
			 Found = 0
			 Words = 0
			 Loop, parse, CurrText, %A_Space%
				{
				 If (InStr(SearchThis1,A_LoopField,Case) > 0) or (InStr(SearchThis2,A_LoopField,Case) > 0) or (InStr(SearchThis3,A_LoopField,Case) > 0)
					Found++
				 Words:=A_Index
				}
			 If (Found = Words)
				{
				 Match++
				}
			}

		 If (SearchMethod = 3) ; regex
			{
			 If (Case = 0)     ; case insensitive, add auto i) option
				SearchRe := "i)" . CurrText
			 Else
				SearchRe := CurrText
			 If (RegExMatch(SearchThis1, SearchRe) > 0) or (RegExMatch(SearchThis2, SearchRe) > 0) or (RegExMatch(SearchThis3, SearchRe) > 0)
				{
				 Match++
				}
			}

		 If (SearchMethod = 4) ; magic (=regex)
			{
			 SearchRe := RegExReplace(CurrText,"(.)","$1.*")
			 If (Case = 0)     ; case insensitive, add auto i) option
				SearchRe := "i)" . SearchRe
			 If (RegExMatch(SearchThis1, SearchRe) > 0) or (RegExMatch(SearchThis2, SearchRe) > 0) or (RegExMatch(SearchThis3, SearchRe) > 0)
				{
				 Match++
				}
			}

		If (match > 0) ; we have a match
			{
			 IconVal:=""
			 If (ShowIcons = 1)
				{
				 IconVal:=SetIcon(Snippet[Bundle,A_Index],Snippet[Bundle,A_Index,5])
				}
			 LV_Add(IconVal,Snippet[Bundle,A_Index,"1v"],Snippet[Bundle,A_Index,"2v"],Snippet[Bundle,A_Index,3],Snippet[Bundle,A_Index,4],Bundle . "_" . A_Index) ; populate listview

			 If (ShowPreviewToggle = 1) ; do only once to improve speed
				{
				 ShowPreview(PreviewSection)
				 ShowPreviewToggle=0
				}
			 CurrHits:=LV_GetCount()
			 SB_SetText(CurrHits "/" . ListTotal ,2) ; update status bar with hits / total
			 If (CurrHits > MaxRes - 1)              ; stop search after Max results (takes to long anyway)
			 	 Break
		    }
		}
	 If (match = 0)
		SB_SetText(LV_GetCount() "/" . ListTotal ,2) ; otherwise it won't show zero results
	GuiControl, 1:+Redraw, MyListView
	}
Return

; (Double)click in listview, action defined in INI
Clicked:
   IfNotEqual A_GuiControlEvent, DoubleClick
	{
	 ShowPreview(PreviewSection)
	 Return
	}
   Else
	{
	 If (DoubleClickSends = 1)
		 Gosub, paste
	 else if (DoubleClickSends = 2)
		{
		 gosub, shiftenter
		}
	 else if (DoubleClickSends = 3)
		{
		 gosub, ctrlenter
		}
	 else if (DoubleClickSends = 4)
		{
		 gosub, shiftctrlenter
		}
	 else if (DoubleClickSends = 5)
		{
		 gosub,editf4
		}
	 else if (DoubleClickSends = 6)
		{
		 gosub,editf7
		}
	}
Return

; We made a selection and now want to paste and process the selected text or run script
Paste:
Gui, 1:Submit, NoHide
ControlFocus, SysListView321, %AppWindow%
SelItem := LV_GetNext()
If (SelItem = 0)
	SelItem = 1
LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column which is always hidden
Gui, 1:Destroy
CurrText= ; 20110623
; We got here via Shortcut or abbreviation defined in active bundle(s)
ViaShortCut:
StringSplit, paste, paste, _      ; split to bundle / index number
Text1  :=Snippet[Paste1,Paste2,1] ; part 1 (enter, or shortcut, or shorthand)
Text2  :=Snippet[Paste1,Paste2,2] ; part 2 (shift-enter)
Script :=Snippet[Paste1,Paste2,5] ; script (if there is a script, run script instead)

If ((Paste2 <> 1) and (SortByUsage = 1)) ; if it already is the first don't bother moving it to the top...
	{
	 BackupSnippet:=Snippet[Paste1].Remove(Paste2)
	 Snippet[Paste1].Insert(1,BackupSnippet)
	 BackupSnippet=
	 Snippet[Paste1,"Save"]:="1"
	}

If (Text1 = "") and (Text2 = "") and (Script = "")
	Return ; nothing to paste or run
If (Script = "") or (ScriptPaused = 1) ; script is empty so we need to paste Text1 or Text2
	{
	 If (InStr(Text1, "[[Clipboard]]") > 0) or (InStr(Text2, "[[Clipboard]]") > 0) ; if we do it here it saves us some time getting back the original clipsaved variable
		{ ; insert clipboard
		 StringReplace, Text1, Text1, [[Clipboard]], %Clipboard%, All
		 StringReplace, Text2, Text2, [[Clipboard]], %Clipboard%, All
		}
	 If (PastText1 = 1) OR (Text2 = "")
		Clip:=Text1
	 Else If (PastText1 = 0) ; if shift-enter use Text2 BUT if it is empty revert to Text1
		{
		 Clip:=Text2
		 PastText1 = 1       ; restore default paste
		}
	 If (Text1 = "") and (Text2 <> "")   ; if Text1 is empty check if Text2 has content so we can paste that
		Clip:=Text2
	 ClipSet("s",1,SendMethod,Clipboard) ; store in clip1
	 ClearClipboard()
	 Gosub, ProcessText
	 ; process formatted text: HTML, Markdown, RTF and Image
	 If RegExMatch(Clip,"iU)\[\[(html|md|rtf=.*|image=.*)\]\]")
		{
		 WinClip.Clear()
		 formatted:=1
		 if InStr(Clip,"[[md]]")
			{
			 StringReplace,Clip,Clip,[[md]],,All
			 Clip:=Markdown2HTML(Clip)
			 Clip:=FixURI(Clip,"html",A_ScriptDir)
			 WinClip.SetHTML(clip)
			 Clip:=RegExReplace(clip,"iU)</*[^>]*>") ; strip HTML tags so we can paste normal text if need be
			 WinClip.SetText(Clip)
			}
		 else if InStr(Clip,"[[html]]")
			{
			 StringReplace,Clip,Clip,[[html]],,all
			 Clip:=FixURI(Clip,"html",A_ScriptDir)
			 Gosub, ProcessText
			 CheckCursorPos()
			 WinClip.SetHTML(Clip)
			 Clip:=RegExReplace(clip,"iU)</*[^>]*>") ; strip HTML tags so we can paste normal text if need be
			 WinClip.SetText(Clip)
			}
		 else if InStr(Clip,"[[rtf=")
			{
			 RegExMatch(Clip, "iU)\[\[rtf=([^[]*)\]\]", ClipQ, 1)
			 ClipQ1:=FixURI(ClipQ1,"rtf",A_ScriptDir)
			 FileRead,Clip,%ClipQ1%
			 Gosub, ProcessText
			 WinClip.SetRTF(Clip)
			}
		 else if InStr(Clip,"[[image=")
			{
			 RegExMatch(Clip, "iU)\[\[Image=([^[]*)\]\]", ClipQ, 1)
			 ClipQ1:=FixURI(ClipQ1,"image",A_ScriptDir)
			 WinClip.SetBitmap(ClipQ1)
			}
		 Clip:="", ClipQ1:=""
		}
	 Else
		Clipboard:=ClipSet("s",2,SendMethod,Clip) ; set clip2
	 If (formatted = 0)
	 	CheckCursorPos()
	 formatted:=0	
	 GUI, 1:Destroy
	 SendKey(SendMethod, "^v")
	 WinClip.Clear()
	 If ((BackLeft > 0) or (BackUp > 0))       ; place caret at postion defined in snippet text via ^|
		{
		 If (BackUp > 0)
			{
			 SendInput, {Up %BackUp%}{End}
			}
		 SendInput, {Left %BackLeft%}
		}
	 Backleft=0
	 If (ViaText = 1) ; we came from shorttext
		{
		 ViaText=0
		 SkipJumpstart=1
		}
	 Text1=
	 Text2=
	 Clip=
	 Clipboard:=ClipSet("g",1,SendMethod)
	}
Else If (Script <> "") and (ScriptPaused = 0) ; we run script by saving it to tmp file and running it
	{
	 FileDelete, %TmpDir%\tmpScript.ahk
	 StringReplace, Script, Script, LLInit(), %LLInit%, All

		Loop {
		 If (InStr(Script, "[[Var=") = 0)
			break
		 RegExMatch(Script, "iU)\[\[Var=([^[]*)\]\]", ClipQ, 1)
		 StringReplace, Script, Script, [[Var=%ClipQ1%]], % LocalVar_%ClipQ1%, All ; %
		}
	 FileAppend, % Script, %TmpDir%\tmpScript.ahk ; %
	 GUI, 1:Destroy
	 RunWait, %A_AhkPath% "%TmpDir%\tmpScript.ahk"
	 FileDelete, %TmpDir%\tmpScript.ahk
	 Script=
	}
Return

CheckHitList(CheckHitList, CheckFor, Bundle, RE = 0) ; RE no longer needed?
	{
	 Global load,snippet
	 HitKeyHistory=
	 CheckHitList:=CheckHitList "HitList"
	 Loop, parse, Bundle, CSV
		{
		 CheckBundle:=A_LoopField
		 If RegExMatch(%CheckHitList%_%CheckBundle%, "imU)" Chr(5) . "\Q" . CheckFor . "\E" . Chr(5)) ; we have a hit so we to find the snippet ID
			{
			 Loop, % Snippet[CheckBundle].MaxIndex() ; %
				{
				 If (CheckHitList = "HotKeyHitList")
					{
					 If (Snippet[CheckBundle,A_Index,3] ~= "\Q" . CheckFor . "\E") ; use literal search
						HitKeyHistory .= CheckBundle . "_" . A_Index ","
					}
					 Else If (CheckHitList = "ShortHandHitList")
					{
					 If (Snippet[CheckBundle,A_Index,4] = CheckFor)
						HitKeyHistory .= CheckBundle . "_" . A_Index ","
					}
				}
			}
		 Index1=
		}
	 Return HitKeyHistory
	}

; Change with of LV columns depending on content (e.g. autohide if it holds no data)
UpdateLVColWidth()
	{
	 global
	 local c4w
	 LV_ModifyCol(5,0) ; hidden Bundle_Index column, always hide

	 c1w:=Round((Width - 40 - 100) / 2)
	 c2w:=c1w

	 If (Col3 = 0)     ; shortcut column
		{
		 LV_ModifyCol(3,0)
		 c2w += 20
		 c1w += 20
		}
	 Else
		LV_ModifyCol(3,50)

	 If (Col4 = 0)     ; abbreviation/shorthand column
		{
		 LV_ModifyCol(4,0)
	 	 c1w += 20
		 c2w += 20
		}
	 Else
		LV_ModifyCol(4,60)

	 If (Col2 = 0)           ; paste2 column is empty so no need to show
		{
		 c1w += c2w
		 LV_ModifyCol(1,c1w) ; col1 is paste1 column
		 LV_ModifyCol(2,0)   ; no second part so don't show
		}
	 Else
		{
		 LV_ModifyCol(1,c1w) ; col1 is paste1 column
		 LV_ModifyCol(2,c2w) ; paste2 column has content so show it
		}
	}

; Shows the lines in the preview window (edit2)
ShowPreview(Section="1")
	{
	 ; 1 = Text of part one of snippet
	 ; 2 = Text of part two of snippet (fall back on Part 1 of Part 2 is empty)
	 ; 3 = Script code of snippet (fall back to Part 1 if 3 is empty)
	 Global load,snippet
	 Gui, 1:Submit, NoHide
	 SelItem := LV_GetNext()
	 If (SelItem = 0)
		SelItem = 1
	 LV_GetText(Paste, SelItem, 5)          ; get "hidden" bundle _ index value
	 StringSplit, Paste, Paste, _
	 If (Section = 3)
		{
		 If (Snippet[Paste1,Paste2,5] = "") ;  if script is empty default to 2
			Section = 2
		 Else
			Section = 5                     ; 5 = actual script (array element)
		}
	 If (Section = 2)
		{
		 If (Snippet[Paste1,Paste2,2] = "")
			Section = 1
		}
	 GuiControl,1: , Edit2, % Snippet[Paste1,Paste2,Section] ; set preview Edit control %
	 Return
	}

; Case sensitive search checkbox
Case:
Case:=!Case
ControlFocus, Edit1, %AppWindow%
lasttext = fadsfSDFDFasdFdfsadfsadFDSFDf
Gosub, GetText
Return

; Lock bundle checkbox
Lock:
Lock:=!Lock
ControlFocus, Edit1, %AppWindow%
If !Lock
	{
	 LoadBundle()
	 UpdateLVColWidth()
	}
Gosub, SetStatusBar
lasttext = fadsfSDFDFasdFdfsadfsadFDSFDf
Gosub, GetText
ShowPreview(PreviewSection)
Return

; Searchmethod radio
SetSearchMethod:
Gui, Submit, Nohide
If (SMNorm = 1)
	SearchMethod=1
If (SMFuzz = 1)
	SearchMethod=2
If (SMRegx = 1)
	SearchMethod=3
If (SMMagc = 1)
	SearchMethod=4
ControlFocus, Edit1, %AppWindow%
lasttext = fadsfSDFDFasdFdfsadfsadFDSFDf
Gosub, GetText
Return

; Not the best of methods, but it works best for some reason
; Hotkeys active in Gui, 10:
#IfWinActive, Select bundle
Esc::
Gosub, 10GuiClose
Return
#IfWinActive

#IfWinActive, Select and press enter
Esc::
;Gosub, 10GuiClose
Gosub, CancelChoice
Return
#IfWinActive

#IfWinActive, Lintalist bundle editor
Esc::
Gosub, 71GuiClose ; for some reason this is required
Return
#IfWinActive

#IfWinActive, Move snippet to bundle
Esc::
Gosub, 10GuiClose
Return
#IfWinActive

; Hotkeys active in Main GUI
; Reference: Endless scrolling in a listview [hugov] http://www.autohotkey.com/forum/topic44914.html

#IfWinActive, ahk_group AppTitle   ; Hotkeys only work in the just created GUI
Esc::
Gosub, 1GuiClose ; for some reason this is needed, 1GuiEspace doesn't seem to work
Return

F4:: ; edit snippet
EditF4:
EditMode = EditSnippet
Gui, 1:Submit, NoHide
ControlFocus, SysListView321, %AppWindow%
SelItem := LV_GetNext()
If (SelItem = 0)
	SelItem = 1
LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column
Gui, 71:+Owner1
Gui, 1:+Disabled
Gosub, BundleEditor
Return

F5:: ; copy snippet
EditF5:
EditMode = CopySnippet
Gui, 1:Submit, NoHide
ControlFocus, SysListView321, %AppWindow%
SelItem := LV_GetNext()
If (SelItem = 0)
	SelItem = 1
LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column
Gui, 71:+Owner1
Gui, 1:+Disabled
Gosub, BundleEditor
Return

F6:: ; copy snippet
EditF6:
EditMode = MoveSnippet
Gui, 1:Submit, NoHide
ControlFocus, SysListView321, %AppWindow%
SelItem := LV_GetNext()
If (SelItem = 0)
	SelItem = 1
LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column
Gui, 71:+Owner1
Gui, 1:+Disabled
Gosub, BundleEditor
Return

F7:: ; create new snippet e.g. append
EditF7:
EditMode = AppendSnippet
Gui, 71:+Owner1
Gui, 1:+Disabled
Gosub, BundleEditor
Return

F8:: ; delete snippet
EditF8:
InEditMode = 1
Gui, 1:Submit, NoHide
ControlFocus, SysListView321, %AppWindow%
SelItem := LV_GetNext()
If (SelItem = 0)
	SelItem = 1
LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column
StringSplit, paste, paste, _
f1:=Filename_%paste1%
Gui, 99:+Owner1
Gui, 1:+Disabled
Gui, 99:+OwnDialogs
Gui, 99:+Owner
Gui, 99: Add, Text, x10 y10 w630 h250, % "Bundle:`t`t" f1 "`nPart 1:`t`t" Snippet[paste1,paste2,"1v"] "`nPart 2:`t`t" Snippet[paste1,paste2,"2v"] "`nHotkey:`t`t" Snippet[paste1,paste2,3] "`nShorthand:`t" Snippet[paste1,paste2,4] "`nScript:`t`t" Snippet[paste1,paste2,5] ; %
X:=(A_ScreenWidth - 630)/2
Gui, 99: Show, w650 h300 x%x% y10, Delete this entry?
MsgBox, 262196, Delete?, Delete this entry? ; 4+48+262144 =  262196
IfMsgBox, Yes
	{
	 Gui, 1:Default
	 Snippet[Paste1].Remove(Paste2) ; remove snippet
	 List_%Paste1%_Deleted++        ; Keep track of No deleted snippets so we can update the statusbar correctly
	 LoadBundle(Load)
	 UpdateLVColWidth()
	 ControlFocus, Edit1, %AppWindow%
	 lasttext = fadsfSDFDFasdFdfsadfsadFDSFDf
	 Gosub, SetStatusBar
	 Gosub, GetText
	 ShowPreview(PreviewSection)
	 Snippet[Paste1,"Save"]:="1"
	}
Gui, 99: Destroy
Gui, 1:-Disabled
Gui, 1:Default
Sleep 10
WinActivate, %AppWindow%
Sleep 10
InEditMode = 0
ControlFocus, Edit1, %AppWindow%
Return

F10::
EditF10:
EditMode = NewBundle
Gui, 71:+Owner1
Gui, 1:+Disabled
Gosub, BundleEditor
Return

;Enter:: ; not present but default Gui action, paste text from part1

^Enter:: ; paste text from part1 EVEN if snippet has script e.g. don't run script
ctrlenter:
If (ScriptPaused = 0)
	{
	 StoreScriptPaused = 0
	 ScriptPaused = 1
	}
Gosub, Paste
If (ScriptPaused = 1) and (StoreScriptPaused = 0)
	ScriptPaused = 0
StoreScriptPaused=
Return

+Enter:: ; paste text from part2, but if there is a script, run the script
shiftenter:
PastText1=0
Gosub, Paste
Return

^+Enter:: ; paste text from part2 EVEN if snippet has script e.g. don't run script
shiftctrlenter:
If (ScriptPaused = 0)
	{
	 StoreScriptPaused = 0
	 ScriptPaused = 1
	}
PastText1=0
Gosub, Paste
If (ScriptPaused = 1) and (StoreScriptPaused = 0)
	ScriptPaused = 0
Return

Up::
PreviousPos:=LV_GetNext()
If (PreviousPos = 0) ; exeption, focus is not on listview this will allow you to jump to last item via UP key
	{
	 ControlSend, SysListview321, {End}, %AppWindow%
	 Return
	}
ControlSend, SysListview321, {Up}, %AppWindow%
ItemsInList:=LV_GetCount()
ChoicePos:=PreviousPos-1
If (ChoicePos <= 1)
	ChoicePos = 1
If (ChoicePos = PreviousPos)
	ControlSend, SysListview321, {End}, %AppWindow%
ShowPreview(PreviewSection)
ControlFocus, Edit1, %AppWindow%
Return

Down::
PreviousPos:=LV_GetNext()
ControlSend, SysListview321, {Down}, %AppWindow%
ItemsInList:=LV_GetCount()
ChoicePos:=PreviousPos+1
If (ChoicePos > ItemsInList)
   ChoicePos := ItemsInList
If (ChoicePos = PreviousPos)
    ControlSend, SysListview321, {Home}, %AppWindow%
ShowPreview(PreviewSection)
ControlFocus, Edit1, %AppWindow%
Return

Pgdn::
	IfWinNotActive, %AppWindow%,
		{
		 Send, {PgDn}
		 Return
		}
	ControlGetFocus, CurrCtrl, %AppWindow%
	If (CurrCtrl = "Edit1")
		ControlSend, SysListView321, {Down %VisibleRows%}, %AppWindow%
Return

Pgup::
	IfWinNotActive, %AppWindow%,
		{
		 Send, {Pgup}
		 Return
		}
	ControlGetFocus, CurrCtrl, %AppWindow%
	If (CurrCtrl = "Edit1")
		ControlSend, SysListView321, {Up %VisibleRows%}, %AppWindow%
Return

#IfWinActive

#IfWinActive Lintalist bundle editor
$Rbutton::
ControlGetFocus, Control, Lintalist bundle editor
If Control not in Edit2,Edit3
	Send {Rbutton}
Else
	Menu, Editor, Show
Return
#IfWinActive

ToggleView:
Gosub, GuiToggleSettings
ControlGetText, CurrText, Edit1, %AppWindow% ; 20110623
Return

; Assorted labels -----------------------
; If you type some text and hit the SHORTCUT key it will see if it matches an abbreviation or fire up search if it doesn't
ShortText:
GetActiveWindowStats()
WhichBundle()
ClipSet("s",1) ; safe current content and clear clipboard
ClearClipboard()
Clipboard=
SendKey(SendMethod, "^c") ; this is where it goes wrong for some editors - see DOC, not a program of lintalist or ahk but certain editors behave differently. (when nothing is selected they will copy an entire line)
If (Clipboard = "")
	SendKey(SendMethod, "^+{Left}^x")
ViaText=1
Typed:=Clipboard ; ??
; You pressed hotkey defined in the active bundle

ShortCut:
GetActiveWindowStats()
WhichBundle()
StringTrimLeft, ThisHotkey, A_ThisHotkey, 1
If ((ViaText = 0) or (ViaText = "")) ; if not Via ShortText search in defined hotkeys
	{
	 HitKeyHistory:=CheckHitList("HotKey", ThisHotkey, Load)
	}
Else If ((ViaText = 1) or (ViaShorthand = 1)) ; search in defined abbreviations
	{
	 Back:=StrLen(Typed) + 1
	 If (HitKeyHistory = "")
		HitKeyHistory:=CheckHitList("ShortHand", Typed, Load)
	}

StringTrimRight, HitKeyHistory, HitKeyHistory, 1
StringRight, CheckHitKey, HitKeyHistory, 1

If ((CheckHitKey = "_") or (CheckHitKey = "")) ; No hit, so simply send hotkey otherwise original hotkey in program stops working e.g. ^b bold in Office
	{
	 If (ViaText <> 1)
		{
		 StringLower, ThisHotkey, ThisHotkey
		 Loop, parse, SendKeysToFix, CSV
		 	StringReplace, ThisHotkey, ThisHotkey, %A_LoopField%, {%A_LoopField%}
		 Send %ThisHotkey%
		 Return
		}
	}

If ((HitKeyHistory = "") and (ViaText = 1)) ; No hit so start searching
	{
	 JumpSearch=1
	 Gosub, GUIStart
	 Return
	}

If InStr(HitKeyHistory, ",") ; CSV indicates multiple hits so create gui for selecting which one
	{
	 ClipQ1=
	 Loop, Parse, HitKeyHistory, CSV
		{
		 HkHm%A_Index%:=A_LoopField
		 StringSplit, MenuText, A_LoopField, _
		 ClipQ1 .= MenuName_%MenuText1% "|"
		}
	 MultipleHotkey=1
	 Gui, 10:Destroy
	 Gui, 10:+Owner +AlwaysOnTop
	 Gui, 10:Add, ListBox, w400 h100 x5 y5 vItem gChoiceMouseOK AltSubmit,
	 Gui, 10:Add, button, default gChoiceOK hidden, OK
	 GuiControl, 10: , ListBox1, |
	 GuiControl, 10: , ListBox1, %ClipQ1%
	 Gui, 10:Show, w410 h110, Select bundle
	 ControlSend, ListBox1, {Down}, Select bundle
	 Return
	}
Else ; only one hit e.g. unique shortcut
	{
	 Paste:=HitKeyHistory
	 PastText1=1
	 If (ViaShorthand = 1) and (Paste <> "")
		{
		 Send, {Blind}{BS %back%}
		}
	 Gosub, ViaShortCut
	 Return
	}
ViaText=0
ViaShorthand=0
Return

ChoiceMouseOK: ; if selection by mouse
If (A_GuiEvent <> "DoubleClick")
	Return

ChoiceOK: ; selected via Enter
Gui, 10:Submit
Gui, 10:Destroy
MadeChoice=1
If (MultipleHotkey=1) ; via hotkey
	{
	 Paste:=HkHm%Item%
	 PastText1=1
	 If (ViaText=1) AND (ViaShorthand=1)
		{
		 Back:=StrLen(Clipboard) + 1
		 Send {BS %back%}
		}
	 ViaText = 0 ;???
	 Gosub, ViaShortCut
	}
Else If (MultipleHotkey=0) ; choice gui (see ProcessText label)
	{
	 StringReplace, Clip, Clip, [[Choice=%Clipq1%]], %Item%
	 Item=
	 MultipleHotkey=0
	 Gosub, ProcessText
	}
AppendToBundle:=HkHm%Item% ; for use Editor
Return

10GuiClose:
10GuiEscape:
MadeChoice = 1
InEditMode = 0
EditMode =
Gui, 10:Destroy
Gui, 1:-Disabled
Gui, 71:Destroy
WinActivate, %AppWindow%
Return

1GuiClose:
1GuiEscape:
WinGetPos, X, Y, , ,  %AppWindow% ; remember position set by user
XY:=X "|" Y
Gui, 1:Destroy
CurrText=
LastText=ladjflsajfasjflsdjlleiei
ViaText=0
ViaShorthand=0
Return

; for traymenu
TrayMenuHandler:
If (A_ThisMenuItem = "&Help")
	Run, docs\index.html
Else If (A_ThisMenuItem = "Quick Start Guide")
	Gosub, QuickStartGuideMenu
Else If (A_ThisMenuItem = "&Edit Local Bundle")
		{
		 RunWait, %A_AhkPath% include\localbundleeditor.ahk
		 MsgBox, 36, Restart?, In order for any changes to take effect you must reload.`nOK to restart? ; 4+32 = 36
		 IfMsgBox, Yes
			{
			 Gui, 1:Destroy
			 Reload
			}
		}
Else If (A_ThisMenuItem = "&Manage counters")
		{
		 Gosub, SaveSettingsCounters
		 StoreCounters:=Counters
		 StoreLocalCounter_0:=LocalCounter_0
		 SaveUpdatedBundles()
		 RunWait, %A_AhkPath% include\CounterEditor.ahk
		 IniRead, Counters, settings.ini, settings, Counters, 0
		 If (Counters <> StoreCounters)
			{
			 MsgBox, 36, Restart?, In order for any changes to take effect you must reload.`nOK to restart? ; 4+32 = 36
			 IfMsgBox, Yes
			  {
				Gui, 1:Destroy
				ReadCountersIni()
				Reload
			  }
			}
		}
Else If (A_ThisMenuItem = "E&xit")
	ExitApp
Else If (A_ThisMenuItem = "&Reload Bundles")
	Reload
Else If (A_ThisMenuItem = "&Pause Lintalist")
	Gosub, PauseProgram
Else If (A_ThisMenuItem = "&Configuration")
	{
	 IniSettingsEditor("LintaList","settings.ini")
	 MsgBox, 36, Restart?, In order for any changes to take effect you must reload.`nOK to restart? ; 4+32 = 36
	 IfMsgBox, Yes
		{
		 Gui, 1:Destroy
		 Reload
		}
	}
Else If (A_ThisMenuItem = "Pause &Shorthand")
	Gosub, PauseShorthand
Else If (A_ThisMenuItem = "Pause &Shortcut")
	{
	ShortcutPaused:=!ShortcutPaused
	Menu, tray, ToggleCheck, Pause &Shortcut
	Gosub, PauseShortcut
	}
Else If (A_ThisMenuItem = "Pause &Scripts")
	{
	 ScriptPaused:=!ScriptPaused
	 Menu, tray, ToggleCheck, Pause &Scripts
	}

Return
; /for traymenu

;EditMenu
EditMenuHandler:
If (A_ThisMenuItem = "&Edit Snippet`tF4")
	Gosub, EditF4
Else If (A_ThisMenuItem = "&Copy Snippet`tF5")
	Gosub, EditF5
Else If (A_ThisMenuItem = "&Move Snippet`tF6")
	Gosub, EditF6
Else If (A_ThisMenuItem = "&New Snippet`tF7")
	Gosub, EditF7
Else If (A_ThisMenuItem = "&Remove Snippet`tF8")
	Gosub, EditF8
Else If (A_ThisMenuItem = "&New Bundle`tF10")
	Gosub, EditF10
Else If (A_ThisMenuItem = "&Help")
	Run, docs\index.html
Return
;/EditMenu

; for filemenu
MenuHandler:
If (A_ThisMenuItem = "&Load All Bundles")
	{
	 If (LoadAll = 1)
		{
		 LoadAll=0
		 Menu, tray, UnCheck, &Load All Bundles
		 Try
			{
			 Menu, file, UnCheck, &Load All Bundles
			}
		 Catch
			{
			 ;
			}
		}
	 Else If (LoadAll = 0)
		{
		 LoadAll=1
		 Menu, tray, Check, &Load All Bundles
		 Try
			{
		 	 Menu, file, Check, &Load All Bundles
			}
		 Catch
			{
			 ;
			}
		}
	 Lock = 0
	 GuiControl, 1: ,Lock, 0
		LoadBundle()
	 UpdateLVColWidth()
	 Gosub, SetStatusBar
	 ShowPreview(PreviewSection)
	 Loop, parse, MenuName_HitList, |
		{
		 StringSplit, MenuText, A_LoopField, % Chr(5) ; %
		 Menu, file, UnCheck, &%MenuText1%
		}
	 Return
	}
Else
	{
	 LoadTmp=
	 Loop, parse, MenuName_HitList, |
		{
		 StringSplit, MenuText, A_LoopField, % Chr(5) ; %
		 If ("&" . MenuText1 = A_ThisMenuItem)
			{
			 Load:=MenuText2
			 Lock = 1
			 GuiControl, 1:, Lock, 1
			 LoadBundle()
			 UpdateLVColWidth()
				Gosub, SetStatusBar
			 ShowPreview(PreviewSection)
			 LoadAll=0
			 Menu, tray, UnCheck, &Load All Bundles
			 Try
				{
				 Menu, file, UnCheck, &Load All Bundles
				}
			 Catch
				{
				 ;
				}
			 Loop, parse, MenuName_HitList, |
				{
				 StringSplit, MenuText, A_LoopField, % Chr(5) ; %
				 Menu, file, UnCheck, &%MenuText1%
				}
			 Menu, file, Check, %A_ThisMenuItem%
			 Break
			}
		}
	}
Return
; /for filemenu

;EditorMenu
EditorMenuHandler:
If (A_ThisMenuItem = "Insert [[Clipboard]]")
	ControlSend, %Control%, [[Clipboard]], Lintalist bundle editor
Else If (A_ThisMenuItem = "Insert [[Selected]]")
	ControlSend, %Control%, [[Selected]], Lintalist bundle editor
Else If (A_ThisMenuItem = "Insert [[Input=]]")
	ControlSend, %Control%, [[Input=]]{left 2}, Lintalist bundle editor
Else If (A_ThisMenuItem = "Insert [[DateTime=]]")
	ControlSend, %Control%, [[DateTime=]]{left 2}, Lintalist bundle editor
Else If (A_ThisMenuItem = "Insert [[Choice=]]")
	ControlSend, %Control%, [[Choice=]]{left 2}, Lintalist bundle editor
Else If (A_ThisMenuItem = "Insert [[Var=]]")
	ControlSend, %Control%, [[Var=]]{left 2}, Lintalist bundle editor
Else If (A_ThisMenuItem = "Insert [[File=]]")
	ControlSend, %Control%, [[File=]]{left 2}, Lintalist bundle editor
Else If (A_ThisMenuItem = "Insert [[Snippet=]]")
	ControlSend, %Control%, [[Snippet=]]{left 2}, Lintalist bundle editor
Else If (A_ThisMenuItem = "Insert [[Counter=]]")
	ControlSend, %Control%, [[Counter=]]{left 2}, Lintalist bundle editor
Else If (A_ThisMenuItem = "Insert [[Calendar=]]")
	ControlSend, %Control%, [[Calendar=]]{left 2}, Lintalist bundle editor
Else If (A_ThisMenuItem = "Insert [[C=]]")
	ControlSend, %Control%, [[C=]]{left 2}, Lintalist bundle editor
Return
;/EditorMenu

PauseShortcut: ; Toggle Hotkeys defined in Bundles
;ShortcutPaused:=!ShortcutPaused
;Menu, tray, ToggleCheck, Pause &Shortcut
Loop, parse, Group, CSV
	{
	 Bundle:=A_LoopField
	 Loop, parse, HotKeyHitList_%Bundle%, % Chr(5) ; %
		{
		 StringSplit, _h, A_LoopField, % Chr(7) ; %
		 If (_h1 <> "")
			{
			 If (ShortcutPaused = 0) ; for some reason Toggle doesn't work so hence the On/Off method
				{
				 Hotkey, IfWinNotActive , Lintalist bundle editor
				 Hotkey, $%_h1%, On
				 Hotkey, IfWinNotActive
				}
			 else If (ShortcutPaused = 1)
				{
				 Hotkey, IfWinNotActive , Lintalist bundle editor
				 Hotkey, $%_h1%, Off
				 Hotkey, IfWinNotActive
				}
			}
		 _h1= ; clear vars
		 _h2=
		}
	}

Return

PauseShorthand:
ShorthandPaused:=!ShorthandPaused
Menu, tray, ToggleCheck, Pause &Shorthand
Return

PauseProgram:
PauseToggle:=!PauseToggle
If PauseToggle
  {
   Menu, tray, Tip, %AppWindow% - inactive
   Menu, tray, icon, icons\lintalist_suspended.ico, , 1
  }
Else
  {
   Menu, tray, Tip, %AppWindow% - active`nPress %StartSearchHotkey% to start search...
   Menu, tray, icon, icons\lintalist.ico, , 1
  }
Menu, tray, ToggleCheck, &Pause Lintalist
Suspend
Return


SetStatusBar:
MenuNames=
ListTotal=0
Loop, parse, load, CSV
	{
	 MenuNames .= MenuName_%A_LoopField% "`; "
	 ListTotal += Snippet[A_LoopField].MaxIndex() ; List_%A_LoopField%_0
	 ListTotal -= List_%A_LoopField%_Deleted ; this keeps track of how many snippets where deleted from the bundle to correctly update the statusbar
	}
StringTrimRight, MenuNames, MenuNames, 2
SB_SetText(MenuNames,1) ; show active file in statusbar
SB_SetText(ListTotal . "/" . ListTotal ,2) ; show hits / total
Return

; check if text to paste has any special parameters [[ClipCommands - you can write your own plugins see DOCs for more info
ProcessText:
	Loop ; get personal variables first... only exception from the plugins as it is a built-in feature with the local bundle editor as well
		{
		 If (InStr(Clip, "[[Var=") = 0)
			break
		 RegExMatch(Clip, "iU)\[\[Var=([^[]*)\]\]", ClipQ, 1)
		 StringReplace, clip, clip, [[Var=%ClipQ1%]], % LocalVar_%ClipQ1%, All ; %
		}

	 Loop, parse, ClipCommand, |
		{
		 If (A_LoopField = "")
			Continue
		 If InStr(Clip, A_LoopField)
			{
			 Filter:=SubStr(A_LoopField, 3)
			 Gosub, GetSnippet%Filter%
			}
		 If (Filter = "Image")
			Break
		}


If (RegExMatch(Clip, "i)(" ClipCommandRE ")") > 0) ; make sure all "plugins" are processed before proceeding
	Gosub, ProcessText

Return

CheckCursorPos()
	{
	 Global BackLeft, BackUp
	 BackLeft=0
	 BackUp=0
	 If InStr(Clipboard, "^|") ; Find caret pos after paste
		{
		 Clip:=Clipboard
		 StringReplace, Clip, Clip, `r, , All ; remove `r as we don't need these for caret pos
		 UpLines:=SubStr(Clip,InStr(Clip,"^|")+2)
		 StringReplace, UpLines, UpLines, `n, `n, UseErrorLevel
		 BackUp:=ErrorLevel
		 If (BackUp > 0)
			{
		  	 BackLeft:=StrLen(SubStr(UpLines,1,InStr(UpLines,"`n")))-1
		 	}
		 Else If (BackUp = 0)
			BackLeft:=StrLen(UpLines)
		 StringReplace, Clipboard, Clipboard, ^|, ,All
		 UpLines=
		 Clip=
		}
	}

CheckTyped(TypedChar,EndKey)
	{
	 Global
	 If (ShorthandPaused = 1) or (InEditMode = 1) ; Expansion of abbreviations is suspended OR we are in editor mode
		Return
	 IfWinActive, %AppWindow% ; if Lintalist GUI is active return e.g. Expansion of abbreviations is suspended
	{
		 Return
	}
	 If (EndKey = "EndKey:Backspace")
		{
		 StringTrimRight, Typed, Typed, 1
		 Return
		}
	 HitKeyHistory=
	 GetActiveWindowStats()
	 WhichBundle()
	 If (EndKey <> "Max")
		{
		 If EndKey not in %TriggerKeys%
			{
			 Typed=
			 Return
			}
		 If EndKey in %TriggerKeys%
			{
			 If (Typed = "")
				Return
			 HitKeyHistory:=CheckHitList("Shorthand", Typed, Load)

			 If (HitKeyHistory <> "")
				{
				 ViaText=1
				 ViaShorthand=1
				 Gosub, ShortCut
				 Typed=
				 Back=
		 		 ViaText=0
				 ViaShorthand=0
				 HitKeyHistory=
				}
			}
		 typed=
		}
	 Else
		typed .= TypedChar
	}

BuildEditMenu:
Try
	{
	 Menu, Edit, DeleteAll
	}
Catch
	{
	 ;
	}

Menu, Edit, Add, &Edit Snippet`tF4,  EditMenuHandler
Menu, Edit, Add, &Copy Snippet`tF5,  EditMenuHandler
Menu, Edit, Add, &Move Snippet`tF6,  EditMenuHandler
Menu, Edit, Add, &New Snippet`tF7,   EditMenuHandler
Menu, Edit, Add, &Remove Snippet`tF8,EditMenuHandler
Menu, Edit, Add, &New Bundle`tF10,   EditMenuHandler
Menu, Edit, Add,
Menu, Edit, Add, &Configuration,     TrayMenuHandler
Menu, Edit, Add,
Menu, Edit, Add, &Edit Local Bundle, TrayMenuHandler
Menu, Edit, Add, &Manage counters,   TrayMenuHandler
Menu, Edit, Add,
Menu, Edit, Add, &Help,              TrayMenuHandler
Menu, MenuBar, Add, &Edit, :Edit

Return

BuildFileMenu: ; build File menu (used twice: at start and in bundle editor)
Try
	{
	 Menu, File, DeleteAll
	}
Catch
	{
	 ;
	}
Menu, File, Add, &Load All Bundles, MenuHandler
If (LoadAll = 1)
	 Menu, file, Check, &Load All Bundles
Else If (LoadAll = 0)
	 Menu, file, UnCheck, &Load All Bundles
Menu, File, Add ; add line

Loop, parse, MenuName_HitList, |
	{
	 StringSplit, MenuText, A_LoopField, % Chr(5)
	 Menu, File, Add, % "&"MenuText1, MenuHandler
	}
Menu, File, Add
Menu, File, Add, &Reload Bundles,     TrayMenuHandler
Menu, MenuBar, Add, &Bundle, :File

Return

BuildEditorMenu:
Menu, Editor, Add, Insert [[Clipboard]], EditorMenuHandler
Menu, Editor, Add, Insert [[Selected]] , EditorMenuHandler
Menu, Editor, Add, Insert [[Input=]]   , EditorMenuHandler
Menu, Editor, Add, Insert [[Snippet=]] , EditorMenuHandler
Menu, Editor, Add, Insert [[DateTime=]], EditorMenuHandler
Menu, Editor, Add, Insert [[Counter=]] , EditorMenuHandler
Menu, Editor, Add, Insert [[Calendar=]], EditorMenuHandler
Menu, Editor, Add, Insert [[Choice=]]  , EditorMenuHandler
Menu, Editor, Add, Insert [[Var=]]     , EditorMenuHandler
Menu, Editor, Add, Insert [[File=]]    , EditorMenuHandler
Menu, Editor, Add, Insert [[C=]]       , EditorMenuHandler
Return

; OnExit
SaveSettings:

Gui, 1:Destroy
Gui, 10:Destroy
Gui, 55:Destroy
Gui, 71:Destroy
Gui, 99:Destroy

; INI
; IniWrite, Value, Filename, Section, Key
LastBundle=
Loop, parse, Load, CSV ; store loaded bundles
	LastBundle .= FileName_%A_LoopField% ","
StringTrimRight, LastBundle, LastBundle, 1
IniWrite, %LastBundle%  , Settings.ini, Settings, LastBundle
If (SubStr(DefaultBundle, 0) = ",")
	StringTrimRight, DefaultBundle, DefaultBundle, 1
IniWrite, %DefaultBundle%, Settings.ini, Settings, DefaultBundle
IniWrite, %SearchMethod%, Settings.ini, Settings, SearchMethod
IniWrite, %Load%        , Settings.ini, Settings, Load
IniWrite, %LoadAll%     , Settings.ini, Settings, LoadAll
IniWrite, %Lock%        , Settings.ini, Settings, Lock
IniWrite, %Case%        , Settings.ini, Settings, Case
IniWrite, %Width%       , Settings.ini, Settings, Width
IniWrite, %Height%      , Settings.ini, Settings, Height
IniWrite, %ShorthandPaused%, Settings.ini, Settings, ShorthandPaused
IniWrite, %ShortcutPaused% , Settings.ini, Settings, ShortcutPaused
IniWrite, %ScriptPaused%   , Settings.ini, Settings, ScriptPaused
IniWrite, %ShowQuickStartGuide%, Settings.ini, Settings, ShowQuickStartGuide
Gosub, SaveSettingsCounters
; /INI

; Bundles

; If (A_ExitReason <> "Exit") ; to prevent saving bundles twice which would make the backup routine not work correctly
	SaveUpdatedBundles()

Gosub, CheckShortcuts ; desktop & startup LNK check (either set or delete after changing ini)

ExitApp
Return

; other Include(s)
#Include %A_ScriptDir%\include\editor.ahk
#Include %A_ScriptDir%\plugins\plugins.ahk
#Include %A_ScriptDir%\include\GuiSettings.ahk
#Include %A_ScriptDir%\include\SetShortcuts.ahk
#Include %A_ScriptDir%\include\QuickStart.ahk
#Include %A_ScriptDir%\include\FixURI.ahk
#Include %A_ScriptDir%\include\SetIcon.ahk
#Include %A_ScriptDir%\include\WinClip.ahk    ; by Deo
#Include %A_ScriptDir%\include\WinClipAPI.ahk ; by Deo
#Include %A_ScriptDir%\include\Markdown2HTML.ahk ; by fincs + additions
; /Includes

SaveSettingsCounters:
Counters=
Loop, parse, LocalCounter_0, CSV
	{
	 If (A_LoopField = "")
		Continue
	 Counters .= A_LoopField "," LocalCounter_%A_LoopField% "|"
	}
IniWrite, %Counters%   , Settings.ini, Settings, Counters
Return
