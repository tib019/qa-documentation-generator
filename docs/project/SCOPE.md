# Projektscope — QA Documentation Generator

## Problem
QA-Teams verbringen viel Zeit mit dem manuellen Erstellen von Testprotokoll-Dokumenten. JSON-basierte Testfälle müssen in professionelle Word/PDF-Dokumente konvertiert werden.

## Lösung
PowerShell-basierter Generator, der aus JSON-Testfällen professionelle QA-Protokoll-Dokumente (Word, PDF) generiert und in Azure DevOps Wiki publizieren kann.

## In Scope
- JSON-Testfall-Import (`testcases_hosenso_qt_stage.json`)
- Word-Dokument-Generierung (PowerShell + .NET)
- PDF-Export (`Export-QADocumentPdf.ps1`)
- Azure DevOps Wiki-Publishing (`Publish-AdoWiki.ps1`)
- Templates für verschiedene Dokumenttypen
- Azure Pipelines CI/CD
- Schnellstart-Skript (`SCHNELLSTART.bat`)

## Out of Scope
- Webbasiertes Frontend
- Automatische Testausführung
- Jira/Confluence-Integration

## Technologie-Stack
| Schicht | Technologie |
|---------|-------------|
| Skriptsprache | PowerShell |
| Dokumentformat | Word (.docx), PDF |
| Testfall-Format | JSON |
| CI/CD | Azure DevOps Pipelines |
| Deployment | Windows / PowerShell Core |
