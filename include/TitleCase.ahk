/*

Function   : TitleCase()
Purpose    : Title case (capital case, headline style), example
             "The Quick Brown Fox Jumps over the Lazy Dog"
             A mixed-case style with all words capitalised, except for certain subsets
             -- https://en.wikipedia.org/wiki/Letter_case#Title_case
Version    : 1.41
Source     : https://github.com/lintalist/TitleCase
License    : See license.txt for further details (GPL-2.0)

History:
v1.41 - removed static
v1.4 - replaced pairs object by simple list (ensures order of processing as listed in INI)
v1.3 - additional Find/Replace via INI setup - moved v1.2 to INI  
       read language section in one go
v1.2 - adding RegExReplace() to address 1st 2nd 3rd 4th etc
v1.1 - adding readme.md doc, minor mods to default LowerCaseList
v1.0 - initial version

Documentation see readme.md @ https://github.com/lintalist/TitleCase

*/

TitleCase(Text,lang="en",ini="TitleCase.ini")
	{
	 settings:={}, pairs:=""
	 If !InStr(ini,"\")
		ini:=A_ScriptDir "\" ini
	 IfNotExist, %ini%
		TitleCase_Ini(ini)
	 IniRead, LangSection, %ini%, %lang%
	 Loop, parse, LangSection, `n, `r
		{
		 data:=StrSplit(A_LoopField,"=",2)
		 settings[data[1]]:=data[2]
		 if InStr(data[1],"_")
			{
			 pairdata:=StrSplit(A_LoopField,"_").1
			 If pairdata not in pairs
				pairs .= pairdata ","
			}
		}
	 StringLower, Text, Text, T
	 Text:=TitleCase_LowerCaseList(Text,settings.LowerCaseList)
	 Text:=TitleCase_UpperCaseList(Text,settings.UpperCaseList)
	 Text:=TitleCase_MixedCaseList(Text,settings.MixedCaseList)
	 Text:=TitleCase_ExceptionsList(Text,settings.ExceptionsList)
	 pairs:=trim(pairs,",")
	 loop, parse, pairs, CSV
		{
		 find:=settings[A_LoopField "_find"]
		 replace:=settings[A_LoopField "_replace"]
		 Text:=RegExReplace(Text,find,replace)
		}
	 Text:=TitleCase_AlwaysLowerCaseList(Text,settings.AlwaysLowerCaseList)

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
OrdinalIndicator_Find=im)\b(\d+)(st|nd|rd|th)\b
OrdinalIndicator_Replace=$1$L{2}
Hypen1_Find=im)-\K(.)
Hypen1_Replace=$U{1}
Hypen2_Find=im)-(and|but|for|nor|of|or|so|yet)-
Hypen2_Replace=-$L{1}-
)
, %ini%, UTF-16
	}
