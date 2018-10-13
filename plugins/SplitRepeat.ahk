/* 
Plugin        : SplitRepeat [Standard Lintalist]
Purpose       : Split input into variables and repeat snippet
Version       : 1.1

History:
- 1.1 Adding named split - Lintalist v1.7
- 1.0 first version
*/

GetSnippetSplitRepeat:
 	 Loop 
		{
;		 If (InStr(Clip, "[[SplitRepeat=") = 0) or (A_Index > 100)
;			Break
		 named:=Trim(StrSplit(StrSplit(PluginText,"=").1,"_").2,"[]")
		 if (named <> "")
			named:="_" named

		 sp:={}
		 spsingle:=""
		 StringReplace, clip, clip, %PluginText%`n, , All
		 StringReplace, clip, clip, %PluginText%, , All
		 spwhat:=StrSplit(PluginOptions,"|").1
		 If (spwhat = "clipboard")
			spwhat:=ClipSet("g",1,SendMethod) ; restore
		 else If (spwhat = "selected")
			{
			 ClipSet("s",1,SendMethod) ; safe current content and clear clipboard
			 ClearClipboard()
			 SendKey(SendMethod, "^c")
			 spwhat:=clipboard
			 ClearClipboard()
			 Clipboard:=ClipSet("g",1,SendMethod) ; restore
			}
		 If CountString(PluginOptions,"|") > 2 ; multi
			{
			 sprepeat:=SplitDelimiter(StrSplit(PluginOptions,"|").2)
			 sprow:=SplitDelimiter(StrSplit(PluginOptions,"|").3)
			 spcol:=SplitDelimiter(StrSplit(PluginOptions,"|").4)
			 Loop, parse, % spwhat, % sprepeat
				{
				 sp:={}
				 spRowText:=clip
				 Loop, parse, % A_LoopField, % sprow
					sp.insert(StrSplit(A_LoopField,spcol,"`r"))
				 for k, v in sp
					{
					 row:=k
					 for column,cell in v ; msgbox % row "," a_index
						{
						 StringReplace, spRowText, spRowText, % "[[sp" named "=" row "," A_Index "]]", % cell, All
						}
					}
				 spRowOutput .= spRowText
				} 
			}
		 else ; single
			{
			 sprepeat:=SplitDelimiter(StrSplit(PluginOptions,"|").2)	
			 Loop, parse, % spwhat, % sprepeat
				{
				 sp:=StrSplit(A_LoopField,SplitDelimiter(StrSplit(PluginOptions,"|").2),"`r")
				 spRowText:=clip
				 for k, v in sp
					{
					 StringReplace, spRowText, spRowText, [[sp%named%=%k%]], %v%, All
					}
				 spRowOutput .= spRowText
				}
			}	
		 clip:=RTrim(spRowOutput,"`n")
		 spRowOutput:=""
		 clip:=RegExReplace(clip,"iU)\[\[sp" named "=.*\]\]") ; remove any stray [[sp=?]]
		 spsingle:=""
		 sp:=""
		 row:=""
		 sprow:=""
		 spcol:=""
		 spwhat:=""
		 sprepeat:=""
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""
		 if (named = "")
			named:="="
		 If (InStr(Clip, "[[SplitRepeat" named) = 0) or (A_Index > 100)
			Break

		}
	 named:=""
Return

