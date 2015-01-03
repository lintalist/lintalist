/*

SetIcon()
Lintalist v1.1
Date: 20150101

Return: Icon for listview

Icon1: Default text snippet
Icon2: Default script snippet
Icon3: HTML/MD text snippet
Icon4: RTF text snippet
Icon5: Image text snippet
Icon6: HTML/MD text snippet with script
Icon7: RTF text snippet with script
Icon8: Image text snippet with script

*/

SetIcon(text,script)
	{
	 If (script = "")
		{
		 IconVal:="Icon1"
		 If RegExMatch(text[1],"\[\[html|md\]\]") or RegExMatch(text[1],"\[\[html|md\]\]")
			IconVal:="Icon3"
		 If RegExMatch(text[1],"\[\[rtf\=")
			IconVal:="Icon4"
		 If RegExMatch(text[1],"\[\[image\=")
			IconVal:="Icon5"
		}
	else
		{
		 IconVal := "Icon2"
		 If RegExMatch(text[1],"\[\[html|md\]\]") or RegExMatch(text[1],"\[\[html|md\]\]")
			IconVal:="Icon6"
		 If RegExMatch(text[1],"\[\[rtf\=")
			IconVal:="Icon7"
		 If RegExMatch(text[1],"\[\[image\=")
			IconVal:="Icon8"
		}
	 Return IconVal	
	}