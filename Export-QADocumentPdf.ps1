#Requires -Version 5.1

<#
.SYNOPSIS
    Exportiert ein QA-Dokument zusätzlich als PDF (via Pandoc).

.DESCRIPTION
    Erzeugt aus einer JSON-Konfigurationsdatei zuerst ein Markdown-Dokument (per Generate-QADocument.ps1),
    und wandelt dieses anschließend mit Pandoc in ein PDF um.

    Voraussetzung: Pandoc muss installiert sein und im PATH liegen (Befehl: pandoc).

.EXAMPLE
    .\Export-QADocumentPdf.ps1 -ConfigFile ".\examples\beispiel_test_protokoll.json" -Template "TestProtokoll" -OutputPdfPath ".\output\testprotokoll.pdf"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateScript({ Test-Path $_ -PathType Leaf })]
    [string]$ConfigFile,

    [Parameter(Mandatory = $true)]
    [ValidateSet('BugTicket', 'TestProtokoll', 'Lösungskonzept', 'AnalyseBericht', 'TestCases')]
    [string]$Template,

    [Parameter(Mandatory = $true)]
    [string]$OutputPdfPath,

    [Parameter(Mandatory = $false)]
    [string]$PandocPath = "pandoc",

    [Parameter(Mandatory = $false)]
    [string[]]$PandocArgs = @()
)

$ErrorActionPreference = 'Stop'

$repoRoot = $PSScriptRoot
$generator = Join-Path $repoRoot "Generate-QADocument.ps1"
if (-not (Test-Path -Path $generator -PathType Leaf)) {
    throw "Generate-QADocument.ps1 nicht gefunden in: $repoRoot"
}

try {
    $null = Get-Command $PandocPath -ErrorAction Stop
}
catch {
    throw "Pandoc wurde nicht gefunden. Bitte installiere Pandoc und stelle sicher, dass 'pandoc' im PATH ist. (Get-Command pandoc muss funktionieren.)"
}

# Output Verzeichnis sicherstellen
$outPdfFull = Resolve-Path -Path (Split-Path -Parent $OutputPdfPath) -ErrorAction SilentlyContinue
if (-not $outPdfFull) {
    New-Item -ItemType Directory -Path (Split-Path -Parent $OutputPdfPath) -Force | Out-Null
}

$tmpMd = Join-Path ([System.IO.Path]::GetTempPath()) ("qa_doc_{0}_{1}.md" -f ($Template.ToLower()), (Get-Date -Format "yyyyMMdd_HHmmss"))

Write-Host "Erzeuge Markdown..." -ForegroundColor Yellow
& $generator -ConfigFile $ConfigFile -Template $Template -OutputPath $tmpMd -NoPrompt | Out-Null
if ($LASTEXITCODE -ne 0) {
    throw "Markdown-Generierung ist fehlgeschlagen (ExitCode: $LASTEXITCODE)."
}

Write-Host "Erzeuge PDF via Pandoc..." -ForegroundColor Yellow
$pandocCmd = @($PandocPath, $tmpMd, "-o", $OutputPdfPath) + $PandocArgs
& $pandocCmd[0] @($pandocCmd[1..($pandocCmd.Count - 1)])
if ($LASTEXITCODE -ne 0) {
    throw "Pandoc ist fehlgeschlagen (ExitCode: $LASTEXITCODE)."
}

Remove-Item -Path $tmpMd -ErrorAction SilentlyContinue
Write-Host "✅ PDF erstellt: $OutputPdfPath" -ForegroundColor Green

