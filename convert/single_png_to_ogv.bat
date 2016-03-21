@echo off

setlocal enabledelayedexpansion

for /f "delims=" %%a in ('dir /b /a:-d *.png') do (
    set "fileName=%%a"
    set "newName=!fileName: =_!"
    ren "!fileName!" "!newName!"
)

for /f "delims=" %%a in ('dir /b /a:-d *.png') do (

    set fileName=%%~na

    echo !fileName!

    ffmpeg -loop 1 -i %%a -c:v libx264 -t 10 -pix_fmt yuv420p -vf scale=1024:512 !fileName!.mp4

    ffmpeg -y -i !fileName!.mp4 -c:v libtheora -qscale:v 8 -an !fileName!.ogv

    del !fileName!.mp4

)

echo Files converted!

pause
