/* 
Plugin        : FileList [Standard Lintalist]
Purpose       : Return a delimited list of files from one or more folders
Version       : 1.0

Both asterisks and question marks are supported as wildcards, 
if you want to use multiple wildcards you can do so using a ; like so:

folder\*.jpg;*.png

will return a list of all JPG and PNG files in a folder.

[[FileList=?OPTIONS|Folder1|Folder2|etc]]

(Options are optional)

Options:

D : Include directories (folders).
F : Include files. If both F and D are omitted, files are included but not folders.
R : Recurse into subdirectories (subfolders). If R is omitted, files and folders in subfolders are not included.

P : Use full file path, if omitted only the filenames are returned

Delimiter to use, default is a pipe (|) character, alternatively use:

SC: c comma
SN: n newline
ST: t tab

T : use path from active panel in Total Commander (assuming only one instance is active)
E : use path from current folder in Explorer (assuming only one instance is active)
W : current window title path (some programs show full path in Title, we can use this)

U : Uri paths use / not \
X : Relative paths, strip root folder path e.g. "?RXUP|c:\server\mywebsite\*.css" -> c:\server\mywebsite\css\style.css -> css/style.css

! : Assume FileList was called using [[Choice=!]] "filter as you type"

History:
- 1.0 first version
*/

GetSnippetFileList: 
Loop
	{
	 If (InStr(Clip, "[[FileList=") = 0) or (A_Index > 100)
	 Break

	 FileListDelimeter:="|"
	 FileListOptions:=""
	 FileListRelative:=""
	 FileListUri:=""
	 FileListFullPath:=0
	 if RegExMatch(PluginOptions,"^\s*[\?\!]")
		{
			 If InStr(PluginOptions,"!")
				{
				 FileListChoicePlugin:=1
				 PluginOptions:=StrReplace(PluginOptions,"!")
				}
			 FileListOptions:=LTrim(StrSplit(PluginOptions,"|").1," ?!`t")
			 PluginOptions:=StrReplace(PluginOptions,StrSplit(PluginOptions,"|").1 "|")
			 If InStr(FileListOptions,"P")
				{
				 FileListFullPath:=1
				 FileListOptions:=StrReplace(FileListOptions,"P")
				}
			 If InStr(FileListOptions,"SC")
				 FileListDelimeter:=","
			 else If InStr(FileListOptions,"SN")
				 FileListDelimeter:="`n"
			 else If InStr(FileListOptions,"ST")
				 FileListDelimeter:=A_Tab
			 FileListOptions:=RegExReplace(FileListOptions,"i)s[cnt]")
			 If InStr(FileListOptions,"W")
				{
				 PluginOptions:=FileListGetActiveWindowPath(ActiveWindowTitle) PluginOptions
				 FileListOptions:=StrReplace(FileListOptions,"W")
				}
			 If InStr(FileListOptions,"E")
				{
				 PluginOptions:=FileListGetExplorerPath() "\" PluginOptions
				 FileListOptions:=StrReplace(FileListOptions,"E")
				}
			 If InStr(FileListOptions,"T")
				{
				 PluginOptions:=FileListGetTCPath() PluginOptions
				 FileListOptions:=StrReplace(FileListOptions,"T")
				}
			 If InStr(FileListOptions,"X")
				{
				 FileListRelative:=1
				 FileListOptions:=StrReplace(FileListOptions,"X")
				}
			 If InStr(FileListOptions,"U")
				{
				 FileListUri:=1
				 FileListOptions:=StrReplace(FileListOptions,"U")
				}
			}
	 FileListOptions:=RegExReplace(FileListOptions,"imU)[^dfr]") ; remove all non-valid options for the Loop File pattern, just keep DFR
	 Loop, parse, PluginOptions, |
		{
		 PluginFileList .= FileListLoop(A_LoopField,FileListOptions,FileListFullPath,FileListDelimeter,FileListRelative,FileListUri)
		}

	 if !FileListChoicePlugin
		StringReplace, clip, clip, %PluginText%, %PluginFileList%, All
	 else if FileListChoicePlugin
		StringReplace, clip, clip, %PluginText%, [[Choice=!FileList|%PluginFileList%]], All

	 FileListChoicePlugin:=""
	 FileListOptions:=""
	 FileListRelative:=""
	 FileListUri:=""
	 FileListDelimeter:=""
	 FileListFullPath:=""
	 PluginFileList:=""
	 PluginOptions:=""
	 PluginText:=""
	 ProcessTextString:=""
	}
Return

FileListLoop(path,options,pathname,Delimiter,FileListRelative:=0,FileListUri:=0)
	{
	 SplitPath, path, OutFileName, OutDir, OutExtension, OutNameNoExt, OutDrive
	 if !OutFileName ; add wildcard
		path .= "\*.*"
	 if InStr(OutFileName,";")
		{
		 paths:=StrSplit(OutFileName,";")
		 path:=""
		 for k, v in paths
			path .= OutDir "\" v "|"
		}
	 path:=Trim(path,"|")
	 Loop, Parse, path, |
		 Loop, Files, %A_LoopField%, %Options%
			if pathname
				list .= A_LoopFileFullPath Delimiter
			else
				list .= A_LoopFileName Delimiter
	 if (trim(list,Delimiter) = "")
		list:="<FileList-ERROR-NoFiles>"
	 if FileListRelative
		list:=StrReplace(list,OutDir "\")
	 if FileListUri	
		list:=StrReplace(list,"\","/")
	 return list
	}

; perhaps COM for Word?
; or even memoryread https://autohotkey.com/board/topic/94981-get-file-path-opened-of-notepad/
FileListGetActiveWindowPath(title)
	{
	 if !Instr(title,":\")
		return "<FileList-ERROR-WinTitle-NoPathInTitle>"
	 RegExMatch(title,"(.\:\\.*\\)",path)
	 IfNotExist %path%
		return "<FileList-ERROR-WinTitle-PathNotFound>"
	 return path
	}

FileListGetExplorerPath()
	{
	 IfWinNotExist, ahk_exe explorer.exe ahk_class CabinetWClass
	 	return "<FileList-ERROR-Explorer-NotFound>"
	 for w in ComObjCreate("Shell.Application").Windows
		return w.Document.Folder.Self.Path
	}

FileListGetTCPath()
	{
	 IfWinNotExist, ahk_class TTOTAL_CMD
	 	return "<FileList-ERROR-TotalCommander-NotFound>"
	 ClearClipBoard()
	 PostMessage 1075, 2029, 0, , ahk_class TTOTAL_CMD ; 2029 Copy source path to clipboard cm_CopySrcPathToClip
	 Sleep 100
	 if (clipboard = "")
		return "<FileList-ERROR-TotalCommander>"
	 return clipboard "\"
	}

