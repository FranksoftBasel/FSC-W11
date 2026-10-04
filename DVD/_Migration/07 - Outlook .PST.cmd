@echo off
@echo. Search .Pst on Drive C:
dir c:\*.pst /s >"%temp%\%UserName%_Outlook_.pst.txt"
dir c:\*.ost /s >"%temp%\%UserName%_Outlook_.pst.txt"

start "" notepad "%temp%\%UserName%_Outlook_.pst.txt"

exit