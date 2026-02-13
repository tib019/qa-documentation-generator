#Requires -Version 5.1

<#
.SYNOPSIS
    Generiert professionelle QA-Dokumentation aus Vorlagen und Daten.

.DESCRIPTION
    Dieses Script nimmt eine JSON-Konfigurationsdatei mit Ihren Daten und generiert
    daraus ein professionelles Markdown-Dokument im einheitlichen Format.
    
    Unterstützte Dokumenttypen:
    - Bug-Tickets
    - Test-Protokolle
    - Lösungskonzepte
    - Analyse-Berichte
    - Test Cases

.PARAMETER ConfigFile
    Pfad zur JSON-Konfigurationsdatei mit Ihren Daten

.PARAMETER Template
    Typ des zu generierenden Dokuments (BugTicket, TestProtokoll, Lösungskonzept, etc.)

.PARAMETER OutputPath
    Pfad für das generierte Markdown-Dokument (optional)

.EXAMPLE
    .\Generate-QADocument.ps1 -ConfigFile "bug_data.json" -Template "BugTicket"
    
.EXAMPLE
    .\Generate-QADocument.ps1 -ConfigFile "test_data.json" -Template "TestProtokoll" -OutputPath "output/testprotokoll.md"

.NOTES
    Autor: QA Team Hosenso
    Version: 1.0
    Datum: 13.02.2026
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory=$true, HelpMessage="Pfad zur JSON-Konfigurationsdatei")]
    [ValidateScript({Test-Path $_ -PathType Leaf})]
    [string]$ConfigFile,
    
    [Parameter(Mandatory=$true, HelpMessage="Dokumenttyp")]
    [ValidateSet('BugTicket', 'TestProtokoll', 'Lösungskonzept', 'AnalyseBericht', 'TestCases')]
    [string]$Template,
    
    [Parameter(Mandatory=$false, HelpMessage="Ausgabepfad für Markdown-Dokument")]
    [string]$OutputPath = ""
)

# Funktion: JSON-Daten laden
function Get-ConfigData {
    param([string]$Path)
    
    try {
        $jsonContent = Get-Content -Path $Path -Raw -Encoding UTF8
        $data = $jsonContent | ConvertFrom-Json
        Write-Verbose "Konfigurationsdaten erfolgreich geladen: $Path"
        return $data
    }
    catch {
        Write-Error "Fehler beim Laden der Konfigurationsdatei: $_"
        exit 1
    }
}

# Funktion: Bug-Ticket generieren
function New-BugTicketDocument {
    param($Data)
    
    $markdown = @"
# Bug-Ticket: $($Data.Titel)

**Bug-ID:** #$($Data.BugID)  
**Erstellt am:** $($Data.Datum)  
**Ersteller:** $($Data.Ersteller)  
**Schweregrad:** $($Data.Schweregrad)  
**Status:** $($Data.Status)  

---

## 📋 Zusammenfassung

$($Data.Zusammenfassung)

---

## 🔍 Beschreibung

$($Data.Beschreibung)

---

## 📱 Betroffene Plattformen

$($Data.Plattformen -join "`n")

---

## 🔄 Schritte zur Reproduktion

$($Data.Reproduktionsschritte | ForEach-Object { $i = 1 } { "$i. $_"; $i++ } | Out-String)

---

## ✅ Erwartetes Verhalten

$($Data.ErwartetesVerhalten)

---

## ❌ Tatsächliches Verhalten

$($Data.TatsächlichesVerhalten)

---

## 🖼️ Screenshots/Videos

$($Data.Screenshots -join "`n")

---

## 🔧 Technische Details

**Browser/App-Version:** $($Data.TechnischeDetails.Version)  
**Betriebssystem:** $($Data.TechnischeDetails.OS)  
**Gerät:** $($Data.TechnischeDetails.Gerät)  

---

## 💡 Mögliche Ursache

$($Data.MöglicheUrsache)

---

## 🛠️ Lösungsvorschlag

$($Data.Lösungsvorschlag)

---

## 🔗 Verwandte Tickets

$($Data.VerwandteTickets -join "`n")

---

**Erstellt von:** $($Data.Ersteller)  
**Letzte Aktualisierung:** $($Data.Datum)  
"@
    
    return $markdown
}

# Funktion: Test-Protokoll generieren
function New-TestProtokollDocument {
    param($Data)
    
    $markdown = @"
# Test-Protokoll: $($Data.Titel)

**Version:** $($Data.Version)  
**Datum:** $($Data.Datum)  
**Tester:** $($Data.Tester)  
**Testumgebung:** $($Data.Testumgebung)  

---

## 📋 Übersicht

**Getestete Version:** $($Data.Version)  
**Test-Typ:** $($Data.TestTyp)  
**Dauer:** $($Data.Dauer)  
**Status:** $($Data.Status)  

---

## 🎯 Testziele

$($Data.Testziele -join "`n")

---

## 🔧 Testumgebung

**Plattform:** $($Data.Testumgebung)  
**Browser/App:** $($Data.Browser)  
**Betriebssystem:** $($Data.OS)  
**Gerät:** $($Data.Gerät)  

---

## ✅ Durchgeführte Tests

| Test-ID | Testfall | Status | Bemerkung |
|---------|----------|--------|-----------|
$($Data.Tests | ForEach-Object { "| $($_.ID) | $($_.Testfall) | $($_.Status) | $($_.Bemerkung) |" } | Out-String)

---

## 🐛 Gefundene Bugs

$($Data.GefundeneBugs | ForEach-Object { "- **#$($_.BugID)**: $($_.Titel) (Schweregrad: $($_.Schweregrad))" } | Out-String)

---

## 📊 Test-Statistik

**Tests gesamt:** $($Data.Statistik.Gesamt)  
**Erfolgreich:** $($Data.Statistik.Erfolgreich)  
**Fehlgeschlagen:** $($Data.Statistik.Fehlgeschlagen)  
**Übersprungen:** $($Data.Statistik.Übersprungen)  
**Erfolgsrate:** $($Data.Statistik.Erfolgsrate)%  

---

## 💡 Empfehlungen

$($Data.Empfehlungen -join "`n")

---

## 📝 Bemerkungen

$($Data.Bemerkungen)

---

**Erstellt von:** $($Data.Tester)  
**Datum:** $($Data.Datum)  
"@
    
    return $markdown
}

# Funktion: Lösungskonzept generieren
function New-LösungskonzeptDocument {
    param($Data)
    
    $markdown = @"
# Lösungskonzept: $($Data.Titel)

**Für:** $($Data.Empfänger)  
**Problem:** $($Data.Problem)  
**Datum:** $($Data.Datum)  
**Ersteller:** $($Data.Ersteller)  

---

## 🎯 Problemanalyse

### Was ist passiert?

$($Data.Problemanalyse.WasIstPassiert)

### Warum passiert das?

$($Data.Problemanalyse.WarumPassiertDas)

**Typische Situation:**

$($Data.Problemanalyse.TypischeSituation -join "`n")

**Konkrete Auswirkungen:**

$($Data.Problemanalyse.Auswirkungen -join "`n")

---

## 🔍 Root Cause Analysis

### Primäre Ursachen

$($Data.RootCause | ForEach-Object { $i = 1 } { "**$i. $($_.Titel)**`n$($_.Beschreibung)`n"; $i++ } | Out-String)

---

## 💡 Lösungsansätze

### Kurzfristige Lösungen (1-2 Wochen)

$($Data.Lösungen.Kurzfristig | ForEach-Object { 
    "#### $($_.Nummer). $($_.Titel)`n`n**Problem:** $($_.Problem)`n`n**Lösungsansatz:** $($_.Lösungsansatz)`n`n**Aufwand:** $($_.Aufwand)`n**Impact:** $($_.Impact)`n**Risiko:** $($_.Risiko)`n"
} | Out-String)

### Mittelfristige Lösungen (1-2 Monate)

$($Data.Lösungen.Mittelfristig | ForEach-Object { 
    "#### $($_.Nummer). $($_.Titel)`n`n**Problem:** $($_.Problem)`n`n**Lösungsansatz:** $($_.Lösungsansatz)`n`n**Aufwand:** $($_.Aufwand)`n**Impact:** $($_.Impact)`n**Risiko:** $($_.Risiko)`n"
} | Out-String)

---

## 🎯 Empfehlung

### Phase 1: Sofort (vor nächster Messe)

$($Data.Empfehlung.Phase1 -join "`n")

**Gesamt:** $($Data.Empfehlung.Phase1Gesamt.Aufwand)  
**Kosten:** $($Data.Empfehlung.Phase1Gesamt.Kosten)  
**Ergebnis:** $($Data.Empfehlung.Phase1Gesamt.Ergebnis)  

---

## 📋 Nächste Schritte

### Diese Woche

$($Data.NächsteSchritte.DieseWoche -join "`n")

### Nächste Woche

$($Data.NächsteSchritte.NächsteWoche -join "`n")

---

**Erstellt von:** $($Data.Ersteller)  
**Version:** 1.0  
**Letzte Aktualisierung:** $($Data.Datum)  
"@
    
    return $markdown
}

# Funktion: Analyse-Bericht generieren
function New-AnalyseBerichtDocument {
    param($Data)
    
    $markdown = @"
# Analyse-Bericht: $($Data.Titel)

**Datum:** $($Data.Datum)  
**Ersteller:** $($Data.Ersteller)  
**Bereich:** $($Data.Bereich)  

---

## 📋 Executive Summary

$($Data.ExecutiveSummary)

---

## 🎯 Analyseziele

$($Data.Analyseziele -join "`n")

---

## 🔍 Methodik

$($Data.Methodik)

---

## 📊 Ergebnisse

$($Data.Ergebnisse | ForEach-Object { 
    "### $($_.Titel)`n`n$($_.Beschreibung)`n`n**Kennzahlen:**`n$($_.Kennzahlen -join "`n")`n"
} | Out-String)

---

## 💡 Empfehlungen

$($Data.Empfehlungen | ForEach-Object { $i = 1 } { "$i. **$($_.Titel)**: $($_.Beschreibung)"; $i++ } | Out-String)

---

## 📈 Priorisierung

| Empfehlung | Priorität | Aufwand | Impact |
|------------|-----------|---------|--------|
$($Data.Priorisierung | ForEach-Object { "| $($_.Empfehlung) | $($_.Priorität) | $($_.Aufwand) | $($_.Impact) |" } | Out-String)

---

## 📝 Fazit

$($Data.Fazit)

---

**Erstellt von:** $($Data.Ersteller)  
**Datum:** $($Data.Datum)  
"@
    
    return $markdown
}

# Funktion: Test Cases generieren
function New-TestCasesDocument {
    param($Data)
    
    $markdown = @"
# Test Cases: $($Data.Titel)

**Erstellt für:** $($Data.Projekt)  
**Datum:** $($Data.Datum)  
**Ersteller:** $($Data.Ersteller)  

---

## 🎯 Übersicht

$($Data.Übersicht)

---

## 📋 Test Case Kategorien

$($Data.Kategorien | ForEach-Object {
    "### $($_.Nummer). $($_.Titel)`n`n$($_.Beschreibung)`n`n| Test Case ID | Szenario | Erwartetes Verhalten | Priorität |`n|--------------|----------|---------------------|-----------|`n" + 
    ($_.TestCases | ForEach-Object { "| $($_.ID) | $($_.Szenario) | $($_.ErwartetesVerhalten) | $($_.Priorität) |" } | Out-String) + "`n"
} | Out-String)

---

## 🛠️ Technische Umsetzung

$($Data.TechnischeUmsetzung)

---

## 📊 Test-Durchführung & Dokumentation

$($Data.TestDurchführung)

---

## 🎯 Priorisierung

### Kritische Tests (sofort durchführen)

$($Data.Priorisierung.Kritisch -join "`n")

### Wichtige Tests (nächste Sprint)

$($Data.Priorisierung.Wichtig -join "`n")

---

## 📈 Erfolgskriterien

$($Data.Erfolgskriterien -join "`n")

---

**Erstellt von:** $($Data.Ersteller)  
**Version:** 1.0  
**Letzte Aktualisierung:** $($Data.Datum)  
"@
    
    return $markdown
}

# Hauptlogik
Write-Host "=== QA-Dokumenten-Generator ===" -ForegroundColor Cyan
Write-Host ""

# Konfigurationsdaten laden
Write-Host "Lade Konfigurationsdaten..." -ForegroundColor Yellow
$config = Get-ConfigData -Path $ConfigFile

# Dokument generieren basierend auf Template
Write-Host "Generiere $Template Dokument..." -ForegroundColor Yellow

$markdown = switch ($Template) {
    'BugTicket'       { New-BugTicketDocument -Data $config }
    'TestProtokoll'   { New-TestProtokollDocument -Data $config }
    'Lösungskonzept'  { New-LösungskonzeptDocument -Data $config }
    'AnalyseBericht'  { New-AnalyseBerichtDocument -Data $config }
    'TestCases'       { New-TestCasesDocument -Data $config }
    default {
        Write-Error "Unbekannter Template-Typ: $Template"
        exit 1
    }
}

# Ausgabepfad bestimmen
if ([string]::IsNullOrEmpty($OutputPath)) {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $filename = "$($Template.ToLower())_$timestamp.md"
    $OutputPath = Join-Path -Path (Get-Location) -ChildPath $filename
}

# Markdown-Dokument speichern
try {
    $markdown | Out-File -FilePath $OutputPath -Encoding UTF8 -Force
    Write-Host "✅ Dokument erfolgreich erstellt: $OutputPath" -ForegroundColor Green
    Write-Host ""
    
    # Statistik anzeigen
    $lines = ($markdown -split "`n").Count
    $chars = $markdown.Length
    Write-Host "Statistik:" -ForegroundColor Cyan
    Write-Host "  - Zeilen: $lines" -ForegroundColor White
    Write-Host "  - Zeichen: $chars" -ForegroundColor White
    Write-Host ""
    
    # Öffnen-Option anbieten
    $open = Read-Host "Möchten Sie das Dokument öffnen? (J/N)"
    if ($open -eq 'J' -or $open -eq 'j') {
        Start-Process $OutputPath
    }
}
catch {
    Write-Error "Fehler beim Speichern des Dokuments: $_"
    exit 1
}

Write-Host "Fertig! 🎉" -ForegroundColor Green
