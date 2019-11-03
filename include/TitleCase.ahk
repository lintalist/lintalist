/*

Function   : TitleCase()
Purpose    : Title case (capital case, headline style), example
             "The Quick Brown Fox Jumps over the Lazy Dog"
             A mixed-case style with all words capitalised, except for certain subsets
             -- https://en.wikipedia.org/wiki/Letter_case#Title_case
Version    : 1.2
Source     : https://github.com/lintalist/TitleCase
License    : See license.txt for further details (GPL-2.0)

History:
v1.2 - adding RegExReplace() to address 1st 2nd 3rd 4th etc
v1.1 - adding readme.md doc, minor mods to default LowerCaseList
v1.0 - initial version

Documentation see readme.md @ https://github.com/lintalist/TitleCase

*/

TitleCase(Text,lang="en",ini="TitleCase.ini")
	{
	 static settings:={}
	 If !InStr(ini,"\")
	 	ini:=A_ScriptDir "\" ini
	 IfNotExist, %ini%
		TitleCase_Ini(ini)
	 inilist=LowerCaseList,UpperCaseList,MixedCaseList,ExceptionsList,AlwaysLowerCaseList
	 loop, parse, inilist, CSV
	 	{
 		 IniRead, key, %ini%, %lang%, %A_LoopField%
 		 If (key = "ERROR")
 		 	key:=""
		 settings[A_LoopField]:=key
	 	}
	 StringLower, Text, Text, T
	 Text:=TitleCase_LowerCaseList(Text,settings.LowerCaseList)
	 Text:=TitleCase_UpperCaseList(Text,settings.UpperCaseList)
	 Text:=TitleCase_MixedCaseList(Text,settings.MixedCaseList)
	 Text:=TitleCase_ExceptionsList(Text,settings.ExceptionsList)
	 Text:=TitleCase_AlwaysLowerCaseList(Text,settings.AlwaysLowerCaseList)
	 Text:=RegExReplace(Text,"im)\b(\d+)(st|nd|rd|th)\b","$1$L{2}") ; for 1st 2nd 3rd 4th etc
	 Text:=RegExReplace(Text,"^(.)","$U{1}") ; ensure first char is always upper case
	 Return Text
	}

TitleCase_LowerCaseList(Text,list)
	{
	 loop, parse, list, CSV
		Text:=RegExReplace(Text, "im)\b" A_LoopField "\b",A_LoopField)
	 Text:=RegExReplace(Text, "im)([’'`])s","$1s") ; to prevent grocer'S
	 Return Text
	}

TitleCase_UpperCaseList(Text,list)
	{
	 loop, parse, list, CSV
		Text:=RegExReplace(Text, "im)\b" A_LoopField "\b",A_LoopField)
	 Return Text
	}

TitleCase_MixedCaseList(Text,list)
	{
	 loop, parse, list, CSV
		Text:=RegExReplace(Text, "im)\b" A_LoopField "\b",A_LoopField)
	 Return Text
	}

TitleCase_ExceptionsList(Text,list)
	{
	 loop, parse, list, CSV
		Text:=RegExReplace(Text, "im)\b" A_LoopField "\b",A_LoopField)
	 Text:=RegExReplace(Text, "im)[\.:;] \K([a-z])","$U{1}") ; first letter after .:; uppercase
	 Return Text
	}
	
TitleCase_AlwaysLowerCaseList(Text,list)
	{
	 loop, parse, list, CSV
		Text:=RegExReplace(Text, "im)\b" A_LoopField "\b",A_LoopField)
	 Return Text
	}

; create ini if not present, that way we don't overwrite any user changes in future updates
TitleCase_Ini(ini)
	{
FileAppend,
(
; -------------------------------------------------------------------------------------------
; TitleCase - https://github.com/lintalist/TitleCase
; ------------------------------------------------------------------------------------------

[en]
LowerCaseList=a,an,and,amid,as,at,atop,be,but,by,for,from,if,in,into,is,it,its,nor,not,of,off,on,onto,or,out,over,past,per,plus,than,the,till,to,up,upon,v,vs,via,with
UpperCaseList=AHK,IBM,UK,USA
MixedCaseList=AutoHotkey,iPod,iPad,iPhone
ExceptionsList=
AlwaysLowerCaseList=

)
, %ini%, UTF-16
	}
