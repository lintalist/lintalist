/* 
Plugin        : Split [Standard Lintalist]
Purpose       : Split input into variables
Version       : 1.2

History:
- 1.2 Fix https://github.com/lintalist/lintalist/issues/116
- 1.1 Adding named split - Lintalist v1.7
- 1.0 first version
*/

GetSnippetSplit:
	 Loop 
		{
		 ;If (InStr(Clip, "[[Split=") = 0) or (A_Index > 100) or (InStr(Clip, "[[Split_") = 0)
		;	Break
		 named:=Trim(StrSplit(StrSplit(PluginText,"=").1,"_").2,"[]")
		 if (named <> "")
		 	named:="_" named
;		 MsgBox % clip ":" named
		 sp:={}
		 StringReplace, clip, clip, %PluginText%`n, , All
		 StringReplace, clip, clip, %PluginText%, , All
		 spwhat:=StrSplit(PluginOptions,"|").1
		 If (spwhat = "clipboard")
			spwhat:=ClipSet("g",1,SendMethod) ; restore
		 else If (spwhat = "selected")
			{
			 ClipSet("s",1,SendMethod,Clipboard) ; safe current content and clear clipboard
			 ClearClipboard()
			 SendKey(SendMethod, ShortcutCopy)
			 spwhat:=clipboard
			 ClearClipboard()
			 Clipboard:=ClipSet("g",1,SendMethod) ; restore
			}
		 If CountString(PluginOptions,"|") > 1 ; multi
			{
			 sprow:=SplitDelimiter(StrSplit(PluginOptions,"|").2)
			 spcol:=SplitDelimiter(StrSplit(PluginOptions,"|").3)
			 ;msgbox % sprow ":" spcol ":" StrSplit(PluginOptions,"|").1
			 Loop, parse, % spwhat, % sprow
				sp.insert(StrSplit(A_LoopField,spcol,"`r"))
			 for k, v in sp
				{
				 row:=k
				 for column,cell in v ; msgbox % row "," a_index
				 	{
					 StringReplace, clip, clip, % "[[sp" named "=" row "," A_Index "]]", % cell, All
					} 
				}
			}
		 else ; single
			{
			 sp:=StrSplit(spwhat,SplitDelimiter(StrSplit(PluginOptions,"|").2),"`r")
			 for k, v in sp
				StringReplace, clip, clip, [[sp%named%=%k%]], %v%, All
			;msgbox % clip	
			}
		 clip:=RegExReplace(clip,"iU)\[\[sp" named "=.*\]\]") ; remove any stray named [[sp=]]
		 ;If (InStr(Clip, "[[Split=") = 0)
		 ;	clip:=RegExReplace(clip,"iU)\[\[sp=.*\]\]") ; remove any stray [[sp=?]]

		 sp:=""
		 row:=""
		 sprow:=""
		 spcol:=""
		 spwhat:=""
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""
		 if (named = "")
			named:="="
		 If (InStr(Clip, "[[Split" named) = 0) or (A_Index > 100)
				Break

		}
	 named:=""
Return



SplitDelimiter(delim)
	{
	 If (delim = "\n")
		delim:="`n"
	 else If (delim = "\p")
		delim:="|"
	 else If (delim = "\t")
		delim:=A_Tab
	 else If (delim = "\s")
		delim:=A_Space
	 else If (delim = " ")
		delim:=" "
	 else
	 	delim:=delim
	 Return delim 
	}
	
