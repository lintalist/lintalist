HOW TO WRITE A PLUGIN FOR LINTALIST BUNDLES/SNIPPETS

# Introduction

A Lintalist plugin is basically a AutoHotkey script which is included
in the main Lintalist script at startup. You can learn more about AutoHotkey
at http://www.autohotkey.com/ - there you will find an introduction,
tutorials, full documentation and support forum to get you started.

# General information

Call a plugin from a snippet by using [[PLUGINNAME=parameter(s)]]

A regular expression is used to extract the parameters, you can not 
use [[]] in a plugins' name or in the parameters as it will most 
likely fail. If you want to pass on multiple parameters, using a 
vertical bar (|) as separator is recommended.

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

Once you've written your plugin, you need to add it to Plugins.ahk
and #include your ahk file, example:

**#Include %A_ScriptDir%\plugins\input.ahk**

Now you can call your Plugin from a snippet by using 
[[PLUGINNAME=parameter(s)]]. 
Reload Lintalist to ensure your Plugin is active. 
If there is an error in your Plugin you can always
remove it again from plugins.ahk and the plugins
directory.

Finally, study the examples. File.ahk, Input.ahk 
and DateTime.ahk are among the easier examples. 
Don't forget to post on the forum if you've written a
plugin, have any suggestions and/or requests. Have fun!

