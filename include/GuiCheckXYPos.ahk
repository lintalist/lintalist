; this should be redundant but apparently something can still go wrong so we're going to do it anyway
; https://github.com/lintalist/lintalist/issues/121

GuiCheckXYPos()
	{
	 Global
	 for k, v in GuiCheckXYPos
		{
		 if RegExMatch(%k%,"[[:^digit:]]") or (%k% = "")
			%k%:=GuiCheckXYPos[k]
		}
	 Return
	}
