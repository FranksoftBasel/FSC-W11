rd %temp% /S/Q
md %temp% 

rd %SystemRoot%\temp /S/Q
md %SystemRoot%\temp



exit



: Del HF Spamm 
: http://www.pcreview.co.uk/forums/thread-1466693.php
: by info@franksoft.net

@echo off

@title Del HF spamm

@echo. 
@echo. Delete Hotfix Temp Files, please wait.......
@echo. 


for /f "delims=" %%a in ('dir/ad/b %systemroot%\$NtUninstall*') do (
rd /s /q "%systemroot%\%%a"
)

del "%systemroot%\kb*.log"
attrib -r -s -h "%systemroot%\*.tmp"
del "%systemroot%\*.tmp"


if exist %systemroot%\$hf_mig$ rd /s/q %systemroot%\$hf_mig$
if exist %systemRoot%\$MSI31Uninstall_KB893803v2$ rd /S/Q %systemRoot%\$MSI31Uninstall_KB893803v2$
if exist %systemRoot%\$NtServicePackUninstallIDNMitigationAPIs$ rd /S/Q %systemRoot%\$NtServicePackUninstallIDNMitigationAPIs$
if exist %systemRoot%\$NtServicePackUninstallNLSDownlevelMapping$ rd /S/Q %systemRoot%\$NtServicePackUninstallNLSDownlevelMapping$

if exist %systemRoot%\FSInfo.EXE del /F/Q %systemRoot%\FSInfo.EXE
if exist %systemRoot%\Msg.vbs del /F/Q %systemRoot%\Msg.vbs

rd "%SystemRoot%\SoftwareDistribution\Download" /S/Q
md "%SystemRoot%\SoftwareDistribution\Download"


