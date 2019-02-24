; LintaList Include
; Purpose: Read LineFeed INI
; Version: 1.0
; Date:    20181011

/*
[program.exe]
char=11
*/

ReadLineFeedIni()
	{
	 Global LineFeed
	 ini=%A_ScriptDir%\LineFeed.ini
	 IfNotExist, %ini%
		LineFeedIni(ini)
	 ; IniRead, OutputVarSectionNames, Filename
	 ; IniRead, OutputVar, Filename, Section, Key [, Default]
	 IniRead, SectionNames, %ini%
	 LineFeed:={}
	 keys:="char"
	 LineFeed["programs"]:=Trim(StrReplace(SectionNames,"`n",","),",")
	 Loop, parse, SectionNames, `n
		{
		 section:=A_LoopField
		 Loop, parse, keys, CSV
			IniRead, %A_LoopField%, %ini%, %section%, %A_LoopField%, %A_Space%
		 LineFeed[section,"Char"]:=Char
		 char:=""
		}
	}

; create ini if not present, that way we don't overwrite any user changes in future updates
LineFeedIni(ini)
	{
FileAppend,
(
; -------------------------------------------------------------------------------------------
; Lintalist - LineFeed
; Use the name of the program executable as [section] name
; followed by the key:
; char=
; Use character code indicated by the specified number*, you can use a CSV list if you want
; to use multiple characters e.g. char=13,10
;
; Common values:
;  9 (\t) Horizontal Tab
; 10 (\n) Line Feed
; 11 (\v) Vertical Tab
; 12 (\f) Form Feed
; 13 (\r) Carriage Return
; 32      Space
; * Number can be a Unicode character code between 0 and 0x10FFFF; otherwise it
;   is an ANSI character code between 0 and 255. More information:
;   https://autohotkey.com/docs/commands/Chr.htm
;
; Discussion: https://github.com/lintalist/lintalist/issues/65
; -------------------------------------------------------------------------------------------

[notepad.exe]
char=13,10
[wordpad.exe]
char=11
)
, %ini%, UTF-16
	}
