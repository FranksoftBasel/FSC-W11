@Title Franksoft Computer Report
@Color 1F
@Echo off

@echo. 
@echo. Bitte warten, es wird ein Computer Report generiert.
@echo. 

@CD /D %0\..

aida64.exe /R .\Reports\Report /CUSTOM "%~dp0Franksoft2.rpf" /HTML /NOICONS /SHOWPCANCEL /SILENT


Replace.exe /M:L /T:Reports\Report.htm /F:Berichtsart /R:
Replace.exe /M:L /T:Reports\Report.htm /F:Benchmark Modul /R:
Replace.exe /M:L /T:Reports\Report.htm /F:http://www.aida64.de /R:
Replace.exe /M:L /T:Reports\Report.htm /F:AIDA64 v3.20.2600/de /R:

Replace.exe /M:T /T:Reports\Report.htm /F:Homepage /R:Autor
Replace.exe /M:T /T:Reports\Report.htm /F:http://www.aida64.de /R:www.Franksoft.Net
Replace.exe /M:T /T:Reports\Report.htm /F:AIDA64 Business Edition /R: Franksoft System Report
Replace.exe /M:T /T:Reports\Report.htm /F:The names of actual companies and products mentioned herein may be the trademarks of their respective owners. /R: 


Ren Reports\Report.htm "Franksoft System Report von %UserName% auf %ComputerName%, %Date%.htm

:start "" iexplore %~dp0Reports\Report.htm

DEL Reports\*.OLD

start "" explorer .\Reports

exit

