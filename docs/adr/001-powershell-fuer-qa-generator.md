# ADR-001: PowerShell für QA-Dokumentationsgenerator

**Status:** Accepted  
**Datum:** 2025

## Kontext
Der QA-Dokumentationsgenerator soll auf Windows-Entwicklungsrechnern laufen und Word/PDF-Dokumente aus Testfällen generieren.

## Entscheidung
PowerShell als primäre Skriptsprache für den Generator.

## Abgewogene Alternativen
- **Python:** Plattformübergreifend, aber zusätzliche Installation nötig
- **Node.js:** Gut für JSON-Verarbeitung, aber weniger nativ auf Windows
- **Bash:** Nicht nativ auf Windows

## Konsequenzen
**Positiv:**
- Nativ auf Windows ohne zusätzliche Installation
- Direkte .NET-Integration für Word/PDF-Export
- Azure DevOps Pipelines Unterstützung nativ

**Negativ:**
- Nicht plattformübergreifend (Linux/Mac erfordert PowerShell Core)
- UTF-16/BOM Probleme bei Sonderzeichen (siehe NO-BOM Varianten)
