; LintaList [standalone script]
; Purpose: Update script for Lintalist
; Version: 1.3
; Date:    20150125

; ChangeButtonNames
; http://ahkscript.org/docs/scripts/MsgBoxButtonNames.htm	  

; CopyFilesAndFolders (AHK Docs)
; http://ahkscript.org/docs/commands/FileCopy.htm

; AutoHotkey wrapper for Windows native Zip feature by Coco
; http://ahkscript.org/boards/viewtopic.php?f=6&t=3892
; https://github.com/cocobelgica/AutoHotkey-ZipFile

; VersionCompare by boiler 
; http://ahkscript.org/boards/viewtopic.php?f=6&t=5959


DetectHiddenWindows, On
SetTitleMatchMode, 2

TrayTip, Checking ..., Checking for updates

SplitPath, A_ScriptDir, , LintalistFolder
UnpackFolder:=LintalistFolder "\tmpscrpts"

FileDelete, %UnpackFolder%\checkupdate.ini

URLDownloadToFile, https://raw.githubusercontent.com/lintalist/master/version.ini, %UnpackFolder%\checkupdate.ini

IniRead, currentversion, %LintalistFolder%\version.ini, settings, version
If (currentversion = "ERROR")
	{
	 MsgBox, 16, Error, Can't read %LintalistFolder%\version.ini file
	 ExitApp
	}
IniRead, checkversion, %UnpackFolder%\checkupdate.ini, settings, version
IniRead, checkauto   , %UnpackFolder%\checkupdate.ini, settings, auto
If (checkversion = "ERROR") or (checkauto = "ERROR")
	{
	 MsgBox, 16, Error, Can't read %UnpackFolder%\checkupdate.ini file
	 ExitApp
	}

If VersionCompare(currentversion, checkversion) < 2
	{
	 MsgBox, 64, No update, No update available...
	 ExitApp
	}

If (checkauto = 0)
	{
	 MsgBox, 16, Error, Automatic update not possible, read the release notes first.
	 Run, https://github.com/lintalist/lintalist/releases
	 ExitApp
	}

SetTimer, ChangeButtonNames, 10
MsgBox, 4150, Update, There is a Lintalist update.`nNew version: v%checkversion%`nDo you wish to download and install update?
IfMsgBox, TryAgain
	{
	 Run, https://github.com/lintalist/lintalist/releases
	 ExitApp
	}
Else IfMsgBox, Continue
	ExitApp

UrlDownloadToFile, https://github.com/lintalist/lintalist/archive/master.zip, %UnpackFolder%\update.zip
If (ErrorLevel = 1 )
	{
	 MsgBox, 16, Error, Downloading the update failed
	 ExitApp
	}

FileRemoveDir, %UnpackFolder%\lintalist-master, 1

BackupZip:=UnpackFolder "\Backup-" A_Now ".zip"
backup := new ZipFile(BackupZip)
backup.pack(LintalistFolder "\*.*")

zip := new ZipFile(UnpackFolder "\update.zip")
zip.unpack(, UnpackFolder)

WinClose, %LintalistFolder%\lintalist.ahk
Sleep, 1000 

; From the AHK docs:
; The following copies all files and folders inside a folder to a different folder:
ErrorCount := CopyFilesAndFolders( UnpackFolder "\lintalist-master\*.*", LintalistFolder, true)
if ErrorCount <> 0
    MsgBox %ErrorCount% files/folders could not be copied.

WinClose, %LintalistFolder%\lintalist.ahk
Sleep, 1000 

FileRemoveDir, %UnpackFolder%\lintalist-master, 1

Run, %LintalistFolder%\lintalist.ahk

MsgBox, 64, Updated, Lintalist has been updated.`nA backup is made and can be found in:`n%BackupZip%

ExitApp

; ---------------------------------------------------------------------------

VersionCompare(version1, version2)
	{
	 StringSplit, verA, version1, .
	 StringSplit, verB, version2, .
	 Loop, % (verA0> verB0 ? verA0 : verB0)
		{
		 if (verA0 < A_Index)
			verA%A_Index% := "0"
		 if (verB0 < A_Index)
			verB%A_Index% := "0"
		 if (verA%A_Index% > verB%A_Index%)
			return 1
		 if (verB%A_Index% > verA%A_Index%)
			return 2
		}
	 return 0
	}

; AutoHotkey wrapper for Windows native Zip feature
; https://github.com/cocobelgica/AutoHotkey-ZipFile

/* ZipFile
 *     Wrapper for Windows shell ZIP function
 * AHK Version: Requires v1.1+ OR v2.0-a049+
 * License: WTFPL (http://www.wtfpl.net/)
 * Usage:
 *     See each method's inline documentation for usage
 * Remarks:
 *     Caller can insantiate the class vie the 'new' operator OR call the
 *     ZipFile() function(function definition is below the class definition)
 */
class ZipFile
{
	/* Function: __New
	 * Instantiates an object that represents a zip archive. 
	 * Syntax:
	 *     zip := new ZipFile( file )
	 * Parameter(s):
	 *     file    [in] - The zip archive . If 'file' does not exist, an empty
	 *                    zip archive is created.
	 */
	__New(file) {
		static set := Func( A_AhkVersion < "2" ? "ObjInsert" : "ObjRawSet" )
		
		%set%(this, "_", {}) ;// dummy object, bypass __Set
		fso := ComObjCreate("Scripting.FileSystemObject")
		this._.__path := file := fso.GetAbsolutePathName(file)
		;// create empty zip file if it doesn't exist
		if !FileExist(file) {
			header1 := "PK" . Chr(5) . Chr(6)
			, VarSetCapacity(header2, 18, 0)
			, archive := FileOpen(file, "w")
			, archive.Write(header1)
			, archive.RawWrite(header2, 18)
			, archive.Close()
		}
	}
	/* Function: pack
	 * Adds the specified file(s) to the archive
	 * Syntax:
	 *     zip.pack([ fspec, del ])
	 * Parameter(s):
	 *     fpsec   [in] - The file(s) to zip, accepts wildcards. If omitted,
	 *                    all the file(s) in the current directory will be
	 *                    included.
	 *     del     [in] - If true, the file(s) will be deleted after zipping.
	 */
	pack(fspec:="*.*", del:=false) {
		fso := ComObjCreate("Scripting.FileSystemObject")
		, psh := ComObjCreate("Shell.Application")
		, fspec := fso.GetAbsolutePathName(fspec)
		, dest := psh.NameSpace(this._.__path)
		, items := psh.NameSpace(fso.GetParentFolderName(fspec)).Items()
		;// .Filter(): http://goo.gl/HsUW5W
		, items.Filter(0x00020|0x00040|0x00080 ;// http://goo.gl/A2nfTt
		             , fso.GetFileName(fspec))

		if (tmp := dest.Items().Count) {
			tmp := fso.CreateFolder(A_Temp . "\" . fso.GetTempName())
			, _dest := dest
			, dest := psh.NameSpace(tmp.Path) ;// .Path -> http://goo.gl/aHMt2J
		}
		count := items.Count
		dest[del ? "MoveHere" : "CopyHere"](items, 4|16)
		while (dest.Items().Count != count)
			Sleep 15
		if tmp {
			_dest.MoveHere(dest.Items(), 4|16)
			while (dest.Items().Count != 0)
				Sleep 15
			tmp.Delete(true) ;// http://goo.gl/b5p7DT
		}
	}
	/* Function: unpack
	 * Extracts file(s) to the current or specified directory.
	 * Syntax:
	 *     zip.unpack([ fspec, dest ])
	 * Parameter(s):
	 *     fpsec   [in] - The file(s) to extract, accepts wildcards. If
	 *                    omitted, all the files in the archive will be
	 *                    extracted.
	 *     dest    [in] - The directory to extract to. A_WorkingDir if omitted.
	 */
	unpack(fspec:="*.*", dest:="") {
		fso := ComObjCreate("Scripting.FileSystemObject")
		, psh := ComObjCreate("Shell.Application")
		, dest := psh.NameSpace(fso.GetAbsolutePathName(dest))
		, items := psh.NameSpace(this._.__path).Items()
		, items.Filter(0x00020|0x00040|0x00080, fspec)

		if (tmp := dest.Items().Count) {
			tmp := fso.CreateFolder(A_Temp . "\" . fso.GetTempName())
			, _dest := dest
			, dest := psh.NameSpace(tmp.Path) 
		}
		count := items.Count
		dest.CopyHere(items, 4|16)
		while (dest.Items().Count != count)
			Sleep 15
		if tmp {
			_dest.MoveHere(dest.Items(), 4|16)
			while (dest.Items().Count != 0)
				Sleep 15
			tmp.Delete(true)
		}
	}
	/* Function: delete
	 * Removes the specified item(s) from the archive
	 * Syntax:
	 *     zip.delete([ fspec ])
	 * Parameter(s):
	 *     fspec   [in] - File(s) to be deleted from the archive, accepts
	 *                    wildcard pattern. All files, if omitted.
	 */
	delete(fspec:="*.*") {
		fso := ComObjCreate("Scripting.FileSystemObject")
		, psh := ComObjCreate("Shell.Application")
		, items := psh.NameSpace(this._.__path).Items()
		, items.Filter(0x00020|0x00040|0x00080, fspec)
		, count := items.Count
		, tmp := fso.CreateFolder(A_Temp . "\" . fso.GetTempName())
		, trash := psh.NameSpace(tmp.Path)
		, trash.MoveHere(items, 4|16)
		while (trash.Items().Count != count)
			Sleep 15
		tmp.Delete(true)
	}
	/* Function: items
	 * Returns an array containing an item object for each member of the archive.
	 * Syntax:
	 *     zip.items([ filter ])
	 * Parameter(s):
	 *     filter  [in] - Only item(s) that match the wildcard pattern will
	 *                    be included. Defaults to all types(*.*).
	 */
	items(filter:="*.*") {
		static push := Func( A_AhkVersion < "2" ? "ObjInsert" : "ObjPush" )
		
		fso := ComObjCreate("Scripting.FileSystemObject")
		, psh := ComObjCreate("Shell.Application")
		, list := []
		, items := psh.NameSpace(this._.__path).Items()
		, items.Filter(0x00020|0x00040|0x00080, filter)
		for item in items
			member := {
			(Join Q C
				"base": {"__Class": "ZipFile.Member", "__Get": this.base.__Get},
				"_": [&this, item.Path]
			)}
			, %push%(list, member)
		return list
	}
	/* Function: item_info
	 * Retrieves details about an item in the archive.
	 * Syntax:
	 *     zip.item_info(item [, info ])
	 * Parameter(s):
	 *     item    [in] - Name/relative path of the item for which to retrieve
	 *                    the information.
	 *     info    [in] - One the following: [name, size, type, date, path].
	 *                    Defaults to 'name' if omitted.
	 */
	item_info(item, info:="name") {
		psh := ComObjCreate("Shell.Application")
		, pzip := psh.NameSpace(this._.__path)
		, item := pzip.ParseName(item)
		;// Name
		if (info = "name") {
			fso := ComObjCreate("Scripting.FileSystemObject")
			return fso.GetFileName(item.Path)
		} 
		;// Size, type, date
		else if (i:={"size":"Size", "type":"Type", "date":"ModifyDate"}[info])
			return item[i]
		;// Relative path
		else if (info = "path")
			return SubStr(item.Path, StrLen(this._.__path)+2)
	}
	;// PRIVATE -> for internal use
	__Get(k, p*) {
		;// Bypass 'base' and '__Class'
		if (k = "base" || k = "__Class")
			goto __zf_get
		;// Applies to each item object created by ZipFile.items()
		if (this.__Class == "ZipFile.Member") {
			zip := Object(this._[1])
			return zip.item_info(SubStr(this._[2], StrLen(zip._.__path)+2), k)
		}
		;// Full path of the zip archive
		else if (k = "path" || k = "__path") {
			return this._.__path
		}
		;// Name of the zip archive w/o path
		else if (k = "name") {
			fso := ComObjCreate("Scripting.FileSystemObject")
			return fso.GetFileName(this._.__path)
		}
		;// Private members
		else if this._.HasKey(k) {
			return this._[k]
		}

		__zf_get:
	}

	__Set(k, v, p*) {
		;// Bypass 'base' and '__Class'
		if (k != "base" && k != "__Class")
			return false ;// Make any property read-only
	}

	_NewEnum() {
		return {"enum":this.items()._NewEnum(), "base":{"Next":this.base.Next}}
	}

	Next(ByRef k, ByRef v:="") {
		if (r := this.enum.Next(k, v))
			k := v, v := ""
		return r
	}
}

ZipFile(file) {
	return new ZipFile(file)
}

ChangeButtonNames: ; http://ahkscript.org/docs/scripts/MsgBoxButtonNames.htm	  
IfWinNotExist, Update ahk_class #32770
    Return  ; Keep waiting...
SetTimer, ChangeButtonNames, off 
; WinActivate 
ControlSetText, Button1, Update, Update ahk_class #32770
If (checkauto = 1)
	ControlSetText, Button2, Release notes, Update ahk_class #32770
else If (checkauto = 0)	
	ControlSetText, Button2, Release notes!!, Update ahk_class #32770
ControlSetText, Button3, Cancel, Update ahk_class #32770
Return

; VersionCompare function by boiler at ahkscript.org - boiler
; Compares versions where simple string comparison can fail, such as 9.1.3.2 and 10.1.3.5
; Both version numbers are in format n1[.n2.n3.n4...] where each n can be any number of digits.
; Fills in zeros for missing sections for purposes of comparison (e.g., comparing 9 to 8.1).
; Not limited to 4 sections.  Can handle 5.3.2.1.6.19.6 (and so on) if needed.
; Returns 1 if version1 is more recent, 2 if version 2 is more recent, 0 if they are the same.
; http://ahkscript.org/boards/viewtopic.php?f=6&t=5959

; CopyFilesAndFolders
; http://ahkscript.org/docs/commands/FileCopy.htm

CopyFilesAndFolders(SourcePattern, DestinationFolder, DoOverwrite = false) 
; Copies all files and folders matching SourcePattern into the folder named DestinationFolder and
; returns the number of files/folders that could not be copied.
{
    ; First copy all the files (but not the folders):
    FileCopy, %SourcePattern%, %DestinationFolder%, %DoOverwrite%
    ErrorCount := ErrorLevel
    ; Now copy all the folders:
    Loop, %SourcePattern%, 2  ; 2 means "retrieve folders only".
    {
        FileCopyDir, %A_LoopFileFullPath%, %DestinationFolder%\%A_LoopFileName%, %DoOverwrite%
        ErrorCount += ErrorLevel
        if ErrorLevel  ; Report each problem folder by name.
            MsgBox Could not copy %A_LoopFileFullPath% into %DestinationFolder%
    }
    return ErrorCount
}