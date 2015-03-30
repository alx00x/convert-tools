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

echo Choose an output:
echo [1] .png
echo [2] .tif
echo [3] .jpg
echo [4] exit

:choice
set /P CH="> "
echo.

if "%CH%"=="1" goto pngseq
if "%CH%"=="2" goto tifseq
if "%CH%"=="3" goto jpgseq
if "%CH%"=="4" goto quit

:pngseq
echo png
for /f "delims=" %%a in ('dir /b /a:-d !extensions!') do (
    mkdir %%~na
    ffmpeg -i %%a -c:v png -pix_fmt rgba %%~na/%%~na_%%06d.png
)
pause
goto quit

:tifseq
echo tif
for /f "delims=" %%a in ('dir /b /a:-d !extensions!') do (
    mkdir %%~na
    ffmpeg -i %%a -c:v tiff -pix_fmt rgba %%~na/%%~na_%%06d.tif
)
pause
goto quit

:jpgseq
echo jpg
for /f "delims=" %%a in ('dir /b /a:-d !extensions!') do (
    mkdir %%~na
    ffmpeg -i %%a -c:v mjpeg -q:v 0 -pix_fmt yuvj444p %%~na/%%~na_%%06d.jpg
)
pause
goto quit

:quit
exit