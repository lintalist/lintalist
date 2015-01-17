; LintaList Include
; Purpose: Read INI
; Version: 1.2
; Date:    20150109

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
	 If (StartSearchHotkey = "") ; additional check to prevent error with empty hotkey
	 	StartSearchHotkey:="Capslock"
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

	 ; new settings 1.2
	 IniRead, ActivateWindow    ,%ini%, settings, ActivateWindow
	 If (ActivateWindow = "ERROR")
	 	Append2Ini("ActivateWindow",ini)
	 IniRead, ActivateWindow    ,%ini%, settings, ActivateWindow, 0

	 IniRead, OnPaste           ,%ini%, settings, OnPaste
	 If (OnPaste = "ERROR")
	 	Append2Ini("OnPaste",ini)
	 IniRead, OnPaste           ,%ini%, settings, OnPaste, 0

	 IniRead, PasteMethod       ,%ini%, settings, PasteMethod
	 If (PasteMethod = "ERROR")
	 	Append2Ini("PasteMethod",ini)
	 IniRead, PasteMethod       ,%ini%, settings, PasteMethod, 0

	 IniRead, AlwaysUpdateBundles,%ini%, settings, AlwaysUpdateBundles
	 If (AlwaysUpdateBundles = "ERROR")
	 	Append2Ini("AlwaysUpdateBundles",ini)
	 IniRead, AlwaysUpdateBundles,%ini%, settings, AlwaysUpdateBundles, 0

	 ReadCountersIni()

  }                         

Append2Ini(Setting,file)
	{
	 FileRead, New2IniFile, %A_ScriptDir%\include\settings\%Setting%.ini
	 FileAppend, `n%New2IniFile%, %file%
	 Sleep 100
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
	 defaultlist:="AlwaysLoadBundles,LastBundle,DefaultBundle,Load
	 ,LoadAll,MinLen,SortByUsage ,MaxRes,SearchMethod,DoubleClickSends
	 ,Lock,Case,QuickSearchHotkey,ExitProgramHotKey,SendMethod,PasteDelay
	 ,TriggerKeys,ShorthandPaused,ShortcutPaused,ScriptPaused,CompactWidth
	 ,CompactHeight,WideWidth,WideHeight,Width,Height,PreviewHeight,ShowIcons
	 ,PreviewSection,ShowGrid,Icon1,Center,MouseAlternative,Mouse,Counters
	 ,SetStartup,SetDesktop,IniVersion,ShowQuickStartGuide
	 ,ActivateWindow,OnPaste,PasteMethod,AlwaysUpdateBundles"
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

)
	Loop, parse, defaultlist, CSV
		{
		 FileRead, add2ini, %A_ScriptDir%\include\Settings\%A_LoopField%.ini
		 NewIni .= add2ini "`n"
		 add2ini:=""
		}
	 FileAppend, %NewIni%, %A_ScriptDir%\settings.ini
	}