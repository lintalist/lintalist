; LintaList [standalone script]
; Purpose: Restart Lintalist
; This should prevent "Could not close the previous instance of this script. Keep waiting?"
; This can potentially happen when running the script from a cloud-folder (say dropbox)
; which could be slow with saving bundles.
; References:
; https://github.com/lintalist/lintalist/issues/127#issuecomment-496279719 and
; https://github.com/lintalist/lintalist/issues/114
; Bug fix: %A_AhkPath% https://github.com/lintalist/lintalist/issues/163

#NoEnv
#SingleInstance, force
SetBatchLines, -1
DetectHiddenWindows, On
SetTitleMatchMode, 2
Menu, Tray, Icon, icons\lintalist_suspended.ico ; while loading show suspended icon
Menu, Tray, Tip, Restarting Lintalist...

SetWorkingDir, %A_ScriptDir%\..

SplitPath, A_ScriptDir, , LintalistFolder

WinClose, %LintalistFolder%\lintalist.ahk
While WinExist("lintalist.ahk ahk_class AutoHotkey")
	{
	 Sleep, 1000 
	}

Run, %A_AhkPath% "%LintalistFolder%\tmpscrpts\restarttmp.ahk"
Sleep 1000
FileDelete, %LintalistFolder%\tmpscrpts\restarttmp.ahk

ExitApp
