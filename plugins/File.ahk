/* 
Plugin        : File [Standard Lintalist]
Purpose       : Insert the contents of a file
Version       : 1.1

History:
- 1.1 as of Lintalist v1.6 it now also uses FixURI, and the options select and clean have been added
- 1.0 first version

*/

GetSnippetFile:
 	 Loop ; get Text from File
		{
		 If (InStr(Clip, "[[File=") = 0) or (A_Index > 100)
			Break
		 If !InStr(PluginOptions,"|")
		 	{
			 PluginOptions:=FixURI(PluginOptions,"txt",A_ScriptDir)
			 FileRead, PluginSnippetFile, %PluginOptions%
		 	}
		 Else ; we have options, process select first if present
			{
			 If (StrSplit(PluginOptions,"|").2 = "select") or (StrSplit(PluginOptions,"|").3 = "select")
				{
				 PluginSelectedDir:=FixURI(StrSplit(PluginOptions,"|").1,"txt",A_ScriptDir)
				 FileSelectFile, PluginSelectedFile, 3 , %PluginSelectedDir%, Select your file to use, *.txt
				 If (ErrorLevel = 0) ; a file has been selected
					FileRead, PluginSnippetFile, %PluginSelectedFile%
				}
			 If (StrSplit(PluginOptions,"|").2 = "clean") or (StrSplit(PluginOptions,"|").3 = "clean")
				{
				 PluginOptions:=FixURI(PluginOptions,"txt",A_ScriptDir)
				 FileRead, PluginSnippetFile, %PluginOptions%
				 StringReplace, PluginSnippetFile, PluginSnippetFile, [, %A_Space%, All
				 StringReplace, PluginSnippetFile, PluginSnippetFile, ], %A_Space%, All
				 StringReplace, PluginSnippetFile, PluginSnippetFile, |, %A_Space%, All
				}
			} 

		 StringReplace, clip, clip, %PluginText%, %PluginSnippetFile%, All

		 PluginSelectedDir:=""
		 PluginSnippetFile:=""
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""

		}
Return