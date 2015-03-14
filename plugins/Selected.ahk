/* 
Plugin        : Selected [Standard Lintalist]
Purpose       : Cut currently selected text (if any) to clipboard and place it in the text at the desired location
Version       : 1.4
Updated       : 20150215

Syntax (also for clipboard):
	[[Selected=UPPER-U]]
	[[Selected=lower-L]]
	[[Selected=title-T]]
	[[Selected=sentence-S]]
	[[Selected=Wrap-w|before|after]]

*/

GetSnippetSelected:
	 If (InStr(Clip, "[[Selected") > 0) ; insert selected text if any
		{
		 RegExMatch(Clip, "iU)\[\[Selected(.*)\]\]", ClipQ, 1)
		 ClipSet("s",1,SendMethod) ; safe current content and clear clipboard
		 ClearClipboard()
		 SendKey(SendMethod, "^x")
		 SelectedText:=Clipboard
		 StringReplace, ClipQ1, ClipQ1, =,, All ; trim any = chars
		 OrgClipQ1:=ClipQ1
		 StringLower, ClipQ1, ClipQ1
		 If (ClipQ1 <> "") 
			{
			 SelectedText:=ClipSelEx(SelectedText,ClipQ1)
			 StringReplace, clip, clip, [[Selected=%OrgClipQ1%]], %SelectedText%, All
			}
		 else
			StringReplace, clip, clip, [[Selected]], %SelectedText%, All
		 ClearClipboard()
		 Clipboard:=ClipSet("g",1,SendMethod) ; restore
		 OrgClipQ1=, ClipQ1=, ClipQ11=, ClipQ12=, ClipQ2=
		 SelectedText=
		 ReplaceClipSelEx=
		}
Return
