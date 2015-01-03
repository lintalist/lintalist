; LintaList Include
; Purpose: Read INI
; Version: 1.0.2
; Date:    20140423

ReadIni()
	{
	 Global
	 local ini
	 ini=%A_ScriptDir%\settings.ini
	 IfNotExist, %ini%
	 	{
		 CreateDefaultIni()
		 Gosub, SetShortcuts ; (#Include from main script)
		} 
	 IniRead, AlwaysLoadBundles  ,%ini%, settings, AlwaysLoadBundles
		StringReplace, AlwaysLoadBundles, AlwaysLoadBundles, bundles\, ,All ; fileselect adds the directory which we don't want
	 IniRead, LastBundle         ,%ini%, settings, LastBundle        , default.txt
	 IniRead, DefaultBundle      ,%ini%, settings, DefaultBundle     , default.txt
		StringReplace, DefaultBundle, DefaultBundle, bundles\, ,All ; fileselect adds the directory which we don't want
	 IniRead, MinLen             ,%ini%, settings, MinLen            , 1
	 IniRead, SortByUsage        ,%ini%, settings, SortByUsage       , 1
	 IniRead, MaxRes             ,%ini%, settings, MaxRes            , 100
	 IniRead, SearchMethod       ,%ini%, settings, SearchMethod      , 1
	 IniRead, StartSearchHotkey  ,%ini%, settings, StartSearchHotkey , Capslock
	 IniRead, QuickSearchHotkey  ,%ini%, settings, QuickSearchHotkey , #z
	 IniRead, ExitProgramHotKey  ,%ini%, settings, ExitProgramHotKey , ^#q
	 IniRead, CompactWidth       ,%ini%, settings, CompactWidth      , 450
	 If (CompactWidth < 300)
		CompactWidth=300 ; min value to keep Gui usuable
	 IniRead, CompactHeight,%ini%, settings, CompactHeight , 400
	 If (CompactHeight < 300)
		CompactHeight=300 ; min value to keep Gui usuable
	 IniRead, WideWidth    ,%ini%, settings, WideWidth     , 760
	 If (WideWidth < 300)
		WideWidth=300     ; min value to keep Gui usuable
	 IniRead, WideHeight   ,%ini%, settings, WideHeight    , 400
	 If (WideHeight < 300)
		WideHeight=300    ; min value to keep Gui usuable
	 IniRead, Width        ,%ini%, settings, Width         , 450
	 IniRead, Height       ,%ini%, settings, Height        , 400
	 IniRead, PreviewHeight,%ini%, settings, PreviewHeight , 102
	 IniRead, ShowIcons    ,%ini%, settings, ShowIcons     , 1
	 IniRead, Icon1        ,%ini%, settings, Icon1         , TextIcon.ico
	 IniRead, Icon2        ,%ini%, settings, Icon2         , ScriptIcon.ico
	 SplitPath, Icon1, , , , Icon1 ; trim ext
	 SplitPath, Icon2, , , , Icon2 ; trim ext
	 IniRead, SendMethod   ,%ini%, settings, SendMethod    , 3
	 IniRead, PasteDelay   ,%ini%, settings, PasteDelay    , 10
	 IniRead, TriggerKeys  ,%ini%, settings, TriggerKeys   , Tab,Space
	 Loop, parse, TriggerKeys, CSV
	 	{
	 	 TmpKey = %A_LoopField%
	 	 TmpTriggerKeys .= "EndKey:" TmpKey ","
	 	 TmpKey =
	 	}
	 StringTrimRight, TmpTriggerKeys,TmpTriggerKeys,1
	 TriggerKeys:=TmpTriggerKeys
	 TmpTriggerKeys=
	 IniRead, DoubleClickSends   ,%ini%, settings, DoubleClickSends, 1
	 IniRead, Load               ,%ini%, settings, Load            , 0
	 IniRead, LoadAll            ,%ini%, settings, LoadAll         , 0
	 IniRead, Lock               ,%ini%, settings, Lock            , 0
	 IniRead, Case               ,%ini%, settings, Case            , 0
	 IniRead, ShorthandPaused    ,%ini%, settings, ShorthandPaused , 0
	 IniRead, ShortcutPaused     ,%ini%, settings, ShortcutPaused  , 0
	 IniRead, ScriptPaused       ,%ini%, settings, ScriptPaused    , 0
	 IniRead, Center             ,%ini%, settings, Center          , 0
	 IniRead, MouseAlternative   ,%ini%, settings, MouseAlternative, 1
	 IniRead, Mouse              ,%ini%, settings, Mouse           , 0
	 IniRead, PreviewSection	 ,%ini%, settings, PreviewSection  , 1
	 IniRead, ShowGrid           ,%ini%, settings, ShowGrid        , 0
	 If (ShowGrid = 0)
	 	ShowGrid =
	 Else
	 	ShowGrid = Grid
	 IniRead, Counters          ,%ini%, settings, Counters, 0	
	 IniRead, SetStartup        ,%ini%, settings, SetStartup, 0	
	 IniRead, SetDesktop        ,%ini%, settings, SetDesktop, 0	
	 IniRead, ShowQuickStartGuide,%ini%, settings, ShowQuickStartGuide, 1
	 ReadCountersIni()

  }                         

ReadCountersIni()
	{
	 Global
	 If (Counters <> 0) or (Counters <> "")
	 	{
	 	 LocalCounter_0=
	 	 Loop, parse, counters, |
	 	 	{
	 	 	 If (A_LoopField = "")
	 	 	 	Continue
	 	 	 StringSplit, _ctemp, A_LoopField, `,
	 	 	 LocalCounter_%_ctemp1% := _ctemp2
	 	 	 LocalCounter_0 .= _ctemp1 ","
	 	 	 _ctemp1=
	 	 	 _ctemp2=
	 	 	}
	 	}  
	}
	
CreateDefaultIni()
	{
	 NewIni=
	 (
`; Lintalist uses a modified version of Func_IniSettingsEditor, http://www.autohotkey.com/forum/viewtopic.php?p=69534#69534
`;     ;functions remarks
`;     ;[SomeSection]
`;     ;somesection This can describe the section. 
`;     Somekey=SomeValue 
`;     ;somekey Now the descriptive comment can explain this item. 
`;     ;somekey More then one line can be used. As many as you like.
`;     ;somekey [Type: key type] [format/list] 
`;     ;somekey [Default: default key value] 
`;     ;somekey [Hidden:] 
`;     ;somekey [Options: AHK options that apply to the control] 
`;     ;somekey [CheckboxName: Name of the checkbox control] 
[Settings]
AlwaysLoadBundles=default.txt
`;AlwaysLoadBundles Type: File
`;AlwaysLoadBundles Bundles you want always to be loaded, comma separated list
`;AlwaysLoadBundles Note: "bundles\" is automatically removed from the path, so no need to include it but doesn't hurt if you do.
LastBundle=default.txt
`;LastBundle Hidden:
`;LastBundle The bundle(s) that were loaded when the program closes, this in case of a locked bundle so we can reload it at next startup
DefaultBundle=default.txt
`;DefaultBundle Type: File
`;DefaultBundle If no matching bundle can be found based on the window title load this bundle.
`;DefaultBundle Note: "bundles\" is automatically removed from the path, so no need to include it but doesn't hurt if you do.
Load=1 
`;Load Hidden:
`;Load stores the internal number (which can change) of the bundle(s) loaded when the program closed
LoadAll=0
`;LoadAll Hidden:
`;LoadAll 0=no, 1 = yes (load all bundles) Change via TrayMenu or FileMenu in GUI
MinLen=1
`;MinLen Hidden:
`;MinLen Type: Dropdown 1|2|3|4|5|6
`;MinLen Default: 1
`;MinLen Number of characters to type before the bundles is being searched in the Search GUI
`;MinLen This can increase the responsiveness of the program when searching really large lists
SortByUsage = 1
`;SortByUsage Type: Dropdown 0|1
`;SortByUsage Default: 1
`;SortByUsage Sort bundle by usage: most recently used snippets at the top 
MaxRes=100
`;MaxRes Type: Dropdown 10|20|30|40|50|60|70|80|90|100
`;MaxRes Default: 30
`;MaxRes The number of maximum results while searching (loaded bundle(s) may be very large, this will make the program more responsive)
SearchMethod=2
`;SearchMethod Type: Dropdown 1|2|3|4
`;SearchMethod Default: 2
`;SearchMethod There are three types of search available
`;SearchMethod 1=Normal
`;SearchMethod 2=Fuzzy
`;SearchMethod 3=RegEx
`;SearchMethod 4=Magic
`;SearchMethod See documentation for more information on the various types, can be set in Search GUI
DoubleClickSends=1
`;DoubleClickSends Type: Dropdown 1|2|3|4|5|6
`;DoubleClickSends Default: 1
`;DoubleClickSends You can change what happens if you double click on an entry in the search results:
`;DoubleClickSends 1=Paste Part1 as enter e.g. run script if present
`;DoubleClickSends 2=Paste Part2 as shift-enter e.g. run script if present 
`;DoubleClickSends 3=Paste Part1 as ctrl-enter e.g. always paste part1 even if script present
`;DoubleClickSends 4=Paste Part2 as ctrl-shift-enter e.g. always paste part2 even if script present
`;DoubleClickSends 5=Edit snippet
`;DoubleClickSends 6=New snippet
Lock=0
`;Lock Hidden:
`;Lock Store locked state 0=no, 1 = yes. Change via GUI
Case=0
`;Case Hidden:
`;Case Store Case sens search state 0=no, 1 = yes. Change via GUI
StartSearchHotkey=CAPSLOCK
`;StartSearchHotkey !=Alt, ^ = Ctrl, + Shift, # = WinKey
`;StartSearchHotkey The HotKey used to launch the Lintalist search GUI.
`;StartSearchHotkey See http://ahkscript.org/docs/Hotkeys.htm#Symbols and http://ahkscript.org/docs/KeyList.htm for other keys 
QuickSearchHotkey=#z
`;QuickSearchHotkey !=Alt, ^ = Ctrl, + Shift, # = WinKey
`;QuickSearchHotkey HotKey used to start searching (e.g. cut word to the left, launch Gui and search, if only one match is found act accordingly)
`;QuickSearchHotkey Note that some editors cut or copy and entire line if no selection is made so (UltraEdit, Sublime Text Editor, Editpad ...)
`;QuickSearchHotkey See http://ahkscript.org/docs/Hotkeys.htm#Symbols and http://ahkscript.org/docs/KeyList.htm for other keys 
ExitProgramHotKey=^#q
`;ExitProgramHotKey Default: ^#q
`;ExitProgramHotKey !=Alt, ^ = Ctrl, + Shift, # = WinKey
`;ExitProgramHotKey HotKey used to quit Lintalist
`;ExitProgramHotKey See http://ahkscript.org/docs/Hotkeys.htm#Symbols and http://ahkscript.org/docs/KeyList.htm for other keys
SendMethod=1
`;SendMethod Type: Dropdown 1|2|3|4
`;SendMethod Default: 1
`;SendMethod If you experience any problems with the way text is sent to the various applications you use you may try various methods to see if it resolves the issues
`;SendMethod 1=SendInput
`;SendMethod 2=SendEvent
`;SendMethod 3=SendPlay
`;SendMethod 4=ControlSend
PasteDelay=160
`;PasteDelay Type: Dropdown 10|15|20|25|30|40|50|60|70|80|90|100|120|140|160|180|200|220|240|260|280|300|350|400|450|500|550|600|650|700|750
`;PasteDelay Default 100
`;PasteDelay If the text of the snippet isn't pasted in to your application after search, shortcut or shorthand you could try to increase the number of Milliseconds before the text is pasted
TriggerKeys=Tab,Space
`;TriggerKeys Type: Text
`;TriggerKeys Default Tab,Space
`;TriggerKeys Keys that will expand Shorthand (abbreviation) if applicable. Comma separated list. 
`;TriggerKeys Valid keys: Tab,Space,.
ShorthandPaused=0
`;ShorthandPaused Hidden:
`;ShorthandPaused change via TrayMenu - enable/disable abbreviations
ShortcutPaused=0
`;ShortcutPaused Hidden:
`;ShortcutPaused change via TrayMenu - enable/disable shortcuts
ScriptPaused=0
`;ScriptPaused Hidden:
`;ScriptPaused change via TrayMenu - enable/disable scripts
CompactWidth=330
`;CompactWidth Type: Integer
`;CompactWidth Default: 300
`;CompactWidth The width in Pixels of the narrow version of the search Gui, Lintalist has two modes (narrow and wide) 
`;CompactWidth Recommended is minimum 300, any smaller and the Gui might become to cramped to be useful
CompactHeight=500
`;CompactHeight Type: Integer
`;CompactHeight Default: 500
`;CompactHeight The height in Pixels of the narrow version of the search Gui, Lintalist has two modes (narrow and wide) 
`;CompactHeight Recommended is minimum 500, any smaller and the Gui might become to cramped to be useful
WideWidth=760
`;WideWidth Type: Integer
`;WideWidth Default: 760
`;WideWidth The width in Pixels of the wide version of the search Gui, Lintalist has two modes (narrow and wide) 
`;WideWidth Recommended is not to make it any wider than your lowest resolution in case you use multiple monitors with different resolutions
WideHeight=400
`;WideHeight Type: Integer
`;WideHeight Default: 400
`;WideHeight The width in Pixels of the wide version of the search Gui, Lintalist has two modes (narrow and wide) 
Width=760
`;Width Hidden:
`;Width last used width when program closed
Height=400
`;Height Hidden:
`;Height last used height when program closed
PreviewHeight=102
`;PreviewHeight Hidden:
ShowIcons=1
`;ShowIcons Type: Dropdown 0|1
`;ShowIcons Default: 1
`;ShowIcons Show the Text and Script icons in the search results.
`;ShowIcons 0=No
`;ShowIcons 1=Yes
PreviewSection=1
`;PreviewSection Type: Dropdown 1|2|3
`;PreviewSection Default: 1
`;PreviewSection What to show in the preview area:
`;PreviewSection 1=Text of part one of snippet (recommended)
`;PreviewSection 2=Text of part two of snippet (fall back on Part 1 if Part 2 is empty)
`;PreviewSection 3=Script code of snippet (fall back to Part 1 if 3 is empty)
ShowGrid=0
`;ShowGrid Type: Dropdown 0|1
`;ShowGrid Default: 0
`;ShowGrid Show a Grid in the listview of the Search GUI
`;ShowGrid 0=No
`;ShowGrid 1=Yes
Icon1=TextIcon.ico
`;Icon1 Hidden:
`;Icon1 Used for Text only snippets (e.g. no script)
Icon2=ScriptIcon.ico
`;Icon2 Hidden:
`;Icon2 Used for snippets with a script
Center=0
`;Center Type: Dropdown 0|1|2
`;Center Default: 0
`;Center GUI on first monitor regardless of caret or cursor position
`;Center 0 = Do not center but use Caret position
`;Center 1 = Center on first monitor
`;Center 2 = Do not center but remember position set by user
`;Center check with Mouse and MouseAlternative settings to set your preferred combination
MouseAlternative=1
`;MouseAlternative Type: Dropdown 0|1
`;MouseAlternative Default: 1
`;MouseAlternative Use the mouse position as backup:
`;MouseAlternative 1 = If caret fails use mouse cursor position as an alternative
`;MouseAlternative 0 = Don't use mouse cursor position as an alternative if caret pos. fails
Mouse=0
`;Mouse Type: Dropdown 0|1
`;Mouse Default: 0
`;Mouse Use the mouse cursor instead of the caret position:
`;Mouse = 1 use the mouse cursor instead of the caret position
`;Mouse = 0 do not use the mouse cursor instead of the caret position
Counters= 
`;Counters Hidden:
`;Counters Used for the counter bundle, edit these via the tray menu, "Manage Counters" option
SetStartup=0	
`;SetStartup Type: Dropdown 0|1
`;SetStartup Default: 0
`;SetStartup Create shortcut (lnk) in the startup folder to Lintalist starts automatically
`;SetStartup 0=No
`;SetStartup 1=Yes
SetDesktop=0	
`;SetDesktop Type: Dropdown 0|1
`;SetDesktop Default: 0
`;SetDesktop Create shortcut (lnk) in on the Desktop to start LintaList
`;SetDesktop 0=No
`;SetDesktop 1=Yes
IniVersion=1
`;IniVersion Hidden:
`;IniVersion Just in case we want to add some more features later we can use this - currently not implemented - do not update yourself
ShowQuickStartGuide=1
`;ShowQuickStartGuide Type: Dropdown 0|1
`;ShowQuickStartGuide Default: 1
`;ShowQuickStartGuide Show Lintalist Quickstart Guide at start up of program
`;ShowQuickStartGuide 0=No
`;ShowQuickStartGuide 1=Yes

	 )
	 FileAppend, %NewIni%, %A_ScriptDir%\settings.ini
	}