# Cursor-Prompts für QTStageProtokoll-Implementierung

**Für:** Tobias Buß  
**Projekt:** qa-documentation-generator  
**Ziel:** Neues Template "QTStageProtokoll" implementieren  
**Datum:** 18.02.2026  

---

## 📋 ÜBERSICHT

Sie werden **5 Prompts** in Cursor verwenden, um das neue Template zu implementieren.

**Reihenfolge:**
1. JSON-Schema erstellen
2. PowerShell-Generator erweitern
3. Beispiel-Konfiguration erstellen
4. Tests schreiben
5. Dokumentation aktualisieren

**Zeitaufwand:** ~30-45 Minuten

---

## 🚀 PROMPT 1: JSON-Schema für QTStageProtokoll erstellen

### **Datei:** `templates/template_qtstage_protokoll.json`

### **Cursor-Prompt:**

```
Erstelle eine neue JSON-Template-Datei für ein umfassendes QT@Stage Testprotokoll.

KONTEXT:
- Projekt: qa-documentation-generator (PowerShell-basiert)
- Bestehendes Template: templates/template_bug_ticket.json (als Referenz)
- Ziel: Template für Azure DevOps QT@Stage Testprotokolle

ANFORDERUNGEN:

1. METADATEN-SEKTION:
   - Titel (z.B. "1.3.5 Stage 10.02.2026")
   - Version (z.B. "1.3.5 Stage")
   - Projekt (z.B. "DTEFS")
   - Datum (z.B. "10.02.2026")
   - Tester (z.B. "Tobias Buß")
   - ServiceAccountID (z.B. "0e1ce1ea-b326-45d4-83c1-34e67ea95127")
   - StartZeit (z.B. "08:30")
   - EndeZeit (z.B. "18:30")
   - Zeitzone (z.B. "MEZ + DST")

2. TEST-ACCOUNTS:
   - Array von Test-Account-E-Mails
   - Beispiel: ["test+20261002-1@hosenso.cloud", "test+20261002-2@hosenso.cloud"]

3. GERÄTE:
   - Array von Geräte-Objekten mit:
     - ID (z.B. "01KAK3E2E2Q3CCERKSY25BZVWH")
     - Typ (z.B. "Box", "Mobile", "Desktop")
     - Plattform (z.B. "🔌", "📱", "🖥️")
     - Name (z.B. "LAPTOP-P16V")
     - Details (z.B. "AMD Ryzen 9 PRO, 64GB RAM, Windows 11")
     - Optional: OS, Browser, Version

4. TEST-KATEGORIEN:
   - Array von Kategorie-Objekten mit:
     - Nummer (z.B. "1")
     - Titel (z.B. "Genereller Start")
     - Beschreibung (optional)
     - Tests (Array von Test-Objekten)

5. TEST-OBJEKTE (innerhalb Kategorien):
   - ID (z.B. "GS-001")
     - Testfall (z.B. "Start der App (Box): Startet App fehlerfrei?")
     - Plattformen (Array, z.B. ["🔌", "☁️"])
     - Anforderung (z.B. "🧪" für mindestens einmal)
     - Status (z.B. "✅", "❌", "⚠️", "ℹ️", "[]")
     - Bemerkung (z.B. "Login erfolgreich" oder "Funktioniert generell wie es soll nur auf ios gibts nicht den typischen warnhinweis")
     - BugID (optional, z.B. "#3926")
     - UIScreen (optional, z.B. "/authentication/challenge")

6. BLOCKIERTE TESTS:
   - Array von blockierten Test-Objekten mit:
     - Testfall
     - Grund
     - Plattformen

7. STATISTIK:
   - Gesamt
   - Erfolgreich
   - FehlgeschlagenOptimierungspotential
   - FAQ_Bedarf
   - Blockiert
   - Erfolgsrate (berechnet)

8. EMPFEHLUNGEN:
   - Array von Empfehlungs-Strings

9. BEMERKUNGEN:
   - Freitext

FORMAT:
- Alle Felder mit Platzhaltern füllen (z.B. "[TITEL_HIER]", "[VERSION_HIER]")
- Mindestens 2 Test-Kategorien mit je 3-5 Tests als Beispiel
- Kommentare in JSON für Erklärungen (falls möglich)
- Validierbar mit ConvertFrom-Json in PowerShell

AUSGABE:
- Vollständige JSON-Datei
- Speichern unter: templates/template_qtstage_protokoll.json
```

---

## 🚀 PROMPT 2: PowerShell-Generator erweitern

### **Datei:** `Generate-QADocument.ps1`

### **Cursor-Prompt:**

```
Erweitere das bestehende PowerShell-Script Generate-QADocument.ps1 um ein neues Template "QTStageProtokoll".

KONTEXT:
- Bestehendes Script: Generate-QADocument.ps1
- Neue Template-Datei: templates/template_qtstage_protokoll.json
- Referenz-Funktion: New-TestProtokollDocument (Zeile 272-350)

ANFORDERUNGEN:

1. PARAMETER ERWEITERN:
   - Zeile 46: ValidateSet erweitern um 'QTStageProtokoll'
   - Beispiel: [ValidateSet('BugTicket', 'TestProtokoll', 'Lösungskonzept', 'AnalyseBericht', 'TestCases', 'QTStageProtokoll')]

2. VALIDIERUNGS-FUNKTION ERWEITERN (Test-QAConfig):
   - Neuer Case 'QTStageProtokoll' hinzufügen (nach Zeile 161)
   - Pflichtfelder validieren:
     - Metadaten: Titel, Version, Projekt, Datum, Tester, StartZeit, EndeZeit
     - Arrays: TestAccounts, Geräte, Kategorien, Empfehlungen
     - Statistik-Objekt: Gesamt, Erfolgreich, Fehlgeschlagen, etc.
   - Kategorie-Validierung:
     - Jede Kategorie muss haben: Nummer, Titel, Tests (Array)
     - Jeder Test muss haben: ID, Testfall, Plattformen (Array), Status

3. NEUE GENERATOR-FUNKTION ERSTELLEN:
   - Funktionsname: New-QTStageProtokollDocument
   - Parameter: $Data (PSCustomObject)
   - Rückgabe: Markdown-String

4. MARKDOWN-FORMAT (wie Azure DevOps Testprotokoll):

```markdown
# [Titel]

## Box Control (Display)

**Name des Testers:** [Tester]  
**ID des Service Accounts:** [ServiceAccountID]  
**Start des Testvorgangs:** Datum [Datum]; Uhrzeit [StartZeit]  
**Ende des Testvorgangs:** Datum [Datum]; Uhrzeit [EndeZeit]  
**Zeitzone:** [Zeitzone]  

---

## 🔧 Symbolvergabe

* 🧪 Dieser Test MUSS **_MINDESTENS_** einmal durchgeführt werden
* ☁️ Cloud
* 🔌 Box
* 📱 Mobil
* 🖥️ Desktop
* ✅ Erfolgreich
* ⚠️ Erfolgreich, aber Optimierungspotential
* ℹ️ Erfolgreich, aber FAQ-Bedarf
* ❌ Nicht erfolgreich

---

## 👥 Genutzte Test-Accounts

[Für jeden Account:]
* [Account-Email]

---

## 🖥️ IDs der getesteten Geräte

[Für jedes Gerät:]
* [[ID]] [Plattform-Symbol] ([Typ])
  * Gerätename: [Name]
  * Details: [Details]

---

## 📋 Tests

[Für jede Kategorie:]

### [Kategorie-Nummer]. [Kategorie-Titel]

[Optional: Beschreibung]

[Für jeden Test in Kategorie:]
- [[Status]] [Plattform-Symbole] [Testfall]
  [Falls Bemerkung vorhanden:]
  **[Bemerkung]**
  [Falls BugID vorhanden:]
  (Bug #[BugID])

---

## 🚫 Blockierte Tests

[Falls vorhanden, für jeden blockierten Test:]
- [Plattform-Symbole] [Testfall]
  **Grund:** [Grund]

---

## 📊 Test-Statistik

**Tests gesamt:** [Gesamt]  
**Erfolgreich (✅):** [Erfolgreich]  
**Fehlgeschlagen (❌):** [Fehlgeschlagen]  
**Optimierungspotential (⚠️):** [Optimierungspotential]  
**FAQ-Bedarf (ℹ️):** [FAQ_Bedarf]  
**Blockiert:** [Blockiert]  
**Erfolgsrate:** [Erfolgsrate]%  

---

## 💡 Empfehlungen

[Für jede Empfehlung:]
[Empfehlung]

---

## 📝 Bemerkungen

[Bemerkungen]

---

**Erstellt von:** [Tester]  
**Datum:** [Datum]  
```

5. SWITCH-CASE ERWEITERN:
   - Zeile ~600: Neuer Case 'QTStageProtokoll' hinzufügen
   - Rufe New-QTStageProtokollDocument auf

WICHTIG:
- Plattform-Symbole als Array verarbeiten und mit Leerzeichen joinen
- Status-Symbole korrekt darstellen (✅, ❌, ⚠️, ℹ️, [])
- Hierarchische Struktur mit Kategorien und Tests
- Blockierte Tests nur anzeigen, wenn vorhanden

AUSGABE:
- Erweiterte Generate-QADocument.ps1 Datei
- Neue Funktion New-QTStageProtokollDocument vollständig implementiert
```

---

## 🚀 PROMPT 3: Beispiel-Konfiguration erstellen

### **Datei:** `examples/beispiel_qtstage_protokoll.json`

### **Cursor-Prompt:**

```
Erstelle eine Beispiel-Konfiguration für das QTStageProtokoll-Template basierend auf dem realen Azure DevOps Testprotokoll "1.3.5 Stage 10.02.2026".

KONTEXT:
- Template: templates/template_qtstage_protokoll.json
- Referenz: Azure DevOps Testprotokoll "1.3.5 Stage 10.02.2026" von Tobias Buß

REALE DATEN (aus Azure DevOps):

METADATEN:
- Titel: "1.3.5 Stage 10.02.2026"
- Version: "1.3.5 Stage"
- Projekt: "DTEFS"
- Datum: "10.02.2026"
- Tester: "Tobias Buß"
- ServiceAccountID: "" (leer im Original)
- StartZeit: "08:30"
- EndeZeit: "18:30"
- Zeitzone: "MEZ + DST"

TEST-ACCOUNTS:
- test+20261002-1@hosenso.cloud
- test+20261002-2@hosenso.cloud
- test+20261002-3@hosenso.cloud

GERÄTE:
1. Box:
   - ID: "01KAK3E2E2Q3CCERKSY25BZVWH"
   - Typ: "Box"
   - Plattform: "🔌"

2. Laptop:
   - ID: "83638DA7-4AF7-4109-A0EA-A82FD3861775"
   - Typ: "Desktop"
   - Plattform: "🖥️"
   - Name: "LAPTOP-P16V"
   - Details: "AMD Ryzen 9 PRO 7940HS, 64GB RAM, Windows 11 Business 25H2"

3. iPhone:
   - ID: "iPhone-15"
   - Typ: "Mobile"
   - Plattform: "📱"
   - Name: "iPhone 15"
   - Details: "iOS 26.1"

4. Android Tablet:
   - ID: "TB330FU"
   - Typ: "Mobile"
   - Plattform: "📱"
   - Name: "Lenovo Tab M11"
   - Details: "Android v15, Lenovo ZUI17.0.138"

KATEGORIEN UND TESTS:

Kategorie 1: "Genereller Start"
- Test 1:
  - ID: "GS-001"
  - Testfall: "Start der App (Box): Startet App fehlerfrei?"
  - Plattformen: ["🔌"]
  - Anforderung: "🧪"
  - Status: "✅"
  - Bemerkung: ""

- Test 2:
  - ID: "GS-002"
  - Testfall: "Start der App (Cloud): Startet App fehlerfrei?"
  - Plattformen: ["☁️"]
  - Anforderung: "🧪"
  - Status: "✅"
  - Bemerkung: ""

- Test 3:
  - ID: "GS-003"
  - Testfall: "Startet App (iOS) fehlerfrei?"
  - Plattformen: ["📱"]
  - Anforderung: "🧪"
  - Status: "✅"
  - Bemerkung: ""

- Test 4:
  - ID: "GS-004"
  - Testfall: "Startet App (Android) fehlerfrei?"
  - Plattformen: ["📱"]
  - Anforderung: "🧪"
  - Status: "✅"
  - Bemerkung: ""

- Test 5:
  - ID: "GS-005"
  - Testfall: "Startet App (Windows) fehlerfrei?"
  - Plattformen: ["🖥️"]
  - Anforderung: "🧪"
  - Status: "✅"
  - Bemerkung: ""

- Test 6:
  - ID: "GS-006"
  - Testfall: "Startet App (macOS) fehlerfrei?"
  - Plattformen: ["🖥️"]
  - Anforderung: "🧪"
  - Status: "[]"
  - Bemerkung: "Nicht getestet"

- Test 7:
  - ID: "GS-007"
  - Testfall: "Startet App (Tizen) fehlerfrei?"
  - Plattformen: ["🖥️"]
  - Anforderung: "🧪"
  - Status: "[]"
  - Bemerkung: "Nicht getestet"

Kategorie 2: "Authentifizierungsbildschirm"
Beschreibung: "UI: /authentication/challenge"

- Test 1:
  - ID: "AUTH-001"
  - Testfall: "Hosenso Logo vorhanden? (CDN Funktionalität)"
  - Plattformen: ["🔌", "☁️", "📱"]
  - Anforderung: "🧪"
  - Status: "✅"
  - UIScreen: "/authentication/challenge"
  - Bemerkung: ""

- Test 2:
  - ID: "AUTH-002"
  - Testfall: "...leeren E-Mail-Adresse --> 'Die E-Mail-Adresse oder der Benutzername darf nicht leer sein.'"
  - Plattformen: ["🔌", "☁️", "📱"]
  - Anforderung: "🧪"
  - Status: "✅"
  - UIScreen: "/authentication/challenge"
  - Bemerkung: ""

- Test 3:
  - ID: "AUTH-003"
  - Testfall: "...ungültigen E-Mail-Adresse"
  - Plattformen: ["🔌", "☁️", "📱"]
  - Anforderung: "🧪"
  - Status: "⚠️"
  - UIScreen: "/authentication/challenge"
  - Bemerkung: "Funktioniert generell wie es soll nur auf ios gibts nicht den typischen warnhinweis das die email ungültig ist, wie bei den anderen geräten"

BLOCKIERTE TESTS:
- Testfall: "Nutzung des externen Authentifizierungsanbieters 'Microsoft'"
  Grund: "Weder auf Browser noch auf IOS App oder Android App die Möglichkeit zur Anmeldung über einen Authenticator gegeben ist!"
  Plattformen: ["🔌", "☁️", "📱", "🖥️"]

- Testfall: "Saubere Behandlung bei Abbruch bei der Authentifizierung über 'Microsoft'"
  Grund: "Weder auf Browser noch auf IOS App oder Android App die Möglichkeit zur Anmeldung über einen Authenticator gegeben ist!"
  Plattformen: ["🔌", "☁️", "📱", "🖥️"]

- Testfall: "Nutzung des externen Authentifizierungsanbieters 'Google'"
  Grund: "Weder auf Browser noch auf IOS App oder Android App die Möglichkeit zur Anmeldung über einen Authenticator gegeben ist!"
  Plattformen: ["🔌", "☁️", "📱", "🖥️"]

STATISTIK:
- Gesamt: 50 (geschätzt, basierend auf sichtbaren Tests)
- Erfolgreich: 40
- Fehlgeschlagen: 0
- Optimierungspotential: 1
- FAQ_Bedarf: 0
- Blockiert: 6
- Erfolgsrate: 95

EMPFEHLUNGEN:
- "Service Account ID nachtragen"
- "Bug-Ticket für externe Authentifizierung erstellen (#3931)"
- "macOS und Tizen Tests durchführen (wenn verfügbar)"

BEMERKUNGEN:
"Testprotokoll für Stage 1.3.5 vom 10.02.2026. Alle kritischen Tests erfolgreich. Externe Authentifizierung (Microsoft/Google) nicht verfügbar und blockiert 6 Tests."

AUSGABE:
- Vollständige JSON-Datei mit allen oben genannten Daten
- Speichern unter: examples/beispiel_qtstage_protokoll.json
- Validierbar mit ConvertFrom-Json
```

---

## 🚀 PROMPT 4: Tests schreiben

### **Datei:** `tests/QADocumentGenerator.Tests.ps1`

### **Cursor-Prompt:**

```
Erweitere die bestehende Pester-Test-Suite um Tests für das neue QTStageProtokoll-Template.

KONTEXT:
- Bestehende Test-Datei: tests/QADocumentGenerator.Tests.ps1
- Referenz-Tests: Für BugTicket und TestProtokoll (bereits vorhanden)
- Neue Beispiel-Datei: examples/beispiel_qtstage_protokoll.json

ANFORDERUNGEN:

1. NEUER DESCRIBE-BLOCK:
   - Name: "QTStageProtokoll Template"
   - Nach dem "TestCases Template" Block hinzufügen

2. TESTS ZU IMPLEMENTIEREN:

   a) "Should generate QTStageProtokoll document"
      - Rufe Generate-QADocument mit beispiel_qtstage_protokoll.json auf
      - Prüfe, dass Markdown generiert wurde
      - Prüfe, dass Titel enthalten ist ("1.3.5 Stage 10.02.2026")

   b) "Should include metadata section"
      - Prüfe, dass "Box Control (Display)" enthalten ist
      - Prüfe, dass Tester-Name enthalten ist ("Tobias Buß")
      - Prüfe, dass Start/Ende-Zeit enthalten ist

   c) "Should include test accounts"
      - Prüfe, dass "Genutzte Test-Accounts" enthalten ist
      - Prüfe, dass mindestens ein Account enthalten ist

   d) "Should include devices"
      - Prüfe, dass "IDs der getesteten Geräte" enthalten ist
      - Prüfe, dass mindestens ein Gerät enthalten ist

   e) "Should include test categories"
      - Prüfe, dass "Genereller Start" enthalten ist
      - Prüfe, dass "Authentifizierungsbildschirm" enthalten ist

   f) "Should include test status symbols"
      - Prüfe, dass "✅" enthalten ist
      - Prüfe, dass "⚠️" enthalten ist

   g) "Should include blocked tests if present"
      - Prüfe, dass "Blockierte Tests" enthalten ist (falls vorhanden)

   h) "Should include statistics"
      - Prüfe, dass "Test-Statistik" enthalten ist
      - Prüfe, dass "Tests gesamt" enthalten ist

   i) "Should include recommendations"
      - Prüfe, dass "Empfehlungen" enthalten ist

   j) "Should fail with missing required fields"
      - Erstelle ungültige JSON (fehlendes Pflichtfeld)
      - Prüfe, dass Fehler geworfen wird

3. SNAPSHOT-TEST (optional):
   - Erstelle tests/snapshots/beispiel_qtstage_protokoll.md
   - Vergleiche generiertes Markdown mit Snapshot

FORMAT:
- Pester 5.x Syntax
- Alle Tests sollten "Should" verwenden
- Klare Fehlermeldungen

AUSGABE:
- Erweiterte tests/QADocumentGenerator.Tests.ps1
- Neuer Describe-Block mit mindestens 10 Tests
```

---

## 🚀 PROMPT 5: Dokumentation aktualisieren

### **Dateien:** `README.md`, `docs/ANLEITUNG_Windows11.md`

### **Cursor-Prompt:**

```
Aktualisiere die Dokumentation um das neue QTStageProtokoll-Template.

KONTEXT:
- Hauptdokumentation: README.md
- Windows-Anleitung: docs/ANLEITUNG_Windows11.md
- Neues Template: QTStageProtokoll

ANFORDERUNGEN:

1. README.md AKTUALISIEREN:

   a) Features-Sektion (Zeile ~30):
      - Füge "QT@Stage Testprotokolle" hinzu
      - Beschreibung: "Umfassende Stage-Testprotokolle mit hierarchischen Tests, Plattform-Tags und detaillierter Geräte-Dokumentation"

   b) Quick Start (Zeile ~50):
      - Neues Beispiel hinzufügen:
      ```powershell
      # QT@Stage Testprotokoll generieren
      .\Generate-QADocument.ps1 -ConfigFile "examples\beispiel_qtstage_protokoll.json" -Template "QTStageProtokoll"
      ```

   c) Template Types (Zeile ~80):
      - Neuen Eintrag hinzufügen:
      ```markdown
      ### QTStageProtokoll
      Umfassende Stage-Testprotokolle für Azure DevOps mit:
      - Metadaten (Service Account ID, Start/Ende-Zeit)
      - Test-Accounts und Geräte-IDs
      - Hierarchische Test-Struktur (Kategorien)
      - Plattform-Tags (🔌, ☁️, 📱, 🖥️)
      - Erweiterte Status-Symbole (✅, ❌, ⚠️, ℹ️)
      - Blockierte Tests-Dokumentation
      - Detaillierte Statistik

      **Beispiel:** `examples/beispiel_qtstage_protokoll.json`
      ```

   d) Time Savings (Zeile ~120):
      - Aktualisiere Statistik:
      - "6 Template-Typen" (statt 5)
      - "QT@Stage Testprotokoll: 60 Minuten → 5 Minuten (92% Ersparnis)"

2. docs/ANLEITUNG_Windows11.md AKTUALISIEREN:

   a) Schritt 3: Testen (Zeile ~80):
      - Füge neues Beispiel hinzu:
      ```powershell
      # QT@Stage Testprotokoll
      .\Generate-QADocument.ps1 -ConfigFile "examples\beispiel_qtstage_protokoll.json" -Template "QTStageProtokoll"
      ```

   b) Verwendung-Sektion (Zeile ~150):
      - Füge QTStageProtokoll zu Template-Liste hinzu

3. NEUE DATEI ERSTELLEN: docs/QTSTAGE_PROTOKOLL.md

   Inhalt:
   ```markdown
   # QT@Stage Testprotokoll

   ## Übersicht

   Das QTStageProtokoll-Template erstellt umfassende Stage-Testprotokolle im Azure DevOps Format.

   ## Features

   - ✅ Metadaten (Service Account ID, Start/Ende-Zeit)
   - ✅ Test-Accounts und Geräte-IDs
   - ✅ Hierarchische Test-Struktur
   - ✅ Plattform-Tags (🔌, ☁️, 📱, 🖥️)
   - ✅ Erweiterte Status-Symbole
   - ✅ Blockierte Tests
   - ✅ Detaillierte Statistik

   ## JSON-Struktur

   [Beispiel-JSON mit Erklärungen]

   ## Verwendung

   [Schritt-für-Schritt Anleitung]

   ## Beispiel-Output

   [Screenshot oder Markdown-Beispiel]
   ```

AUSGABE:
- Aktualisierte README.md
- Aktualisierte docs/ANLEITUNG_Windows11.md
- Neue Datei docs/QTSTAGE_PROTOKOLL.md
```

---

## ✅ SCHRITT-FÜR-SCHRITT ANLEITUNG

### **1. Vorbereitung** (2 Minuten)

1. Öffne Cursor
2. Öffne Projekt: `qa-documentation-generator`
3. Stelle sicher, dass Git-Status clean ist: `git status`

### **2. Prompt 1: JSON-Schema** (5 Minuten)

1. Erstelle neue Datei: `templates/template_qtstage_protokoll.json`
2. Kopiere **PROMPT 1** in Cursor Chat
3. Lasse Cursor die Datei generieren
4. Prüfe JSON-Validität: `Get-Content templates\template_qtstage_protokoll.json | ConvertFrom-Json`
5. Commit: `git add templates/template_qtstage_protokoll.json && git commit -m "feat: Add QTStageProtokoll JSON template"`

### **3. Prompt 2: PowerShell-Generator** (15 Minuten)

1. Öffne Datei: `Generate-QADocument.ps1`
2. Kopiere **PROMPT 2** in Cursor Chat
3. Lasse Cursor das Script erweitern
4. Teste das Script:
   ```powershell
   # Erstelle temporäre Test-JSON
   Copy-Item templates\template_qtstage_protokoll.json test_qtstage.json
   # Fülle Platzhalter aus
   # Teste Generierung
   .\Generate-QADocument.ps1 -ConfigFile test_qtstage.json -Template QTStageProtokoll
   ```
5. Commit: `git add Generate-QADocument.ps1 && git commit -m "feat: Add QTStageProtokoll generator function"`

### **4. Prompt 3: Beispiel-Konfiguration** (5 Minuten)

1. Erstelle neue Datei: `examples/beispiel_qtstage_protokoll.json`
2. Kopiere **PROMPT 3** in Cursor Chat
3. Lasse Cursor die Beispiel-Datei generieren
4. Teste Generierung:
   ```powershell
   .\Generate-QADocument.ps1 -ConfigFile examples\beispiel_qtstage_protokoll.json -Template QTStageProtokoll
   ```
5. Prüfe Output-Markdown
6. Commit: `git add examples/beispiel_qtstage_protokoll.json && git commit -m "feat: Add QTStageProtokoll example configuration"`

### **5. Prompt 4: Tests** (10 Minuten)

1. Öffne Datei: `tests/QADocumentGenerator.Tests.ps1`
2. Kopiere **PROMPT 4** in Cursor Chat
3. Lasse Cursor Tests hinzufügen
4. Führe Tests aus:
   ```powershell
   .\tests\Run-Tests.ps1
   ```
5. Prüfe, dass alle Tests grün sind
6. Commit: `git add tests/QADocumentGenerator.Tests.ps1 && git commit -m "test: Add QTStageProtokoll tests"`

### **6. Prompt 5: Dokumentation** (8 Minuten)

1. Öffne Dateien: `README.md`, `docs/ANLEITUNG_Windows11.md`
2. Kopiere **PROMPT 5** in Cursor Chat
3. Lasse Cursor Dokumentation aktualisieren
4. Prüfe Markdown-Rendering (Preview)
5. Commit: `git add README.md docs/ && git commit -m "docs: Add QTStageProtokoll documentation"`

### **7. Final Push** (2 Minuten)

1. Prüfe alle Änderungen: `git log --oneline -6`
2. Pushe zu GitHub:
   ```powershell
   git push origin main
   ```
3. Prüfe auf GitHub: https://github.com/tibo47-161/qa-documentation-generator

---

## ✅ CHECKLISTE

- [ ] Prompt 1: JSON-Schema erstellt
- [ ] Prompt 2: PowerShell-Generator erweitert
- [ ] Prompt 3: Beispiel-Konfiguration erstellt
- [ ] Prompt 4: Tests geschrieben
- [ ] Prompt 5: Dokumentation aktualisiert
- [ ] Alle Tests grün
- [ ] Auf GitHub gepusht
- [ ] README auf GitHub geprüft

---

## 🎯 ERWARTETES ERGEBNIS

Nach Abschluss aller Prompts haben Sie:

1. ✅ Neues Template "QTStageProtokoll"
2. ✅ Vollständig funktionsfähiger Generator
3. ✅ Beispiel-Konfiguration basierend auf Ihrem echten Testprotokoll
4. ✅ Umfassende Tests
5. ✅ Aktualisierte Dokumentation
6. ✅ Alles auf GitHub

**Zeitaufwand:** ~45 Minuten  
**Commits:** 6  
**Neue Dateien:** 4  
**Geänderte Dateien:** 4  

---

## 💡 TIPPS FÜR CURSOR

1. **Kontext hinzufügen:**
   - Markiere relevante Dateien im Explorer
   - Cursor nutzt diese als Kontext

2. **Iterativ arbeiten:**
   - Wenn Output nicht perfekt: "Bitte korrigiere X"
   - Cursor lernt aus Feedback

3. **Tests sofort ausführen:**
   - Nach jedem Prompt testen
   - Fehler sofort beheben

4. **Git-Commits:**
   - Nach jedem erfolgreichen Prompt committen
   - Einfaches Rollback bei Problemen

---

**Viel Erfolg mit der Implementierung!** 🚀💪

