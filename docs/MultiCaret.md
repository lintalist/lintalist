# Lintalist MultiCaret support

A Lintalist snippet can make use of the multi-caret / multi-edit features of certain
text editors.

If you don't want to use MultiCaret simply avoid using multiple ^| in a Lintalist snippet.

If you paste a snippet in a program that isn't defined in multicaret.ini it should put
the caret at the location of the first ^| you defined in the snippet. The str, key and
clr settings will not be processed so they should not interfere after pasting the snippet.

Animated GIF showing short demo:
https://cloud.githubusercontent.com/assets/4143898/14404417/ed64a340-fe75-11e5-8f91-509c319a39fb.gif

## Requirements

- Editor must support multi-caret / multi-edit (see list below)
- Editor needs to have a keyboard shortcut for "select word" AND "select next occurrence".
If you can only use the mouse to do this, you won't be able to use this with feature of
Lintalist snippets (Notepad++ and RJ TextEd for example won't work)

## Setup

Edit multicaret.ini and check if your editor is already included. Create a new entry if not.
If you have changed the default shortcut for "select word" make sure you update the
KEY setting for your editor(s) that are already there.

**Adding a new editor**

Use the name of the editor executable as [section] name, followed by three keys: 

- str= string to use as placeholder to be able to "select word" + "select next occurrence"
- key= shortcut key used by editor for "select word" in AHK notation (^=ctrl +=shift !=alt)
- clr= key to send when all "words" are selected, using {Del} or {BS} clears the text

## Variations in use

A normal snippet could look like this, ^| indicates the caret position after pasting
the snippet.

    for (text1=0, text1 < text2, i++){
    ^|
    }

Using multi-caret we can set two or more carets in the snippet so we can type text in
multiple locations directly after pasting. Just use ^| to indicate the locations.

    for (^|=0, ^| < text2, i++){
    
    }

after pasting the snippet you should be able to start typing and text should be
inserted at both locations.

In order for the multi-carets to work the editor has to be able to select a word.
To be sure we have a unique word Lintalist inserts a string at the defined locations
in the snippet so it can tell the editor to select these and use these locations.
This is defined in the 'str' setting. By default we use three underscores but you
can change it to something else as long as it is unique, the 'str' must NOT occur 
in the snippet text itself or it will fail.

You can leave it empty but then you must ensure your snippet is setup in such a way
that it has the same text after each ^|. For example, if you leave str empty you
can take the above snippet and still make it work by placing the ^| markers infront
of the words - which have to be the same:

    for (^|text1=0, ^|text1 < text2, i++){
    
    }

After pasting, both occurrences of 'text1' should be highlighted in your editor.

How words are selected will also have an influence. Some editors will select
words with underscores, hyphen- or minus characters. Some editors also allow you
to configure this.

Each editor will behave slightly different when multi-carets are activated, some will
APPEND to the selected text and some will overwrite the selected text when you start
typing. If you always want to overwrite the selected text you can clear the selected
words by using the 'clr' setting in the multicaret.ini. If you define it as {del} 
or {bs} it will delete the selected text and just leave the multiple carets.

If you keep 'key' empty it won't erase the selected text so you can continue with
the text editors default behaviour.

## Tested or Confirmed Editors that work

- Atom
- Brackets
- EverEdit
- Sublime Text
- TextAdept
- UltraEdit 23+

