; LintaList Include
; Purpose: Show Quick Start Guide at start up
; Version: 1.0.2
; Date:    20140423

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
Gui, 55:Add, Checkbox, xp yp+440 g55GuiStartupCheckbox vShowQuickStartGuide, Show Quick start guide at start up.
Gui, 55:Add, Button, xp+450 w100 g55GuiClose, Close
Gui, 55:Add, link, x10 yp+30, Be sure to read <a href="docs\index.html">the documentation</a> or visit the <a href="https://github.com/lintalist">Github bundle repo</a>.
Gui, 55:Show
GuiControl, 55:, button1, %ShowQuickStartGuide%
Return

55GuiStartupCheckbox:
Gui, 55:Submit, NoHide
IniWrite, %ShowQuickStartGuide%, %A_ScriptDir%\Settings.ini, Settings, ShowQuickStartGuide
Return

55GuiClose:
Gui, 55:Destroy
Return
