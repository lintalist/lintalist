Lintalist for Math is an adaption of Lintalist to easier comment assignments
made in Maple (CAS). Lintalist itself provides searchable interactive lists to
copy & paste text, run scripts, using easily exchangeable bundles.


# Introduction

Lintalist allows you to store and (incrementally) search and edit texts in
bundles and paste a selected text in your active program. The text can be
interactive, for example, you can automatically insert the current time and
date, ask for (basic) user input or make a selection from a list etc.

Lintalist for Math includes the features of Lintalist and adds some extra
features specific to Maple (CAS) to make it easier to comment on assignments
made in Maple.

This text introduces these extra features. Please refer to
<https://github.com/lintalist/lintalist> for a short introduction to the
features of Lintalist. More Lintalist documentation can be found at
<http://lintalist.github.io/>.

### Lintalist for Math specific features (default hotkeys in parentheses)

<dl>
  <dt>Changed Default Trigger Keys</dt>
  <dd>Both the keys "-" and "_" will the Shorthand (abbreviation) if applicable.</dd>
  
  <dt>Setup Maple for Commenting (Win + W)</dt>
  <dd>In Maple, give Maple Input a red color, unfold all sections,
    and set zoom to 100 %.</dd>

  <dt>Improved Pasting to Maple</dt>
  <dd>When pasting to Maple the text will be pasted as Maple Input.
    When the same snippets are pasted to other programs, it will
    be pasted the same way as Lintalist would paste it (i.e. paste pure text).
    </dd>

  <dt>Snippet Helper (Win + H)</dt>
  <dd>Add a new snippet from the selected text (using dialogs).</dd>

  <dt>Paste Pure Text (Win + V)</dt>
  <dd>Pastes content of clipboard as pure text. This helps with some
    formatting issues in Maple.</dd>

  <dt>Yellow Background Color (Win + A)</dt>
  <dd>In Maple, give the selected text a yellow background color.</dd>

  <dt>Orange Text Color (Win + Z)</dt>
  <dd>In Maple, give the selected text a faded orange color.</dd>

  <dt>Red Text Color (Win + C)</dt>
  <dd>In Maple, give the selected text a red color.</dd>

  <dt>Reload All Bundles (Win + Q)</dt>
  <dd>Load all bundles and reload Lintalist for Math.</dd>

  <dt>Underline Plugin</dt>
  <dd>A plugin for Lintalist for Math that underlines the plugin text if
  snippet is pasted to Maple, but pastes pure text in other programs. Refer to
    Lintalist docs on plugins. In the snippet editor, the selected text can
    be given the underline tag by pressing Ctrl + U.</dd>

  <dt>Math Plugin</dt>
  <dd>A plugin for Lintalist for Math paste formulas to Maple. See more below.</dd>
</dl>

### Math Plugin

For example, you could put `[[Math=x^t+2{right}+2x]]` to get
<i>x</i><sup><i>t</i>+2</sup> + 2<i>x</i> when pasted to Maple. The `[[Math` and
`]]` parts are default plugin syntax. The content `x^t+2{right}+2x` is basically
the key presses you would make to type the same expression in Maple. Notice
in particular the `{right}` to send a right arrow key press.

Experiment to make more complex examples.

# Installation

1. New users: Download the [lastest
   release](https://github.com/jensjacobt/lintalist-for-math/releases) - unpack
   to a new directory and run lintalist.exe (or lintalist.ahk if you are already
   an AutoHotkey user).
2. AutoHotkey users (or installing updates): Download the
   [master.zip](https://github.com/jensjacobt/lintalist-for-math/archive/master.zip) - unpack to a new (or your current Lintalist) directory and run lintalist.ahk.

# AutoHotkey

Lintalist (for Math) written in AutoHotkey, a free and open-source utility for
Windows.  You can learn more about AutoHotkey at <http://ahkscript.org/>. The
source code for AutoHotkey is available at
<https://github.com/Lexikos/AutoHotkey_L>.

**Note**: lintalist.exe is simply a renamed autohotkey.exe included for
convenience, so you don't have to install AutoHotkey as well.  This script
requires a working copy of autohotkey.exe to be present in order to run user
scripts defined in bundles. If you have AHK installed you can safely delete
lintalist.exe and just start lintalist.ahk directly.
