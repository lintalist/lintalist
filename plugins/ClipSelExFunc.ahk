/*
Plugin func   : Used in Selected & Clipboard plugins
Purpose       : Process text for upper, lower, title, sentence and wrap options
Version       : 1.4
Credit        : Sentence case by Laszlo & None
Updated       : 20150215
*/

ClipSelEx(SelectedText,ClipQ1)
	{
	 If ClipQ1 in upper,u
		{
		 StringUpper, SelectedText, SelectedText
		}
	 Else If ClipQ1 in lower,l
		{
		 StringLower, SelectedText, SelectedText
		}
	 Else If ClipQ1 in title,t
		{
		 StringUpper, SelectedText, SelectedText, T
		}
	 Else If ClipQ1 in sentence,s
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
	 Else If (InStr(ClipQ1,"wrap|") or InStr(ClipQ1,"w|"))
		{
		 StringSplit, ClipQ1, ClipQ1, |
		 If InStr(SelectedText,"`n")
			{
			 loop, parse, SelectedText, `n, `r
				ReplaceClipSelEx .= ClipQ12 A_LoopField ClipQ13 "`n"
			}
		 else
			ReplaceClipSelEx := ClipQ12 SelectedText ClipQ13 "`n"
		 ReplaceClipSelEx:=Trim(ReplaceClipSelEx,"`n")	
		 SelectedText:=ReplaceClipSelEx
		} 
	 Return SelectedText
	}

ProcessClipboard(Snippet)
	{
	 RegExMatch(Snippet, "iU)\[\[Clipboard(.*)\]\]", ClipQ, 1)
	 Text:=Clipboard
	 StringReplace, ClipQ1, ClipQ1, =,, All ; trim any = chars
	 OrgClipQ1:=ClipQ1
	 StringLower, ClipQ1, ClipQ1
	 Text:=ClipSelEx(Text,ClipQ1)
	 If (ClipQ1 <> "")
		StringReplace, Snippet, Snippet, [[Clipboard=%OrgClipQ1%]], %Text%, All
	 Return Snippet
	}
