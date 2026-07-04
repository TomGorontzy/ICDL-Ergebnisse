# Release Notes v4.0

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

- Build-Verzeichnis: dist/ICDL-Ergebnisse-v4.0/
- EXE: dist/ICDL-Ergebnisse-v4.0/ICDL-Ergebnisse.exe
- Dokumentation: dist/<Build>/docs/
- Archivdaten: dist/ICDL-Ergebnisse-v4.0/archive/
- Release-ZIP: release/ICDL-Ergebnisse-v4.0.zip

## Enthaltene Commits (aktuelle Historie)

- `5386685` fix: mark invalid duration and log time anomalies
- `d496b10` fix: robust duration field detection and archive retries
- `843e982` release: v3.8
- `f07f85a` fix: map csv header aliases and always archive on mail errors
- `57311a7` release: v3.7

## Technische Build-Informationen

- Build-Datum: 2026-07-04 20:49:10
- Build-Modus: PyInstaller --noconfirm
- EXE-Name: ICDL-Ergebnisse.exe