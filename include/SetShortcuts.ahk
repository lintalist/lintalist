; LintaList Include
; Purpose: Ask & set Desktop & Startup shortcuts
;          Used at startup and can be used via Configuration
; Version: 1.0
; Date:    20101010

SetShortcuts:
Gui, Startup:Add, Text, ,This seems to be the first time you start Lintalist.`nDo you want to:`n
Gui, Startup:Add, Checkbox, vSetStartup, Automatically start Lintalist at start up?
Gui, Startup:Add, Checkbox, vSetDesktop, Create a shortcut on your desktop?
Gui, Startup:Add, Checkbox, vSetStartmenu checked, Create a shortcut in your startmenu?
Gui, Startup:Add, Button, xp+120 yp+40 w100 gStartup, Continue
Gui, Startup:show, , Lintalist setup
ControlFocus, Button4, Lintalist setup
Return

Startup:
Gui, Startup:Submit
Gui, Startup:Destroy
SetStartup_Start:=SetStartup
SetDesktop_Start:=SetDesktop
SetStartmenu_Start:=SetStartmenu
;IniWrite, %SetStartup%   , %IniFile%, Settings, SetStartup
;IniWrite, %SetDesktop%   , %IniFile%, Settings, SetDesktop
;IniWrite, %SetStartmenu%   , %IniFile%, Settings, Startmenu

CheckShortcuts:
SplitPath, A_AhkPath, SP_ScriptName
If (SP_ScriptName = "lintalist.exe")
	{
	 FP_Script:=A_AhkPath
	 FP_Args:=""
	} 
Else
	{
	 FP_Script:=A_AhkPath
	 FP_Args:=Chr(34) A_ScriptDir "\lintalist.ahk" Chr(34)
	}
	
If (SetStartmenu = 1 or SetStartmenu_Start = 1)
	{
	 FP_Dir:=A_StartMenu
	 Gosub, SetShortcut
	}
else
	FileDelete, %A_StartMenu%\Lintalist for Math.lnk
If (SetDesktop = 1 or SetDesktop_Start = 1)
	{
	 FP_Dir:=A_Desktop
	 Gosub, SetShortcut
	}
else
	FileDelete, %A_Desktop%\Lintalist for Math.lnk
If (SetStartup = 1 or SetStartup_Start = 1)
	{
	 FP_Dir:=A_Startup
	 Gosub, SetShortcut
	}
else
	FileDelete, %A_Startup%\Lintalist for Math.lnk
Return

SetShortcut:
IfExist, %FP_Dir%\lintalist.lnk
 	Return
FileCreateShortcut, %FP_Script%, %FP_Dir%\Lintalist for Math.lnk , %A_ScriptDir%, %FP_Args%, Lintalist, %A_ScriptDir%\icons\lintalist.ico, , , 1
Return