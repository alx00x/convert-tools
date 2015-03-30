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

    ffmpeg -i %%a -c:v rawvideo -v:q 0 -pix_fmt rgba !fileName!_lossless.mov

)

echo Files converted!

pause