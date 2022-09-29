/*
LintaList Include
Purpose: Read AltPaste INI
Version: 1.1
Date:    20220929

History:
1.1 PasteDelay, PasteMethod added #230
1.0 Initial version 20180817

Ini format:

[program.exe]
Copy=^{Ins}
Cut=+{Del}
Paste=+{Ins}
QuickSearch=
PasteDelay=ms
PasteMethod=0-2
*/

ReadAltPasteIni()
	{
	 Global AltPaste
	 ini=%A_ScriptDir%\AltPaste.ini
	 IfNotExist, %ini%
		AltPasteIni(ini)
	 ; IniRead, OutputVarSectionNames, Filename
	 ; IniRead, OutputVar, Filename, Section, Key [, Default]
	 IniRead, SectionNames, %ini%
	 AltPaste:={}
	 keys:="copy,cut,paste,QuickSearch,PasteDelay,PasteMethod"
	 AltPaste["programs"]:=Trim(StrReplace(SectionNames,"`n",","),",")
	 Loop, parse, SectionNames, `n
		{
		 section:=A_LoopField
		 Loop, parse, keys, CSV
			IniRead, %A_LoopField%, %ini%, %section%, %A_LoopField%, %A_Space%
		 if copy
			AltPaste[section,"copy"]:=copy
		 if cut
			AltPaste[section,"cut"]:=cut
		 if paste
			AltPaste[section,"paste"]:=paste
		 if QuickSearch
			AltPaste[section,"QuickSearch"]:=QuickSearch
		 if PasteDelay
			AltPaste[section,"PasteDelay"]:=PasteDelay
		 if PasteMethod
			AltPaste[section,"PasteMethod"]:=PasteMethod
		 copy:="",cut:="",paste:="",QuickSearch:="",PasteDelay:="",PasteMethod:=""
		}
	}

; create ini if not present, that way we don't overwrite any user changes in future updates
AltPasteIni(ini)
	{
FileAppend,
(
; -------------------------------------------------------------------------------------------
; Lintalist - AltPaste setup for programs where you don't want to use Ctrl+C, Ctrl+X, Ctrl+V
; to copy, cut and paste text.
; Use the name of the program executable as [section] name
; followed by the key:
; copy=
; cut=
; paste=
; QuickSearch=     see documentation (cut word to the left, start Lintalist Search Gui)
;
; Use AHK notation (^=ctrl +=shift !=alt) for the above shortcuts.
;
; PasteDelay=      see documentation, delay in milliseconds, overrides global setting
; PasteMethod=0-2, see documentation, overrides global setting
; 
; IBM Common User Access (CUA) standard:
; Copy : Control+Insert -> ^{Ins}
; Cut  : Shift+Delete   -> +{Del}
; Paste: Shift+Insert   -> +{Ins}
; -------------------------------------------------------------------------------------------

[cmd.exe]
Copy=^{Ins}
Cut=+{Del}
Paste=+{Ins}
[mintty.exe]
Copy=^{Ins}
Cut=+{Del}
Paste=+{Ins}
[putty.exe]
Copy=^{Ins}
Cut=+{Del}
Paste=+{Ins}
[powershell.exe]
Copy=^{Ins}
Cut=+{Del}
Paste=+{Ins}
[kitty.exe]
Copy=^{Ins}
Cut=+{Del}
Paste=+{Ins}
[kitty_portable.exe]
Copy=^{Ins}
Cut=+{Del}
Paste=+{Ins}
[ConEmu64.exe]
Copy=^{Ins}
Cut=+{Del}
Paste=+{Ins}
[ConEmu.exe]
Copy=^{Ins}
Cut=+{Del}
Paste=+{Ins}
)
, %ini%, UTF-16
	}
