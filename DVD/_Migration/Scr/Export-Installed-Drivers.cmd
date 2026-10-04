@echo off

Set ExpDir=C:\Temp\Drivers_%date%
MD %ExpDir%

@echo. Export all Installed Drivers to 

pnputil  /export-driver * %ExpDir%


Explorer %ExpDir%