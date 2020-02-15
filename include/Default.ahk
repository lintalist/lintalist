/*
Name          : Standard functions, can also be shared by bundle scripts by including LLInit() in your bundle script
Version       : 1.2
Functions     :
	- LLInit()
	- GetActiveWindowStats()
	- Sendkey()
	- ClipSet() mod of virclip by Learning one http://www.autohotkey.com/forum/topic56926.html

History:
1.2 - ShortcutCopy, ShortcutPaste, ShortcutCut available in Scripts as well.
    - optional includes nvda.ahk and afterpaste.ahk (see docs, used for nvda for now)
    - moved Sleep, % PasteDelay to after pasting (replacing sleep, 50)
1.1 PasteDelay, ActiveWindowID, ActiveControl now global as they should in SendKey()
1.0 Initial version 20101010

*/

GetActiveWindowStats() ; Get Active Window & Control
	{
	 global
	 WinGet, ActiveWindowID, ID, A
	 WinGet, ActiveWindowProcessName, ProcessName, A ; TODO TODOMC
	 WinGetClass, ActiveWindowClass, A
	 ControlGetFocus, ActiveControl, A
	 WinGetActiveTitle, ActiveWindowTitle
	 StringReplace, ActiveWindowTitle, ActiveWindowTitle, [, , All
	 StringReplace, ActiveWindowTitle, ActiveWindowTitle, ], , All
	 
	 ; we can use this in our bundles to make sure we have 
	 ; the default functions available to our scripts defined in the bundle

	 LLInit= ; pass on basic data + functions to script from snippet
	 (
	  
		ActiveWindowID=%ActiveWindowID%
		ActiveWindowClass=%ActiveWindowClass%
		ActiveControl=%ActiveControl%
		ActiveWindowTitle=%ActiveWindowTitle%
		PasteDelay=%PasteDelay%
		SendMethod=%SendMethod%
		ShortcutCopy=%ShortcutCopy%
		ShortcutPaste=%ShortcutPaste%
		ShortcutCut=%ShortcutCut%

		#include %A_ScriptDir%\include\default.ahk  	  

		#include *i %A_ScriptDir%\include\nvda.ahk
	  
	 )
	}

LLInit() ; Fake function call -> If you use this in a snippet script Lintalist will replace this with the variables above from LLInit.
	{
	;
	}


SendKey(Method = 1, Keys = "")
	{
	 ; Method: 1 = SendInput
	 ; Method: 2 = SendEvent
	 ; Method: 3 = SendPlay
	 ; Method: 4 = ControlSend
 
 global PasteDelay, ActiveWindowID, ActiveControl, ActiveWindowProcessName, AltPaste, ShortcutCopy, ShortcutPaste, ShortcutCut, ShortcutQuickSearch
 
; replace default keys with application specific keys defined in AltPaste.ini - see docs\AltPaste.md
 If ActiveWindowProcessName in % AltPaste.programs
	{
	 if (keys = ShortcutPaste)
		{
		 if AltPaste[ActiveWindowProcessName].HasKey("paste")
		 	keys:=AltPaste[ActiveWindowProcessName].paste
		}
	 else if (keys = ShortcutCopy)
		{
		 if AltPaste[ActiveWindowProcessName].HasKey("copy")
			keys:=AltPaste[ActiveWindowProcessName].copy
		}
	 else if (keys = ShortcutCut)
		{
		 if AltPaste[ActiveWindowProcessName].HasKey("cut")
			keys:=AltPaste[ActiveWindowProcessName].cut
		}
	 else if (keys = ShortcutQuickSearch)
		{
		 if AltPaste[ActiveWindowProcessName].HasKey("QuickSearch")
			keys:=AltPaste[ActiveWindowProcessName].QuickSearch
		}
	}

;	 If ((Save = 1) or (Save = ""))
;		ClipSet("s",1) ; safe current content and clear clipboard
;		ClearClipboard()

	 If (Method = 1)
		{ 
		 WinActivate ahk_id %ActiveWindowID%
		 SendInput %keys%
		}
	 Else If (Method = 2)
		{ 
		 WinActivate ahk_id %ActiveWindowID%
		 SendEvent %keys%
		}
	 Else If (Method = 3)
		{ 
		 WinActivate ahk_id %ActiveWindowID%
		 SendPlay %keys%
		}
	 Else If (Method = 4)
		{ 
		 WinActivate ahk_id %ActiveWindowID%
		 ControlSend, %ActiveControl%, %keys%, ahk_id %ActiveWindowID%
		}

;	 Sleep 50 ; some time to get data to clipboard
	 Sleep, % PasteDelay ; was at the start of the function, moved it here

     ; Because one of the includes below will always fail code is only loaded once:
	 #include *i %A_ScriptDir%\include\afterpaste.ahk     ; from lintastlist search
	 #include *i %A_ScriptDir%\..\include\afterpaste.ahk  ; from a script

;	 If (Restore = 1)
;		 Clipboard:=ClipSet("g",2) ; restore
	
	 Return
	}

; mod of virclip by Learning one http://www.autohotkey.com/forum/topic56926.html
/* original VirClip tasks: (renamed to ClipSet for Lintalist)
"c" or "Copy"        ; copies just text. (Clipboard)
"ca" or "CopyAll"    ; copies all data; text, pictures, formatting. (ClipboardAll)
"x" or "Cut"
"xa" or "CutAll"
"v" or "Paste"
"vt" or "PasteText"  ; pastes only text from virtual clipboard.

"e" or "Empty"
"ea" or "EmptyAll"
"g" or "Get"
"ge" or "GetAndEmpty"      ; Lintalist addition
"s" or "Set"
"a" or "Append"
"p" or "Prepend"
"as" or "AppendSelected"   ; Appends selected text, not pictures etc.
"ps" or "PrependSelected"   

"uc" or "UpperCase"
"lc" or "LowerCase"
"tc" or "TitleCase"
*/

ClipSet(Task,ClipNum=1,SendMethod=1,Value="") ; by Learning one http://www.autohotkey.com/forum/topic56926.html
  { 
   global ShortcutCopy, ShortcutPaste, ShortcutCut
   Static Clip1, Clip2, Clip3, Clip4
   if ClipNum not between 1 and 30
   Return
   If !TryClipboard() ; v1.9.3
		Return ; if we can't read clipboard do nothing as to avoid the program to stall  
   IsClipEmpty := (Clipboard = "") ? 1 : 0
   if (task = "c" or task = "ca" or task = "x" or task = "xa" or task = "Copy" or task = "CopyAll" or task = "Cut" or task = "CutAll")
   {
      ClipboardBackup := ClipboardAll
      While !(Clipboard = "") {
         Clipboard =
         Sleep, 10
      }
      if (task = "c" or task = "ca" or task = "Copy" or task = "CopyAll")
      	SendKey(SendMethod, ShortcutCopy)
      Else
      	SendKey(SendMethod, ShortcutCut)
      if (task = "c" or task = "x" or task = "Copy" or task = "Cut") {
         ClipWait, 0.5
         if !(Clipboard = "")
         Clip%ClipNum% := Clipboard
      }
      Else {
         ClipWait, 0.5, 1
         if !(Clipboard = "")
         Clip%ClipNum% := ClipboardAll
      }
      Clipboard := ClipboardBackup
      if !IsClipEmpty
      ClipWait, 0.5, 1
      Return Clip%ClipNum%
   }
   else if (task = "v" or task = "vt" or task = "Paste" or task = "PasteText") {
      if (Clip%ClipNum% = "")
      Return
      ClipboardBackup := ClipboardAll
      While !(Clipboard = "") {
         Clipboard =
         Sleep, 10
      }
      Clipboard := Clip%ClipNum%
      ClipWait, 0.5, 1
      Sleep, 40
      if (task = "vt" or task = "PasteText") {
         Clipboard := Clipboard
         ClipWait, 0.5
         Sleep, 30
      }
      	SendKey(SendMethod, ShortcutPaste)
      Sleep, 20
      While !(Clipboard = "") {
         Clipboard =
         Sleep, 10
      }
      Clipboard := ClipboardBackup
      if !IsClipEmpty
      ClipWait, 0.5, 1
      Return Clip%ClipNum%
   }
   else if (task = "e" or task = "Empty") {
      Clip%ClipNum% =
      Return
   }
   else if (task = "ea" or task = "EmptyAll") {
      Loop, 30
      Clip%A_Index% =
      Return
   }
   else if (task = "g" or task = "Get")
      Return Clip%ClipNum%
   else if (task = "ge" or task = "GetAndEmpty") {
   	ThisClip:=Clip%ClipNum%
   	Clip%ClipNum% =
    Return ThisClip
   }
   else if (task = "s" or task = "Set") {
      Clip%ClipNum% := Value
      Return Clip%ClipNum%
   }
   else if (task = "a" or task = "Append") {
      Clip%ClipNum% .= Value
      Return Clip%ClipNum%
   }
   else if (task = "p" or task = "Prepend") {
      Clip%ClipNum% := Value Clip%ClipNum%
      Return Clip%ClipNum%
   }
   else if (task = "as" or task = "ps" or task = "AppendSelected" or task = "PrependSelected") {
      ClipboardBackup := ClipboardAll
      While !(Clipboard = "") {
         Clipboard =
         Sleep, 10
      }
      SendKey(SendMethod, ShortcutCopy)
      ClipWait, 0.5
      if !(Clipboard = "") {
         if (Clip%ClipNum% = "")
         Clip%ClipNum% := Clipboard
         Else {
            if (task = "as" or task = "AppendSelected")
            Clip%ClipNum% .= value Clipboard
            Else
            Clip%ClipNum% := Clipboard Value Clip%ClipNum%
         }
      }
      While !(Clipboard = "") {
         Clipboard =
         Sleep, 10
      }
      Clipboard := ClipboardBackup
      if !IsClipEmpty
      ClipWait, 0.5, 1
      Return Clip%ClipNum%
   }
   else if (task = "uc" or task = "UpperCase") {
      StringUpper, Clip%ClipNum%, Clip%ClipNum%
      Return Clip%ClipNum%
   }
   else if (task = "lc" or task = "LowerCase") {
      StringLower, Clip%ClipNum%, Clip%ClipNum%
      Return Clip%ClipNum%
   }
   else if (task = "tc" or task = "TitleCase") {
      StringUpper, Clip%ClipNum%, Clip%ClipNum%, T
      Return Clip%ClipNum%
   }
}

ClearClipboard()
	{
	 While !(Clipboard = "")
		{
		 Clipboard =
		 Sleep, 10
		}
	 Return
	}
	
TryClipboard()
	{
	 Try
		v:=Clipboard
	 catch ; can't read/access clipboard to return false
		Return 0
	 Return 1
	}
