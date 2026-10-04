@echo off
wmic bios get Manufacturer,serialnumber /format:list
wmic CSPRODUCT get name /format:list


pause >NUL