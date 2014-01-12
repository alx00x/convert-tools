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

    ffmpeg -i %%a -c:v libxvid -q:v 0 !fileName!"_xvid".avi

)

echo Files converted!

pause