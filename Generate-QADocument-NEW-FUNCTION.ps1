# Neue erweiterte Generator-Funktion für QTStageProtokoll

function New-QTStageProtokollDocument {
    param(
        [Parameter(Mandatory=$true)]
        [PSCustomObject]$Data
    )
    
    # Markdown schrittweise aufbauen
    $markdown = "# $($Data.Titel)`n`n"
    $markdown += "---`n`n"
    
    # Metadaten
    $markdown += "## 📊 Metadaten`n`n"
    $markdown += "**Tester:** $($Data.Tester)  `n"
    if ($Data.ServiceAccountID) {
        $markdown += "**Service Account ID:** $($Data.ServiceAccountID)  `n"
    }
    $markdown += "**Startzeit:** $($Data.Startzeit)  `n"
    $markdown += "**Endzeit:** $($Data.Endzeit)  `n"
    if ($Data.Zeitzone) {
        $markdown += "**Zeitzone:** $($Data.Zeitzone)  `n"
    }
    $markdown += "**Datum:** $($Data.Datum)  `n"
    $markdown += "**Version:** $($Data.Version)  `n"
    if ($Data.Projekt) {
        $markdown += "**Projekt:** $($Data.Projekt)  `n"
    }
    $markdown += "`n---`n`n"
    
    # Symbolvergabe
    if ($Data.Symbolvergabe) {
        $markdown += "## 🔖 Symbolvergabe`n`n"
        if ($Data.Symbolvergabe.Beschreibung) {
            $markdown += "$($Data.Symbolvergabe.Beschreibung)`n`n"
        }
        if ($Data.Symbolvergabe.Symbole) {
            foreach ($sym in $Data.Symbolvergabe.Symbole) {
                $markdown += "* $($sym.Symbol) $($sym.Bedeutung)`n"
            }
            $markdown += "`n"
        }
        if ($Data.Symbolvergabe.Hinweis) {
            $markdown += "*$($Data.Symbolvergabe.Hinweis)*`n`n"
        }
        $markdown += "---`n`n"
    }
    
    # Test-Accounts
    if ($Data.TestAccounts -and $Data.TestAccounts.Count -gt 0) {
        $markdown += "## 👤 Genutzte Test-Accounts`n`n"
        foreach ($account in $Data.TestAccounts) {
            $markdown += "* $account`n"
        }
        $markdown += "`n---`n`n"
    }
    
    # Geräte-IDs (ERWEITERT)
    if ($Data.GeräteIDs) {
        $markdown += "## 📱 IDs der getesteten Geräte`n`n"
        
        # Box IDs
        if ($Data.GeräteIDs.BoxIDs) {
            $markdown += "### 🔌 Box IDs`n`n"
            foreach ($boxId in $Data.GeräteIDs.BoxIDs) {
                $markdown += "* [$boxId] 🔌 (Box ID)`n"
            }
            $markdown += "`n"
        }
        
        # Desktop-Geräte (DETAILLIERT)
        if ($Data.GeräteIDs.DesktopGeräte) {
            $markdown += "### 🖥️ Desktop-Geräte`n`n"
            foreach ($desktop in $Data.GeräteIDs.DesktopGeräte) {
                if ($desktop.Gerätename) {
                    $markdown += "#### $($desktop.Gerätename)`n`n"
                }
                if ($desktop.Prozessor) {
                    $markdown += "* **Prozessor:** $($desktop.Prozessor)`n"
                }
                if ($desktop.RAM) {
                    $markdown += "* **RAM:** $($desktop.RAM)`n"
                }
                if ($desktop.GeräteID) {
                    $markdown += "* **Geräte-ID:** $($desktop.GeräteID)`n"
                }
                if ($desktop.ProduktID) {
                    $markdown += "* **Produkt-ID:** $($desktop.ProduktID)`n"
                }
                if ($desktop.Systemtyp) {
                    $markdown += "* **Systemtyp:** $($desktop.Systemtyp)`n"
                }
                if ($desktop.Edition) {
                    $markdown += "* **Edition:** $($desktop.Edition)`n"
                }
                if ($desktop.Version) {
                    $markdown += "* **Version:** $($desktop.Version)`n"
                }
                if ($desktop.InstalliertAm) {
                    $markdown += "* **Installiert am:** $($desktop.InstalliertAm)`n"
                }
                if ($desktop.Betriebssystembuild) {
                    $markdown += "* **Betriebssystembuild:** $($desktop.Betriebssystembuild)`n"
                }
                if ($desktop.Funktionspaket) {
                    $markdown += "* **Funktionspaket:** $($desktop.Funktionspaket)`n"
                }
                
                # Browser-Informationen
                if ($desktop.Browser) {
                    $markdown += "`n**Browser:**`n`n"
                    $markdown += "| Eigenschaft | Wert |`n"
                    $markdown += "|-------------|------|`n"
                    if ($desktop.Browser.Name) {
                        $markdown += "| Name | $($desktop.Browser.Name) |`n"
                    }
                    if ($desktop.Browser.Version) {
                        $markdown += "| Version | $($desktop.Browser.Version) |`n"
                    }
                    if ($desktop.Browser.Revision) {
                        $markdown += "| Revision | $($desktop.Browser.Revision) |`n"
                    }
                    if ($desktop.Browser.ChromiumVersion) {
                        $markdown += "| Chromium-Version | $($desktop.Browser.ChromiumVersion) |`n"
                    }
                    $markdown += "`n"
                }
                
                if ($desktop.Plattformen) {
                    $markdown += "* **Plattformen:** $($desktop.Plattformen)`n"
                }
                $markdown += "`n"
            }
        }
        
        # Mobile Geräte
        if ($Data.GeräteIDs.MobileGeräte) {
            $markdown += "### 📱 Mobile Geräte`n`n"
            foreach ($mobile in $Data.GeräteIDs.MobileGeräte) {
                $markdown += "* **$($mobile.Name)**"
                if ($mobile.OS) {
                    $markdown += " - $($mobile.OS)"
                }
                if ($mobile.Version) {
                    $markdown += " ($($mobile.Version))"
                }
                if ($mobile.Plattformen) {
                    $markdown += " $($mobile.Plattformen)"
                }
                $markdown += "`n"
            }
            $markdown += "`n"
        }
        
        $markdown += "---`n`n"
    }
    
    # Test-Kategorien (ERWEITERT)
    if ($Data.TestKategorien) {
        $markdown += "## ✅ Testvorgang`n`n"
        
        foreach ($kategorie in $Data.TestKategorien) {
            # Kategorie-Überschrift
            $markdown += "### $($kategorie.Name)`n`n"
            
            # UI-Screen (falls vorhanden)
            if ($kategorie.UIScreen) {
                $markdown += "**UI:** ``$($kategorie.UIScreen)```n`n"
            }
            
            # Beschreibung (falls vorhanden)
            if ($kategorie.Beschreibung) {
                $markdown += "$($kategorie.Beschreibung)`n`n"
            }
            
            # Direkte Tests (ohne Unterkategorien)
            if ($kategorie.Tests) {
                foreach ($test in $kategorie.Tests) {
                    # Status-Symbol
                    $statusSymbol = ""
                    switch ($test.Status) {
                        "✅" { $statusSymbol = "✅" }
                        "Bestanden" { $statusSymbol = "✅" }
                        "❌" { $statusSymbol = "❌" }
                        "Fehlgeschlagen" { $statusSymbol = "❌" }
                        "⚠️" { $statusSymbol = "⚠️" }
                        "Warnung" { $statusSymbol = "⚠️" }
                        "ℹ️" { $statusSymbol = "ℹ️" }
                        "Info" { $statusSymbol = "ℹ️" }
                        "[]" { $statusSymbol = "[]" }
                        default { $statusSymbol = "[]" }
                    }
                    
                    # Test-Zeile
                    $markdown += "- [$statusSymbol] "
                    if ($test.Plattformen) {
                        $markdown += "$($test.Plattformen) "
                    }
                    $markdown += "$($test.Testfall)"
                    
                    # Bemerkung (falls vorhanden)
                    if ($test.Bemerkung) {
                        $markdown += "`n    **$($test.Bemerkung)**"
                    }
                    
                    # Ticket-ID (falls vorhanden)
                    if ($test.TicketID) {
                        $markdown += " **siehe Ticket | $($test.TicketID)**"
                    }
                    
                    $markdown += "`n"
                }
                $markdown += "`n"
            }
            
            # Unterkategorien (falls vorhanden)
            if ($kategorie.Unterkategorien) {
                foreach ($unterkategorie in $kategorie.Unterkategorien) {
                    $markdown += "#### $($unterkategorie.Name)`n`n"
                    
                    if ($unterkategorie.Tests) {
                        foreach ($test in $unterkategorie.Tests) {
                            # Status-Symbol
                            $statusSymbol = ""
                            switch ($test.Status) {
                                "✅" { $statusSymbol = "✅" }
                                "Bestanden" { $statusSymbol = "✅" }
                                "❌" { $statusSymbol = "❌" }
                                "Fehlgeschlagen" { $statusSymbol = "❌" }
                                "⚠️" { $statusSymbol = "⚠️" }
                                "Warnung" { $statusSymbol = "⚠️" }
                                "ℹ️" { $statusSymbol = "ℹ️" }
                                "Info" { $statusSymbol = "ℹ️" }
                                "[]" { $statusSymbol = "[]" }
                                default { $statusSymbol = "[]" }
                            }
                            
                            # Test-Zeile
                            $markdown += "- [$statusSymbol] "
                            if ($test.Plattformen) {
                                $markdown += "$($test.Plattformen) "
                            }
                            $markdown += "$($test.Testfall)"
                            
                            # Bemerkung (falls vorhanden)
                            if ($test.Bemerkung) {
                                $markdown += "`n    **$($test.Bemerkung)**"
                            }
                            
                            # Ticket-ID (falls vorhanden)
                            if ($test.TicketID) {
                                $markdown += " **siehe Ticket | $($test.TicketID)**"
                            }
                            
                            $markdown += "`n"
                        }
                        $markdown += "`n"
                    }
                }
            }
        }
        
        $markdown += "---`n`n"
    }
    
    # Blockierte Tests
    if ($Data.BlockierteTests -and $Data.BlockierteTests.Count -gt 0) {
        $markdown += "## 🚫 Blockierte Tests`n`n"
        
        foreach ($blocked in $Data.BlockierteTests) {
            $markdown += "**Test:** $($blocked.Testfall)`n`n"
            $markdown += "**Grund:** $($blocked.Grund)`n`n"
            if ($blocked.Plattformen) {
                $markdown += "**Plattformen:** $($blocked.Plattformen)`n`n"
            }
            if ($blocked.TicketID) {
                $markdown += "**Ticket:** $($blocked.TicketID)`n`n"
            }
            $markdown += "---`n`n"
        }
    }
    
    # Offline-Tests
    if ($Data.OfflineTests -and $Data.OfflineTests.Szenarien) {
        $markdown += "## 🔌 Offline-Szenarien`n`n"
        
        if ($Data.OfflineTests.Beschreibung) {
            $markdown += "$($Data.OfflineTests.Beschreibung)`n`n"
        }
        
        foreach ($szenario in $Data.OfflineTests.Szenarien) {
            $markdown += "### $($szenario.Name)`n`n"
            
            if ($szenario.Tests) {
                foreach ($test in $szenario.Tests) {
                    $statusSymbol = ""
                    switch ($test.Status) {
                        "✅" { $statusSymbol = "✅" }
                        "❌" { $statusSymbol = "❌" }
                        "⚠️" { $statusSymbol = "⚠️" }
                        "ℹ️" { $statusSymbol = "ℹ️" }
                        "[]" { $statusSymbol = "[]" }
                        default { $statusSymbol = "[]" }
                    }
                    
                    $markdown += "- [$statusSymbol] "
                    if ($test.Plattformen) {
                        $markdown += "$($test.Plattformen) "
                    }
                    $markdown += "$($test.Testfall)"
                    
                    if ($test.Bemerkung) {
                        $markdown += "`n    **$($test.Bemerkung)**"
                    }
                    
                    $markdown += "`n"
                }
                $markdown += "`n"
            }
        }
        
        $markdown += "---`n`n"
    }
    
    # Zusammenfassung
    if ($Data.Zusammenfassung) {
        $markdown += "## 📊 Zusammenfassung`n`n"
        
        if ($Data.Zusammenfassung.Gesamt) {
            $markdown += "**Gesamt:** $($Data.Zusammenfassung.Gesamt) Tests durchgeführt`n`n"
        }
        
        $markdown += "**Ergebnis:**`n`n"
        
        if ($Data.Zusammenfassung.Bestanden) {
            $prozent = ""
            if ($Data.Zusammenfassung.Gesamt -and $Data.Zusammenfassung.Gesamt -gt 0) {
                $prozent = " (" + [math]::Round(($Data.Zusammenfassung.Bestanden / $Data.Zusammenfassung.Gesamt) * 100) + "%)"
            }
            $markdown += "- ✅ Bestanden: $($Data.Zusammenfassung.Bestanden)$prozent`n"
        }
        
        if ($Data.Zusammenfassung.Warnung) {
            $prozent = ""
            if ($Data.Zusammenfassung.Gesamt -and $Data.Zusammenfassung.Gesamt -gt 0) {
                $prozent = " (" + [math]::Round(($Data.Zusammenfassung.Warnung / $Data.Zusammenfassung.Gesamt) * 100) + "%)"
            }
            $markdown += "- ⚠️ Warnung: $($Data.Zusammenfassung.Warnung)$prozent`n"
        }
        
        if ($Data.Zusammenfassung.Info) {
            $prozent = ""
            if ($Data.Zusammenfassung.Gesamt -and $Data.Zusammenfassung.Gesamt -gt 0) {
                $prozent = " (" + [math]::Round(($Data.Zusammenfassung.Info / $Data.Zusammenfassung.Gesamt) * 100) + "%)"
            }
            $markdown += "- ℹ️ Info: $($Data.Zusammenfassung.Info)$prozent`n"
        }
        
        if ($Data.Zusammenfassung.Fehlgeschlagen) {
            $prozent = ""
            if ($Data.Zusammenfassung.Gesamt -and $Data.Zusammenfassung.Gesamt -gt 0) {
                $prozent = " (" + [math]::Round(($Data.Zusammenfassung.Fehlgeschlagen / $Data.Zusammenfassung.Gesamt) * 100) + "%)"
            }
            $markdown += "- ❌ Fehlgeschlagen: $($Data.Zusammenfassung.Fehlgeschlagen)$prozent`n"
        }
        
        if ($Data.Zusammenfassung.NichtDurchgeführt) {
            $prozent = ""
            if ($Data.Zusammenfassung.Gesamt -and $Data.Zusammenfassung.Gesamt -gt 0) {
                $prozent = " (" + [math]::Round(($Data.Zusammenfassung.NichtDurchgeführt / $Data.Zusammenfassung.Gesamt) * 100) + "%)"
            }
            $markdown += "- [] Nicht durchgeführt: $($Data.Zusammenfassung.NichtDurchgeführt)$prozent`n"
        }
        
        if ($Data.Zusammenfassung.Blockiert) {
            $markdown += "- 🚫 Blockiert: $($Data.Zusammenfassung.Blockiert)`n"
        }
        
        $markdown += "`n"
        
        if ($Data.Zusammenfassung.Erfolgsrate) {
            $markdown += "**Erfolgsrate:** $($Data.Zusammenfassung.Erfolgsrate)`n`n"
        }
        
        $markdown += "---`n`n"
    }
    
    # Empfehlungen
    if ($Data.Empfehlungen -and $Data.Empfehlungen.Count -gt 0) {
        $markdown += "## 💡 Empfehlungen`n`n"
        foreach ($empfehlung in $Data.Empfehlungen) {
            $markdown += "* $empfehlung`n"
        }
        $markdown += "`n---`n`n"
    }
    
    # Bemerkungen
    if ($Data.Bemerkungen) {
        $markdown += "## 📝 Bemerkungen`n`n"
        $markdown += "$($Data.Bemerkungen)`n`n"
        $markdown += "---`n`n"
    }
    
    # Footer
    $markdown += "`n**Erstellt von:** $($Data.Tester)  `n"
    $markdown += "**Letzte Aktualisierung:** $($Data.Datum)  `n"
    
    return $markdown
}
