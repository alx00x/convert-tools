@echo off

setlocal enabledelayedexpansion

for /f "delims=" %%a in ('dir /b /a:-d *.ogv') do (
    set "fileName=%%a"
    set "newName=!fileName: =_!"
    ren "!fileName!" "!newName!"
)

for /f "delims=" %%a in ('dir /b /a:-d *.ogv') do (

    set fileName=%%~na

    echo !fileName!

    ffmpeg -i %%a -c:v rawvideo -qscale 0 !fileName!_lossless.avi 

)

echo Files converted!

pause