Set "DRV=%~d0"
Set "MY_LOG=%DRV%\System.sav\Logs\CEPS\FusionExtPreloadReset.log"

@echo %date% %time%   Dump info folder back to %DRV%  >> "%MY_LOG%"
if not exist "%DRV%\Program Files\HP\AppEnablingServicesExtPre\" md "%DRV%\Program Files\HP\AppEnablingServicesExtPre\"
xcopy /f /v /e /y "%DRV%\Recovery\OEM\Point_D\AppEnablingServicesExtPre\" "%DRV%\Program Files\HP\AppEnablingServicesExtPre\" >> "%MY_LOG%" 2>&1
xcopy /f /v /e /y "%DRV%\Recovery\OEM\Point_B\AppEnablingServicesExtPre\" "%DRV%\Program Files\HP\AppEnablingServicesExtPre\" >> "%MY_LOG%" 2>&1
attrib +h "C:\Program Files\HP\AppEnablingServicesExtPre" /d >> "%MY_LOG%" 2>&1

@echo %date% %time%   Finished  >> "%MY_LOG%"