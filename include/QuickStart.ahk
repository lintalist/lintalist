/* 
LintaList Include
Purpose: Show Quick Start Guide at start up

History: 
- v1.1 Added Esc to close Gui
- v1.0 Added to Lintalist v1.0.2 
*/

QuickStartGuide:
	 If (ShowQuickStartGuide = 0)
		Return

QuickStartGuideMenu:
FileRead, quickstarthtml, docs\quickstart.html
StringReplace, quickstarthtml, quickstarthtml, [quickstarthotkey], %StartSearchHotkey%, All
StringReplace, quickstarthtml, quickstarthtml, [quicksearchhotkey], %QuickSearchHotkey%, All
StringReplace, quickstarthtml, quickstarthtml, [quithotkey], %ExitProgramHotKey%, All
StringReplace, quickstarthtml, quickstarthtml, +, Shift+, All
StringReplace, quickstarthtml, quickstarthtml, #, WinKey+, All
StringReplace, quickstarthtml, quickstarthtml, ^, Ctrl+, All
StringReplace, quickstarthtml, quickstarthtml, !, Alt+, All

Gui, 55:Destroy
Gui, 55:Add, ActiveX, w550 h430 x10 y10 vdoc, HTMLFile
doc.write(quickstarthtml)
Gui, 55:font, s10 arial
Gui, 55:Add, Checkbox, xp yp+440 w420 h25 g55GuiStartupCheckbox vShowQuickStartGuide, Show Quick start guide at start up.
Gui, 55:Add, Button, xp+450 w100 g55GuiClose, Close
Gui, 55:Add, link, x10 yp+30, Be sure to read <a href="docs\index.html">the documentation</a> or visit the <a href="https://github.com/lintalist">Github bundle repo</a>.
Gui, 55:Show,,Lintalist Quick Start Guide
GuiControl, 55:, button1, %ShowQuickStartGuide%
Return

55GuiStartupCheckbox:
Gui, 55:Submit, NoHide
IniWrite, %ShowQuickStartGuide%, %A_ScriptDir%\%IniFile%, Settings, ShowQuickStartGuide
Return

55GuiClose:
Gui, 55:Destroy
Return

#IfWinActive Lintalist Quick Start Guide ahk_class AutoHotkeyGUI
Esc::
Gosub, 55GuiClose
Return
#IfWinActive
