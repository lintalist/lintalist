/* 
Plugin        : Selected [Standard Lintalist]
Purpose       : Cut currently selected text (if any) to clipboard and place it in the text at the desired location
Updated       : 20150215
Version       : 1.1

History:
- 1.1 Modified to accept parameters in Lintalist v1.4
- 1.0 first version

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

/*

comment: because it should now be able to process nested plugins better this plugin label
can be executed several times in a row and thus execute the "copy selected text" multiple
times as well. Therefore instead of using ^x to CUT the text to the clipboard ^c is used 
to COPY it instead - otherwise multiple CUT routines might be executed in succession which
could result in:
- empty selection being cut (selected text was already cut, so there would be nothing to cut again)
- "eating up" all text in the document (depending on editor), with each cut the "caret"
  is moved up a line so the next cycle would cut that line as well and so on...

*/

		 ClipSet("s",1,SendMethod) ; safe current content and clear clipboard
		 ClearClipboard()
		 SendKey(SendMethod, ShortcutCopy)
		 SelectedText:=Clipboard

		 If (PluginOptions <> "") 
			{
			 SelectedText:=ClipSelEx(SelectedText,PluginOptions)
			 StringReplace, clip, clip, %PluginText%, %SelectedText%, All
			}
		 else
		 	{
			 StringReplace, clip, clip, [[Selected]], %SelectedText%, All
		 	}
		 ClearClipboard()
		 Clipboard:=ClipSet("g",1,SendMethod) ; restore
		 
		 SelectedText:=""
		 ReplaceClipSelEx:=""
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""
		}
Return



GetSnippetClipboard:
	 If (InStr(Clip, "[[Clipboard") > 0) ; insert selected text if any
		{

		 SelectedText:=ClipSet("g",1,SendMethod) ; get clipboard back

		 If (PluginOptions <> "") 
			{
			 SelectedText:=ClipSelEx(SelectedText,PluginOptions)
			 StringReplace, clip, clip, %PluginText%, %SelectedText%, All
			}
		 else
		 	{
			 StringReplace, clip, clip, [[Selected]], %SelectedText%, All
		 	}
;		 ClearClipboard()
		 Clipboard:=clip
		 
		 SelectedText:=""
		 ReplaceClipSelEx:=""
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""
		}
Return
