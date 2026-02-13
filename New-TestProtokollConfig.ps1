#Requires -Version 5.1

<#
.SYNOPSIS
    Erzeugt automatisch eine neue Testprotokoll-JSON aus dem TestCase-Katalog.

.DESCRIPTION
    Dieses Script liest den TestCase-Katalog (z.B. testcases_hosenso_qt_stage.json),
    erzeugt daraus eine neue TestProtokoll-Konfigurationsdatei im JSON-Format
    und trägt alle TestCases bereits mit ID und Szenario ein.

    Du musst anschließend nur noch:
    - Status (✅ / ⚠️ / ❌ / leer) und
    - Bemerkungen
    im JSON ausfüllen und kannst dann mit Generate-QADocument.ps1 das Markdown-Protokoll erzeugen.

.EXAMPLE
    .\New-TestProtokollConfig.ps1 -Version "1.3.6 Stage" -Tester "Tobias Buß"

.EXAMPLE
    .\New-TestProtokollConfig.ps1 -Version "1.3.6 Stage" -Tester "QA Team" -Testumgebung "Stage" -OutputDirectory ".\data"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, HelpMessage = "Version / Name des Testlaufs, z.B. '1.3.6 Stage'")]
    [string]$Version,

    [Parameter(Mandatory = $false, HelpMessage = "Name des Testers oder Teams")]
    [string]$Tester = "QA Team",

    [Parameter(Mandatory = $false, HelpMessage = "Testumgebung, z.B. Stage, RC, Prod")]
    [string]$Testumgebung = "Stage",

    [Parameter(Mandatory = $false, HelpMessage = "Test-Typ, z.B. QT@Stage")]
    [string]$TestTyp = "QT@Stage (Pre-Release Testing)",

    [Parameter(Mandatory = $false, HelpMessage = "Geplante Dauer, z.B. '4 Stunden'")]
    [string]$Dauer = "",

    [Parameter(Mandatory = $false, HelpMessage = "Gesamtstatus des Testlaufs")]
    [string]$Status = "Geplant",

    [Parameter(Mandatory = $false, HelpMessage = "Pfad zur TestCase-Definition")]
    [string]$TestCasesFile = ".\testcases_hosenso_qt_stage.json",

    [Parameter(Mandatory = $false, HelpMessage = "Ausgabe-Ordner für die neue JSON-Datei")]
    [string]$OutputDirectory = ".\data"
)

Write-Host "=== Neue TestProtokoll-Konfiguration erzeugen ===" -ForegroundColor Cyan
Write-Host ""

if (-not (Test-Path -Path $TestCasesFile -PathType Leaf)) {
    Write-Error "TestCases-Datei wurde nicht gefunden: $TestCasesFile"
    exit 1
}

try {
    Write-Host "Lese TestCases aus '$TestCasesFile'..." -ForegroundColor Yellow
    $testCasesJson = Get-Content -Path $TestCasesFile -Raw -Encoding UTF8 | ConvertFrom-Json
}
catch {
    Write-Error "Fehler beim Laden der TestCases-Datei: $_"
    exit 1
}

# Alle TestCases aus den Kategorien in eine flache Liste bringen
$tests = @()

foreach ($kategorie in $testCasesJson.Kategorien) {
    foreach ($tc in $kategorie.TestCases) {
        $tests += [pscustomobject]@{
            ID        = $tc.ID
            Testfall  = $tc.Szenario
            Status    = ""
            Bemerkung = ""
        }
    }
}

if ($tests.Count -eq 0) {
    Write-Error "In der TestCases-Datei wurden keine TestCases gefunden."
    exit 1
}

Write-Host "Insgesamt $($tests.Count) TestCases gefunden." -ForegroundColor Green
Write-Host ""

# Basisdaten für das neue Testprotokoll
$heute = Get-Date

$config = [pscustomobject]@{
    Titel         = "$Version Stage"
    Version       = $Version
    Datum         = $heute.ToString("dd.MM.yyyy")
    Tester        = $Tester
    Testumgebung  = $Testumgebung
    TestTyp       = $TestTyp
    Dauer         = $Dauer
    Status        = $Status
    Testziele     = @(
        "- Funktionalität der wichtigsten Bereiche testen (siehe TestCase-Katalog)",
        "- Kritische und wichtige TestCases ausführen (Priorität = Hoch/Kritisch/Wichtig)",
        "- Gefundene Bugs und Auffälligkeiten dokumentieren"
    )
    Browser       = ""
    OS            = ""
    Gerät         = ""
    Tests         = $tests
    GefundeneBugs = @()
    Statistik     = [pscustomobject]@{
        Gesamt        = $tests.Count
        Erfolgreich   = 0
        Fehlgeschlagen = 0
        Übersprungen  = 0
        Erfolgsrate   = 0
    }
    Empfehlungen  = @()
    Bemerkungen   = ""
}

# Ausgabeverzeichnis sicherstellen
if (-not (Test-Path -Path $OutputDirectory -PathType Container)) {
    Write-Host "Erstelle Ausgabe-Ordner: $OutputDirectory" -ForegroundColor Yellow
    New-Item -ItemType Directory -Path $OutputDirectory -Force | Out-Null
}

# Dateinamen aus Version und Datum generieren
$safeVersion = ($Version -replace "[^0-9A-Za-z\-]+", "_")
$fileName = "testprotokoll_${safeVersion}_$($heute.ToString('yyyyMMdd_HHmmss')).json"
$outputPath = Join-Path -Path $OutputDirectory -ChildPath $fileName

try {
    $config | ConvertTo-Json -Depth 10 | Out-File -FilePath $outputPath -Encoding UTF8 -Force
    Write-Host "✅ Neue TestProtokoll-Konfiguration erstellt:" -ForegroundColor Green
    Write-Host "   $outputPath" -ForegroundColor White
    Write-Host ""
    Write-Host "Nächste Schritte:" -ForegroundColor Cyan
    Write-Host "1) Öffne die Datei in deinem Editor und trage für jeden TestCase 'Status' und 'Bemerkung' ein." -ForegroundColor White
    Write-Host "2) Erzeuge anschließend das Markdown-Testprotokoll mit:" -ForegroundColor White
    Write-Host "" -ForegroundColor White
    Write-Host "   .\Generate-QADocument.ps1 -ConfigFile `"$outputPath`" -Template `"TestProtokoll`"" -ForegroundColor Yellow
    Write-Host "" -ForegroundColor White
}
catch {
    Write-Error "Fehler beim Schreiben der TestProtokoll-Datei: $_"
    exit 1
}

