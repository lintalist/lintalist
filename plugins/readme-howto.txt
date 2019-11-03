HOW TO WRITE A PLUGIN FOR LINTALIST BUNDLES/SNIPPETS
(and functions)

# Introduction

A Lintalist plugin is basically a AutoHotkey script which is included
in the main Lintalist script at startup. You can learn more about AutoHotkey
at http://www.autohotkey.com/ - there you will find an introduction,
tutorials, full documentation and support forum to get you started.

# General information

Call a plugin from a snippet by using [[PLUGINNAME=parameter(s)]]

You can not use [[]] in a plugins' name or in the parameters as it will
most likely fail. If you want to pass on multiple parameters, using a
vertical bar or pipe (|) as separator is recommended.

Note:
You can start with a template: copy the file "template.plugin"
to a new ahk file and start from there.

# PLUGIN SPECS

A Plugin script-file must have the following characteristics:

## 1 - A label such as GetSnippetPLUGINNAME:

The label has to start with GetSnippet followed by PLUGINNAME, 
where PLUGINNAME is both the filename of the script (minus 
the .ahk extenstion) and the code you will use in the snippets
to call your plugin. These are always wrapped in [[]] as in [[pluginname=]]
See note above or the "Interactive bundle text" section in the
Lintalist documentation (docs\index.html)

Example, from input.ahk:

Label:              GetSnippetInput:
Filename of plugin: Input.ahk
Snippet code        [[Input=...]]

## 2 - #Include your plugin script

Once you've written your plugin, you need to add it to MyPlugins.ahk
and #include your ahk file, example:

#Include %A_ScriptDir%\plugins\input.ahk

Now you can call your Plugin from a snippet by using 
[[PLUGINNAME=parameter(s)]]. 
Reload Lintalist to ensure your Plugin is active. 
If there is an error in your Plugin you can always
remove it again from MyPlugins.ahk and the plugins
directory.

Finally, study the existing plugins. File.ahk, Input.ahk 
and DateTime.ahk are among the easier examples. 
Don't forget to post on the forum if you've written a
plugin, have any suggestions and/or requests. Have fun!

## 3 - Example (by FanaticGuru @ https://autohotkey.com/boards/viewtopic.php?p=182346#p182346)

/* 
Plugin   : Example
Purpose  : Add two options separated by | together
Version  : 1.0
Author   : You
*/

; In the snippet the [[Example]] Plugin below will pass on two options which
; will be joined as one word, the snippet looks like this: 
; Hello I will join two words: [[Example=Linta|list]]

GetSnippetExample:            ; GetSnippet is Standard followed by {Plugin File Name} (here Example)
Loop                          ; Standard Loop for All Plugins
	{
	 If (InStr(Clip, "[[Example=") = 0) or (A_Index > 100) ; Standard  Break condition for All Plugins, replace "Example" with {Plugin File Name}
		Break

	 ; Reminder:
	 ; Clip, PluginOptions, PluginText and ProcessTextString are set in Lintalist mainscript (ProcessText label)
	 ; we can use these to process the plugin and any options/parameters passed onto the plugin
	 ; Here:
	 ; Clip is set to: Hello I will join two words: [[Example=Linta|list]]
	 ; PluginText and ProcessTextString are set to: [[Example=Linta|list]]
	 ; PluginOptions is set to: Linta|list

	 PluginX := StrSplit(PluginOptions,"|").1 + StrSplit(PluginOptions,"|").2 ; Access options divided by | to add two options together
	 StringReplace, clip, clip, %PluginText%, %PluginX%, All                  ; Insert User Defined Variable into Lintalist Clip in place of Plugin Markup
	 
	 PluginX:=""           ; Clear User Defined Variable
	 PluginOptions:=""     ; Clear Standard Plugin Variable
	 PluginText:=""        ; Clear Standard Plugin Variable
	 ProcessTextString:="" ; Clear Standard Plugin Variable
	}
Return

# Functions - [v1.9.4+]

Functions should return a value which is then placed in the snippet at the location(s) of the
function call.

A simple snippet like this:

Hello, your name spelled backwards is: [[MyFunc([[Input=Your Name?]])]]

-> MyFunc is called which returns a string, and it replaces [[MyFunc([[Input=Your Name?]])]]

MyFunc in #include-d or part of plugins\MyFunctions.ahk

MyFunc(in)
   {
    Loop, Parse, in
  		result=%A_LoopField%result%
    Return result
   }

If you want to update the entire snippet and not simply process the returned value from
a function you need to make clip a global variable in your function.

MyFunc(parameters)
   {
    global clip ; make clip global
    ; ... your code
    ; ... changing clip
    Return
   }

