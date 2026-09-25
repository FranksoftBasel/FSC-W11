Title %~nx0

@Echo Off
@Echo. 
@Echo. Collect Installed Drivers...
@Echo.
pushd "%~dp0"

SET DEBUG=0

IF %DEBUG%==1 (
powershell -ep bypass -file "%~dp0FSC_Check_Installed_Drivers.ps1"
explorer C:\ProgramData\Franksoft\Logs
) ELSE (
powershell -ep bypass -file "%~dp0FSC_Check_Installed_Drivers.ps1"
)
