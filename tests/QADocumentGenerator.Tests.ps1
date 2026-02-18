#Requires -Version 5.1

$ErrorActionPreference = 'Stop'

function Normalize-Markdown {
    param([Parameter(Mandatory = $true)][string]$Text)

    $t = $Text -replace "`r`n", "`n"
    $lines = $t -split "`n" | ForEach-Object { $_.TrimEnd() }
    $t2 = ($lines -join "`n").TrimEnd()
    return $t2
}

function Get-Snapshot {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$Name
    )

    $path = Join-Path $RepoRoot ("tests\\snapshots\\{0}" -f $Name)
    return (Get-Content -Path $path -Raw -Encoding UTF8)
}

function Invoke-Generator {
    param(
        [Parameter(Mandatory = $true)][string]$RepoRoot,
        [Parameter(Mandatory = $true)][string]$ConfigFile,
        [Parameter(Mandatory = $true)][string]$Template
    )

    $outFile = Join-Path $TestDrive ("out_{0}.md" -f ($Template -replace '[^A-Za-z0-9]+','_'))

    $ps = Join-Path $env:WINDIR 'System32\WindowsPowerShell\v1.0\powershell.exe'
    $script = Join-Path $RepoRoot 'Generate-QADocument.ps1'

    & $ps -NoProfile -ExecutionPolicy Bypass -File $script -ConfigFile $ConfigFile -Template $Template -OutputPath $outFile -NoPrompt | Out-Null

    if ($LASTEXITCODE -ne 0) {
        throw "Generator exited with code $LASTEXITCODE for template '$Template'."
    }

    return (Get-Content -Path $outFile -Raw -Encoding UTF8)
}

Describe 'QA Documentation Generator' {
    BeforeAll {
        $RepoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
        $ExampleBug = (Resolve-Path (Join-Path $RepoRoot 'examples\beispiel_bug_ticket.json')).Path
        $ExampleTest = (Resolve-Path (Join-Path $RepoRoot 'examples\beispiel_test_protokoll.json')).Path
        $TestCases = (Resolve-Path (Join-Path $RepoRoot 'testcases_hosenso_qt_stage.json')).Path
        $MinTestCases = (Resolve-Path (Join-Path $RepoRoot 'tests\fixtures\testcases_min.json')).Path
    }

    It 'generiert ein BugTicket Markdown mit Kernsektionen' {
        $md = Invoke-Generator -RepoRoot $RepoRoot -ConfigFile $ExampleBug -Template 'BugTicket'
        $md | Should -Match '^# Bug-Ticket:'
        $md | Should -Match '## .*Zusammenfassung'
        $md | Should -Match '## .*Schritte zur Reproduktion'
        $md | Should -Match '## .*Technische Details'
    }

    It 'generiert ein TestProtokoll Markdown inkl. Tabelle und Bug-Sektion' {
        $md = Invoke-Generator -RepoRoot $RepoRoot -ConfigFile $ExampleTest -Template 'TestProtokoll'
        $md | Should -Match '^# Test-Protokoll:'
        $md | Should -Match '\\| Test-ID \\| Testfall \\| Status \\| Bemerkung \\|'
        $md | Should -Match '## .*Gefundene Bugs'

        # mind. 9 Test-Zeilen aus dem Beispiel (TC-001..TC-009)
        ($md -split \"`n\" | Where-Object { $_ -match '^\\| TC-' }).Count | Should -BeGreaterThanOrEqual 9
    }

    It 'generiert ein TestCases Markdown inkl. Kategorien' {
        $md = Invoke-Generator -RepoRoot $RepoRoot -ConfigFile $TestCases -Template 'TestCases'
        $md | Should -Match '^# Test Cases:'
        $md | Should -Match '## .*Test Case Kategorien'
        $md | Should -Match '### 1\\. Genereller Start'
        $md | Should -Match '\\| Test Case ID \\| Szenario \\| Erwartetes Verhalten \\| Priorität \\|'
    }

    It 'Snapshot: Beispiel BugTicket bleibt stabil' {
        $actual = Invoke-Generator -RepoRoot $RepoRoot -ConfigFile $ExampleBug -Template 'BugTicket'
        $expected = Get-Snapshot -RepoRoot $RepoRoot -Name 'beispiel_bug_ticket.md'
        Normalize-Markdown $actual | Should -Be (Normalize-Markdown $expected)
    }

    It 'Snapshot: Beispiel TestProtokoll bleibt stabil' {
        $actual = Invoke-Generator -RepoRoot $RepoRoot -ConfigFile $ExampleTest -Template 'TestProtokoll'
        $expected = Get-Snapshot -RepoRoot $RepoRoot -Name 'beispiel_test_protokoll.md'
        Normalize-Markdown $actual | Should -Be (Normalize-Markdown $expected)
    }

    It 'Snapshot: Mini TestCases bleibt stabil' {
        $actual = Invoke-Generator -RepoRoot $RepoRoot -ConfigFile $MinTestCases -Template 'TestCases'
        $expected = Get-Snapshot -RepoRoot $RepoRoot -Name 'testcases_min.md'
        Normalize-Markdown $actual | Should -Be (Normalize-Markdown $expected)
    }

    It 'bricht bei unvollständigem JSON sauber ab' {
        $bad = Join-Path $TestDrive 'bad.json'
        '{ \"Titel\": \"X\" }' | Out-File -FilePath $bad -Encoding UTF8 -Force

        $ps = Join-Path $env:WINDIR 'System32\\WindowsPowerShell\\v1.0\\powershell.exe'
        $script = Join-Path $RepoRoot 'Generate-QADocument.ps1'
        $outFile = Join-Path $TestDrive 'bad.md'

        & $ps -NoProfile -ExecutionPolicy Bypass -File $script -ConfigFile $bad -Template 'BugTicket' -OutputPath $outFile -NoPrompt | Out-Null
        $LASTEXITCODE | Should -Not -Be 0
    }
}

