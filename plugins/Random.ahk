/* 
Plugin        : Random [Standard Lintalist]
Purpose       : Make a random selection from a list
Version       : 1.2

History:
- 1.2 fix range of numbers 1|10
- 1.1 fix to count correct number of RandomItems (+ 1)
- 1.0 first version - Lintalist v1.8
*/

GetSnippetRandom:
	 Loop
		{
		 If (InStr(Clip, "[[Random=") = 0) or (A_Index > 100)
			Break

		 ; check for numbers
		 RandomItems:=CountString(PluginOptions,"|") + 1
		 RandomStart:=StrSplit(PluginOptions,"|").1
		 RandomEnd:=StrSplit(PluginOptions,"|").2
		 if RandomCheckNumber(RandomStart,RandomEnd)
			 Random, PluginOptions, %RandomStart%, %RandomEnd%
		 Else ; a list
		 	{
			 Random, RandomNumber, 1, %RandomItems%
			 PluginOptions:=StrSplit(PluginOptions,"|")
			 PluginOptions:=PluginOptions[RandomNumber]
		 	}
		 StringReplace, clip, clip, %PluginText%, %PluginOptions%, All
		 RandomStart:=""
		 RandomEnd:=""
		 RandomItems:=""
		 RandomNumber:=""
		 PluginOptions:=""
		 PluginText:=""
		 ProcessTextString:=""
		}
Return

RandomCheckNumber(start,end) {
	check:=0,check1:=0,check2:=0
	if start is number
		check1:=1
	if end is number
		check2:=1
	if 	(check1 + check2 = 2)
		check:=1
	return check
	}
