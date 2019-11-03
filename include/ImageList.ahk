; used in lintalist.ahk and objectbundles.ahk

If (ShowIcons = 1)
	{
	 IL_Destroy(ImageListID1)
	 ; Create an ImageList so that the ListView can display some icons:
	 ImageListID1 := IL_Create(100, 10)
	 ; Attach the ImageLists to the ListView so that it can later display the icons:
	 LV_SetImageList(ImageListID1)
	}

IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 ".ico")       ; assign texticon   Icon1
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 ".ico")       ; assign scripticon Icon2
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML.ICO")  ; html/md icon
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF.ICO")   ; rtf icon
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image.ICO") ; image icon
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML.ICO")  ; html/md icon
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF.ICO")   ; rtf icon
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image.ICO") ; image icon

IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_1.ico")         ; texticon overlay 1 = Icon9
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_2.ico")         ; texticon overlay 2 = Icon10
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_3.ico")         ; texticon overlay 3 = 11
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_4.ico")         ; texticon overlay 4 = 12
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_5.ico")         ; texticon overlay 5 = 13
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_6.ico")         ; texticon overlay 6 = 14
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_7.ico")         ; texticon overlay 7 = 15
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_8.ico")         ; texticon overlay 8 = 16
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_9.ico")         ; texticon overlay 9 = 17
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_10.ico")        ; texticon overlay 0 = 18

IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_1.ico")         ; scripticon overlay 1 = 19 ; script
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_2.ico")         ; scripticon overlay 2 = 20
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_3.ico")         ; scripticon overlay 3 = 21
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_4.ico")         ; scripticon overlay 4 = 22
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_5.ico")         ; scripticon overlay 5 = 23
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_6.ico")         ; scripticon overlay 6 = 24
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_7.ico")         ; scripticon overlay 7 = 25
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_8.ico")         ; scripticon overlay 8 = 26
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_9.ico")         ; scripticon overlay 9 = 27
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_10.ico")        ; scripticon overlay 0 = 28

IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML_1.ico")    ; htmlicon overlay 1 = 29 
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML_2.ico")    ; htmlicon overlay 2 = 30
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML_3.ico")    ; htmlicon overlay 3 = 31
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML_4.ico")    ; htmlicon overlay 4 = 32
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML_5.ico")    ; htmlicon overlay 5 = 33
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML_6.ico")    ; htmlicon overlay 6 = 34
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML_7.ico")    ; htmlicon overlay 7 = 35
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML_8.ico")    ; htmlicon overlay 8 = 36
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML_9.ico")    ; htmlicon overlay 9 = 37
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_HTML_10.ico")   ; htmlicon overlay 0 = 38

IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF_1.ico")     ; rtficon overlay 1 = 39 
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF_2.ico")     ; rtficon overlay 2 = 40
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF_3.ico")     ; rtficon overlay 3 = 41
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF_4.ico")     ; rtficon overlay 4 = 42
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF_5.ico")     ; rtficon overlay 5 = 43
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF_6.ico")     ; rtficon overlay 6 = 44
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF_7.ico")     ; rtficon overlay 7 = 45
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF_8.ico")     ; rtficon overlay 8 = 46
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF_9.ico")     ; rtficon overlay 9 = 47
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_RTF_10.ico")    ; rtficon overlay 0 = 48

IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image_1.ico")   ; imageicon overlay 1 = 49 
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image_2.ico")   ; imageicon overlay 2 = 50
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image_3.ico")   ; imageicon overlay 3 = 51
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image_4.ico")   ; imageicon overlay 4 = 52
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image_5.ico")   ; imageicon overlay 5 = 53
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image_6.ico")   ; imageicon overlay 6 = 54
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image_7.ico")   ; imageicon overlay 7 = 55
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image_8.ico")   ; imageicon overlay 8 = 56
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image_9.ico")   ; imageicon overlay 9 = 57
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon1 "_Image_10.ico")  ; imageicon overlay 0 = 58

IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML_1.ico")    ; htmlicon overlay 1 = 59 
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML_2.ico")    ; htmlicon overlay 2 = 60
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML_3.ico")    ; htmlicon overlay 3 = 61
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML_4.ico")    ; htmlicon overlay 4 = 62
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML_5.ico")    ; htmlicon overlay 5 = 63
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML_6.ico")    ; htmlicon overlay 6 = 64
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML_7.ico")    ; htmlicon overlay 7 = 65
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML_8.ico")    ; htmlicon overlay 8 = 66
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML_9.ico")    ; htmlicon overlay 9 = 67
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_HTML_10.ico")   ; htmlicon overlay 0 = 68

IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF_1.ico")     ; rtficon overlay 1 = 69 
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF_2.ico")     ; rtficon overlay 2 = 70
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF_3.ico")     ; rtficon overlay 3 = 71
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF_4.ico")     ; rtficon overlay 4 = 72
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF_5.ico")     ; rtficon overlay 5 = 73
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF_6.ico")     ; rtficon overlay 6 = 74
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF_7.ico")     ; rtficon overlay 7 = 75
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF_8.ico")     ; rtficon overlay 8 = 76
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF_9.ico")     ; rtficon overlay 9 = 77
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_RTF_10.ico")    ; rtficon overlay 0 = 78

IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image_1.ico")   ; imageicon overlay 1 = 79 
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image_2.ico")   ; imageicon overlay 2 = 80
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image_3.ico")   ; imageicon overlay 3 = 81
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image_4.ico")   ; imageicon overlay 4 = 82
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image_5.ico")   ; imageicon overlay 5 = 83
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image_6.ico")   ; imageicon overlay 6 = 84
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image_7.ico")   ; imageicon overlay 7 = 85
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image_8.ico")   ; imageicon overlay 8 = 86
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image_9.ico")   ; imageicon overlay 9 = 87
IL_Add(ImageListID1, A_ScriptDir . "\Icons\" . Icon2 "_Image_10.ico")  ; imageicon overlay 0 = 88
