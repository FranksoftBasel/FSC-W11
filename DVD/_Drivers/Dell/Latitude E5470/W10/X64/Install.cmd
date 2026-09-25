@echo off
color c0
Title Franksoft 2014 Install Drivers


@CD /D %0\..

MODE CON: COLS=60 LINES=20
@echo. 
@echo. Install Drivers, please wait....
@echo. 


DPInst64.exe

Shutdown -r -t 10