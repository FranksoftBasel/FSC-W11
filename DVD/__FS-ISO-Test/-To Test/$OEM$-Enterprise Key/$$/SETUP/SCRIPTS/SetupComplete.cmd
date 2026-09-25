@Echo off
@rem cd /d "%~dp0"

@rem cd /d "%windir%\Setup\Scripts"

call %~dp0KMS_VL_ALL_AIO.cmd /s /a /u /o

call "%~dp0HWID_Activation_AIO.cmd" /u

