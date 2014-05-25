; LintaList [standalone script]
; Purpose: Local variable Editor [see Lintalist doc]
; Version: 1.0.3
; Date:    20140426

#NoTrayIcon

OnExit, 20GuiClose 
EditorTitle=Lintalist local bundle editor
Save=0
LoadPersonalBundle()
StringSplit, var, LocalVariables, |
content:=% LocalVar_%var1%
Previous:=var1
Gui, 20: +Toolwindow
Gui, 20: Add, Text, x10  y10 , Local variable (select to edit)
Gui, 20: Add, Text, x240 y10 , Content

Gui, 20: Add, ListBox, h300 w220 x10  y30 gCheck vVar, %LocalVariables%
Gui, 20: Add, Edit,    h292 w450 x240 y30 vContent, %content%
Gui, 20: Add, Button,  x10  w65  h25 g20Scan, Scan
Gui, 20: Add, Button,  xp+78 w65 h25 g20New, New
Gui, 20: Add, Button,  xp+78 w65 h25 g20Del, Del
Gui, 20: Add, Button,  xp+74 w220 h25 g20Save, Save
Gui, 20: Add, Button,  xp+230 yp w220 h25 g20GuiClose, Cancel
Gui, 20: Show, autosize center, %EditorTitle%
ControlSend, Listbox1, {Down}, %EditorTitle%
Save=0
Return

#IfWinActive, Lintalist local bundle editor
Down::
ControlGetFocus, IsListBox, %EditorTitle%
	If (IsListBox = "ListBox1")
		 ControlSend, Listbox1, {Down}, %EditorTitle%
	Else
		Send {Down}
Return

Up::
ControlGetFocus, IsListBox, %EditorTitle%
	If (IsListBox = "ListBox1")
		 ControlSend, Listbox1, {Up}, %EditorTitle%
	Else
		Send {Up}
Return
#IfWinActive


Check: 
		 Gui, 20:submit, nohide
		 OldContent:=% LocalVar_%previous%
		 If (OldContent <> Content)
		    {
			 LocalVar_%previous%:=Content
			 Save=1
			} 
		 Content:=% LocalVar_%var%	
		 Previous:=var
		 GuiControl,20:,Edit1, %content%
Return

20Del:
tmpLocalVariables=
Gui, 20:submit, nohide
MsgBox, 4, Delete, Do you want to delete %var%?
IfMsgbox, Yes
	{
	 LocalVar_%var%:=
	 Loop, parse, LocalVariables, |
		{
		 If (A_LoopField = var)
			{
			 var%A_Index%=
			 Continue
			} 
		 tmpLocalVariables .= A_LoopField "|"
		}
	 LocalVariables:=tmpLocalVariables
	 StringReplace, LocalVariables, LocalVariables, ||, |, All
	 tmpLocalVariables=
	 GuiControl,20:,Listbox1, |%LocalVariables%
	 Controlfocus,Listbox1,%EditorTitle%
	 Gosub, Check
	} 
Return

20New:
InputBox, OutputVar, %EditorTitle%, New variable name:, , 400, 150
If (ErrorLevel = 1)
	Return
MsgBox % outputvar	
If (InStr("|" . LocalVariables . "|" , "|" OutputVar "|") > 0)
	{
	 MsgBox, 48, Duplicate variable, There is already a local variable with that name, enter a new name.
	 Goto, 20New
	}
GuiControl,20:,Listbox1, %OutputVar%|
LocalVariables .= OutputVar "|"
VarCount:=Var0++
Var%VarCount%:=OutputVar
Save=1
Return

20Save:
		 Gui, 20:submit, nohide
		 OldContent:=% LocalVar_%previous%
		 If (OldContent <> Content)
		    {
			 LocalVar_%previous%:=Content
			 Save=1
			} 
		 Content:=% LocalVar_%var%	
		 Previous:=var
If (Save = 0)
	ExitApp
Bundle=
(	
BundleVersion: 1
Name: Local bundle
Description: Local and private variables for re-use in other Bundles
Patterns:
)
Loop, parse, LocalVariables, |
	{
If (A_LoopField = "")
	Continue
p1:=LocalVar_ . A_LoopField
p2:=% LocalVar_%A_LoopField%
Append=
(
- LLVarName: %p1%
  LLContent: %p2%
)	
	Bundle .= "`n" Append
	Append=
	p1=
	p2=
	}
FileMove, %A_ScriptDir%\..\local\local.txt, %A_ScriptDir%\..\local\local.txt.bak, 1
FileAppend, %bundle%, %A_ScriptDir%\..\local\local.txt
Save=0
ExitApp
Return

Esc::
20GuiEscape:
20GuiClose:
If (Save = 1)
	{
	 MsgBox, 4, Save?, Do you want to save your changes?
	 IfMsgBox, Yes
		Gosub, 20Save
	 Else
	    {
	     Save=0
		 ExitApp
		} 
	}	
Else 
	ExitApp	
Return

20Scan:
Progress, b1 w300 CWFFFFFF CB000080, , Scanning for local variables, Scanning
Progress, 5 ; Set the position of the bar to 5%.
BundleFiles=
NewScannedVars=
ScannedVarList=
Loop, %A_ScriptDir%\..\bundles\*.txt
	{
	 Counter:=A_Index
	 BundleFiles .= A_LoopFileLongPath . ","
	}
StringTrimRight, BundleFiles, BundleFiles, 1 ; trim trailing
Progress, 10
Loop, parse, BundleFiles, CSV
	{
	 File=
	 PBar:=Floor((a_index/counter)*90)
	 Progress, %PBar%
	 FileRead, File, %A_LoopField%
	 StringReplace, File, File, [[, `n[[, All
	 StringReplace, File, File, ]], ]]`n, All
	 Loop, parse, file, `n, `r
		{
		 IfInString, A_LoopField, [[Var=
			ScannedVarList .= A_LoopField "`n"
		}
	}
StringReplace, ScannedVarList, ScannedVarList, [[Var=,,all
StringReplace, ScannedVarList, ScannedVarList, ]],,all
Sort, ScannedVarList, U
Loop, parse, ScannedVarList, `n, `r%A_Space%%A_Tab%
	{
	 If (InStr("|" . LocalVariables . "|", "|" . A_LoopField . "|") > 0)
		Continue
	 NewScannedVars .= 	A_LoopField . "`n"
	}
StringTrimRight, NewScannedVars, NewScannedVars, 1	
Progress, 100
Progress, Off
If (NewScannedVars = "")
	{
	 MsgBox, 48, Nothing found, No new local variables where found in your bundles
	 Return
	}
MsgBox,4,Found new local variables, % "Do you want to add these new variables to your local bundle?`n`n"NewScannedVars
IfMsgBox, Yes
	{
	 Stringreplace, NewScannedVars, NewScannedVars, `n, |, all
	 LocalVariables .= "|" NewScannedVars "|"
	 ;MsgBox % LocalVariables
	 StringSplit, var, LocalVariables, |
	 GuiControl,20:,Listbox1, |
	 GuiControl,20:,Listbox1, %LocalVariables%
	 Save=1
	}
Return

LoadPersonalBundle()
	{
	 Global
	 FileRead, CBundle, %A_ScriptDir%\..\local\local.txt
	 Patterns:=RegExReplace(SubStr(CBundle, InStr(CBundle, "Patterns:") + 10),"m)\s*-\s*LLVarName:\s*", Chr(5))   ; prepare split per pattern
	 Patterns:=Ltrim(patterns,"`r`n")
	 Patterns:=RegExReplace(Patterns,"m)\s*LLContent:\s*", Chr(7)) ; prepare split per pattern
	 StringTrimLeft, Patterns, Patterns, 1 ; remove first empty 
	 StringSplit, __loc, Patterns, % Chr(5) 
	 Loop, % __loc0
		{
		 StringSplit, __pers, __loc%A_Index%, % Chr(7) 
			 LocalVariables .= __pers1 "|" 
		 LocalVar_%__pers1% := __pers2
		 __pers1= ; free mem
		 __pers2=
		 __loc%A_Index%=
		}
	 Patterns= ; free mem
	 Sort, LocalVariables, D|
	 Return	
	}
