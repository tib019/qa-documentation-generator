# ADR-002: Azure DevOps für CI/CD

**Status:** Accepted  
**Datum:** 2025

## Kontext
Der QA-Generator soll automatisiert getestet und als Pipeline ausführbar sein.

## Entscheidung
Azure DevOps Pipelines (`azure-pipelines.yml`) für CI/CD.

## Abgewogene Alternativen
- **GitHub Actions:** Möglich, aber Azure DevOps für professionelle QA-Umgebungen üblicher
- **Jenkins:** Älter, höherer Infrastrukturaufwand

## Konsequenzen
**Positiv:**
- Native Integration mit Azure-Infrastruktur
- ADO Wiki-Publishing (`Publish-AdoWiki.ps1`) direkt möglich

**Negativ:**
- Azure DevOps Account und Organisation erforderlich
