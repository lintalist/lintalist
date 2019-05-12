/*
#include to save bundle after conversion
*/


Gui, 71:Add, Text, x20   y40         , Name:
Gui, 71:Add, Edit, xp+80 y40 w400 h20 vName, %OutNameNoExt% ; Add file name without extention

Gui, 71:Add, Text, x20   y70     , Description:
Gui, 71:Add, Edit, xp+80 y70 w400 h20 vDescription,

Gui, 71:Add, Text, x20   y100     , Author:
Gui, 71:Add, Edit, xp+80 y100 w400 h20 vAuthor,

Gui, 71:Add, Text, x20   y130     , TitleMatch:
Gui, 71:Add, Edit, xp+80 y130 w400 h20 vTitleMatch,

Gui, 71:Add, Text, x20   y160     , File name:
Gui, 71:Add, Edit, xp+80 y160 w400 h20 vFilename, %OutDir%

Gui, 71:Add, Button, x20    y190 h25 w210 g71Save, Save
Gui, 71:Add, Button, xp+245 y190 h25 w210 g71GuiClose, Cancel
   
Gui, 71:Show, AutoSize Center, Lintalist Convertor
Return

71Save:
Gui, Submit, NoHide
If (Name = "") or (Filename = "") or (Filename = OutDir)
   {
    MsgBox, 48, New Bundle not saved, Name or File name missing.
    Return
   }
IfNotInstring, Filename, .txt
      FileName .= ".txt"

FileEncoding, UTF-8

FileAppend,
(
BundleFormat: 1
Name: %Name%
Description: %Description%
Author: %Author%
TitleMatch: %TitleMatch%
Patterns:
%Output%

), %Filename%, UTF-8
MsgBox, 64, New Bundle saved, Bundle saved as:`n%Filename%
ExitApp
Return

71GuiClose:
ExitApp
Return
