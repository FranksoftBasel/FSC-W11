@echo off
chcp 65001 >NUL
TITLE Franksoft Power Plan - %~nx0 - %TIME%

:: =============================================================================
:: Script Name : PowerPlanFS.cmd
:: Version     : 2.0
:: Date        : 25.09.2026
:: Author      : Franksoft
::
:: Changelog
:: -----------------------------------------------------------------------------
:: v2.0 - 25.09.2026
:: - Bestehendes produktives PowerPlanFS.cmd grundlegend bereinigt
:: - Power-Konfiguration vollständig in PowerPlanFS.cmd zentralisiert
:: - PowerOptions.reg wird nicht mehr benötigt
:: - Franksoft Deployment basiert weiterhin auf Ultimate Performance
:: - Franksoft Deployment Energieschema wird erstellt und aktiviert
:: - AC und DC vollständig auf "Nie ausschalten" gesetzt
:: - Monitor Timeout AC/DC = 0
:: - Disk Timeout AC/DC = 0
:: - Standby Timeout AC/DC = 0
:: - Hibernate Timeout AC/DC = 0
:: - Hybrid Sleep AC/DC = 0
:: - Relevante PowerOptions.reg Werte per powercfg übernommen
:: - Alte, nach EXIT nie ausgeführte Powercfg-Blöcke entfernt
:: - Doppelte Power-Einstellungen können aus SetupComplete.cmd entfallen
::
:: Legacy
:: -----------------------------------------------------------------------------
:: - Vorherige produktive PowerPlanFS.cmd hatte keinen Versionsheader
::
:: Purpose
:: -----------------------------------------------------------------------------
:: Erstellt und aktiviert das temporäre Energieschema "Franksoft Deployment"
:: auf Basis von Ultimate Performance und setzt alle für das FSC Deployment
:: benötigten Energieoptionen.
::
:: Das Script ist die zentrale Quelle für FSC Power Settings.
:: PowerOptions.reg darf danach aus dem Setup-Verzeichnis entfernt werden.
:: =============================================================================

setlocal

SET "PowerGUID-BASE=e9a42b02-d5df-448d-aa00-03f14749eb61"
SET "PowerGUID-NEW=bedf8352-a712-4d56-add4-e2c900fc2b62"


:: =============================================================================
:: [01] FRANKSOFT DEPLOYMENT POWER PLAN
:: Funktion:
:: - Franksoft Deployment Plan bei Bedarf erstellen
:: - Plan benennen und aktivieren
:: =============================================================================

powercfg /list | findstr /I "%PowerGUID-NEW%" >NUL 2>&1
IF ERRORLEVEL 1 (
    powercfg -duplicatescheme %PowerGUID-BASE% %PowerGUID-NEW%
)

powercfg -changename %PowerGUID-NEW% "Franksoft Deployment" "Nur während des Franksoft Client Windows-Deployment verfügbar"
powercfg -setactive %PowerGUID-NEW%


:: =============================================================================
:: [02] HIBERNATION
:: Funktion:
:: - Ruhezustand aktivieren
:: - Hibernate Timeout Einstellung sichtbar machen
:: =============================================================================

powercfg /hibernate on

REG ADD HKLM\SYSTEM\CurrentControlSet\Control\Power\PowerSettings\238C9FA8-0AAD-41ED-83F4-97BE242C8F20\9d7815a6-7ee4-497e-8888-515a05f02364 /v Attributes /t REG_DWORD /d 2 /f


:: =============================================================================
:: [03] POWEROPTIONS.REG MIGRATION
:: Funktion:
:: - Relevante Einstellungen des bisherigen Franksoft Deployment Plans
::   aus PowerOptions.reg direkt per powercfg setzen
:: =============================================================================

:: Disk - Turn off hard disk after
powercfg -setacvalueindex %PowerGUID-NEW% 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0
powercfg -setdcvalueindex %PowerGUID-NEW% 0012ee47-9041-4b5d-9b77-535fba8b1442 6738e2c4-e8a5-4a42-b16a-e040e769756e 0

:: Sleep - Sleep after
powercfg -setacvalueindex %PowerGUID-NEW% 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0
powercfg -setdcvalueindex %PowerGUID-NEW% 238c9fa8-0aad-41ed-83f4-97be242c8f20 29f6c1db-86da-48c5-9fdb-f2b67b1f44da 0

:: Sleep - Allow hybrid sleep
powercfg -setacvalueindex %PowerGUID-NEW% 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0
powercfg -setdcvalueindex %PowerGUID-NEW% 238c9fa8-0aad-41ed-83f4-97be242c8f20 94ac6d29-73ce-41a6-809f-6363ba21b47e 0

:: Power buttons and lid
powercfg -setacvalueindex %PowerGUID-NEW% 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0
powercfg -setdcvalueindex %PowerGUID-NEW% 4f971e89-eebd-4455-a8de-9e59040e7347 5ca83367-6e45-459f-a27b-476b1d01c936 0

powercfg -setacvalueindex %PowerGUID-NEW% 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3
powercfg -setdcvalueindex %PowerGUID-NEW% 4f971e89-eebd-4455-a8de-9e59040e7347 7648efa3-dd9c-4e3e-b566-50f929386280 3

powercfg -setacvalueindex %PowerGUID-NEW% 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 2
powercfg -setdcvalueindex %PowerGUID-NEW% 4f971e89-eebd-4455-a8de-9e59040e7347 96996bc0-ad50-47ec-923b-6f41874dd9eb 2

:: Processor power management
powercfg -setacvalueindex %PowerGUID-NEW% 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 4
powercfg -setdcvalueindex %PowerGUID-NEW% 54533251-82be-4824-96c1-47b60b740d00 0cc5b647-c1df-4637-891a-dec35c318583 4

powercfg -setacvalueindex %PowerGUID-NEW% 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6863 0
powercfg -setdcvalueindex %PowerGUID-NEW% 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6863 0

powercfg -setacvalueindex %PowerGUID-NEW% 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6864 0
powercfg -setdcvalueindex %PowerGUID-NEW% 54533251-82be-4824-96c1-47b60b740d00 36687f9e-e3a5-4dbf-b1dc-15eb381c6864 0

powercfg -setacvalueindex %PowerGUID-NEW% 54533251-82be-4824-96c1-47b60b740d00 97cfac41-2217-47eb-992d-618b1977c907 1000

powercfg -setacvalueindex %PowerGUID-NEW% 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334028 100
powercfg -setdcvalueindex %PowerGUID-NEW% 54533251-82be-4824-96c1-47b60b740d00 ea062031-0e34-4ff1-9b6d-eb1059334028 100

:: Display brightness
powercfg -setacvalueindex %PowerGUID-NEW% 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 100
powercfg -setdcvalueindex %PowerGUID-NEW% 7516b95f-f776-4464-8c53-06167f40cc99 aded5e82-b909-4619-9949-f5d71dac0bcb 100


:: =============================================================================
:: [04] FSC DEPLOYMENT OVERRIDES
:: Funktion:
:: - Während Deployment kein Monitor-, Disk- oder Standby-Timeout
:: - Hybrid Sleep deaktivieren
:: - Hibernate Timeout AC/DC = 0 (Nie)
:: =============================================================================

powercfg -change -monitor-timeout-ac 0
powercfg -change -monitor-timeout-dc 0

powercfg -change -disk-timeout-ac 0
powercfg -change -disk-timeout-dc 0

powercfg -change -standby-timeout-ac 0
powercfg -change -standby-timeout-dc 0

powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP STANDBYIDLE 0

powercfg /setacvalueindex SCHEME_CURRENT SUB_SLEEP HYBRIDSLEEP 0
powercfg /setdcvalueindex SCHEME_CURRENT SUB_SLEEP HYBRIDSLEEP 0

powercfg -change -hibernate-timeout-ac 0
powercfg -change -hibernate-timeout-dc 0


:: =============================================================================
:: [05] APPLY
:: Funktion:
:: - Franksoft Deployment Plan abschließend aktivieren
:: =============================================================================

powercfg -setactive %PowerGUID-NEW%

endlocal
exit /b 0
