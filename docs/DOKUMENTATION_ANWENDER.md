# ICDL-Ergebnisse – Anwenderdokumentation

## Zweck

Die Anwendung `ICDL-Ergebnisse` automatisiert den Ablauf:

1. `examinations.csv` einlesen
2. Excel-Ergebnisdatei erstellen
3. Outlook-E-Mail-Vorschau mit Tabelleninhalt und Excel-Anlage erzeugen

## Voraussetzungen

- Windows mit installiertem Outlook (Desktop)
- Python/EXE-Build ist bereits vorhanden
- `examinations.csv` kann in einem der folgenden Orte liegen:
  1. direkt neben der EXE
  2. im benutzerspezifischen Desktop-Ordner
  3. im benutzerspezifischen Downloads-Ordner

## Start

### EXE-Variante

- `dist\ICDL-Ergebnisse.exe` starten

## Bedienung

- **App starten**: verarbeitet eine ausgewählte oder automatisch gefundene `examinations.csv`.
- **Automatik wiederholen**: sucht erneut in den drei Automatik-Speicherorten nach aktualisierten `examinations.csv` und verarbeitet diese automatisch, falls sie noch nicht als erledigt erkannt wurden.
- **Dokumentation öffnen**: öffnet den Dokumentationsordner im Explorer.

### Verhalten beim Start

- Beim Auto-Start wird in dieser Reihenfolge gesucht:
  1. neben der EXE
  2. Desktop
  3. Downloads
- Wenn dort eine `examinations.csv` **tagesaktuell** ist, startet die Verarbeitung automatisch.
- Andernfalls kann die CSV über den Button ausgewählt werden.
- Zusätzlich wird beim Start der Ordner `archive\` automatisch bereinigt:
  - Es bleiben nur die **10 neuesten** Excel-Dateien (`*.xlsx`) erhalten.
  - Ältere Excel-Dateien werden automatisch gelöscht.

## Diagramme

Weitere Ablauf- und Architekturdiagramme sind in `docs/DOKUMENTATION_DIAGRAMME.md` dokumentiert.

## Ergebnis

- Excel-Datei: `ICDL-Ergebnisse_YYYYMMDD_HHMMSS.xlsx`
- Inhalte der Excel-Datei:
  - Blatt `Ergebnisse`: enthält alle Datensätze des aktuellen CSV-Laufs.
  - Blatt `Neue Daten`: enthält eine laufübergreifende Sammlung neu hinzugekommener Datensätze.
    - Neue Zeilen werden bei jedem Lauf an die bestehende Sammlung angehängt.
    - Zusätzliche Spalte `Erfasst am` dokumentiert den Zeitpunkt der Aufnahme.
- Nach erfolgreicher Verarbeitung und Outlook-Vorschau wird die erzeugte Excel-Datei automatisch nach `archive\` verschoben.
- Existiert dort bereits eine Datei mit gleichem Namen, wird sie ohne Rückfrage überschrieben.
- Outlook-E-Mail-Vorschau mit:
  - Empfänger `KG_Kaufleuteteam`
  - Betreff mit Prüfungsdatum
  - Tabelle aus Excel (Quellformatierung beibehalten)
  - Excel-Datei als Anlage

## Hinweise

- Wenn Outlook noch nicht läuft, versucht die App Outlook automatisch zu starten.
- Bei Outlook-Dialogen (Profil/Sicherheit) kann der Ablauf warten oder mit Meldung abbrechen.

## Fehlerbehebung

- Prüfen, ob `examinations.csv` korrekt aufgebaut ist (Semikolon-getrennt).
- Outlook manuell öffnen, falls COM-Zugriff blockiert ist.
- Bei Build-Themen das Technikdokument prüfen.
