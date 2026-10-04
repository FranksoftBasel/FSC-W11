┌───────────────────────────────────────────────────────────────────┐
│ ▄  ▄ ▄▄▄ ▄▄▄ ▄▄  ▄▄▄ ▄▄                                           │
│ █▀▄█ █▄  █ █ █▄▀ █▄█ █ █                                          │
│ ▀  ▀ ▀   ▀▀▀ ▀   ▀ ▀ ▀▀                                           │
│ par Anders Nivfors de THD                                         │
└───────────────────────────────────────────────────────────────────┤
                                                                    │
  NFOPad est un éditeur de texte combiné à un afficheur de fichiers |
  nfo, petit, rapide et flexible. C'est un clone du Bloc-notes      :
  (Notepad) de Microsoft mais bien plus personnalisable et avec     .
  quelques nouvelles foncionnalités. NFOPad prend en charge
  totalement l'Unicode ainsi que les fichiers nfo avec ASCII art.

  Liste des fonctionnalités:
   - Détection des URLs (liens) et des adresses e-mail (courriel)
   - Très personnalisable (polices, couleurs, paramètres)
   - Largeur automatique de la fenêtre
   - Liste des fichiers récemment ouverts
   - En option, copier si sélectionné
   - Polices ASCII intégrées pour fichiers nfo
   - Défilement direct
   - Paramétrage de la largeur d'une tabulation
   - Portable
   - Prise en charge de l'Unicode
   - Prise en charge de l'Alpha blending (transparence)
   - Multilingue
   - Intégration dans le Shell
   - L'extension détermine la police
   - Impression
   - Chercher et remplacer du texte
   - Mode Insertion/Refrappe
   - Atteindre la ligne
   - Suppression de ligne
   - Glisser-Déposer
   - Sélection de mot via double clic et sélection par CTRL
   - Ouvrir le fichier suivant/précédent du dossier
     du fichier en cours
   - Option Toujours au-dessus
   - Fermeture via la touche ESC
   - Option Retour automatique à la ligne
   - Fonction .LOG similaire à MS Notepad (Bloc-notes)
                                                                    .
  Rendez vous sur notre page web pour plus d'informations,          :
  des mises à jour et notre forum: http://truehumandesign.se        |
                                                                    │
┌───────────────────────────────────────────────────────────────────┤
│ Historique des versions                                           │
├───────────────────────────────────────────────────────────────────┘
│
| ver 1.8     [2022-04-02]
:  - Added support for zooming the text with Ctrl+plus/Ctrl+minus/
     Ctrl+0 or scrollwheel
   - Added support for adding/removing a specified string to the 
     start of all selected lines (typically used for commenting 
     lines in scripts/source code)
   - All icons updated and 256x256 version added
   - Untabify now remove spaces as well as tabs
   - Added Reset all settings button to Options/Misc
   - "Allow changes to text" checkbox moved from menu to 
     Options/Misc to avoid accidental use of feature and READ ONLY 
     status bar item will be shown when set
   - bugfix: ctrl-stepping the caret did not work for some cases
   - bugfix: open new file with F6/F7 did not ask to save unchanged
     changes
   - bugfix: horizontal scroll position restored properly for a
     bunch of cases

  ver 1.75    [2020-02-09]
   - Triple clicking now selects the whole line
   - Open dialog now shows all file types by default
   - Recent files list now shows 10 files instead of 6 by default
   - Bugfix: opening a new file with the same contents as the
     currently open did not scroll the text to the top
   - Minor tweaks and fixes

  ver 1.74    [2018-06-16]
   - Improved detection of when to load text as unicode (tries to 
     detect UTF-8/UTF-16 even when the BOM is missing)
   - Fixed so non-text files containing null is displayed as
     expected
   - Pasted text with non-windows line endings (\n instead of \r\n)
     is now displayed properly
   - Fixed Replace/Replace all not working for some cases if
     clipboard was locked
   - URL detection improved to handle URLs within other tags
   - Initial paths set in Open/Save dialog when passing a file as
     argument to the exe
   - Misc. optimizations
   - Localization updates

  ver 1.73    [2017-09-09]
   - Added command for sorting the selected lines alphabetically
   - Recent files list instantly updated for all open NFOPad
     instances
   - Scrolled position is preserved so the selected text is kept in
     view (for when reopening files, changing wordwrap/font etc)
   - When reopening a file the text selection is no longer
     preserved if the selected text has changed
   - Fix for detection of email addresses within citation marks
   - Tabify behavior tweaked
   - .LOG feature (adding current date and time on open) now marks
     file as dirty as expected
   - Bugfix: Opening a file which ends with a non-empty line will
     no longer add one empty line
   - Bugfix: Ctrl+Insert and Shift+Insert no longer toggles
     OVERWRITE
   - Bugfix: Tabify honors read only setting
   - Minor fixes to both NFOPad and the installer

  ver 1.72    [2016-11-14]
   - Tab key will indent the current selection (tabify)
   - Hebrew localization added
   - Url/email detection improvements
   - Apostrophe added as word delimiter by default for better word
     selection in scripts/source code
   - App path registration fixed for non admin windows accounts
   - Installer updated to fix windows 10 issues
   - Bugfix: Delete line did not work as expected if word wrap was
     enabled

  ver 1.71    [2016-02-20]
   - Load times for large text files improved
   - Double clicking a word and keeping the button held down now
     allows the user to select several words just as ctrl + click
   - Slovak localization added
   - Set the NFOPad icon on "Edit with NFOPad" in the windows
     context menu
   - Opening an empty NFOPad, adding text and removing it again
     will no longer prompt to save on close
   - Added help text about starting the app as administrator when
     writing to the registry fails
   - Localization fixes
   - Bugfix: when having the menu bar hidden, AltGr no longer
     flickers the menu when held down
   - Bugfix: Auto Window Width no longer changes the window size
     when NFOPad is maximized

  ver 1.7     [2015-07-30]
   - Search while typing setting added
   - Different icons can now be selected when associating files
     with NFOPad, the old one updated and five new added
   - Fixed the file extension description to display the correct
     file type when associating files with NFOPad
   - Associating files from NFOPad should now always work and will
     immediately update the explorer icons
   - Bugfix: Shell/Edit extension dialog was not always checking the
     "Use NFO font" setting correctly
   - Bugfix: auto width was not calculated correctly for some cases
   - Localization fixes

  ver 1.69    [2014-04-06]
   - French localization added
   - Fixed so CTRL + backspace removes the whole word

  ver 1.68    [2014-01-18]
   - Italian localization added
   - Minor localization and code fixes

  ver 1.67    [2013-10-27]
   - Brazilian Portuguese added
   - Added so F6/F7 will open the next/previous file in the
     directory of the currently open file
   - Double click on path in status bar will copy it to the
     clipboard
   - Fixed so the NFOPad window and dialogs don't open outside the
     desktop.
   - Bugfix: text in main window could get manipulated using
     keyboard shortcuts when the Find dialog had focus
   - Bugfix: restoring scrolled position in text failed for some
     cases if selection was outside of the view
   - Bugfix: minor fixes

  ver 1.66    [2013-01-20]
   - Ukrainian localization added
   - INI file location can be selected from Options
   - Find text will try to scroll so the matched string is not at
     the bottom of the screen for better overview
   - Fixed so undo works for the following operations: delete line,
     replace, replace all, change case and insert date
   - Bugfix: "Count search hits" and "Replace all" dialogs could end
     up behind the NFOPad main window
   - Bugfix: When searching to the end and then reversing search
     direction Find had to be pressed twice

  ver 1.65    [2012-09-30]
   - Word selection updated, now works for ctrl + click, ctrl +
     arrow keys and double click. Also appending a word to the
     selection with ctrl + shift + click works as expected now.
   - Added a customizable list of word delimiters.
   - Performance fixes for opening and saving large documents
   - Bugfix: NFO files not shown correctly on some systems, changed
     default setting for "load nfo files with western latin
     encoding" to false for all except users with asian operating
     systems
   - Bugfix: When NFOPad was set to be always on top some dialogs
     were hidden by the main window
   - Bugfix: Windows information/warning sounds were played
     incorrectly on some dialogs
   - Bugfix: Some dialogs was not positioned correctly if the main
     window had been moved
   - Bugfix: Filesize was not shown on locked files
   - Bugfix: Portuguese localization file updated
   - Minor fixes

  ver 1.64    [2012-04-14]
   - Hungarian localization added
   - Direct scrolling (scroll the text using the arrow keys) and a
     bunch of options for when to enable it
   - Improved dialog shown when trying to save unicode characters
     with the wrong encoding.
   - Menu bar can be hidden (use ALT to show it again)
   - You can specify where on the screen to open NFOPad by sending
     in two extra command line arguments (nfopad.exe [file to open]
     [x coordinate] [y coordinate])
   - Specifying a shortcut as command line argument now opens the
     referenced file
   - Bugfix: opening files from network shares or really long paths
     could fail
   - Bugfix: error message for setting NFOPad language was sometimes 
     incorrectly shown when pressing OK on the Options dialog

  ver 1.63    [2011-11-20]
   - Korean localization added
   - Tweaked some default values

  ver 1.62    [2011-10-23]
   - Russian localization added
   - URL detection now also detects URLs starting with www (without
     http://)
   - Pressing insert will switch input mode (overwrite/insert)
   - Input mode indicator on the status bar and a setting to turn
     it off
   - Potential fix for NFOPad requesting administrator rights every
     time it starts
   - Bugfix: title of the document was never sent to the printer
     when printing
   - Bugfix: "View with NFOPad" was not removed properly from the
     context menu
   - Bugfix: scrolled position and selection could be reset for
     some rare cases

  ver 1.61    [2011-10-02]
   - Chinese localization added
   - Added alpha blending support for the program window (and a
     setting + shortcut)
   - Added an asterisk to the program title when the text is changed
     and unsaved
   - Added a setting to disable all registry writes to ensure 100%
     portability
   - Fixed so ctrl-clicking a word to select it also works when
     holding down the mouse button to select several words
   - Context menu renamed "View with NFOPad" -> "Edit with NFOPad"
   - Minor layout fixes and code optimizations
   - Bugfix: switching font selection using F9-F12 now keeps the
     scrolled text position
   - Bugfix: tabs was handled incorrectly when printing

  ver 1.6     [2010-10-05]
   - Polish localization added
   - Added option for toggling all status bar items on/off
   - Added new status bar items: file size, unicode indication,
     selection length (not shown by default)
   - "Match case" in the Find dialog is not saved between sessions
     anymore
   - Added setting for always using the standard tab width 8 for nfo
     files, since some nfo files assumes this (default true)
   - When reopening a file (F5) the text is scrolled back to the
     previous location
   - Find/replace/count performance greatly improved
   - Changed some default values for Auto Width
   - Fixes and tweaks on how to select text by double clicking and
     ctrl-clicking
   - Added a warning if trying to use a language when the language
     file has not been installed
   - Fixes, checks and warnings regarding reading and writing
     registry keys for all users using an windows account without
     admin rights
   - bugfix: Find dialog was always on top all other windows
   - bugfix: Changing font selection using the menu or keyboard
     shortcuts did not update the Save As dialog's default extension
   - bugfix: Misc localization fixes

  ver 1.59    [2010-07-22]
   - Program language can be set in options
   - Quick switch between NFO/text mode can be done from menu or
     with shortcut keys.
   - URL detection now work within xml tags
   - Default encoding for saving files can be set in options
   - Fixed taskbar icon to use the one with high resolution
   - German localization added
   - Portuguese localization added
   - Spanish localization added

  ver 1.58    [2010-05-16]
   - Added support for multiple languages in the GUI. Added
     localizations for Swedish
   - Added setting to select whether to save the window 
     position/size on exit
   - Added word count in the search dialog
   - Hourglass cursor shown during large operations
   - Replace All optimized
   - "New Window" will open the new window with a small offset
   - Bugfix: The program settings INI file is now saved as Unicode
   - Bugfix: Changing the word wrap setting no longer resets the
     tab width
   - Bugfix: Printing large texts with lots of tabs was very slow
   - Bugfix: Application could crash if unable to read the INI file

  ver 1.57    [2010-03-27]
   - Tab width can be set in Options
   - NFOPad warns if trying to save a text with unicode characters
     with an incompatible encoding
   - More intuitive word selection when double clicking a word.
   - Double clicking an URL or e-mail address will select it
   - Adding ".LOG" at the top of a text tells NFOPad to
     automatically add the current date and time to the text
     upon opening, just as Notepad.
   - Recent files list always sorted so the most recent files are
     shown first.
   - Word wrapping added when printing to make sure all text fits
     the page.
   - Bugfix: Removed false warning when printing
   - Bugfix: Tabs where not handled correctly when printing
   - Bugfix: URL/e-mail detection did not work in the end of 
     really long texts
   - Bugfix: Delete line was possible in read only mode
   - A bunch of minor tweaks

  ver 1.56    [2009-09-25]
   - Program settings can now be saved to an INI file or the
     windows registry
   - Added a READ ONLY notification in the status bar
   - "TXT file" is now shown in the Windows Explorer's New menu (can
     be turned off in Options)
   - Bugfix: fixed so force western latin encoding setting doesn't
     apply to unicode files
   - Bugfix: Save As and changing encoding would reload the wrong
     file (file saved correctly but wrong text loaded)

  ver 1.55    [2009-06-22]
   - New Options dialogue
   - Added Auto width, including settings in Options
   - Added operations for making the selected text uppercase,
     lowercase, sentence case, title case and inverted case
   - Added "Insert Time/Date"
   - Added support for URLs within {} and <>
   - Save dialog tweaks
   - Bugfix: URL detection didn't work on uppercase addresses

  ver 1.54    [2009-05-17]
   - Made a new icon for NFOPad (and all associated files)
   - Added option to search text in reverse direction (shift+F3)
   - Improved URL/e-mail detection to handle addresses within
     parenthesis/brackets and detect the following keywords:
     http://, https://, ftp://, ftps://, file://, gopher://,
     news://, nntp://, telnet://, wais://, prospero://
   - Added Reopen current file (F5)
   - Optimized "Replace all" to be >40 times faster
   - Changing the encoding of a file when saving will refresh the
     text to reflect the change
   - Bug fixes

  ver 1.53   [2009-04-13]
   - Added option "Load NFO files with western latin encoding",
     true by default. NFO files was not displayed properly for 
     users with a non latin OS language (such as Chinese or 
     Japanese).
   - Added separate colors for nfo/txt
   - Made it easier to associate new extensions with NFOPad and
     also made it possible to set what font to use for each
     extension
   - Fixed so you can use Start->Run "nfopad" to start NFOPad,
     even when the program wasn't installed using the installer
   - Removed unwanted shortcuts (CTRL + H, J, I, M)
   - Font character set is used and saved properly
   - Improved unicode support in Find/Replace dialog
   - Suggested filename cleared on New
   - Program renamed to NFOPad with a capital P
   - Various fixes

  ver 1.52    [2009-02-09]
   - Added support for some rare line ending characters, fixes
     problems with some NFO files having double blank lines
   - SaveAs dialog now suggests the previous path and filename
   - Bugfix: extension detection was case sensitive
   - Bugfix: you could open several font/color dialogs in Options
     which would stall NFOPad
   - Bugfix: parts of the recent items list could be cleared and
     using several NFOPad could overwrite recent items
   - Some minor fixes

  ver 1.51    [2009-01-09]
   - Fixed so locked files can be opened by NFOPad (files used by
     some other process)
   - Additional Unicode support, encoding can be selected upon open
     and save
   - Fixed so the scrolled location in the file is preserved upon
     replace
   - The SaveAs dialog suggests the default extension from the
     opened file
   - Shift+delete to remove a line only applies if nothing
     is selected in the text (else the selection is
     removed as expected)

  ver 1.5     [2008-12-01]
   - Full Unicode support
   - "Copy on select" added which copies the selected text on mouse
     up, can be enabled in Options
  - "New Window" menu item added. Opens a new instance of NFOPad
   - Replace functionality added
   - Selected text is automatically copied to the search field
   - Search dialog has new settings for "always start from top" 
     and "close on search"
   - Search dialog uses ASCII font if that is used in the text
   - Added support for Vista/XP themes.
   - Loading and saving of files rewritten (loading a large text is
     much faster)
   - Added option when using "extension determines font" to use
     either nfo or txt as default extension when saving and viewing
     files without extension
   - Increased max number of recent items to 20
   - Dropping a shortcut (.lnk) on NFOPad will open the referenced
     file as expected
   - Optimized url and e-mail detection which could be really slow
     on large text files
   - Changed how the application settings are stored, this
     unfortunately means all your old settings will be wiped
   - Readme added to Help menu
   - The standard windows taskbar menu items added
   - Fixed some printing issues
   - Fixed bug when clicking on an address in the text if it was on
     the last line
   - Default settings changed for text font and recent files count
   - Finally got rid of some old bugs

  ver 1.42    [2008-10-07]
   - Recent files list added to File menu
   - Shift+delete deletes the line
   - Fixed bug which asked if the user wanted to save changes twice
   - Updated some dialogs
   - Tooltip fixes
   - Fixed so UTF byte-order marks aren't displayed in the text 
     (but keeps it when saved)

  ver 1.41    [2008-03-24]
   - E-mail adress follow added (openens default e-mail client)
   - Added CTRL+click as default on e-mail and URL following
   - URL/e-mail follow tweaks and optimizations
   - Fixed small bug with the statusbar not being updated

  ver 1.4     [2007-11-24]
   - URL follow (on double or single click)
   - Status bar added, shows current line, column and full path
   - Goto line function added (CTRL+G)
   - Warning added when trying to save a file marked as read-only
   - Some minor fixes

  ver 1.3     [2007-05-13]
   - New ASCII fonts included for the nfo-files!
   - Font, font style and font size can be changed for both nfo and
     txt files
   - Printing of ASCII text possible
   - "Always on top" option added
   - Fixed bug with printing the text which messed up the tabs
   - When searching, the selected text is automatically copied to
     the search dialog
   - Fixed bug with NFOPad crashing if the computer had no default
     printer installed (WinXP/Vista)
   - Fixed so when saving and having word wrap enabled, the text is
     not scrolled to the top anymore
   - "Save changes to text?" dialog has a Cancel button
   - Options dialog tab order fixed
   
  ver 1.2     [2007-01-08]
   - new search dialog, search options updated
   - fixed bug that made program save wrapped text on new lines
   - updated associations options
   - default bg color tweaked
   - printing bugs fixed, still only plain text though
   - Maximized flag saved, fixes issues when closing the program
     when maximized
   - default font when "use extension to determine font" is changed
     to fixedsys
   - save dialog filters updated
   - namelist changed to show filename first
   - fixed bug with name list not being able to handle long
     filenames or spaces (in certain cases)
   - fixed bug with font not being updated on save file
   
  ver 1.1     [2006-10-08]
    - searching the text is now possible
    - added support for dropping files on the program
    - printing is now possible, the output is plain text though
    - the program will check the extension in order to set the
      correct font
    - added support for additional text encoding formats
    - program will quit on ESC
    - more shortcut keys for main menu added
    - Removed first time message about context integration (the
      feature can be set upon install or in options)
    - options added: 
    - Use extension to determine font
    - ask to save unsaved document upon exit
    - close program on ESC key
    - minor updates and bug fixes
.
: ver 1.0     [2004-03-08]
|   - first official version
│
├───────────────────────────────────────────────────────────────────┐
│ (c) True Human Design 2022                                        │
│ http://truehumandesign.se                                         │
└───────────────────────────────────────────────────────────────────┘
