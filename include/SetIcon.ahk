/*

SetIcon()
Return: Icon for listview

Icon1: Default text snippet
Icon2: Default script snippet
Icon3: HTML/MD text snippet
Icon4: RTF text snippet
Icon5: Image text snippet
Icon6: HTML/MD text snippet with script
Icon7: RTF text snippet with script
Icon8: Image text snippet with script
-- See ImageList.ahk for complete list

History:
v1.1 - adding overlay 1-10 result icons for alt_1..0 shortcuts in search result gui
v1.0 - initial version

*/

SetIcon(text,script,ShortCutSearchGui,ShortCutSearchGuiCounter)
	{
	 If (script = "")
		{
		 IconVal := "Icon1"
		 If RegExMatch(text[1] text[2],"i)\[\[html|md\]\]")
			IconVal:="Icon3"
		 If RegExMatch(text[1] text[2],"i)\[\[rtf\=")
			IconVal:="Icon4"
		 If RegExMatch(text[1] text[2],"i)\[\[image\=")
			IconVal:="Icon5"
		}
	 else
		{
		 IconVal := "Icon2"
		 If RegExMatch(text[1] text[2],"i)\[\[html|md\]\]")
			IconVal:="Icon6"
		 If RegExMatch(text[1] text[2],"i)\[\[rtf\=")
			IconVal:="Icon7"
		 If RegExMatch(text[1] text[2],"i)\[\[image\=")
			IconVal:="Icon8"
		}
	 if (ShortCutSearchGui = 1)
		Return IconVal

	 If (IconVal = "Icon1") ; texticon
		{
		 Switch ShortCutSearchGuiCounter
			{
			 default: IconVal:="Icon1"
			 Case  1: IconVal:="Icon9"
			 Case  2: IconVal:="Icon10"
			 Case  3: IconVal:="Icon11"
			 Case  4: IconVal:="Icon12"
			 Case  5: IconVal:="Icon13"
			 Case  6: IconVal:="Icon14"
			 Case  7: IconVal:="Icon15"
			 Case  8: IconVal:="Icon16"
			 Case  9: IconVal:="Icon17"
			 Case 10: IconVal:="Icon18"
			}
		}
	 else If (IconVal = "Icon2") ; scripticon
		{
		 Switch ShortCutSearchGuiCounter
			{
			 default: IconVal:="Icon2"
			 Case  1: IconVal:="Icon19"
			 Case  2: IconVal:="Icon20"
			 Case  3: IconVal:="Icon21"
			 Case  4: IconVal:="Icon22"
			 Case  5: IconVal:="Icon23"
			 Case  6: IconVal:="Icon24"
			 Case  7: IconVal:="Icon25"
			 Case  8: IconVal:="Icon26"
			 Case  9: IconVal:="Icon27"
			 Case 10: IconVal:="Icon28"
			}
		}
	 else If (IconVal = "Icon3") ; htmlicon
		{
		 Switch ShortCutSearchGuiCounter
			{
			 default: IconVal:="Icon3"
			 Case  1: IconVal:="Icon29"
			 Case  2: IconVal:="Icon30"
			 Case  3: IconVal:="Icon31"
			 Case  4: IconVal:="Icon32"
			 Case  5: IconVal:="Icon33"
			 Case  6: IconVal:="Icon34"
			 Case  7: IconVal:="Icon35"
			 Case  8: IconVal:="Icon36"
			 Case  9: IconVal:="Icon37"
			 Case 10: IconVal:="Icon38"
			}
		}
	 else If (IconVal = "Icon4") ; rtficon
		{
		 Switch ShortCutSearchGuiCounter
			{
			 default: IconVal:="Icon5"
			 Case  1: IconVal:="Icon39"
			 Case  2: IconVal:="Icon40"
			 Case  3: IconVal:="Icon41"
			 Case  4: IconVal:="Icon42"
			 Case  5: IconVal:="Icon43"
			 Case  6: IconVal:="Icon44"
			 Case  7: IconVal:="Icon45"
			 Case  8: IconVal:="Icon46"
			 Case  9: IconVal:="Icon47"
			 Case 10: IconVal:="Icon48"
			}
		}
	 else If (IconVal = "Icon5") ; imageicon
		{
		 Switch ShortCutSearchGuiCounter
			{
			 default: IconVal:="Icon5"
			 Case  1: IconVal:="Icon49"
			 Case  2: IconVal:="Icon50"
			 Case  3: IconVal:="Icon51"
			 Case  4: IconVal:="Icon52"
			 Case  5: IconVal:="Icon53"
			 Case  6: IconVal:="Icon54"
			 Case  7: IconVal:="Icon55"
			 Case  8: IconVal:="Icon56"
			 Case  9: IconVal:="Icon57"
			 Case 10: IconVal:="Icon58"
			}
		}
	 else If (IconVal = "Icon6") ; html
		{
		 Switch ShortCutSearchGuiCounter
			{
			 default: IconVal:="Icon6"
			 Case  1: IconVal:="Icon59"
			 Case  2: IconVal:="Icon60"
			 Case  3: IconVal:="Icon61"
			 Case  4: IconVal:="Icon62"
			 Case  5: IconVal:="Icon63"
			 Case  6: IconVal:="Icon64"
			 Case  7: IconVal:="Icon65"
			 Case  8: IconVal:="Icon66"
			 Case  9: IconVal:="Icon67"
			 Case 10: IconVal:="Icon68"
			}
		}
	 else If (IconVal = "Icon7") ; rtfcon
		{
		 Switch ShortCutSearchGuiCounter
			{
			 default: IconVal:="Icon7"
			 Case  1: IconVal:="Icon69"
			 Case  2: IconVal:="Icon70"
			 Case  3: IconVal:="Icon71"
			 Case  4: IconVal:="Icon72"
			 Case  5: IconVal:="Icon73"
			 Case  6: IconVal:="Icon74"
			 Case  7: IconVal:="Icon75"
			 Case  8: IconVal:="Icon76"
			 Case  9: IconVal:="Icon77"
			 Case 10: IconVal:="Icon78"
			}
		}
	 else If (IconVal = "Icon8") ; imageicon
		{
		 Switch ShortCutSearchGuiCounter
			{
			 default: IconVal:="Icon8"
			 Case  1: IconVal:="Icon79"
			 Case  2: IconVal:="Icon80"
			 Case  3: IconVal:="Icon81"
			 Case  4: IconVal:="Icon82"
			 Case  5: IconVal:="Icon83"
			 Case  6: IconVal:="Icon84"
			 Case  7: IconVal:="Icon85"
			 Case  8: IconVal:="Icon86"
			 Case  9: IconVal:="Icon87"
			 Case 10: IconVal:="Icon88"
			}
		}

	 Return IconVal
	}
