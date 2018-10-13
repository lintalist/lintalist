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

#Include %A_ScriptDir%\plugins\snippet.ahk     ; Chaining snippets
#Include %A_ScriptDir%\plugins\input.ahk       ; Get user input
#Include %A_ScriptDir%\plugins\datetime.ahk    ; Insert date & time
#Include %A_ScriptDir%\plugins\selected.ahk    ; Cut currently selected text 
#Include %A_ScriptDir%\plugins\choice.ahk      ; Choose from a list
#Include %A_ScriptDir%\plugins\file.ahk        ; Include file
#Include %A_ScriptDir%\plugins\calendar.ahk    ; Calendar 
#Include %A_ScriptDir%\plugins\counter.ahk     ; Counters
#Include %A_ScriptDir%\plugins\calc.ahk        ; Math
#Include %A_ScriptDir%\plugins\c.ahk           ; Character plugin
#Include %A_ScriptDir%\plugins\split.ahk       ; Split plugin
#Include %A_ScriptDir%\plugins\SplitRepeat.ahk ; Split plugin
#Include %A_ScriptDir%\plugins\Random.ahk      ; Random plugin
#Include %A_ScriptDir%\plugins\PasteMethod.ahk ; Set PasteMethod per snippet
;#Include %A_ScriptDir%\plugins\enc.ahk         ; Enc(rypt) plugin (decode)
#Include %A_ScriptDir%\plugins\ClipSelExFunc.ahk
#Include *i %A_ScriptDir%\plugins\MyPlugins.ahk

;----------------------------------------------------------------
