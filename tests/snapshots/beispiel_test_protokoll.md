# Test-Protokoll: Version 1.3.5 Stage

**Version:** 1.3.5 Stage  
**Datum:** 10.02.2026  
**Tester:** QA Team  
**Testumgebung:** Stage  

---

## Übersicht

**Getestete Version:** 1.3.5 Stage  
**Test-Typ:** QT@Stage (Pre-Release Testing)  
**Dauer:** 4 Stunden  
**Status:** Abgeschlossen  

---

## Testziele

- Funktionalität der neuen Features testen
- Regressionstests für bestehende Funktionen
- Performance und Stabilität prüfen
- Bugs identifizieren und dokumentieren

---

## Testumgebung

**Plattform:** Stage  
**Browser/App:** Safari 17.2 / Chrome 120  
**Betriebssystem:** iOS 17.2 / macOS 14.2  
**Gerät:** iPhone 13 Pro / MacBook Pro  

---

## Durchgeführte Tests

| Test-ID | Testfall | Status | Bemerkung |
|---------|----------|--------|-----------|
| TC-001 | Login-Funktionalität | Pass | Login erfolgreich |
| TC-002 | Kalenderansicht | Fail | Startet bei 12:00 statt 08:00 (#3684) |
| TC-003 | Kalender löschen | Fail | Nicht möglich im Desktop (#3685) |
| TC-004 | Wetter-Ansicht | Fail | Visuelle Artefakte (#3685) |
| TC-005 | Wetter-Tab Desktop | Fail | Fehlt komplett (#3686) |
| TC-006 | Einladungs-Status | Fail | Account-Status Problem (#3687) |
| TC-007 | Temperatur-Anzeige | Fail | Überlappung in Wochenansicht (#3689) |
| TC-008 | Controller löschen | Fail | Nicht möglich (#3895) |
| TC-009 | Offline-Login | Fail | Blockiert im Flugmodus (Bug #9) |

---

## Gefundene Bugs

- **#3684**: Kalender startet bei 12:00 statt 08:00 (Schweregrad: Mittel)
- **#3685**: Kalender kann nicht gelöscht werden (Desktop) (Schweregrad: Hoch)
- **#3685**: Wetter-Ansicht visuelle Artefakte (Schweregrad: Niedrig)
- **#3686**: Wetter-Tab fehlt im Desktop (Schweregrad: Hoch)
- **#3687**: Einladungs-/Account-Status Problem (Schweregrad: Kritisch)
- **#3689**: Temperatur-Anzeige überlappt in Wochenansicht (Schweregrad: Niedrig)
- **#3895**: Controller können nicht gelöscht werden (Schweregrad: Hoch)
- **#TBD**: Offline-Login blockiert (Schweregrad: Kritisch)

---

## Test-Statistik

**Tests gesamt:** 9  
**Erfolgreich:** 1  
**Fehlgeschlagen:** 8  
**Übersprungen:** 0  
**Erfolgsrate:** 11%  

---

## Empfehlungen

- Kritische Bugs (#3687, Offline-Login) sollten vor Release behoben werden
- Hohe Priorität: Kalender löschen (#3685), Wetter-Tab (#3686), Controller löschen (#3895)
- UI/UX-Verbesserungen: Kalender-Startzeit (#3684), Temperatur-Anzeige (#3689)

---

## Bemerkungen

Version 1.3.5 Stage hat mehrere kritische Bugs, die vor dem Release behoben werden sollten. Besonders die Offline-Funktionalität und der Einladungs-Status sind problematisch.

---

**Erstellt von:** QA Team  
**Datum:** 10.02.2026  

