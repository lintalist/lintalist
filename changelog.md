### v1.9.2

* New: replaced check/radio boxes with button bar (using Class_Toolbar by pulover) and  
  icons from the Fugue & Diagona Icon sets by Yusuke Kamiyamane.  
  #51 https://github.com/lintalist/lintalist/issues/51
* New: Right click context menu listview #70 https://github.com/lintalist/lintalist/issues/70
* Fix: Refactored LoadAll and Selected Bundle code, should work better now (lintalist.ahk)
* Fix: Refactored duplicate hotkey and shorthand detection code, should work better now (editor.ahk)
* Fix: SetIcon.ahk now also looks at Part2 of the snippet as it should

### v1.9.1a (Initial version of Lintalist for Math)
* New: Hardcoded shortcuts:
  - Alt + Enter: Edit selected snippet (same as F4).
  - Ctrl + n: Add new snippet (same as F7).
  - Delete: Delete selected snippet.
* New: Hotkeys (which can be changed or disabled in the settings menu):
  - MathSnippetHelperHotkey (#h). HotKey used to add a new snippet to Lintalist
    from the selected text (using dialogs).
  - MathSetUpHotkey (#w). HotKey to set up Maple for commenting. It gives Maple
    Input a red color, unfolds all sections, and sets zoom to 100 %.
  - MathPastePureHotkey (#v). HotKey for pasting pure text. This helps with some
    formatting issues in Maple.
  - MathYellowBGHotkey (#a). HotKey for Maple. It gives the selected text a
    yellow background color.
  - MathOrangeTextHotkey (#z). HotKey for Maple. It gives the selected text a
    faded orange color.
  - MathRedTextHotkey (#c). HotKey for Maple. It gives the selected text a red
    color.
  - MathReloadAllHotkey (#q). HotKey that loads all bundles and reloads
    Lintalist for Math.
* New: Plugins:
  - Math: A plugin to display math in Maple (and strip output in other programs).
  - Underline: A plugin to underline text in Maple (but not in other programs).
* New: Trigger keys added: -, \_
* Change: Default trigger keys changed from "Tab,Space" to "-, \_".
* Change: QuickSearchHotkey changed from "#z" to "^#z".
* Change: Edited the default bundle to include some important shortcuts for
  Maple and an example for the new plugins (Math og Underline).
* Change: Disabled update feature (for now).
* Change: Removed "Snippet succesfully added to bundle [...]" message.

### v1.9.1

* Fix: At very first startup SetDesktop and SetStartup default settings wouldn't be  
  properly stored for them to be useable with Func_IniSettingsEditor()

### v1.9

* New: Choice plugin - Added option to provide "information/question" hint  
  by starting first item with a ? - HT @flyingaliens https://github.com/lintalist/lintalist/issues/68  
  (see DOC)
* Fix: Choice plugin - Reverted back to Loop, works better for multiple  
  Choice plugins https://github.com/lintalist/lintalist/issues/68
* Fix: Lintalist - Added "Select and press enter" Choice gui to  
  BundleHotkeys group to disable the possibility of activating Lintalist again
* Fix: Random plugin - Count correct number of RandomItems (+ 1)
* New: Introduce "Not Titlematch" for bundles by using an exclamation mark  
  (see DOC) https://github.com/lintalist/lintalist/issues/30
* Change: Allow Editor GUI to be resized using AutoXYWH()  
  https://github.com/lintalist/lintalist/issues/67
* Added: Visual Studio Code (code.exe) Configuration to MultiCaret.ini (for new  
  users only, existing users can add it manually if they use Visual Studio Code)

### v1.8.1

* Added Random plugin to Editor menu(s)
* Added: Komodo Edit 10+ Configuration to MultiCaret.ini (for new users only, existing
  users can add it manually if they use Komodo)

### v1.8

* New: Command line parameters -Ini: load specific settings file (ini)  
  https://github.com/lintalist/lintalist/issues/8
* New: Multi-caret implemented for certain text editors (see DOC)  
  https://github.com/lintalist/lintalist/issues/61
* New: Random plugin, return random value or entry from a list  
  https://github.com/lintalist/lintalist/issues/64  
  (Random button added to Choice plugin)
* New: Calendar and DateTime now accept Locale Identifiers (LCID) parameter  
  ht @dbielz https://github.com/lintalist/lintalist/issues/58
* Change: Snippet, Bundle, Counter and Local variable editors are now all visible  
  on the taskbar as a child window of a disabled Lintalist Search GUI (if present)  
  this makes it easer to switch from/to the appropriate editor using alt-tab and mouse  
  https://github.com/lintalist/lintalist/issues/57
* Added: Choice plugin GUI now has "Endless scrolling in a listbox" similar to  
  Search GUI listview + New Random button
* Fix: Cancelling a snippet with Choice plugin no longer makes Shorthand stop working  
  https://github.com/lintalist/lintalist/issues/52
* Fix: After using quick search with one result e.g. automatic pasting of the only  
  snippet, pressing space or tab executed the snippet again. Cleared the typing history  
  after each paste fixed it.
* Fix: Pause shortcut could cause error, added #IfWinNotActive ahk_group

### v1.7

* New: SnippetEditor Setting - Allow user to set editor to use for "Edit in Editor" button  
  in the Snippet Editor  
  ht @starstuff - https://github.com/lintalist/lintalist/issues/46
  Note: added EXE type to Func_IniSettingsEditor_v6.ahk
* New: PlaySound Setting - Play sounds after paste, open or close of Search Gui (beeps, default  
  Windows media or user files)  
  ht @starstuff - https://github.com/lintalist/lintalist/issues/45  
* New: SearchLetterVariations setting -  Allow for variations of letters in search query
  Searching for 'e' is translated to searching for 'e���...' etc  
  You can toggle this setting via the Search GUI - https://github.com/lintalist/lintalist/issues/33  
  Note: Consequence for Fuzzy search is that this now always using a RegEx which could be slower.
* New: added help menu with Help and About options and added About to tray menu - https://github.com/lintalist/lintalist/issues/47  
  also refactored tray and edit menu handlers by merging most of the options in these two handlers  
  to prevent errors such as https://github.com/lintalist/lintalist/issues/44
* New: Allow Ctrl+ and Shift+NumpadEnter to also bypass script just like normal Enter  
  ht: @jaredbidlow https://github.com/lintalist/lintalist/issues/50
* New: Split plugin now accepts "named Split" [[split_name]]  
  ht: afh - https://github.com/lintalist/lintalist/issues/48
* Fix: Tray menu: manage bundles and manage local variables weren't working  
  ht: @starstuff - https://github.com/lintalist/lintalist/issues/44
* Fix: First time of UP key press didn't update ShowPreview, should work correctly now
* Fix: Always resolve Vars in nested situations  
  ht: @dbielz - https://github.com/lintalist/lintalist/issues/56
* New: Added icons to status bar

### v1.6

* New/Changed: improved plugin parsing so any type of nested snippets are now  
  allowed (used to be a limited set in a particular order) #37
* New: Split & SplitRepeat plugins #37
* New: Fall back on part2 of snippet it part1 happens to be empty  
  https://github.com/lintalist/lintalist/issues/36
* New: you can now create counters "on the fly" - if the name of a counter is  
  unknown it will be added automatically and saved in the settings. The start  
  value is 0 so when first using it the value used in the snippet will be 1  
  https://github.com/lintalist/lintalist/issues/26
* New: ColumnWidth setting to set percentage of width for part1 and part2 in  
  results https://github.com/lintalist/lintalist/issues/22
* New: Optional sort for the five columns in the listview, ColumnSort setting  
  ht: FanaticGuru - https://github.com/lintalist/lintalist/issues/21
  Hotkeys: ctrl-1 to 5
* New: File plugin - options for Select and Clean, now uses FixURI() as well.
* New/Editor: hotstring to expand [ to [[]] while in Snippet editor.
* Editor/ObjectBundles: fix preview moved to function (code refactored)
* Editor: new snippet now uses .InsertAt vs .MaxIndex+1  (.Push and .InsertAt where introduced in AutoHotkey 1.1.21.00)  
  hopefully fixes issue with "hidden" new snippet https://github.com/lintalist/lintalist/issues/37#issuecomment-108025595  
  New snippets are now insert at the beginning of the Snippet object,  
  so the new item should be the first of the items in the active  
  bundle (depending on sort, see New: Optional sort) - should be a good indication that the  
  new snippet has been added correctly.
* Change: Sort settings in the Configuration treeview  
  https://github.com/lintalist/lintalist/issues/35
* Change: Calendar now uses Multi-select (shows two months side by side). This  
  allows the user to shift-click or click-drag to select a range of adjacent  
  dates (the user may still select a single date too).
* Change: made bundle hotkeys context sensitive to avoid them being used in Lintalist guis.  
  https://github.com/lintalist/lintalist/issues/38
  Also applied to regular Lintalist (GUI) hotkeys replacing some code at Guistart label.
* Change/Fix: Nesting of HTML and MD snippets now allowed.  
  https://github.com/lintalist/lintalist/issues/42

### v1.5

* New: Optional - Show bundle name in search results and/or use Colour to  
  indicate bundle - https://github.com/lintalist/lintalist/issues/18  
  uses Class_LV_Colors by just me https://github.com/AHK-just-me/Class_LV_Colors  
  Setting: DisplayBundle  
  Caveat: using colours might cause the Search GUI to freeze or to become  
  unresponsive should this happen simply avoid using a DisplayBundle  
  setting > 1.
* New: Optional - Set font (typeface) and font size for search results  
  and preview - https://github.com/lintalist/lintalist/issues/18  
  Setting: Font and FontSize
* New: Bundle editor revised (used to be 2nd tab in editor) - editing bundle  
  properties now independent of snippet. Delete a bundle using the editor.  
  ht: @danielo515 https://github.com/lintalist/lintalist/issues/19 and  
  https://github.com/lintalist/lintalist/issues/28
* New: Omnisearch - start search query with @, press F2 while search or
  ctrl-capslock to search in all bundles regardless of loaded and/or locked  
  bundles in search Gui.  
  ht: @danielo515 https://github.com/lintalist/lintalist/issues/31  
  http://lintalist.github.io/#Omni
* Fix: Selected plugin, fixing issue with = in the text of wrap option caused error  
  https://github.com/lintalist/lintalist/issues/25  
  (does not properly solve nested plugins yet as discussed there).
* Fix: Calendar plugin - added cancel option.
* Fix: Update helper: Revised routine.
* Change: refactored ReadIni() code.
* Change: in EditorMenuHandler now using Control, EditPaste for sending Plugin  
  to controls in Snippet editor (part 1 & part 2) - faster and more reliable.
* Doc: More information about the various usages of part2 in a snippet.  
  Discussion at https://github.com/lintalist/lintalist/issues/20
* Doc: How to use counter more than once "Add Zero"  
  https://github.com/lintalist/lintalist/issues/24

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
