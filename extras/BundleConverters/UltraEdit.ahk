/*
[info]
Name=UltraEdit Taglist to Lintalist format converter
Version=1.0
*/
; Bundle convertor for UltraEdit Taglists
; http://www.ultraedit.com/downloads/extras.html
; Note there are two formats for the Taglists - it works with both

SetBatchLines, -1
Text=Select an UltraEdit Taglist
Mask=*.txt
#include %A_ScriptDir%\_GetSourceFile.ahk

; ------------------------------------------------------------

Loop
	{ 
	 Key:=A_Index - 1
	 IniRead, Add, %file%, Group List, %Key%
	 If (Add = "") or (Add = "ERROR")
		Break
	 Group .= Add Chr(7)
	 Add=
	}
Gui, add, listview , w400 h200 Checked, Group
Loop, parse, Group, % Chr(7)
	{
	 If (A_LoopField <> "")
		LV_Add("", A_Loopfield)
	} 
LV_ModifyCol(1, "Sort")	 
Gui, add, button, , submit	
Gui, show, w510 h250, Select TagList groups to convert/include
Return

ButtonSubmit:
TheseGroups=
RowNumber = 0  ; This causes the first loop iteration to start the search at the top of the list.
Loop
	{
     RowNumber := LV_GetNext(RowNumber, "Checked")  ; Resume the search at the row after that found by the previous iteration.
     if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
	 LV_GetText(Text, RowNumber) 
     TheseGroups .= Text Chr(7)
	}

StringTrimRight, TheseGroups, TheseGroups, 1

Loop, Parse, TheseGroups, % Chr(7)
	{
	 Section:="Tag Group - " . A_loopField
	 Loop
		{
		 Key:=A_Index - 1
		 IniRead, Add, %file%, %Section% , %Key%
		 If (Add = "") or (Add = "ERROR")
			Break
		 GetText .= Add Chr(7)
		 Add=
		} 
	}
	
If (InStr(GetText, ":UEDS:") > 0) ; "newer" UE TagList format
	{
	 Loop, Parse, GetText, % Chr(7)
		{
		 If (A_LoopField <> "")
			{
			 StringReplace, Tag, A_LoopField, :UEDS:, % Chr(7), All
			 StringSplit, Tag, Tag, % Chr(7)
			 append=
(   
- LLPart1: %Tag2%
  LLPart2: %Tag1%
  LLKey:
  LLShorthand: 
  LLScript: 
  
)
		     Output .= Append "`n"
		     Tag1=
		     Tag2=
			}
		 NewText .= append
		 append=
		}
	}	
Else ; "older" UE TagList format
	{
	 Loop, Parse, GetText, % Chr(7)
		{
		 If (A_LoopField <> "")
			{
			 append=
(	 
- LLPart1: %A_LoopField%
  LLPart2: 
  LLKey:
  LLShorthand: 
  LLScript: 
  
)
			NewText .= append
			append=
			}
		}
	}
	
StringReplace, NewText, NewText, ^p, `n, All ; replace new line chars if any
StringReplace, NewText, NewText, ^t, %A_Tab%, All ; replace tab chars if any
StringReplace, NewText, NewText, %A_Space%...%A_Space%, [[clipboard]], all
StringReplace, NewText, NewText, ..., [[clipboard]], all

Output:=NewText

; ------------------------------------------------------------
#include %A_ScriptDir%\_SaveBundleFile.ahk

Gosub, GuiClose
Return

Esc::
GuiClose:
ExitApp