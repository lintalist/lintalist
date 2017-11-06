; LintaList Include
; Purpose: Set and Toggle values for GUI (width, height and position of controls)
; Version: 1.0.5
; Date:    20171106

GuiStartupSettings:

DPIFactor:=Round(DPIFactor())

if (Width = CompactWidth + 200) ; special case for BigIcons = 2 and DPIFactor = 1,  perhaps better to store GuiView state in ini
	GuiView:="Narrow"
else if (Width > CompactWidth) 
	GuiView:="Wide"
else if (Width <= CompactWidth)
	GuiView:="Narrow"

If (BigIcons = 1)
	{
	 SearchBoxWidth:=CompactWidth-30  ; Searchbox Width
	 SearchBoxHeight:=20
	 SearchFontSize:=8
	 ;ButtonBarPosX:=0
	 ButtonBarPosY:=0
	 IconSize:=16
	 SearchIconSize:=16
	 SearchBoxX:=9+IconSize
	 SearchBoxY:=2
	 xBarPos:=330
	}
else If (BigIcons = 2)
	{
	 SearchBoxWidth:=CompactWidth-70  ; Searchbox Width
	 SearchBoxHeight:=28
	 SearchFontSize:=12
	 ;ButtonBarPosX:=0
	 ButtonBarPosY:=20
	 IconSize:=32
	 If (DPIFactor = 1)
		SearchIconSize:=32
	 else
		SearchIconSize:=24
	 SearchBoxX:=9+IconSize
	 SearchBoxY:=6
	 xBarPos:=550
	}

VisibleRows:=Ceil(LVHeight/20)  ; TODO: Calculate correct value for 20 for pagedown/pageup as is just a rough guess

YCtrlNarrow:=30+(ButtonBarPosY/DPIFactor)  ; Y pos of controls (now only custom button bar controls)
YLViewNarrow:=YCtrlNarrow+30+(ButtonBarPosY/DPIFactor) ; Y pos of Listview (e.g. bundle/search results)

WidthNarrow:=CompactWidth
HeightNarrow:=CompactHeight

YCtrlWide:=1
If (BigIcons = 2)
	YCtrlWide:=10
YLViewWide:=YCtrlWide+30+(ButtonBarPosY/DPIFactor) ; Y pos of Listview (e.g. bundle/search results)

WidthWide:=WideWidth
HeightWide:=WideHeight

If (DPIFactor = 1) and (BigIcons = 2)
	{
	 WidthNarrow:=CompactWidth+200
	 WidthWide:=WideWidth+200
	 YCtrlWide:=1
	}

Gosub, GuiSetValues

Return

GuiToggleSettings:

if (GuiView = "Wide")
	GuiView:="Narrow"
else
	GuiView:="Wide"

Gosub, GuiSetValues

Return

GuiSetValues:

YCtrl:=YCtrl%GuiView%
YLView:=YLView%GuiView%
Width:=Width%GuiView%
Height:=Height%GuiView%
;:=%GuiView%
;:=%GuiView%

barx:=Width-xBarPos

if (barx < 0) ; just in case
	 barx:=1

LVWidth:=Width-2                                 ; Listview Width
LVHeight:=Height-PreviewHeight-72-ButtonBarPosY  ; Listview Height

if (GuiView = "Wide") and (BigIcons = 1)
	LVHeight+=15
else if (GuiView = "Narrow") and (BigIcons = 1)
	LVHeight-=10
else if (GuiView = "Wide") and (BigIcons = 2)
	LVHeight+=5
else if (GuiView = "Narrow") and (BigIcons = 2)
	LVHeight-=30

Return