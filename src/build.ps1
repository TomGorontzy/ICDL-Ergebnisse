# build.ps1 - Build-Skript für ICDL-Ergebnisse
# - Erzeugt die EXE per PyInstaller
# - Versioniert automatisch als major.minor (minor 0..9, dann major+1)
# - Legt jedes Build in dist/ICDL-Ergebnisse-vX.Y/ ab

param(
    [switch]$SkipZip,
    [switch]$SkipMarkdownLint,
    [switch]$Help
)

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
if ($PSVersionTable.PSVersion.Major -ge 6) {
    $OutputEncoding = [System.Text.Encoding]::UTF8
}

if ($Help) {
    Write-Host "ICDL-Ergebnisse Build-Skript" -ForegroundColor DarkCyan
    Write-Host "  -SkipZip : ZIP-Erstellung im release-Ordner überspringen" -ForegroundColor DarkGray
    Write-Host "  -SkipMarkdownLint : Markdownlint-Prüfung vor dem Build überspringen" -ForegroundColor DarkGray
    Write-Host "  -Help : Hilfe anzeigen" -ForegroundColor DarkGray
    Write-Host "Versionierung: major.minor mit minor 0..9, danach major+1 und minor=0" -ForegroundColor DarkGray
    exit 0
}

$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
Set-Location $projectRoot

$specFile = Join-Path $PSScriptRoot 'ICDL-Ergebnisse.spec'
$distRoot = Join-Path $projectRoot 'dist'
$rawExe = Join-Path $distRoot 'ICDL-Ergebnisse.exe'
$docsDir = Join-Path $projectRoot 'docs'
$demoDir = Join-Path $projectRoot 'demo'
$archiveDir = Join-Path $projectRoot 'archive'
$versionFile = Join-Path $projectRoot 'build-version.json'
$releaseDir = Join-Path $projectRoot 'release'
$mdLintScript = Join-Path $PSScriptRoot 'tools\lint-markdown.ps1'

if (-not (Test-Path $specFile)) {
    throw "Spec-Datei nicht gefunden: $specFile"
}

if ($SkipMarkdownLint) {
    Write-Host "Markdownlint-Prüfung übersprungen (-SkipMarkdownLint)." -ForegroundColor Yellow
}
else {
    if (-not (Test-Path $mdLintScript)) {
        throw "Markdownlint-Skript nicht gefunden: $mdLintScript"
    }

    Write-Host "Markdownlint-Auto-Fix läuft ..." -ForegroundColor Cyan
    & $mdLintScript -Fix
    if ($LASTEXITCODE -ne 0) {
        throw "Build abgebrochen: Markdownlint-Fehler beim Auto-Fix erkannt."
    }

    Write-Host "Markdownlint-Verifikation läuft ..." -ForegroundColor Cyan
    & $mdLintScript
    if ($LASTEXITCODE -ne 0) {
        throw "Build abgebrochen: Nicht automatisch behebbarer Markdownlint-Fehler erkannt."
    }
}

function Resolve-PythonCommand {
    $venvPython = Join-Path $projectRoot '.venv\Scripts\python.exe'
    if (Test-Path $venvPython) {
        return @($venvPython)
    }

    $pyCmd = Get-Command py -ErrorAction SilentlyContinue
    if ($pyCmd) {
        return @('py', '-3')
    }

    $pythonCmd = Get-Command python -ErrorAction SilentlyContinue
    if ($pythonCmd) {
        return @('python')
    }

    throw 'Kein Python-Interpreter gefunden (.venv, py oder python).'
}

function Get-NextVersion {
    param([string]$Path)

    $major = 1
    $minor = -1

    if (Test-Path $Path) {
        try {
            $versionObj = Get-Content $Path -Raw -Encoding UTF8 | ConvertFrom-Json
            $major = [int]$versionObj.major
            $minor = [int]$versionObj.minor
        } catch {
            throw "Versionsdatei ist ungültig: $Path"
        }
    }

    if ($minor -lt 9) {
        $minor += 1
    } else {
        $major += 1
        $minor = 0
    }

    $outObj = [pscustomobject]@{
        major = $major
        minor = $minor
    }

    $json = $outObj | ConvertTo-Json
    Set-Content -Path $Path -Value $json -Encoding UTF8

    return "$major.$minor"
}

function New-ReleaseNotesFile {
    param(
        [Parameter(Mandatory = $true)][string]$Version,
        [Parameter(Mandatory = $true)][string]$BuildDirName,
        [Parameter(Mandatory = $true)][string]$ExeName,
        [Parameter(Mandatory = $true)][string]$ReleaseDir,
        [Parameter(Mandatory = $true)][bool]$ArchiveIncluded,
        [string]$ZipFileName
    )

    New-Item -ItemType Directory -Path $ReleaseDir -Force | Out-Null

    $notesPath = Join-Path $ReleaseDir "RELEASE_NOTES_v$Version.md"
    $buildDate = (Get-Date).ToString('yyyy-MM-dd HH:mm:ss')
    $displayDate = (Get-Date).ToString('yyyy-MM-dd')

    $zipArtifactLine = if ($ZipFileName) {
        "- Release-ZIP: release/$ZipFileName"
    } else {
        "- Release-ZIP: *(noch nicht erstellt - Build wurde mit -SkipZip ausgefuehrt oder steht noch aus)*"
    }

    $qualityZipLine = if ($ZipFileName) {
        "- ZIP-Artefakt erstellt und im Release-Ordner abgelegt."
    } else {
        "- ZIP-Artefakt in diesem Lauf nicht erstellt (-SkipZip)."
    }

    $archiveArtifactLine = if ($ArchiveIncluded) {
        "- Archivdaten: dist/$BuildDirName/archive/"
    } else {
        "- Archivdaten: *(kein archive-Ordner im Projekt gefunden)*"
    }

    $recentCommits = @()
    try {
        $gitLog = git log --oneline --no-decorate -5 2>$null
        foreach ($entry in $gitLog) {
            if ([string]::IsNullOrWhiteSpace($entry)) {
                continue
            }
            $parts = $entry -split ' ', 2
            if ($parts.Count -eq 2) {
                $recentCommits += "- ``$($parts[0])`` $($parts[1])"
            } else {
                $recentCommits += "- $entry"
            }
        }
    }
    catch {
        # Fallback wird unten gesetzt
    }

    if (-not $recentCommits -or $recentCommits.Count -eq 0) {
        $recentCommits = @('- *(Commitliste konnte automatisch nicht ermittelt werden.)*')
    }

    $contentLines = @(
        "# Release Notes v$Version",
        '',
        "Datum: $displayDate",
        '',
        '## Highlights',
        '',
        '- Release wurde automatisiert gebaut und paketiert (EXE + Dokumentation + Archivdaten).',
        '- Build- und Release-Prozess wurden im Projektstandard vereinheitlicht (Versionierung, ZIP, Notes).',
        '- Diese Version enthält die zuletzt umgesetzten Funktions- und UX-Anpassungen.',
        '',
        '## Letzte Anpassungen',
        '',
        '- GUI: Statusbalken für die Verarbeitung ergänzt; bei erfolgreichem Abschluss "Fertig" grün hervorgehoben.',
        '- GUI: Schaltfläche zum direkten Öffnen des docs-Ordners ergänzt.',
        '- Automatik: CSV-Suche und Auto-Start für App-Ordner, Desktop und Downloads erweitert.',
        '- Datenfluss: erzeugte Excel-Dateien werden nach erfolgreicher Verarbeitung automatisch nach archive verschoben (Überschreiben ohne Rückfrage).',
        '- Distribution: demo-Ordner wird in Build und Release mitgeführt; Demo-CSV liegt unter demo/examinations.csv.',
        '',
        '## Qualitätsstatus',
        '',
        '- Release-Build erfolgreich erzeugt.',
        "$qualityZipLine",
        '- Automatische Basisprüfung (Build/Packaging) im Skript durchlaufen.',
        '',
        '## Artefakte',
        '',
        "- Build-Verzeichnis: dist/$BuildDirName/",
        "- EXE: dist/$BuildDirName/$ExeName",
        '- Dokumentation: dist/<Build>/docs/',
        "$archiveArtifactLine",
        "$zipArtifactLine",
        '',
        '## Enthaltene Commits (aktuelle Historie)',
        ''
    )

    $contentLines += $recentCommits

    $contentLines += @(
        '',
        '## Technische Build-Informationen',
        '',
        "- Build-Datum: $buildDate",
        '- Build-Modus: PyInstaller --noconfirm',
        "- EXE-Name: $ExeName"
    )

    $content = $contentLines -join "`r`n"

    # Robust gegen Mojibake durch unterschiedliche Skript-Decodierung (z. B. PS5 ohne BOM).
    $content = $content.Replace(([string]([char]0x00C3) + [char]0x00BC), [string][char]0x00FC) # Ã¼ -> ü
    $content = $content.Replace(([string]([char]0x00C3) + [char]0x00A4), [string][char]0x00E4) # Ã¤ -> ä
    $content = $content.Replace(([string]([char]0x00C3) + [char]0x00B6), [string][char]0x00F6) # Ã¶ -> ö
    $content = $content.Replace(([string]([char]0x00C3) + [char]0x009F), [string][char]0x00DF) # ÃŸ -> ß
    $content = $content.Replace(([string]([char]0x00C3) + [char]0x009C), [string][char]0x00DC) # Ãœ -> Ü
    $content = $content.Replace(([string]([char]0x00C3) + [char]0x0096), [string][char]0x00D6) # Ã– -> Ö
    $content = $content.Replace(([string]([char]0x00C3) + [char]0x0084), [string][char]0x00C4) # Ã„ -> Ä

    # Explizit UTF-8 mit BOM schreiben (Windows-/Editor-kompatibel für Umlaute).
    [System.IO.File]::WriteAllText($notesPath, $content, (New-Object System.Text.UTF8Encoding($true)))
    Write-Host "Release-Notes erstellt/aktualisiert: $notesPath" -ForegroundColor Green
    return $notesPath
}

Write-Host "\nICDL-Ergebnisse Build" -ForegroundColor Green
Write-Host "====================\n" -ForegroundColor Green

$version = Get-NextVersion -Path $versionFile
Write-Host "Version für dieses Build: $version" -ForegroundColor Cyan

$pythonCommand = Resolve-PythonCommand
Write-Host "Verwende Python: $($pythonCommand -join ' ')" -ForegroundColor DarkGray

Write-Host "1) PyInstaller-Build wird erstellt ..." -ForegroundColor Cyan
$pyArgs = @()
if ($pythonCommand.Count -gt 1) {
    $pyArgs += $pythonCommand[1..($pythonCommand.Count - 1)]
}
$pyArgs += @('-m', 'PyInstaller', $specFile, '--noconfirm')
& $pythonCommand[0] $pyArgs

if ($LASTEXITCODE -ne 0) {
    throw "PyInstaller fehlgeschlagen (ExitCode $LASTEXITCODE)."
}

if (-not (Test-Path $rawExe)) {
    throw "Erwartete EXE nicht gefunden: $rawExe"
}

$buildDirName = "ICDL-Ergebnisse-v$version"
$buildDir = Join-Path $distRoot $buildDirName
New-Item -ItemType Directory -Path $buildDir -Force | Out-Null

$targetExe = Join-Path $buildDir 'ICDL-Ergebnisse.exe'
Move-Item -Path $rawExe -Destination $targetExe -Force
Write-Host "2) EXE abgelegt in: $targetExe" -ForegroundColor Green

if (Test-Path $docsDir) {
    $targetDocs = Join-Path $buildDir 'docs'
    New-Item -ItemType Directory -Path $targetDocs -Force | Out-Null
    Copy-Item -Path (Join-Path $docsDir '*') -Destination $targetDocs -Recurse -Force
    Write-Host "3) Dokumentation kopiert nach: $targetDocs" -ForegroundColor Green
}

$targetDemo = Join-Path $buildDir 'demo'
New-Item -ItemType Directory -Path $targetDemo -Force | Out-Null
if (Test-Path $demoDir) {
    Copy-Item -Path (Join-Path $demoDir '*') -Destination $targetDemo -Recurse -Force
    Write-Host "3b) Demo-Dateien kopiert nach: $targetDemo" -ForegroundColor Green
}
else {
    Write-Host "3b) Kein demo-Quellordner gefunden; leerer demo-Ordner im Build angelegt." -ForegroundColor DarkGray
}

$archiveIncluded = $false
$targetArchive = Join-Path $buildDir 'archive'
New-Item -ItemType Directory -Path $targetArchive -Force | Out-Null
if (Test-Path $archiveDir) {
    Copy-Item -Path (Join-Path $archiveDir '*') -Destination $targetArchive -Recurse -Force
    $archiveIncluded = $true
    Write-Host "4) Archivdaten kopiert nach: $targetArchive" -ForegroundColor Green
}
else {
    $archiveIncluded = $true
    Write-Host "4) Kein archive-Quellordner gefunden; leerer archive-Ordner für Release angelegt." -ForegroundColor DarkGray
}

$archiveItems = Get-ChildItem -Path $targetArchive -Force -ErrorAction SilentlyContinue
if (-not $archiveItems -or $archiveItems.Count -eq 0) {
    $placeholder = Join-Path $targetArchive 'ARCHIVE_PLACEHOLDER.txt'
    Set-Content -Path $placeholder -Value 'Platzhalter, damit der archive-Ordner im Release-ZIP enthalten ist.' -Encoding UTF8
    Write-Host "4b) Archiv-Platzhalter erstellt: $placeholder" -ForegroundColor DarkGray
}

$exeName = Split-Path $targetExe -Leaf
$null = New-ReleaseNotesFile `
    -Version $version `
    -BuildDirName $buildDirName `
    -ExeName $exeName `
    -ReleaseDir $releaseDir `
    -ArchiveIncluded $archiveIncluded

if ($SkipZip) {
    Write-Host "5) ZIP-Erstellung übersprungen (-SkipZip)." -ForegroundColor Yellow
}
else {
    New-Item -ItemType Directory -Path $releaseDir -Force | Out-Null
    $releasePackageDir = Join-Path $releaseDir $buildDirName
    if (Test-Path $releasePackageDir) {
        Remove-Item -Path $releasePackageDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $releasePackageDir -Force | Out-Null
    Copy-Item -Path (Join-Path $buildDir '*') -Destination $releasePackageDir -Recurse -Force

    $zipPath = Join-Path $releaseDir ($buildDirName + '.zip')

    if (Test-Path $zipPath) {
        Remove-Item $zipPath -Force
    }

    # ZIP ohne Wrapper-Ordner (Explorer-kompatibel): Inhalt des Build-Ordners archivieren.
    Compress-Archive -Path (Join-Path $releasePackageDir '*') -DestinationPath $zipPath -CompressionLevel Optimal -Force
    $null = New-ReleaseNotesFile `
        -Version $version `
        -BuildDirName $buildDirName `
        -ExeName $exeName `
        -ReleaseDir $releaseDir `
        -ArchiveIncluded $archiveIncluded `
        -ZipFileName (Split-Path $zipPath -Leaf)

    Write-Host "5) Release-ZIP erstellt: $zipPath" -ForegroundColor Green
}

Write-Host "\nBuild erfolgreich abgeschlossen." -ForegroundColor Green
Write-Host "Build-Ordner: $buildDir" -ForegroundColor White
exit 0
