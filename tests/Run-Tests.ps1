#Requires -Version 5.1

<#
.SYNOPSIS
    Führt Pester-Tests für den QA Documentation Generator aus.

.DESCRIPTION
    Installiert bei Bedarf Pester (>= 5) im CurrentUser-Scope und startet anschließend die Tests.
    (Ideal für neue Rechner / CI.)

.EXAMPLE
    .\tests\Run-Tests.ps1
#>

[CmdletBinding()]
param()

$minVersion = [Version]'5.0.0'

function Get-PesterModule {
    $modules = Get-Module -ListAvailable Pester | Sort-Object Version -Descending
    return $modules | Select-Object -First 1
}

$pester = Get-PesterModule

if (-not $pester -or ([Version]$pester.Version -lt $minVersion)) {
    Write-Host "Pester (>= $minVersion) nicht gefunden. Installiere im CurrentUser Scope..." -ForegroundColor Yellow
    try {
        Install-Module Pester -Scope CurrentUser -Force -MinimumVersion $minVersion -AllowClobber
    }
    catch {
        Write-Error "Konnte Pester nicht installieren: $($_.Exception.Message)"
        Write-Host "Hinweis: Falls deine PowerShell-Policy oder PSGallery blockiert, installiere Pester manuell." -ForegroundColor Yellow
        exit 1
    }
}

Import-Module Pester -Force

$testPath = Join-Path $PSScriptRoot "QADocumentGenerator.Tests.ps1"
Invoke-Pester -Path $testPath -CI

