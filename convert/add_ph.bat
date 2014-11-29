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
    ffmpeg -i %%a -vf drawtext="fontfile=/Windows/Fonts/arialbd.ttf:text='PH': x=w/10: y=h/20: fontsize=25: fontcolor=red: box=1: boxcolor=black" -vcodec rawvideo -an ph/%%~na.avi
)

chdir ph

for %%a in ("*.avi") do ..\ffmpeg2theora -o %%~na.ogv --videoquality 8 --noaudio %%a

for %%a in ("*.avi") do (
    ..\ffmpeg -y -i %%a -c:v libx264 -preset slow -pix_fmt yuv420p -b:v 1200k -minrate 1200k -maxrate 1200k -bufsize 1200k -pass 1 -an -f mp4 NUL && ffmpeg -i %%a -c:v libx264 -preset slow -pix_fmt yuv420p -b:v 1200k -minrate 1200k -maxrate 1200k -bufsize 1200k -pass 2 -c:a aac -strict -2 -b:a 128k %%~na.mp4
    del ffmpeg2pass-0.log
    del ffmpeg2pass-0.log.mbtree
)
 
for %%g in ("*.avi") do del %%g

echo Operation done!

pause