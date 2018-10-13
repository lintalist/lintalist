# Lintalist Alternative Cut, Copy and Paste

By default Lintalist uses <kbd>ctrl</kbd>+<kbd>c</kbd>, <kbd>ctrl</kbd>+<kbd>v</kbd> to
copy and paste.  
Cut is only used for the QuickSearchHotkey as in <kbd>ctrl</kbd>+<kbd>shift</kbd>+<kbd>Left</kbd>+<kbd>ctrl</kbd>+<kbd>x</kbd>.  
(`^+{Left}^x` in AHK Syntax)

Some programs do not accept the standard copy and paste shortcuts such as console applications
(putty, powershell, cmd, etc). Or perhaps you want to paste an image as a new layer in a
graphics program.

## Setup

Edit `AltPaste.ini` and check if your program is already included. Create a new entry if not
or modify the entry to your preference(s).

**Adding a new program**

Use the name of the program executable as [section] name, followed by one or more of these four keys: 
( Use AHK Syntax: ^=ctrl +=shift !=alt )

- Copy=        alternative copy shortcut  ^{Ins} for console applications[1]
- Cut=         alternative cut   shortcut +{Del} for console applications 
- Paste=       alternative paste shortcut +{Ins} for console applications
- QuickSearch= alternative shortcut to Select and Cut Word to the Left of the Caret position

Only add those keys you need for that application.
Restart Lintalist after modifying `AltPaste.ini`

[1] More information https://en.wikipedia.org/wiki/Cut,_copy,_and_paste#Common_keyboard_shortcuts

## Included (console) applications (see ReadAltPasteIni.ahk and AltPaste.ini)

* cmd.exe
* ConEmu.exe
* ConEmu64.exe
* kitty.exe
* kitty_portable.exe
* mintty.exe
* putty.exe
* powershell.exe

Suggestions welcome at https://github.com/lintalist/lintalist/issues/66
