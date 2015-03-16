### Changelog v1.4.1

* Fix: ShowPreview no longer worked reliabley due to "SetKeyDelay, -1" - removed it
* Fix: Somehow Changelog was only partially included.

### Changelog v1.4

* New: Extended Clipboard & Selected plugins (upper, lower, sentence, title, wrap)
  https://github.com/lintalist/lintalist/issues/12
* New: Calc plugin - Evaluate arithmetic expressions (using Laszlo's Eval/Monster)
  https://github.com/lintalist/lintalist/issues/15
* New: Plugins & Tools menu in Bundle Editor including dynamic submenus for clipboard,
  selected, counter & local variables plugins
* New: Settting for Single click in listview to act as double click
  ht: **dsewq1LYJ** https://github.com/lintalist/lintalist/issues/16
* New: Command line parameters -Bundle: load specific bundle and lock
  https://github.com/lintalist/lintalist/issues/8
* Fix: Minor bug which would allow last snippet to be pasted again if enter was given
  on an empty results list
* Fix: Up & Down arrow navigation should now work in the Bundle menu (Search GUI)
  this includes sending additional hidden keystrokes to the search control, do
  report errors if you experience any.
* Fix: Error on Gui, Show in lintalist.ahk for AHK v1.1.20+

### Changelog v1.3.1

* Fix: url fix update version check

### Changelog v1.3

* New: Configuration setting "**AutoExecuteOne**" if only one result is left
  during the search AutoExecute (no need to press enter)  
  ht: **dsewq1LYJ** https://github.com/lintalist/lintalist/issues/10
* New: Right menu Check for updates and install update if possible, uses  
  ZipFile class https://github.com/cocobelgica/AutoHotkey-ZipFile  
  VersionCompare http://ahkscript.org/boards/viewtopic.php?f=6&t=5959  
  see https://github.com/lintalist/lintalist/issues/7  
  Should work, but will know for sure at next update.
* Fix: Pgup/Pgdown now works again in search Gui
* Fix: Caret plugin misfired (first time only) when it was called via a
  shorthand snippet AND if that was the first snippet used after Lintalist was started.
 
### Changelog v1.2

* New: Command line parameter "**-Active**" to start Lintalist and open the search window:  
  Usage Running lintalist.exe installed: lintalist.exe lintalist.ahk -Active  
  Usage AutoHotkey installed: lintalist.ahk -Active 
  https://github.com/lintalist/lintalist/issues/6 - ht: @thiagotalma
* New: Configuration setting "**ActivateWindow**" which you can use to achieve
  the same as "-Active" - https://github.com/lintalist/lintalist/issues/6 - ht: @thiagotalma
* New: Configuration setting "**OnPaste**" which you can use to Exit Lintalist
  after pasting - https://github.com/lintalist/lintalist/issues/2 - ht: @thiagotalma
* New: Configuration setting "**PasteMethod**": paste snippet+restore clipboard,
  paste and keep as clipboard to paste again, just set as clipboard to paste
  manually - https://github.com/lintalist/lintalist/issues/3 - ht: @thiagotalma
* New: Configuration setting "**AlwaysUpdateBundles**" to always update Bundles
  after editing an existing snippet and don't want until you close Lintalist
  or "Reload Bundles" (tray menu) - https://github.com/lintalist/lintalist/issues/4 - ht: @mbos
* Change: You can now disable **QuickSearchHotkey** and **ExitProgramHotKey** in the
  settings by deleting the hotkey definitions.
  Background (note to self): https://github.com/lintalist/lintalist/issues/5#issuecomment-69449864
* Change: **ReadIni()** now creates settings based on a default file per setting,
  this will hopefully make it easier to introduce new settings or fixes for
  existing settings.
* Fixed: Added missing formatted texts options to Bundle editor right
  click menu (html,md,rtf,image)

### Changelog v1.1

* New: Snippets can now have HTML or Markdown markup which will be pasted as
  formatted text, or you can read an RTF or Image file which will be pasted
  into your current application.

### Changelog v1.0.3

* New: you can now use Local variables in your script code as well - ht: tpr
* Fixed: minor fixes local bundle editor (adding, removing) - ht: tpr
* Fixed: minor fix local counter editor (double click on empty row)

### Changelog v1.0.2

* New: Added Quick start guide to program and tray menu (can be turned on/off)
* New: Tray tip on Tray icon shows "hotkey" to start a search as visual reminder
* Fixed: Better handling of new (empty) bundles
* Fixed: Double click to edit snippet (method 5) was actually creating new snippet
  and it was missing from the INI - New: method 6 to create new snippet
* Fixed: Missing "tmpscrpts" folder from repo - @hoppfrosch - #1
* Fixed: Now actually implemented the center & mouse(alternative) settings
  for Lintalist window position + New: remember position set by user - these
  can now also be set via the Configuration gui
* Change: Removed "fake" text menu and now using a proper Gui menubar

### Changelog v1.0.1

* Fixed: RunWait %A_AhkPath% for local bundle & counter editor scripts
