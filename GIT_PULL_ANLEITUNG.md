# Git Pull Anleitung - QTStageProtokoll Update

## ✅ Was wurde implementiert?

Die **QTStageProtokoll**-Funktionalität wurde vollständig implementiert und ist bereit zum Pushen!

### Neue Dateien:

1. ✅ **templates/template_qtstage_protokoll.json** - JSON-Schema-Template
2. ✅ **examples/beispiel_qtstage_protokoll.json** - Vollständige Beispiel-Konfiguration
3. ✅ **docs/QTSTAGE_PROTOKOLL.md** - Umfassende Dokumentation
4. ✅ **tests/Test-QTStageProtokoll.ps1** - Validierungs-Tests

### Geänderte Dateien:

1. ✅ **Generate-QADocument.ps1** - Erweitert um QTStageProtokoll-Support
2. ✅ **README.md** - Aktualisiert mit QTStageProtokoll-Informationen

---

## 🚀 Git Push & Pull Anleitung

### Schritt 1: Repository-Status prüfen

```powershell
cd C:\path\to\qa-documentation-generator
git status
```

**Erwartete Ausgabe:**
```
On branch main
Your branch is behind 'origin/main' by 1 commit.
```

---

### Schritt 2: Änderungen vom Remote-Repository holen

```powershell
git pull origin main
```

**Erwartete Ausgabe:**
```
From https://github.com/tibo47-161/qa-documentation-generator
 * branch            main       -> FETCH_HEAD
Updating abc1234..6860d18
Fast-forward
 Generate-QADocument.ps1                    | 157 +++++++++++++++++++++++++++
 README.md                                  |   4 +
 docs/QTSTAGE_PROTOKOLL.md                  | 432 +++++++++++++++++++++++++++++++++++++++++++
 examples/beispiel_qtstage_protokoll.json   | 183 +++++++++++++++++++++
 templates/template_qtstage_protokoll.json  | 345 +++++++++++++++++++++++++++++++++++
 tests/Test-QTStageProtokoll.ps1            | 203 ++++++++++++++++++++++
 6 files changed, 1124 insertions(+), 7 deletions(-)
```

---

### Schritt 3: Änderungen überprüfen

```powershell
# Neue Dateien anzeigen
Get-ChildItem -Path . -Recurse -File | Where-Object { $_.Name -like "*qtstage*" }

# Oder mit Git
git log --oneline -1
```

**Erwartete Ausgabe:**
```
6860d18 feat: Add QTStageProtokoll template for comprehensive stage test protocols
```

---

## 🧪 Funktionalität testen

### Test 1: Beispiel-Dokument generieren

```powershell
.\Generate-QADocument.ps1 `
  -ConfigFile "examples\beispiel_qtstage_protokoll.json" `
  -Template "QTStageProtokoll" `
  -OutputPath "output\test_qtstage_protokoll.md"
```

**Erwartetes Ergebnis:**
- ✅ Dokument wird erfolgreich generiert
- ✅ Markdown-Datei enthält alle Abschnitte (Metadaten, Geräte-IDs, Test-Kategorien, etc.)
- ✅ Symbole werden korrekt angezeigt (✅, ⚠️, ℹ️, ❌, 🔌, ☁️, 📱, 🖥️)

---

### Test 2: Validierungs-Tests ausführen

```powershell
.\tests\Test-QTStageProtokoll.ps1
```

**Erwartetes Ergebnis:**
```
=== QTStageProtokoll Tests ===

Test 1: Template-Datei existiert...
  ✅ PASSED: Template gefunden
Test 2: Beispiel-Konfiguration existiert...
  ✅ PASSED: Beispiel gefunden
Test 3: Beispiel-Konfiguration ist valides JSON...
  ✅ PASSED: JSON ist valide
...
Test 12: Plattform-Symbole werden korrekt gemappt...
  ✅ PASSED: Plattform-Symbole gefunden (4/4)

=== Alle Tests erfolgreich! ===
```

---

## 📋 Verwendung im Projekt

### Eigenes QTStageProtokoll erstellen

1. **Template kopieren:**
   ```powershell
   Copy-Item "templates\template_qtstage_protokoll.json" "mein_stage_test.json"
   ```

2. **JSON-Datei bearbeiten:**
   - Öffne `mein_stage_test.json` in VS Code
   - Fülle alle Felder aus (siehe Beispiel: `examples\beispiel_qtstage_protokoll.json`)
   - Speichere die Datei

3. **Dokument generieren:**
   ```powershell
   .\Generate-QADocument.ps1 `
     -ConfigFile "mein_stage_test.json" `
     -Template "QTStageProtokoll" `
     -OutputPath "output\stage_1.3.5_protokoll.md"
   ```

4. **Fertig!** 🎉
   - Markdown-Dokument ist bereit für Azure DevOps Wiki

---

## 📖 Dokumentation

Vollständige Dokumentation findest du hier:

```powershell
# Dokumentation öffnen
notepad "docs\QTSTAGE_PROTOKOLL.md"
```

Die Dokumentation enthält:
- 📋 Template-Struktur und JSON-Schema
- 🎯 Verwendungsbeispiele
- ✅ Status- und Plattform-Symbole
- 🔧 Best Practices
- 🐛 Troubleshooting

---

## 🎯 Features des QTStageProtokoll

### ✨ Neue Funktionen:

1. **Erweiterte Metadaten**
   - Tester, Service Account ID
   - Start- und Endzeit
   - Version und Datum

2. **Geräte-IDs**
   - Android, iOS, Desktop
   - Mehrere Geräte dokumentieren

3. **Hierarchische Test-Struktur**
   - Kategorien → UI-Screens → Tests
   - Oder: Kategorien → Tests (direkt)

4. **Plattform-spezifische Tests**
   - 🔌 Backend
   - ☁️ Cloud
   - 📱 Mobile
   - 🖥️ Desktop

5. **Symbol-System**
   - ✅ Bestanden
   - ⚠️ Warnung
   - ℹ️ Info
   - ❌ Fehlgeschlagen

6. **Test-Accounts**
   - Account, Rolle, Verwendung
   - Übersichtliche Tabelle

7. **Blockierte Tests**
   - Test, Grund, Ticket-Referenz
   - Nachvollziehbare Dokumentation

8. **Zusammenfassung**
   - Statistiken
   - Kritische Probleme
   - Empfehlungen

---

## 🔧 Troubleshooting

### Problem: "Template nicht gefunden"

**Lösung:**
```powershell
# Prüfe ob Template vorhanden ist
Test-Path "templates\template_qtstage_protokoll.json"

# Falls nicht: Git Pull erneut ausführen
git pull origin main
```

### Problem: "Ungültige Konfiguration"

**Lösung:**
- Überprüfe JSON-Syntax mit VS Code
- Vergleiche mit Beispiel: `examples\beispiel_qtstage_protokoll.json`
- Führe Tests aus: `.\tests\Test-QTStageProtokoll.ps1`

### Problem: "Symbole werden nicht angezeigt"

**Lösung:**
- Speichere JSON-Datei mit **UTF-8 Encoding**
- Öffne generiertes Markdown mit einem Editor, der UTF-8 unterstützt (VS Code, Notepad++)

---

## 📞 Support

Bei Fragen oder Problemen:

1. 📖 Konsultiere die Dokumentation: `docs\QTSTAGE_PROTOKOLL.md`
2. 🔍 Überprüfe das Beispiel: `examples\beispiel_qtstage_protokoll.json`
3. 🧪 Führe Tests aus: `.\tests\Test-QTStageProtokoll.ps1`

---

## ✅ Checkliste

- [ ] Git Pull ausgeführt
- [ ] Neue Dateien vorhanden (6 Dateien)
- [ ] Beispiel-Dokument generiert
- [ ] Tests erfolgreich ausgeführt
- [ ] Dokumentation gelesen
- [ ] Eigenes QTStageProtokoll erstellt

---

**Viel Erfolg mit dem neuen QTStageProtokoll-Template!** 🚀

**Version:** 1.0  
**Datum:** 18.02.2026  
**Commit:** 6860d18
