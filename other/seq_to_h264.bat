@echo off

setlocal enabledelayedexpansion

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
if "%Choice%"=="" goto chioceloop
if %Choice% LSS 1 goto choiceloop
if %Choice% GTR %UBound% goto choiceloop

set Subfolder=!Subfolders[%Choice%]!

for %%f in (%Subfolder%\*) do (
    if not defined FirstFile set "FirstFile=%%~nxf"
    if not defined FirstFileName set "FirstFileName=%%~nf"
    if not defined FirstFileExt set "FirstFileExt=%%~xf"
    if not defined FirstFilePath set "FirstFilePath=%%f"
)
echo.

set count=1

:loopstart
set var1=!FirstFileName:~-%count%!
set /a count=%count%+1
echo %var1%| findstr /r "^[0-9][0-9]*$">nul
if errorlevel 1 (
    set endme=1
) else (
    set endme=0
)
if %endme%==1 goto loopend
goto loopstart

:loopend
set /a NumPadding=%count%-2
set /a RemoveFromName=%count%-1
set OutputName=!FirstFileName:~0,-%RemoveFromName%!
set InputName=!FirstFileName:~0,-%NumPadding%!
set StartNum=!FirstFileName:~-%NumPadding%!

echo Choose output:
echo [1] baseline
echo [2] lossless
echo [3] EXIT

:choice
set /P CH="> "
echo.

if "%CH%"=="1" goto baseline mp4 (libx264)
if "%CH%"=="2" goto lossless mp4 (libx264)
if "%CH%"=="3" goto quit

:baseline
echo baseline
ffmpeg -start_number %StartNum% -i %Subfolder%\%InputName%%%0%NumPadding%d%FirstFileExt% -c:v libx264 -preset slow -pix_fmt yuv420p -profile:v baseline -level 3.0 -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" -an %OutputName%.mp4
pause 
goto quit

:lossless
echo lossless
ffmpeg -start_number %StartNum% -i %Subfolder%\%InputName%%%0%NumPadding%d%FirstFileExt% -c:v libx264 -qp 0 -pix_fmt yuv420p -vf "scale=trunc(iw/2)*2:trunc(ih/2)*2" %OutputName%.mp4
pause
goto quit

:quit
exit