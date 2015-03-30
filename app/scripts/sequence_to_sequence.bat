@echo off

setlocal enabledelayedexpansion

for /d %%a in (*) do (
    set "folderName=%%a"
    set "newName=!folderName: =_!"
    ren "!folderName!" "!newName!"
)

set Index=1
for /d %%D in (*) do (
    set "Subfolders[!Index!]=%%D"
    set /a Index+=1
)
set /a UBound=Index-1

echo.
echo Choose a folder:
for /l %%i in (1,1,%UBound%) do echo [%%i] !Subfolders[%%i]!
:choiceloop
set /p Choice="> "
if "%Choice%"=="" goto choiceloop
if %Choice% LSS 1 goto choiceloop
if %Choice% GTR %UBound% goto choiceloop

set Subfolder=!Subfolders[%Choice%]!

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
mkdir %Subfolder%_png
for %%i in (%Subfolder%/*.*) do (
    ffmpeg -i %Subfolder%/%%i -c:v png -pix_fmt rgba %Subfolder%_png/%%i.png
)
pause
goto quit

:tifseq
echo tif
mkdir %Subfolder%_tif
for %%i in (%Subfolder%/*.*) do (
    ffmpeg -i %Subfolder%/%%i -c:v tiff -pix_fmt rgba %Subfolder%_tif/%%i.tif
)
pause
goto quit

:jpgseq
echo jpg
mkdir %Subfolder%_jpg
for %%i in (%Subfolder%/*.*) do (
    ffmpeg -i %Subfolder%/%%i -c:v mjpeg -q:v 0 -pix_fmt yuvj444p %Subfolder%_jpg/%%i.jpg
)
pause
goto quit

:quit
exit