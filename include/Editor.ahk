; LintaList Include
; Purpose: Bundle & Snippet Editor
; Version: 1.2
;
; Hotkeys used in Search GUI to start Bundle & Snippet Editor
; F4  = Edit snippet
; F5  = Copy and Edit snippet
; F6  = Move snippet (from one bundle to another)
; F7  = Add new snippet
; F8  = Delete snippet
; 
; History: 
; v1.1 - Use font/fontsize settings in Editor as well (as in the Search GUI)
; v1.1 - Added (optional) Syntax Highlighting for snippets/html/scripts
; 
; 

BundleEditor:
InEditMode:=1
WrapPart1:=1
WrapPart2:=1
WrapPart3:=1

Codes := { "AHK": { "Highlighter": "HighlightAHK" }
	, "Snippet": {"Highlighter": "HighlightSnippet"	}
	, "Plain": { "Highlighter": "" } } 

; Settings array for the RichCode control
RichCodeSettings:=
( LTrim Join Comments
{
	"TabSize": 4,
	"Indent": "`t",
	"FGColor": 0x000000,
	"BGColor": 0xFFFFFF,
	"Font": {"Typeface": font, "Size": fontsize},
	
	"UseHighlighter": True,
	"WordWrap": False,
	"HighlightDelay": 200,
	"Colors": {
		"Comments":     0x7F9F7F,
		"Functions":    0x7CC8CF,
		"Keywords":     0xE4EDED,
		"Multiline":    0x7F9F7F,
		"Numbers":      0xF79B57,
		"Punctuation":  0x000088,
		"Strings":      0xCC9893,
		
		; AHK
		"A_Builtins":   0xF79B57,
		"Commands":     0x008800,
		"Directives":   0x7CC8CF,
		"Flow":         0x008800,
		"KeyNames":     0xCB8DD9,
	
		; Snippets-HTML
		"Attributes":   0x7CC8CF,
		"Entities":     0xF79B57,
		"Tags":         0x008800 ; plugins
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
		 Gui10NoResize:=1
		 Gui, 10:Destroy
		 Gui, 10:+Owner +AlwaysOnTop
		 Gui, 10:Add, ListBox, w400 h100 x5 y5 vItem gChoiceMouseOK AltSubmit, 
		 Gui, 10:Add, button, default gChoiceOK hidden, OK
		 GuiControl, 10: , ListBox1, |
		 GuiControl, 10: , ListBox1, %ClipQ1%
		 Gui, 10:Show, w410 h110, Append snippet to bundle:
		 ControlSend, ListBox1, {Down}, Append snippet to bundle:
		 Gui10NoResize:=0
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
	 Gui10NoResize:=1
	 Gui, 10:Destroy
	 Gui, 10:+Owner +AlwaysOnTop
	 Gui, 10:Add, ListBox, w400 h100 x5 y5 vItem gChoiceMouseOK AltSubmit, 
	 Gui, 10:Add, button, default gChoiceOK hidden, OK
	 GuiControl, 10: , ListBox1, |
	 GuiControl, 10: , ListBox1, %ClipQ1%
	 Gui, 10:Show, w410 h110, Move snippet to bundle:
	 ControlSend, ListBox1, {Down}, Move snippet to bundle:
	 Gui10NoResize:=0
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

ActionText:=StrReplace(RegExReplace(EditMode,"([A-Z])"," $1"),"Append","New")

Gui, 71:Destroy
Gui, 71:+Owner +Resize +MinSize740x520
Gui, 71:Default
Gui, 71:Menu, MenuBar2
Gui, 71:font,s12 bold
Gui, 71:Add, Text,     x600   y10 vActionText, %ActionText%
Gui, 71:font,s10 normal
Gui, 71:Add, Picture , x20    y10 w16 h16, %A_ScriptDir%\icons\lintalist_bundle.png
Gui, 71:Add, Text    , x40    y13               , Bundle:`t%A_Space%%A_Space%%A_Space%%Name%
Gui, 71:Add, Text    , x340   y13               , File:%A_Space%%A_Space%%A_Space%%Filename%
Gui, 71:Add, Text,     x20    y45 w700 h1 0x10 vTextLine
Gui, 71:Add, Picture , x20    y65 w16 h16, %A_ScriptDir%\icons\hotkeys.ico
Gui, 71:Add, Text    , x40    y65                  , Hotkey: 

If !EditorHotkeySyntax
	{
	 Gui, 71:Add, Hotkey  , xp+50  y63  w140 h20 vHKey  , %HKey%
	 Gui, 71:Add, Checkbox, xp+150 y65  w70  h20 vWinKey %checked%, Win
	}
else If EditorHotkeySyntax
	{
	 Gui, 71:Add, Edit  , xp+50  y63  w140 h20 vHKey  , %HKey%
	 Gui, 71:Add, Link, xp+150 y65  w70  h20 , [<a href="https://autohotkey.com/docs/Hotkeys.htm">AHK Docs</a>]
	}

Gui, 71:Add, Picture , xp+80  y65  w16 h16, %A_ScriptDir%\icons\shorthand.ico
Gui, 71:Add, Text    , xp+20  y65  w150 h20           , Shorthand: 
Gui, 71:Add, Edit    , xp+70  y63  w150 h20 vShorthand, %Shorthand%

Gui, 71:Add, Picture , x20    y100 w16 h16 vPicture1, %A_ScriptDir%\icons\text_dropcaps.png
Gui, 71:Add, Text    , x40    y100  vText1Label       , Part 1 (Enter)

Gui, 71:Font,s%fontsize%,%font%
If EditorSyntaxHL
	RC1 := new RichCode(RichCodeSettings.Clone(), "x20 y120 w700 h120 vText1")
else
	Gui, 71:Add, Edit    , x20    y120  h120 w700 vText1  , %Text1%
Gui, 71:Font,

Gui, 71:Add, Picture , x20    yp+125 w16 h16 vPicture2, %A_ScriptDir%\icons\text_dropcaps.png
Gui, 71:Add, Text    , x40    yp    vText2Label      , Part 2 (Shift-Enter)
Gui, 71:Font,s%fontsize%,%font%
If EditorSyntaxHL
	RC2 := new RichCode(RichCodeSettings.Clone(), "x20 yp+20 w700 h90 vText2")
else	
	Gui, 71:Add, Edit    , x20    yp+20 h90 w700 vText2  , %Text2%
Gui, 71:Font,

Gui, 71:Add, Picture , x20    yp+95 w16 h16 vPicture3, %A_ScriptDir%\icons\scripts.ico
Gui, 71:Add, Text    , x40    yp    vText3Label              , Script
Gui, 71:Font,s%fontsize%,%font%
If EditorSyntaxHL
	RC3 := new RichCode(RichCodeSettings.Clone(), "x20 yp+20 w700 h90 vScript")
else
	Gui, 71:Add, Edit    , x20    yp+20 h90 w700 vScript , %Script%
Gui, 71:Font,

Gui, 71:font, s8, arial
If EditorSyntaxHL
	Gui, 71:Add, Text, x400 y102 h16 w200, Note: press Ctrl+W to toggle Word Wrap
Gui, 71:Add, Button, x610 y100 h20 w110 0x8000 g71EditPart1  vEditorButton1, 1 - Edit in Editor ; part1
Gui, 71:Add, Button, x610 y245 h20 w110 0x8000 g71EditPart2  vEditorButton2, 2 - Edit in Editor ; part2
Gui, 71:Add, Button, x610 y360 h20 w110 0x8000 g71EditScript vEditorButton3, 3 - Edit in Editor ; script
Gui, 71:font, s10

Gui, 71:Add, Button, x20    y480 h30 w210 g71Save     vActionButton1, &Save
Gui, 71:Add, Button, xp+245 yp   h30 w210 g71GuiClose vActionButton2, &Cancel
Gui, 71:Add, Button, xp+245 yp   h30 w210 g71Help     vActionButton3, Help

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

GuiCheckXYPos()
DetectHiddenWindows, On
Try
	{
	 Gui, 71:Show, Hide w740 h520 x%EditorX% y%EditorY%, Lintalist snippet editor
	 WinMove, Lintalist snippet editor, , %EditorX%, %EditorY%, %EditorWidth%, %EditorHeight%
	}
Catch
	Gui, 71:Show, Hide w740 h520, Lintalist snippet editor
DetectHiddenWindows, Off
Gui, 71:Show

WinActivate, Lintalist snippet editor
If EditorSyntaxHL
	GuiControl, Focus, % RC1.hWnd
else
	ControlFocus, Text1, Lintalist snippet editor
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

If !SnippetErrorCheck(Text1,"[[") or !SnippetErrorCheck(Text2,"[[")
	{
	 MsgBox,48,Warning, Possible Plugin/function error in Snippet.`nMismatch number of square brackets "[[" and "]]".
	 Return
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
	 Snippet[AppendToBundle].InsertAt(1,{1:Text1,2:Text2,3:HKey,4:Shorthand,5:Script,"1v":FixPreview(Text1),"2v":FixPreview(Text2)})
	 Snippet[AppendToBundle,"Save"]:=1  ; added 11/12/2018 fix movesnippet

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
		 	Reload
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
	 Reload ; lazy solution - it is just easier for now
	}
	 
; Update shortcutlist and shorthandlist here
ArrayName=List_
HotKeyHitList_%Counter%:=Chr(5)    ; clear
ShortHandHitList_%Counter%:=Chr(5) ; clear
; MsgBox % Counter
If (OldKey <> "") ; and (OldKey <> HKey)
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
		}
			
	 If (Snippet[Counter,A_Index,4] <> "") ; if no shorthand defined: skip
		{
		 ShortHandHitList_%Counter% .= Snippet[Counter,A_Index,4] Chr(5)
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
	 	Reload
	}
	
WinActivate, %AppWindow%
WinWaitActive, %AppWindow%
LoadBundle(Load)
UpdateLVColWidth()
ControlFocus, Shorthand, %AppWindow%
Gosub, SetStatusBar	
lasttext = fadsfSDFDFasdFdfsadfsadFDSFDf
Gosub, GetText
;LV_Modify(SelItem, "Select") ; set focus on snippet we edited in listview
;LV_Modify(SelItem, "Vis")    ; doesn't work yet as DOWN starts at row 1 again
;Sleep 10
;ControlFocus, Edit1, %AppWindow%
ShowPreview(PreviewSection)
InEditMode = 0
Return

71EditPart1:
EditControlInEditor("Text1")
Return

71EditPart2:
EditControlInEditor("Text2")
Return

71EditScript:
EditControlInEditor("Script")
Return

EditControlInEditor(ControlID)
	{
	 Global WhichControl,SnippetEditor,TmpDir, RC1, RC2, RC3, RCID, EditorSyntaxHL

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
 
	 FileDelete, %TmpDir%\__tmplintalistedit.txt
	 FileAppend, %ToFile%, %TmpDir%\__tmplintalistedit.txt, UTF-8
	 If (SnippetEditor = "")
		Run, %TmpDir%\__tmplintalistedit.txt
	 else
		Run, %SnippetEditor% %TmpDir%\__tmplintalistedit.txt
	 WinWait, __tmplintalistedit
	 SetTimer, CheckEdit, 500, On
	 Return
	}

CheckEdit:
IfWinExist, __tmplintalistedit
	Return
SetTimer, CheckEdit, Off
FileRead, NewText, %TmpDir%\__tmplintalistedit.txt
FileDelete, %TmpDir%\__tmplintalistedit.txt
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
Return

71GuiEscape:
71GuiClose:
Gosub, 71GuiSavePos
Gui, 1:-Disabled
Gui, 71:Destroy
WinActivate, %AppWindow%
InEditMode = 0
ControlFocus, Shorthand, %AppWindow%
Return

SnippetErrorCheck(in,type)
	{
	 if (type = "[[")
		{
		 if (CountString(in, "[[") = CountString(in, "]]"))
			Return 1
		}
	}

#include %A_ScriptDir%\include\richcode\RichCode.ahk
#include %A_ScriptDir%\include\richcode\AHK.ahk
#include %A_ScriptDir%\include\richcode\SnippetHTML.ahk
#include %A_ScriptDir%\include\richcode\Util.ahk

EditorWindowPosition:
IniRead, EditorX     , %A_ScriptDir%\session.ini, editor, EditorX, 100
IniRead, EditorY     , %A_ScriptDir%\session.ini, editor, EditorY, 100
IniRead, EditorWidth , %A_ScriptDir%\session.ini, editor, EditorWidth, 740
IniRead, EditorHeight, %A_ScriptDir%\session.ini, editor, EditorHeight, 520
Return

71GuiSavePos:
WinGetPos, EditorX, EditorY, EditorWidth, EditorHeight, Lintalist snippet editor
Return

EditorWindowPositionSave:
IniWrite, %EditorX%     , %A_ScriptDir%\session.ini, editor, EditorX
IniWrite, %EditorY%     , %A_ScriptDir%\session.ini, editor, EditorY
IniWrite, %EditorWidth% , %A_ScriptDir%\session.ini, editor, EditorWidth
IniWrite, %EditorHeight%, %A_ScriptDir%\session.ini, editor, EditorHeight
Return

EditorHotkeySyntaxDummyLabel:
Return
