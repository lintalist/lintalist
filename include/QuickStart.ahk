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
StringReplace, quickstarthtml, quickstarthtml, +, Shift +`, All
StringReplace, quickstarthtml, quickstarthtml, #, Win +` , All
StringReplace, quickstarthtml, quickstarthtml, ^, Ctrl +` , All
StringReplace, quickstarthtml, quickstarthtml, !, Alt +` , All
StringReplace, quickstarthtml, quickstarthtml, &plus`;, +, All

Gui, 55:Destroy
Gui, 55:Add, ActiveX, w550 h450 x10 y10 vdoc, HTMLFile
doc.write(quickstarthtml)
Gui, 55:Add, Checkbox, xp yp+460 g55GuiStartupCheckbox vShowQuickStartGuide, Show Quick start guide at start up.
Gui, 55:Add, Button, xp+470 w100 g55GuiClose, Close
Gui, 55:Add, link, x10 yp+30, Be sure to read <a href="docs\index.html">the Lintalist documentation</a>, <a href="https://github.com/jensjacobt/lintalist-for-math">Lintalist for Math intro</a> or visit the <a href="https://github.com/jensjacobt/lintalist-for-math-bundles">Github bundle repository</a>.
Gui, 55:Show
GuiControl, 55:, button1, %ShowQuickStartGuide%
Return

55GuiStartupCheckbox:
Gui, 55:Submit, NoHide
IniWrite, %ShowQuickStartGuide%, %A_ScriptDir%\%IniFile%, Settings, ShowQuickStartGuide
Return

55GuiClose:
Gui, 55:Destroy
Return
