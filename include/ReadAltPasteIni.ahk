; LintaList Include
; Purpose: Read AltPaste INI
; Version: 1.0
; Date:    20180817

/*
[program.exe]
Copy=^{Ins}
Cut=+{Del}
Paste=+{Ins}
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
	 keys:="copy,cut,paste,QuickSearch"
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
		 copy:="",cut:="",paste:="",QuickSearch:=""
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
; Use AHK notation (^=ctrl +=shift !=alt) for the shortcuts.
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
