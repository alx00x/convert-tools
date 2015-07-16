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

    ffmpeg2theora -o !fileName!.ogv --videoquality 8 --noaudio !fileName!.mp4

    del !fileName!.mp4

)

echo Files converted!

pause