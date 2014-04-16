; LintaList Include [could be used elsewhere]
; Purpose: Get X, Y, Coordinates while keeping Gui ON active monitor
; Version: 1.0
; Date:    20101010

; called as XY:=StayOnMonXY(Width, Height, 0, 1, 1) 

StayOnMonXY(GW, GH, Mouse = 0, MouseAlternative = 1, Center = 0) 
	{
	 ; GW = gui width
	 ; GH = gui heigth
	 ; Mouse = 1 or 0. If 1 use the mouse cursor
	 ; MouseAlternative = 1 or 0. If caret fails use mouse as an alternative
	 ; Center = 1 always center, 0 don't center
	 
	 CoordMode, Caret, Screen
	 SysGet, MonitorCount, MonitorCount ; get number of monitors
	 Loop, %MonitorCount%
		{
		 SysGet, Monitor, Monitor, %A_Index%
		 MonitorMaxRight%A_Index% := MonitorRight
		}

	 If (Center = 1)
	   {
		X := (A_ScreenWidth - GW) / 2
		Y := (A_ScreenHeight - GH) / 2
	    Return X . "|" . Y
	  }

	 If ((Mouse = 0) OR (Mouse = "")) 
		{
		 X := A_CaretX ; get x & y via caret pos
		 Y := A_CaretY
		 If ((X = 0) AND (Y = 0) AND (MouseAlternative = 1)) ; if caret fails + use Mouse
			MouseGetPos, X, Y
 		 If ((X = 0) AND (Y = 0) AND (MouseAlternative = 0)) ; if caret fails + don't use mouse find center of first monitor
			{
			 X := (A_ScreenWidth - GW) / 2
			 Y := (A_ScreenHeight - GH) / 2
			}
		}
	 Else If (Mouse = 1) 
		 MouseGetPos, X, Y

	 If ( Y + GH + 60 > A_ScreenHeight ) ; fix Y pos later, not as important, will need monitor bottom vars.
		Y := A_ScreenHeight - GH - 60

	 If (MonitorCount = 1) ; single monitor
		{
		 If ( X + GW > A_ScreenWidth )
			X := A_ScreenWidth - GW
		}
	 Else
		{
		 If ( X > MonitorMaxRight1 AND X + GW > MonitorMaxRight2  ) ; 2nd monitor at right pos.
				X := MonitorMaxRight2 - GW

		 If ( X > 0 AND X < MonitorMaxRight1 ) ; caret is found on first monitor
			{
			 If ( X + GW > MonitorMaxRight1 ) ; gui would be out of view of 1st monitor
				X := MonitorMaxRight1 - GW - 10
			}

		 If ( X < 0 ) ; 2nd monitor at left pos.
			{
				If ( X + GW > 0 ) ; gui would overflow to 1st monitor
				X := 0 - GW
			}
		}
	 If (X = 0)
		X = 10
	 If Y between -5 and 0
		Y = 10
	 Return X . "|" . Y
	}
