SET Exe2D=Evernote

powershell.exe -command "& Invoke-WebRequest https://ninite.com/%Exe2D%/ninite.exe" -OutFile %Exe2D%-Ninite.exe

start "" "%Exe2D%-Ninite.exe"