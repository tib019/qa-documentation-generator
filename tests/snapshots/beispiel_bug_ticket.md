# Bug-Ticket: Calendar starts at 12:00 instead of 08:00

**Bug-ID:** #3684  
**Erstellt am:** 10.02.2026  
**Ersteller:** QA Team  
**Schweregrad:** Mittel  
**Status:** Offen  

---

## Zusammenfassung

Der Kalender in der iOS-App startet bei 12:00 Uhr statt bei 08:00 Uhr, was die Übersichtlichkeit für Termine am Vormittag beeinträchtigt.

---

## Beschreibung

Beim Öffnen der Kalenderansicht in der iOS-App wird die Tagesansicht standardmäßig bei 12:00 Uhr (Mittag) positioniert. Benutzer müssen nach oben scrollen, um Termine am Vormittag zu sehen. Dies ist nicht benutzerfreundlich, da die meisten Termine zwischen 08:00 und 18:00 Uhr stattfinden.

---

## Betroffene Plattformen

- iOS App (Version 1.3.5 Stage)
- Getestet auf iPhone 13 Pro, iOS 17.2

---

## Schritte zur Reproduktion

1. iOS-App öffnen
2. Zum Kalender navigieren
3. Tagesansicht auswählen
4. Beobachten: Kalender startet bei 12:00 Uhr

---

## Erwartetes Verhalten

Der Kalender sollte bei 08:00 Uhr starten, da dies der typische Arbeitsbeginn ist und die meisten Termine am Vormittag stattfinden.

---

## Tatsächliches Verhalten

Der Kalender startet bei 12:00 Uhr. Benutzer müssen nach oben scrollen, um Vormittagstermine zu sehen.

---

## ️ Screenshots/Videos

- Screenshot 1: Kalenderansicht startet bei 12:00 Uhr
- Screenshot 2: Nach Scrollen nach oben sind Vormittagstermine sichtbar

---

## Technische Details

**Browser/App-Version:** hosenso iOS App 1.3.5 Stage  
**Betriebssystem:** iOS 17.2  
**Gerät:** iPhone 13 Pro  

---

## Mögliche Ursache

Die Standard-Scroll-Position der Kalenderansicht ist auf 12:00 Uhr gesetzt, vermutlich als Mittelwert zwischen 00:00 und 24:00 Uhr. Eine bessere Lösung wäre, die Scroll-Position auf den Arbeitsbeginn (08:00 Uhr) oder den ersten Termin des Tages zu setzen.

---

## ️ Lösungsvorschlag

Die Standard-Scroll-Position der Kalenderansicht sollte auf 08:00 Uhr gesetzt werden. Alternativ könnte die Position auf den ersten Termin des Tages gesetzt werden, falls vorhanden.

---

## Verwandte Tickets

- Keine verwandten Tickets

---

**Erstellt von:** QA Team  
**Letzte Aktualisierung:** 10.02.2026  

