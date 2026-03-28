# QT Stage Protokoll - Dokumentation

## Übersicht

Das **QT Stage Protokoll** ist ein umfassendes Test-Protokoll-Format für Stage-Deployments, das speziell für die Anforderungen der DTEFS-QA entwickelt wurde. Es erweitert das Standard-TestProtokoll um:

- **Erweiterte Metadaten** (Service Account, Geräte-IDs, Zeitstempel)
- **Hierarchische Test-Struktur** (Kategorien → UI-Screens → Tests)
- **Plattform-spezifische Tests** (Backend, Cloud, Mobile, Desktop)
- **Test-Accounts-Dokumentation**
- **Blockierte Tests mit Ticket-Referenzen**
- **Symbol-System** für Status und Plattformen

---

## Template-Struktur

### JSON-Schema

Das Template verwendet folgende Hauptstruktur:

```json
{
  "Titel": "String - Titel des Testprotokolls",
  "Version": "String - Getestete Version (z.B. 1.3.5)",
  "Datum": "String - Testdatum",
  "Tester": "String - Name des Testers",
  "ServiceAccountID": "String - Service Account für Tests",
  "Startzeit": "String - Startzeit des Tests",
  "Endzeit": "String - Endzeit des Tests",
  "GeräteIDs": {
    "Android": "String - Android Device ID",
    "iOS": "String - iOS Device ID",
    "Desktop": "String - Desktop Device ID"
  },
  "TestKategorien": [ /* Array von Kategorien */ ],
  "PlattformTests": [ /* Array von Plattform-Tests */ ],
  "TestAccounts": [ /* Array von Test-Accounts */ ],
  "BlockierteTests": [ /* Array von blockierten Tests */ ],
  "Zusammenfassung": "String - Zusammenfassung der Testergebnisse"
}
```

---

## Verwendung

### 1. JSON-Konfiguration erstellen

Erstellen Sie eine JSON-Datei basierend auf dem Template:

```bash
# Template als Basis kopieren
cp templates/template_qtstage_protokoll.json mein_test.json

# Oder Beispiel als Basis verwenden
cp examples/beispiel_qtstage_protokoll.json mein_test.json
```

### 2. Dokument generieren

```powershell
.\Generate-QADocument.ps1 `
  -ConfigFile "mein_test.json" `
  -Template "QTStageProtokoll" `
  -OutputPath "output/stage_test_protokoll.md"
```

### 3. Ausgabe

Das Script generiert ein professionelles Markdown-Dokument mit:

- Vollständigen Metadaten
- Hierarchisch strukturierten Tests
- Plattform-spezifischen Tests mit Symbolen
- Test-Accounts-Übersicht
- Blockierte Tests mit Ticket-Links
- Zusammenfassung mit Statistiken

---

## Test-Kategorien

### Struktur mit UI-Screens

Für Tests, die UI-spezifisch sind:

```json
{
  "TestKategorien": [
    {
 "Kategorie": " Authentifizierung & Autorisierung",
      "UIScreens": [
        {
          "Screen": "Login-Screen",
          "Tests": [
            {
              "Test": "Login mit gültigen Credentials",
              "Status": "Bestanden",
              "Bemerkung": "Erfolgreicher Login auf allen Plattformen"
            }
          ]
        }
      ]
    }
  ]
}
```

### Struktur ohne UI-Screens

Für allgemeine Tests ohne spezifischen Screen:

```json
{
  "TestKategorien": [
    {
 "Kategorie": " Benachrichtigungen",
      "Tests": [
        {
          "Test": "Push-Benachrichtigungen empfangen",
          "Status": "Bestanden",
          "Bemerkung": "Notifications auf Android und iOS"
        }
      ]
    }
  ]
}
```

---

## Status-Symbole

Das Template verwendet folgende Status-Symbole:

| Status | Symbol | Bedeutung |
|--------|--------|-----------|
| `Bestanden` | | Test erfolgreich durchgeführt |
| `Warnung` | ️ | Test bestanden, aber mit Auffälligkeiten |
| `Info` | ℹ️ | Informative Bemerkung |
| `Fehlgeschlagen` | | Test fehlgeschlagen |

---

## Plattform-Symbole

Für plattform-spezifische Tests:

| Plattform | Symbol | Verwendung |
|-----------|--------|------------|
| `Backend` | | Backend/API-Tests |
| `Cloud` | ️ | Cloud-Services (Azure, AWS, etc.) |
| `Mobile` | | Mobile Apps (iOS, Android) |
| `Desktop` | ️ | Desktop/Browser-Tests |

---

## Plattform-spezifische Tests

```json
{
  "PlattformTests": [
    {
      "Plattform": "Backend",
      "Tests": [
        {
          "Test": "API-Endpunkte Erreichbarkeit",
          "Status": "Bestanden",
          "Bemerkung": "Alle Endpoints antworten korrekt"
        }
      ]
    }
  ]
}
```

---

## Test-Accounts

Dokumentieren Sie verwendete Test-Accounts:

```json
{
  "TestAccounts": [
    {
      "Account": "admin@stage.hosenso.com",
      "Rolle": "Administrator",
      "Verwendung": "Vollzugriff auf alle Funktionen"
    }
  ]
}
```

---

## Blockierte Tests

Dokumentieren Sie Tests, die nicht durchgeführt werden konnten:

```json
{
  "BlockierteTests": [
    {
      "Test": "Export zu Excel",
      "Grund": "Backend-Bug verhindert Export",
      "Ticket": "#3930"
    }
  ]
}
```

---

## Zusammenfassung

Die Zusammenfassung sollte enthalten:

- Gesamtanzahl durchgeführter Tests
- Verteilung nach Status (Bestanden, Warnung, Fehlgeschlagen, etc.)
- Kritische Probleme mit Ticket-Referenzen
- Empfehlungen für nächste Schritte

**Beispiel:**

```
**Gesamt:** 42 Tests durchgeführt

**Ergebnis:**
- Bestanden: 35 (83%)
- ️ Warnung: 5 (12%)
- Fehlgeschlagen: 1 (2%)
- ℹ️ Info: 1 (2%)
- Blockiert: 2

**Kritische Probleme:**
- Bug #3926: Datumsfeld-Validierung fehlerhaft (Priorität: Hoch)

**Empfehlungen:**
1. Bug #3926 vor Production-Release beheben
2. Performance-Optimierung für >100 concurrent users
```

---

## Best Practices

### 1. Konsistente Benennung

- Verwenden Sie klare, beschreibende Test-Namen
- Kategorien sollten mit Emoji beginnen für bessere Übersicht
- UI-Screen-Namen sollten den tatsächlichen Screen-Namen entsprechen

### 2. Aussagekräftige Bemerkungen

- Beschreiben Sie **was** getestet wurde
- Notieren Sie **Auffälligkeiten** auch bei bestandenen Tests
- Referenzieren Sie **Bug-Tickets** bei Fehlern

### 3. Vollständige Metadaten

- Dokumentieren Sie **alle** verwendeten Geräte-IDs
- Notieren Sie **Start- und Endzeit** für Nachvollziehbarkeit
- Geben Sie die **genaue Version** an

### 4. Plattform-spezifische Tests

- Gruppieren Sie Tests nach Plattform
- Verwenden Sie die korrekten Plattform-Symbole
- Dokumentieren Sie plattform-spezifische Auffälligkeiten

### 5. Test-Accounts

- Listen Sie **alle** verwendeten Test-Accounts auf
- Dokumentieren Sie die **Rolle** jedes Accounts
- Beschreiben Sie den **Verwendungszweck**

---

## Beispiel-Workflow

### 1. Vorbereitung

```powershell
# Template kopieren
cp templates/template_qtstage_protokoll.json stage_1.3.5_test.json
```

### 2. Konfiguration anpassen

Öffnen Sie `stage_1.3.5_test.json` und füllen Sie aus:

- Metadaten (Tester, Datum, Version, etc.)
- Geräte-IDs
- Test-Kategorien mit Tests
- Plattform-Tests
- Test-Accounts
- Blockierte Tests
- Zusammenfassung

### 3. Dokument generieren

```powershell
.\Generate-QADocument.ps1 `
  -ConfigFile "stage_1.3.5_test.json" `
  -Template "QTStageProtokoll" `
  -OutputPath "output/stage_1.3.5_protokoll.md"
```

### 4. Review & Upload

- Überprüfen Sie das generierte Markdown
- Laden Sie es in Azure DevOps Wiki hoch
- Verlinken Sie relevante Bug-Tickets

---

## Validierung

Das Script validiert automatisch:

- Pflichtfelder (Titel, Version, Datum, Tester, etc.)
- Geräte-IDs Objekt vorhanden
- TestKategorien ist Array
- TestAccounts ist Array (falls vorhanden)
- BlockierteTests ist Array (falls vorhanden)

Bei fehlenden Pflichtfeldern wird eine detaillierte Fehlermeldung angezeigt.

---

## Unterschiede zu TestProtokoll

| Feature | TestProtokoll | QTStageProtokoll |
|---------|---------------|------------------|
| Metadaten | Basis | Erweitert (Service Account, Zeitstempel) |
| Geräte-IDs | Einzelnes Gerät | Mehrere Geräte (Android, iOS, Desktop) |
| Test-Struktur | Flach | Hierarchisch (Kategorien → Screens → Tests) |
| Plattform-Tests | Nein | Ja (Backend, Cloud, Mobile, Desktop) |
| Test-Accounts | Nein | Ja |
| Blockierte Tests | Nein | Ja |
| Symbol-System | Basis | Erweitert (Status + Plattform) |

---

## Troubleshooting

### Fehler: "Pflichtfeld fehlt oder ist leer"

**Ursache:** Ein erforderliches Feld fehlt in der JSON-Konfiguration.

**Lösung:** Überprüfen Sie die Fehlermeldung und fügen Sie das fehlende Feld hinzu.

### Fehler: "muss ein Array sein"

**Ursache:** Ein Feld, das ein Array sein sollte, ist ein einzelner Wert.

**Lösung:** Ändern Sie den Wert in ein Array: `"Feld": []` oder `"Feld": [...]`

### Symbole werden nicht korrekt angezeigt

**Ursache:** Encoding-Problem beim Speichern der JSON-Datei.

**Lösung:** Speichern Sie die JSON-Datei mit UTF-8 Encoding.

---

## Support

Bei Fragen oder Problemen:

1. Überprüfen Sie die [Beispiel-Konfiguration](../examples/beispiel_qtstage_protokoll.json)
2. Konsultieren Sie das [Template](../templates/template_qtstage_protokoll.json)
3. Kontaktieren Sie das QA-Team

---

**Version:** 1.0  
**Letzte Aktualisierung:** 18.02.2026  
**Autor:** QA Team Hosenso
