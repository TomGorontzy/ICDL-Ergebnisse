# Release Notes v2.4

Datum: 2026-07-04

## Highlights

- Release wurde automatisiert gebaut und paketiert (EXE + Dokumentation + Archivdaten).
- Build- und Release-Prozess wurden im Projektstandard vereinheitlicht (Versionierung, ZIP, Notes).
- Diese Version enthält die zuletzt umgesetzten Funktions- und UX-Anpassungen.

## Letzte Anpassungen

- GUI: Statusbalken für die Verarbeitung ergänzt; bei erfolgreichem Abschluss "Fertig" grün hervorgehoben.
- GUI: Schaltfläche zum direkten Ã–ffnen des docs-Ordners ergänzt.
- Automatik: CSV-Suche und Auto-Start für App-Ordner, Desktop und Downloads erweitert.
- Datenfluss: erzeugte Excel-Dateien werden nach erfolgreicher Verarbeitung automatisch nach archive verschoben (Ãœberschreiben ohne Rückfrage).
- Distribution: demo-Ordner wird in Build und Release mitgeführt; Demo-CSV liegt unter demo/examinations.csv.

## Qualitätsstatus

- Release-Build erfolgreich erzeugt.
- ZIP-Artefakt in diesem Lauf nicht erstellt (-SkipZip).
- Automatische Basisprüfung (Build/Packaging) im Skript durchlaufen.

## Artefakte

- Build-Verzeichnis: dist/ICDL-Ergebnisse-v2.4/
- EXE: dist/ICDL-Ergebnisse-v2.4/ICDL-Ergebnisse.exe
- Dokumentation: dist/<Build>/docs/
- Archivdaten: dist/ICDL-Ergebnisse-v2.4/archive/
- Release-ZIP: *(noch nicht erstellt - Build wurde mit -SkipZip ausgefuehrt oder steht noch aus)*

## Enthaltene Commits (aktuelle Historie)

- `fa6d56e` Cleanup: untrack build/dist/release artifacts, keep release notes
- `ebf7ad2` Enable markdownlint for release notes and apply markdown fixes
- `fceab60` Track demo folder and demo CSV on GitHub
- `b2b3c0d` Release v2.3
- `9c50f1b` Track release notes while keeping release artifacts ignored

## Technische Build-Informationen

- Build-Datum: 2026-07-04 16:05:00
- Build-Modus: PyInstaller --noconfirm
- EXE-Name: ICDL-Ergebnisse.exe
