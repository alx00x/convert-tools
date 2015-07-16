@echo off

setlocal enabledelayedexpansion

for /f "delims=" %%i in (_extensions.txt) do (
    set extensions=!extensions! %%i
)

for /f "delims=" %%a in ('dir /b /a:-d !extensions!') do (
    set "fileName=%%a"
    set "newName=!fileName: =_!"
    ren "!fileName!" "!newName!"
)

for %%a in (*.ogg *.wav) do (
    set "fileName=%%a"
    set "newName=!fileName: =_!"
    ren "!fileName!" "!newName!"
)

set Index=1
for /f "delims=" %%i in ('dir /b /a:-d !extensions!') do (
    set "videofile[!Index!]=%%i"
    set /a Index+=1
)
set /a UBound=Index-1

echo.
echo Choose a video file:
for /l %%i in (1,1,%UBound%) do echo [%%i] !videofile[%%i]!
:choiceloopV
set /p ChoiceV="> "
if "%ChoiceV%"=="" goto choiceloopV
if %ChoiceV% LSS 1 goto choiceloopV
if %ChoiceV% GTR %UBound% goto choiceloopV

set chosenvideofile=!videofile[%ChoiceV%]!

set Index=1
for %%f in (*.ogg *.wav) do (
    set "audiofile[!Index!]=%%f"
    set /a Index+=1
)
set /a UBound=Index-1

echo.
echo Choose a audio file:
for /l %%f in (1,1,%UBound%) do echo [%%f] !audiofile[%%f]!
:choiceloopA
set /p ChoiceA="> "
if "%ChoiceA%"=="" goto choiceloopA
if %ChoiceA% LSS 1 goto choiceloopA
if %ChoiceA% GTR %UBound% goto choiceloopA

set chosenaudiofile=!audiofile[%ChoiceA%]!
echo.
echo Chosen video file: %chosenvideofile%
echo Chosen video file: %chosenaudiofile%
echo.

echo Converting and resizing, please wait...

set outputName=%chosenvideofile:~0,-4%
set width=640
set height=640
ffmpeg -y -i %chosenvideofile% -c:v libx264 -preset slow -pix_fmt yuv420p -b:v 1200k -minrate 1200k -maxrate 1200k -bufsize 1200k -pass 1 -an -f mp4 NUL && ffmpeg -i %chosenvideofile% -i %chosenaudiofile% -c:v libx264 -vf "scale=(iw*sar)*min(640/(iw*sar)\,640/ih):ih*min(640/(iw*sar)\,640/ih), pad=640:640:(640-iw*min(640/iw\,640/ih))/2:(640-ih*min(640/iw\,640/ih))/2" -preset slow -pix_fmt yuv420p -b:v 1200k -minrate 1200k -maxrate 1200k -bufsize 1200k -pass 2 -c:a aac -strict -2 -b:a 128k !outputName!.mp4
    
del ffmpeg2pass-0.log
del ffmpeg2pass-0.log.mbtree

pause