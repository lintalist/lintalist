/* 
Plugin        : Selected [Standard Lintalist]
Purpose       : Cut currently selected text (if any) to clipboard and place it in the text at the desired location
Version       : 1.0
*/

GetSnippetSelected:
	 If (InStr(Clip, "[[Selected]]") > 0) ; insert selected text if any
		{
		 ClipSet("s",1,SendMethod) ; safe current content and clear clipboard
		 ClearClipboard()
		 SendKey(SendMethod, "^x")
		 StringReplace, clip, clip, [[Selected]], %clipboard%, All
		 ClearClipboard()
		 Clipboard:=ClipSet("g",1,SendMethod) ; restore
		}
Return
