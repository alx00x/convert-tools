@echo off

setlocal enabledelayedexpansion

for /f "delims=" %%i in (_extensions.txt) do (
    set extensions=!extensions! %%i
)

echo Converting following extensions: !extensions!

mkdir ph

for /f "delims=" %%a in ('dir /b /a:-d *.avi *.mp4 *.ogv') do (
    set "fileName=%%a"
    set "newName=!fileName: =_!"
    ren "!fileName!" "!newName!"
)

for /f "delims=" %%a in ('dir /b /a:-d *.avi *.mp4 *.ogv') do (
    ffmpeg -i %%a -vf drawtext="fontfile=/Windows/Fonts/arialbd.ttf:text='PH': x=100: y=25: fontsize=25: fontcolor=red: box=1: boxcolor=black" -vcodec rawvideo -an ph/%%~na.avi
)

chdir ph

for %%a in ("*.avi") do ffmpeg2theora -o %%~na.ogv --videoquality 8 --noaudio %%a
 
for %%g in ("*.avi") do del %%g

echo Operation done!

pause