/* 
Plugin        : Comment [Standard Lintalist]
Purpose       : Add a comment to snippet which will be removed before pasting. Use as a visual reminder (snippet preview) or search aid.
Version       : 1.0

History:
- 1.0 first version
*/

GetSnippetComment:
	 StringReplace, clip, clip, %ProcessTextString%, , All
	 PluginSnippetString:=""
	 PluginText:=""
	 PluginOptions:=""
	 ProcessTextString:=""
Return
