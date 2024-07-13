# Themes for Lintalist

The Lintalist Search GUI and Snippet Editor can be styled using Themes defined in INI files.

Support will remain somewhat rudimentary. Given the limitations of AutoHotkey in this regard
not all (parts of) the controls and Windows can be styled. There might also be some undesired
flickering or some controls may loose their theme color temporarily.

GUIs used by Plugins are not styled.

Example themes @ https://github.com/lintalist/lintalist-themes (unpack zip file to `lintalist\themes\')

Discussion @ https://github.com/lintalist/lintalist/issues/147

## INI format

You can use one of the 16 primary HTML color names or 6-digit hexadecimal RGB `RRGGBB` format.  
 do not include "0x"), see table https://www.autohotkey.com/docs/commands/Progress.htm#Object_Colors (RGB value)

Notes: 

* If you are using Syntax Highlighting for the Editor the `EditorTextColor` and `EditorBackgroundColor` must be in `RRGGBB` format.
* It is not possible to set the Text color of the statusbar so it will always use the color as defined by the Windows theme.
* Tip: to reduce flickering of the search results listview use the same color for the `MainBackgroundColor` and `ListViewBackgroundColor`

```ini
[settings]
MainBackgroundColor=Black
SearchBoxTextColor=White
SearchBoxBackgroundColor=Black
ListViewTextColor=White
ListViewBackgroundColor=Black
ListViewBackgroundColorAlternateRow=eeeeee
ListViewBackgroundColorSelection=ffcc00,000000
PreviewTextColor=White
PreviewBackgroundColor=Black
EditorGuiTextColor=White
EditorTextColor=FFFFFF
EditorBackgroundColor=000000
; note that it is not possible to set the Text color of the statusbar
StatusBarBackgroundColor=Gray
```

`ListViewBackgroundColorAlternateRow` and `ListViewBackgroundColorSelection` overrule `AlternateRowColor` and `AlternateSelectionColor` set in Configuration.
Color values for these two settings have to be set in 6-digit hexadecimal RGB `RRGGBB` format.  

Additional keys for *Syntax Highlighting* (default settings, you only have to use those keys you wish to change)

`MainColorPunctuation=FFCC00` will change the color of the [[..]] around plugins for example.

Study `include\richcode\AHK.ahk` and `include\richcode\SnippetHTML.ahk` for more info about
these keys (keys are defined by regular expression)

Values must be 6-digit hexadecimal RGB `RRGGBB` format. 

```ini
FGColor=000000
BGColor=FFFFFF

MainColorComments=7F9F7F
MainColorFunctions=7CC8CF
MainColorKeywords=E4EDED
MainColorMultiline=7F9F7F
MainColorNumbers=F79B57
MainColorPunctuation=000088
MainColorStrings=CC9893

AHKColorA_Builtins=F79B57
AHKColorCommands=008800
AHKColorDirectives=7CC8CF
AHKColorFlow=008800
AHKColorFunctions=008800
AHKColorKeyNames=CB8DD9
AHKColorKeywords=CB8DD9

SnippetsColorAttributes=7CC8CF
SnippetsColorEntities=F79B57
SnippetsColorTags=008800
```

## Icons

Alternative icons per theme are also possible. Location `themes\icons\`

Simply add the name of the theme to the icon name like so:

Theme: `Darkmode.ini`

`snippet_new.ico` would be `snippet_new_darkmode.ico` and placed in `themes\icons\`

### Toolbar icons

* snippet_new.ico
* snippet_edit.ico
* snippet_copy.ico
* scripts.ico (Also used in Editor)
* no_scripts.ico
* hotkeys.ico (Also used in Editor)
* no_hotkeys.ico
* shorthand.ico (Also used in Editor)
* no_shorthand.ico
* lettervariations.ico
* unlocked.ico
* case.ico
* search_1.ico
* search_2.ico
* search_3.ico
* search_4.ico
* locked.ico
* pin-to-top.ico

### Listview icons

* TextIcon.ico
* TextIcon_HTML.ico
* TextIcon_Image.ico
* TextIcon_RTF.ico

* ScriptIcon.ico
* ScriptIcon_RTF.ico
* ScriptIcon_Image.ico
* ScriptIcon_HTML.ico

For the `ShortcutSearchGui` setting with Icon overlays (1 to 0) there are additonaly 10 icons per listview type above named _1 to _10:  
TextIcon_1.ico to TextIcon_10.ico

Theme icon examples:

`TextIcon_darkmode.ico`  
`TextIcon_1_darkmode.ico`

## Editor icons

* lintalist_bundle.png
* text_dropcaps.png
