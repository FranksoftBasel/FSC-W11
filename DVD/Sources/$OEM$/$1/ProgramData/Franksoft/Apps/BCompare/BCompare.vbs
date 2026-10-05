On error Resume Next

dim wsh

set wsh = createobject("WScript.Shell")
wsh.run("REG.EXE DELETE ""HKEY_CURRENT_USER\Software\Scooter Software\Beyond Compare 5"" /v CacheID /f"), 0, True

set wsh = nothing
