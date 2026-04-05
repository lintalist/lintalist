; Source Lexikos @ https://github.com/Lexikos/xHotkey.ahk/blob/master/Lib/HotkeyNormalize.ahk
; MsgBox % HotkeyNormalize("+^!s") ":" HotkeyNormalize("!+^s") ":" HotkeyNormalize("+!^s") ; ^!+s

HotkeyNormalize(Hotkey, ByRef UseHook:="", ByRef HasTilde:="", Excp:=-1) {
    if p := InStr(Hotkey, " & ") {
        return HotkeyNormalize(RTrim(SubStr(Hotkey, 1, p)),,, -2) " & "
            .  HotkeyNormalize(LTrim(SubStr(Hotkey, p+3)),,, -2)
    }
    
    Hotkey := RegExReplace(Hotkey, "i)[ `t]up$", "", isKeyUp, 1)
    
    if !p := RegExMatch(Hotkey, "^[~$*<>^!+#]*\K(\w+|.)$")
        throw Exception("Invalid hotkey", Excp, Hotkey)
    
    mods := SubStr(Hotkey, 1, p-1)
    
    if UseHook := InStr(mods, "$") != 0
        mods := StrReplace(mods, "$")
    if HasTilde := InStr(mods, "~") != 0
        mods := StrReplace(mods, "~")
    
    static allMods := StrSplit("* <^ <! <+ <# >^ >! >+ ># ^ ! + #", " ")
    sortedMods := ""
    if mods
        for _, aMod in allMods
            if InStr(mods, aMod)
                sortedMods .= aMod, mods := StrReplace(mods, aMod)
    
    key := SubStr(Hotkey, p)
    if key ~= "i)^(.$|vk|sc)"
        key := StrLower(key)
    else if n := GetKeyName(key)
        key := n
    else
        throw Exception("Unknown key", Excp, key)
    return sortedMods . key . (isKeyUp ? " up" : "")
}

; https://github.com/Lexikos/xHotkey.ahk/blob/master/Lib/
StrLower(String) {
    StringLower String, String
    return String
}

/*
; https://github.com/Lexikos/xHotkey.ahk/blob/master/Lib/
StrReplace(Input, SearchText, ReplaceText:="", ByRef OutputVarCount:="", Limit:="") {
    ErrLvl := ErrorLevel
    if (Limit != 1 && Limit != "")
        throw Exception("Limit must be 1 or omitted in v1", -1, Limit)
    if IsByRef(OutputVarCount) && Limit != ""
        throw Exception("OutputVarCount cannot be used with Limit in v1", -1)
    StringReplace Output, Input, %SearchText%, %ReplaceText%, % Limit=1 ? "" : "UseErrorLevel"
    OutputVarCount := ErrorLevel,  ErrorLevel := ErrLvl
    return Output
}
*/