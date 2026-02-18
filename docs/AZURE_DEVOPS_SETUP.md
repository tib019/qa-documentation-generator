# Azure DevOps Pipeline Setup

**Automatisierte QA-Dokumenten-Generierung mit Azure DevOps**

---

## 🎯 Übersicht

Dieses Dokument beschreibt, wie Sie die Azure DevOps Pipelines für den QA-Dokumenten-Generator einrichten. Mit diesen Pipelines können Sie:

- ✅ Automatisch Dokumentation bei Git-Commits generieren
- ✅ Batch-Generierung aller Dokumente auf Knopfdruck
- ✅ Geplante tägliche Generierung neuer Dokumente
- ✅ Automatisches Hochladen ins Azure DevOps Wiki

---

## 📋 Voraussetzungen

### Azure DevOps
- Azure DevOps Organisation und Projekt
- Repository-Zugriff (Admin oder Contributor)
- Pipeline-Berechtigungen

### Repository
- GitHub Repository mit QA-Dokumenten-Generator
- Service Connection zu GitHub (optional)

---

## 🚀 Quick Start

### 1. Pipeline erstellen

1. Öffnen Sie Ihr Azure DevOps Projekt
2. Navigieren Sie zu **Pipelines** → **New Pipeline**
3. Wählen Sie **GitHub** als Code-Quelle
4. Wählen Sie Ihr Repository: `tibo47-161/qa-documentation-generator`
5. Wählen Sie **Existing Azure Pipelines YAML file**
6. Pfad: `/azure-pipelines.yml`
7. Klicken Sie auf **Run**

**Fertig!** Die Pipeline läuft jetzt automatisch bei jedem Commit.

---

## 📂 Verfügbare Pipelines

### 1. Standard Pipeline (`azure-pipelines.yml`)

**Zweck:** Automatische Generierung bei Git-Commits

**Trigger:**
- Commits auf `main` oder `develop` Branch
- Änderungen in `data/*.json` oder `examples/*.json`

**Ablauf:**
1. Checkout Repository
2. Generiere Bug-Tickets
3. Generiere Test-Protokolle
4. Erstelle Summary Report
5. Publiziere Artifacts
6. (Optional) Upload ins Wiki

**Verwendung:**
```bash
# Einfach committen - Pipeline läuft automatisch
git add data/bug_3690.json
git commit -m "Add new bug ticket data"
git push
```

---

### 2. Batch-Generierung (`.azuredevops/pipelines/batch-generation.yml`)

**Zweck:** Generierung aller Dokumente auf Knopfdruck

**Trigger:** Manuell

**Parameter:**
- `documentType`: All, BugTicket, TestProtokoll, SolutionConcept

**Ablauf:**
1. Liest alle JSON-Dateien aus `data/` Ordner
2. Generiert Dokumente basierend auf Typ
3. Erstellt Statistik-Report
4. Publiziert Artifacts

**Verwendung:**
1. Pipelines → **batch-generation** → **Run pipeline**
2. Wählen Sie `documentType` (z.B. "All")
3. Klicken Sie **Run**

---

### 3. Geplante Generierung (`.azuredevops/pipelines/scheduled-generation.yml`)

**Zweck:** Tägliche automatische Generierung

**Trigger:** Montag-Freitag um 8:00 Uhr

**Ablauf:**
1. Prüft auf neue/geänderte JSON-Dateien (letzte 24h)
2. Generiert nur neue Dokumente
3. Erstellt Daily Report
4. Sendet E-Mail-Benachrichtigung (optional)

**Verwendung:**
- Läuft automatisch
- Keine manuelle Aktion erforderlich

---

## 🔧 Erweiterte Konfiguration

### Wiki-Upload aktivieren

Ab Phase 3 kann der Wiki-Upload **direkt per REST API** erfolgen (ohne Wiki-Git-Repo-Clone).

#### 1) PAT (Personal Access Token) erstellen

1. Azure DevOps → User Settings → **Personal access tokens**
2. **New Token**
3. Scopes:
   - **Wiki (Read & write)**
4. Token kopieren (wird nur einmal angezeigt)

#### 2) Pipeline-Variablen setzen (Azure DevOps UI)

In deiner Pipeline unter **Variables** hinzufügen:

- `ADO_PAT` (**secret**): dein PAT
- `adoOrganization`: z.B. `myorg`
- `adoProject`: z.B. `MyProject`
- `adoWiki`: z.B. `MyProject.wiki` (oder Wiki-ID)
- `wikiBasePath`: z.B. `/QA-Documentation`

> Hinweis: Diese Werte sind als Default-Placeholders in `azure-pipelines.yml` vorhanden, sollten aber in Azure DevOps überschrieben werden.

#### 3) Wiki-Upload Stage aktiv nutzen

Die Stage `UploadToWiki` in `azure-pipelines.yml` lädt die Artefakte nach der Generierung ins Wiki hoch:

- Quelle: `$(System.ArtifactsDirectory)/qa-documentation/*.md` (rekursiv)
- Ziel: `wikiBasePath` im Azure DevOps Wiki

Du musst dafür nur sicherstellen, dass `ADO_PAT` gesetzt ist.

---

### E-Mail-Benachrichtigungen

1. **Marketplace Extension installieren:**
   - Organisation Settings → Extensions
   - Browse Marketplace → "Send Email"
   - Installieren

2. **Pipeline anpassen:**
   ```yaml
   - task: SendEmail@1
     inputs:
       To: 'qa-team@hosenso.com'
       Subject: 'QA Documentation Generated - Build $(Build.BuildNumber)'
       Body: 'See attached report'
       Attachments: '$(System.ArtifactsDirectory)/qa-documentation/DAILY_REPORT.md'
   ```

---

### Custom Data Ordner

Standardmäßig sucht die Pipeline in `data/` und `examples/`. Für einen custom Ordner:

1. Erstellen Sie Ordner: `custom-data/`
2. Pipeline anpassen:
   ```yaml
   variables:
     dataPath: 'custom-data'
   ```

---

## 📊 Artifacts & Reports

### Wo finde ich generierte Dokumente?

1. **Pipeline Run öffnen:**
   - Pipelines → Runs → Wählen Sie einen Run

2. **Artifacts herunterladen:**
   - Tab "Summary"
   - Section "Related" → "1 published"
   - Download "qa-documentation"

### Report-Typen

| Report | Beschreibung | Dateiname |
|--------|--------------|-----------|
| Summary Report | Übersicht aller generierten Dokumente | `SUMMARY.md` |
| Batch Stats | Statistiken der Batch-Generierung | `BATCH_STATS.md` |
| Daily Report | Täglicher Report mit neuen Dokumenten | `DAILY_REPORT.md` |

---

## 🎨 Pipeline-Badge im README

Fügen Sie ein Pipeline-Badge zu Ihrem README hinzu:

```markdown
[![Build Status](https://dev.azure.com/YOUR_ORG/YOUR_PROJECT/_apis/build/status/qa-documentation-generator?branchName=main)](https://dev.azure.com/YOUR_ORG/YOUR_PROJECT/_build/latest?definitionId=YOUR_PIPELINE_ID&branchName=main)
```

**So finden Sie die URL:**
1. Pipeline öffnen
2. "..." (Mehr Optionen) → "Status badge"
3. Markdown kopieren

---

## 🔒 Sicherheit & Berechtigungen

### Service Connection

Für GitHub-Zugriff:
1. Project Settings → Service connections
2. New service connection → GitHub
3. OAuth oder Personal Access Token

### Pipeline Permissions

Erforderliche Berechtigungen:
- **Build:** Queue builds, Edit build pipeline
- **Repository:** Read, Contribute
- **Artifacts:** Read, Create

---

## 🐛 Troubleshooting

### "Execution Policy" Fehler

**Problem:** PowerShell-Script kann nicht ausgeführt werden

**Lösung:**
```yaml
- task: PowerShell@2
  inputs:
    targetType: 'inline'
    script: |
      Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
```

### "JSON file not found"

**Problem:** Pipeline findet JSON-Dateien nicht

**Lösung:**
- Prüfen Sie Pfade in `azure-pipelines.yml`
- Stellen Sie sicher, dass `data/` Ordner existiert
- Committen Sie JSON-Dateien ins Repository

### Pipeline läuft nicht automatisch

**Problem:** Trigger funktioniert nicht

**Lösung:**
- Prüfen Sie Branch-Namen (`main` vs `master`)
- Prüfen Sie Pfad-Filter in `trigger.paths`
- Deaktivieren Sie "Override the YAML trigger" in Pipeline-Settings

---

## 📈 Best Practices

### 1. Ordnerstruktur

```
repository/
├── data/                    # Produktionsdaten
│   ├── bugs/
│   ├── tests/
│   └── solutions/
├── examples/                # Beispieldaten
└── templates/               # Leere Vorlagen
```

### 2. Naming Conventions

- Bug-Tickets: `bug_XXXX.json`
- Test-Protokolle: `test_YYYY_MM_DD.json`
- Solution Concepts: `solution_NAME.json`

### 3. Commit Messages

```bash
# Gut
git commit -m "Add bug ticket #3690: Offline login blocked"

# Schlecht
git commit -m "Update"
```

### 4. Pipeline-Optimierung

- Nutzen Sie `condition:` für bedingte Steps
- Cachen Sie Dependencies (falls vorhanden)
- Parallelisieren Sie Jobs wo möglich

---

## 🎯 Nächste Schritte

1. ✅ Standard-Pipeline einrichten
2. ✅ Ersten Test-Run durchführen
3. ✅ Batch-Pipeline für bestehende Dokumente
4. ✅ Wiki-Upload konfigurieren (optional)
5. ✅ Scheduled Pipeline aktivieren
6. ✅ Team schulen

---

## 📚 Weitere Ressourcen

- [Azure Pipelines Dokumentation](https://docs.microsoft.com/en-us/azure/devops/pipelines/)
- [YAML Schema Reference](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema)
- [PowerShell in Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/tasks/utility/powershell)

---

**Viel Erfolg mit Ihrer automatisierten QA-Dokumentation!** 🚀
