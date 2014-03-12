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

mkdir new

echo.
echo Flip:
echo [1] vertically
echo [2] horizontally
echo [3] exit

:choice
set /P CH="> "
echo.

if "%CH%"=="1" goto vertically
if "%CH%"=="2" goto horizontally
if "%CH%"=="3" goto quit

:vertically
for /f "delims=" %%a in ('dir /b /a:-d !extensions!') do (
    ffmpeg -i %%a -c:v libx264 -preset veryslow -crf 0 -pix_fmt yuv420p -vf 'vflip' -c:a copy new/%%~na.avi
)
pause
goto quit

:horizontally
for /f "delims=" %%a in ('dir /b /a:-d !extensions!') do (
    ffmpeg -i %%a -c:v libx264 -preset veryslow -crf 0 -pix_fmt yuv420p -vf 'hflip' -c:a copy new/%%~na.mp4
)
pause
goto quit

:quit
exit