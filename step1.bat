@echo off
setlocal enabledelayedexpansion

:: === Base folder where numbered builds are located ===
set "BUILD_BASE=E:\Jenkins\QA\Publish\ACMO"

:: === Variables to track latest folder ===
set "LATEST_BUILD="
set "LATEST_TIMESTAMP=0"

:: === Loop through all numeric folders ===
for /f "delims=" %%F in ('dir /b /ad "%BUILD_BASE%" ^| findstr "^[0-9][0-9]*$"') do (
    set "FOLDER=%%F"

    :: Get full path
    set "FOLDER_PATH=%BUILD_BASE%\%%F"

    :: Get folder timestamp using 'for' and 'dir'
    for /f "tokens=1-4*" %%a in ('dir /tc /-c /od /b /a:d "%FOLDER_PATH%" 2^>nul') do (
        :: 'dir /tc' gives creation date/time of contents, but we want folder itself.
        :: So we use 'dir /tc' on the parent and parse it.

        :: Now get the timestamp of folder itself
        for /f "tokens=1,2 delims= " %%x in ('dir /tc /a:d "%FOLDER_PATH%\.." ^| findstr /b "%%F"') do (
            set "TS=%%x %%y"
        )
    )

    :: Convert timestamp to sortable form (YYYYMMDDHHMMSS) for comparison
    for /f "tokens=1-3 delims=/- " %%x in ("!TS!") do (
        set "YYYY=%%z"
        set "MM=%%x"
        set "DD=%%y"
    )
    for /f "tokens=1-2 delims=: " %%x in ("!TS!") do (
        set "HH=%%x"
        set "MI=%%y"
    )

    set "SORT_TS=!YYYY!!MM!!DD!!HH!!MI!"

    :: Compare folder number and timestamp
    set /a "NUM=FOLDER" >nul 2>&1
    if defined LATEST_BUILD (
        set /a "CUR=NUM"
        set /a "PREV=LATEST_BUILD"
        if !CUR! GEQ !PREV! (
            if !SORT_TS! GTR !LATEST_TIMESTAMP! (
                set "LATEST_BUILD=%%F"
                set "LATEST_TIMESTAMP=!SORT_TS!"
            )
        )
    ) else (
        set "LATEST_BUILD=%%F"
        set "LATEST_TIMESTAMP=!SORT_TS!"
    )
)

:: === Abort if no valid folder found ===
if not defined LATEST_BUILD (
    echo No valid build folders found in %BUILD_BASE%
    pause
    exit /b
)

echo Latest valid build detected: %LATEST_BUILD% at timestamp %LATEST_TIMESTAMP%

:: === Set paths ===
set "SOURCE=%BUILD_BASE%\%LATEST_BUILD%\ARCON Web Components\ARCOSClientManagerOnline"
set "DEST_ROOT=E:\DUMMY_Diff.24\new"
set "DEST=%DEST_ROOT%\ARCOSClientManagerOnline"

:: === Delete existing destination folder if it exists ===
if exist "%DEST%" (
    echo Deleting existing folder: "%DEST%"
    rd /S /Q "%DEST%"
)

:: === Ensure root destination exists ===
if not exist "%DEST_ROOT%" (
    mkdir "%DEST_ROOT%"
)

:: === Copy folder ===
echo Copying "%SOURCE%" to "%DEST%"...
xcopy "%SOURCE%\*" "%DEST%\" /E /I /Y

echo.
echo === Copy Complete ===
pause
