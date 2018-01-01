/* 
Purpose       : Main #Include script for all Lintalist functions.
Version       : 1.0

History:
- 1.0 initial version

See "readme-howto.txt" for more information.
*/

;----------------------------------------------------------------
; Do not add your personal plugins/functions here,
; do so in MyFunctions.ahk

EnvGet(EnvVarName)
	{
	 EnvGet, OutputVar, %EnvVarName%
	 Return OutputVar
	}

#Include *i %A_ScriptDir%\plugins\MyFunctions.ahk
