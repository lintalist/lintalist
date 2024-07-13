/*
LintaList Include
Purpose: Read Theme INI
Version: 1.0

*/

ReadTheme(IniFile)
	{
	 Global Theme:=[],AlternateRowColor,AlternateSelectionColor
	 ini=%A_ScriptDir%\themes\%IniFile%.ini
	 If !FileExist(ini)
		Return

	 list=
	 (join`n
MainBackgroundColor
SearchBoxTextColor
SearchBoxBackgroundColor
ListViewTextColor
ListViewBackgroundColor
ListViewBackgroundColorAlternateRow
ListViewBackgroundColorSelection
PreviewTextColor
PreviewBackgroundColor
EditorGuiTextColor
EditorTextColor
EditorBackgroundColor
StatusBarBackgroundColor
MainColorComments
MainColorFunctions
MainColorKeywords
MainColorMultiline
MainColorNumbers
MainColorPunctuation
MainColorStrings
AHKColorA_Builtins
AHKColorCommands
AHKColorDirectives
AHKColorFlow
AHKColorFunctions
AHKColorKeyNames
AHKColorKeywords
SnippetsColorAttributes
SnippetsColorEntities
SnippetsColorTags
	 )
	 Loop, parse, list, `n, `r
		{
		 if (A_LoopField = "")
			continue
		 ReadKey:=Trim(A_LoopField,"`t `n`r")
		 IniRead, ThemeKey ,%ini%, settings, % ReadKey
		 If (ThemeKey = "ERROR") or (ThemeKey = "")
			Continue
		 Theme[ReadKey]:=ThemeKey
		}
	 Theme["path"]:=Trim(IniFile,"\")

	 If Theme["ListViewBackgroundColorAlternateRow"]
		AlternateRowColor:=Theme["ListViewBackgroundColorAlternateRow"]
	 If Theme["ListViewBackgroundColorSelection"]
		AlternateSelectionColor:=StrSplit(Theme["ListViewBackgroundColorSelection"],",")
	}
