# Release Notes v3.7

Datum: 2026-07-04

## Highlights

- Release wurde automatisiert gebaut und paketiert (EXE + Dokumentation + Archivdaten).
- Build- und Release-Prozess wurden im Projektstandard vereinheitlicht (Versionierung, ZIP, Notes).
- Diese Version enthält die zuletzt umgesetzten Funktions- und UX-Anpassungen.

## Letzte Anpassungen

- GUI: Statusbalken für die Verarbeitung ergänzt; bei erfolgreichem Abschluss "Fertig" grün hervorgehoben.
- GUI: Schaltfläche zum direkten Öffnen des docs-Ordners ergänzt.
- Automatik: CSV-Suche und Auto-Start für App-Ordner, Desktop und Downloads erweitert.
- Datenfluss: erzeugte Excel-Dateien werden nach erfolgreicher Verarbeitung automatisch nach archive verschoben (Überschreiben ohne Rückfrage).
- Distribution: demo-Ordner wird in Build und Release mitgeführt; Demo-CSV liegt unter demo/examinations.csv.

## Qualitätsstatus

- Release-Build erfolgreich erzeugt.
- ZIP-Artefakt erstellt und im Release-Ordner abgelegt.
- Automatische Basisprüfung (Build/Packaging) im Skript durchlaufen.

## Artefakte

- Build-Verzeichnis: dist/ICDL-Ergebnisse-v3.7/
- EXE: dist/ICDL-Ergebnisse-v3.7/ICDL-Ergebnisse.exe
- Dokumentation: dist/<Build>/docs/
- Archivdaten: dist/ICDL-Ergebnisse-v3.7/archive/
- Release-ZIP: release/ICDL-Ergebnisse-v3.7.zip

## Enthaltene Commits (aktuelle Historie)

- `b324be7` fix: broaden datetime parsing for duration calculation
- `5c8b64c` release: v3.6
- `b952a97` fix: always compute duration for partial csv rows
- `f7dc324` chore: ignore generated export xlsx files
- `d3dc079` release: v3.5

## Technische Build-Informationen

- Build-Datum: 2026-07-04 20:35:58
- Build-Modus: PyInstaller --noconfirm
- EXE-Name: ICDL-Ergebnisse.exe