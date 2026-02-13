@echo off
chcp 65001 >nul
color 0A
title QA-Dokumenten-Generator - Schnellstart

echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║     QA-Dokumenten-Generator - Schnellstart               ║
echo ║     Script-basierte Automation für QA-Dokumentation      ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.

:MENU
echo.
echo Wählen Sie eine Option:
echo.
echo [1] Bug-Ticket generieren (Beispiel)
echo [2] Test-Protokoll generieren (Beispiel)
echo [3] Eigenes Bug-Ticket generieren
echo [4] Eigenes Test-Protokoll generieren
echo [5] Hilfe anzeigen
echo [6] Beenden
echo.

set /p choice="Ihre Wahl (1-6): "

if "%choice%"=="1" goto BUG_BEISPIEL
if "%choice%"=="2" goto TEST_BEISPIEL
if "%choice%"=="3" goto BUG_EIGEN
if "%choice%"=="4" goto TEST_EIGEN
if "%choice%"=="5" goto HILFE
if "%choice%"=="6" goto END

echo Ungültige Eingabe! Bitte wählen Sie 1-6.
goto MENU

:BUG_BEISPIEL
echo.
echo Generiere Bug-Ticket (Beispiel)...
echo.
powershell.exe -ExecutionPolicy Bypass -File "Generate-QADocument.ps1" -ConfigFile "beispiel_bug_ticket.json" -Template "BugTicket"
echo.
echo Fertig!
pause
goto MENU

:TEST_BEISPIEL
echo.
echo Generiere Test-Protokoll (Beispiel)...
echo.
powershell.exe -ExecutionPolicy Bypass -File "Generate-QADocument.ps1" -ConfigFile "beispiel_test_protokoll.json" -Template "TestProtokoll"
echo.
echo Fertig!
pause
goto MENU

:BUG_EIGEN
echo.
set /p configfile="JSON-Datei (z.B. mein_bug.json): "
echo.
echo Generiere Bug-Ticket aus %configfile%...
echo.
powershell.exe -ExecutionPolicy Bypass -File "Generate-QADocument.ps1" -ConfigFile "%configfile%" -Template "BugTicket"
echo.
echo Fertig!
pause
goto MENU

:TEST_EIGEN
echo.
set /p configfile="JSON-Datei (z.B. mein_test.json): "
echo.
echo Generiere Test-Protokoll aus %configfile%...
echo.
powershell.exe -ExecutionPolicy Bypass -File "Generate-QADocument.ps1" -ConfigFile "%configfile%" -Template "TestProtokoll"
echo.
echo Fertig!
pause
goto MENU

:HILFE
echo.
echo ╔═══════════════════════════════════════════════════════════╗
echo ║                         HILFE                             ║
echo ╚═══════════════════════════════════════════════════════════╝
echo.
echo So verwenden Sie den Generator:
echo.
echo 1. Kopieren Sie template_bug_ticket.json
echo 2. Benennen Sie die Kopie um (z.B. bug_3690.json)
echo 3. Öffnen Sie die Datei mit Notepad oder VS Code
echo 4. Füllen Sie Ihre Daten ein
echo 5. Wählen Sie Option 3 oder 4 in diesem Menü
echo.
echo Beispiel-Dateien:
echo   - beispiel_bug_ticket.json
echo   - beispiel_test_protokoll.json
echo.
echo Vollständige Anleitung:
echo   - Öffnen Sie ANLEITUNG_Windows11.md
echo.
pause
goto MENU

:END
echo.
echo Auf Wiedersehen!
echo.
timeout /t 2 >nul
exit
