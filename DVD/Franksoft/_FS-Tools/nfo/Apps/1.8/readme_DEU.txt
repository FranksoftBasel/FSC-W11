┌───────────────────────────────────────────────────────────────────┐
│ ▄  ▄ ▄▄▄ ▄▄▄ ▄▄  ▄▄▄ ▄▄                                           │
│ █▀▄█ █▄  █ █ █▄▀ █▄█ █ █                                          │
│ ▀  ▀ ▀   ▀▀▀ ▀   ▀ ▀ ▀▀                                           │
│ Durch Anders Nivfors von THD                                      │
└───────────────────────────────────────────────────────────────────┤
                                                                    │
  NFOPad ist ein kleiner, schneller und flexibler kombinierter      |
  NFO-Viewer und Text-Editor. Er ist ein Clone von Microsoft`s      :
  Notepad aber mit Extra-Einstellungen und dem Support für NFO-     .
  Dateien. Die Datei-Endung wird zur Festlegung der Benutzung 
  einer ASCII-Schrift verwendet. NFOPad unterstützt ausserdem 
  Unicode vollständig.

  Funktions-Liste:
   - URL- & e-Mail-Erkennung
   - Sehr anpassbar (Schriften, Farben, Programm-Einstellungen)
   - Fenster Auto-Breite
   - Liste der zuletzt geöffneten Dateien
   - Kopieren beim Markieren Option
   - Eingebaute ASCII-Schriften für NFO-Dateien
   - Direktes Scrollen
   - Tab-Breiten Einstellungen
   - Portabel
   - Unicode-Support
   - Alpha Blending Support
   - Lokalisiert
   - Shell-Integration
   - Endungen bestimmen Schrift
   - Drucken
   - Suchen & Ersetzen von Text
   - Einfügen/Überschreiben-Modus
   - Gehe zu Zeile
   - Zeile löschen
   - Drag & Drop
   - Verbesserte Wortauswahl bei Doppelklick und STRG-Auswahl
   - Öffne nächste/vorherige Datei im Verzeichnis der aktuell 
     geöffneten Datei
   - Immer im Vordergrund-Option
   - Schliessen mit der ESC-Taste
   - Zeilenumbruch-Option
   - Notepad's .LOG-Funktionalität
                                                                    .
  Besuche unsere Webseite für weitere Informationen,                :
  Aktualisierungen und Forum: http://truehumandesign.se             |
                                                                    │
┌───────────────────────────────────────────────────────────────────┤
│ Versions-Historie                                                 │
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
   - Brasilianische Portugiesische Lokalisierung hinzugefügt
   - F6/F7 hinzugefügt, sodass die nächste/vorherige Datei
     im Ordner der aktuell geöffneten Datei geöffnet wird
   - Doppelklick auf den Pfad in der Status-Bar kopiert ihn
     in die Zwischenablage
   - Bugfix: Text im Haupt-Fenster konnte verändert werden, 
     wenn man Tastatur-Befehle benutzt hat, der Finden-Dialog 
     im Fokus war
   - Bugfix: Wiederherstellen der Scroll-Position im Text
     schlug in einigen Fällen fehl wenn die Auswahl ausserhalb 
     der Sicht war
   - Bugfix: Kleinere Bugfixes

  ver 1.66    [2013-01-20]
   - Ukrainische Lokalisierung hinzugefügt
   - INI-Datei Speicherort kann ausgewählt werden
   - Text finden wird versuchen zu scrollen, sodass sich der
     gesuchte Text nicht mehr am Ende des Bildschirms befindet
   - So gefixt, dass Rückgängig für folgende Operationen 
     funktioniert: Zeile löschen, Ersetzen, Alles ersetzen, 
     Schreibweise ändern und Datum einfügen
   - "Trefferanzahl" und "Alles ersetzen" Dialoge konnten hinter
     dem NFOPad Haupt-Fenster liegen
   - Bug gefixt beim Suchen bis zum Ende und dann Umkehren der 
     Suchrichtung (man musste zwei Mal auf Finden drücken)

  ver 1.65    [2012-09-30]
   - Wort-Auswahl aktualisiert, funktioniert jetzt mit CTRL +
     Klick, CTRL + Pfeil-Tasten und Doppelklick.
   - Eine anpassbare Liste von Wort-Trennzeichen hinzugefügt.
   - Performance Fixes für das Öffnen und Speichern von großen
     Dokumenten       
   - Bugfix: Standard-Einstellungen für "Lade NFO-Dateien mit 
     Western Latin Encoding" auf false geändert, ausser Benutzer
     mit asiatischen Betriebssystemen
   - Bugfix: Wenn NFOPad so eingestellt wurde, dass es immer im
     Vordergrund ist, wurden einige Dialoge vom Hauptfenster
     verdeckt
   - Bugfix: Windows Sounds bei Information/Warnung wurden in 
     einigen Dialogen falsch abgespielt
   - Bugfix: Einige Dialoge wurden nicht immer richtig positioniert
     wenn man das Hauptfenster verschoben hat
   - Bugfix: Dateigröße bei gesperrten Dateien wurde nicht angezeigt
   - Bugfix: Portugiesische Lokalisierungs-Datei aktualisiert
   - Kleinere Bugfixes

  ver 1.64    [2012-04-14]
   - Ungarische Lokalisierung hinzugefügt
   - Direktes Scrollen (den Text scrollen mit Hilfe der Pfeil-
     Tasten) und eine große Anzahl von Optionen wenn man dieses 
     aktiviert
   - Angezeigten Dialog verbessert, wenn man Unicode-Zeichen mit
     der falschen Encodierung speichern möchte
   - Menübar kann versteckt werden (benutze ALT um sie wieder
     anzuzeigen)
   - Du kannst festlegen, wo sich NFOPad auf dem Bildschirm öffnen 
     soll, indem zwei extra Kommandozeilenargumente gesendet werden 
     (nfopad.exe [zu öffnende Datei] [x Koordinate] [y Koordinate])
   - Die Angabe einer Verknüpfung als Befehlszeilenargument öffnet
     jetzt die verweisende Datei
   - Bugfix: Das Öffnen von Dateien bei Netzwerkfreigaben oder 
     sehr langen Pfaden konnte scheitern
   - Bugfix: Fehlermeldung für die Einstellung der Sprache von 
     NFOPad wurde manchmal falsch dargestellt wenn man im Options-
     Dialog auf Ok drückt

  ver 1.63]   [2011-11-20]
   - Koreanische Lokalisierung hinzugefügt
   - Einige Standard-Werte optimiert

  ver 1.62    [2011-10-23]
   - Russische Lokalisierung hinzugefügt
   - URL Erkennung erkennt nun auch URLs die mit www beginnen
     (ohne http://)
   - Drücken von Einfügen ändert den Eingabemodus (überschreiben/
     einfügen)
   - Eingabemodus-Anzeige in der Statusbar und eine Einstellung es
     zu deaktivieren
   - Potentieller Fix für NFOPad: Erfragte Administratorrechte bei
     jedem Start
   - Bugfix: Titel des Dokuments wurde beim Drucken nie zum Drucker 
     gesendet
   - Bugfix: "View with NFOPad" wurde nicht korrekt aus dem Kontext-
     Menü entfernt
   - Bugfix: Scrolltext-Position und Auswahl wurden in seltenen
     Fällen zurückgesetzt

  ver 1.61    [2011-10-02]
   - Chinesische Lokalisierung hinzugefügt
   - Alpha Blending Support für das Programm-Fenster hinzugefügt
     (und eine Einstellung + Verknüpfung)
   - Dem Programm-Titel wurde ein Sternchen hinzugefügt wenn der 
     Text geändert wurde aber ungespeichert ist
   - Eine Einstellung hinzugefügt, um alle Registry-Einträge zu
     deaktivieren, um 100%ige Portabilität zu gewährleisten
   - Strg-Klicken gefixt, um ein Wort auszuwählen - funktioniert nun 
     ebenfalls beim Drücken des Maus-Buttons, um mehrere Wörter 
     gleichzeitig auszuwählen
   - Kontext-Menü umbenannt "View with NFOPad" -> "Edit with NFOPad"
   - Geringfügige Layout-Fixes und Code-Optimierungen
   - Bugfix: Wechseln der Schrift-Auswahl mit Hilfe von F9-F12 
     behält nun die Scrolltext-Position bei
   - Bugfix: Tabs wurden beim Drucken inkorrekt gehandhabt

  ver 1.6     [2010-10-05]
   - Polnische Lokalisierung hinzugefügt
   - Option hinzugefügt, zum Ein/Ausblenden aller Statusbar-Items
   - Neue Statusbar-Items hinzugefügt: Datei-Grösse, Unicode-
     Anzeige, Auswahl-Länge (wird standardmässig nicht angezeigt)
   - "Übereinstimmende Schreibweise" im Finden-Dialog wird jetzt 
     nicht mehr zwischen den Sessions gespeichert
   - Einstellung hinzugefügt immer die Standard Tabbreite 8 für 
     NFO zu benutzen, seit einige NFO-Dateien dieses voraussetzen 
     (standardmäßig aktiviert)
   - Wenn eine Datei erneut geöffnet wird (F5) scrollt der Text 
     zurück an die zuletzt befindliche Stelle
   - Finden/Ersetzen/Trefferanzahl-Performance wurde erheblich 
     verbessert
   - Einige Standardwerte für die Auto-Breite geändert
   - Fixes und Verbesserungen bei der Art und Weise wie der Text 
     per Doppelklick und CTRL-Klicken ausgewählt wird
   - Eine Warnung hinzugefügt wenn versucht wird, eine Sprache zu 
     verwenden, obwohl die Sprachdatei nicht installiert ist
   - Fixes, Überprüfungen und Warnungen betreffend des Lesens und 
     Schreibens von Registry-Keys für alle Benutzer die einen 
     Windows-Account ohne Administratorrechte benutzen
   - Bugfix: Finden-Dialog war immer über allen anderen Fenstern
   - Bugfix: Ändern der Schriftauswahl über die Menü- oder 
     Tastatur-Shortcuts aktualisierte nicht die Standard-Endung 
     im Speichern Als Dialog
   - Bugfix: Verschiedene Lokalisierungs-Fixes

  ver 1.59    [2010-07-22]
   - Programm-Sprache kann in den Optionen eingestellt werden
   - Schnell-Umschaltung zwischen NFO/Text-Modus kann aus dem Menü
     heraus oder über Shortcut-Keys gewählt werden.                  
   - URL-Erkennung funktioniert nun auch innerhalb XML-Tags
   - Standard-Encodierung für zu speichernde Dateien kann in den
     Optionen eingestellt werden
   - Taskbar Icon gefixt, sodass das hochauflösende verwendet wird
   - Deutsche Lokalisierung hinzugefügt
   - Portugiesische Lokalisierung hinzugefügt
   - Spanische Lokalisierung hinzugefügt

  ver 1.58    [2010-05-16]
   - Support für verschiedene Sprachen in der GUI hinzugefügt.
   - Lokalisierung für Schwedisch hinzugefügt
   - Einstellung Fensterposition/Grösse beim Beenden speichern
     zur Auswahl hinzugefügt
   - Wortanzahl im Such-Dialog hinzugefügt
   - Sanduhr-Cursor wird bei grossen Operationen angezeigt
   - Alles ersetzen optimiert
   - "Neues Fenster" wird das neue Fenster mit einem kleinen Offset 
     öffnen
   - Bugfix: Die Programm-Einstellungen INI-Datei wird nun als 
     Unicode gespeichert
   - Bugfix: Ändern der Zeilenumbruch-Einstellung setzt nun nicht
     mehr die Tab-Breite zurück
   - Bugfix: Drucken von grossen Texten mit vielen Tabs war sehr
     langsam
   - Bugfix: Anwendung konnte abstürzen wenn die INI-Datei nicht
     gelesen werden konnte

  ver 1.57    [2010-03-27]
   - Tab-Breite kann in den Optionen gesetzt werden
   - NFOPad warnt wenn man versucht einen Text mit Unicode-Charakter
     und einem inkompatiblen Encoding zu speichern
   - Intuitivere Wortauswahl beim Doppelklicken auf ein Wort
   - Doppelklicken einer URL oder e-Mail-Addresse wählt sie aus
   - ".LOG" am Anfang eines Textes hinzugefügt bringt NFOPad 
     dazu automatisch das aktuelle Datum und die Zeit während des 
     Öffnens einzufügen, wie bei Notepad
   - Liste der zuletzt geöffneten Dateien wird so sortiert, dass
     die kürzlich geöffneten zuerst angezeigt werden
   - Zeilenumbruch beim Drucken hinzugefügt um sicherzustellen,
     dass der ganze Text auf die Seite passt
   - Bugfix: Falsche Warnung beim Drucken entfernt
   - Bugfix: Tabs wurden beim Drucken nicht korrekt verwaltet
   - Bugfix: URL/e-Mail-Erkennung funktionierte am Ende sehr langer
     Texte nicht
   - Bugfix: Zeile konnte trotz Schreibschutz gelöscht werden
   - Eine riesige Anzahl geringfügiger Optimierungen

  ver 1.56    [2009-09-25]
   - Programm-Einstellungen können nun in eine INI-Datei oder 
     der Registry gespeichert werden
   - Einen Schreibgeschützt-Hinweis in der Status Bar hinzugefügt
   - "TXT-Datei" wird jetzt im Neu-Menü des Windows Explorers 
     angezeigt (kann in den Optionen angeschaltet werden)
   - Bugfix: gefixt sodass das Erzwingen der Western Latin Encoding 
     Einstellung nicht für Unicode-Dateien angewandt wird
   - Bugfix: Speichern als und Ändern des Encoding konnte die 
     falsche Datei neu laden (Datei korrekt gespeichert aber 
     falscher Text geladen)

  ver 1.55    [2009-06-22]
   - Neuer Optionen-Dialog
   - Auto-Breite hinzugefügt, inklusive Einstellungen in den
     Optionen
   - Operationen hinzugefügt den ausgewählten Text gross, klein,
     nur am Anfang gross und umgekehrt zu schreiben
   - "Zeit/Datum einfügen" hinzugefügt
   - Support für URLs innerhalb {} und <> hinzugefügt
   - Speichern-Dialog Optimierungen
   - Bugfix: URL-Erkennung funktionierte bei gross geschriebenen
     Adressen nicht

  ver 1.54    [2009-05-17]
   - Neues Icon für NFOPad erstellt (und alle damit verknüpften 
     Dateien)
   - Option hinzugefügt den Text in umgekehrter Richtung zu suchen
     (Shift+F3)
   - Verbesserte URL/e-Mail-Erkennung um auch Adressen innerhalb 
     Rundklammern/Klammern zu handhaben und folgende Schlagwörter
     zu erkennen:
     http://, https://, ftp://, ftps://, file://, gopher://,
     news://, nntp://, telnet://, wais://, prospero://
   - Aktuelle Datei erneut öffnen hinzugefügt (F5)
   - "Alles ersetzen" optimiert um >40 mal schneller zu sein
   - Ändern des Encoding einer Datei beim Speichern aktualisiert
     den Text um die Änderungen wiederzuspiegeln
   - Bug Fixes

  ver 1.53   [2009-04-13]
   - Option "Lade NFO-Dateien mit Western Latin Encoding"
     hinzugefügt, standardmässig aktiviert. NFO-Dateien
     wurden für nicht Latin Betriebssystem-Sprache nicht
     richtig angezeigt (wie Chinesisch oder Japanisch)
   - Separate Farben für NFO/TXT hinzugefügt
   - Vereinfachung der Verknüpfung von neuen Dateiendungen mit 
     NFOPad und ebenfalls ermöglicht welche Schrift für jede
     Endung verwendet werden soll
   - Gefixt sodass du Start->Ausführen "nfopad" verwenden kannst
     um NFOPad zu starten sogar wenn das Programm nicht mit einem
     Installer installiert wurde
   - Ungewollte Verknüpfungen entfernt (CTRL + H, J, I, M)
   - Schrift Zeichensatz wird benutzt und ordnungsgemäss
     gespeichert
   - Unicode-Support im Suchen/Ersetzen-Dialog verbessert
   - Vorgeschlagener Dateiname bei Neu gelöscht
   - Programm in NFOPad mit einem grossen P umbenannt
   - Verschiedene Fixes

  ver 1.52    [2009-02-09]
   - Support für einige seltene Zeilen beendende Charakter
     hinzugefügt, fixt viele Probleme mit einigen NFO-Dateien
     die doppelte leere Zeilen enthalten
   - Speichern als Dialog schlägt nun den letzten Pfad und
     Dateinamen vor
   - Bugfix: Endungs-Erkennung ist schreibabhängig
   - Bugfix: Man konnte mehrere Schrift/Farbe-Dialoge in den 
     Optionen öffnen was NFOPad verzögerte
   - Bugfix: Teile der Liste der zuletzt verwendeten Dateien 
     konnte gelöscht werden und das Verwenden mehrerer NFOPad
     überschrieb zuletzt geöffnete Items
   - Einige geringfügige Fixes

  ver 1.51    [2009-01-09]
   - Gefixt sodass gesperrte Dateien von NFOPad geöffnet werden 
     können (Dateien die von einem anderen Prozess verwendet 
     werden)
   - Zusätzlicher Unicode-Support, Encoding kann während des
     Öffnens und Speicherns ausgewählt werden
   - Gefixt sodass sich der gescrollte Bereich beim zu Ersetzenden
     befindet
   - Der Speichern als Dialog schlägt die Standard-Endung der 
     geöffneten Datei vor
   - Shift+Entfernen um eine Zeile zu löschen wird erst angewandt, 
     wenn nichts innerhalb des Textes ausgewählt wurde (andernfalls
     bis die Auswahl wie zu erwarten entfernt ist)

  ver 1.5     [2008-12-01]
   - Vollständiger Unicode-Support
   - "Kopieren beim Markieren" hinzugefügt welcher den mit der Maus
     ausgewählten Text kopiert, kann in den Optionen angeschaltet
     werden
   - "Neues Fenster" Menü Item hinzugefügt. Öffnet eine neue
     Instanz von NFOPad
   - Ersetzen-Funktionalität hinzugefügt
   - Ausgewählter Text wird automatisch in das Such-Feld kopiert
   - Such-Dialog hat neue Einstellungen für "Immer am Anfang 
     starten" und "Bei Suche schliessen"
   - Such-Dialog benutzt ASCII-Schrift wenn diese im Text verwendet 
     wird
   - Support für Vista/XP-Themes hinzugefügt
   - Laden und Speichern von Dateien neu geschrieben (Laden eines 
     grossen Textes geht nun viel schneller)
   - Option "Endung bestimmt Schrift" hinzugefügt um entweder
     NFO oder TXT als Standard-Endung festzulegen wenn Dateien
     ohne Endung angesehen oder gespeichert werden
   - Maximale Anzahl der zuletzt geöffneten Items auf 20 erhöht
   - Beim Ziehen einer Verknüpfung (.lnk) auf NFOPad wird die zu 
     erwartene Datei geöffnet
   - URL- und e-Mail-Erkennung optimiert welche bei grossen Text-
     Dateien sehr langsam sein konnte
   - Geändert wie die Programm-Einstellungen gespeichert werden
     sollen, das bedeutet leider auch, dass alle deine alten 
     Einstellungen gelöscht werden
   - Liesmich zum Hilfe-Menü hinzugefügt
   - Die Standard Windows Taskbar Menü Items hinzugefügt
   - Einige Druck-Probleme gefixt
   - Bug gefixt wenn man auf eine Adresse im Text in der letzten 
     Zeile klickt
   - Standard-Einstellungen für Text-Schrift und Erfassung zuletzt 
     geöffnete Dateien geändert
   - Einige alte Bugs losgeworden

  ver 1.42    [2008-10-07]
   - Liste zuletzt geöffneter Dateien in das Datei-Menü 
     hinzugefügt
   - Shift+Entfernen löscht die Zeile
   - Bug, dass wenn der Benutzer gefragt wurde ob Änderungen 
     am Text gespeichert werden sollen doppelt gefragt wurde,
     gefixt
   - Einige Dialoge aktualisiert
   - Tooltip gefixt
   - Fix, sodass UTF Byte-Reihenfolgen-Markierungen nicht im Text 
     angezeigt werden (aber beim Speichern erhalten bleiben)

  ver 1.41    [2008-03-24]
   - e-Mail Adressen-Verfolgung hinzugefügt (öffnet Standard 
     e-Mail Client)
   - CTRL+Klick hinzugefügt, als Standard bei e-Mail- und URL-
     Verfolgung
   - URL/e-Mail Verfolgung Verbesserungen und Optimierungen
   - Kleiner Bug mit nicht aktualisierter Statusbar gefixt

  ver 1.4     [2007-11-24]
   - URL-Verfolgung (bei Doppel- oder einfachem Klick)
   - Statusbar hinzugefügt, zeigt aktuelle Zeile, Spalte und den
     kompletten Pfad
   - Gehe zu Zeile Funktion hinzugefügt (CTRL+G)
   - Warnung hinzugefügt wenn eine Datei gespeichert wird die als
     Schreibgeschützt markiert ist
   - Einige kleinere Fixes

  ver 1.3     [2007-05-13]
   - Neue ASCII-Schriften für die NFO-Dateien hinzugefügt!
   - Schrift, Schriftstil und Schriftgröße können für beides,
     NFO- und Txt-Dateien geändert werden
   - Drucken von ASCII Text möglich
   - "Immer im Vordergrund"-Option hinzugefügt
   - Bug beim Drucken des Textes welcher die Tabs durcheinander
     brachte gefixt
   - Bei der Suche wird der ausgewählte Text automatisch in den 
     Such-Dialog kopiert
   - Bug mit NFOPad-Absturz wenn der Computer keinen Standard-
     Drucker installiert hat (WinXP/Vista) gefixt
   - Bug gefixt dass wenn man speichert und den Zeilenumbruch 
     aktiviert hat, der Text nicht mehr nach oben scrollen konnte
   - "Änderungen am Text speichern?"-Dialog hat einen Abbrechen-
     Button
   - Optionen-Dialog Tab-Reihenfolge gefixt
   
  ver 1.2     [2007-01-08]
   - Neuer Such-Dialog, Such-Optionen verbessert
   - Bug gefixt, der das Programm umgebrochenen Text in neuen 
     Zeilen speichern ließ
   - Verknüpfungs-Optionen verbessert
   - Standard Hintergrund-Farbe optimiert
   - Druck-Bugs gefixt, immer noch nur einfacher Text
   - Maximiert-Haken gespeichert, fixt Probleme wenn das Programm
     maximiert geschlossen wird
   - Standard-Schrift wenn "Benutze Endung zum Festlegen der
     Schrift" in fixedsys geändert wurde
   - Speichern-Dialog-Filter verbessert
   - Namensliste geändert um die Dateinamen zuerst anzuzeigen
   - Bug mit der Namensliste gefixt die nicht mit langen Dateinamen 
     oder Leerzeichen umgehen konnte (in vielen Fällen)
   - Bug gefixt dass die Schrift bei Datei-Speicherung nicht 
     aktualisiert wurde
   
  ver 1.1     [2006-10-08]
   - Durchsuchen des Textes ist nun möglich
   - Support zum Hineinziehen (Drag&Drop) von Dateien in das 
     Programm hinzugefügt
   - Drucken ist jetzt möglich, die Ausgabe ist ein einfacher 
     Text
   - Das Programm überprüft die Endung um die korrekte Schrift 
     zu setzen
   - Support für verschiedene Text-Encoding-Formate hinzugefügt
   - Programm schliesst sich mit ESC
   - Mehr Tasten-Verknüpfungen für das Hauptmenü hinzugefügt
   - Erstes Mal-Hinweis über die Kontext-Integration entfernt
     (das Feature kann während der Installation oder in den 
     Optionen gesetzt werden)
   - Optionen hinzugefügt: 
   - Benutze Endung zur Schrift-Festlegung
   - Frage nach Speichern ungespeicherter Dokumente beim Beenden
   - Schliesse Programm mit ESC-Taste
   - kleinere Updates und Bug-Fixes
.                                                                    
: ver 1.0     [2004-03-08]
|   - erste offizielle Version
│
├───────────────────────────────────────────────────────────────────┐
│ (c) True Human Design 2022                                        │
│ http://truehumandesign.se                                         │
└───────────────────────────────────────────────────────────────────┘
