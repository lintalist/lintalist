/*
[info]
Name=CSV to Lintalist format converter
Version=1.0
*/

intro=
(
Enter the columns for each section.

You can place multiple columns in one  
section (Part1 and Part2), seperate by a comma.
)

SetBatchLines, -1
Text=Select a CSV file
Mask=*.csv
#include _GetSourceFile.ahk

Spacer:=A_Space
TrimR:=StrLen(Spacer)

; ------------------------------------------------------------

Gui, Add, Text, readonly w240 h60, %intro% 

Gui, Add, Text,, Delimiter
Gui, Add, Edit, w150 vDelimiter,`,
Gui, Add, Text,, Column(s) for Part1 (for example: 1 or 3,9):
Gui, Add, Edit, w150 vPart1Col

Gui, Add, Text,, Column(s) for Part2 (for example: 4 or 2,6):
Gui, Add, Edit, w150 vPart2Col

Gui, Add, Text,,Column for Shortcut (Hotkey):
Gui, Add, Edit, w150 vKeyCol

Gui, Add, Text,,Column for Shorthand (Hotstring):
Gui, Add, Edit, w150 vShortCol

Gui, Add, Button,w150 yp+40, OK
Gui, Show
Return

ButtonOK:
Gui, Submit, Hide

Loop, parse, list, `n, `r
	{
	 If (A_LoopField = "")
		Continue
	 Rows:=ReturnDSVArray(A_LoopField, "Field", Delimiter)

	 Loop, % Rows
		{
		 If A_Index in %ShortCol%
			Short .= Field%A_Index% Spacer
		 If A_Index in %KeyCol%
			Key .= Field%A_Index% Spacer
		 If A_Index in %Part1Col%
			Part1 .= Field%A_Index% Spacer
		 If A_Index in %Part2Col%
			Part2 .= Field%A_Index% Spacer
		}
	 StringTrimRight, Short, Short, %TrimR%
	 StringTrimRight, Key, Key, %TrimR%
	 StringTrimRight, Part1, Part1, %TrimR%
	 StringTrimRight, Part2, Part2, %TrimR%
	 append=
(
- LLPart1: %part1%
  LLPart2: %part2%
  LLKey: %key%
  LLShorthand: %short%
  LLScript: 
  
)
	 Output .= Append
	 Short=
	 Key=
	 Part1=
	 Part2=
	}	

; ------------------------------------------------------------

#include _SaveBundleFile.ahk

GuiEscape:
ExitApp
Return


;#################################################################################################################### 
; Delimiter Seperated Values by DerRaphael
; http://www.autohotkey.com/forum/post-203280.html#203280
;
; Proof of Concept to extract DSV (Delimiter Seperator Values)
;      - adapted for AHK by derRaphael / 21st July 2008 -
;                           derRaphael@oleco.net
; Following rules apply:
;   You have to set a delimiter char and an encapsulation char.
;   1) If you're using the delimeter char within your value, the value has
;      to be surrounded by your encapsulation char. One at beginning and one
;      at its end.
;   2) If you're using your encapsulation char within your value you have to
;      double it each time it occurs and surround your value as in rule 1.
; Remarks:
;   The whole concept will break, when using same EOL (End Of Line) as LineBreaks
;   in a value as in the entire file. Either you will have to escape these chars
;   somehow or use a single linefeed (`n) in values and carriage return linefeed
;   (`r`n) as EOL in your DSV file.
;   Encapsulation and delimiter chars have to be single Chars. Strings containing
;   more than one char are not supported by concept.
;CurrentDSVLine=a,b,c,"d,e","f"","",g",,i
;
;Loop, % ReturnDSVArray(CurrentDSVLine)
;   MsgBox % A_Index ": " DSVfield%A_Index%

ReturnDSVArray(CurrentDSVLine, ReturnArray="DSVfield", Delimiter=",", Encapsulator="""")
{
   global
   if ((StrLen(Delimiter)!=1)||(StrLen(Encapsulator)!=1))
   {
      return -1                             ; return -1 indicating an error ...
   }
   SetFormat,integer,H                      ; needed for escaping the RegExNeedle properly
   local d := SubStr(ASC(delimiter)+0,2)    ; used as hex notation in the RegExNeedle
   local e := SubStr(ASC(encapsulator)+0,2) ; used as hex notation in the RegExNeedle
   SetFormat,integer,D                      ; no need for Hex values anymore

   local p0 := 1                            ; Start of search at char p0 in DSV Line
   local fieldCount := 0                    ; start off with empty fields.
   CurrentDSVLine .= delimiter              ; Add delimiter, otherwise last field
   ;                                          won't get recognized
   Loop
   {
      Local RegExNeedle := "\" d "(?=(?:[^\" e "]*\" e "[^\" e "]*\" e ")*(?![^\" e "]*\" e "))"
      Local p1 := RegExMatch(CurrentDSVLine,RegExNeedle,tmp,p0)
      ; p1 contains now the position of our current delimitor in a 1-based index
      fieldCount++                         ; add count
      local field := SubStr(CurrentDSVLine,p0,p1-p0)
      ; This is the Line you'll have to change if you want different treatment
      ; otherwise your resulting fields from the DSV data Line will be stored in AHK array
      if (SubStr(field,1,1)=encapsulator)
      {
       ; This is the exception handling for removing any doubled encapsulators and
       ; leading/trailing encapsulator chars
       field := RegExReplace(field,"^\" e "|\" e "$")
       StringReplace,field,field,% encapsulator encapsulator,%encapsulator%, All
      }
      Local _field := ReturnArray A_Index  ; construct a reference for our ReturnArray name
      %_field% := field                    ; dereference _field and assign our value to it
      if (p1=0)
      {                                    ; p1 is 0 when no more delimitor chars have been found
         fieldCount--                      ; so correct fieldCount due to last appended delimitor
         Break                             ; and exit loop
      } Else
         p0 := p1 + 1                      ; set the start of our RegEx Search to last result
   }                                       ; added by one
   return fieldCount
}

Esc::
GuiClose:
GuiEsc:
ExitApp