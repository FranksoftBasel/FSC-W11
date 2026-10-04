@Title Franksoft Computer Report
@Color 1F
@Echo off

@echo. 
@echo. Bitte warten, es wird ein System Treiber Report generiert.
@echo. 


cd %cd%

aida64.exe /R .\Reports\Report /CUSTOM "%~dp0DriversOS.rpf" /HTML /NOICONS /SHOWPCANCEL /SILENT

Replace.exe /M:L /T:Reports\Report.htm /F:Berichtsart /R:

Replace.exe /M:L /T:Reports\Report.htm /F:Benchmark Modul /R:

Replace.exe /M:L /T:Reports\Report.htm /F:AIDA64 v3.20.2600/de /R:



Replace.exe /M:T /T:Reports\Report.htm /F:Homepage /R:Autor

Replace.exe /M:T /T:Reports\Report.htm /F:http://www.aida64.de /R:http://www.Franksoft.Net

Replace.exe /M:T /T:Reports\Report.htm /F:AIDA64 Business Edition /R: Franksoft Treiber Report

Replace.exe /M:T /T:Reports\Report.htm /F:The names of actual companies and products mentioned herein may be the trademarks of their respective owners. /R: 


ren Reports\Report.htm "OS Treiber von %ComputerName%, %Date%.htm

start "" explorer .\Reports

DEL Reports\*.OLD

exit