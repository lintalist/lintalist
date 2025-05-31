### v1.9.26

* New: Ctrl+Shift+Alt+Enter Join Part1 and Part2 into one item to paste or copy to clipboard (see BothParts* settings) https://github.com/lintalist/lintalist/discussions/309  
* New: Plugin [[Part1]] [[Part2]] can now be used to insert part1 or part2 into the other part of the snippet - #309  
* AlwaysUpdateBundles: Also save bundles when deleting a snippet https://github.com/lintalist/lintalist/issues/307#issuecomment-2918655004  
* Fix: Plugin Random number range (1|10) https://github.com/lintalist/lintalist/issues/302  

### v1.9.25

* Fix: Entries from list disappeared after pasting https://github.com/lintalist/lintalist/issues/296

### v1.9.24

* Plugin: Update DateTime.ahk for Date Rolling #295 PR by KyleIsDork https://github.com/lintalist/lintalist/pull/295  
* Plugin: Input AlwaysOnTop for Input https://github.com/lintalist/lintalist/issues/294  
* New: Always select first row in Listview for legibility, works well with SelectionColors  
* New: First down in Search results jump to second row (was first row), the first row is automatically selected already  
* New: Shorten text displayed in Listview + Preview for more responsive Gui for (very) large snippets https://github.com/lintalist/lintalist/issues/291  
* New: Editor, status bar with line & column number, total lines, and size of edited part of a snippet. Not very fast nor 100% accurate...

### v1.9.23

* New: Choice / FileList plugin: Image preview window (toggle w <kbd>F3</kbd>) (formats bmp,gif,ico,jpg,jpeg,png -- ) if the FileList has returned full paths (P option). If an option in Choice seems to be a valid path (a-z:\) it automatically opens the preview window. https://github.com/lintalist/lintalist/issues/239  
* New: Settings AlternateRowColor and AlternateSelectionColor (activated by default), see configuration. Also available in Themes (see Themes.md) https://github.com/lintalist/lintalist/issues/279  
* New: Search Gui, view menu: Save column widths manually + reset https://github.com/lintalist/lintalist/discussions/252 https://github.com/lintalist/lintalist/discussions/273 https://github.com/lintalist/lintalist/issues/279  
* New: Press Ins-key to insert searched text into Input and Choice plugin edit controls https://github.com/lintalist/lintalist/discussions/280  
* New: Editor: load edited snippet manually from external editor https://github.com/lintalist/lintalist/issues/268  
* New: Allow TitleMatch to use ahk_exe https://github.com/lintalist/lintalist/issues/286  
* New: Show a "ScriptTemplates" menu in the Editor on right click https://github.com/lintalist/lintalist/discussions/256 https://lintalist.github.io/#ScriptTemplates  
* New: Choice plugin "Enable Choice to use typed in value" PR TFWol https://github.com/lintalist/lintalist/pull/258  
* New: Adding bundle name + properties to ColumnSearch using 6< https://github.com/lintalist/lintalist/issues/272  
* New: Expert option: Define additional tools and editors accessible via the Tools and Editor menu (see Editing snippets and Additional Tools in the Docs)  
* Fix: Additional check for StartSearchHotkeyTimeOut https://github.com/lintalist/lintalist/discussions/261  
* Fix: Bundle (properties) Editor Gui +Owner1 PR TFWol https://github.com/lintalist/lintalist/pull/282  
* Fix: Editor Gui +Owner1 PR TFWol https://github.com/lintalist/lintalist/pull/267  
* Fix: Use [[clipboard]] in scripts (directly or via llpart1/2) https://github.com/lintalist/lintalist/discussions/259  
* Fix: actually add ColumnWidthShorthand.ini to repository - reference https://github.com/lintalist/lintalist/pull/173#issuecomment-715927123  
* Fix: Check for updates via About, allow for "spaces in path" https://github.com/lintalist/lintalist/issues/262  
* Minor changes to docs ty @TFWol, "check for updates" and links in "about"
* AutoHotkey v1.1.37.02 now equired

### v1.9.22

* Fix: StartSearchHotkeyTimeOut should now work (better) with both StartSearchHotkey and StartOmniSearchHotkey, incl. modifier keys https://github.com/lintalist/lintalist/issues/247#issuecomment-1627195701
* Fix: Quote file paths in "Edit in Editor" (Snippet Editor) avoiding errors with spaces in paths https://github.com/lintalist/lintalist/issues/249

### v1.9.21

* New: Toggle timer to StartSearchHotkey activation + option to disable to toggle view mode (wide/narrow)   
  see settings StartSearchHotkeyTimeOut and StartSearchHotkeyToggleView https://github.com/lintalist/lintalist/issues/247  
* New: ShorthandPart2 setting to paste Part2 of snippet, similar to QuickSearchHotkey2 https://github.com/lintalist/lintalist/discussions/242
* Fix: Shorthand not being saved when reloading with default bundle only https://github.com/lintalist/lintalist/issues/246

### v1.9.20

* Fix: QuickSearchHotkey/QuickSearchHotkey2 did not restore clipboard with a Script snippet https://github.com/lintalist/lintalist/issues/236#issuecomment-1421500855

### v1.9.19

* Fix: QuickSearchHotkey2 didn't work https://github.com/lintalist/lintalist/issues/236 https://github.com/lintalist/lintalist/issues/169
* Fix: QuickSearchHotkey/QuickSearchHotkey2 did not restore clipboard https://github.com/lintalist/lintalist/issues/236
* LLInit() in a Local Var + Script snippet combination https://github.com/lintalist/lintalist/issues/238#issuecomment-1404014721
* New: [[LLShorthand]] available in scripts similar to [[LLPart1]] and [[LPart2]] https://github.com/lintalist/lintalist/issues/237

### v1.9.18

* Fix: Column Search should now reset properly after a search, so normal search works correctly again https://github.com/lintalist/lintalist/issues/232

### v1.9.17

* New: Added setting for ColumnSearchDelimiter to allow to search in a specific part of 
  the snippet (part1, part2, hotkey, shorthand, and script) https://github.com/lintalist/lintalist/issues/227
  (a ColumnSearch setting is also available as hidden setting to automatically implement this for all searches)

### v1.9.16

* New: AltPaste, addition to define PasteDelay (ms) and PasteMethod (0-2) per program https://github.com/lintalist/lintalist/issues/230
* Fix: Fix the change so it actually restores Clipboard contents https://github.com/lintalist/lintalist/issues/217 (line '970' was omitted from commit)

### v1.9.15

* New: Allow for _ in MyFunction and MyPlugin names https://github.com/lintalist/lintalist/issues/221
* New: Split plugin: use 0 (zero) to indicate last item https://github.com/lintalist/lintalist/issues/207
* New: Show the shortcut key on the Tray menu https://github.com/lintalist/lintalist/issues/191
* Fix: Revert change so it actually restores Clipboard contents https://github.com/lintalist/lintalist/issues/217
* Fix: Take into account that using a "deadkey" TriggerKey would produce an erroneous backspace https://github.com/lintalist/lintalist/issues/223

### v1.9.14

* New: QuickSearchHotkey2 setting, same as QuickSearchHotkey but always use Part2 of the snippet https://github.com/lintalist/lintalist/issues/169
* New: Editor add check for ASCII 5 (Enquiry) and ASCII 7 (Bell) https://github.com/lintalist/lintalist/issues/170
* New: Automatically create MyPlugins submenu in the Editor if they are present (ht gibbons6546 @ autohotkey forum)
* Change: Choice plugin - Automatically remove empty entries/options, to include an empty option make it the first option (ht gibbons6546 @ autohotkey forum)
* New: Setting to disable DPIfactor to resolve issue with multimonitor setup with different DPIs https://github.com/lintalist/lintalist/issues/165
* Fix: Ensure icons for Editor are correctly loaded incl. the default "theme" (e.g. no theme) https://github.com/lintalist/lintalist/issues/171
* Fix: Editor properly update column data to show part2, hotkey & shorthand columns when adding these for the first time
* Fix: File plugin, wouldn't be read correctly when using "|clean" as an option
* Fix/Change: try to match #includes to correct case of FileNames for mapped drives https://github.com/lintalist/lintalist/issues/176
* Minor changes to DOCs/links (ahkscript.org to autohotkey.com)

### v1.9.13

* New/Fix: "Update lintalist" could fail  
  - (1) if there was a space in the path https://github.com/lintalist/lintalist/issues/154  
  but also if the path "includes characters that cannot be used in a compressed folder"   
  As an alternative it now detects if the console version of 7-zip is present, if so use that  
  instead of the native Windows ZIP function. See docs\Update.md for instructions.  
  - (2) missing %A_AhkPath% in Restart routine https://github.com/lintalist/lintalist/issues/163
* Fix: potentially incorrect position of listbox in choice plugin

### v1.9.12

* New: you can now escape [[ and ]] in snippets - https://github.com/lintalist/lintalist/issues/162
  and additionally use [,],| in options using alternative notations: <SB, >SB, ^SB (see ParseEscaped in settings.ini)
* New: paste HTML code from clipboard (if present) in the editor https://github.com/lintalist/lintalist/issues/59 
* New: Run Query string using special hotkey (hidden expert option) https://github.com/lintalist/lintalist/issues/153
* Fix: if there are no search results, disable edit, copy, move, delete
* Further improvements for NVDA users
  - disable tooltip in toolbar https://github.com/lintalist/lintalist/issues/161
  - reporting snippet/listview contents to NVDA https://github.com/lintalist/lintalist/issues/159

### v1.9.11

* New: Theme support incl. updating all listview icons with transparency.
* New: <kbd>ctrl</kbd>+<kbd>f</kbd> shortcut to focus on search box in Lintalist GUI, <kbd>TAB</kbd> to set focus on Listview (results) https://github.com/lintalist/lintalist/issues/148
* Changed how UP/DOWN are handled in the search results (related to TAB above)
* Check for certain programs that might conflict with the standard Start search hotkey (capslock). Only NVDA for now. #148
* New: Optional AfterPaste.ahk to allow additional actions after copy or paste (example: let NVDA speak the snippet text) https://github.com/lintalist/lintalist/issues/150
* Update: Default.ahk make ShortcutCopy, ShortcutPaste, ShortcutCut available in Scripts as well. Changed timing of PasteDelay.
* Update: TitleCase() v1.41 https://github.com/lintalist/TitleCase
* Fix: StayOnMonitor to prevent searching GUI being displayed above the top of the monitor

### v1.9.10

* New: Comment plugin - add comment to snippet which will be removed before pasting. Use as visual reminder or search aid.
* New: On Top button/option in Search Window <kbd>ctrl</kbd>+<kbd>t</kbd> (per search)
* New: Option to show/hide the Search Window with the same shortcut (StartSearchHotkeyToggle setting)
* New: View menu in Search Window to toggle wide/narrow window and On Top
* New: Make a 64-bit version available for download as well (a renamed AutoHotkeyU64.exe)
* New: EditorAutoCloseBrackets setting to define some editor hotstrings, example `[` -> `[[|]]`
* Change: More flexible plugin check syntax in Editor (was too strict with regards to `[[..]]`). (EditorSnippetErrorCheck setting) 
* Fix/Change: Disable Search GUI shortcuts when using the non-default ColumnSort setting (NoSort) 

### v1.9.9

* New: Search GUI shortcuts for first 10 search result (Alt+1..0) - show numbers as text and/or icons.  
  Settings: ShortCutSearchGui - https://github.com/lintalist/lintalist/issues/137
* New: String plugin to transform text (upper, lower, sentence, title case, trim...)
* New: Query plugin and QueryDelimiter setting. Use (parts of) search query in Snippets, see docs and  
  https://github.com/lintalist/lintalist/issues/136
* New: Editor - 'shortcuts' (Keyboard accelerators) for the (Edit) controls
* Change: removed Pgdown and Pgup hotkeys, no longer worked correctly and not all that useful
* Change/fix: Change how Col2, Col3, and Col4 are set for listview columns to prevent accidental hiding of columns  
  https://github.com/lintalist/lintalist/issues/126  
* Fix: Choice plugin Cancel/Esc not storing position properly
* Fix: Pausing / Enabling Shortcuts didn't work correctly, worked only after restart
* Update TitleCase() to v1.2 https://github.com/lintalist/TitleCase

### v1.9.8.4

* Change: merge search string (SearchThis1,SearchThis2,SearchThis3) to allow for easier searching  
* Change: Use external script (restart.ahk) to restart to prevent possible "Could not close the previous instance of this script" message https://github.com/lintalist/lintalist/issues/127#issuecomment-496279719   
* Change/fix: MaxRes=30 in Ini (recommended setting anyway) + ObjectBundles.ahk https://github.com/lintalist/lintalist/issues/127#issuecomment-496279719  
* Change: Statistics = 3 option to save Statistics in A_UserName-Statistics.ini (on request https://github.com/lintalist/lintalist/issues/112#issuecomment-494350363)  

### v1.9.8.3

* Fix: unexpected () characters deletion for plugin content ending with ()]] not being a function  
  https://github.com/lintalist/lintalist/issues/125
* New: Allow ^$ to be used as alternative notation for Caret plugin (^|)  
  https://github.com/lintalist/lintalist/issues/124
* New: Use Font and FontSize setting in Editor as well (Part1, Part2, Script)  
  https://github.com/lintalist/lintalist/issues/122

### v1.9.8.2

* Fix: Improve CheckLineFeed by using RegEx to catch all CR, LF, and CRLF

### v1.9.8.1

* Fix: additional safety check for positioning Editor and Choice plugin windows to prevent error  
  https://github.com/lintalist/lintalist/issues/121

### v1.9.8

* New: [[FileList]] plugin returns list of file names from folder - see DOC for all available options
* New: [[Choice]] Search (filter as you type) option for Choice by adding ! similar to ? Question help/text;  
       Allow user to resize Choice GUI; Use FontSize for Choice GUI (in the listbox) incl. Auto Center checkbox
* New: Editor save size and position (resize by dragging window border)
* New: Optional Statistics (see Configuration) https://github.com/lintalist/lintalist/issues/112
* New: added :hover 'permalink' helpers for most headings etc using visible pilcrow (¶) in DOC
* Fixed: ClipSet("s") call in Lintalist and Selected, Split* plugins - https://github.com/lintalist/lintalist/issues/116
* Update: ClipSet() now also use ShortcutCopy, ShortcutPaste, ShortcutCut settings.
* Update: Title case for selected/clipboard plugins now uses TitleCase() for more flexibility  
  https://github.com/lintalist/lintalist/issues/113 also available as separate function (for AHK) https://github.com/lintalist/TitleCase
* Update: Incorporate CancelPlugin (avoids SoundPlay and return nicely) in plugins: Calendar, Choice, File and Input
* Change: Revert change https://github.com/lintalist/lintalist/issues/52 (v1.8)
* Change: Choice and Editor now use WinWaitClose vs "ugly Loop"
* Change: LCID values for Calendar and DateTime can now be Hexadecimal values as well (L1036 and L0x040C = French)

### v1.9.7

* New: AltPaste method via INI config - for example to paste in Putty via shift+insert vs ctrl+v - #66  
  https://github.com/lintalist/lintalist/issues/66 and docs\AltPaste.md
* New: You can replace linefeed(s)/newline(s) per application via INI config in Linefeed.ini - #65 https://github.com/lintalist/lintalist/issues/65
* New: You can now define the Copy, Cut, Paste and QuickSearch shortcuts (see settings)
* New: Run as Administrator command line, Settings, and Tray menu options - #99 https://github.com/lintalist/lintalist/issues/99
* New: Plugin [[PasteMethod]] similar to global setting but now acts on snippet basis #9 https://github.com/lintalist/lintalist/issues/9
* New: Alt+Enter and Alt+Shift+Enter in Search GUI just copies snippet to the clipboard (=PasteMethod=2) - #9
* New: Plugin [[image]] now accepts clipboard as a valid path to an image: [[image=clipboard]]
* New: Added reset/set option to [[Counter]] plugin
* New: Open Tray Menu on left mouse click - #101 https://github.com/lintalist/lintalist/issues/101
* New: Esc closes Lintalist Quick Start Guide - #100 https://github.com/lintalist/lintalist/issues/100
* New: Tray and Edit menu item "Open Lintalist folder" - #102 https://github.com/lintalist/lintalist/issues/102
* New: Tray menu click on first item (Program name) opens Search GUI - #102
* New: Added NumpadUp / NumpadDown for navigation in addition to Up/Down keys - #103 https://github.com/lintalist/lintalist/issues/103
* New: FixURI() - added A HREF for HTML to check/correct local file uri (file://) as well not just for IMG SRC
* Fix: removed stray "If (BigIcons..." from ReadIni.ahk
* Fix: Plugin [[Choice]] resolved crash when having over 9 Choice entries in a snippet - #108 https://github.com/lintalist/lintalist/issues/108
* Fix: added IniListFinalCheck to ensure all button states are saved with a 0 or 1 value (e.g. not empty)
* Fix: corrected some typos in Changelog.md and doc\index.html

### v1.9.6

* New: Setting EditorHotkeySyntax to allow users to enter AHK syntax hotkeys in Snippet Editor  
  #98 https://github.com/lintalist/lintalist/issues/98
* Fix: Actually add support for LCID to Calendar plugin - see v1.8 - and introduced third  
  option to replace hardcoded " to " with user defined string. #97

### v1.9.5

* New: Command line parameters -ReadOnly: start in ReadOnly mode, no editing of bundles or  
  updating settings.ini #95 https://github.com/lintalist/lintalist/issues/95
* New: Check Capslock and ScrollLock state at startup, turn it off if used as hotkeys  
  and inform user if it is turned off #93 https://github.com/lintalist/lintalist/issues/93
* Fix: allow to change default bundle #94 https://github.com/lintalist/lintalist/issues/94
* Fix: Escape % in llpart1 and llpart2 variable when using snippet part1 or part2 in scripts  
  #92 https://github.com/lintalist/lintalist/issues/92
* Fix: The error "Can not append snippet to Bundle (No file name available)" should no  
  longer happen.
* New: adding UTF-8 to all FileAppend commands as potential fix for Text-encoding issues #96  
  https://github.com/lintalist/lintalist/issues/96

### v1.9.4

* New: Functions in Snippets are now also allowed: [[function()]] - both AHK built-in as  
  user defined - #86 https://github.com/lintalist/lintalist/issues/86
* New: support a subset of AutoHotkey built-in variables (A_MyDocuments etc)
* New: Additional safety check when processing snippet by "removing" faulty plugins  
  plus a simple error check when saving snippets.
* New: Editor now has (optional) Syntax highlighting (plugins, html, scripts) by using  
  the RichCode class by @G33kDude - #88 https://github.com/lintalist/lintalist/issues/88  
  (when using RichCode you can toggle word wrapping in the edit controls by pressing ctrl+w)
* Fix: Editor - "Edit in Editor" routine improved, notepad.exe may not show ".txt" in Window title,  
  and actually delete "__tmplintalistedit.txt" file in tmp folder (didn't do so correctly)
* Change: User plugins (and now functions) can be added to MyPlugins/MyFunctions so future  
  updates of Lintalist won't overwrite plugins/functions added by users each time. (see release note)
* Fix: Closing Input and Choice plugins via close button (x) in Gui now properly cancels snippet
* New: added icons to Tray menu and some Search menu entries.

### v1.9.3

* Improved: TriggerKeys now accept more keys such as <kbd>½</kbd> or <kbd>+</kbd> for example  
  #79 https://github.com/lintalist/lintalist/issues/79
* Improved: Now there is also a 32x32 size icon button bar accommodating high(er) DPI settings  
  #71 https://github.com/lintalist/lintalist/issues/71 (see BigIcons in settings)  
  Entirely new code for GuiSettings.ahk
* New: added TryClipboard() to see if clipboard is inaccessible, if so "catch" error and do nothing 
  #73 https://github.com/lintalist/lintalist/issues/73
* New: Make it possible to include contents of Snippet (part 1 and 2) in script code incl. caret  
  position per snippet (see "Script" in Documentation)  
  #76 https://github.com/lintalist/lintalist/issues/76
* Change: Similar to modal windows for Local variable etc, Snippet editor now modal  
  - see v1.8 #57 https://github.com/lintalist/lintalist/issues/57
* Fix: Adding support for UTF-8 characters in Local variable & Counter Editors  
  #78 https://github.com/lintalist/lintalist/pull/78 ht @exetico
* Fix: ReadIni() now writes in UTF-16 to store settings correctly  
  #77 https://github.com/lintalist/lintalist/issues/77
* Fix: Closing using X in title bar didn't store Window position for users with Center=2  
  and now save it to settings.ini as well #75 https://github.com/lintalist/lintalist/issues/75
* Fix: Closing and Starting Lintalist in Narrow view mode no longer  
  causes error in GUI with empty 'barx' variable #72 https://github.com/lintalist/lintalist/issues/72  
  (see also #71 above re GuiSettings.ahk)

### v1.9.2

* New: replaced check/radio boxes with button bar (using Class_Toolbar by pulover) and  
  icons from the Fugue & Diagona Icon sets by Yusuke Kamiyamane.  
  #51 https://github.com/lintalist/lintalist/issues/51
* New: Right click context menu listview #70 https://github.com/lintalist/lintalist/issues/70
* Fix: Refactored LoadAll and Selected Bundle code, should work better now (lintalist.ahk)
* Fix: Refactored duplicate hotkey and shorthand detection code, should work better now (editor.ahk)
* Fix: SetIcon.ahk now also looks at Part2 of the snippet as it should

### v1.9.1

* Fix: At very first startup SetDesktop and SetStartup default settings wouldn't be  
  properly stored for them to be usable with Func_IniSettingsEditor()

### v1.9

* New: Choice plugin - Added option to provide "information/question" hint  
  by starting first item with a ? - HT @flyingaliens https://github.com/lintalist/lintalist/issues/68  
  (see DOC)
* Fix: Choice plugin - Reverted back to Loop, works better for multiple  
  Choice plugins https://github.com/lintalist/lintalist/issues/68
* Fix: Lintalist - Added "Select and press enter" Choice GUI to  
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
* Fix: Canceling a snippet with Choice plugin no longer makes Shorthand stop working  
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
  Searching for 'e' is translated to searching for 'eéèê...' etc  
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

* Fix: ShowPreview no longer worked reliably due to "SetKeyDelay, -1" - removed it
* Fix: Somehow Changelog was only partially included.

### Changelog v1.4

* New: Extended Clipboard & Selected plugins (upper, lower, sentence, title, wrap)
  https://github.com/lintalist/lintalist/issues/12
* New: Calc plugin - Evaluate arithmetic expressions (using Laszlo's Eval/Monster)
  https://github.com/lintalist/lintalist/issues/15
* New: Plugins & Tools menu in Bundle Editor including dynamic submenus for clipboard,
  selected, counter & local variables plugins
* New: Setting for Single click in listview to act as double click
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

* Fix: URL fix update version check

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
