/*
#include to open source for new bundle
*/

FileSelectFile, File, 1, %A_ScriptDir%, %Text%, %Mask%
If (ErrorLevel = 1)
   {
    MsgBox, 48, Missing file, No file selected.
    ExitApp
   }
FileRead, list, %file%
SplitPath, file, , OutDir, , OutNameNoExt
OutDir .= "\"
