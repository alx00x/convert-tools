@echo off

setlocal enabledelayedexpansion

for /f "delims=" %%a in ('dir /b /a:-d *.ogg') do (
    set "fileName=%%a"
    set "newName=!fileName: =_!"
    ren "!fileName!" "!newName!"
)

for /f "delims=" %%a in ('dir /b /a:-d *.ogg') do (

    set fileName=%%~na

    echo !fileName!

    ffmpeg -i %%a !fileName!.wav 

)

echo Files converted!

pause