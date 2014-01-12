@echo off

setlocal enabledelayedexpansion

for /f "delims=" %%i in (_extensions.txt) do (
    set extensions=!extensions! %%i
)

echo Converting following extensions: !extensions!

for /f "delims=" %%a in ('dir /b /a:-d !extensions!') do (
    set "fileName=%%a"
    set "newName=!fileName: =_!"
    ren "!fileName!" "!newName!"
)

for /f "delims=" %%a in ('dir /b /a:-d !extensions!') do (

    set fileName=%%~na
    echo !fileName!|findstr /r /c:"_raw" >nul 

    if not errorlevel 1 (
        set fileName=!fileName:_raw=!
    ) else (
        set fileName=%%~na
    )

    echo !fileName!

    ffmpeg -y -i %%a -c:v libx264 -preset medium -pix_fmt yuv420p -b:v 555k -pass 1 -an -f mp4 NUL && ffmpeg -i %%a -c:v libx264 -preset medium -pix_fmt yuv420p -b:v 555k -pass 2 -c:a aac -strict -2 -b:a 128k !fileName!"_h264".mp4
    
    del ffmpeg2pass-0.log
    del ffmpeg2pass-0.log.mbtree
    
)

echo Files converted!

pause