/* 
Plugin        : PasteMethod [Standard Lintalist]
Purpose       : Same as global setting but per snippet setting - Retain current clipboard or set it as current clipboard content

PasteMethod=0
PasteMethod Default: 0

PasteMethod=0 Paste snippet and retain current clipboard content (=default behaviour)
PasteMethod=1 Paste snippet and keep it as the current clipboard content (so you can manually paste it again)
PasteMethod=2 Don't paste snippet content but copy it to the clipboard so you can manually paste it.

Note: overrides global setting

History:
- 1.0 first version

*/

GetSnippetPasteMethod:
	Loop ; get counters
		{
		 If (InStr(Clip, "[[PasteMethod=") = 0) or (A_Index > 100)
			Break

		 SnippetPasteMethod:=PluginOptions
		 StringReplace, clip, clip, %PluginText%, , All

		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""

		}
Return
