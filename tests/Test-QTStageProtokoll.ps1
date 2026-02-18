#Requires -Version 5.1

<#
.SYNOPSIS
    Tests für QTStageProtokoll Template
    
.DESCRIPTION
    Testet die Validierung und Generierung von QTStageProtokoll Dokumenten
#>

$ErrorActionPreference = 'Stop'

# Pfade
$scriptRoot = Split-Path -Parent $PSScriptRoot
$generateScript = Join-Path $scriptRoot "Generate-QADocument.ps1"
$exampleConfig = Join-Path $scriptRoot "examples\beispiel_qtstage_protokoll.json"
$templateFile = Join-Path $scriptRoot "templates\template_qtstage_protokoll.json"

Write-Host "=== QTStageProtokoll Tests ===" -ForegroundColor Cyan
Write-Host ""

# Test 1: Template-Datei existiert
Write-Host "Test 1: Template-Datei existiert..." -ForegroundColor Yellow
if (Test-Path $templateFile) {
    Write-Host "  ✅ PASSED: Template gefunden" -ForegroundColor Green
} else {
    Write-Host "  ❌ FAILED: Template nicht gefunden: $templateFile" -ForegroundColor Red
    exit 1
}

# Test 2: Beispiel-Konfiguration existiert
Write-Host "Test 2: Beispiel-Konfiguration existiert..." -ForegroundColor Yellow
if (Test-Path $exampleConfig) {
    Write-Host "  ✅ PASSED: Beispiel gefunden" -ForegroundColor Green
} else {
    Write-Host "  ❌ FAILED: Beispiel nicht gefunden: $exampleConfig" -ForegroundColor Red
    exit 1
}

# Test 3: Beispiel-Konfiguration ist valides JSON
Write-Host "Test 3: Beispiel-Konfiguration ist valides JSON..." -ForegroundColor Yellow
try {
    $config = Get-Content -Path $exampleConfig -Raw -Encoding UTF8 | ConvertFrom-Json
    Write-Host "  ✅ PASSED: JSON ist valide" -ForegroundColor Green
} catch {
    Write-Host "  ❌ FAILED: JSON ist nicht valide: $_" -ForegroundColor Red
    exit 1
}

# Test 4: Pflichtfelder vorhanden
Write-Host "Test 4: Pflichtfelder vorhanden..." -ForegroundColor Yellow
$requiredFields = @('Titel', 'Version', 'Datum', 'Tester', 'ServiceAccountID', 'Startzeit', 'Endzeit', 'GeräteIDs', 'TestKategorien')
$missingFields = @()

foreach ($field in $requiredFields) {
    if (-not ($config.PSObject.Properties.Name -contains $field)) {
        $missingFields += $field
    }
}

if ($missingFields.Count -eq 0) {
    Write-Host "  ✅ PASSED: Alle Pflichtfelder vorhanden" -ForegroundColor Green
} else {
    Write-Host "  ❌ FAILED: Fehlende Felder: $($missingFields -join ', ')" -ForegroundColor Red
    exit 1
}

# Test 5: TestKategorien ist Array
Write-Host "Test 5: TestKategorien ist Array..." -ForegroundColor Yellow
if ($config.TestKategorien -is [Array]) {
    Write-Host "  ✅ PASSED: TestKategorien ist Array" -ForegroundColor Green
} else {
    Write-Host "  ❌ FAILED: TestKategorien ist kein Array" -ForegroundColor Red
    exit 1
}

# Test 6: TestKategorien enthält Tests
Write-Host "Test 6: TestKategorien enthält Tests..." -ForegroundColor Yellow
$hasTests = $false
foreach ($kategorie in $config.TestKategorien) {
    if ($kategorie.UIScreens -or $kategorie.Tests) {
        $hasTests = $true
        break
    }
}

if ($hasTests) {
    Write-Host "  ✅ PASSED: TestKategorien enthält Tests" -ForegroundColor Green
} else {
    Write-Host "  ❌ FAILED: Keine Tests in TestKategorien gefunden" -ForegroundColor Red
    exit 1
}

# Test 7: PlattformTests vorhanden und valide
Write-Host "Test 7: PlattformTests vorhanden und valide..." -ForegroundColor Yellow
if ($config.PlattformTests -and $config.PlattformTests -is [Array] -and $config.PlattformTests.Count -gt 0) {
    Write-Host "  ✅ PASSED: PlattformTests valide" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  WARNING: PlattformTests nicht vorhanden oder leer" -ForegroundColor Yellow
}

# Test 8: TestAccounts vorhanden und valide
Write-Host "Test 8: TestAccounts vorhanden und valide..." -ForegroundColor Yellow
if ($config.TestAccounts -and $config.TestAccounts -is [Array] -and $config.TestAccounts.Count -gt 0) {
    Write-Host "  ✅ PASSED: TestAccounts valide" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  WARNING: TestAccounts nicht vorhanden oder leer" -ForegroundColor Yellow
}

# Test 9: BlockierteTests vorhanden und valide
Write-Host "Test 9: BlockierteTests vorhanden und valide..." -ForegroundColor Yellow
if ($config.BlockierteTests -and $config.BlockierteTests -is [Array] -and $config.BlockierteTests.Count -gt 0) {
    Write-Host "  ✅ PASSED: BlockierteTests valide" -ForegroundColor Green
} else {
    Write-Host "  ⚠️  WARNING: BlockierteTests nicht vorhanden oder leer" -ForegroundColor Yellow
}

# Test 10: Dokument-Generierung funktioniert
Write-Host "Test 10: Dokument-Generierung funktioniert..." -ForegroundColor Yellow
$outputPath = Join-Path $env:TEMP "test_qtstage_protokoll.md"

try {
    & $generateScript -ConfigFile $exampleConfig -Template "QTStageProtokoll" -OutputPath $outputPath -NoPrompt
    
    if (Test-Path $outputPath) {
        $content = Get-Content -Path $outputPath -Raw -Encoding UTF8
        
        # Prüfe ob wichtige Abschnitte vorhanden sind
        $requiredSections = @(
            '## 📊 Metadaten',
            '## 📱 Geräte-IDs',
            '## ✅ Test-Kategorien'
        )
        
        $missingSections = @()
        foreach ($section in $requiredSections) {
            if ($content -notmatch [regex]::Escape($section)) {
                $missingSections += $section
            }
        }
        
        if ($missingSections.Count -eq 0) {
            Write-Host "  ✅ PASSED: Dokument erfolgreich generiert" -ForegroundColor Green
        } else {
            Write-Host "  ❌ FAILED: Fehlende Abschnitte: $($missingSections -join ', ')" -ForegroundColor Red
            exit 1
        }
        
        # Cleanup
        Remove-Item $outputPath -Force
    } else {
        Write-Host "  ❌ FAILED: Dokument wurde nicht erstellt" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "  ❌ FAILED: Fehler bei Generierung: $_" -ForegroundColor Red
    exit 1
}

# Test 11: Status-Symbole werden korrekt gemappt
Write-Host "Test 11: Status-Symbole werden korrekt gemappt..." -ForegroundColor Yellow
$outputPath = Join-Path $env:TEMP "test_qtstage_symbols.md"

try {
    & $generateScript -ConfigFile $exampleConfig -Template "QTStageProtokoll" -OutputPath $outputPath -NoPrompt
    $content = Get-Content -Path $outputPath -Raw -Encoding UTF8
    
    $expectedSymbols = @('✅', '⚠️', 'ℹ️', '❌')
    $foundSymbols = @()
    
    foreach ($symbol in $expectedSymbols) {
        if ($content -match [regex]::Escape($symbol)) {
            $foundSymbols += $symbol
        }
    }
    
    if ($foundSymbols.Count -ge 2) {
        Write-Host "  ✅ PASSED: Status-Symbole gefunden ($($foundSymbols.Count)/$($expectedSymbols.Count))" -ForegroundColor Green
    } else {
        Write-Host "  ❌ FAILED: Zu wenige Status-Symbole gefunden" -ForegroundColor Red
        exit 1
    }
    
    # Cleanup
    Remove-Item $outputPath -Force
} catch {
    Write-Host "  ❌ FAILED: Fehler beim Symbol-Test: $_" -ForegroundColor Red
    exit 1
}

# Test 12: Plattform-Symbole werden korrekt gemappt
Write-Host "Test 12: Plattform-Symbole werden korrekt gemappt..." -ForegroundColor Yellow
$outputPath = Join-Path $env:TEMP "test_qtstage_platforms.md"

try {
    & $generateScript -ConfigFile $exampleConfig -Template "QTStageProtokoll" -OutputPath $outputPath -NoPrompt
    $content = Get-Content -Path $outputPath -Raw -Encoding UTF8
    
    $expectedPlatformSymbols = @('🔌', '☁️', '📱', '🖥️')
    $foundPlatformSymbols = @()
    
    foreach ($symbol in $expectedPlatformSymbols) {
        if ($content -match [regex]::Escape($symbol)) {
            $foundPlatformSymbols += $symbol
        }
    }
    
    if ($foundPlatformSymbols.Count -ge 2) {
        Write-Host "  ✅ PASSED: Plattform-Symbole gefunden ($($foundPlatformSymbols.Count)/$($expectedPlatformSymbols.Count))" -ForegroundColor Green
    } else {
        Write-Host "  ⚠️  WARNING: Wenige Plattform-Symbole gefunden" -ForegroundColor Yellow
    }
    
    # Cleanup
    Remove-Item $outputPath -Force
} catch {
    Write-Host "  ❌ FAILED: Fehler beim Plattform-Symbol-Test: $_" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "=== Alle Tests erfolgreich! ===" -ForegroundColor Green
Write-Host ""
