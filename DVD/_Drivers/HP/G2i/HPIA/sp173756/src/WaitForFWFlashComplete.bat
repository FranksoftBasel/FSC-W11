@echo off
setlocal EnableDelayedExpansion

rem change codepage to english
chcp 437 > nul

set "registryKey=HKLM\Software\wow6432node\Intel\FwFlashService"
set "valueName=FlashStatus"

rem set "logfile=%1"
set "outputFile="

if "%~1"=="" (
	set "outputFile=.\log\MonitorLog.log" 
)else (
	set "outputFile=%~1" 
)

:: 檢查 log 資料夾是否存在
if not exist ".\log" (
    mkdir ".\log"
)

set "returnValue=999"
set "Error_RegNotFound=998"
set "Error_TimeOut=997"
set "Error_UnexceptedStatus=996"

echo ========================== Installing WNC T700 driver by WaitForFWFlashComplete.bat start ========================== > %outputFile%

rem DLMRH01-7887 [Windows] The Installer sometimes ends early while waiting for the FW flash.
rem set /a "currentSeconds=currentSeconds+!currentTime:~3,2!*60+!currentTime:~0,2!*3600"

set "startTime=!TIME!"
set "startSeconds=!startTime:~6,2!"
set "startMins=!startTime:~3,2!"
set "startHours=!startTime:~0,2!"

set /a "startSeconds=!startSeconds:*0=!" 2>nul
set /a "startMins=!startMins:*0=!" 2>nul
set /a "startHours=!startHours:*0=!" 2>nul

echo start Time:!startHours! , !startMins! , !startSeconds!
set /a "startSeconds= startSeconds+startMins*60+ startHours*3600"

rem set "InitialTimeOut=10"
set "InitialTimeOut=50"
rem set "PreProcessTimeOut=40"
set "ProcessTimeOut=150"
set "TimeOutSeconds=!InitialTimeOut!"

set "FWFlashFlag=0"
set "FlashStatus_initial=0x0"
set "FlashStatus_initialStart=0x1"
set "FlashStatus_initialProcess=0x2"
set "FlashStatus_FWFlashProcess=0x3"
set "FlashStatus_EndingProcess=0x5"
set "FlashStatus_FWFlashComplete=0x6"

rem DLMRH01-7817 [Windows][War room]Size of MonitorFwFlash file will keep around 150MB after FW upgrade/downgrade
rem for /f "tokens=2 delims==" %%a in ('wmic os get localdatetime /value') do set "datetime=%%a"
set "datetime=00000000000000" 
where wmic >nul 2>&1
if %errorlevel% neq 0 (
    echo WMIC is not available. Use PowerShell to get localdatetime...
    for /f "delims=" %%A in ('powershell -Command "Get-Date -Format \"yyyyMMddHHmmss\""') do set datetime=%%A
) else (
    echo WMIC is available. Use WMIC to get localdatetime...
    for /f "tokens=2 delims==" %%A in ('wmic os get localdatetime /value') do set datetime=%%A    
)

set "year=!datetime:~0,4!"
set "month=!datetime:~4,2!"
set "day=!datetime:~6,2!"
set "hour=!datetime:~8,2!"
set "minute=!datetime:~10,2!"
set "second=!datetime:~12,2!"

set "formatted_datetime=!year!!month!!day!_!hour!!minute!!second!"
set "formatted_date=!year!/!month!/!day!"
rem set "outputFile=MonitorFwFlash_!formatted_datetime!.txt"

set "ProcessAccumulatedTime=0"
set "RecordInitialProcessFlag=1"
set "RecordFwFlashProcessFlag=1"
set "RecordEndingProcessFlag=1"
set "registry_value=0"

rem query string from registry
rem for /f "tokens=2*" %%a in ('C:\Windows\System32\reg.exe query "HKLM\SOFTWARE\WNC,Inc.\MTK_T700_Driver" /v "ExecFWFlashMode"') do (
rem     echo %date:~3% %time% query string from registry ExecFWFlashMode: %%b >> "%outputFile%"
rem     set "registry_value=%%b"
rem )

rem if !registry_value! equ 2 (
rem 	echo ExecFWFlashMode is !registry_value!, bypass monitor FwFlashService >> "%outputFile%"
rem     goto :endMonitoring
rem )

set "value=!FlashStatus_initial!"
:monitorRegistry
C:\Windows\System32\reg.exe query "%registryKey%" /v "%valueName%" >nul 2>&1
REM echo !formatted_date! errorlevel = %errorlevel% 
if %errorlevel% equ 0 (
    for /f "tokens=3" %%a in ('C:\Windows\System32\reg.exe query "%registryKey%" /v "%valueName%" 2^>nul ^| findstr /i "%valueName%"') do (
        set "value=%%a"
		echo !formatted_date! %time% !value!
		echo !formatted_date! %time% !value! >> "%outputFile%"
				
		if !FWFlashFlag! equ 0 (
			rem if !value! equ !FlashStatus_initial! (			
			if !value! equ !FlashStatus_initialStart! (			
              set "FWFlashFlag=1"			  			 
			  set "TimeOutSeconds=!ProcessTimeOut!"      
			  echo !formatted_date! %time% wait FW Flash initial flag time:!ProcessAccumulatedTime! >> "%outputFile%"  
			  set "ProcessAccumulatedTime=0"   			  
			) else if !value! equ !FlashStatus_initialProcess! (			
              set "FWFlashFlag=1"			  			  
			  set "TimeOutSeconds=!ProcessTimeOut!"      
			  echo !formatted_date! %time% wait FW Flash initial flag time:!ProcessAccumulatedTime! >> "%outputFile%"  
			  set "ProcessAccumulatedTime=0"   			  
			)	
			
			CALL :checkTimeout    
			exit /b
		) else (
	      
		  if !value! equ !FlashStatus_initial! (					  
              echo !formatted_date! %time% wait for initial start process >> "%outputFile%"  
		  ) else if !value! equ !FlashStatus_initialStart! (					  
              echo !formatted_date! %time% initial start process >> "%outputFile%"  			  
		  ) else if !value! equ !FlashStatus_initialProcess! (		
			  rem set "TimeOutSeconds=!ProcessTimeOut!"      
              echo !formatted_date! %time% initial Process >> "%outputFile%"             
          ) else if !value! equ !FlashStatus_FWFlashProcess! (			
			  if !RecordInitialProcessFlag! equ 1 (
				 echo !formatted_date! %time% initial Process time:!ProcessAccumulatedTime! >> "%outputFile%"           
				 set "ProcessAccumulatedTime=0"
				 set "RecordInitialProcessFlag=0"
			  )
              echo !formatted_date! %time% FW Flash Process >> "%outputFile%"           
          ) else if !value! equ !FlashStatus_EndingProcess! (
			  if !RecordFwFlashProcessFlag! equ 1 (
			     echo !formatted_date! %time% FW Flash Process time:!ProcessAccumulatedTime! >> "%outputFile%"           
			     set "ProcessAccumulatedTime=0"		  
				 set "RecordFwFlashProcessFlag=0"
			  )
              echo !formatted_date! %time% Ending Process >> "%outputFile%"              
          ) else if !value! equ !FlashStatus_FWFlashComplete! (			
		      if !RecordEndingProcessFlag! equ 1 (			  
				 echo !formatted_date! %time% Ending Process time:!ProcessAccumulatedTime! >> "%outputFile%"           			  
				 set "RecordEndingProcessFlag=0"
			  ) 
              echo !formatted_date! %time% FW Flash Complete , sleep 3s to wait for program close >> "%outputFile%"
			  timeout /t 3 >nul 
			  rem set "returnValue=0"
              goto :endMonitoring
           ) else (					      
              echo !formatted_date! %time% Got unexpected flash status : !value! , stop the monitoring >> "%outputFile%"	
			  set "returnValue=%Error_UnexceptedStatus%"
              goto :endMonitoring
           )
		  
		  CALL :checkTimeout
          exit /b
		)
    )
) else (
    echo Registry key or value not found. >> "%outputFile%"
	set "returnValue=!Error_RegNotFound!"
    goto :endMonitoring
)

:checkTimeout
set "currentTime=!TIME!"
set "currentSeconds=!currentTime:~6,2!"

rem DLMRH01-7887 [Windows] The Installer sometimes ends early while waiting for the FW flash.
rem set /a "currentSeconds=currentSeconds+!currentTime:~3,2!*60+!currentTime:~0,2!*3600"
set "currentMins=!currentTime:~3,2!"
set "currentHours=!currentTime:~0,2!"

set /a "currentSeconds=!currentSeconds:*0=!" 2>nul
set /a "currentMins=!currentMins:*0=!" 2>nul
set /a "currentHours=!currentHours:*0=!" 2>nul

echo Current Time:!currentHours! , !currentMins! , !currentSeconds!
set /a "currentSeconds= currentSeconds+currentMins*60+ currentHours*3600"
echo currentSeconds add hour and minute:!currentSeconds!
set /a "elapsedSeconds=currentSeconds-startSeconds"

rem fix DLMRH01-5716 [Windows] The Windows SW installation process will get stuck if it runs overnight.
if !elapsedSeconds! lss 0 (
	set /a "elapsedSeconds=86400+elapsedSeconds"
)

echo !formatted_date! elapsedSeconds = !elapsedSeconds!
if !elapsedSeconds! geq !TimeOutSeconds! (
    echo Timeout reached. Exiting monitoring. >> "%outputFile%"
	set "returnValue=%Error_TimeOut%"
    goto :endMonitoring
)
set /a "ProcessAccumulatedTime+=1"
timeout /t 1 >nul 
goto :monitorRegistry

:endMonitoring
echo Monitoring stopped.
if !value! equ !FlashStatus_FWFlashComplete! (			
set "returnValue=0"
)

echo returnValue : %returnValue% >> %outputFile%
echo ========================== Installing WNC T700 driver by WaitForFWFlashComplete.bat End ========================== >> %outputFile%
cmd /c exit /b %returnValue%

rem exit /b %returnValue% 
rem exit
