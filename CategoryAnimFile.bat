@echo off
echo This script is written by HK560 and it copies delta animation files to deltaFile and others to nodeltaFile.
pause

setlocal enabledelayedexpansion

set "dir=%cd%"
set "deltaFile=%dir%\deltaFile"
set "nodeltaFile=%dir%\nodeltaFile"

if not exist "%deltaFile%" mkdir "%deltaFile%"
if not exist "%nodeltaFile%" mkdir "%nodeltaFile%"

set /a deltaCount=0
set /a nodeltaCount=0

for %%f in (*.smd) do (
    set "desc_delta="
    for /f "usebackq delims=" %%i in ("%%f") do (
        set "line=%%i"
        if "!line:desc_delta=!" neq "!line!" set "desc_delta=1"
    )
    if defined desc_delta (
        copy "%%f" "%deltaFile%\%%f"
        set /a deltaCount+=1
    ) else (
        copy "%%f" "%nodeltaFile%\%%f"
        set /a nodeltaCount+=1
    )
)

echo Copied %deltaCount% files to deltaFile.
echo Copied %nodeltaCount% files to nodeltaFile.
pause