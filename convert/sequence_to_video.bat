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

for %%f in (%Subfolder%\*) do (
    if not defined FirstFile set "FirstFile=%%~nxf"
    if not defined FirstFileName set "FirstFileName=%%~nf"
    if not defined FirstFileExt set "FirstFileExt=%%~xf"
    if not defined FirstFilePath set "FirstFilePath=%%f"
)
echo.

echo Frames per second:
set /p fps="> "

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

echo Choose an output:
echo [1] .mov apple png ------- (keeps alpha)
echo [2] .mov rawvideo bmp ---- (keeps alpha)
echo [3] .mp4 baseline h264 --- (doesn't keep alpha)
echo [4] exit

:choice
set /P CH="> "
echo.

if "%CH%"=="1" goto applepng
if "%CH%"=="2" goto rawvideo
if "%CH%"=="3" goto baselineh264
if "%CH%"=="4" goto quit

:applepng
echo apple png
ffmpeg -start_number %StartNum% -i %Subfolder%\%InputName%%%0%NumPadding%d%FirstFileExt% -r %fps% -c:v png %OutputName%.mov
pause
goto quit

:rawvideo
echo rawvideo
ffmpeg -start_number %StartNum% -i %Subfolder%\%InputName%%%0%NumPadding%d%FirstFileExt% -r %fps% -c:v rawvideo -v:q 0 -pix_fmt rgba %OutputName%.mov
pause
goto quit

:baselineh264
echo baseline h264
ffmpeg -start_number %StartNum% -i %Subfolder%\%InputName%%%0%NumPadding%d%FirstFileExt% -r %fps% -c:v libx264 -preset slow -pix_fmt yuv420p -profile:v baseline -level 3.0 %OutputName%.mp4
pause
goto quit

:quit
exit