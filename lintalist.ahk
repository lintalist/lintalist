/*

Name            : Lintalist
Author          : Lintalist
Purpose         : Searchable interactive lists to copy & paste text, run scripts,
                  using easily exchangeable bundles
Version         : 1.9.19
Code            : https://github.com/lintalist/
Website         : http://lintalist.github.io/
AutoHotkey Forum: https://autohotkey.com/boards/viewtopic.php?f=6&t=3378
License         : Copyright (c) 2009-2023 Lintalist

This program is free software; you can redistribute it and/or modify it under the
terms of the GNU General Public License as published by the Free Software Foundation;
either version 2 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details.

See license.txt for further details.

*/

; Default settings
#Requires AutoHotkey v1.1.31+ ; we use Switch
#NoEnv
#SingleInstance, force
SetBatchLines, -1
SetTitleMatchMode, 2
ListLines, off
TmpDir:= A_ScriptDir "\tmpscrpts"
CoordMode, ToolTip, Screen
SendMode, Input
;SetKeyDelay, -1
SetWorkingDir, %A_ScriptDir%
FileEncoding, UTF-8
SortDirection:="Sort"
IniFile:="Settings.ini"

PluginMultiCaret:=0 ; TODOMC

; Title + Version are included in Title and used in #IfWinActive hotkeys and WinActivate
Title=Lintalist
Version=1.9.19

; Gosub, ReadPluginSettings

AppWindow=%title% - %version%   ; Name of Gui

If A_IsAdmin
	AppWindow:=A_UserName "^ " AppWindow

GroupAdd, AppTitle, %AppWindow% ; we can now use #IfWinActive with the INI value (main scripts hotkeys)

GroupAdd, BundleHotkeys, Select bundle ahk_class AutoHotkeyGUI
GroupAdd, BundleHotkeys, Append snippet to bundle ahk_class AutoHotkeyGUI
GroupAdd, BundleHotkeys, Select and press enter ahk_class AutoHotkeyGUI
GroupAdd, BundleHotkeys, Lintalist bundle editor ahk_class AutoHotkeyGUI
GroupAdd, BundleHotkeys, Lintalist snippet editor ahk_class AutoHotkeyGUI
GroupAdd, BundleHotkeys, Lintalist counters editor ahk_class AutoHotkeyGUI
GroupAdd, BundleHotkeys, Lintalist local bundle editor ahk_class AutoHotkeyGUI
GroupAdd, BundleHotkeys, Lintalist settings ahk_class AutoHotkeyGUI

OnExit, SaveSettings ; store settings (locked state, search mode, gui size etc in INI + Make sure changes to Bundles are saved)

; /Default settings

; Tray Menu

Menu, Tray, NoStandard
Menu, Tray, Icon, icons\lintalist_suspended.ico ; while loading show suspended icon
Menu, Tray, Add, %AppWindow%,             GlobalMenuHandler
Menu, Tray, Icon, %AppWindow%,            icons\lintalist.ico
Menu, Tray, Default, %AppWindow%
Menu, Tray, Add,
Menu, Tray, Add, &Help,          	      GlobalMenuHandler
Menu, Tray, Icon,&Help,          	      icons\help.ico
Menu, Tray, Add, &About,          	      GlobalMenuHandler
Menu, Tray, Icon,&About,          	      icons\help.ico
Menu, Tray, Add, &Quick Start Guide,      GlobalMenuHandler
Menu, Tray, Icon,&Quick Start Guide,      icons\help.ico
Menu, Tray, Add,
Menu, Tray, Add, &Configuration,          GlobalMenuHandler
Menu, Tray, Icon,&Configuration,          icons\gear.ico
Menu, Tray, Add, &Open Lintalist folder,  GlobalMenuHandler
Menu, Tray, Icon,&Open Lintalist folder,  icons\folder-horizontal-open.ico
Menu, Tray, Add, &View Statistics,        GlobalMenuHandler
Menu, Tray, Icon,&View Statistics,        icons\chart_pie.ico
Menu, Tray, Add,
Menu, Tray, Add, Check for updates,       GlobalMenuHandler
Menu, Tray, Icon,Check for updates,       icons\download.ico
Menu, Tray, Add,
Menu, Tray, Add, &Manage Bundles,         GlobalMenuHandler
Menu, Tray, Icon,&Manage Bundles,         icons\lintalist_bundle.ico
Menu, Tray, Add, &Manage Local Variables, GlobalMenuHandler
Menu, Tray, Icon,&Manage Local Variables, icons\variables.ico
Menu, Tray, Add, &Manage Counters,        GlobalMenuHandler
Menu, Tray, Icon,&Manage Counters,        icons\counter.ico
Menu, Tray, Add,
Menu, Tray, Add, &Load All Bundles,       MenuHandler ; exception
Menu, Tray, Icon,&Load All Bundles,       icons\arrow-in.ico
Menu, Tray, Add, &Reload Bundles (restarts Lintalist),         GlobalMenuHandler
Menu, Tray, Icon,&Reload Bundles (restarts Lintalist),         icons\arrow-retweet.ico
Menu, Tray, Add, &Restart as Administrator, GlobalMenuHandler
Menu, Tray, Icon,&Restart as Administrator, icons\restart-admin.ico
If A_IsAdmin
	 Menu, Tray, Disable, &Restart as Administrator
Menu, Tray, Add,
Menu, Tray, Add, &Pause Lintalist,        GlobalMenuHandler
Menu, Tray, Icon,&Pause Lintalist,        icons\control-pause.ico
Menu, Tray, Add, Pause &Shortcut,         GlobalMenuHandler
Menu, Tray, Icon,Pause &Shortcut,         icons\hotkeys.ico
Menu, Tray, Add, Pause &Shorthand,        GlobalMenuHandler
Menu, Tray, Icon,Pause &Shorthand,        icons\shorthand.ico
Menu, Tray, Add, Pause &Scripts,          GlobalMenuHandler
Menu, Tray, Icon,Pause &Scripts,          icons\scripts.ico
Menu, Tray, Add,
Menu, Tray, Add, E&xit,                   GlobalMenuHandler
Menu, Tray, Icon,E&xit,                   icons\101_exit.ico
Menu, Tray, Check, &Pause Lintalist ; indicate program is still loading
Menu, Tray, Tip, %AppWindow% - inactive
; Tray Menu continue below

; Tray Menu left click handler
OnMessage(0x404, "AHK_NOTIFYICON")

; Includes
; [Note: bundle editor + plugins + GuiSettings included at the end of the script]

#Include %A_ScriptDir%\include\ObjectBundles.ahk
#Include %A_ScriptDir%\include\StayOnMonitor.ahk
#Include %A_ScriptDir%\include\ReadIni.ahk
#Include %A_ScriptDir%\include\ReadTheme.ahk
#Include %A_ScriptDir%\include\Default.ahk
#Include %A_ScriptDir%\include\Func_IniSettingsEditor_v6.ahk
; /Includes

; command line parameters

if 0 > 0  ; check cl parameters
	{
	 Loop, %0%  ; For each parameter:
		{
		 param := %A_Index%  ; Fetch the contents of the variable whose name is contained in A_Index.
		 if (param = "-Active")
			cl_Active:=1
		 if (param = "-ReadOnly") ; possible to expand to various options, see discussion https://github.com/lintalist/lintalist/issues/95 
			{
			 cl_ReadOnly:=1
			 AppWindow:="*" AppWindow
			}
		 if (param = "-Administrator") 
			{
			 cl_Administrator:=1
			 AppWindow:=A_UserName "^ " AppWindow
			}
		 if InStr(param,"-Bundle")
			{
			 cl_Bundle:=StrSplit(param,"=").2
			 If !FileExist(A_ScriptDir "\bundles\" cl_Bundle)
				cl_Bundle:=""
			}
		 if InStr(param,"-Ini")
			 IniFile:=StrSplit(param,"=").2
		 param:=""
		}
	}

; /command line parameters

; INI ---------------------------------------
ReadIni()

If (Administrator = 1) or (cl_Administrator = 1)
	{
	 Administrator:=1
	 If !A_IsAdmin
		Gosub, RunAdmin
	}

ReadMultiCaretIni()
ReadAltPasteIni()
ReadLineFeedIni()
If Statistics
	Statistics()
Else
	{
	 
	 Menu, Tray, Disable, &View Statistics
	}

if cl_Bundle
	{
	 LastBundle:=cl_Bundle
	 Lock:=1
	}

Gosub, ChoiceWindowPosition ; for choice plugin
Gosub, EditorWindowPosition ; for snippet editor

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

; Dynamic Gui elements, positions etc.
Gosub, GuiStartupSettings
; /Dynamic Gui settings

; theme
If Theme
	ReadTheme(theme)
Gosub, ReadThemeEditorIcons

PastText1=1
LoadAllBundles()
LoadPersonalBundle()
Menu, Tray, Icon, icons\lintalist.ico ; loading is done so show active Icon
Menu, tray, UnCheck, &Pause Lintalist
Menu, tray, Tip, %AppWindow% - active`nPress %StartSearchHotkey% to start search...
Menu, Tray, Rename, %AppWindow%, %AppWindow% - %StartSearchHotkey%
if (MinLen > 1)
	MinLen--

Gosub, BuildFileMenu
Gosub, BuildEditMenu
Gosub, BuildEditorMenu
Gosub, QuickStartGuide

; setup hotkey

; check for programs that may use Capslock already and display warning

If (StartSearchHotkey = "Capslock")
	Loop, parse, % "nvda.exe", CSV
		{
		 Process, Exist, %A_LoopField%
		 If ErrorLevel
			MsgBox, 64, Lintalist, %A_LoopField% is running may conflict with Capslock.`nChange the Lintalist Hotkey in the Configuration.`nLook for the StartSearchHotkey setting.`n`nYou can find the Configuration option in the tray menu or`nvia the Edit, Configuration menu in the Lintalist search window.
		}

; check capslock and ScrollLock status so we can actually use them as hotkey if defined by user and 
; they are already in the DOWN (active) state when Lintalist is started

ProgramHotKeyList:="StartSearchHotkey,StartOmniSearchHotkey,QuickSearchHotkey,ExitProgramHotKey"
Loop, parse, ProgramHotKeyList, CSV
	{
	 If (%A_LoopField% = "CAPSLOCK") and (GetKeyState("CAPSLOCK","T") = 1) ; is set as hotkey, so we need to turn it off
		{
		 SetCapsLockState, Off
		 MsgBox, 64, Lintalist, Capslock has been turned off as it is now used by Lintalist.
		}
	 If (%A_LoopField% = "SCROLLLOCK") and (GetKeyState("SCROLLLOCK","T") = 1)
		{
		 SetScrollLockState, Off
		 MsgBox, 64, Lintalist, ScrollLock has been turned off as it is now used by Lintalist.
		}
	}

IsNVDARunning:=IsNVDARunning() ; used for up/down in listview as it looks like NVDA may have some issues with up/down navigation when listview NOT in focus/selected

Hotkey, IfWinNotExist, ahk_group BundleHotkeys
Hotkey, %StartSearchHotkey%, GUIStart
If (StartOmniSearchHotkey <> "")
	Hotkey, %StartOmniSearchHotkey%, GUIStartOmni
If (QuickSearchHotkey <> "")
	Hotkey, %QuickSearchHotkey%, ShortText
If (QuickSearchHotkey2 <> "")
	Hotkey, %QuickSearchHotkey2%, ShortText2
If (ExitProgramHotKey <> "")
	Hotkey, %ExitProgramHotKey%, SaveSettings
Hotkey, IfWinNotExist

Hotkey, IfWinActive, ahk_group AppTitle
Hotkey, %QueryHotkey%, RunQuery
Hotkey, IfWinActive
ProgramHotKeyList:=""

ViaShorthand=0

; Toolbar setup
; Create an ImageList.
ILA := IL_CreateCustom(18, 5, IconSize) ; TODO BIGICONS

ILA_List:="snippet_new,snippet_edit,snippet_copy,scripts,hotkeys,shorthand,lettervariations,unlocked,case,search_1,search_2,search_3,search_4,locked,no_scripts,no_hotkeys,no_shorthand,pin-to-top"


Loop, parse, ILA_List, CSV
	{
	 If FileExist("themes\icons\" A_LoopField "_" theme["path"] ".ico")
		IL_Add(ILA, "themes\icons\" A_LoopField "_" theme["path"] ".ico")
	 else
		IL_Add(ILA, "icons\" A_LoopField ".ico")
	}

MyToolbarIcons:={ "UnLocked" : "8"
	, "Locked" : "14"
	, "Scripts" : "4"
	, "NoScripts" : "15"
	, "Hotkeys" : "5"
	, "NoHotkeys" : "16"
	, "ShortHand" : "6"
	, "NoShortHand" : "17" 
	, "PinTop" : "18" }

; https://autohotkey.com/board/topic/94750-class-toolbar-create-and-modify-updated-19-08-2013/?p=599930
IL_CreateCustom(InitialCount=18, GrowCount=5, IconSize=16)
	{
	 return DllCall("ImageList_Create"
			, "Int", IconSize
			, "Int", IconSize
			, "UInt", 0x00000001 + 0x00000020
			, "Int", InitialCount
			, "Int", GrowCount)
	}
; /Toolbar setup

; Listview ColorList
lvc:={1: "0xF5F5E2", 2: "0xF9F5EC", 3: "0xF9F3EC", 4: "0xF9EFEC", 5: "0xF5E8E2", 6: "0xFAF2EF", 7: "0xF8F1F1", 8: "0xFFEAEA", 9: "0xFAE7EC", 10: "0xFFE3FF", 11: "0xF8E9FC", 12: "0xEEEEFF", 13: "0xEFF9FC", 14: "0xF2F9F8", 15: "0xFFECEC", 16: "0xFFEEFB", 17: "0xFFECF5", 18: "0xFFEEFD", 19: "0xFDF2FF", 20: "0xFAECFF", 21: "0xF1ECFF", 22: "0xFFECFF", 23: "0xF4D2F4", 24: "0xF9EEFF", 25: "0xF5EEFD", 26: "0xEFEDFC", 27: "0xEAF1FB", 28: "0xDBF0F7", 29: "0xEEEEFF", 30: "0xECF4FF", 31: "0xF9FDFF", 32: "0xE6FCFF", 33: "0xF2FFFE", 34: "0xCFFEF0", 35: "0xEAFFEF", 36: "0xE3FBE9", 37: "0xF3F8F4", 38: "0xF1FEED", 39: "0xE7FFDF", 40: "0xF2FFEA", 41: "0xFFFFE3", 42: "0xFCFCE9"}

; /INI --------------------------------------

SendKeysToFix=Enter,Space,Esc,Tab,Home,End,PgUp,PgDn,Up,Down,Left,Right,F1,F2,F2,F3,F4,F5,F6,F7,F8,F9,F10,F11,F12,AppsKey
;TerminatingCharacters={Alt}{LWin}{RWin}{Shift}{enter}{space}{esc}{tab}{Home}{End}{PgUp}{PgDn}{Up}{Down}{Left}{Right}{F1}{F2}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}.,¿?¡!'"()[]{}{}}{{}~$&*-+=\/><^|@#:`%;  ; "%
TerminatingCharacters={Alt}{LWin}{RWin}{enter}{space}{esc}{tab}{Home}{End}{PgUp}{PgDn}{Up}{Down}{Left}{Right}{F1}{F2}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}  ; "%
CheckTypedLoop:
Gui, 10:Destroy
Loop
	{
	 ;Get one key at a time
	 if (cl_Active = 1) or (ActivateWindow = 1)
		{
		 Gosub, GuiStart
		 cl_Active:=0, ActivateWindow:=0
		}
	 Input, TypedChar, L1 V I, {BS}%TerminatingCharacters%
	 CheckTyped(TypedChar,ErrorLevel)
	}
Return

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

GUIStartOmni:
OmniSearch:=1
GuiStart: ; build GUI
If Statistics
	 Stats("SearchGui")
OmniSearchText:=""
LastText = fadsfSDFDFasdFdfsadfsadFDSFDf
If !MenuToggleView ; if we toggle via the menu we should skip the hide/show option
	{
	 If WinActive(AppWindow) and StartSearchHotkeyToggle
		{
		 PlaySound(PlaySound,"close")
		 Gosub, GuiClose
		 Return
		}
	}
MenuToggleView:=0
If !WinActive(AppWindow)
	GetActiveWindowStats()
Else
	Gosub, ToggleView

Gui, 1:Destroy ; just to be sure
	
If Theme["MainBackgroundColor"]
	Gui, 1: Color, % Theme["MainBackgroundColor"]
Gui, 1:+Border +Resize +MinSize%Width%x%Height%

Gui, 1:Menu, MenuBar
Gui, 1:Add, Picture, x4 y4 w%SearchIconSize% h-1, icons\search.ico ; TODO BIGICONS
Gui, 1:Font, s%SearchFontSize% ; TODO BIGICONS
Gui, 1:Add, Edit, hwndEDID1 0x8000 x%SearchBoxX% y%SearchBoxY% w%SearchBoxWidth% h%SearchBoxHeight% -VScroll -HScroll gGetText vCurrText, %CurrText% ; TODO BIGICONS
Gui, 1:Add, Button, x300 y2 w30 h20 0x8000 Default hidden gPaste, OK
Gui, 1:Font ; TODO BIGICONS

; TBSTYLE_FLAT     := 0x0800 Required to show separators as bars.
; TBSTYLE_TOOLTIPS := 0x0100 Required to show Tooltips.

If !IsNVDARunning
	Gui, 1:Add, Custom, ClassToolbarWindow32 hwndhToolbar 0x0800 0x0100 0x0008 0x0040 x%barx% y%Yctrl% w580 ; TODO BIGICONS
else if IsNVDARunning ; skip tooltips to avoid it being read twice (button name + tooltip)
	Gui, 1:Add, Custom, ClassToolbarWindow32 hwndhToolbar 0x0800 0x0008 0x0040 x%barx% y%Yctrl% w580 ; TODO BIGICONS

Gui, 1:Font,s%fontsize%,%font%

If !Theme["ListViewTextColor"]
	Theme["ListViewTextColor"]:="black"

If !Theme["ListViewBackgroundColor"]
	Gui, 1:Add, Listview, % ShowGrid " count500 x2 y" YLView " xLV0x100 LV0x10000 hwndHLV vSelItem AltSubmit gClicked h" LVHeight " w" LVWidth " ", Paste (Enter)|Paste (Shift+Enter)|Key|Short|Index|Bundle ; TODO BIGICONS
else if Theme["ListViewBackgroundColor"]
	Gui, 1:Add, Listview, % ShowGrid " count500 x2 y" YLView " xLV0x100 LV0x10000 hwndHLV vSelItem AltSubmit gClicked h" LVHeight " w" LVWidth " c" Theme["ListViewTextColor"] " Background" Theme["ListViewBackgroundColor"], Paste (Enter)|Paste (Shift+Enter)|Key|Short|Index|Bundle ; TODO BIGICONS

Gui, 1:Add, edit, hwndEDID2  x0 yp+%LVHeight%+2 -VScroll w%LVWidth% h%PreviewHeight%, preview

If Theme["PreviewBackgroundColor"]
	 CtlColors.Attach(EDID2, Theme["PreviewBackgroundColor"], Theme["PreviewTextColor"])

Gui, 1:Font, s8, Arial
If Theme["StatusBarBackgroundColor"]
	Gui, 1:Add, StatusBar, % "Background" Theme["StatusBarBackgroundColor"] " -Theme" 
else
	Gui, 1:Add, StatusBar,,
SB1:=Round(.8*Width)
SB2:=Width-SB1
SB_SetParts(SB1,SB2)
SB_SetIcon("icons\lintalist_bundle.ico",,1)
SB_SetIcon("icons\search.ico",,2)
; Gosub, GetText ; commented v1.9.3

; Initialize Toolbars.
; The variable you choose will be your handle to access the class for your toolbar.
MyToolbar := New Toolbar(hToolbar)

; Set ImageList.
MyToolbar.SetImageList(ILA)
; Add buttons; vertical bars count as buttons when calling them via their ID
MyToolbar.Add("Enabled"
	, "EditF7=New Snippet (F7):1"
	, "EditF4=Edit Snippet (F4):2"
	, "EditF5=Copy Snippet (F5):3"
	, "" ; vertical bar
	, "PauseScriptButton=Toggle Scripts:4"
	, "PauseShortcutButton=Toggle Shortcuts:5"
	, "PauseShorthandButton=Toggle Shorthand:6"
	, "" ; vertical bar
	, "SearchLetterVariations=Letter Variations (alt+v):7"
	, "Lock=Lock (alt+l):8"
	, "Case=Case Sensitive (alt+c):9"
	, "" ; vertical bar
	, "Label10=Regular Search (alt+r):10"
	, "Label11=Fuzzy Search (alt+z):11"
	, "Label12=Regular Expression Search (alt+x):12"
	, "Label13=Magic Search (alt+m):13"
	, "" ; vertical bar
	, "GuiOnTop=Pin to top:18")

; Should the button bar be changed we don't need to update all the
; MyToolbar.ModifyButton calls, we can just update the IDs here.
MyToolbarIDs:={ "NewSnippet" : "1"
	, "EditSnippet" : "2"
	, "CopySnippet" : "3"
	, "ToggleScripts" : "5"
	, "ToggleShortcuts" : "6"
	, "ToggleShorthand" : "7"
	, "ToggleLetterVariations" : "9"
	, "ToggleLock" : "10"
	, "ToggleCase" : "11"
	, "RegularSearch" : "13"
	, "FuzzySearch" : "14"
	, "RegExSearch" : "15"
	, "MagicSearch" : "16"
	, "OnTop" : "18" }

; Removes text labels and show them as tooltips.
MyToolbar.SetMaxTextRows(0)

; Set a function to monitor the Toolbar's messages.
WM_COMMAND := 0x111
OnMessage(WM_COMMAND, "TB_Messages")

; Set a function to monitor notifications.
WM_NOTIFY := 0x4E
OnMessage(WM_NOTIFY, "TB_Notify")

Gosub, TB_SetButtonStates

XY:=StayOnMonXY(Width*DPIFactor()+20, Height*DPIFactor()+80, Mouse, MouseAlternative, Center) ; was XY:=StayOnMonXY(Width, Height, 0, 1, 0)
StringSplit, Pos, XY, |
Try
	Gui, 1:Show, w%Width% h%Height% x%Pos1% y%Pos2%, %AppWindow%
Catch
	Gui, 1:Show, w760 h400, %AppWindow%
	
If (DisplayBundle > 1)
	 CLV := New LV_Colors(HLV)

If (JumpSearch=1) ; Send clipboard text to search control
	{
	 JumpSearch=0
	 GuiControl, 1:, Edit1, %clipboard%
	 ControlSend, Edit1, {End}, %AppWindow%
	 Sleep 100     ; added as a fix to avoid duplicate search results, not sure if it helps
	 Gosub, GetText
	 UpdateLVColWidth()
	}
ControlSend, Edit1, {End}, %AppWindow%  ; 20110623

Gosub, GetText                          ; 20110623
PlaySound(PlaySound,"open")

If Theme["SearchBoxBackgroundColor"]
	 CtlColors.Attach(EDID1, Theme["SearchBoxBackgroundColor"], Theme["SearchBoxTextColor"])
SetEditCueBanner(EDID1, "Type to search (Ctrl+f)")

Return

; Incremental Search, here is where the magic starts, based on 320mph version by Fures, if you know of an even FASTER way let me know ;-)

GetText:
Critical, 50 ; experimental-v1.7
;MsgBox % "y1-----" Snippet[1,1,1] ; debug
StartTime := A_TickCount
ControlGetText, CurrText, Edit1, %AppWindow%
If QueryDelimiter
	{
	 Gosub, LLQuery
	 CurrText:=Query[1]
	}

If (CurrText = LastText)
	{
	 Critical, off ; experimental-v1.7
	 Return
	}
CurrLen:=StrLen(CurrText)
; LoadBundle() ; 20121209
If (CurrLen = 0) or (CurrLen =< MinLen)
	{
	 LoadBundle()
	 UpdateLVColWidth()
	 LastText = fadsfSDFDFasdFdfsadfsadFDSFDf
	 Gosub, SetStatusBar
	 Critical, off ; experimental-v1.7
	 ShowPreview(PreviewSection)
	 Return
	}
Gui, 1:Default
LV_Delete()
GuiControl,1: , Edit2, %A_Space% ; fix preview if no more snippets e.g. ghosting of last snippet

; setup ImageList and define icons
;#Include %A_ScriptDir%\include\ImageList.ahk

If (SubStr(CurrText,1,1) = OmniChar) or (OmniSearch = 1)
	{
	 SearchBundles:=Group
	 OmniSearchText:=" (All)"
	}
Else
	{
	 SearchBundles:=Load
	 OmniSearchText:=""
	}

ColumnID:=""
LastText:=CurrText

ShowPreviewToggle=1
ShortCutSearchGuiCounter:=0
Loop, parse, SearchBundles, CSV
	{
	 If (A_TickCount - StartTime > 150) ; was 250 for <1.6 - experimental-v1.7
		ControlGetText, CurrText, Edit1, %AppWindow%
	 If (CurrText <> LastText)
		Goto GetText
	 Bundle:=A_LoopField

	 Max:=Snippet[Bundle].MaxIndex()
	 Loop,% Max ; %
		{
		 A_BundleIndex:=A_Index
		 SearchThis:=""
		 SearchText:=LTrim(CurrText,OmniChar)

		 If ColumnSearchDelimiter and RegExMatch(SearchText,"^[0-5]" ColumnSearchDelimiter)
			{
			Gosub, ColumnSearchText
			SearchText:=ColumnSearchText
			}

		 If SearchLetterVariations and (SearchMethod <> 4)
			SearchText:=LetterVariations(SearchText,Case)

		 match=0
;		 SearchThis1:=Snippet[Bundle,A_Index,1] ; part '1' (enter)
;		 SearchThis2:=Snippet[Bundle,A_Index,2] ; part '2' (shift-enter)
;		 SearchThis3:=Snippet[Bundle,A_Index,4] ; shorthand
		 If ColumnID
			SearchThis:=Snippet[Bundle,A_BundleIndex,ColumnID]
		 else
			{
			 If (ColumnSearch = "") ; could be set in hidden Ini setting
				SearchThis:=Snippet[Bundle,A_BundleIndex,1] " " Snippet[Bundle,A_BundleIndex,2] " " Snippet[Bundle,A_BundleIndex,4] ; part1, part2, shorthand
			 else
				Loop, parse, ColumnSearch, CSV
					SearchThis .= Snippet[Bundle,A_BundleIndex,A_LoopField] " "	
			}

		 If (SearchMethod = 1) ; normal
			{
			 if (SearchLetterVariations = 0)
				Search(SearchMethod)
			 else If (SearchLetterVariations = 1) ; search normal with letter variations making it a RegExMatch search
				Search(3) ; RegEx search
			}
		 else
			Search(SearchMethod)

		If (match > 0) ; we have a match
			{
			 IconVal:=""
		If ShortCutSearchGui
			{
			 ShortCutSearchGuiCounter++
			 If (ShortCutSearchGuiCounter > 11)
				ShortCutSearchGuiCounter:=11
			}
		 If ShortCutSearchGui in 1,3
			 ShortCutSearchGuiText:=ShortCutSearchGuiShow[ShortCutSearchGuiCounter]
		 else
			SearchGuiShortText:=""

			 If (ShowIcons = 1)
				{
				 IconVal:=SetIcon(Snippet[Bundle,A_BundleIndex],Snippet[Bundle,A_BundleIndex,5],ShortCutSearchGui,ShortCutSearchGuiCounter)
				}
			 LV_Add(IconVal,ShortCutSearchGuiText Snippet[Bundle,A_BundleIndex,"1v"],Snippet[Bundle,A_BundleIndex,"2v"],Snippet[Bundle,A_BundleIndex,3],Snippet[Bundle,A_BundleIndex,4],Bundle . "_" . A_BundleIndex, MenuName_%Bundle%) ; populate listview
			 If (ShowPreviewToggle = 1) ; do only once to improve speed
				{
				 ShowPreview(PreviewSection)
				 ShowPreviewToggle=0
				}
			 CurrHits:=LV_GetCount()
			 SB_SetText(CurrHits "/" . ListTotal OmniSearchText,2) ; update status bar with hits / total
			 If (CurrHits > MaxRes - 1)              ; stop search after Max results (takes to long anyway)
				Break
			}
		}
	 If (match = 0)
		SB_SetText(LV_GetCount() "/" . ListTotal OmniSearchText,2) ; otherwise it won't show zero results

	}

If (CurrHits = 1) and (QuickSearchHotkeyPart2 = 0) and (AutoExecuteOne <> 0)
	{
	 if (AutoExecuteOne = 1)
		Gosub, paste
	 else if (AutoExecuteOne = 2)
		Gosub, shiftenter
	}
else If (CurrHits = 1) and (QuickSearchHotkeyPart2 = 1) and (AutoExecuteOne <> 0)
	Gosub, shiftenter

If (DisplayBundle > 1)
	Gosub, ColorList

If (ColumnSort <> "NoSort")
	SortResults(ColumnSortOption1,ColumnSortOption2,SortDirection)
Return

Search(mode=1)
	{
	 global
	 if (Mode = 1) ; normal
		{
		 ;If (InStr(SearchThis1,SearchText,Case) > 0) or (InStr(SearchThis2,SearchText,Case) > 0) or (InStr(SearchThis3,SearchText,Case) > 0)
		 If (InStr(SearchThis,SearchText,Case) > 0)
			{
			 Match++
			}
		}

	 else if (Mode = 2) ; fuzzy search as of v1.7 using RegExMatch - could be slower
		{
		 SearchRe:=RegExReplace(SearchText,"imU)([\.\*\?\+\{\}\\^\$\(\)])","\$1") ; we need to escape regex symbols - [] are excluded atm
		 if InStr(SearchRe,A_Space) ; prepare regular expression to ensure search is done independent on the position of the words
			SearchRe:="(?=.*" RegExReplace(Trim(SearchRe," "),"iUms)(.*)\s","$1)(?=.*") ")"
		 SearchRe:="iUmsS)" SearchRe
		 If (Case = 1)     ; case sensitive, remove i) option
			SearchRe := LTrim(SearchRe,"i")
		 ;;;;ToolTip, % "Case: " case " : SearchRe: " SearchRe ; debug only
;		 If (RegExMatch(SearchThis1, SearchRe) > 0) or (RegExMatch(SearchThis2, SearchRe) > 0) or (RegExMatch(SearchThis3, SearchRe) > 0)
		 If (RegExMatch(SearchThis, SearchRe) > 0)
			{
			 Match++
			}
		}

	 else if (Mode = 3) ; Regular expression search
		{
		 If (SearchMethod = 1) ; normal
			SearchRe:=RegExReplace(SearchText,"imU)([\.\*\?\+\{\}\\^\$\(\)])","\$1") ; we need to escape regex symbols - [] are excluded atm
		 If (Case = 0)     ; case insensitive, add auto i) option
			SearchRe := "i)" . SearchText
		 Else
			SearchRe := SearchText
		 ;If (RegExMatch(SearchThis1, SearchRe) > 0) or (RegExMatch(SearchThis2, SearchRe) > 0) or (RegExMatch(SearchThis3, SearchRe) > 0)
		 If (RegExMatch(SearchThis, SearchRe) > 0)
			{
			 Match++
			}
		}

	 else if (Mode = 4) ; Magic search
		{
		 SearchRe:="iUmsS)"
		 Loop, parse, SearchText
			SearchRe .= LetterVariations(A_LoopField,case) ".*"
		 SearchRe:=RTrim(SearchRe,".*")
		 If (Case = 1)     ; case sensitive, remove i) option
			SearchRe := LTrim(SearchRe,"i")

		 ;;;;ToolTip, % "Case: " case " : SearchRe: " SearchRe ; debug only
		 ;If (RegExMatch(SearchThis1, SearchRe) > 0) or (RegExMatch(SearchThis2, SearchRe) > 0) or (RegExMatch(SearchThis3, SearchRe) > 0)
		 If (RegExMatch(SearchThis, SearchRe) > 0)
			{
			 Match++
			}
		}

	}

ColorList:
If (LV_GetCount() = 0)
	Return
GuiControl, -Redraw, SelItem
Loop, % LV_GetCount()
	{
	 LV_GetText(Paste, A_Index, 5) ; get bundle_index from 5th column which is always hidden
	 StringSplit, paste, paste, _
	 CLV.Row(A_Index, lvc[paste1], 0x000000)
	}
GuiControl, +Redraw, SelItem
Return

; (Double)click in listview, action defined in INI
Clicked:
	;  user has right-clicked within the listview control. The variable A_EventInfo contains the focused row number.
	If (A_GuiEvent = "RightClick")
		{
		 Menu, edit, show ; this is the same menu as used in the Editor, Menubar (edit)
		 Return
		}

	; ignore all other events apart from DoubleClick and normal left-click
	If A_GuiControlEvent not in DoubleClick,Normal
		Return
	IfEqual A_GuiControlEvent, Normal
		{
		 ShowPreview(PreviewSection)
		 If (SingleClickSends = 0) ; if set to 1 in configuration a normal click will act
			Return                 ; the same as a DoubleClick (also configurable)
		}

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
		 gosub, editf4
		}
	else if (DoubleClickSends = 6)
		{
		 gosub, editf7
		}

Return

; We made a selection and now want to paste and process the selected text or run script
Paste:
Gui, 1:Submit, NoHide
If QueryDelimiter
	Gosub, LLQuery
ControlFocus, SysListView321, %AppWindow%
SelItem := LV_GetNext()
If (SelItem = 0)
	SelItem = 1
If PasteResult
	SelItem:=PasteResult
PasteResult:=""	
LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column which is always hidden
Gui, 1:Destroy
CurrText= ; 20110623
if (paste = "") ; there were no search results, this will prevent pasting result from empty Gui, instead it would paste the previous one
	Return
; We got here via Shortcut or abbreviation defined in active bundle(s)
ViaShortCut:
StringSplit, paste, paste, _      ; split to bundle / index number
Text1  :=Snippet[Paste1,Paste2,1] ; part 1 (enter, or shortcut, or shorthand)
Text2  :=Snippet[Paste1,Paste2,2] ; part 2 (shift-enter)
Script :=Snippet[Paste1,Paste2,5] ; script (if there is a script, run script instead)
If (QueryDelimiter and ViaShorthand) or (QueryDelimiter and ViaShortCut)
	{
	 Text1:=RegExReplace(Text1,"iU)\[\[query[12]{0,1}=([^[]*)\]\]","[[input=$1]]")
	 Text2:=RegExReplace(Text2,"iU)\[\[query[12]{0,1}=([^[]*)\]\]","[[input=$1]]")
	 Script:=RegExReplace(Script,"iU)\[\[query[12]{0,1}=([^[]*)\]\]","[[input=$1]]")

	 StringReplace, Text1, Text1, [[Query]] , [[Input=Enter Query string (full)]], All
	 StringReplace, Text1, Text1, [[Query1]], [[Input=Enter Query string part 1]], All
	 StringReplace, Text1, Text1, [[Query2]], [[Input=Enter Query string part 2]], All

	 StringReplace, Text2, Text2, [[Query]] , [[Input=Enter Query string (full)]], All
	 StringReplace, Text2, Text2, [[Query1]], [[Input=Enter Query string part 1]], All
	 StringReplace, Text2, Text2, [[Query2]], [[Input=Enter Query string part 2]], All

	}

; process Query plugin before all others
if QueryDelimiter
	{
	 Text1:=RegExReplace(Text1,"iU)\[\[query[12]{0,1}=([^[]*)\]\]",Trim(Query["full"]))
	 Text2:=RegExReplace(Text2,"iU)\[\[query[12]{0,1}=([^[]*)\]\]",Trim(Query[1]))
	 Script:=RegExReplace(Script,"iU)\[\[query[12]{0,1}=([^[]*)\]\]",Trim(Query[2]))

	 StringReplace, Text1, Text1, [[Query]] , % Trim(Query["full"]), All
	 StringReplace, Text1, Text1, [[Query1]], % Trim(Query[1]), All
	 StringReplace, Text1, Text1, [[Query2]], % Trim(Query[2]), All

	 StringReplace, Text2, Text2, [[Query]] , % Trim(Query["full"]), All
	 StringReplace, Text2, Text2, [[Query1]], % Trim(Query[1]), All
	 StringReplace, Text2, Text2, [[Query2]], % Trim(Query[2]), All

	 StringReplace, Script, Script, [[Query]] , % Trim(Query["full"]), All
	 StringReplace, Script, Script, [[Query1]], % Trim(Query[1]), All
	 StringReplace, Script, Script, [[Query2]], % Trim(Query[2]), All
	}
Else if (Trim(QueryDelimiter) = "") ; remove query 
	{
	 Text1:=RegExReplace(Text1,"iU)\[\[query[12=]{0,2}([^[]*)\]\]")
	 Text2:=RegExReplace(Text2,"iU)\[\[query[12=]{0,2}([^[]*)\]\]")
	 Script:=RegExReplace(Script,"iU)\[\[query[12=]{0,2}([^[]*)\]\]")
	}

Query:=""

If Statistics and SelItem
	{
	 If !Snippet[Paste1,Paste2,3] and !Snippet[Paste1,Paste2,4] ; no shortcut and no shorthand
		Stats(MenuName_%paste1% "__viasearch__no-short-defined")
	 If Snippet[Paste1,Paste2,4]
		{
		 Stats(MenuName_%paste1% "__viasearch__" Snippet[Paste1,Paste2,4])
		}
	}

If ((Paste2 <> 1) and (SortByUsage = 1)) ; if it already is the first don't bother moving it to the top...
	{
	 BackupSnippet:=Snippet[Paste1].Delete(Paste2)
	 Snippet[Paste1].InsertAt(1,BackupSnippet)
	 BackupSnippet:=""
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
	 If (clipboard <> typed)
		 ClipSet("s",1,SendMethod,Clipboard) ; store in clip1
	 ClearClipboard()
	 ; process formatted text: HTML, Markdown, RTF and Image
	 ; RTF and Image are processed here, MD and HTML just before pasting to allow for nesting snippets using [[snippet=]]
	 formatMD:=0,formatHTML:=0

	 If RegExMatch(Clip,"iU)\[\[(rtf=.*|image=.*)\]\]")
		{
		 WinClip.Clear()
		 formatted:=1
		 If InStr(Clip,"[[rtf=")
			{
			 RegExMatch(Clip, "iU)\[\[rtf=([^[]*)\]\]", ClipQ, 1)
			 FileRead,Clip,%ClipQ1%
			 Gosub, ProcessText
			 ParseEscaped()
			 Gosub, CheckLineFeed
			 If CancelPlugin
				{
				 If TryClipboard()
					Clipboard:=ClipSet("g",1,SendMethod)
				 ClipSet("ea",1,SendMethod)
				 Return
				}
			 ClipQ1:=FixURI(ClipQ1,"rtf",A_ScriptDir)
			 WinClip.SetRTF(Clip)
			}
		 else if InStr(Clip,"[[image=")
			{
			 RegExMatch(Clip, "iU)\[\[Image=([^[]*)\]\]", ClipQ, 1)
			 If (ClipQ1 = "clipboard")
				ClipQ1:=StrReplace(ClipQ1,"clipboard",trim(ClipSet("g",1,SendMethod)," `r`n"))
			 ClipQ1:=FixURI(ClipQ1,"image",A_ScriptDir)
			 WinClip.SetBitmap(ClipQ1)
			 ; check if we need to leave image on clipboard after pasting (exception as ProcessText isn't called here)
			 If InStr(Clip,"[[PasteMethod=1]]")
				SnippetPasteMethod:=1
			 If InStr(Clip,"[[PasteMethod=2]]")
				SnippetPasteMethod:=2
			}
		 Clip:="", ClipQ1:="", ClipQ1_ClipboardPath:=""
		}
	 Else
		{
		 Gosub, ProcessText
		 ParseEscaped()
		 Gosub, CheckLineFeed
		 If CancelPlugin
			{
			 If TryClipboard()
				Clipboard:=ClipSet("g",1,SendMethod)
			 ClipSet("ea",1,SendMethod)
			 Return
			}
		 If (formatMD = 1) or (formatHTML = 1)
			{
			 StringReplace,Clip,Clip,[[md]],,All
			 StringReplace,Clip,Clip,[[html]],,All
			 If (formatMD = 1)
				Clip:=Markdown2HTML(Clip)
			 Clip:=FixURI(Clip,"html",A_ScriptDir)
			 WinClip.SetHTML(Clip)
			 Clip:=RegExReplace(clip,"iU)</*[^>]*>") ; strip HTML tags so we can paste normal text if need be
			 WinClip.SetText(Clip)
			}
		else
			{
			 If TryClipboard()
				Clipboard:=ClipSet("s",2,SendMethod,Clip) ; Must be 2 to restore clipboard #217 
			}
		}

	 If !(formatted > 0)  ; only check for ^| post if it is a plain text snippet
		Clipboard:=CheckCursorPos(Clipboard)
	 formatted:=0
	 GUI, 1:Destroy

	 If Statistics
		Stats("TotalBytes",StrLen(Clipboard))

	 If AltPaste[ActiveWindowProcessName].HasKey("PasteMethod")
		SnippetPasteMethod:=AltPaste[ActiveWindowProcessName].PasteMethod

	 If (SnippetPasteMethod = 0) or (SnippetPasteMethod = "") ; there was no PasteMethod plugin in the snippet
		{
		
		 If (PasteMethod = 0) or (SnippetPasteMethod = 0) ; paste it and clear formatted clipboard
			{
			 SendKey(SendMethod, ShortcutPaste)
			 PlaySound(PlaySound,"paste")
			 Clipboard:=ClipSet("s",2,SendMethod,Clip) ; Must be 2 to restore clipboard #217 
			 WinClip.Clear()
			}
		 else If (PasteMethod = 1) ; paste it, keep formatted clipboard
			{
			 SendKey(SendMethod, ShortcutPaste)
			 PlaySound(PlaySound,"paste")
			}
		}
	 else ; PasteMethod was set in the snippet or in AltPaste.ini
		If (SnippetPasteMethod = 1) ; 1 Paste snippet and keep it as the current clipboard content (so you can manually paste it again)
			{
			 SendKey(SendMethod, ShortcutPaste)
			 PlaySound(PlaySound,"paste")
			}
		; else PasteMethod was set in the snippet, so it must be: 2 Don't paste snippet content but copy it to the clipboard so you can manually paste it.

	 If (((BackLeft > 0) or (BackUp > 0)) and (PasteMethod <> 2)) ; place caret at position defined in snippet text via ^|
		{
		 If (BackUp > 0)
			{
			 SendInput, {Up %BackUp%}{End}
			}
		 SendInput, {Left %BackLeft%}
		 If PluginMultiCaret
			{
			 Loop, % PluginMultiCaret
				{
				 SendInput, % MultiCaret[ActiveWindowProcessName].key  ; TODOMC
				 Sleep 10
				}
			 SendInput, % MultiCaret[ActiveWindowProcessName].clr     ; TODOMC
			 Sleep 10
			 PluginMultiCaret=0
			}
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

	 If (SnippetPasteMethod = 0) or (SnippetPasteMethod = "") ; there was no PasteMethod plugin in the snippet
		{
		 If (PasteMethod = 0) ; it was pasted, restore original clipboard
			{
			 If TryClipboard()
				Clipboard:=ClipSet("g",1,SendMethod)
			 ClipSet("ea",1,SendMethod)
			}
		 else If (PasteMethod = 1) ; it was pasted, clear the original stored clipboard (free memory)
			{
			 ClipSet("ea",1,SendMethod)
			}
		 else If (PasteMethod = 2) ; it wasn't pasted, clear the original stored clipboard (free memory)
			{
			 ClipSet("ea",1,SendMethod)
			}
		}
	 else ; PasteMethod was set in the snippet with setting 1 or 2 so don't restore previous clipboard contents but just erase the stored content to save memory
			{
			 ClipSet("ea",1,SendMethod)
			}

	}
Else If (Script <> "") and (ScriptPaused = 0) ; we run script by saving it to tmp file and running it
	{

	 Loop {
		 If (InStr(Script, "[[Var=") = 0)
			break
		 RegExMatch(Script, "iU)\[\[Var=([^[]*)\]\]", ClipQ, 1)
		 StringReplace, Script, Script, [[Var=%ClipQ1%]], % LocalVar_%ClipQ1%, All ; %
		}

	 Loop, 2 ; check for plugins llpart1 and llpart2
		{
		 If InStr(Script,"[[llpart" A_Index "]]")
			{
			 Clip:=Text%A_Index%
			 Gosub, ProcessText
			 ParseEscaped()
			 Gosub, CheckLineFeed
			 If CancelPlugin
				{
				 If TryClipboard()
					Clipboard:=ClipSet("g",1,SendMethod)
				 ClipSet("ea",1,SendMethod)
				 Return
				}
			 Clip:=CheckCursorPos(Clip)
			 ; we use (join`n % here to avoid the need to escape the % characters which may be included in the clip variable - https://github.com/lintalist/lintalist/issues/92
			 StringReplace,Script,Script,[[llpart%A_Index%]],llpart%A_Index%=`n(join``n `%`n%clip%`n)`n`nLLBackLeft%A_Index%:=%BackLeft%`nLLBackUp%A_Index%:=%BackUp%`n`n,All
			 BackLeft:=0
			 BackUp:=0
			}
		}
	 
	 FileDelete, %TmpDir%\tmpScript.ahk
	 StringReplace, Script, Script, LLInit(), %LLInit%, All

	 StringReplace, Script, Script, [[LLShortHand]], LLShortHand:="%Typed%"`n, All

	 FileAppend, % Script, %TmpDir%\tmpScript.ahk, UTF-8 ; %
	 ;FileCopy, %TmpDir%\tmpScript.ahk, saved.ahk , 1 ; debug
	 GUI, 1:Destroy
	 RunWait, %A_AhkPath% "%TmpDir%\tmpScript.ahk"
	 FileDelete, %TmpDir%\tmpScript.ahk
	 Script=
	 If Statistics
		Stats("Scripts")
	}

If Statistics
	Stats(MenuName_%paste1% "__total")

If (OnPaste = 1)
	Gosub, SaveSettings
If Statistics and (OmniSearch or OmniSearchText)
	Stats("OmniSearch")
OmniSearch:=0,OmniSearchText:="",Typed:="",SnippetPasteMethod:="",SelItem:="",ViaShorthand:=0,ViaShortCut:=0,QuickSearchHotkeyPart2:=0
 ; ,ViaShorthand:="",ViaText:=""
ClipSet("ea",1,SendMethod)
Return

CheckHitList(CheckHitList, CheckFor, Bundle, RE = 0) ; RE no longer needed?
	{
	 Global load,snippet
	 HitKeyHistory=
	 CheckHitList:=CheckHitList "HitList"
	 Loop, parse, Bundle, CSV
		{
		 CheckBundle:=A_LoopField
		 If RegExMatch(%CheckHitList%_%CheckBundle%, "imU)" Chr(5) . "\Q" . CheckFor . "\E" . Chr(5)) ; we have a hit so we have to find the snippet ID
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

; Sort results - https://github.com/lintalist/lintalist/issues/21
SortResults(SortColumn,SortOption,SortDirection)
	{
	 LV_ModifyCol(SortColumn,SortOption " " SortDirection)
	}

; Change with of LV columns depending on content (e.g. autohide if it holds no data)
UpdateLVColWidth()
	{
	 global
	 local c4w
	 factor:=225
	 Col4Correction:=Abs(FontSize-10)*10+10 ; if we set a bigger font size shorthand becomes to narrow very quickly ; TODO BIGICONS/fonts
	 If DisplayBundle in 0,2 ; Bundle name, 6th column setting 0 & 2 hide column
		{
		 LV_ModifyCol(6,0)
		 factor:=155
		}
	 else
		LV_ModifyCol(6,70)
	 LV_ModifyCol(5,0) ; hidden Bundle_Index column, always hide
	 WinGetPos , , , AvailableWidth, , %AppWindow%
	 If (AvailableWidth = "")
		AvailableWidth:=Width
	 AvailableWidth:=Round(AvailableWidth/DPIFactor())-(ColumnWidthShorthand-65) ; accommodate for columnwidth set by user, -65 seems to work

	 ColumnWidth:=Round(((AvailableWidth - factor) / 10))
	 c1w:=Round((ColumnWidth) * (ColumnWidthPart1/10) - (Col4Correction/4) - 15)
	 c2w:=Round((ColumnWidth) * (ColumnWidthPart2/10) - (Col4Correction/4) - 10)

	 If (Col3 = 0)     ; shortcut column
		{
		 LV_ModifyCol(3,0)
		 c1w += 30
		 c2w += 25
		}
	 Else
		LV_ModifyCol(3,50)

	 If (Col4 = 0)     ; abbreviation/shorthand column ; TODO BIGICONS/fonts
		{
		 LV_ModifyCol(4,0)
		 c1w += 30
		 c2w += 25
		}
	 Else
		 LV_ModifyCol(4,ColumnWidthShorthand+Col4Correction)

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

/*
	 ; double check if widths are presentable - keep this as additional backup for future reference 
	 ; width_c1w, width_c2w would need to be added to local variables at start of function
     ; https://github.com/lintalist/lintalist/issues/165#issuecomment-633706970
	 SendMessage, 0x1000+29, 0, 0, SysListView321, %AppWindow%
	 width_c1w := ErrorLevel

	 SendMessage, 0x1000+29, 1, 0, SysListView321, %AppWindow%
	 width_c2w := ErrorLevel

	 If ((width_c1w+width_c2w+100+Col4Correction) < (AvailableWidth - 50))
		{
		 LV_ModifyCol(1,300)
		 LV_ModifyCol(2,300)
		}
*/

	 If (ColumnSort <> "NoSort")
		SortResults(ColumnSortOption1,ColumnSortOption2,SortDirection)
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
		 Section = 5 ; 5 = actual script (array element)
		 If (Snippet[Paste1,Paste2,5] = "") ;  if script is empty default to 2
			Section = 2
		}
	 If (Section = 2)
		{
		 If (Snippet[Paste1,Paste2,2] = "")
			Section = 1
		}
	 If (Section = 1)
		{
		 If (Snippet[Paste1,Paste2,1] = "")
			Section = 2
		}

	 GuiControl,1: , Edit2, % Snippet[Paste1,Paste2,Section] ; set preview Edit control %

	 Return
	}

LLQuery:
Query:=StrSplit(CurrText, QueryDelimiter,, 2)
Query["full"]:=LTrim(CurrText,OmniChar)
Return

ColumnSearchText:
ColumnID:=Trim(SubStr(CurrText,1,2),"@<")
ColumnSearchText:=LTrim(StrSplit(CurrText, ColumnSearchDelimiter,, 2).2,OmniChar)
Return
; This function is used to reset the search mode buttons when you switch search mode
TB_ResetButtons(in)
	{
	 global
	 loop, parse, in, CSV
		MyToolbar.ModifyButton(A_LoopField,"Check",0)
	}
Return

; This function will receive the messages sent by both Toolbar's buttons.
TB_Messages(wParam, lParam)
	{
	 Global ; Function (or at least the Handles) must be global.
	 MyToolbar.OnMessage(wParam) ; Handles toolbar's messages.
	}

; This function will receive the notifications.
TB_Notify(wParam, lParam)
	{
	 Global ; Function (or at least the Handles) must be global.
	 ReturnCode := MyToolbar.OnNotify(lParam) ; Handles notifications.
	 return ReturnCode
	}

; When we open the GUI make sure each button in the correct state (un)checked
TB_SetButtonStates:

If ScriptPaused
	MyToolbar.ModifyButton(MyToolbarIDs.ToggleScripts,"Check",ScriptPaused)
Gosub, SetScriptButton

If ShortcutPaused
	MyToolbar.ModifyButton(MyToolbarIDs.ToggleShortcuts,"Check",ShortcutPaused)
Gosub, SetShortcutButton

If ShorthandPaused
	MyToolbar.ModifyButton(MyToolbarIDs.ToggleShorthand,"Check",ShorthandPaused)
Gosub, SetShorthandButton

If SearchLetterVariations
	MyToolbar.ModifyButton(MyToolbarIDs.ToggleLetterVariations,"Check",SearchLetterVariations)
Gosub, SetShorthandButton

Gosub, SetLockButton

If Case
	MyToolbar.ModifyButton(MyToolbarIDs.ToggleCase,"Check",Case)

If (SearchMethod = 1)
	MyToolbar.ModifyButton(MyToolbarIDs.RegularSearch,"Check",1)
else If (SearchMethod = 2)
	MyToolbar.ModifyButton(MyToolbarIDs.FuzzySearch,"Check",1)
else If (SearchMethod = 3)
	MyToolbar.ModifyButton(MyToolbarIDs.RegExSearch,"Check",1)
else If (SearchMethod = 4)
	MyToolbar.ModifyButton(MyToolbarIDs.MagicSearch,"Check",1)
Return

PauseScriptButton:
	 ScriptPaused:=!ScriptPaused
	 Menu, tray, ToggleCheck, Pause &Scripts
	 PauseScriptButton:=MyToolbar.GetButtonState(MyToolbarIDs.ToggleScripts,"Checked")
	 PauseScriptButton:=!PauseScriptButton
	 MyToolbar.ModifyButton(MyToolbarIDs.ToggleScripts,"Check",PauseScriptButton)
	 Gosub, SetScriptButton
Return

SetScriptButton:
	 If ScriptPaused
		MyToolbar.ModifyButtonInfo(MyToolbarIDs.ToggleScripts,"Image",MyToolbarIcons.NoScripts)
	 else
		MyToolbar.ModifyButtonInfo(MyToolbarIDs.ToggleScripts,"Image",MyToolbarIcons.Scripts)
Return

PauseShortcutButton:
	 ShortcutPaused:=!ShortcutPaused
	 Menu, tray, ToggleCheck, Pause &Shortcut
	 PauseShortcutButton:=MyToolbar.GetButtonState(MyToolbarIDs.ToggleShortcuts,"Checked")
	 PauseShortcutButton:=!PauseShortcutButton
	 MyToolbar.ModifyButton(MyToolbarIDs.ToggleShortcuts,"Check",PauseShortcutButton)
	 Gosub, SetShortcutButton
	 Gosub, PauseShortcut
Return

SetShortcutButton:
	 If ShortcutPaused
		MyToolbar.ModifyButtonInfo(MyToolbarIDs.ToggleShortcuts,"Image",MyToolbarIcons.NoHotkeys)
	 else
		MyToolbar.ModifyButtonInfo(MyToolbarIDs.ToggleShortcuts,"Image",MyToolbarIcons.Hotkeys)
Return

PauseShorthandButton:
	 ShorthandPaused:=!ShorthandPaused
	 Menu, tray, ToggleCheck, Pause &Shorthand
	 PauseShorthandButton:=MyToolbar.GetButtonState(MyToolbarIDs.ToggleShorthand,"Checked")
	 PauseShorthandButton:=!PauseShorthandButton
	 MyToolbar.ModifyButton(MyToolbarIDs.ToggleShorthand,"Check",PauseShorthandButton)
	 Gosub, SetShorthandButton
Return

SetShorthandButton:
	 If ShorthandPaused
		MyToolbar.ModifyButtonInfo(MyToolbarIDs.ToggleShortHand,"Image",MyToolbarIcons.NoShortHand)
	 else
		MyToolbar.ModifyButtonInfo(MyToolbarIDs.ToggleShortHand,"Image",MyToolbarIcons.ShortHand)
Return

SetLockButton:
	 MyToolbar.ModifyButton(MyToolbarIDs.ToggleLock,"Check",Lock)
	 if lock
		{
		 MyToolbar.ModifyButtonInfo(MyToolbarIDs.ToggleLock,"Image",MyToolbarIcons.Locked)
		}
	 else if !lock
		{
		 MyToolbar.ModifyButtonInfo(MyToolbarIDs.ToggleLock,"Image",MyToolbarIcons.UnLocked)
		}
Return

ResetSearch:
	 lasttext = fadsfSDFDFasdFdfsadfsadFDSFDf
	 if !cl_ReadOnly
		IniWrite, %SearchMethod%       , %IniFile%, Settings, SearchMethod
	 Gosub, GetText
Return

; Shortcuts for the button bar
#IfWinActive, ahk_group AppTitle

^f::
ControlFocus, Edit1, %AppWindow%
Return

; LetterVariations
!v::
SearchLetterVariations:
	 SearchLetterVariations:=MyToolbar.GetButtonState(MyToolbarIDs.ToggleLetterVariations,"Checked")
	 SearchLetterVariations:=!SearchLetterVariations
	 MyToolbar.ModifyButton(MyToolbarIDs.ToggleLetterVariations,"Check",SearchLetterVariations)
	 if !cl_ReadOnly
		IniWrite, %SearchLetterVariations% , %IniFile%, Settings, SearchLetterVariations
	 Gosub, ResetSearch
Return

; lock sensitive
!l::
Lock:
	 lock:=MyToolbar.GetButtonState(MyToolbarIDs.ToggleLock,"Checked")
	 lock:=!lock
	 Gosub, SetLockButton
	 if !lock
		{
		 LoadBundle()
		 UpdateLVColWidth()
		}
	 Gosub, SetStatusBar
	 Gosub, ResetSearch
	 ShowPreview(PreviewSection)
Return

; Case sensitive
!c::
Case:
	 case:=MyToolbar.GetButtonState(MyToolbarIDs.ToggleCase,"Checked")
	 case:=!case
	 MyToolbar.ModifyButton(MyToolbarIDs.ToggleCase,"Check",case)
	 Gosub, ResetSearch
Return

; Regular search
!r::
Label10:
	 SMState1:=MyToolbar.GetButtonState(MyToolbarIDs.RegularSearch,"Checked")
	 if (SMState1 = 1)
		Return
	 SMState1:=!SMState1
	 TB_ResetButtons(MyToolbarIDs.FuzzySearch "," MyToolbarIDs.RegExSearch "," MyToolbarIDs.MagicSearch)
	 MyToolbar.ModifyButton(MyToolbarIDs.RegularSearch,"Check",SMState1)
	 SearchMethod:=1
	 Gosub, ResetSearch
Return

!z::
Label11: ; Fuzzy Search
	 SMState2:=MyToolbar.GetButtonState(MyToolbarIDs.FuzzySearch,"Checked")
	 if (SMState2 = 1)
		Return
	 SMState2:=!SMState2
	 TB_ResetButtons(MyToolbarIDs.RegularSearch "," MyToolbarIDs.RegExSearch "," MyToolbarIDs.MagicSearch)
	 MyToolbar.ModifyButton(MyToolbarIDs.FuzzySearch,"Check",SMState2)
	 SearchMethod:=2
	 Gosub, ResetSearch
Return

!x::
Label12: ; RegEx Search
	 SMState3:=MyToolbar.GetButtonState(MyToolbarIDs.RegExSearch,"Checked")
	 if (SMState3 = 1)
		Return
	 SMState3:=!SMState3
	 TB_ResetButtons(MyToolbarIDs.RegularSearch "," MyToolbarIDs.FuzzySearch "," MyToolbarIDs.MagicSearch)
	 MyToolbar.ModifyButton(MyToolbarIDs.RegExSearch,"Check",SMState3)
	 SearchMethod:=3
	 Gosub, ResetSearch
Return

!m::
Label13: ; Magic Search
	 SMState4:=MyToolbar.GetButtonState(MyToolbarIDs.MagicSearch,"Checked")
	 if (SMState4 = 1)
		Return
	 SMState4:=!SMState4
	 TB_ResetButtons(MyToolbarIDs.RegularSearch "," MyToolbarIDs.FuzzySearch "," MyToolbarIDs.RegExSearch)
	 MyToolbar.ModifyButton(MyToolbarIDs.MagicSearch,"Check",SMState4)
	 SearchMethod:=4
	 Gosub, ResetSearch
Return

#IfWinActive

; GUI related hotkeys

; Not the best of methods, but it works best for some reason
; Hotkeys active in Gui, 10:
#IfWinActive, Select bundle
Esc::
Gosub, 10GuiClose
Return
#IfWinActive

#IfWinActive, Select and press enter ahk_class AutoHotkeyGUI
Esc:: ; when we try cancel second time it fails. Why? Keyhistory shows the key is pressed
Gosub, 10GuiClose
Gosub, CancelChoice
Gui, 10:Destroy
Return
#IfWinActive

#IfWinActive, Calendar ahk_class AutoHotkeyGUI
Esc::
Gosub, CalendarCancel
Return
#IfWinActive

#IfWinActive, Lintalist snippet editor
Esc::
Gosub, 71GuiClose ; for some reason this is required
Return
#IfWinActive

#IfWinActive, Lintalist bundle editor
Esc::
Gosub, 81GuiClose ; for some reason this is required
Return
#IfWinActive

#IfWinActive, Move snippet to bundle
Esc::
Gosub, 10GuiClose
Return
#IfWinActive

#IfWinActive, About Lintalist -   ; About
Esc::
Gosub, 55GuiClose
Return
#IfWinActive

; Endless scrolling in a listbox
; https://autohotkey.com/board/topic/28879-example-endless-scrolling-in-a-listbox/
#IfWinActive, Select and press enter ahk_class AutoHotkeyGUI
NumpadUp::
Up::
SendMessage, 0x188, 0, 0, ListBox1, Select and press enter  ; 0x188 is LB_GETCURSEL (for a ListBox).
PreviousPos:=ErrorLevel+1
ControlSend, ListBox1, {Up}, Select and press enter
SendMessage, 0x18b, 0, 0, ListBox1, Select and press enter  ; 0x18b is LB_GETCOUNT (for a ListBox).
ItemsInList:=ErrorLevel
SendMessage, 0x188, 0, 0, ListBox1, Select and press enter  ; 0x188 is LB_GETCURSEL (for a ListBox).
ChoicePos:=ErrorLevel+1
If (ChoicePos = PreviousPos)
	{
	SendMessage, 0x18b, 0, 0, ListBox1, Select and press enter  ; 0x18b is LB_GETCOUNT (for a ListBox).
	SendMessage, 390, (Errorlevel-1), 0, ListBox1, Select and press enter  ; LB_SETCURSEL = 390
	}
Return

NumpadDown::
Down::
SendMessage, 0x188, 0, 0, ListBox1, Select and press enter  ; 0x188 is LB_GETCURSEL (for a ListBox).
PreviousPos:=ErrorLevel+1
SendMessage, 0x18b, 0, 0, ListBox1, Select and press enter  ; 0x18b is LB_GETCOUNT (for a ListBox).
ItemsInList:=ErrorLevel
ControlSend, ListBox1, {Down}, Select and press enter
SendMessage, 0x188, 0, 0, ListBox1, Select and press enter  ; 0x188 is LB_GETCURSEL (for a ListBox).
ChoicePos:=ErrorLevel+1
If (ChoicePos = PreviousPos)
	SendMessage, 390, 0, 0, ListBox1, Select and press enter  ; LB_SETCURSEL = 390 - position 'one'
Return
#IfWinActive

; Hotkeys active in Main GUI
; Reference: Endless scrolling in a listview [hugov] http://www.autohotkey.com/forum/topic44914.html

#IfWinActive, ahk_group AppTitle   ; Hotkeys only work in the just created GUI
Esc::
PlaySound(PlaySound,"close")
Gosub, GuiClose ; for some reason this is needed, 1GuiEscape doesn't seem to work
IfWinExist, Lintalist bundle editor
	Gosub, 71GuiClose
IfWinExist, Lintalist snippet editor
	Gosub, 81GuiClose
If Statistics
	Stats("SearchGuiCancel")
Return

F2::
OmniSearch:=!OmniSearch
Gosub, ResetSearch
Return

F4:: ; edit snippet
EditF4:
If cl_ReadOnly
	{
	 MsgBox, 64, Lintalist, Lintalist is in Read Only mode - editing has been disabled.
	 Return
	}
If WinExist("Lintalist snippet editor")
	{
	 WinActivate, Lintalist snippet editor
	 return
	}
If !ListviewResults()
	Return
EditMode = EditSnippet
Gosub, GetPastefromSelItem
;Gui, 1:Submit, NoHide
;ControlFocus, SysListView321, %AppWindow%
;SelItem := LV_GetNext()
;If (SelItem = 0)
;	SelItem = 1
;LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column
gui 1:+Disabled
gui 71:+Owner1
Gosub, BundleEditor
Return

F5:: ; copy snippet
EditF5:
If cl_ReadOnly
	{
	 MsgBox, 64, Lintalist, Lintalist is in Read Only mode - editing has been disabled.
	 Return
	}
If !ListviewResults()
	Return
EditMode = CopySnippet
Gosub, GetPastefromSelItem
;Gui, 1:Submit, NoHide
;ControlFocus, SysListView321, %AppWindow%
;SelItem := LV_GetNext()
;If (SelItem = 0)
;	SelItem = 1
;LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column
gui 1:+Disabled
gui 71:+Owner1
Gosub, BundleEditor
Return

F6:: ; copy snippet
EditF6:
If cl_ReadOnly
	{
	 MsgBox, 64, Lintalist, Lintalist is in Read Only mode - editing has been disabled.
	 Return
	}
If !ListviewResults()
	Return
EditMode = MoveSnippet
Gosub, GetPastefromSelItem
;Gui, 1:Submit, NoHide
;ControlFocus, SysListView321, %AppWindow%
;SelItem := LV_GetNext()
;If (SelItem = 0)
;	SelItem = 1
;LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column
gui 1:+Disabled
gui 71:+Owner1
Gosub, BundleEditor
Return

F7:: ; create new snippet e.g. append
EditF7:
If cl_ReadOnly
	{
	 MsgBox, 64, Lintalist, Lintalist is in Read Only mode - editing has been disabled.
	 Return
	}
EditMode = AppendSnippet
gui 1:+Disabled
gui 71:+Owner1
Gosub, BundleEditor
Return

F8:: ; delete snippet
EditF8:
If cl_ReadOnly
	{
	 MsgBox, 64, Lintalist, Lintalist is in Read Only mode - editing has been disabled.
	 Return
	}
If !ListviewResults()
	Return
InEditMode = 1
Gosub, GetPastefromSelItem
;Gui, 1:Submit, NoHide
;ControlFocus, SysListView321, %AppWindow%
;SelItem := LV_GetNext()
;If (SelItem = 0)
;	SelItem = 1
;LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column
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
	 Gosub, ResetSearch
	 Gosub, SetStatusBar
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
f1:=""
Return

F10::
EditF10:
If cl_ReadOnly
	{
	 MsgBox, 64, Lintalist, Lintalist is in Read Only mode - editing has been disabled.
	 Return
	}
EditMode = BundleProperties
If WinExist("Lintalist bundle editor")
	{
	 WinActivate, Lintalist bundle editor
	 return
	}
If WinExist(AppWindow)
	{
	 ;Gui, 81:+Owner1
	 Gui, 81:+0x40000000 -0x80000000 +Owner1 ; Add WS_CHILD, remove WS_POPUP, set owner/parent
	 Gui, 1:+Disabled
	}
Gosub, BundlePropertiesEditor
Return

;Enter:: ; not present but default Gui action, paste text from part1

^NumpadEnter:: ; allow Numpad enter to work as well [v1.7]
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

+NumpadEnter:: ; allow Numpad enter to work as well [v1.7]
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

!Enter::
SnippetPasteMethod:=2
Gosub, Paste
Return

!+Enter::
SnippetPasteMethod:=2
PastText1=0
Gosub, Paste
Return

; we add this for screenreader users (NVDA), that way they can TAB to the results listview
; and use the UP and DOWN keys to 'listen' to the results. If the listview already has focus
; it jumps back to the Find control to continue searching
Tab::
ControlGetFocus, OutputVar, %AppWindow%
If (OutputVar = "Edit1")
	{
	 If CheckListViewResults()
		Return
	 ControlFocus, SysListview321, %AppWindow%
	 If (LV_GetNext() = 0)
		LV_Modify(1, "Select Focus")
	}
else If (OutputVar = "SysListview321")
	{
	 ControlFocus, Edit1, %AppWindow%
	 ControlSend, Edit1, ^{end}, %AppWindow%
	}
Return

~NumpadUp::
~Up::
ControlGetFocus, OutputVar, %AppWindow%
ControlSend, Edit1, ^{end}, %AppWindow% ; v1.4 to keep caret at end of typed text in searchbox
If CheckListViewResults()
	Return
If (DisplayBundle > 1)
	GuiControl, -Redraw, SelItem
PreviousPos:=LV_GetNext()
If (PreviousPos = 0) ; exception, focus is not on listview this will allow you to jump to last item via UP key
	{
	 ControlSend, SysListview321, {End}, %AppWindow%
	 If (DisplayBundle > 1)
		GuiControl, +Redraw, SelItem
	 ShowPreview(PreviewSection)
	 Return
	}
ControlGetFocus, OutputVar, %AppWindow%
	{
	 If (OutputVar = "Edit1") and !IsNVDARunning
		ControlSend, SysListview321, {Up}, %AppWindow%
	 If (OutputVar = "Edit1") and IsNVDARunning
		ControlFocus, SysListview321, %AppWindow%
	}
ItemsInList:=LV_GetCount()
ChoicePos:=PreviousPos-1
If (ChoicePos <= 1)
	ChoicePos = 1
If (ChoicePos = PreviousPos) and (OutputVar <> "SysListview321")
	ControlSend, SysListview321, {End}, %AppWindow%
ShowPreview(PreviewSection)
;ControlFocus, Edit1, %AppWindow%
If (DisplayBundle > 1)
	GuiControl, +Redraw, SelItem
Return

~NumpadDown::
~Down::
If CheckListViewResults()
	Return
If (DisplayBundle > 1)
	GuiControl, -Redraw, SelItem
ControlSend, Edit1, ^{end}, %AppWindow% ; v1.4 to keep caret at end of typed text in searchbox
PreviousPos:=LV_GetNext()
ControlGetFocus, OutputVar, %AppWindow%
	{
	 If (OutputVar = "Edit1") and !IsNVDARunning
		ControlSend, SysListview321, {Down}, %AppWindow%
	 If (OutputVar = "Edit1") and IsNVDARunning
		ControlFocus, SysListview321, %AppWindow%
	}
ItemsInList:=LV_GetCount()
ChoicePos:=PreviousPos+1
If (ChoicePos > ItemsInList)
	ChoicePos := ItemsInList
If (ChoicePos = PreviousPos) and (OutputVar <> "SysListview321")
	ControlSend, SysListview321, {Home}, %AppWindow%
ShowPreview(PreviewSection)
If (DisplayBundle > 1)
	GuiControl, +Redraw, SelItem
Return

$!1:: ; alt-1..0 for the first 10 search results 
$!2::
$!3::
$!4::
$!5::
$!6::
$!7::
$!8::
$!9::
$!0::
If !ShortCutSearchGui
	Return
PasteResult:=(A_ThisHotkey= "$!0") ? 10 : SubStr(A_ThisHotkey,0)
Gosub, Paste
return

$^1:: ; sort part1
$^2:: ; part part2
$^3:: ; sort key
$^4:: ; sort shorthand
$^5:: ; sort bundle
If (SubStr(A_ThisHotkey,0) = LastSort)
	SortDirection:=SortDirection = "Sort" ? "SortDesc" : "Sort"
LastSort:=SubStr(A_ThisHotkey,0)
; if LastSort = 5 we must pass on 6 as that is the actual column number of the Bundle name column
SortResults(LastSort = 5 ? 6 : LastSort,ColumnSortOption2,SortDirection)
Return

#IfWinActive

#IfWinActive Lintalist snippet editor
$Rbutton::
ControlGetFocus, Control, Lintalist snippet editor
If !EditorHotkeySyntax
	MatchListPlugins:="Edit2,Edit3,RICHEDIT50W1,RICHEDIT50W2"
else If EditorHotkeySyntax
	MatchListPlugins:="Edit3,Edit4,RICHEDIT50W1,RICHEDIT50W2"
If Control not in %MatchListPlugins%
	Send {Rbutton}
Else
	Menu, Plugins, Show
Return
#IfWinActive

ToggleView:
Gosub, GuiToggleSettings
ControlGetText, CurrText, Edit1, %AppWindow% ; 20110623
Return

; Assorted labels -----------------------
; If you type some text and hit the SHORTCUT key it will see if it matches an abbreviation or fire up search if it doesn't

ShortText2:
If (QuickSearchHotkey2 = "") ; additional safety check to avoid triggering by accident
	Return                  ; see "setup hotkey" at the start of the script and INI
QuickSearchHotkeyPart2:=1
ShortText:
If (QuickSearchHotkey = "") ; additional safety check to avoid triggering by accident
	{
	 QuickSearchHotkeyPart2:=0
	 Return                  ; see "setup hotkey" at the start of the script and INI
	}
GetActiveWindowStats()
WhichBundle()
ClipSet("s",1,SendMethod,Clipboard) ; safe current content and clear clipboard
ClearClipboard()
Clipboard=
SendKey(SendMethod, ShortcutCopy) ; this is where it goes wrong for some editors - see DOC, not a problem of lintalist or ahk but certain editors behave differently. (when nothing is selected they will copy an entire line)
If (Clipboard = "")
	SendKey(SendMethod, ShortcutQuickSearch)
If Statistics
	Stats("QuickSearch")
ViaText=1
Typed:=Clipboard ; ??
; You pressed hotkey defined in the active bundle

ShortCut:
GetActiveWindowStats()
If (ActiveWindowClass = "AutoHotkeyGUI") and RegExMatch(ActiveWindowTitle, "^Lintalist")
	Return
WhichBundle()
;MsgBox % ThisHotkey ":" A_ThisHotkey
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
		 QuickSearchHotkeyPart2:=0
		 Return
		}
	}

If ((HitKeyHistory = "") and (ViaText = 1)) ; No hit so start searching
	{
	 JumpSearch=1
	 Gosub, GUIStart
	 QuickSearchHotkeyPart2:=0
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
	 OldGui10NoResize:=Gui10NoResize
	 Gui10NoResize:=1
	 Gui, 10:Destroy
	 Gui, 10:+Owner +AlwaysOnTop
	 Gui, 10: font, s%FontSize%
	 Gui, 10:Add, ListBox, w400 r5 x5 y5 vItem gChoiceMouseOK AltSubmit,
	 Gui, 10:Add, button, default gChoiceOK hidden, OK
	 GuiControl, 10: , ListBox1, |%ClipQ1%
	 Gui, 10:Font,
	 Gui, 10:Show, w410 h110, Select bundle
	 ControlSend, ListBox1, {Down}, Select bundle
	 Gui10ListboxCheckPosition("Select bundle")
	 Gui10NoResize:=OldGui10NoResize ; fix-to-prevent-resize
	 OldGui10NoResize:=""            ; fix-to-prevent-resize
	 Return
	}
Else ; only one hit e.g. unique shortcut
	{
	 Paste:=HitKeyHistory
	 SaveStat:=Paste
	 PastText1=1 ; #169 #236
	 If QuickSearchHotkeyPart2
		PastText1=0
	 If (ViaShorthand = 1) and (Paste <> "")
		{
		 Send, {Blind}{BS %back%}
		}
	 else
	 	ViaShortCut:=1 ; so we can actually check we're using a shortcut, for combination with QueryDelimiter
	 Gosub, ViaShortCut
	 if Statistics
		{
		 If !ViaShorthand
			If (Snippet[paste1,paste2,3] <> "") ; this doesn't work correctly AFTER a Choice GUI with duplicate hotkeys
				{
				 Stats("SnippetShortcut")
				 StringSplit, paste, SaveStat, _
				 Stats(MenuName_%paste1% "__viashortcut__" Snippet[paste1,paste2,3]) ; viashortcut2 for debug
				}
		 SaveStat:=""
		}
	 Return
	}
ViaText=0
ViaShorthand=0
ViaShortCut=0
QuickSearchHotkeyPart2:=0
Return

ChoiceMouseOK: ; if selection by mouse
If (A_GuiEvent <> "DoubleClick")
	Return

ChoiceOK: ; selected via Enter
Gui, 10:Submit,NoHide
If (item = "") ; if we didn't focus on results list while "typing to filter" in Choice it may return empty
	{
	 ControlGet, item, List, Focused, ListBox1,  Select and press enter
	 If InStr(item,"`n") ; we may get all the results of the "typing to filter" so assume we want first result
		item:=Trim(StrSplit(item,"`n").1,"`n`r")
	}
Gosub, 10GuiSavePos
Gui, 10:Destroy

MadeChoice=1
If (MultipleHotkey=1) ; via hotkey
	{
	 Paste:=HkHm%Item%
	 if Statistics
		SaveStat:=Paste
	 PastText1=1
	 If (ViaText=1) AND (ViaShorthand=1)
		{
		 Back:=StrLen(Clipboard) + 1
		 Send {BS %back%}
		}
	 ViaText = 0 ;???
	 if Statistics
		{
		 Stats("SnippetShortcut")
		 StringSplit, paste, SaveStat, _
		 Stats(MenuName_%paste1% "__viashortcut__" Snippet[paste1,paste2,3])
		 SaveStat:=""
		}
	 Gosub, ViaShortCut
	}
Else If (MultipleHotkey=0) ; choice gui (see ProcessText label)
	{
	 StringReplace, Clip, Clip, %PluginText%, %Item%, All
	 Item=
	 MultipleHotkey=0
	 PluginText:="", PluginOptions:="", ChoiceQuestion:="", PluginsFilterText:="", PluginOptionsResults:="" ; ,ChoiceHeight:=""
	}
AppendToBundle:=HkHm%Item% ; for use Editor
Gui, 10:Destroy
Return

10GuiClose:
10GuiEscape:
MadeChoice = 1
InEditMode = 0
EditMode =
Clip:="" ; in case we cancelled Choice by using the X
Gosub, 10GuiSavePos
Gui, 10:Destroy
Gui, 1:-Disabled
Gui, 71:Destroy
WinActivate, %AppWindow%
Return

GuiClose: ; GuiClose for Gui 1 (and not 1GuiClose)
1GuiEscape:
WinGetPos, X, Y, , ,  %AppWindow% ; remember position set by user
XY:=X "|" Y
Gui, 1:Destroy
Query:=""
ColumnID:=""
ColumnSearchText:=""
CurrText:=""
lasttext:="fadsfSDFDFasdFdfsadfsadFDSFDf"
ViaText:=0
ViaShorthand:=0
OmniSearch:=0
Return

; For tray and Search/Edit Gui menu - not including the File and Plugin Menus
GlobalMenuHandler:

ControlGetFocus, Control, Lintalist snippet editor

; tray menu
If (A_ThisMenuItem = AppWindow)
	Gosub, GUIStart
If (A_ThisMenuItem = "&Help")
	Run, docs\index.html
Else If (A_ThisMenuItem = "&About")
	Gosub, ShowAbout
Else If (A_ThisMenuItem = "&Quick Start Guide")
	Gosub, QuickStartGuideMenu
Else If (A_ThisMenuItem = "Check for updates")
	Run, %A_AhkPath% "%A_ScriptDir%\include\Update.ahk"
Else If (A_ThisMenuItem = "&Manage Counters")
		{
		 If cl_ReadOnly
			{
			 MsgBox, 64, Lintalist, Lintalist is in Read Only mode - editing has been disabled.
			 Return
			}
		 Gosub, SaveSettingsCounters
		 StoreCounters:=Counters
		 StoreLocalCounter_0:=LocalCounter_0
		 SaveUpdatedBundles()
		 If WinExist(AppWindow " ahk_class AutoHotkeyGUI")
			Gui, 1:+Disabled
		 Gosub, GuiOnTopCheck
		 RunWait, %A_AhkPath% include\CounterEditor.ahk %IniFile%
		 IniRead, Counters, %IniFile%, settings, Counters, 0
		 If WinExist(AppWindow " ahk_class AutoHotkeyGUI")
			{
			 Gui, 1:-Disabled
			 WinActivate, %AppWindow% ahk_class AutoHotkeyGUI
			}

		 If (Counters <> StoreCounters)
			{
			 MsgBox, 36, Restart?, In order for any changes to take effect you must reload.`nOK to restart? ; 4+32 = 36
			 IfMsgBox, Yes
				{
				 Gui, 1:Destroy
				 ReadCountersIni()
				 Gosub, RunReload
				}
			 If OnTopStateSaved
				Gosub, GuiOnTopCheck
			}
		}
Else If (A_ThisMenuItem = "E&xit")
	ExitApp
Else If (A_ThisMenuItem = "&Reload Bundles (restarts Lintalist)")
	; Reload
	Gosub, RunReload
Else If (A_ThisMenuItem = "&Restart as Administrator")
	{
	 If !A_IsAdmin
		{
		 Administrator:=1
		 Gosub, RunAdmin
		}
	 MsgBox, 64, Lintalist, Lintalist is already started as Administrator.
	 Return
	}
Else If (A_ThisMenuItem = "&Pause Lintalist")
	Gosub, PauseProgram
Else If (A_ThisMenuItem = "&Configuration")
	{
	 If cl_ReadOnly
		{
		 MsgBox, 64, Lintalist, Lintalist is in Read Only mode - editing has been disabled.
		 Return
		}
	 Gosub, SaveStartupSettings
	 Gosub, GuiOnTopCheck
	 IniSettingsEditor("Lintalist",A_ScriptDir "\" IniFile)
	 MsgBox, 36, Restart?, In order for any changes to take effect you must reload.`nOK to restart? ; 4+32 = 36
	 IfMsgBox, Yes
		{
		 Gui, 1:Destroy
		 Gosub, RunReload
		}
	 If OnTopStateSaved
		Gosub, GuiOnTopCheck
	}
Else If (A_ThisMenuItem = "&Open Lintalist folder")
	{
	 IfWinActive, %AppWindow%
		Gosub, GuiClose
	 IfWinExist, ahk_exe TOTALCMD.EXE
		Run, c:\totalcmd\TOTALCMD.EXE /O /T %A_ScriptDir% ; open folder in Total Commander
	 Else
		Run, %A_ScriptDir% ; open folder in Explorer
	}
Else If (A_ThisMenuItem = "&View Statistics")
	{
	 StatisticsReport()
	}
Else If (A_ThisMenuItem = "Pause &Shorthand")
	{
	 Gosub, PauseShorthandButton
	}
Else If (A_ThisMenuItem = "Pause &Shortcut")
	{
	 Gosub, PauseShortcutButton
	}
Else If (A_ThisMenuItem = "Pause &Scripts")
	{
	 Gosub, PauseScriptButton
	}
Else If (A_ThisMenuItem = "&Manage Bundles") or (A_ThisMenuItem = "&Manage Bundles`tF10")
	Gosub, EditF10

; edit menu
Else If (A_ThisMenuItem = "&Edit Snippet`tF4")
	Gosub, EditF4
Else If (A_ThisMenuItem = "&Copy Snippet`tF5")
	Gosub, EditF5
Else If (A_ThisMenuItem = "&Move Snippet`tF6")
	Gosub, EditF6
Else If (A_ThisMenuItem = "&New Snippet`tF7")
	Gosub, EditF7
Else If (A_ThisMenuItem = "&Remove Snippet`tF8")
	Gosub, EditF8
Else If (A_ThisMenuItem = "&Manage Bundles") or (A_ThisMenuItem = "&Manage Bundles`tF10")
	 Gosub, EditF10
Else If (A_ThisMenuItem = "&Help")
	Run, docs\index.html
Else If (A_ThisMenuItem = "&Manage Local Variables")
		{
		 If cl_ReadOnly
			{
			 MsgBox, 64, Lintalist, Lintalist is in Read Only mode - editing has been disabled.
			 Return
			}
		 If WinExist(AppWindow " ahk_class AutoHotkeyGUI")
			Gui, 1:+Disabled
		 Gosub, GuiOnTopCheck
		 RunWait, %A_AhkPath% include\LocalBundleEditor.ahk
		 If WinExist(AppWindow " ahk_class AutoHotkeyGUI")
			{
			 Gui, 1:-Disabled
			 WinActivate, %AppWindow% ahk_class AutoHotkeyGUI
			}
		 MsgBox, 36, Restart?, In order for any changes to take effect you must reload.`nOK to restart? ; 4+32 = 36
		 IfMsgBox, Yes
			{
			 Gui, 1:Destroy
			 Gosub, RunReload
			}
		 If OnTopStateSaved
			Gosub, GuiOnTopCheck
		}
; Tools menu
Else If (A_ThisMenuItem = "Encrypt text")
	 Run, %A_AhkPath% include\EncodeText.ahk
else If (A_ThisMenuItem = "Convert CSV file")
	Run, %A_AhkPath% extras\BundleConverters\CSV.ahk
else If (A_ThisMenuItem = "Convert List")
	Run, %A_AhkPath% extras\BundleConverters\List.ahk
else If (A_ThisMenuItem = "Convert Texter bundle")
	Run, %A_AhkPath% extras\BundleConverters\Texter.ahk
else If (A_ThisMenuItem = "Convert UltraEdit taglist")
	Run, %A_AhkPath% extras\BundleConverters\UltraEdit.ahk
; /tools

; View menu
Else If (A_ThisMenuItem = "Toggle Wide/Narrow View")
	{
	 MenuToggleView:=1
	 Gosub, GuiStart
	}
Else If (A_ThisMenuItem = "Toggle On Top`tCtrl+T")
	Gosub, GuiOnTop
; /View menu

Return
; /for For tray and Search/Edit Gui menu

GuiOnTop:
OnTopState:=MyToolbar.GetButtonState(MyToolbarIDs.Ontop,"Checked")
WinSet, AlwaysOnTop, Toggle, %AppWindow%
OnTopState:=!OnTopState
MyToolbar.ModifyButton(MyToolbarIDs.OnTop,"Check",OnTopState)
Return

GuiOnTopCheck:
If MyToolbar.GetButtonState(MyToolbarIDs.Ontop,"Checked")
	{
	 OnTopStateSaved:=1
	 Gosub, GuiOnTop
	 Return
	}
If OnTopStateSaved
	Gosub, GuiOnTop
OnTopStateSaved:=0
Return


; for filemenu - e.g. the bundles menu option
MenuHandler:
If (A_ThisMenuItem <> "&Load All Bundles")
	{
	 LoadTmp=
	 Loop, parse, MenuName_HitList, |
		{
		 StringSplit, MenuText, A_LoopField, % Chr(5) ; %
		 If ("&" . MenuText1 = A_ThisMenuItem)
			{
			 Load:=MenuText2
			 LoadAll:=0
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

	 Lock:=1
	}
else
	{
	 ; first we take care of the checkmarks in the two menus (tray + search gui)
	 ; checkmarks
	 If (LoadAll = 1)
		{
		 LoadAll=0
		 Load:=""
		 Menu, tray, UnCheck, &Load All Bundles
		 Try
			{
			 Menu, file, UnCheck, &Load All Bundles
			}
		 Catch
			{
			 ;
			}

		 ; uncheck all File menu items (bundle menu item in search gui)
		 Loop, parse, MenuName_HitList, |
			{
			 StringSplit, MenuText, A_LoopField, % Chr(5) ; %
			 Menu, file, UnCheck, &%MenuText1%
			}
		}
	 Else If (LoadAll = 0)
		{
		 LoadAll=1
		 Load:=Group
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
	 ; /checkmarks
	 Lock:=LoadAll
	}

	Gosub, SetLockButton
	LoadBundle(Load)

	UpdateLVColWidth()
	Gosub, SetStatusBar
	ShowPreview(PreviewSection)

Return
; /for filemenu

; Plugins menu
PluginMenuHandler:
ControlGetFocus, Control, Lintalist snippet editor
If !EditorHotkeySyntax
	MatchListPlugins:="Edit2,Edit3,RICHEDIT50W1,RICHEDIT50W2"
else If EditorHotkeySyntax
	MatchListPlugins:="Edit3,Edit4,RICHEDIT50W1,RICHEDIT50W2"
If Control not in %MatchListPlugins%
	Return

If (A_ThisMenuItem = "Paste HTML code")
	{
	 If !WinClip.HasFormat(49351)
		{
		 MsgBox, 48, Lintalist, No HTML content in the clipboard found.
		 Return
		}
	 Gosub, PasteHTMLEdit
	 Return
	}

If RegExMatch(A_ThisMenuItem,"i)(clipboard|selected)")
	Control, EditPaste, % "[[" Trim(A_ThisMenuItem,"=") "]]", %Control%, Lintalist snippet editor
Else If RegExMatch(A_ThisMenuItem, "i)(Counter=|Var=)")
	Control, EditPaste, % "[[" A_ThisMenuItem "]]", %Control%, Lintalist snippet editor
Else
	;Control, EditPaste, % SubStr(A_ThisMenuItem,8), %Control%, Lintalist snippet editor
	Control, EditPaste, % RegExReplace(SubStr(A_ThisMenuItem,8),"U)\]\].*$") "]]", %Control%, Lintalist snippet editor

If InStr(A_ThisMenuItem,"=")
	Send {left 2}

Return
;/PluginMenuHandler

PauseShortcut: ; Toggle Hotkeys defined in Bundles
Loop, parse, Group, CSV
	{
	 Bundle:=A_LoopField
	 Loop, parse, HotKeyHitList_%Bundle%, % Chr(5) ; %
		{
		 StringSplit, _h, A_LoopField, % Chr(7) ; %
		 If (_h1 <> "")
			{
			 Hotkey, IfWinNotActive, ahk_group BundleHotkeys
			 If (ShortcutPaused = 0) ; for some reason Toggle doesn't work so hence the On/Off method
				{
				 Hotkey, $%_h1%, On
				}
			 else If (ShortcutPaused = 1)
				{
				 Hotkey, $%_h1%, Off
				}
			 Hotkey, IfWinNotActive, off
			}
		 _h1= ; clear vars
		 _h2=
		}
	}
;Gosub, PauseShortcutButton
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
SB_SetText(ListTotal . "/" . ListTotal OmniSearchText,2) ; show hits / total
Return

ProcessText:

CancelPlugin:=0

If InStr(clip,"[[A_") ; check for built-in variables - https://autohotkey.com/docs/Variables.htm#BuiltIn
	BuiltInVariables()

	Loop ; get local variables first... only exception from the plugins as it is a built-in feature with the local variable editor as well
		{
		 ProcessTextString:=""
		 LocalVarName:=""
		 If (InStr(Clip, "[[Var=") = 0)
			break
		 ProcessTextString:=GrabPlugin(Clip,"var")
		 If InStr(ProcessTextString, "[[",,3) ; just in case we use another plugin to determine the name of the local variable
			break
		 LocalVarName:=RTrim(StrSplit(ProcessTextString,"=").2,"]")
		 StringReplace, clip, clip, %ProcessTextString%, % LocalVar_%LocalVarName%, All ; %
		}
	 Gosub, CheckFormat

	 ; Additional safety, by adding an IF it should prevent crashing Lintalist by getting stuck in an endless loop (for example missing a closing ] of a plugin)
	 If RegExMatch(clip,"iUs)\[\[[^\[]*\]\]",ProcessTextString)
		{

		 PluginText:=ProcessTextString
		 ; PluginName:=Trim(StrSplit(PluginText,"=").1,"[]") ; debug only
		 ; PluginName:=Trim(StrSplit(StrSplit(PluginText,"=").1,"_").1,"[]") ; plugins only: name=
		 ; PluginName:=Trim(StrSplit(StrSplit(PluginText,["=","("]).1,"_").1,"[]") ; v2.0 allow for plugins and functions: name= and name(
		 PluginName:=Trim(StrSplit(PluginText,["=","("]).1,"[]") ; 3.0 allow for plugins and functions: name= and name( but with underscore
		 If RegExMatch(PluginName,"iU)^(Split_|SplitRepeat_)") ; check for named split
		 	PluginName:=StrSplit(PluginName,"_").1

		 PluginOptions:=GrabPluginOptions(PluginText)
		 If IsLabel("GetSnippet" PluginName)
			Gosub, GetSnippet%PluginName%
		 else If IsFunc(PluginName)
			{
			 clipsave:=clip ; store clip
			 PluginProcessFunction:=ProcessFunction(PluginName,PluginOptions)
			 if (clipsave = clip) ; if function hasn't modified the clip, modify clip by replacing the function calls
				clip:=StrReplace(clip,PluginText,PluginProcessFunction)
			 if InStr(clip,PluginText) ; safety check, if func HAS modified the clip, but has omitted to remove itself from clip we need to remove it otherwise we're stuck in an endless loop
				clip:=StrReplace(clip,PluginText)
			 clipsave:="", PluginProcessFunction:=""
			}
		 else ; not a plugin, so remove it otherwise we'll get stuck in an endless loop, we replace [[]] with {{}} to show the "error"
			clip:=StrReplace(clip,ProcessTextString,"{{" trim(ProcessTextString,"[]") "}}")

		 If (RegExMatch(Clip, "iU)\[\[\w") > 0) ; make sure all "plugins" are processed before proceeding incl. local variables
			Gosub, ProcessText

		}

Return

CheckLineFeed:
If ActiveWindowProcessName in % LineFeed.programs
	{
	 LineFeedReplace:=""
	 Loop, parse, % LineFeed[ActiveWindowProcessName].char, CSV
		LineFeedReplace .= Chr(A_LoopField)
 	 clip:=RegExReplace(clip,"im)(*BSR_ANYCRLF)\R",LineFeedReplace)
	 LineFeedReplace:=""
	}

Return

CheckFormat:
	 If InStr(Clip,"[[md]]")
		{
		 StringReplace,Clip,Clip,[[md]],,All
		 formatMD:=1
		 formatted:=1
		}
	 If InStr(Clip,"[[html]]")
		{
		 StringReplace,Clip,Clip,[[html]],,All
		 formatHTML:=1
		 formatted:=1
		}
Return

CheckCursorPos(Clip)
	{
	 Global BackLeft, BackUp, PluginMultiCaret, MultiCaret, ActiveWindowProcessName
	 BackLeft=0
	 BackUp=0
	 PluginMultiCaret=0
	 clip:=StrReplace(clip,"^$","^|")
	 If InStr(Clip, "^|") ; Find caret pos after paste
		{
		 StringReplace, Clip, Clip, `r, , All ; remove `r as we don't need these for caret pos
		 StringReplace, Clip, Clip, ^|, ^|, UseErrorLevel
		 If (ErrorLevel > 1)
			PluginMultiCaret:=ErrorLevel
		 UpLines:=SubStr(Clip,InStr(Clip,"^|")+2)
		 StringReplace, UpLines, UpLines, `n, `n, UseErrorLevel
		 BackUp:=ErrorLevel
		 If (BackUp > 0)
			{
			 If (PluginMultiCaret > 0)
				BackLeft:=StrLen(SubStr(UpLines,1,InStr(UpLines,"`n")))-1 + StrLen(MultiCaret[ActiveWindowProcessName].str) ; TODOMC
			 else
				BackLeft:=StrLen(SubStr(UpLines,1,InStr(UpLines,"`n")))-1
			}
		 Else If (BackUp = 0)
			BackLeft:=StrLen(UpLines)
		 If (PluginMultiCaret <> 0) and MultiCaret.HasKey(ActiveWindowProcessName)
			{
			 StringReplace, Clip, Clip, ^|, % MultiCaret[ActiveWindowProcessName].str, All ; TODOMC
			}
		 else
			StringReplace, Clip, Clip, ^|, ,All ; TODOMC
		 UpLines=
		}
	 Return Clip	
	}

CheckTyped(TypedChar,EndKey)
	{
	 Global
	 expandit:=0
	 
	 if TypedChar in %TriggerKeysSource%
		expandit:=1

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
	 IfWinNotExist, %AppWindow% ; v1.9.3 (will make original window active instead of last found)
		 GetActiveWindowStats()
	 WhichBundle()

	 If (EndKey <> "Max") or (expandit = 1)
		{
		 if !expandit
			{
			 If EndKey not in %TriggerKeys%
				{
				 Typed=
				 Return
				}
			}

		 If EndKey in %TriggerKeys%
			expandit:=1

		 If Statistics
			SaveStat2:=typed

		 If expandit
			{
			 If (Typed = "")
				Return

			 HitKeyHistory:=CheckHitList("Shorthand", Typed, Load)

			 If EndKey in %TriggerKeysDead%
				StringTrimRight, Typed, Typed, 1

			 If (HitKeyHistory <> "")
				{
				 ViaText=1
				 ViaShorthand=1
				 Gosub, ShortCut
				 if Statistics
					{
					 Stats(MenuName_%paste1% "__viashorthand__" SaveStat2)
					 Stats("SnippetShorthand")
					 SaveStat2:=""
					}
				 Typed=
				 Back=
				 ViaText=0
				 ViaShorthand=0
				 HitKeyHistory=
				 CheckHitKey=
				 SaveStat2=
				}
			}
		 typed=
		}
	 Else
		typed .= TypedChar
	}

; https://autohotkey.com/board/topic/6893-guis-displaying-differently-on-other-machines/page-3#entry77893
DPIFactor()
{
Global DPIDisable
;If DPIDisable
;	Return 1
RegRead, DPI_value, HKEY_CURRENT_USER, Control Panel\Desktop\WindowMetrics, AppliedDPI 
; the reg key was not found - it means default settings 
; 96 is the default font size setting 
if (errorlevel=1) OR (DPI_value=96)
	Return 1
else
	Return  DPI_Value/96
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


Menu, Edit, Add, &Edit Snippet`tF4,       GlobalMenuHandler
Menu, Edit, Icon,&Edit Snippet`tF4,       icons\snippet_edit.ico

Menu, Edit, Add, &Copy Snippet`tF5,       GlobalMenuHandler
Menu, Edit, Icon,&Copy Snippet`tF5,       icons\snippet_copy.ico

Menu, Edit, Add, &Move Snippet`tF6,       GlobalMenuHandler
Menu, Edit, Icon,&Move Snippet`tF6,       icons\snippet_move.ico

Menu, Edit, Add, &New Snippet`tF7,        GlobalMenuHandler
Menu, Edit, Icon,&New Snippet`tF7,        icons\snippet_new.ico

Menu, Edit, Add, &Remove Snippet`tF8,     GlobalMenuHandler
Menu, Edit, Icon,&Remove Snippet`tF8,     icons\snippet_remove.ico

Menu, Edit, Add,

Menu, Edit, Add, &Manage Bundles`tF10,    GlobalMenuHandler
Menu, Edit, Icon,&Manage Bundles`tF10,    icons\lintalist_bundle.ico

Menu, Edit, Add, &Manage Local Variables, GlobalMenuHandler
Menu, Edit, Icon,&Manage Local Variables, icons\variables.ico

Menu, Edit, Add, &Manage Counters,        GlobalMenuHandler
Menu, Edit, Icon,&Manage Counters,        icons\counter.ico

Menu, Edit, Add,

Menu, Edit, Add, &Configuration,          GlobalMenuHandler
Menu, Edit, Icon,&Configuration,          icons\gear.ico
Menu, Edit, Add, &Open Lintalist folder,  GlobalMenuHandler
Menu, Edit, Icon,&Open Lintalist folder,  icons\folder-horizontal-open.ico
Menu, Edit, Add, &View Statistics,        GlobalMenuHandler
Menu, Edit, Icon,&View Statistics,        icons\chart_pie.ico
If !Statistics
	 Menu, Edit, Disable, &View Statistics

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
;Menu, File, Icon,&Load All Bundles, icons\arrow-in.ico
If (LoadAll = 1)
	{
	 Menu, file, Check, &Load All Bundles
	}
Else If (LoadAll = 0)
	{
	 Menu, file, UnCheck, &Load All Bundles
	}

Menu, File, Add ; add line

Loop, parse, MenuName_HitList, |
	{
	 StringSplit, MenuText, A_LoopField, % Chr(5)
	 Menu, File, Add, % "&"MenuText1, MenuHandler
	}
Menu, File, Add
Menu, File, Add, &Reload Bundles (restarts Lintalist),     GlobalMenuHandler
Menu, File, Icon,&Reload Bundles (restarts Lintalist),     icons\arrow-retweet.ico
Menu, MenuBar, Add, &Bundle, :File

Return

BuildEditorMenu:
ClipSelMenu:="Upper,Lower,Title,Sentence,Wrap|>|<"
Menu, ClipboardMenu, Add, Clipboard, PluginMenuHandler
Menu, SelectedMenu , Add, Selected , PluginMenuHandler
Loop, parse, ClipSelMenu, CSV
	{
	 Menu, ClipboardMenu, Add, Clipboard=%A_LoopField%, PluginMenuHandler
	 Menu, SelectedMenu , Add, Selected=%A_LoopField% , PluginMenuHandler
	}
Menu, Plugins, Add, Paste HTML code, PluginMenuHandler
Menu, Plugins, Add
Menu, Plugins, Add, Insert [[Clipboard]], :ClipboardMenu
Menu, Plugins, Add, Insert [[Selected]] , :SelectedMenu

Menu, Plugins, Add

Menu, LocalCounter, Add, Counter=, PluginMenuHandler
	 Loop, parse, LocalCounter_0, CSV
		{
		 If (A_LoopField <> "")
			Menu, LocalCounter, Add, Counter=%A_LoopField%, PluginMenuHandler
		}
Menu, Plugins, Add, Insert [[Counter=]] , :LocalCounter
Menu, LocalVar, Add, var=, PluginMenuHandler
Loop, parse, LocalVarMenu, CSV
	{
	 If (A_LoopField <> "")
		Menu, LocalVar, Add, var=%A_LoopField%, PluginMenuHandler
	}
Menu, Plugins, Add, Insert [[Var=]]     , :LocalVar

Menu, Plugins, Add

Menu, Plugins, Add, Insert [[C=]]        , PluginMenuHandler
Menu, Plugins, Add, Insert [[Calc=]]     , PluginMenuHandler
Menu, Plugins, Add, Insert [[Calendar=]] , PluginMenuHandler
Menu, Plugins, Add, Insert [[Case=]]     , PluginMenuHandler
;Menu, Plugins, Add, Insert [[Choice=]]   , PluginMenuHandler
Menu, Choice, Add, Insert [[Choice=]]	- normal, PluginMenuHandler
Menu, Choice, Add, Insert [[Choice=?|]]	- question, PluginMenuHandler
Menu, Choice, Add, Insert [[Choice=!|]]	- filter, PluginMenuHandler
Menu, Choice, Add, Insert [[Choice=!?|]]	- filter and question, PluginMenuHandler
Menu, Plugins, Add, Insert [[Choice=]]   , :Choice
Menu, Plugins, Add, Insert [[Comment=]]   , PluginMenuHandler
Menu, Plugins, Add, Insert [[DateTime=]] , PluginMenuHandler
;Menu, Plugins, Add, Insert [[Enc=]]      , PluginMenuHandler
Menu, Plugins, Add, Insert [[File=]]     , PluginMenuHandler

Menu, Filelist, Add, Insert [[FileList=?T|]]	- TotalCmdr, PluginMenuHandler 
Menu, Filelist, Add, Insert [[FileList=?W]]	- Window (title), PluginMenuHandler 
Menu, Filelist, Add, Insert [[FileList=?E]]	- Explorer, PluginMenuHandler 
Menu, Filelist, Add, Insert [[FileList=?|]], PluginMenuHandler 
Menu, Plugins, Add, Insert [[FileList=]] , :Filelist
Menu, Plugins, Add, Insert [[Input=]]    , PluginMenuHandler
Menu, Plugins, Add, Insert [[PasteMethod=]], PluginMenuHandler
Menu, Plugins, Add, Insert [[Random=]]   , PluginMenuHandler
Menu, Plugins, Add, Insert [[Snippet=]]  , PluginMenuHandler
Menu, Split, Add, Insert [[Split=]]      , PluginMenuHandler
Menu, Split, Add, Insert [[SplitRepeat=]], PluginMenuHandler
Menu, Split, Add
Menu, Split, Add, Insert [[sp=1]]        , PluginMenuHandler
Menu, Split, Add, Insert [[sp=1`,1]]     , PluginMenuHandler
Menu, Plugins, Add, Insert [[Split/Repeat]], :Split

Menu, Query, Add, Insert [[Query]]   , PluginMenuHandler
Menu, Query, Add, Insert [[Query1]]   , PluginMenuHandler
Menu, Query, Add, Insert [[Query2]]   , PluginMenuHandler
Menu, Plugins, Add, Insert [[Query]], :Query

Menu, Plugins, Add

Menu, Plugins, Add, Insert [[Image=]]   , PluginMenuHandler
Menu, Plugins, Add, Insert [[html]]     , PluginMenuHandler
Menu, Plugins, Add, Insert [[md]]       , PluginMenuHandler
Menu, Plugins, Add, Insert [[rtf=]]     , PluginMenuHandler

; create menu for your own plugins
FileRead, MyPluginsFile, %A_ScriptDir%\plugins\MyPlugins.ahk
	{
	 MyPluginsMenu:=0
	 Loop, parse, MyPluginsFile, `n, `r
		{
		 If RegExMatch(A_LoopField,"i)^#include")
			{
			 If !MyPluginsMenu
				MyPluginsMenu:=1
			 Menu, MyPlugins, Add, % "Insert [[" Trim(StrReplace(SubStr(A_LoopField,InStr(A_LoopField,"\",,0,1)+1),".ahk")," `n`t") "=]]", PluginMenuHandler
			}
		}
	 MyPluginsFile:=""
	}

	If MyPluginsMenu
		{
		Menu, Plugins, Add
		Menu, Plugins, Add, &MyPlugins, :MyPlugins
	}

;Menu, Tools, Add, Encrypt text          , GlobalMenuHandler
;Menu, Tools, Add,
Menu, Tools, Add, Convert CSV file         , GlobalMenuHandler
Menu, Tools, Add, Convert List             , GlobalMenuHandler
Menu, Tools, Add, Convert Texter bundle    , GlobalMenuHandler
Menu, Tools, Add, Convert UltraEdit taglist, GlobalMenuHandler

Menu, View, Add, Toggle Wide/Narrow View   , GlobalMenuHandler
Menu, View, Add, Toggle On Top`tCtrl+T,  GlobalMenuHandler

Menu, Help, Add, &Help, GlobalMenuHandler
Menu, Help, Icon,&Help, icons\help.ico
Menu, Help, Add, &About, GlobalMenuHandler
Menu, Help, Icon,&About, icons\help.ico
Menu, Help, Add, &Quick Start Guide, GlobalMenuHandler
Menu, Help, Icon,&Quick Start Guide, icons\help.ico

Menu, MenuBar2, Add, &Plugins, :Plugins
Menu, MenuBar2, Add, &Tools, :Tools ; make it available in Edit gui
Menu, MenuBar , Add, &Tools, :Tools ; make it available in Search gui
Menu, MenuBar , Add, &View,  :View ; make it available in Search gui
Menu, MenuBar2, Add, &Help, :Help , Right ; make it available in Edit gui (Right works as of v1.1.22.07+)
Menu, MenuBar , Add, &Help, :Help , Right ; make it available in Search gui
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
if !cl_ReadOnly
	{

	 ; this same code is also in ReadIni.ahk 
	 ; just make sure these specific settings have a value so reloading/restarting works better 
	 ; (when updating AHK via the official installer script it seems some settings are lost)
	 IniListFinalCheck:="Lock,Case,ShorthandPaused,ShortcutPaused,ScriptPaused"
	 Loop, parse, IniListFinalCheck, CSV
		If %A_LoopField% is not number
			%A_LoopField%:=0

	 IniWrite, %LastBundle%  , %IniFile%, Settings, LastBundle
	 IniWrite, %Load%               , %IniFile%, Settings, Load
	 IniWrite, %LoadAll%            , %IniFile%, Settings, LoadAll
	 IniWrite, %Lock%               , %IniFile%, Settings, Lock
	 IniWrite, %Case%               , %IniFile%, Settings, Case
	 IniWrite, %Width%              , %IniFile%, Settings, Width
	 IniWrite, %Height%             , %IniFile%, Settings, Height
	 IniWrite, %ShorthandPaused%    , %IniFile%, Settings, ShorthandPaused
	 IniWrite, %ShortcutPaused%     , %IniFile%, Settings, ShortcutPaused
	 IniWrite, %ScriptPaused%       , %IniFile%, Settings, ScriptPaused
	 IniWrite, %XY%                 , %IniFile%, Settings, XY
	}

If Statistics
	StatisticsSave()

; We no longer save:
; - DefaultBundle (set via Func_IniSettingsEditor_v6.ahk)
; - ShowQuickStartGuide (set via QuickStart.ahk) and
; - SearchMethod,SearchLetterVariations (set by labels in Lintalist.ahk above)
; related to https://github.com/lintalist/lintalist/issues/94
;If (SubStr(DefaultBundle, 0) = ",")
;	StringTrimRight, DefaultBundle, DefaultBundle, 1
;IniWrite, %DefaultBundle%      , %IniFile%, Settings, DefaultBundle
;IniWrite, %SearchMethod%       , %IniFile%, Settings, SearchMethod
;IniWrite, %SearchLetterVariations% , %IniFile%, Settings, SearchLetterVariations
;IniWrite, %ShowQuickStartGuide%, %IniFile%, Settings, ShowQuickStartGuide

if !cl_ReadOnly
	{
	 Gosub, SaveStartupSettings
	 Gosub, SaveSettingsCounters
	 Gosub, ChoiceWindowPositionSave
	 Gosub, EditorWindowPositionSave
	}
; /INI

; Bundles

; If (A_ExitReason <> "Exit") ; to prevent saving bundles twice which would make the backup routine not work correctly

if !cl_ReadOnly ; if readonly do not update bundles.
	SaveUpdatedBundles()

Gosub, CheckShortcuts ; desktop & startup LNK check (either set or delete after changing ini)

Sleep, 500

ExitApp
Return

; other Include(s)
#Include %A_ScriptDir%\include\Editor.ahk
#Include %A_ScriptDir%\include\BundlePropertiesEditor.ahk
#Include %A_ScriptDir%\plugins\Plugins.ahk
#Include %A_ScriptDir%\plugins\Functions.ahk
#Include %A_ScriptDir%\include\GuiSettings.ahk
#Include %A_ScriptDir%\include\SetShortcuts.ahk
#Include %A_ScriptDir%\include\QuickStart.ahk
#Include %A_ScriptDir%\include\FixURI.ahk
#Include %A_ScriptDir%\include\SetIcon.ahk
#Include %A_ScriptDir%\include\PluginHelper.ahk
#Include %A_ScriptDir%\include\ShowAbout.ahk
#Include %A_ScriptDir%\include\PlaySound.ahk
#Include %A_ScriptDir%\include\LetterVariations.ahk
#Include %A_ScriptDir%\include\ReadMultiCaretIni.ahk
#Include %A_ScriptDir%\include\ReadAltPasteIni.ahk
#Include %A_ScriptDir%\include\ReadLineFeedIni.ahk
#Include %A_ScriptDir%\include\Statistics.ahk
#Include %A_ScriptDir%\include\GuiCheckXYPos.ahk
#Include %A_ScriptDir%\include\WinClip.ahk         ; by Deo
#Include %A_ScriptDir%\include\WinClipAPI.ahk      ; by Deo
#Include %A_ScriptDir%\include\Markdown2HTML.ahk   ; by fincs + additions
#Include %A_ScriptDir%\include\Class_LV_Colors.ahk ; by just me
#Include %A_ScriptDir%\include\Class_CtlColors.ahk ; by just me
#Include %A_ScriptDir%\include\AutoXYWH.ahk        ; by toralf & tmplinshi
#Include %A_ScriptDir%\include\Class_Toolbar.ahk   ; by pulover
; /Includes

SaveSettingsCounters:
Counters=
Loop, parse, LocalCounter_0, CSV
	{
	 If (A_LoopField = "")
		Continue
	 Counters .= A_LoopField "," LocalCounter_%A_LoopField% "|"
	}
IniWrite, %Counters%   , %IniFile%, Settings, Counters
Return

; to be sure we retain our settings from the very first startup -----------------
; only used once.
SaveStartupSettings:
If (SetStartup_Start <> "")
	IniWrite, %SetStartup_Start%   , %IniFile%, Settings, SetStartup
If (SetDesktop_Start <> "")
	IniWrite, %SetDesktop_Start%   , %IniFile%, Settings, SetDesktop
SetStartup_Start:=""
SetDesktop_Start:=""
Return
; -------------------------------------------------------------------------------

; Show the Tray Menu if the Tray Icon is clicked by the left mouse button
AHK_NOTIFYICON(wParam, lParam)
	{
	 ; WM_LBUTTONUP
	 if (lParam = 0x202)
		{
		 Menu, Tray, Show
		 return 0
		}
	}

RunReload:
Gosub, RunFile
Run, %A_AhkPath% "include\Restart.ahk"
ExitApp
Sleep 1000
Return

; Create restart file
RunFile:
FileDelete, %TmpDir%\restarttmp.ahk
While FileExist(TmpDir "\restarttmp.ahk")
	Sleep 100
if A_IsAdmin
	FileAppend, % "Run, *RunAs " DllCall( "GetCommandLineW", "Str" ), %TmpDir%\restarttmp.ahk, UTF-8  ; reload with command line parameters
else
	FileAppend, % "Run, " DllCall( "GetCommandLineW", "Str" ), %TmpDir%\restarttmp.ahk, UTF-8  ; reload with command line parameters
Sleep 100
Return

; Run as admin
RunAdmin:
If Administrator and !A_IsAdmin
	{
	 if A_OSVersion not in WIN_2003,WIN_XP,WIN_2000
		{
		 Gosub, RunFile
		 Run, *RunAs %A_AhkPath% "include\Restart.ahk"
		 Sleep 1000
		 if !ErrorLevel
			ExitApp
		}
	 MsgBox 0x31, Lintalist,
	 (LTrim Join`s
		Lintalist is running as a limited user. If you continue, Lintalist
		will not be able to interact with programs that run as Administrator.
		`n
		To continue anyway, click OK. Otherwise click Cancel.
		)
	 IfMsgBox Cancel
		ExitApp
	}
Return

; various helper functions for searching/listview
IsNVDARunning()
	{
	 Process, Exist, nvda.exe
	 return ErrorLevel
	}

; present audible message
CheckListViewResults()
	{
	 global
	 If (LV_GetCount() = 0)
		{
		 SoundPlay, *48
		 Return 1
		}
	 Return 0
	}

; helper funcs for f4,f5,f6,f8
; avoid modifying empty listview results
ListviewResults()
	{
	 If (LV_GetCount() = 0)
		{
		 MsgBox, 48, Lintalist, There is no snippet to edit.
		 Return 0
		}
	 Return 1
	}

; avoid some repetitive code
GetPastefromSelItem:
Gui, 1:Submit, NoHide
ControlFocus, SysListView321, %AppWindow%
SelItem := LV_GetNext()
If (SelItem = 0)
	SelItem = 1
LV_GetText(Paste, SelItem, 5) ; get bundle_index from 5th column
Return

RunQuery:
If !QueryAction
	Return
IfWinActive, %AppWindow%
	ControlGetText, CurrText, Edit1, %AppWindow%
Gui, 1:Destroy
Try
	Run, %QueryScript% %CurrText%
Catch
	MsgBox, 64, Lintalist, There is a problem starting Query Action`nperhaps %QueryScript% is not defined
Paste:=""
CurrText:=""
Return

#include *i %A_ScriptDir%\include\nvda.ahk

#Include *i %A_ScriptDir%\autocorrect.ahk
