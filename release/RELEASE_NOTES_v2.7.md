# Release Notes v2.7

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
- ZIP-Artefakt erstellt und im Release-Ordner abgelegt.
- Automatische Basisprüfung (Build/Packaging) im Skript durchlaufen.

## Artefakte

- Build-Verzeichnis: dist/ICDL-Ergebnisse-v2.7/
- EXE: dist/ICDL-Ergebnisse-v2.7/ICDL-Ergebnisse.exe
- Dokumentation: dist/<Build>/docs/
- Archivdaten: dist/ICDL-Ergebnisse-v2.7/archive/
- Release-ZIP: release/ICDL-Ergebnisse-v2.7.zip

## Enthaltene Commits (aktuelle Historie)

- `dc5944c` Docs: README auf v2.6 Verhalten und Release-Link aktualisiert
- `8b9f874` Release v2.6: Titelzeilen-Icon und modernes GUI-Layout
- `f047461` Release v2.5: OneDrive auto-start fix and GUI text/layout update
- `fa6d56e` Cleanup: untrack build/dist/release artifacts, keep release notes
- `ebf7ad2` Enable markdownlint for release notes and apply markdown fixes

## Technische Build-Informationen

- Build-Datum: 2026-07-04 17:51:49
- Build-Modus: PyInstaller --noconfirm
- EXE-Name: ICDL-Ergebnisse.exe