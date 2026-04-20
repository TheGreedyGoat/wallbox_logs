# Projektbeschreibung 
Das Ziel des Projekts ist ein einfach bedienbares Programm, mit dem der Invetarkreisel (IK) das Log der Wallboxen einlesen und daraus die zu erstellenden Rechnungen ableiten kann.

# Hintergrund 
Hinter dem IK-Gebäude stehen 2 Ladesäulen für e-Autos (Wallboxen). Diese können mit ausgegebenen Ladekarten genutzt werden. Es ist geplant, dass zumindest manche Beschäftigte des IK und der cdemy GmbH solche Ladekarten erhalten, aber auch Teilnehmer sind ja theoretisch möglich. Aus diesem Log der Ladevorgänge sind dann Daten zu generieren a la

Ladekarten-ID bzw. Wer? (Firma, Name)
Geladenes Stromvolumen (KWh)

# User Story 
Der IK geht in das Webinterface der Ladeäsulen und downloadet das Lade-Log. Er erhält eine CSV Datei. Er kann nun diese CSV-Datei in unser Programm einlesen. Dieses interpretiert die Daten und gibt eine entsprechende Rechnungsvorlage aus.

# Entwicklungsphasen 
## Phase 1: Log einlesen 
Das Programm kann eine gegebene CSV-Datei (aus Assets einlesen) und die Daten interpretieren. Ausgabe wäre dann eine "Ladekarte X hat Y Kwh geladen)"

## Phase 2: Logdatei auswählen 
Das Programm kann eine CSV-Datei nach FilePicker-Dialog prüfen, ob sie korrekte Daten enthält und dann verfahren wie in Phase 1.

## Phase 3: Stammdaten hinterlegen 
Das Programm erlaubt das Pflegen von Ladekarten und den zugeordneten Benutzern. Diese werden lokal persistent gespeichert. Beispiele:

### Firmen
Fahrer (in der Regel Firmen zugeordnet, aber vielleicht auch privat) mit ihrer Ladekarten-ID
Zugeordnete Preise für verschiedene Firmen / Fahrer
Dann können Rechnungsvorlagen erstellt werden.

## Phase 4: Rechnungen generieren 
Mit einer entsprechenden Verwaltung von Rechnungsnummern könnten die Rechnungen auch direkt aus dem Programm als PDFs generiert werden, aber ... das ist eine Phase, die wir vermutlich nie erreichen werden.

# Edge Cases 
Wenn die Logdatei generiert wurde, während ein Auto noch an der Ladesäule hing, dann sollte das Programm sich den offenen Tankvorgang merken für das nächste Einlesen von Logdateien.

Man sollte sicherstellen, dass die selbe Logdatei nicht zweimal eingelesen wird, etc.




