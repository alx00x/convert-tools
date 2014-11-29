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

    ffmpeg -y -i %%a -c:v libx264 -preset slow -pix_fmt yuv420p -b:v 1200k -minrate 1200k -maxrate 1200k -bufsize 1200k -pass 1 -an -f mp4 NUL && ffmpeg -i %%a -c:v libx264 -preset slow -pix_fmt yuv420p -b:v 1200k -minrate 1200k -maxrate 1200k -bufsize 1200k -pass 2 -c:a aac -strict -2 -b:a 128k !fileName!"_h264".mp4
    
    del ffmpeg2pass-0.log
    del ffmpeg2pass-0.log.mbtree

)

echo Files converted!

pause