/* 
Purpose       : Main #Include script for all Lintalist plugins.
Version       : 1.1

History:
- 1.1 by introducing MyPlugins and MyFunctions we reserve plugins.ahk for
      default plugins. Add your personal Plugins and Functions in MyPlugins.ahk
      or MyFunctions.ahk
- 1.0 initial version

See "readme-howto.txt" for more information.
*/

;----------------------------------------------------------------
; Do not change the order of these default includes below.
; Do not add your personal plugins/functions here, see v1.1 note above.

#Include %A_ScriptDir%\plugins\Snippet.ahk     ; Chaining snippets
#Include %A_ScriptDir%\plugins\Input.ahk       ; Get user input
#Include %A_ScriptDir%\plugins\DateTime.ahk    ; Insert date & time
#Include %A_ScriptDir%\plugins\Selected.ahk    ; Cut currently selected text 
#Include %A_ScriptDir%\plugins\Choice.ahk      ; Choose from a list
#Include %A_ScriptDir%\plugins\File.ahk        ; Include file
#Include %A_ScriptDir%\plugins\Calendar.ahk    ; Calendar 
#Include %A_ScriptDir%\plugins\Counter.ahk     ; Counters
#Include %A_ScriptDir%\plugins\Calc.ahk        ; Math
#Include %A_ScriptDir%\plugins\C.ahk           ; Character plugin
#Include %A_ScriptDir%\plugins\Split.ahk       ; Split plugin
#Include %A_ScriptDir%\plugins\SplitRepeat.ahk ; Split plugin
#Include %A_ScriptDir%\plugins\Random.ahk      ; Random plugin
#Include %A_ScriptDir%\plugins\PasteMethod.ahk ; Set PasteMethod per snippet
#Include %A_ScriptDir%\plugins\FileList.ahk    ; Build file list 
#Include %A_ScriptDir%\plugins\String.ahk      ; Transform text to upper, lower, sentence, title case, trim (basically a wrapper for ClipSelExFunc)
#Include %A_ScriptDir%\plugins\Comment.ahk     ; Add a comment to snippet which will be removed before pasting. Use a visual reminder or search aid.
;#Include %A_ScriptDir%\plugins\FileCopy.ahk    ; Copy files to clipboard for pasting
;#Include %A_ScriptDir%\plugins\enc.ahk         ; Enc(rypt) plugin (decode)
#Include %A_ScriptDir%\plugins\ClipSelExFunc.ahk
#Include *i %A_ScriptDir%\plugins\MyPlugins.ahk

;----------------------------------------------------------------
