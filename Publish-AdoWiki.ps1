#Requires -Version 5.1

<#
.SYNOPSIS
    Lädt generierte Markdown-Dokumente automatisch ins Azure DevOps Wiki hoch (REST API).

.DESCRIPTION
    Lädt alle *.md Dateien aus einem Ordner (rekursiv) ins Azure DevOps Wiki.
    Die Wiki-Seitenpfade werden aus den Dateipfaden abgeleitet (ohne .md Endung).

    Authentifizierung erfolgt per Personal Access Token (PAT).
    Tipp: PAT als Pipeline-Secret Variable speichern und via env übergeben.

.EXAMPLE
    .\Publish-AdoWiki.ps1 -Organization "myorg" -Project "myproject" -Wiki "myproject.wiki" -Pat $env:ADO_PAT -SourceDirectory ".\output" -BasePath "/QA"
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true, HelpMessage = "Azure DevOps Organization (ohne URL), z.B. 'myorg'")]
    [ValidateNotNullOrEmpty()]
    [string]$Organization,

    [Parameter(Mandatory = $true, HelpMessage = "Azure DevOps Project, z.B. 'MyProject'")]
    [ValidateNotNullOrEmpty()]
    [string]$Project,

    [Parameter(Mandatory = $true, HelpMessage = "Wiki Identifier (Name oder ID), z.B. 'MyProject.wiki'")]
    [ValidateNotNullOrEmpty()]
    [string]$Wiki,

    [Parameter(Mandatory = $true, HelpMessage = "Personal Access Token (PAT)")]
    [ValidateNotNullOrEmpty()]
    [string]$Pat,

    [Parameter(Mandatory = $true, HelpMessage = "Ordner mit Markdown-Dateien")]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$SourceDirectory,

    [Parameter(Mandatory = $false, HelpMessage = "Basis-Pfad im Wiki, z.B. '/QA-Documentation'")]
    [string]$BasePath = "/QA-Documentation",

    [Parameter(Mandatory = $false, HelpMessage = "Glob/Filter, z.B. '*.md'")]
    [string]$Filter = "*.md",

    [Parameter(Mandatory = $false, HelpMessage = "API Version")]
    [string]$ApiVersion = "7.1-preview.1",

    [Parameter(Mandatory = $false, HelpMessage = "Nur anzeigen, nicht hochladen")]
    [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

function New-AdoAuthHeader {
    param([Parameter(Mandatory = $true)][string]$Token)
    $bytes = [System.Text.Encoding]::ASCII.GetBytes(":$Token")
    $b64 = [Convert]::ToBase64String($bytes)
    return @{ Authorization = "Basic $b64" }
}

function Normalize-WikiPath {
    param(
        [Parameter(Mandatory = $true)][string]$Base,
        [Parameter(Mandatory = $true)][string]$RelativeNoExt
    )

    $b = $Base.Trim()
    if ([string]::IsNullOrWhiteSpace($b)) { $b = "/" }
    if (-not $b.StartsWith("/")) { $b = "/" + $b }
    if ($b.Length -gt 1 -and $b.EndsWith("/")) { $b = $b.TrimEnd("/") }

    $rel = $RelativeNoExt.Replace("\", "/").Trim("/")
    if ([string]::IsNullOrWhiteSpace($rel)) { return $b }
    return "$b/$rel"
}

function Escape-WikiPathForUrl {
    param([Parameter(Mandatory = $true)][string]$Path)
    # Azure DevOps erwartet eine URL-encoded path Query.
    # Wir encoden pro Segment, damit "/" erhalten bleibt.
    $segments = $Path.Split("/") | Where-Object { $_ -ne "" }
    $encoded = $segments | ForEach-Object { [uri]::EscapeDataString($_) }
    return "/" + ($encoded -join "/")
}

function Get-WikiPageEtag {
    param(
        [Parameter(Mandatory = $true)][string]$Url,
        [Parameter(Mandatory = $true)][hashtable]$Headers
    )

    try {
        $resp = Invoke-WebRequest -Method Get -Uri $Url -Headers $Headers -UseBasicParsing -ErrorAction Stop
        $etag = $resp.Headers.ETag
        if ([string]::IsNullOrWhiteSpace($etag)) { return $null }
        return $etag
    }
    catch {
        # 404 -> Seite existiert nicht (ok)
        if ($_.Exception.Response -and $_.Exception.Response.StatusCode.value__ -eq 404) {
            return $null
        }
        throw
    }
}

function Put-WikiPage {
    param(
        [Parameter(Mandatory = $true)][string]$Url,
        [Parameter(Mandatory = $true)][hashtable]$Headers,
        [Parameter(Mandatory = $true)][string]$Markdown,
        [Parameter(Mandatory = $false)][string]$Etag
    )

    $bodyObj = @{ content = $Markdown }
    $body = $bodyObj | ConvertTo-Json -Depth 4

    $h = @{}
    foreach ($k in $Headers.Keys) { $h[$k] = $Headers[$k] }
    $h["Content-Type"] = "application/json; charset=utf-8"
    if (-not [string]::IsNullOrWhiteSpace($Etag)) {
        $h["If-Match"] = $Etag
    }

    Invoke-WebRequest -Method Put -Uri $Url -Headers $h -Body $body -UseBasicParsing -ErrorAction Stop | Out-Null
}

Write-Host "=== Azure DevOps Wiki Upload ===" -ForegroundColor Cyan
Write-Host "Quelle: $SourceDirectory" -ForegroundColor White
Write-Host "Wiki: $Organization / $Project / $Wiki" -ForegroundColor White
Write-Host "BasePath: $BasePath" -ForegroundColor White
if ($DryRun) { Write-Host "DryRun: aktiv (kein Upload)" -ForegroundColor Yellow }
Write-Host ""

$auth = New-AdoAuthHeader -Token $Pat

$root = (Resolve-Path $SourceDirectory).Path
$files = Get-ChildItem -Path $root -Filter $Filter -File -Recurse | Sort-Object FullName

if (-not $files -or $files.Count -eq 0) {
    Write-Host "Keine Dateien gefunden (Filter: $Filter)." -ForegroundColor Yellow
    exit 0
}

$baseUrl = "https://dev.azure.com/$Organization/$Project/_apis/wiki/wikis/$Wiki/pages"

$ok = 0
$fail = 0

foreach ($f in $files) {
    $rel = $f.FullName.Substring($root.Length).TrimStart("\", "/")
    $relNoExt = [System.IO.Path]::ChangeExtension($rel, $null)

    $wikiPath = Normalize-WikiPath -Base $BasePath -RelativeNoExt $relNoExt
    $encodedPath = Escape-WikiPathForUrl -Path $wikiPath
    $url = "$baseUrl?path=$encodedPath&api-version=$ApiVersion"

    Write-Host "→ $rel  =>  $wikiPath" -ForegroundColor White

    if ($DryRun) { continue }

    try {
        $md = Get-Content -Path $f.FullName -Raw -Encoding UTF8
        $md = $md -replace "`r`n", "`n"

        $etag = Get-WikiPageEtag -Url $url -Headers $auth
        if ($null -eq $etag) {
            Put-WikiPage -Url $url -Headers $auth -Markdown $md
        }
        else {
            Put-WikiPage -Url $url -Headers $auth -Markdown $md -Etag $etag
        }
        $ok++
    }
    catch {
        $fail++
        Write-Host "   ❌ Upload fehlgeschlagen: $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Fertig. Erfolgreich: $ok | Fehlgeschlagen: $fail" -ForegroundColor Cyan
if ($fail -gt 0) { exit 1 }

