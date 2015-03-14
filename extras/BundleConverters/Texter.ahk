/*
[info]
Name=Texter to Lintalist format converter
Version=1.0
*/
; Done
/*
Texter vars, source: http://lifehacker.com/238306/lifehacker-code-texter-windows

Texter       -> Lintalist
%bundlebreak -> `n (new line)
%|           -> ^| (caret position)
%c           -> [[Clipboard]]
%ds          -> [[DateTime=ShortDate]] Short date, which will return the date in the following format: 3/9/2007.
%dl          -> [[DateTime=LongDate]] Long date, which returns the date in the following format: Friday, March 09, 2007.
%t           -> [[DateTime=Time]] Time, which returns the time as follows: 1:30 PM.

lines starting with ::SCR:: are scripts -> script

*/

SetBatchLines, -1
Text=Select a Texter bundle (Exported from Texter)
Mask=*.texter
#include %A_ScriptDir%\_GetSourceFile.ahk

; ------------------------------------------------------------

; transform Texter to Lintalist variables
StringReplace, list, list,`%|,^|, All ;(caret position)
StringReplace, list, list,`%c,[[Clipboard]], All
StringReplace, list, list,`%ds,[[DateTime=ShortDate]], All
StringReplace, list, list,`%dl,[[DateTime=LongDate]], All
StringReplace, list, list,`%t,[[DateTime=Time]], All

; ------------------------------------------------------------
loop, parse, list, `n, `r 
   {
If (A_Index = 1)
	Continue ; skip first line as it is the name of the Texter bundle
If (SubStr(A_Loopfield, 1, 1) = "¢")
		Break
If (Mod(A_Index, 2) = 0)
	{
	 Part1:=A_LoopField
	 Continue
	}
Else	
	Part2:=A_LoopField
   
If (SubStr(Part2, 1, 7) = "::scr::")
	{
	 Script:=SubStr(Part2, 8)
	 Part2=
	}

StringReplace, Part1, Part1,`%bundlebreak,`n,All
StringReplace, Part2, Part2,`%bundlebreak,`n,All
	
append=
(   
- LLPart1: %Part2%
  LLPart2: 
  LLKey:
  LLShorthand: %Part1%
  LLScript: %Script%
)
   Output .= Append "`n"
   part1=
   part2=
   script=
   }
; ------------------------------------------------------------

#include %A_ScriptDir%\_SaveBundleFile.ahk