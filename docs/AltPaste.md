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

- Copy=        alternative copy  shortcut ^{Ins} for console applications[1]
- Cut=         alternative cut   shortcut +{Del} for console applications 
- Paste=       alternative paste shortcut +{Ins} for console applications
- QuickSearch= alternative shortcut to Select and Cut Word to the Left of the Caret position
- PasteDelay=  see documentation, delay in milliseconds, overrides global setting
- PasteMethod= 0-2, see documentation, overrides global setting

Only add those keys you need for that application.
Restart Lintalist after modifying `AltPaste.ini`

[1] More information https://en.wikipedia.org/wiki/Cut,_copy,_and_paste#Common_keyboard_shortcuts

## Note about Notepad++

Lintalist may not work correctly in some versions of notepad++.exe - it may not paste your snippet or not copy text when using the `[[selected]` plugin.
A workaround that _might_ work - the menu bar HAS to visible - will use the AutoHotkey command https://www.autohotkey.com/docs/v1/lib/WinMenuSelectItem.htm

Add the following to `AltPaste.ini`

```ini
[notepad++.exe]
Cut=2&|4&
Copy=2&|5&
Paste=2&|6&
```

Save and restart Lintalist.

This may also work for other programs where the application uses a standard Windows menu bar.
See the AutoHotkey command documentation on how to access the correct main- and submenu. 
This can either be `text` or `digit&` separated by a `|` character - `Edit|Copy` or `2&|5&` would be valid examples.

Discussion https://github.com/lintalist/lintalist/issues/330

## Included (console) applications (see ReadAltPasteIni.ahk and AltPaste.ini)

* cmd.exe [2]
* ConEmu.exe
* ConEmu64.exe
* kitty.exe
* kitty_portable.exe
* mintty.exe
* putty.exe
* powershell.exe

Suggestions welcome at https://github.com/lintalist/lintalist/issues/66

[2] Various Windows versions handle cmd.exe differently:

**Windows 10**

If you use Windows 10 you might consider activating `^v` to paste in which case you could remove the cmd.exe entry.
Instructions: https://www.howtogeek.com/howto/25590/how-to-enable-ctrlv-for-pasting-in-the-windows-command-prompt/

**Before Windows 10**

1) `+{Ins}` to paste might not work but you could try the following (for English language OS):

    Paste=!{space}ep  
    Copy=!{space}ey
    
2) If you do want to use `^v` to paste in your cmd.exe you could consider installing **Clink** which enables this - among many other useful features - more information and download at https://chrisant996.github.io/clink/ ( a fork of the original clink https://mridgers.github.io/clink/ )
