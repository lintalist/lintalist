; LintaList Include
; Purpose: Bundle & Snippet Editor
; Version: 1.11
;
; Hotkeys used in Search GUI to start Bundle & Snippet Editor
; F4  = Edit snippet
; F5  = Copy and Edit snippet
; F6  = Move snippet (from one bundle to another)
; F7  = Add new snippet
; F8  = Delete snippet
;
; History:
; v1.11 - Statusbar with line;col, total lines, size
; v1.10 - Expert option: select different editor via menu (read from separate ini, see docs)
; v1.9 - Manually load edited text from editor https://github.com/lintalist/lintalist/issues/268; https://github.com/lintalist/lintalist/issues/288
; v1.8 - Fix +Owner1 (PR TFWol); Templates (right click)
; v1.7 - "Quote paths" in Edit in Editor
; v1.6 - properly updating Col2, Col3, and Col4 (first attempt), check for ASCII 5 & 7
; v1.5 - paste html
; v1.4 - adding themes
; v1.3 - 'shortcuts' (Keyboard accelerators) for edit controls
; v1.2 - Use font/fontsize settings in Editor as well (as in the Search GUI)
; v1.1 - Added (optional) Syntax Highlighting for snippets/html/scripts
;
;

BundleEditor:

IniRead, SetEditor                  , %A_ScriptDir%\session.ini, editor, SetEditor, Default

Gosub, GuiOnTopCheck

InEditMode:=1
WrapPart1:=1
WrapPart2:=1
WrapPart3:=1

Codes := { "AHK": { "Highlighter": "HighlightAHK" }
	, "Snippet": {"Highlighter": "HighlightSnippet"	}
	, "Plain": { "Highlighter": "" } }

FGColor:="0x" Theme["EditorTextColor"]
BGColor:="0x" Theme["EditorBackgroundColor"]
MainColorComments:="0x" Theme["MainColorComments"]
MainColorFunctions:="0x" Theme["MainColorFunctions"]
MainColorKeywords:="0x" Theme["MainColorKeywords"]
MainColorMultiline:="0x" Theme["MainColorMultiline"]
MainColorNumbers:="0x" Theme["MainColorNumbers"]
MainColorPunctuation:="0x" Theme["MainColorPunctuation"]
MainColorStrings:="0x" Theme["MainColorStrings"]
AHKColorA_Builtins:="0x" Theme["AHKColorA_Builtins"]
AHKColorCommands:="0x" Theme["AHKColorCommands"]
AHKColorDirectives:="0x" Theme["AHKColorDirectives"]
AHKColorFlow:="0x" Theme["AHKColorFlow"]
AHKColorKeyNames:="0x" Theme["AHKColorKeyNames"]
AHKColorKeywords:="0x" Theme["AHKColorKeywords"]
SnippetsColorAttributes:="0x" Theme["SnippetsColorAttributes"]
SnippetsColorEntities:="0x" Theme["SnippetsColorEntities"]
SnippetsColorTags:="0x" Theme["SnippetsColorTags"]

If (FGColor = "0x")
	FGColor:="0x000000"
If (BGColor = "0x")
	BGColor:="0xFFFFFF"
If (MainColorComments = "0x")
	MainColorComments:="0x7F9F7F"
If (MainColorFunctions = "0x")
	MainColorFunctions:="0x7CC8CF"
If (MainColorKeywords = "0x")
	MainColorKeywords:="0xE4EDED"
If (MainColorMultiline = "0x")
	MainColorMultiline:="0x7F9F7F"
If (MainColorNumbers = "0x")
	MainColorNumbers:="0xF79B57"
If (MainColorPunctuation = "0x")
	MainColorPunctuation:="0x000088"
If (MainColorStrings = "0x")
	MainColorStrings:="0xCC9893"
If (AHKColorA_Builtins = "0x")
	AHKColorA_Builtins:="0xF79B57"
If (AHKColorCommands = "0x")
	AHKColorCommands:="0x008800"
If (AHKColorDirectives = "0x")
	AHKColorDirectives:="0x7CC8CF"
If (AHKColorFlow = "0x")
	AHKColorFlow:="0x008800"
If (AHKColorFunctions = "0x")
	AHKColorFunctions:="0x008800"
If (AHKColorKeyNames = "0x")
	AHKColorKeyNames:="0xCB8DD9"
If (AHKColorKeywords = "0x")
	AHKColorKeywords:="0xCB8DD9"
If (SnippetsColorAttributes = "0x")
	SnippetsColorAttributes:="0x7CC8CF"
If (SnippetsColorEntities = "0x")
	SnippetsColorEntities:="0xF79B57"
If (SnippetsColorTags = "0x")
	SnippetsColorTags:="0x008800"

; Settings array for the RichCode control
RichCodeSettings:=
( LTrim Join Comments
{
	"TabSize": 4,
	"Indent": "`t",
	"FGColor": FGColor,
	"BGColor": BGColor,
	"Font": {"Typeface": font, "Size": fontsize},

	"UseHighlighter": True,
	"WordWrap": False,
	"HighlightDelay": 200,
	"Colors": {
		"Comments":     MainColorComments,
		"Functions":    MainColorFunctions,
		"Keywords":     MainColorKeywords,
		"Multiline":    MainColorMultiline,
		"Numbers":      MainColorNumbers,
		"Punctuation":  MainColorPunctuation,
		"Strings":      MainColorStrings,

		; AHK
		"A_Builtins":  AHKColorA_Builtins,
		"Commands":    AHKColorCommands,
		"Directives":  AHKColorDirectives,
		"Flow":        AHKColorFlow,
		"Functions":   AHKColorFunctions,
		"KeyNames":    AHKColorKeyNames,
		"KeyWords":    AHKColorKeywords,

		; Snippets-HTML
		"Attributes":   SnippetsColorAttributes,
		"Entities":     SnippetsColorEntities,
		"Tags":         SnippetsColorTags ; plugins
		}

}
)

; clear editor vars just to be sure
 Text1=
 Text2=
 HKey=
 OldKey=
 Shorthand=
 OldShorthand=
 Script=
 Checked=
 Name=
 Author=
 Description=
 TitleMatch=

If (EditMode = "AppendSnippet")
	{
	 AppendToBundle:=Load ; tmp var
	 IfInString, Load, `, ; Append to which Bundle?
		{
		 MadeChoice=0
		 ClipQ1=
		 Loop, Parse, Load, CSV
			{
			 HkHm%A_Index%:=A_LoopField
			 StringSplit, MenuN, A_LoopField, _
			 ClipQ1 .= MenuName_%MenuN1% "|"
			}
		 OldGui10NoResize:=Gui10NoResize
		 Gui10NoResize:=1
		 Gui, 10:Destroy
		 Gui, 10:+Owner +AlwaysOnTop
		 Gui, 10:Add, ListBox, w400 h100 x5 y5 vItem gChoiceMouseOK AltSubmit,
		 Gui, 10:Add, button, default gChoiceOK hidden, OK
		 GuiControl, 10: , ListBox1, |
		 GuiControl, 10: , ListBox1, %ClipQ1%
		 Gui, 10:Show, w410 h110, Append snippet to bundle:
		 ControlSend, ListBox1, {Down}, Append snippet to bundle:
		 Gui10NoResize:=OldGui10NoResize ; fix-to-prevent-resize
		 OldGui10NoResize:=""            ; fix-to-prevent-resize
		 Gui10ListboxCheckPosition("Append snippet to bundle:")
		 WinWaitClose, Append snippet to bundle:
		 MadeChoice = 1

/*
		 Loop ; ugly hack: can't use return here because, well it returns and would thus skip the gui and proceed to paste
			{
			 If (MadeChoice = 1)
				{
				 MadeChoice = 0
				 Break
				}
			 Sleep 20 ; needed for a specific (old) ahk_l version, if no sleep CPU usages jumps to 50%, no responding to hotkeys and no tray menu
			}
*/
		}
	 paste:=AppendToBundle
	}

If (EditMode = "MoveSnippet")
	{
	 MultipleHotkey=
	 StringSplit, paste, paste, _
	 ClipQ1=
	 Loop, parse, MenuName_HitList, |
			{
			 StringSplit, MenuN, A_LoopField, % Chr(5) ; %
			 If (MenuN2 <> Paste1)
				ClipQ1 .= MenuName_%MenuN2% "|"
			}
	 Loop {
		If (Substr(ClipQ1, 1, 1) = "|")
			StringTrimLeft, ClipQ1, ClipQ1, 1
		Else
			Break
		}
	 StringSplit, HkHm, ClipQ1, |
	 OldGui10NoResize:=Gui10NoResize
	 Gui10NoResize:=1
	 Gui, 10:Destroy
	 Gui, 10:+Owner +AlwaysOnTop
	 Gui, 10:Add, ListBox, w400 h100 x5 y5 vItem gChoiceMouseOK AltSubmit,
	 Gui, 10:Add, button, default gChoiceOK hidden, OK
	 GuiControl, 10: , ListBox1, |
	 GuiControl, 10: , ListBox1, %ClipQ1%
	 Gui, 10:Show, w410 h110, Move snippet to bundle:
	 ControlSend, ListBox1, {Down}, Move snippet to bundle:
	 Gui10NoResize:=OldGui10NoResize ; fix-to-prevent-resize
	 OldGui10NoResize:=""            ; fix-to-prevent-resize
	 Gui10ListboxCheckPosition("Move snippet to bundle:")
	 WinWaitClose, Move snippet to bundle:
	 MadeChoice = 1

/*
	 Loop ; ugly hack: can't use return here because, well it returns and would thus skip the gui and proceed to paste
		{
		 If (MadeChoice = 1)
			{
			 MadeChoice = 0
			 Break
			}
		 Sleep 20 ; needed for (old) ahk_l, if no sleep CPU usages jumps to 50%, no responding to hotkeys and no tray menu
		}
*/
	 If (EditMode = "")
		Return
	 Text1:=     Snippet[Paste1,Paste2,1] ; part 1 (enter, or shortcut, or shorthand)
	 Text2:=     Snippet[Paste1,Paste2,2] ; part 2 (shift-enter)
	 HKey:=      Snippet[Paste1,Paste2,3] ; Hotkey
	 ShortHand:= Snippet[Paste1,Paste2,4] ; Shorthand
	 Script:=    Snippet[Paste1,Paste2,5] ; Script (if there is a script run script instead)
	 ; delete
	 Snippet[Paste1].Remove(Paste2)
	 List_%Paste1%_Deleted++     ; Keep track of No deleted snippets so we can update the statusbar correctly

	 List_ToSave_%Paste1%=1
	 Snippet[Paste1,"Save"]:=1 ; (List_ToSave_%Bundle% = 1)
	 Loop, parse, MenuName_HitList, |
		{
		 StringSplit, MenuText, A_LoopField, % Chr(5) ; %
		 If (MenuText1 = AppendToBundle)
			{
			 AppendToBundle:=MenuText2
			 Break
			}
		}
	 Goto, 71Save
	}

If (EditMode = "")
	Return

If (EditMode = "EditSnippet") or (EditMode = "AppendSnippet") or (EditMode = "CopySnippet")
	{
	 StringSplit, paste, paste, _           ; split to bundle / index number
	 Name:=MenuName_%Paste1%
	 OldName:=Name
	 Description:=Description_%Paste1%
	 Author:=Author_%Paste1%
	 TitleMatch:=TitleMatchList_%Paste1%
	}

If (EditMode = "EditSnippet") or (EditMode = "CopySnippet") ; get snippet vars for editor
	{
	 Text1     := Snippet[Paste1,Paste2,1] ; part 1 (enter, or shortcut, or shorthand)
	 Text2     := Snippet[Paste1,Paste2,2] ; part 2 (shift-enter)
	 HKey      := Snippet[Paste1,Paste2,3] ; Hotkey
	 OldKey:=HKey
	 If !EditorHotkeySyntax
		{
		 If (InStr(HKey, "#") > 0)
			{
			 Checked=Checked
			 StringReplace, HKey, HKey, #, , all
			}
		}
	 Shorthand := Snippet[Paste1,Paste2,4] ; Shorthand
	 OldShorthand:=Shorthand
	 Script    := Snippet[Paste1,Paste2,5] ; Script (if there is a script run script instead)
	 AppendToBundle:=Paste1
	}

Filename:=Filename_%paste1%
FileNameBackupSave:=Filename

ActionText:=StrReplace(RegExReplace(EditMode,"([A-Z])"," $1"),"Append","New")

Gui, 71:Destroy
If Theme["MainBackgroundColor"]
	Gui, 71: Color, % Theme["MainBackgroundColor"]
Gui, 71:+Owner1 +Resize +MinSize740x540
Gui, 71:Default
Gui, 71:Menu, MenuBar2
If Theme["EditorGuiTextColor"]
	Gui, 71: font, % "c" Theme["EditorGuiTextColor"]
Gui, 71:font,s12 bold
Gui, 71:Add, Text,     x600   y10 vActionText, %ActionText%
Gui, 71:font,s10 normal
Gui, 71:Add, Picture , x20    y10 w16 h16, %EditorIconlintalist_bundle%
Gui, 71:Add, Text    , x40    y13               , Bundle:`t%A_Space%%A_Space%%A_Space%%Name%
Gui, 71:Add, Text    , x340   y13               , File:%A_Space%%A_Space%%A_Space%%Filename%
Gui, 71:Add, Text,     x20    y45 w700 h1 0x10 vTextLine
Gui, 71:Add, Picture , x20    y65 w16 h16, %EditorIconhotkeys%
Gui, 71:Add, Text    , x40    y65               , Hotke&y:

If !EditorHotkeySyntax
	{
	 Gui, 71:Add, Hotkey  , xp+50  y63  w140 h20 vHKey  , %HKey%
	 Gui, 71:Add, Checkbox, xp+150 y65  w70  h20 vWinKey %checked%, &Win
	}
else If EditorHotkeySyntax
	{
	 Gui, 71: font, cBlack ; to avoid illegible text in shorthand (white on white for example)
	 Gui, 71:Add, Edit  , xp+50  y63  w140 h20 vHKey  , %HKey%
	 Gui, 71:Add, Link, xp+150 y65  w70  h20 , [<a href="https://autohotkey.com/docs/Hotkeys.htm">AHK Docs</a>]
	}
If Theme["EditorGuiTextColor"]
	Gui, 71: font, % "c" Theme["EditorGuiTextColor"]

Gui, 71:Add, Picture , xp+80  y65  w16 h16, %EditorIconshorthand%
Gui, 71:Add, Text    , xp+20  y65  w150 h20           , Sh&orthand:
Gui, 71: font, cBlack ; to avoid illegible text in shorthand (white on white for example)
Gui, 71:Add, Edit    , xp+70  y63  w150 h20 vShorthand, %Shorthand%

Gui, 71:Add, Checkbox, xp+200 y63  w150 h20 vExternalEditorMonitorStatus gExternalEditorMonitorStatusToggle, Monitor Editor

If ExternalEditorMonitorStatus
	GuiControl, 71:,ExternalEditorMonitorStatus,1

If Theme["EditorGuiTextColor"]
	Gui, 71: font, % "c" Theme["EditorGuiTextColor"]
Gui, 71:Add, Picture , x20    y100 w16 h16 vPicture1, %EditorIcontext_dropcaps%
Gui, 71:Add, Text    , x40    y100  vText1Label       , Part &1 (Enter)

Gui, 71:Font,s%fontsize%,%font%
If EditorSyntaxHL
	RC1 := new RichCode(RichCodeSettings.Clone(), "x20 y120 w700 h120 vText1")
else
	Gui, 71:Add, Edit    , x20    y120  h120 w700 vText1  HwndEditText1, %Text1%

Gui, 71:Font,

If Theme["EditorGuiTextColor"]
	Gui, 71: font, % "c" Theme["EditorGuiTextColor"]
Gui, 71:font,s10 normal
Gui, 71:Add, Picture , x20    yp+125 w16 h16 vPicture2, %EditorIcontext_dropcaps%
Gui, 71:Add, Text    , x40    yp    vText2Label      , Part &2 (Shift-Enter)
Gui, 71:Font,s%fontsize%,%font%
If EditorSyntaxHL
	RC2 := new RichCode(RichCodeSettings.Clone(), "x20 yp+20 w700 h90 vText2")
else
	Gui, 71:Add, Edit    , x20    yp+20 h90 w700 vText2  HwndEditText2, %Text2%
Gui, 71:Font,

If Theme["EditorGuiTextColor"]
	Gui, 71: font, % "c" Theme["EditorGuiTextColor"]
Gui, 71:font,s10 normal
Gui, 71:Add, Picture , x20    yp+95 w16 h16 vPicture3, %EditorIconscripts%
Gui, 71:Add, Text    , x40    yp    vText3Label              , Scrip&t (right click for templates, if any)
Gui, 71:Font,s%fontsize%,%font%
If EditorSyntaxHL
	RC3 := new RichCode(RichCodeSettings.Clone(), "x20 yp+20 w700 h90 vScript")
else
	Gui, 71:Add, Edit    , x20    yp+20 h90 w700 vScript HwndEditScript, %Script%
Gui, 71:Font,

If Theme["EditorGuiTextColor"]
	Gui, 71: font, % "c" Theme["EditorGuiTextColor"]
Gui, 71:font, s8, arial
If EditorSyntaxHL
	Gui, 71:Add, Text, x400 y102 h16 w200, Note: press Ctrl+W to toggle Word Wrap
Gui, 71:Add, Button, x610 y100 h20 w110 0x8000 g71EditPart1  vEditorButton1 HwndHButtonEdit1, 1 - Edit in Editor ; part1
Gui, 71:Add, Button, x610 y245 h20 w110 0x8000 g71EditPart2  vEditorButton2 HwndHButtonEdit2, 2 - Edit in Editor ; part2
Gui, 71:Add, Button, x610 y360 h20 w110 0x8000 g71EditScript vEditorButton3 HwndHButtonEdit3, 3 - Edit in Editor ; script

Gui, 71:font, s10

Gui, 71:Add, Button, x20    y480 h30 w210 g71Save     vActionButton1, &Save
Gui, 71:Add, Button, xp+245 yp   h30 w210 g71GuiClose vActionButton2, &Cancel
Gui, 71:Add, Button, xp+245 yp   h30 w210 g71Help     vActionButton3, Help
Gui, 71:Add, StatusBar,,
SB_SetParts(100,100,100,100)
SB_SetText("  Active Editing", 1) ; part

If EditorSyntaxHL
	{
	 Language:="snippet"
	 RC1.Settings.Highlighter := Codes[language].Highlighter
	 RC1.Value := Text1
	 RC2.Settings.Highlighter := Codes[language].Highlighter
	 RC2.Value := Text2
	 Language:="ahk"
	 RC3.Settings.Highlighter := Codes[language].Highlighter
	 RC3.Value := Script
	}

If !EditorSyntaxHL
	{
	 CtlColors.Attach(EditText1 , Theme["EditorBackgroundColor"],Theme["EditorTextColor"])
	 CtlColors.Attach(EditText2 , Theme["EditorBackgroundColor"],Theme["EditorTextColor"])
	 CtlColors.Attach(EditScript, Theme["EditorBackgroundColor"],Theme["EditorTextColor"])
	}

GuiCheckXYPos()
DetectHiddenWindows, On
Try
	{
	 Gui, 71:Show, Hide w740 h540 x%EditorX% y%EditorY%, Lintalist snippet editor
	 WinMove, Lintalist snippet editor, , %EditorX%, %EditorY%, %EditorWidth%, %EditorHeight%
	}
Catch
	Gui, 71:Show, Hide w740 h540, Lintalist snippet editor
DetectHiddenWindows, Off

Gui, 71:Show

WinActivate, Lintalist snippet editor
If EditorSyntaxHL
	GuiControl, Focus, % RC1.hWnd
else
	;ControlFocus, Text1, Lintalist snippet editor
	GuiControl, Focus, Text1

SetTimer, UpdateEditSB, 100

Return

ExternalEditorMonitorStatusToggle:
ExternalEditorMonitorStatus:=!ExternalEditorMonitorStatus
IniWrite, %ExternalEditorMonitorStatus%, %A_ScriptDir%\session.ini, editor, ExternalEditorMonitorStatus
Return

#IfWinActive, Lintalist snippet editor ahk_class AutoHotkeyGUI
^w::
ControlGetFocus, WordWrapControl, A
WordWrapControl:=SubStr(WordWrapControl,0)
WordWrap(WrapPart%WordWrapControl%,WordWrapControl)
WrapPart%WordWrapControl%:=!WrapPart%WordWrapControl%
Return
#IfWinActive


 WordWrap(On,ID) { ; Turn wordwrapping on/off - HT just me @ https://github.com/AHK-just-me/Class_RichEdit/blob/master/Sources/Class_RichEdit.ahk#L1260
	 global rc1,rc2,rc3
	 SendMessage, 0x0448, 0, % (On ? 0 : -1), , % "ahk_id " . RC%ID%.HWND
	 Return On
	}

; Resize editor GUI
71GuiSize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	AutoXYWH("w h0.3"     , "Text1")
	AutoXYWH("w h0.3 y0.3", "Text2")
	AutoXYWH("w h0.4 y0.6", "Script")
	AutoXYWH("y0.3"       , "Text2Label")
	AutoXYWH("y0.3"       , "Picture2")
	AutoXYWH("y0.6"       , "Text3Label")
	AutoXYWH("y0.6"       , "Picture3")
	AutoXYWH("x"          , "EditorButton1")
	AutoXYWH("x y0.3"     , "EditorButton2")
	AutoXYWH("x y0.6"     , "EditorButton3")
	AutoXYWH("x0.5 y"     , "ActionButton1")
	AutoXYWH("x0.5 y"     , "ActionButton2")
	AutoXYWH("x0.5 y"     , "ActionButton3")
	AutoXYWH("w"          , "TextLine")
	AutoXYWH("x"          , "ActionText")
	AutoXYWH("x"          , "ExternalEditorMonitorStatus")
Return

71Help:
Run, docs\index.html
Return

71Save:
If (EditMode <> "MoveSnippet")
	Gui, 71:Submit, NoHide
If !EditorHotkeySyntax
	{
	 If (HKey = "vk00") ; temp fix for ahk 1.1.02.1-1.1.02.3
		HKey=
	 If (Winkey = 1)
		HKey = #%HKey% ; add Win modifier key
	 StringLower, HKey, HKey
	}
If (EditMode = "EditSnippet")
	Check:=Paste1
Else If (EditMode = "AppendSnippet") or (EditMode = "CopySnippet") or (EditMode = "MoveSnippet")
	Check:=AppendToBundle

If InStr(Text1 Text2 Script,Chr(5)) or InStr(Text1 Text2 Script,Chr(7))
	{
	 MsgBox,16,Warning, Illegal character in Snippet.`n`nUsing ASCII 5 (Enquiry) and ASCII 7 (Bell) in Snippets is not permitted, use [[Chr(5)]] and [[Chr(7)]] instead.
		Return
	}

If EditorSnippetErrorCheck
	{
	 If !SnippetErrorCheck(Text1,EditorSnippetErrorCheck) or !SnippetErrorCheck(Text2,EditorSnippetErrorCheck)
		{
		 MsgBox,52,Warning, Possible Plugin/function error in Snippet.`nMismatch number of square brackets.`n`n(see EditorSnippetErrorCheck setting)`n`nDo you want to continue editing the snippet? (Yes)`nSelect No to ignore error(s) and save Edits.
		 IfMsgBox, Yes
			Return
		}
	}

; EditorHotkeySyntax: check valid hotkey
If EditorHotkeySyntax
	{
	 Hotkey, IfWinNotActive, ahk_group BundleHotkeys
	 Hotkey, % "$" HKey, EditorHotkeySyntaxDummyLabel, UseErrorLevel
	 If ErrorLevel
		{
		 MsgBox,48,Warning [%ErrorLevel%], %HKey% does not seem to be a valid hotkey.`nOne or more keys are either not recognized or not supported by the current keyboard layout/language.`n`nErrorLevel: %ErrorLevel% - check AHK Hotkey documentation for reference.
		 Hotkey, IfWinNotActive
		 Return
		}
	 Hotkey, IfWinNotActive
	}

; Checking for duplicate shorthand within same bundle
HitKeyHistory=
HitKeyHistory:=CheckHitList("Shorthand", Shorthand, Check)
; MsgBox % HitKeyHistory "`n" Paste1 "_" Paste2 "," ; debug
If HitKeyHistory
	{
	 If (HitKeyHistory = Paste1 "_" Paste2 ",") and (EditMode = "EditSnippet")
		{
		 ; its OK
		}
	 else
		{
		 MsgBox,48,Warning, Shorthand collision`nThis abbreviation is already in use in this Bundle.`nBundleName added to Shorthand, so be sure to edit.
		 Shorthand:= MenuText1 ":" Shorthand
		 GuiControl,71:, Shorthand, %Shorthand%
		 If (EditMode <> "MoveSnippet")
			Return
		}
	}

; Checking for duplicate hotkeys within same bundle
HitKeyHistory=
HitKeyHistory:=CheckHitList("Hotkey", HKey, Check, 1)
; MsgBox % HitKeyHistory "`n" Paste1 "_" Paste2 "," ; debug
If HitKeyHistory
	{
	 If (HitKeyHistory = Paste1 "_" Paste2 ",") and (EditMode = "EditSnippet")
		{
		 ; its OK
		}
	 else
		{
		 MsgBox,48,Warning, Hotkey collision.`nThis keyboard shortcut is already in use in this Bundle.`nHotkey reset for this snippet.
		 If (EditMode <> "MoveSnippet")
			{
			 If !EditorHotkeySyntax
				GuiControl,71:, msctls_hotkey321,
			 Else If EditorHotkeySyntax
				GuiControl,71:, HKey,
			 Return
			}
		 HKey=
		}
	}

If (EditMode = "EditSnippet")
	{
	 Snippet[Paste1,Paste2,1] := Text1      ; part 1 (enter)
	 Snippet[Paste1,Paste2,2] := Text2      ; part 2 (shift-enter)
	 If (Snippet[Paste1,Paste2,2] <> "")
		Snippet[Paste1,"Col2"]:=1
	 Snippet[Paste1,Paste2,3] := HKey       ; Hotkey
	 Snippet[Paste1,Paste2,4] := Shorthand  ; Shorthand
	 Snippet[Paste1,Paste2,5] := Script     ; Script (if there is a script run script instead)

	 Snippet[Paste1,Paste2,"1v"]:=FixPreview(Text1)
	 Snippet[Paste1,Paste2,"2v"]:=FixPreview(Text2)

	 List_ToSave_%Paste1%=1
	 Snippet[Paste1,"Save"]:=1
	 Counter:=Paste1
	}
Else If (EditMode = "AppendSnippet") or (EditMode = "CopySnippet") or (EditMode = "MoveSnippet")
	{
	 If (Text1 = "") and (Text2 = "") and (HKey = "") and (Shorthand = "") and (Script = "")
		Return ; nothing to do

	 ;Snippet[AppendToBundle].Push({1:Text1,2:Text2,3:HKey,4:Shorthand,5:Script,"1v":FixPreview(Text1),"2v":FixPreview(Text2)})
	 If (Trim(Text2," `r`n`t") = "")
		Text2:=""
	 Snippet[AppendToBundle].InsertAt(1,{1:Text1,2:Text2,3:HKey,4:Shorthand,5:Script,"1v":FixPreview(Text1),"2v":FixPreview(Text2)})
	 Snippet[AppendToBundle,"Save"]:=1  ; added 11/12/2018 fix movesnippet

	 If Text2
		Snippet[AppendToBundle,"Col2"]:=1
	 If Shorthand
		Snippet[AppendToBundle,"Col4"]:=1
	 If HKey
		Snippet[AppendToBundle,"Col3"]:=1
/*
	 Snippet[AppendToBundle,"Save"]:=1
	 listcounter:= Snippet[AppendToBundle].MaxIndex() + 1
	 Snippet[AppendToBundle,listcounter,1]:=Text1
	 Snippet[AppendToBundle,listcounter,2]:=Text2
	 Snippet[AppendToBundle,listcounter,3]:=HKey
	 Snippet[AppendToBundle,listcounter,4]:=Shorthand
	 Snippet[AppendToBundle,listcounter,5]:=Script

	 ;fix preview
	 fix1 := Snippet[AppendToBundle,listcounter,1]
	 fix2 := Snippet[AppendToBundle,listcounter,2]
	 StringReplace, fix1, fix1, `r, ,all
	 StringReplace, fix1, fix1, `n, \n,all
	 StringReplace, fix1, fix1, %A_Tab%, \t,all
	 StringReplace, fix2, fix2, `r, ,all
	 StringReplace, fix2, fix2, `n, \n,all
	 StringReplace, fix2, fix2, %A_Tab%, %A_Space%,all
	 ;/fix preview

	 Snippet[AppendToBundle,listcounter,"1v"]:=fix1
	 Snippet[AppendToBundle,listcounter,"2v"]:=fix2
*/
	 Append=
(

- LLPart1: %Text1%
  LLPart2: %Text2%
  LLKey: %HKey%
  LLShorthand: %Shorthand%
  LLScript: %Script%
)

If (FileName <> FileNameBackupSave) ; added 23/08/2020 still wrong bundle from time to time
	FileName:=FileNameBackupSave
FileNameBackupSave:=""

 ;  File=
 ;  File .= A_ScriptDir "\bundles\" FileName_%AppendToBundle% ; debug 04/04/2018
    File := A_ScriptDir "\bundles\" Filename ; debug 04/04/2018
    If (FileName = "")
    	File:=A_ScriptDir "\bundles\" FileName_%AppendToBundle%
If !(EditMode = "MoveSnippet") ; added 11/12/2018 fix movesnippet
	{
	IfNotInString, File, .txt
		{
		 MsgBox, 48, Error, ERROR: Can not append snippet to Bundle (No file name available)`nBundle: %File%`n`nDo you wish to Reload?
		 IfMsgBox, Yes
			Gosub, RunReload
		}
	Else
		{
		 FileAppend, %Append%, %file%, UTF-8
		 If (ErrorLevel = 0)
			MsgBox, 64, Snippet succesfully added to bundle, % File "`n" Append
		 Else
			MsgBox, 48, Error, % "ERROR: Could not append snippet to Bundle`n`n" File "`n" Append
		}
		Counter:=AppendToBundle
	}
	}
Else If (EditMode = "NewBundle")
	{
	 ;MsgBox %Name% - %Description%
	 InputBox, NewBundleFileName, Save as, File name of new bundle, , 400, 150
	 If (NewBundleFileName = "")
		{
		 Return
		}
	 NewBundleFileName .= ".txt" ; make sure *.txt was added otherwise it won't load at next startup
	 StringReplace, NewBundleFileName, NewBundleFileName, .txt.txt, .txt, all
	 File .= A_ScriptDir "\bundles\" NewBundleFileName
	 If (Text1 = "") and (Text2 = "") and (HKey = "") and (Shorthand = "") and (Script = "")
		Append= ; no snippet defined
	 Else {
Append=
(

- LLPart1: %Text1%
  LLPart2: %Text2%
  LLKey: %HKey%
  LLShorthand: %Shorthand%
  LLScript: %Script%
)
}
FileAppend,
(
BundleFormat: 1
Name: %Name%
Description: %Description%
Author: %Author%
TitleMatch: %TitleMatch%
Patterns:
%append%

), %file%, UTF-8

	 Gosub, 71GuiSavePos
	 Gui, 1:-Disabled
	 Gui, 71:Destroy
	 Gui, 1:Destroy
	 ;Menu, File, DeleteAll
	 ;Reload ; lazy solution - it is just easier for now
	 Gosub, RunReload
	}

; Update shortcutlist and shorthandlist here
ArrayName=List_
HotKeyHitList_%Counter%:=Chr(5)    ; clear
ShortHandHitList_%Counter%:=Chr(5) ; clear
; MsgBox % Counter
If (OldKey <> "") and (OldKey <> HKey) ; only turn off when the hotkey has changed
	{
	 Hotkey, IfWinNotActive, ahk_group BundleHotkeys
	 Hotkey, % "$" . OldKey, Off ; set old hotkey off ...
	 Hotkey, IfWinNotActive
	}
Loop, % Snippet[Counter].MaxIndex() ; LoopIt
	{
	 If (Snippet[Counter,A_Index,3] <> "") ; if no hotkey defined: skip
		{
		 Hotkey, IfWinNotActive, ahk_group BundleHotkeys
		 Hotkey, % "$" . Snippet[Counter,A_Index,3], ShortCut ; set hotkeys
		 If (ShortcutPaused = 1)
			{
			 Hotkey, % "$" . Snippet[Counter,A_Index,3], Off ; set hotkeys off ...
			}
		 HotKeyHitList_%Counter% .= Snippet[Counter,A_Index,3] Chr(5)
		 Hotkey, IfWinNotActive
		 Snippet[Counter,"Col3"]:=1
		}

	 If (Snippet[Counter,A_Index,4] <> "") ; if no shorthand defined: skip
		{
		 ShortHandHitList_%Counter% .= Snippet[Counter,A_Index,4] Chr(5)
		 Snippet[Counter,"Col4"]:=1
		}
	}


Gosub, 71GuiSavePos
Gui, 1:-Disabled
Gui, 71:Destroy
if (AlwaysUpdateBundles = 1)
	SaveUpdatedBundles(AppendToBundle)

If (OldKey <> HKey)
	{
	 MsgBox,52, Restart, It seems you changed the hotkey, it is advised to restart Lintalist.`nOK to Restart?
	 IfMsgBox, Yes
		Gosub, RunReload
		; Reload
	}

WinActivate, %AppWindow%
WinWaitActive, %AppWindow%
LoadBundle(Load)
UpdateLVColWidth()
Gosub, SetStatusBar
lasttext = fadsfSDFDFasdFdfsadfsadFDSFDf
Gosub, GetText
;LV_Modify(SelItem, "Select") ; set focus on snippet we edited in listview
;LV_Modify(SelItem, "Vis")    ; doesn't work yet as DOWN starts at row 1 again
;Sleep 10
ControlFocus, Edit1, %AppWindow%
ShowPreview(PreviewSection)
InEditMode = 0
If OnTopStateSaved
	Gosub, GuiOnTopCheck
Return

PasteHTMLEdit:
If !WinClip.HasFormat(49351)
	Return
ControlGet, ControlID, Hwnd,, %control%, Lintalist snippet editor
PasteFromHTML(WinClip.GetHTML())
If EditorSyntaxHL
	{
	 SendMessage, 0x302, 0, 0, , ahk_id %ControlID%
	}
else
	{
	 Control, EditPaste, %clipboard%, %Control%, Lintalist snippet editor
	}
Return

PasteFromHTML(in)
	{
	 in:=RegExReplace(in,"iUs)^.*<htm","[[html]]<htm")
	 in:=StrReplace(in,"<!--StartFragment-->")
	 in:=StrReplace(in,"<!--EndFragment-->")
	 ; we need to go from UTF-8 bytes to Unicode text to prevent Ã, Ã¨, etc
	 clipsize := StrPut(in, "CP0")
	 VarSetCapacity(cliptemp, clipsize)
	 StrPut(in, &cliptemp, "CP0")
	 clipboard:=StrGet(&cliptemp, "UTF-8")
	}

CallEditControlInEditor:

If ExternalEditorMonitorStatus
	{
	 EditControlInEditor(ControlID)
	 Return
	}

ControlGetText, CheckEditorState, , ahk_id %ButtonHwnd%

if InStr(CheckEditorState,"Edit in Editor")
	{
	 Gui, 71:Default
	 GuiControl, , %ButtonID%, Load from File
	 EditControlInEditor(ControlID)
	 OriginalButtonText:=CheckEditorState
	}
else ; load from file and reset button text
	{
	 Gosub, UpdateFromFile
	 Gui, 71:Default
	 GuiControl, , %ButtonID%, %OriginalButtonText%
	 OriginalButtonText:=""
	}
Return

DisableEditButtons(id)
	{
	 global HButtonEdit1,HButtonEdit2,HButtonEdit3
	 GuiControl, Disable, %HButtonEdit1%
	 GuiControl, Disable, %HButtonEdit2%
	 GuiControl, Disable, %HButtonEdit3%
	 GuiControl, Enable, %id%
	}

71EditPart1:
ControlID:="Text1"
ButtonID:="EditorButton1"
ButtonHwnd:=HButtonEdit1
Gosub, CallEditControlInEditor
ControlID:="",ButtonID:="",ButtonHwnd:=""
Return

71EditPart2:
ControlID:="Text2"
ButtonID:="EditorButton2"
ButtonHwnd:=HButtonEdit2
Gosub, CallEditControlInEditor
ControlID:="",ButtonID:="",ButtonHwnd:=""
Return

71EditScript:
ControlID:="Script"
ButtonID:="EditorButton3"
ButtonHwnd:=HButtonEdit3
Gosub, CallEditControlInEditor
ControlID:="",ButtonID:="",ButtonHwnd:=""
Return

EditControlInEditor(ControlID)
	{
	 Global WhichControl, SnippetEditor, TmpDir, RC1, RC2, RC3, RCID, EditorSyntaxHL, ExternalEditorMonitorStatus, EditorTempFileExtension, EditorMenu, SetEditor, ButtonID

	 If EditorSyntaxHL
		{
		 if (ControlID = "Text1")
			WhichControl:="RICHEDIT50W1"
		 else if (ControlID = "Text2")
			WhichControl:="RICHEDIT50W2"
		 else if (ControlID = "Script")
			WhichControl:="RICHEDIT50W3"

		 RCID:=SubStr(WhichControl,0)
		 ToFile:=RC%RCID%.Value
		}
	 else
		{
		 if (ControlID = "Text1")
			WhichControl:="Text1"
		 else if (ControlID = "Text2")
			WhichControl:="Text2"
		 else if (ControlID = "Script")
			WhichControl:="Script"

		 GuiControlGet, ToFile, , %ControlID%
		}

	 FileDelete, %TmpDir%\__tmplintalistedit.%EditorTempFileExtension%
	 FileAppend, %ToFile%, %TmpDir%\__tmplintalistedit.%EditorTempFileExtension%, UTF-8
	 If (SnippetEditor = "")
		Run, edit "%TmpDir%\__tmplintalistedit.%EditorTempFileExtension%"
	 else if (SetEditor = "Default")
		Run, "%SnippetEditor%" "%TmpDir%\__tmplintalistedit.%EditorTempFileExtension%"
	 else if (SetEditor <> "Default")
		{
		 RunEditor:=EditorMenu[SetEditor]
		 Run, "%RunEditor%" "%TmpDir%\__tmplintalistedit.%EditorTempFileExtension%"
		 RunEditor:=""
		}
	 DisableEditButtons(ButtonID)
	 WinWait, __tmplintalistedit
	 If ExternalEditorMonitorStatus
		{
		 SetTimer, CheckEdit, 500, On
		}
	 Return
	}

CheckEdit:
IfWinExist, __tmplintalistedit
	Return
SetTimer, CheckEdit, Off
UpdateFromFile:
FileRead, NewText, %TmpDir%\__tmplintalistedit.%EditorTempFileExtension%
FileDelete, %TmpDir%\__tmplintalistedit.%EditorTempFileExtension%
If ErrorLevel
	TrayTip, Lintalist Editor, Could not delete temporary file - it may still be open or locked by the editor.,5
WinActivate, Lintalist bundle editor
Gui, 71:Default
If EditorSyntaxHL
	{
	 RC%RCID%.Value:=NewText
	 GuiControl, Focus, % RC%RCID%.hWnd
	}
else
	{
	 GuiControl, ,%WhichControl%, %NewText%
	 ControlFocus, %WhichControl%, Lintalist bundle editor
	}
NewText=
WhichControl=
RCID=
Gosub, EnableEditButtons
Return

71GuiEscape:
71GuiClose:
SetTimer, UpdateEditSB, off
Gosub, 71GuiSavePos
Gui, 1:-Disabled
Gui, 71:Destroy
WinActivate, %AppWindow%
InEditMode = 0
ControlFocus, Edit1, %AppWindow%
If OnTopStateSaved
	Gosub, GuiOnTopCheck
Return

SnippetErrorCheck(in,type)
	{
	 if (type = "[")
		{
		 if (CountString(in, "[") = CountString(in, "]"))
			Return 1
		}
	 if (type = "[[")
		{
		 if (CountString(in, "[[") = CountString(in, "]]"))
			Return 1
		}
	}

#include %A_ScriptDir%\include\RichCode\RichCode.ahk
#include %A_ScriptDir%\include\RichCode\AHK.ahk
#include %A_ScriptDir%\include\RichCode\SnippetHTML.ahk
#include %A_ScriptDir%\include\RichCode\Util.ahk

EditorWindowPosition:
IniRead, EditorX     , %A_ScriptDir%\session.ini, editor, EditorX, 100
IniRead, EditorY     , %A_ScriptDir%\session.ini, editor, EditorY, 100
IniRead, EditorY     , %A_ScriptDir%\session.ini, editor, EditorY, 100
IniRead, EditorWidth , %A_ScriptDir%\session.ini, editor, EditorWidth, 740
IniRead, EditorHeight, %A_ScriptDir%\session.ini, editor, EditorHeight, 520
IniRead, ExternalEditorMonitorStatus, %A_ScriptDir%\session.ini, editor, ExternalEditorMonitorStatus, 1
IniRead, EditorTempFileExtension    , %A_ScriptDir%\session.ini, editor, EditorTempFileExtension, txt
IniRead, SetEditor                  , %A_ScriptDir%\session.ini, editor, SetEditor, Default
Return

71GuiSavePos:
WinGetPos, EditorX, EditorY, EditorWidth, EditorHeight, Lintalist snippet editor
Return

EditorWindowPositionSave:
IniWrite, %EditorX%     , %A_ScriptDir%\session.ini, editor, EditorX
IniWrite, %EditorY%     , %A_ScriptDir%\session.ini, editor, EditorY
IniWrite, %EditorWidth% , %A_ScriptDir%\session.ini, editor, EditorWidth
IniWrite, %EditorHeight%, %A_ScriptDir%\session.ini, editor, EditorHeight
IniWrite, %ExternalEditorMonitorStatus%, %A_ScriptDir%\session.ini, editor, ExternalEditorMonitorStatus
IniWrite, %SetEditor%, %A_ScriptDir%\session.ini, editor, SetEditor
Return

EditorHotkeySyntaxDummyLabel:
Return

; used in ReadIni for EditorAutoCloseBrackets settings
AutoCloseBrackets(in)
	{
	 ControlGetFocus, Control, A
	 what:=StrReplace(in,"|")
	 Left:=StrLen(StrSplit(in,"|").2)
	 Control, EditPaste, %what%, %Control%, Lintalist snippet editor
	 Send {left %left%}
	}

ReadThemeEditorIcons:
Loop, parse, % "lintalist_bundle.png,text_dropcaps.png,hotkeys.ico,shorthand.ico,scripts.ico", CSV
	{
	 SplitPath, A_LoopField, , , EditorIconOutExtension, EditorIconOutFileNameNoExt
	 If FileExist(A_ScriptDir "\themes\icons\" EditorIconOutFileNameNoExt "_" Theme["path"] "." EditorIconOutExtension)
		EditorIcon%EditorIconOutFileNameNoExt%:=A_ScriptDir "\themes\icons\" EditorIconOutFileNameNoExt "_" Theme["path"] "." EditorIconOutExtension
	 else
		EditorIcon%EditorIconOutFileNameNoExt%:=A_ScriptDir "\icons\" EditorIconOutFileNameNoExt "." EditorIconOutExtension
	}
EditorIconOutFileNameNoExt:="",EditorIconOutExtension:=""
Return

; Menu and object created in ReadIni.AutoHotkey, ReadEditorsIni()
EditorMenuHandler:
if (A_ThisMenuItem = "Reset (enable) Edit Buttons")
	{
	 Gosub, EnableEditButtons
	 GuiControl, , EditorButton1, 1 - Edit in Editor
	 GuiControl, , EditorButton2, 2 - Edit in Editor
	 GuiControl, , EditorButton3, 3 - Edit in Editor
	 Return
	}

Try
	Menu, EditorMenuButton, UnCheck, %SetEditor%
SetEditor:=A_ThisMenuItem
; MsgBox % EditorMenu[SetEditor]
Try
	Menu, EditorMenuButton, Check, %SetEditor%
Return

EnableEditButtons:
GuiControl, Enable, %HButtonEdit1%
GuiControl, Enable, %HButtonEdit2%
GuiControl, Enable, %HButtonEdit3%
Return

UpdateEditSB:
IfWinNotActive, Lintalist snippet editor
	Return

ControlGetFocus, ControlID,Lintalist snippet editor 
ControlGetText, GetText, %ControlID%, Lintalist snippet editor
ControlGet, CurrentLine, CurrentLine,,%ControlID%, Lintalist snippet editor
ControlGet, CurrentCol , CurrentCol ,,%ControlID%, Lintalist snippet editor
ControlGet, LineCount  , LineCount  ,,%ControlID%, Lintalist snippet editor
Size:=StrLen(GetText)
if (CurrentLine = oldCurrentLine) and (CurrentCol = oldCurrentCol) and (LineCount = oldLineCount)
	return

Gui, 71:Default

SB_SetText("Ln " Currentline ", Col " CurrentCol, 2) ; line nr/col nr
SB_SetText(LineCount " line(s)", 3)                  ; lines
SB_SetText(Size " byte(s)", 4)                       ; bytes
oldCurrentLine:=CurrentLine
oldCurrentCol:=CurrentCol
oldLineCount:=LineCount
Return
