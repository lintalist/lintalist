; LintaList Include
; Purpose: Parse (nested) plugins properly and assisting functions
; Version: 1.2
;
; See the ProcessText label in Lintalist.ahk
; GrabPlugin() v1
;
; History:
; - 1.2 Fix GrabPluginOptions to prevent removing closing ) - https://github.com/lintalist/lintalist/issues/125
; - 1.1 Lintalist v1.9.4 added ProcessFunction() and modified GrabPluginOptions() to accommodate functions in snippets
; - 1.0 Lintalist v1.6 - improved plugin parser

; GrabPlugin is used for local variables only at the moment
GrabPlugin(data,tag="",level="1")
	{
	 if (tag <> "")
	 	tag .= "="
	 if RegExMatch(tag,"i)(Clipboard|Selected)")
	 	tag:=trim(tag,"=")
	 Start:=InStr(data,"[[" tag,,,level)
	 Loop
		{
		 Until:=InStr(data, "]]", false, Start, A_Index) + StrLen("]]")
		 Strng:=SubStr(data, Start, Until - Start)
		 OpenCount:=CountString(strng, "[[")
		 CloseCount:=CountString(strng, "]]")
		 If (OpenCount = CloseCount)
			Break

		 If (A_Index > 250) ; for safety so it won't get stuck in an endless loop.
			{
			 strng=
			 Break
			}
		}
	 If (StrLen(strng) < StrLen(tag)) ; something went wrong/can't find it
		strng=

	 Return strng
	}

; helper functions

GrabPluginOptions(data)
	{
	 ; Return Trim(SubStr(data,InStr(data,"=")+1),"[]") ; before supporting functions
	 if RegExMatch(data,"^\[\[\w+=")
		Return Trim(SubStr(trim(data,"[]"),RegExMatch(trim(data,"[]"),"\=|\(")+1),"[]") ; make sure we don't strip closing ")"" from non function plugin code https://github.com/lintalist/lintalist/issues/124
	 else
		Return Trim(SubStr(trim(data,"[]"),RegExMatch(trim(data,"[]"),"\=|\(")+1),"[]()") ; modified to extract parameters from functions
	}

CountString(String, Char)
	{
	 StringReplace, String, String, %Char%,, UseErrorLevel
	 Return ErrorLevel
	}

ProcessFunction(function,param)
	{
	 if (param = "")
		 Return %function%()

	 fp:=[]
	 Loop, parse, param, CSV
		fp.push(A_LoopField)
	 if (fp.length() = 1)
		PluginFunctionReturn:=%function%(fp[1])
	 else if (fp.length() = 2)
		PluginFunctionReturn:=%function%(fp[1],fp[2])
	 else if (fp.length() = 3)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3])
	 else if (fp.length() = 4)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4])
	 else if (fp.length() = 5)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5])
	 else if (fp.length() = 6)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6])
	 else if (fp.length() = 7)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7])
	 else if (fp.length() = 8)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8])
	 else if (fp.length() = 9)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9])
	 else if (fp.length() = 10)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10])
	 else if (fp.length() = 11)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10],fp[11])
	 else if (fp.length() = 12)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10],fp[11],fp[12])
	 else if (fp.length() = 13)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10],fp[11],fp[12],fp[13])
	 else if (fp.length() = 14)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10],fp[11],fp[12],fp[13],fp[14])
	 else if (fp.length() = 15)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10],fp[11],fp[12],fp[13],fp[14],fp[15])
	 else if (fp.length() = 16)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10],fp[11],fp[12],fp[13],fp[14],fp[15],fp[16])
	 else if (fp.length() = 17)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10],fp[11],fp[12],fp[13],fp[14],fp[15],fp[16],fp[17])
	 else if (fp.length() = 18)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10],fp[11],fp[12],fp[13],fp[14],fp[15],fp[16],fp[17],fp[18])
	 else if (fp.length() = 19)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10],fp[11],fp[12],fp[13],fp[14],fp[15],fp[16],fp[17],fp[18],fp[19])
	 else if (fp.length() = 20)
		PluginFunctionReturn:=%function%(fp[1],fp[2],fp[3],fp[4],fp[5],fp[6],fp[7],fp[8],fp[9],fp[10],fp[11],fp[12],fp[13],fp[14],fp[15],fp[16],fp[17],fp[18],fp[19],fp[20])
	 else if (fp.length() > 20)
		PluginFunctionReturn:="-Lintalist Function call: TO MANY PARAMETERS-"
	 Return PluginFunctionReturn
	}

BuiltInVariables()
	{
	 global AutoHotkeyVariables,clip
	 loop, parse, AutoHotkeyVariables, CSV
		clip:=StrReplace(clip,"[[" A_LoopField "]]",%A_LoopField%)
	}
