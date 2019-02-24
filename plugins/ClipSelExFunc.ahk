/*
Plugin func   : Used in Selected & Clipboard plugins
Purpose       : Process text for upper, lower, title, sentence and wrap options
Credit        : Sentence case by Laszlo & None
Updated       : 20181130
Version       : 1.1

History:
- 1.1 Now using TitleCase() - https://github.com/lintalist/lintalist/issues/113#issuecomment-437522435
      and https://github.com/lintalist/TitleCase
- 1.0 first version added to Lintalist v1.4

*/

ClipSelEx(SelectedText,Options)
	{
	 If Options in upper,u
		{
		 StringUpper, SelectedText, SelectedText
		}
	 Else If Options in lower,l
		{
		 StringLower, SelectedText, SelectedText
		}
	 Else If RegExMatch(Options,"i)^\s*t")
		{
		 StringSplit, Options, Options, |
		 ; Options1 will be t or title
		 If (Options2 = "")
			Options2:="en"
		 If (Options3 = "")
			Options3:="TitleCase.ini"
		 SelectedText:=TitleCase(SelectedText,Options2,Options3)
		}
	 Else If Options in sentence,s
		{
		 /*
			Sentence case by Laszlo & None
			http://www.autohotkey.com/board/topic/51153-sentence-case/?p=320221
			http://www.autohotkey.com/board/topic/63122-change-the-case-of-a-string-five-options/
			TODO? take in to account , at end of line or no . at and of line
			currently first word on next line is upper case - also let X be defined by user?
		 */
		 X = I,AHK,AutoHotkey
		 SelectedText := RegExReplace(RegExReplace(SelectedText, "(.*)", "$L{1}"), "(?<=[\.\!\?]\s|\n).|^.", "$U{0}")
		 Loop Parse, X, CSV
			SelectedText := RegExReplace(SelectedText,"i)\b" A_LoopField "\b", A_LoopField)
		}
	 Else If (InStr(Options,"wrap|") or InStr(Options,"w|"))
		{
		 StringSplit, Options, Options, |
		 If InStr(SelectedText,"`n")
			{
			 loop, parse, SelectedText, `n, `r
				ReplaceClipSelEx .= Options2 A_LoopField Options3 "`n"
			}
		 else
			ReplaceClipSelEx := Options2 SelectedText Options3 "`n"
		 ReplaceClipSelEx:=Trim(ReplaceClipSelEx,"`n")	
		 SelectedText:=ReplaceClipSelEx
		}
	 Return SelectedText
	}

#include %A_ScriptDir%\include\TitleCase.ahk