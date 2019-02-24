/*
LintaList Include
Purpose: Statistics
Version: 1.0

History:
1.0 Initial version 20181210

*/

Statistics()
	{
	 global Stats,Statistics
	 Stats:={}
	 ini=%A_ScriptDir%\Statistics.ini
	 If (Statistics = 2)
		Stats["StatsUser"]:="-" A_UserName
	 IfNotExist, %ini%
		StatisticsIni(ini)
	 globalkeys:="SearchGui,SearchGuiCancel,QuickSearch,OmniSearch,SnippetShortcut,SnippetShorthand,Scripts,TotalBytes"
	 loop, parse, globalkeys, CSV
		{
		 IniRead, key, %ini%, % "Global" Stats["StatsUser"], %A_LoopField%, 0
		 Stats[A_LoopField]:=key
		}
	 ; IniRead, OutputVarSection, Filename, Section
	 IniRead, Sections, %ini%, % "Bundles" Stats["StatsUser"]
	 Loop, parse, Sections, `n, `r
		{
		 k:=StrSplit(A_LoopField,"=")
		 Stats[k[1]]:=k[2]
		 k:=""
		}

	 Stats["globalkeys"]:=globalkeys
	 Stats["ini"]:=ini
	 ; save stats every 2 hours, we may loose some data in case of crash ...
	 SetTimer, StatisticsSaveTimer, % 1000*7200
	}

Stats(key,add=1)
	{
	 global Stats
	 if !Stats.haskey(key)
		Stats[key]:=0
	 Stats[key]+=add
	 return 1
	}

StatisticsSave()
	{
	 global Stats
	 loop, parse, % stats.globalkeys, CSV
		;IniWrite, Value, Filename, Section, Key
		IniWrite, % stats[A_LoopField], % stats.ini, % "Global" Stats["StatsUser"], %A_LoopField%
	 for k, v in Stats
		{
		 if (k = "") or (v = "")
			continue
		 if k in % stats.globalkeys ",ini,globalkeys,StatsUser"
			continue
		 IniWrite, %v%, % stats.ini, % "Bundles" Stats["StatsUser"], % k
		}
	}

StatisticsReport()
	{
	 global Stats,Statistics
	 StatisticsSave()

htmlbodyglobal=
(
<h3>Global</h3>
<table>
<tr bgcolor='#c0c0c0'>
<th>Action</th>
<th>Usage</th>
</tr>
[[data]]
</table>
)

htmlbodybundle=
(
<h3>Bundle</h3>
<table id=myTable>
<tr bgcolor='#c0c0c0'>
<th onclick="sortTableA(0,'myTable')">Bundle <span class='widget'>&varr;</span></th>
<th onclick="sortTableA(1,'myTable')">Action <span class='widget'>&varr;</span></th>
<th onclick="sortTableN(2,'myTable')">Usage  <span class='widget'>&darr;</span></th>
</tr>
[[data]]
</table>
)


IniRead, SectionNames, % stats["ini"]

StatsUser:="-" A_UserName

If (Statistics = 2) ; start off with current user
	SectionNames:="Global" StatsUser "`nBundles" StatsUser "`n" RegExReplace(SectionNames "`n","im)(Global|Bundles)" StatsUser "`r?`n")

FileRead, html, docs\stats-template.html
If ErrorLevel
	MsgBox, 16, Template missing, Can not read "docs\stats-template.html"`nSeems to be missing?`n(Overview will be empty)

htmlstats:=""

Loop, parse, SectionNames, `n, `r
	{
	 currentuser:=0	
	 if (A_Index < 3)
		currentuser:=1
	 if InStr(A_LoopField,"global")
		htmlstats .= StatisticsReportTable(A_LoopField,htmlbodyglobal,,currentuser) "`n"
	 else
		htmlstats .= StatisticsReportTable(A_LoopField,htmlbodybundle,A_Index,currentuser) "`n"
	}

title:="<h2>Lintalist Statistics - " A_YYYY "-" A_MM "-" A_DD "</h2>`n" 

html:=StrReplace(html,"[[data]]",title htmlstats)

FileDelete, %A_ScriptDir%\stats.html
Sleep, 500
FileAppend, %html%, %A_ScriptDir%\stats.html
Run, %A_ScriptDir%\stats.html
html:="",htmlstats:="",title:=""
Return
	}

StatisticsReportTable(section,htmlbody,Index:="",currentuser:=0)
	{
	 global stats

	 If InStr(section,"global")
		{
		 loop, parse, % stats.globalkeys, CSV
			{
			 IniRead, Output, % stats["ini"], %section%, %A_LoopField%
			 data .= "<tr><td>" A_LoopField "</td><td>" Output "</td></tr>`n"
			}
		 htmlbody:=StrReplace(htmlbody,"[[data]]",data)
		 htmlbody:=StrReplace(htmlbody,"<h3>Global</h3>","<h3>" section "</h3>")
		 if currentuser
			htmlbody:=StrReplace(htmlbody,"<h3>","<h3 class='currentuser'>")
		 return htmlbody
		}

	 If InStr(section,"bundle")
		{
		 IniRead, OutputVarSection, % stats["ini"], %Section%

		 Sort, OutputVarSection

		 Loop, parse, OutputVarSection, `n ,`r
			{
			 StringSplit, key, A_LoopField, =

			 key1:=StrReplace(key1,"__total",", total</td><td>")
			 key1:=StrReplace(key1,"__viasearch__no-short-defined",", via search</td><td><i>undefined</i>")
			 key1:=StrReplace(key1,"__viasearch__",", via search</td><td>")
			 key1:=StrReplace(key1,"__viasearch",", via search</td><td>")
			 key1:=StrReplace(key1,"__viashortcut__",", via shortcut</td><td>")
			 key1:=StrReplace(key1,"__viashorthand__",", via shorthand</td><td>")

			 if InStr(key1,"via shortcut")
			 	key1:=StatisticsKbd(key1)

			 data .= "<tr><td>" key1 "</td><td>" key2 "</td></tr>`n"
			}

		 htmlbody:=StrReplace(htmlbody,"[[data]]",data)
		 htmlbody:=StrReplace(htmlbody,"myTable","myTable" Index)
		 htmlbody:=StrReplace(htmlbody,"<h3>Bundle</h3>","<h3>" section "</h3>")
		 if currentuser
			htmlbody:=StrReplace(htmlbody,"<h3>","<h3 class='currentuser'>")
		 return htmlbody	 
		}
	}

StatisticsKbd(in)
	{
	 RegExMatch(in,"iU)\>\K([^>]*)$",shortcut)
	 loop, parse, shortcut
	 	kbdtag .= "<kbd>" A_LoopField "</kbd>"
	 in:=StrReplace(in,shortcut,kbdtag)
	 return in
	}

; create ini if not present, that way we don't overwrite any user changes in future updates
StatisticsIni(ini)
	{
global Stats
StatsUser:=Stats["StatsUser"]
FileAppend,
(
; ------------------------------------------------------------------------------------------
; Lintalist Usage Statistics
; Discussion: https://github.com/lintalist/lintalist/issues/112
; ------------------------------------------------------------------------------------------

[Global%StatsUser%]
SearchGui=0
SearchGuiCancel=0
SnippetShortcut=0
SnippetShorthand=0
Scripts=0
OmniSearch=0
TotalBytes=0

)
, %ini%, UTF-16
	}

StatisticsSaveTimer:
If !Statistics
	return
StatisticsSave()
Return