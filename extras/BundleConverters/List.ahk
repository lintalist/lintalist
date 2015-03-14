/*
[info]
Name=Plain text list to Lintalist format converter
Version=1.0
*/
; Done

SetBatchLines, -1
Text=Select a plain text file list (one line per snippet)
Mask=*.txt
#include %A_ScriptDir%\_GetSourceFile.ahk

; ------------------------------------------------------------
loop, parse, list, `n, `r 
   {
If (A_LoopField = "") ; skip empty lines
   Continue
   append=
(   
- LLPart1: %A_LoopField%
  LLPart2:
  LLKey:
  LLShorthand:
  LLScript:
)
   Output .= Append "`n"
   }
; ------------------------------------------------------------

#include %A_ScriptDir%\_SaveBundleFile.ahk